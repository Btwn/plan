SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE [dbo].[spGastoVerificar]
 @ID INT
,@Accion CHAR(20)
,@Empresa CHAR(5)
,@Usuario CHAR(10)
,@Autorizacion CHAR(10)
,@Modulo CHAR(5)
,@Mov CHAR(20)
,@MovID VARCHAR(20)
,@MovTipo CHAR(20)
,@MovMoneda CHAR(10)
,@MovTipoCambio FLOAT
,@FechaEmision DATETIME
,@Estatus CHAR(15)
,@Acreedor CHAR(10)
,@Importe MONEY
,@RetencionTotal MONEY
,@ImpuestoTotal MONEY
,@Saldo MONEY
,@Condicion VARCHAR(50)
,@Vencimiento DATETIME
,@MovAplica CHAR(20)
,@MovAplicaID VARCHAR(20)
,@Multiple BIT
,@Conexion BIT
,@SincroFinal BIT
,@Sucursal INT
,@OrigenMovTipo CHAR(20)
,@FechaRequerida DATETIME
,@AF BIT
,@AFArticulo VARCHAR(20)
,@AFSerie VARCHAR(50)
,@Clase VARCHAR(50)
,@SubClase VARCHAR(50)
,@CfgClaseRequerida BIT
,@CfgValidarCC BIT
,@CfgConceptoCxp BIT
,@FormaPago VARCHAR(50)
,@ConceptoCxp VARCHAR(50) OUTPUT
,@AntecedenteID INT OUTPUT
,@AntecedenteEstatus CHAR(15) OUTPUT
,@AntecedenteSaldo MONEY OUTPUT
,@AntecedenteImporteTotal MONEY OUTPUT
,@AntecedenteMovTipo CHAR(20) OUTPUT
,@Autorizar BIT OUTPUT
,@Ok INT OUTPUT
,@OkRef VARCHAR(255) OUTPUT
AS
BEGIN
	DECLARE
		@ImporteTotal MONEY
	   ,@SumaSaldo MONEY
	   ,@Cuantos INT
	   ,@ContUso VARCHAR(20)
	   ,@LimiteAnticiposMN MONEY
	   ,@ChecarLimite VARCHAR(20)
	   ,@AnticiposPendientesMN MONEY
	   ,@SolicitudesPendientesMN MONEY
	   ,@Diferencia MONEY
	   ,@ConLimiteAnticipos BIT
	   ,@Origen VARCHAR(20)
	   ,@OrigenID VARCHAR(20)
	   ,@GasConceptoMultiple BIT
	SELECT @GasConceptoMultiple = GasConceptoMultiple
	FROM EmpresaCfg2 WITH (NOLOCK)
	WHERE Empresa = @Empresa
	SELECT @Autorizar = 0
	SELECT @AntecedenteID = NULL
		  ,@AntecedenteEstatus = NULL
		  ,@AntecedenteSaldo = 0.0
		  ,@AntecedenteImporteTotal = 0.0
		  ,@AntecedenteMovTipo = NULL
		  ,@ImporteTotal = @Importe - @RetencionTotal + @ImpuestoTotal

	IF @Accion = 'CANCELAR'
	BEGIN

		IF @Conexion = 0
			AND @OrigenMovTipo IN ('GAS.GP', 'GAS.CP', 'GAS.DGP', 'GAS.PRP')
			SELECT @Ok = 60072

		IF @Conexion = 0

			IF EXISTS (SELECT * FROM MovFlujo WITH(NOLOCK) WHERE Cancelado = 0 AND Empresa = @Empresa AND DModulo = @Modulo AND DID = @ID AND OModulo <> DModulo)
				AND @OrigenMovTipo <> 'PROY.PR'
				SELECT @Ok = 60070

		IF @Ok IS NULL

			IF @MovTipo IN ('GAS.S', 'GAS.P', 'GAS.A')
				AND ABS(@ImporteTotal - @Saldo) > 1.0
				SELECT @Ok = 60060

	END

	IF @MovTipo IN ('GAS.DA', 'GAS.ASC', 'GAS.SR')
		AND @Importe = 0.0
		SELECT @Ok = 30100

	IF @MovTipo IN ('GAS.A', 'GAS.DA', 'GAS.ASC', 'GAS.C', 'GAS.CCH', 'GAS.DC', 'GAS.G', 'GAS.GTC', 'GAS.GP', 'GAS.CP', 'GAS.DG', 'GAS.DGP', 'GAS.OI', 'GAS.CB', 'GAS.AB')
		AND @Ok IS NULL
		AND NULLIF(@FormaPago, '') IS NOT NULL
	BEGIN

		IF dbo.fnFormaPagoVerificar(@Empresa, @FormaPago, @Modulo, @Mov, @Usuario, '(Forma Pago)', 0) = 0
			SELECT @Ok = 30600
				  ,@OkRef = dbo.fnIdiomaTraducir(@Usuario, 'Forma Pago') + '. ' + @FormaPago

	END

	IF @MovTipo IN ('GAS.A')
		AND @Accion = 'CANCELAR'
		AND @OK IS NULL
	BEGIN

		IF EXISTS (SELECT * FROM Gasto WITH(NOLOCK) WHERE Empresa = @Empresa AND Origen = @Mov AND OrigenID = @MovID AND Estatus = 'CONCLUIDO')
			SELECT @Ok = 20180
				  ,@OkRef = 'El movimiento ' + Mov + ' ' + MovID + ' esta relacionado (Cancelar)'
			FROM Gasto
WITH(NOLOCK) WHERE Empresa = @Empresa
			AND Origen = @Mov
			AND OrigenID = @MovID
			AND Estatus = 'CONCLUIDO'

	END

	IF @MovTipo IN ('GAS.A', 'GAS.C', 'GAS.ASC', 'GAS.CCH', 'GAS.CP', 'GAS.G', 'GAS.GTC', 'GAS.GP', 'GAS.DA', 'GAS.SR')
		AND (@Multiple = 1 OR @MovAplica IS NOT NULL)
	BEGIN

		IF @Multiple = 1
		BEGIN
			SELECT @SumaSaldo = 0.0
				  ,@Cuantos = 0
			DECLARE
				crVerificarGasto
				CURSOR FOR
				SELECT g.ID
					  ,g.Estatus
					  ,ISNULL(g.Saldo, 0.0)
					  ,ISNULL(g.Importe, 0.0) - ISNULL(g.Retencion, 0.0) + ISNULL(g.Impuestos, 0.0)
					  ,mt.Clave
				FROM GastoAplica ga WITH (NOLOCK)
					,Gasto g WITH (NOLOCK)
					,MovTipo mt WITH (NOLOCK)
				WHERE ga.ID = @ID
				AND g.Empresa = @Empresa
				AND g.Mov = ga.Aplica
				AND g.MovID = ga.AplicaID
				AND mt.Modulo = @Modulo
				AND mt.Mov = g.Mov
				AND g.Moneda = @MovMoneda
				ORDER BY ga.Renglon
			OPEN crVerificarGasto
			FETCH NEXT FROM crVerificarGasto  INTO @AntecedenteID, @AntecedenteEstatus, @AntecedenteSaldo, @AntecedenteImporteTotal, @AntecedenteMovTipo
			WHILE @@FETCH_STATUS <> -1
			AND @Ok IS NULL
			BEGIN

			IF @@FETCH_STATUS <> -2
				AND @Ok IS NULL
			BEGIN
				EXEC spAplicaOk @Empresa
							   ,@Usuario
							   ,@Modulo
							   ,@AntecedenteID
							   ,@Ok OUTPUT
							   ,@OkRef OUTPUT

				IF @MovTipo IN ('GAS.G', 'GAS.GTC', 'GAS.GP')
					AND @AntecedenteMovTipo = 'GAS.A'
					SELECT @Ok = 20182

				SELECT @SumaSaldo = @SumaSaldo + @AntecedenteSaldo
					  ,@Cuantos = @Cuantos + 1

				IF @AntecedenteEstatus = 'PENDIENTE'
					OR (@Accion = 'CANCELAR' AND @AntecedenteEstatus = 'CONCLUIDO')
				BEGIN

					IF (@AntecedenteMovTipo = @MovTipo)
						OR (@AntecedenteMovTipo NOT IN ('GAS.S', 'GAS.P', 'GAS.A'))
						OR (@MovTipo IN ('GAS.DA', 'GAS.ASC', 'GAS.SR') AND @AntecedenteMovTipo <> 'GAS.A')
						SELECT @Ok = 20180

				END
				ELSE
					SELECT @Ok = 20180

			END

			FETCH NEXT FROM crVerificarGasto  INTO @AntecedenteID, @AntecedenteEstatus, @AntecedenteSaldo, @AntecedenteImporteTotal, @AntecedenteMovTipo
			END
			CLOSE crVerificarGasto
			DEALLOCATE crVerificarGasto

			IF @MovTipo IN ('GAS.DA', 'GAS.SR', 'GAS.ASC')
				AND @Accion <> 'CANCELAR'
				AND @Importe - @RetencionTotal + @ImpuestoTotal > @SumaSaldo
				AND @Ok IS NULL
				SELECT @Ok = 20360

			IF @Ok IS NULL
				AND @Cuantos <> (
					SELECT COUNT(*)
					FROM GastoAplica
WITH(NOLOCK) WHERE ID = @ID
				)
				SELECT @Ok = 20180

			IF @Ok IS NULL
				AND @Cuantos = 0
				SELECT @Ok = 20175

		END
		ELSE
		BEGIN
			SELECT @AntecedenteID = ID
				  ,@AntecedenteEstatus = Estatus
				  ,@AntecedenteSaldo = ISNULL(Saldo, 0.0)
				  ,@AntecedenteImporteTotal = ISNULL(Importe, 0.0) - ISNULL(Retencion, 0.0) + ISNULL(Impuestos, 0.0)
			FROM Gasto
WITH(NOLOCK) WHERE Empresa = @Empresa
			AND Mov = @MovAplica
			AND MovID = @MovAplicaID
			AND Acreedor = @Acreedor
			AND Moneda = @MovMoneda

			IF @AntecedenteID IS NOT NULL
				AND (@AntecedenteEstatus = 'PENDIENTE' OR (@Accion = 'CANCELAR' AND @AntecedenteEstatus = 'CONCLUIDO'))
			BEGIN
				EXEC spAplicaOk @Empresa
							   ,@Usuario
							   ,@Modulo
							   ,@AntecedenteID
							   ,@Ok OUTPUT
							   ,@OkRef OUTPUT
				SELECT @AntecedenteMovTipo = UPPER(MovTipo.Clave)
				FROM MovTipo
WITH(NOLOCK) WHERE Modulo = @Modulo
				AND Mov = @MovAplica

				IF @AntecedenteMovTipo NOT IN ('GAS.S', 'GAS.P', 'GAS.A')
					OR (@MovTipo IN ('GAS.DA', 'GAS.ASC') AND @AntecedenteMovTipo <> 'GAS.A')
					SELECT @Ok = 20180

				IF @MovTipo = 'GAS.SR'
				BEGIN

					IF @AntecedenteMovTipo <> 'GAS.S'
						SELECT @Ok = 20180

					IF @ImporteTotal <> @AntecedenteImporteTotal
						SELECT @Ok = 30100

				END

				IF @MovTipo IN ('GAS.DA', 'GAS.ASC', 'GAS.SR')
					AND @Accion <> 'CANCELAR'
					AND @Importe - @RetencionTotal + @ImpuestoTotal > @AntecedenteSaldo
					AND @Ok IS NULL
					SELECT @Ok = 20360

				IF @AntecedenteMovTipo = @MovTipo
					SELECT @Ok = 20180

				IF @MovTipo IN ('GAS.G', 'GAS.GTC', 'GAS.GP')
					AND @AntecedenteMovTipo = 'GAS.A'
					SELECT @Ok = 20182

			END
			ELSE

			IF @AntecedenteEstatus = 'RECURRENTE'
				OR @OrigenMovTipo = 'GAS.GR'
				SELECT @AntecedenteID = NULL
			ELSE
				SELECT @Ok = 20180

		END

	END

	IF @AntecedenteID IS NULL
		AND @MovTipo IN ('GAS.DA', 'GAS.ASC', 'GAS.SR')
		SELECT @Ok = 20180

	IF @MovTipo NOT IN ('GAS.S', 'GAS.P', 'GAS.DA', 'GAS.ASC', 'GAS.SR')
		AND @Accion = 'AFECTAR'
		AND @Ok IS NULL
	BEGIN

		IF EXISTS (SELECT * FROM GastoD WITH(NOLOCK) WHERE ID = @ID AND NULLIF(RTRIM(Concepto), '') IS NULL)
			SELECT @Ok = 20480

		IF @Ok IS NULL

			IF EXISTS (SELECT * FROM GastoD WITH(NOLOCK) WHERE ID = @ID AND ISNULL(Importe, 0.0) = 0.0)
				SELECT @Ok = 30100

	END

	IF @MovTipo IN ('GAS.A', 'GAS.S', 'GAS.P', 'GAS.G', 'GAS.GTC', 'GAS.GP', 'GAS.C', 'GAS.CCH', 'GAS.CP', 'GAS.DPR')
		AND @Accion <> 'CANCELAR'
		AND @Ok IS NULL
		AND @Autorizacion IS NULL
	BEGIN
		EXEC spGastoValidarPresupuesto @Empresa
									  ,@ID
									  ,@FechaEmision
									  ,@FechaRequerida
									  ,@Acreedor
									  ,@AntecedenteID
									  ,@MovMoneda
									  ,@Ok OUTPUT
									  ,@OkRef OUTPUT

		IF @Ok IS NOT NULL
			SELECT @Autorizar = 1

	END

	IF @MovTipo NOT IN ('GAS.DA', 'GAS.ASC', 'GAS.SR')

		IF NOT EXISTS (SELECT * FROM GastoD WITH(NOLOCK) WHERE ID = @ID)
			SELECT @Ok = 60010

	IF @MovTipo = 'GAS.CTO'

		IF EXISTS (SELECT * FROM Gasto WITH(NOLOCK) WHERE ID = @ID AND (ConVigencia = 0 OR VigenciaDesde IS NULL OR VigenciaHasta IS NULL OR VigenciaHasta < VigenciaDesde))
			SELECT @Ok = 10095

	IF @Accion IN ('AFECTAR', 'VERIFICAR')
	BEGIN

		IF @MovTipo <> 'GAS.EST'
			AND (
				SELECT SUM(Importe)
				FROM GastoD
WITH(NOLOCK) WHERE ID = @ID
			)
			< 0.0
			AND @MovTipo <> 'GAS.EST'
			SELECT @Ok = 30100

		IF @MovTipo IN ('GAS.CCH', 'GAS.GTC')

			IF EXISTS (SELECT * FROM GastoD WITH(NOLOCK) WHERE ID = @ID AND NULLIF(RTRIM(AcreedorRef), '') IS NULL)
				SELECT @Ok = 25480

		IF @MovTipo = 'GAS.GTC'

			IF EXISTS (SELECT * FROM GastoD WITH(NOLOCK) WHERE ID = @ID AND NULLIF(RTRIM(EndosarA), '') IS NULL)
				SELECT @Ok = 25490

	END

	IF @CfgConceptoCxp = 1
		AND @Accion IN ('AFECTAR', 'VERIFICAR')
		AND @MovTipo <> 'GAS.GTC'
		AND @Ok IS NULL
	BEGIN
		SELECT @ConceptoCxp = MIN(c.ConceptoCxp)
		FROM GastoD d WITH (NOLOCK)
			,Concepto c WITH (NOLOCK)
		WHERE d.ID = @ID
		AND c.Modulo = @Modulo
		AND c.Concepto = d.Concepto

		IF EXISTS (SELECT * FROM GastoD d WITH (NOLOCK), Concepto c WITH (NOLOCK) WHERE d.ID = @ID AND c.Modulo = @Modulo AND c.Concepto = d.Concepto AND c.ConceptoCxp <> @ConceptoCxp)
			AND @GasConceptoMultiple = 0
			SELECT @Ok = 30630
				  ,@OkRef = @ConceptoCxp

		IF EXISTS (SELECT * FROM GastoD d WITH(NOLOCK) LEFT JOIN Concepto c  WITH(NOLOCK) ON c.Concepto = d.Concepto WHERE d.ID = @ID AND c.Modulo = @Modulo AND c.ConceptoCxp IS NULL)
			AND @GasConceptoMultiple = 1
			SELECT @Ok = 30632
				  ,@OkRef = @OkRef + (
					   SELECT TOP 1 d.Concepto
					   FROM GastoD d  WITH(NOLOCK)
					   LEFT JOIN Concepto c  WITH(NOLOCK)
						   ON c.Concepto = d.Concepto
					   WHERE d.ID = @ID
					   AND c.Modulo = @Modulo
					   AND c.ConceptoCxp IS NULL
				   )

	END

	IF @CfgClaseRequerida = 1
		AND @Accion IN ('AFECTAR', 'VERIFICAR')

		IF @Clase IS NULL
			SELECT @Ok = 10080
		ELSE

		IF @SubClase IS NULL
			AND EXISTS (SELECT * FROM SubClase WITH(NOLOCK) WHERE Modulo = @Modulo AND Clase = @Clase)
			SELECT @Ok = 10090

	IF @Accion IN ('AFECTAR', 'VERIFICAR')
		AND @CfgValidarCC = 1
		AND @Ok IS NULL
	BEGIN
		SELECT @ContUso = NULL

		IF @ContUso IS NULL
			SELECT @ContUso = MIN(d.ContUso)
			FROM GastoD d
WITH(NOLOCK) WHERE d.ID = @ID
			AND NULLIF(RTRIM(d.ContUso), '') IS NOT NULL
			AND d.ContUso NOT IN (SELECT v.CentroCostos FROM CentroCostosEmpresa v  WITH(NOLOCK) WHERE v.Empresa = @Empresa)

		IF @ContUso IS NULL
			SELECT @ContUso = MIN(d.ContUso)
			FROM GastoD d
WITH(NOLOCK) WHERE d.ID = @ID
			AND NULLIF(RTRIM(d.ContUso), '') IS NOT NULL
			AND d.ContUso NOT IN (SELECT v.CentroCostos FROM CentroCostosSucursal v  WITH(NOLOCK) WHERE v.Sucursal = @Sucursal)

		IF @ContUso IS NULL
			SELECT @ContUso = MIN(d.ContUso)
			FROM GastoD d
WITH(NOLOCK) WHERE d.ID = @ID
			AND NULLIF(RTRIM(d.ContUso), '') IS NOT NULL
			AND d.ContUso NOT IN (SELECT v.CentroCostos FROM CentroCostosUsuario v WITH (NOLOCK) WHERE v.Usuario = @Usuario)

		IF @ContUso IS NOT NULL
			SELECT @Ok = 20765
				  ,@OkRef = @ContUso

	END

	IF @Accion NOT IN ('GENERAR', 'CANCELAR')
		AND @Ok IS NULL
		EXEC spValidarMovImporteMaximo @Usuario
									  ,@Modulo
									  ,@Mov
									  ,@ID
									  ,@Ok OUTPUT
									  ,@OkRef OUTPUT

	IF @MovTipo IN ('GAS.A', 'GAS.S')
		AND @Accion IN ('AFECTAR', 'VERIFICAR')
	BEGIN
		SELECT @ConLimiteAnticipos = ISNULL(ConLimiteAnticipos, 0)
			  ,@LimiteAnticiposMN = ISNULL(LimiteAnticiposMN, 0)
			  ,@ChecarLimite = UPPER(ChecarLimite)
		FROM Prov
WITH(NOLOCK) WHERE Proveedor = @Acreedor

		IF @ConLimiteAnticipos = 1
			AND (@ChecarLimite = 'SOLICITUD' OR @MovTipo = 'GAS.A')
		BEGIN
			SELECT @AnticiposPendientesMN = ISNULL(SUM(g.Saldo * g.TipoCambio), 0)
			FROM Gasto g WITH (NOLOCK)
				,MovTipo mt WITH (NOLOCK)
			WHERE mt.Modulo = @Modulo
			AND mt.Mov = g.Mov
			AND mt.Clave = 'GAS.A'
			AND g.Empresa = @Empresa
			AND g.Acreedor = @Acreedor
			AND g.Estatus = 'PENDIENTE'
			SELECT @Diferencia = @AnticiposPendientesMN + (ISNULL(@ImporteTotal, 0) * @MovTipoCambio) - @LimiteAnticiposMN

			IF @ChecarLimite = 'SOLICITUD'
				AND @MovTipo IN ('GAS.A', 'GAS.S')
			BEGIN
				SELECT @Origen = NULL
					  ,@OrigenID = NULL

				IF @OrigenMovTipo = 'GAS.S'
					SELECT @Origen = Origen
						  ,@OrigenID = OrigenID
					FROM Gasto
WITH(NOLOCK) WHERE ID = @ID

				SELECT @SolicitudesPendientesMN = ISNULL(SUM(g.Saldo * g.TipoCambio), 0)
				FROM Gasto g WITH (NOLOCK)
					,MovTipo mt WITH (NOLOCK)
				WHERE mt.Modulo = @Modulo
				AND mt.Mov = g.Mov
				AND mt.Clave = 'GAS.S'
				AND (ISNULL(g.Mov, '') <> ISNULL(@Origen, '') OR ISNULL(g.MovID, '') <> ISNULL(@OrigenID, ''))
				AND g.Empresa = @Empresa
				AND g.Acreedor = @Acreedor
				AND g.Estatus = 'PENDIENTE'
				SELECT @Diferencia = @Diferencia + @SolicitudesPendientesMN

				IF @Diferencia > 0.0
					SELECT @Ok = 65015
						  ,@OkRef = 'Limite Anticipos MN: ' + CONVERT(VARCHAR, @LimiteAnticiposMN) +
						   '<BR>Solicitudes Pendientes MN: ' + CONVERT(VARCHAR, @SolicitudesPendientesMN) +
						   '<BR>Anticipos Pendientes MN: ' + CONVERT(VARCHAR, @AnticiposPendientesMN) +
						   '<BR>Importe Movimiento MN: ' + CONVERT(VARCHAR, @ImporteTotal * @MovTipoCambio) +
						   '<BR><BR>Diferencia MN: ' + CONVERT(VARCHAR, @Diferencia)

			END

			IF @ChecarLimite = 'ANTICIPO'
				AND @MovTipo = 'GAS.A'
				AND @Diferencia > 0.0
				SELECT @Ok = 65015
					  ,@OkRef = 'Limite Anticipos MN: ' + CONVERT(VARCHAR, @LimiteAnticiposMN) +
					   '<BR>Anticipos Pendientes MN: ' + CONVERT(VARCHAR, @AnticiposPendientesMN) +
					   '<BR>Importe Movimiento MN: ' + CONVERT(VARCHAR, @ImporteTotal * @MovTipoCambio) +
					   '<BR><BR>Diferencia MN: ' + CONVERT(VARCHAR, @Diferencia)

		END

	END

	IF NOT EXISTS (SELECT * FROM AuxiliarActivoFijo WITH(NOLOCK) WHERE IDMov = @ID)
		AND @AF = 1
		AND (@AFArticulo IS NULL OR @AFSerie IS NULL)
		AND (
			SELECT GastoAFDetalle
FROM EmpresaCfg2 WITH(NOLOCK)
WHERE Empresa = @Empresa
		)
		= 0
		SELECT @Ok = 44170

	IF @Ok IS NULL
		EXEC xpGastoVerificar @ID
							 ,@Accion
							 ,@Empresa
							 ,@Usuario
							 ,@Modulo
							 ,@Mov
							 ,@MovID
							 ,@MovTipo
							 ,@MovMoneda
							 ,@FechaEmision
							 ,@Estatus
							 ,@Acreedor
							 ,@Ok OUTPUT
							 ,@OkRef OUTPUT

	IF @Ok IS NULL
		EXEC spGastoVerificarDetalle @ID
									,@Accion
									,@Empresa
									,@Usuario
									,@Modulo
									,@Mov
									,@MovID
									,@MovTipo
									,@MovMoneda
									,@FechaEmision
									,@Estatus
									,@Acreedor
									,@Ok OUTPUT
									,@OkRef OUTPUT

	IF @Ok IS NULL
		AND (
			SELECT EsGuatemala
FROM Empresa WITH(NOLOCK)
WHERE Empresa = @Empresa
		)
		= 1
		EXEC xpGastoVerificarGuatemala @ID
									  ,@Accion
									  ,@Empresa
									  ,@Usuario
									  ,@Modulo
									  ,@Mov
									  ,@MovID
									  ,@MovTipo
									  ,@MovMoneda
									  ,@FechaEmision
									  ,@Estatus
									  ,@Acreedor
									  ,@Ok OUTPUT
									  ,@OkRef OUTPUT

	RETURN
END

