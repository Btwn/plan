SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE [dbo].[xpDespuesAfectar]
 @Modulo CHAR(5)
,@ID INT
,@Accion CHAR(20)
,@Base CHAR(20)
,@GenerarMov CHAR(20)
,@Usuario CHAR(10)
,@SincroFinal BIT
,@EnSilencio BIT
,@Ok INT OUTPUT
,@OkRef VARCHAR(255) OUTPUT
,@FechaRegistro DATETIME
AS
BEGIN
	DECLARE
		@Mov VARCHAR(20)
	   ,@MovID VARCHAR(20)
	   ,@Cte VARCHAR(10)
	   ,@CteEnviarA INT
	   ,@SeEnviaBuroCte BIT
	   ,@SeEnviaBuroCanal BIT
	   ,@Estatus VARCHAR(15)
	   ,@CxID INT
	   ,@DineroID INT
	   ,@OrigenCRI VARCHAR(20)
	   ,@OrigenIDCRI VARCHAR(20)
	   ,@EsCredilana BIT
	   ,@Mayor12Meses BIT
	   ,@AplicaIDCTI VARCHAR(20)
	   ,@AplicaCTI VARCHAR(20)
	   ,@NumeroDocumentos INT
	   ,@Financiamiento MONEY
	   ,@Personal VARCHAR(10)
	   ,@DinMovId VARCHAR(20)
	   ,@Origen VARCHAR(20)
	   ,@CtaDineroDin VARCHAR(10)
	   ,@CtaDineroDesDin VARCHAR(10)
	   ,@Aplica VARCHAR(20)
	   ,@AplicaID VARCHAR(20)
	   ,@IDNCMor INT
	   ,@MovMor VARCHAR(20)
	   ,@FechaCancelacion DATETIME
	   ,@MovMorID VARCHAR(20)
	   ,@Concepto VARCHAR(20)
	   ,@OrigenID INT
	   ,@RetencionConcepto FLOAT
	   ,@IdPadre INT
	   ,@dAplica VARCHAR(20)
	   ,@dAplicaID VARCHAR(20)
	   ,@dPadreMAVI VARCHAR(20)
	   ,@dPadreIDMAVI VARCHAR(20)
	   ,@dFechaConclusion DATETIME
	   ,@dEstatus VARCHAR(20)
	   ,@PadreID INT
	   ,@dFechaEmision DATETIME
	   ,@ImporteNC FLOAT
	   ,@IDNcCobro INT
	   ,@CanalVenta INT
	   ,@OrigenPed VARCHAR(20)
	   ,@OrigenIDPed VARCHAR(20)
	   ,@Referencia VARCHAR(50)
	   ,@ReferenciaMavi VARCHAR(50)
	   ,@EngancheID INT
	   ,@MovF VARCHAR(20)
	   ,@MovIDF VARCHAR(20)
	   ,@Empresa CHAR(5)
	   ,@Sucursal INT
	   ,@FechaEmision DATETIME
	   ,@IdSoporte INT
	   ,@Importe MONEY
	   ,@Docs INT
	   ,@Abono MONEY
	   ,@FechaAsigVale DATE
	   ,@DiasPCDN INT
	SELECT @FechaEmision = dbo.FnfechaSinhora(GETDATE())

	IF @Accion = 'AFECTAR'
	BEGIN
		EXEC spActualizaTiemposMAVI @Modulo
								   ,@ID
								   ,@Accion
								   ,@Usuario
	END

	IF @Accion = 'CANCELAR'
	BEGIN
		EXEC spActualizaTiemposMAVI @Modulo
								   ,@ID
								   ,@Accion
								   ,@Usuario
	END

	IF @Accion = 'AFECTAR'
		AND @Modulo = 'VTAS'
	BEGIN
		SELECT @Mov = Mov
			  ,@MovID = MovID
			  ,@Estatus = Estatus
			  ,@CanalVenta = ENVIARA
			  ,@Cte = Cliente
			  ,@Importe = Importe + Impuestos
			  ,@Docs = CO.daNumeroDocumentos * 2
			  ,@Abono =
			   CASE
				   WHEN @Docs > 0 THEN @Importe / @Docs
				   ELSE 0
			   END
		FROM Venta V
		INNER JOIN CONDICION CO
			ON CO.CONDICION = V.CONDICION
		WHERE ID = @ID
		EXEC spClientesNuevosCasaMAVI @Modulo
									 ,@ID
									 ,@Accion
		EXEC spGenerarFinanciamientoMAVI @ID
										,'VTAS'

		IF @Mov IN ('Analisis Credito', 'Pedido')
		BEGIN
			EXEC xpActualizaRefAnticipo @ID
									   ,@Mov
		END

		IF dbo.fnClaveAfectacionMavi(@Mov, 'VTAS') = 'VTAS.F'
			AND @Estatus = 'Concluido'
		BEGIN
			SET @CxID = NULL
			SELECT @CxID = Cxc.ID
			FROM Cxc
			JOIN CxcD
				ON Cxc.ID = CxcD.ID
			WHERE CxcD.Aplica = @Mov
			AND CxcD.AplicaID = @MovID
			AND Cxc.Estatus = 'Concluido'
			AND Cxc.Mov = 'Aplicacion Saldo'

			IF @CxID IS NOT NULL
				EXEC xpDistribuyeSaldo @CxID

			IF @CanalVenta = 34
			BEGIN
				SELECT @Personal = Nomina
				FROM CTEENVIARA ce
				WHERE cliente = @cte
				AND id = 34

				IF ISNULL(@Personal, '') > ''
					EXEC Comercializadora.dbo.SPIDM0221_DeduccionCompras @Cte
																		,@Mov
																		,@MoVid
																		,@Abono
																		,@Personal
																		,@Docs

			END

		END

		IF @Mov IN ('Cancela Credilana', 'Cancela Prestamo')
			AND @Estatus = 'CONCLUIDO'
		BEGIN
			SELECT @DineroID = NULL
			SELECT @DineroID = IDIngresoMAVI
			FROM Venta
			WHERE ID = @ID

			IF EXISTS (SELECT ID FROM Dinero WHERE ID = @DineroID AND Estatus = 'SINAFECTAR')
			BEGIN
				EXEC spAfectar 'DIN'
							  ,@DineroID
							  ,'AFECTAR'
							  ,'TODO'
							  ,NULL
							  ,@Usuario
							  ,0
							  ,0
							  ,@Ok OUTPUT
							  ,@OkRef OUTPUT
							  ,NULL
							  ,0
							  ,NULL

				IF (
						SELECT Estatus
						FROM Dinero
						WHERE ID = @DineroID
					)
					= 'CONCLUIDO'
				BEGIN
					UPDATE Dinero
					SET Referencia = @Mov + ' ' + @MovID
					WHERE ID = @DineroID
					SELECT @Ok = 80300
					SELECT @OkRef = Mov + ' ' + MovID
					FROM Dinero
					WHERE ID = @DineroID
				END

			END

		END

		EXEC spActualizaDesglose @ID
								,@Mov
								,''
								,'CXC'
		DECLARE
			@clave VARCHAR(10)
		SELECT @clave = Clave
		FROM MovTipo
		WHERE Modulo = @Modulo
		AND Mov = @Mov

		IF (ISNULL(@clave, '') = 'VTAS.F')
		BEGIN

			IF (EXISTS (SELECT TOP 1 Mov FROM Cxc WHERE Mov = 'Documento' AND PadreMavi = @Mov AND PadreIDMavi = @MovID AND Referencia <> ReferenciaMAVI)
				)
				UPDATE Cxc
				SET Referencia = ReferenciaMAVI
				WHERE Mov = 'Documento'
				AND PadreMavi = @Mov
				AND PadreIDMavi = @MovID
				AND Referencia <> ReferenciaMAVI

		END

		IF (ISNULL(@clave, '') IN ('VTAS.F', 'VTAS.D'))
		BEGIN
			EXEC SP_MAVIDM0279CalcularBonif @Mov
										   ,@MovID
										   ,@ID
										   ,0
										   ,@clave
		END

		IF (ISNULL(@clave, '') IN ('VTAS.F', 'VTAS.P'))
		BEGIN
			EXEC SpVTASActualizaEstatusTarjeta @ID
		END
		IF @Mov IN (SELECT DISTINCT
				Mov
			FROM MovTipo WITH (NOLOCK) --Valida si el movimiento, es una devolucion de mercancia ó de prestamo de dinero
			WHERE Clave = 'VTAS.D')
		BEGIN
			EXEC SPDM0274NotaCgoDevVenta @ID
		END

	END

	IF @Accion = 'Cancelar'
		AND @Modulo = 'VTAS'
		AND (SELECT
			EnviarA
		FROM Venta WITH (NOLOCK)
		WHERE ID = @ID)
		= 34
		AND (SELECT
			M.Clave
		FROM Venta V WITH (NOLOCK)
		JOIN MovTipo M WITH (NOLOCK)
			ON M.Mov = V.Mov
			AND M.Modulo = 'VTAS'
		WHERE V.ID = @ID)
		= 'VTAS.F'
	BEGIN
		DECLARE @IdNom int
		SELECT
			@Mov = Mov,
			@MovId = MovID
		FROM Venta WITH (NOLOCK)
		WHERE ID = @ID

		SELECT
			@IdNom = ID
		FROM Comercializadora.dbo.Nomina WITH (NOLOCK)
		WHERE Mov = 'Otras Deducciones'
		AND Estatus = 'VIGENTE'
		AND Concepto IN ('Cpa Credilana', 'Cpa Mercancia')
		AND SUBSTRING(REPLACE(Observaciones, 'Descuento Compra ', ''), 1,
		CHARINDEX(' ', REPLACE(Observaciones, 'Descuento Compra ', '')) - 1) = @MOV
		AND SUBSTRING(REPLACE(Observaciones, 'Descuento Compra ', ''),
		CHARINDEX(' ', REPLACE(Observaciones, 'Descuento Compra ', '')) + 1,
		DATALENGTH(REPLACE(Observaciones, 'Descuento Compra ', ''))) = @MOVID

		EXEC Comercializadora.dbo.spAfectar 'NOM',
																				@IDNom,
																				'Cancelar',
																				'Todo',
																				NULL,
																				'NOMIN00017',
																				@Estacion = 99
	END

	IF @Accion = 'CANCELAR'
		AND @Modulo = 'VTAS'
	BEGIN
		SELECT @Mov = Mov
			  ,@MovID = MovID
			  ,@Estatus = Estatus
		FROM Venta
		WHERE ID = @ID
		EXEC spEliminarRecuperacionMAVI @ID
		DECLARE
			@clavemov VARCHAR(10)
		SELECT @clavemov = dbo.fnClaveAfectacionMavi(@Mov, 'VTAS')

		IF ISNULL(@clavemov, '') = 'VTAS.F'
			AND @Estatus = 'Cancelado'
		BEGIN
			SET @CxID = NULL
			SELECT @CxID = Cxc.ID
			FROM Cxc
			JOIN CxcD
				ON Cxc.ID = CxcD.ID
			WHERE CxcD.Aplica = @Mov
			AND CxcD.AplicaID = @MovID
			AND Cxc.Estatus = 'Cancelado'
			AND Cxc.Mov = 'Aplicacion Saldo'

			IF @CxID IS NOT NULL
				EXEC xpDistribuyeSaldoCancelarMAVI @CxID

		END

		SELECT @clave = Clave
		FROM MovTipo
		WHERE Modulo = @Modulo
		AND Mov = @Mov

		IF ISNULL(@clavemov, '') = 'VTAS.D'
			EXEC SP_MAVIDM0279CalcularBonif @Mov
										   ,@MovID
										   ,@ID
										   ,0
										   ,@clavemov

		IF (ISNULL(@clave, '') IN ('VTAS.F', 'VTAS.P'))
		BEGIN
			EXEC SpVTASActualizaEstatusTarjeta @ID
		END

	END

	IF @Accion = 'AFECTAR'
		AND @Modulo = 'CXC'
	BEGIN
		EXEC spActualizarProgramaRecuperacionMAVI @ID
		EXEC spApoyoFactorIMMavi @ID
		SELECT @Mov = Mov
			  ,@MovID = MovID
			  ,@Estatus = Estatus
			  ,@Financiamiento = Financiamiento
			  ,@concepto = Concepto
		FROM CxC
		WHERE ID = @ID

		IF (
				SELECT Clave
				FROM MovTipo
				WHERE Modulo = 'CXC'
				AND Mov = @Mov
			)
			= 'CXC.C'
		BEGIN
			SELECT @dFechaConclusion = FechaConclusion
				  ,@dEstatus = Estatus
			FROM Cxc
			WHERE ID = @ID
			DECLARE
				@PadresCobrados TABLE (
					IDTmp INT IDENTITY PRIMARY KEY
				   ,ID INT
				   ,PadreMavi VARCHAR(20)
				   ,PadreIDMavi VARCHAR(20)
				   ,Importe FLOAT
				)
			INSERT INTO @PadresCobrados
				SELECT F.ID
					  ,F.Mov
					  ,F.MovID
					  ,SUM(D.Importe)
				FROM CxcD D
				JOIN CxC C
					ON D.Aplica = C.Mov
					AND D.AplicaID = C.MovID
				JOIN CxC F
					ON C.PadreMavi = F.Mov
					AND C.PadreIDMavi = F.MovID
				WHERE D.ID = @ID
				GROUP BY F.ID
						,F.Mov
						,F.MovID
			INSERT INTO CobrosxPadre
				SELECT P.ID
					  ,@ID
					  ,@dFechaConclusion
					  ,P.Importe
					  ,@dEstatus
					  ,'CXC.C'
				FROM @PadresCobrados P
		END

		IF (
				SELECT Clave
				FROM MovTipo
				WHERE Modulo = 'CXC'
				AND Mov = @Mov
			)
			= 'CXC.CA'
			AND @Concepto LIKE 'CANC COBRO%'
		BEGIN
			SELECT @dPadreMAVI = padremavi
				  ,@dPadreIDMAVI = padreidmavi
				  ,@dFechaEmision = fechaemision
				  ,@mov = mov
				  ,@ImporteNC = ISNULL(Importe, 0) + ISNULL(Impuestos, 0)
				  ,@dEstatus = Estatus
			FROM cxc
			WHERE id = @ID
			SELECT @PadreID = id
			FROM cxc
			WHERE mov = @dPadreMAVI
			AND movid = @dPadreIDMAVI
			SELECT @IDNcCobro = (SUBSTRING(SUBSTRING(Valor, (CHARINDEX('_', Valor) + 1), LEN(valor)),
			 CHARINDEX('_', (SUBSTRING(Valor, (CHARINDEX('_', Valor) + 1), LEN(valor)))) + 1,
			 LEN(SUBSTRING(Valor, (CHARINDEX('_', Valor) + 1), LEN(valor)))))
			FROM movcampoextra
			WHERE CampoExtra IN ('NC_COBRO', 'NCV_COBRO', 'NCM_COBRO')
			AND ID = @ID
			AND mov = @mov

			IF @IDNcCobro IS NOT NULL
				INSERT INTO NCargoCCxPadre
					SELECT @PadreID
						  ,@IDNcCOBRO
						  ,@ID
						  ,@dFechaEmision
						  ,@ImporteNC
						  ,@dEstatus

			SELECT @IDPadre = IDPadre
			FROM dbo.NCargoCCxPadre
			WHERE IDNCargo = @ID

			IF (
					SELECT COUNT(*)
					FROM CobrosxPadre
					WHERE IDPadre = @IDPadre
					AND Estatus = 'CONCLUIDO'
				)
				= 1
			BEGIN
				UPDATE CXC
				SET CalificacionMAVI = 0
				   ,PonderacionCalifMAVI = '*'
				WHERE ID = @IdPadre
				UPDATE CXCMAVI
				SET MopMavi = 0
				   ,MopActMAVI = NULL
				   ,FechaUltAbono = NULL
				WHERE ID = @IdPadre
				DELETE dbo.HistoricoMOPMAVI
				WHERE ID = @IdPadre
			END

			EXEC SP_MAVIDM0279CalcularBonif @Mov
										   ,@MovID
										   ,0
										   ,@ID
										   ,'CXC.CA'
		END

		IF (
				SELECT Clave
				FROM MovTipo
				WHERE Modulo = 'CXC'
				AND Mov = @Mov
			)
			= 'CXC.NC'
			AND @Concepto LIKE 'CORR COBRO%'
		BEGIN
			SELECT TOP 1 @dAplica = Aplica
						,@dAplicaID = AplicaID
			FROM CxcD
			WHERE ID = @ID
			SELECT @dFechaEmision = FechaEmision
				  ,@dEstatus = Estatus
			FROM Cxc
			WHERE ID = @ID
			SELECT @dPadreMAVI = PadreMavi
				  ,@dPadreIDMAVI = PadreIDMavi
			FROM Cxc
			WHERE Mov = @dAplica
			AND MovID = @dAplicaID
			SELECT @PadreID = ID
			FROM cxc
			WHERE Mov = @dPadreMAVI
			AND MovID = @dPadreIDMAVI
			INSERT INTO CobrosxPadre
				SELECT @PadreID
					  ,@ID
					  ,@dFechaEmision
					  ,SUM(ISNULL(Importe, 0))
					  ,@dEstatus
					  ,'CXC.NC'
				FROM Cxcd
				WHERE id = @ID
		END

		IF (@Mov IN ('Endoso'))
		BEGIN
			SELECT @Mov = Mov
				  ,@MovID = MovID
				  ,@Cte = Cliente
				  ,@CteEnviarA = ClienteEnviarA
			FROM CxC
			WHERE ID = @ID
			SELECT @SeEnviaBuroCte = SeEnviaBuroCreditoMavi
			FROM CteEnviarA
			WHERE Cliente = @Cte
			AND ID = @CteEnviarA
			SELECT @SeEnviaBuroCanal = SeEnviaBuroCreditoMavi
			FROM VentasCanalMavi
			WHERE ID = @CteEnviarA

			IF (@SeEnviaBuroCte = 1)
				EXEC spCambiarCxcBuroCanalVenta @Mov
											   ,@MovID

		END

		IF (@Mov IN ('Cta Incobrable F', 'Cta Incobrable NV'))
		BEGIN
			EXEC spDesactivaEnviarBuroFactEnCtaInc @ID

			IF (@Estatus = 'PENDIENTE')
				EXEC spActualizaCtaIncMigraMaviCob @ID

		END

		IF dbo.fnClaveAfectacionMAVI(@Mov, 'CXC') IN ('CXC.DE')
		BEGIN
			EXEC xpDevolucionAnticipoSaldoMavi @ID
											  ,@Usuario
			UPDATE Cxc
			SET Referencia = RefAnticipoMavi
			WHERE ID = @ID
		END

		IF (@Mov IN ('Contra Recibo Inst'))
		BEGIN
			SELECT @OrigenCRI = Origen
				  ,@OrigenIDCRI = OrigenID
			FROM CXC
			WHERE ID = @ID
			SELECT @EsCredilana = EsCredilana
				  ,@Mayor12Meses = Mayor12Meses
			FROM CXC
			WHERE Mov = @OrigenCRI
			AND MovID = @OrigenIDCRI
			AND Estatus IN ('CONCLUIDO', 'PENDIENTE')
			UPDATE Cxc
			SET EsCredilana = @EsCredilana
			   ,Mayor12Meses = @Mayor12Meses
			WHERE ID = @ID
		END

		IF (@Mov IN ('Cta Incobrable NV', 'Cta Incobrable F'))
		BEGIN
			SELECT @AplicaCTI = Aplica
				  ,@AplicaIDCTI = MIN(AplicaId)
			FROM CxcD
			WHERE Id = @ID
			GROUP BY Aplica
			SELECT @EsCredilana = EsCredilana
				  ,@Mayor12Meses = Mayor12Meses
			FROM CXC
			WHERE Mov = @AplicaCTI
			AND MovId = @AplicaIDCTI
			AND Estatus IN ('CONCLUIDO', 'PENDIENTE')
			UPDATE Cxc
			SET EsCredilana = @EsCredilana
			   ,Mayor12Meses = @Mayor12Meses
			WHERE ID = @ID
		END

		IF (@Mov IN ('Anticipo Contado', 'Anticipo Mayoreo',
			'Apartado', 'Enganche', 'Devolucion',
			'Dev Anticipo Contado', 'Dev Anticipo Mayoreo',
			'Devolucion Enganche', 'Devolucion Apartado'))
			EXEC spMayor12AnticipoDev @ID

		IF @Mov = 'Refinanciamiento'
			AND @Estatus = 'CONCLUIDO'
		BEGIN
			EXEC spGenerarFinanciamientoMAVI @ID
											,'CXC'
			SELECT @NumeroDocumentos = 0
			EXEC spPrendeMayor12Mavi @ID
			EXEC spPrendeBitsMAVI @ID
			UPDATE Cxc
			SET Referencia = @Mov + ' ' + @MovID
			WHERE ID IN (SELECT IDCxc FROM RefinIDInvolucra WHERE ID = @ID)
			UPDATE Cxc
			SET Concepto = 'REFINANCIAMIENTO'
			WHERE Referencia = @Mov + ' ' + @MovID
			AND Mov = 'Nota Cargo'
			AND @Estatus = 'CONCLUIDO'
			SELECT @NumeroDocumentos = NumeroDocumentos
			FROM DocAuto
			WHERE Modulo = 'CXC'
			AND Mov = @Mov
			AND MovID = @MovID

			IF ISNULL(@NumeroDocumentos, 0) > 0
			BEGIN
				SELECT @Financiamiento = @Financiamiento
				 / @NumeroDocumentos
				UPDATE Cxc
				SET Financiamiento = @Financiamiento
				WHERE Origen = @Mov
				AND OrigenID = @MovID
				AND Mov = 'Documento'
				AND Estatus = 'PENDIENTE'
			END

		END

		IF @Mov = 'Refinanciamiento'
			AND @Estatus = 'PENDIENTE'
			UPDATE Cxc
			SET Referencia = @Mov + ' ' + @MovID
			WHERE ID IN (SELECT IDCxc FROM RefinIDInvolucra WHERE ID = @ID)

		EXEC spActualizaDesglose @ID
								,''
								,''
								,'CXC'

		IF @Mov IN ('Nota Cargo', 'Nota Cargo VIU',
			'Nota Cargo Mayoreo')
		BEGIN
			UPDATE Cxc
			SET FechaOriginal = Vencimiento
			WHERE ID = @ID
		END

		IF @Mov IN ('Nota Credito', 'Nota Credito VIU',
			'Nota Credito Mayoreo', 'Cancela Prestamo', 'Cancela Credilana')
			AND @Concepto LIKE 'CORR COBRO%'
		BEGIN
			UPDATE Cxc
			SET Nota = (
				SELECT TOP 1 Padre.ID
				FROM CXC c
				JOIN CXCd d
					ON d.ID = c.ID
				JOIN CXC f
					ON f.Mov = d.Aplica
					AND f.MovID = d.AplicaID
				JOIN CXC Padre
					ON Padre.Mov = f.PadreMAVI
					AND Padre.MovID = f.PadreIDMAVI
				WHERE c.ID = @ID
			)
			WHERE ID = @ID
		END

	END

	IF @Accion = 'CANCELAR'
		AND @Modulo = 'CXC'
	BEGIN
		EXEC spActualizarProgramaRecuperacionAlCancelarMAVI @ID
		SELECT @Mov = Mov
			  ,@Estatus = Estatus
			  ,@Concepto = Concepto
		FROM Cxc
		WHERE ID = @ID

		IF (
				SELECT Clave
				FROM MovTipo
				WHERE Modulo = 'CXC'
				AND Mov = @Mov
			)
			= 'CXC.ANC'
			AND @Concepto LIKE 'CORR COBRO%'
			UPDATE CobrosxPadre
			SET Estatus = 'CANCELADO'
			WHERE IDCobro = @ID

		IF (
				SELECT Clave
				FROM MovTipo
				WHERE Modulo = 'CXC'
				AND Mov = @Mov
			)
			= 'CXC.NC'
			AND @Concepto LIKE 'CORR COBRO%'
			UPDATE CobrosxPadre
			SET Estatus = 'CANCELADO'
			WHERE IDCobro = @ID

		IF @Mov LIKE 'Cobro%'
			UPDATE CobrosxPadre
			SET Estatus = 'CANCELADO'
			WHERE IDCobro = @ID

		IF (
				SELECT Clave
				FROM MovTipo
				WHERE Modulo = 'CXC'
				AND Mov = @Mov
			)
			= 'CXC.CA'
			AND @Concepto LIKE 'CANC COBRO%'
			UPDATE NCargoCCxPadre
			SET EstatusNCargo = 'CANCELADO'
			WHERE IDNCargo = @ID

		IF (@Mov IN ('Cta Incobrable F', 'Cta Incobrable NV'))
			EXEC spActivaEnviarBuroFactEnCtaInc @ID

		IF dbo.fnClaveAfectacionMAVI(@Mov, 'CXC') IN ('CXC.AA')
			AND @Estatus = 'Cancelado'
		BEGIN
			EXEC xpCancelaEnganche @ID
								  ,@Usuario
		END

		IF dbo.fnClaveAfectacionMAVI(@Mov, 'CXC') IN ('CXC.DE')
		BEGIN
			EXEC xpCancelaDevolucion @ID
		END

		IF @Mov IN ('Nota Cargo', 'Nota Cargo VIU',
			'Nota Cargo Mayoreo', 'Nota Credito',
			'Nota Credito VIU', 'Nota Credito Mayoreo')
			AND @Estatus = 'CANCELADO'
		BEGIN

			IF EXISTS (SELECT ModuloID FROM CFD WHERE ModuloID = @ID)
			BEGIN
				SELECT @FechaCancelacion = FechaCancelacion
				FROM CXC
				WHERE ID = @ID
				UPDATE CFD
				SET FechaCancelacion = @FechaCancelacion
				WHERE ModuloID = @ID
			END

		END

		IF (dbo.fnClaveAfectacionMAVI(@Mov, 'CXC') = 'CXC.DM')
			AND @Accion = 'CANCELAR'
			AND @Ok IS NULL
			EXEC spRevisaCtaIncEnvioMaviCob @ID

	END

	IF @Accion = 'AFECTAR'
		AND @Modulo = 'AF'
	BEGIN
		EXEC spActualizarServicioAFAlAfectarMAVI @ID
	END

	IF @Accion = 'CANCELAR'
		AND @Modulo = 'AF'
	BEGIN
		EXEC spActualizarServicioAFAlCancelarMAVI @ID
	END

	IF @Accion = 'AFECTAR'
		AND @Modulo = 'GAS'
	BEGIN
		SELECT @Mov = Mov
			  ,@MovID = MovID
		FROM Gasto
		WHERE Id = @Id

		IF @Mov = 'Cargo Bancario'
			UPDATE Gasto
			SET GenerarDinero = 0
			WHERE Id = @Id

		IF @Mov = 'Contrato'
		BEGIN
			EXEC spSolGastoContratoDF @ID
			UPDATE Gasto
			SET Vencimiento = FechaRequerida
			WHERE Origen = @Mov
			AND OrigenID = @MovID
		END

		SELECT @Mov = Mov
			  ,@MovID = MovID
		FROM Gasto
		WHERE ID = @ID
		SELECT @OrigenID = ID
		FROM CxP
		WHERE Mov = @Mov
		AND MovID = @MovID

		IF @Mov = 'GASTO'
		BEGIN

			IF (EXISTS (SELECT Retencion2 FROM MovImpuesto WHERE Modulo = 'GAS' AND ModuloID = @ID AND Retencion2 > 9)
				)
			BEGIN
				SELECT DISTINCT @RetencionConcepto = Retencion2
				FROM Concepto
				WHERE Modulo = 'GAS'
				AND Retencion2 > 9
				UPDATE MovImpuesto
				SET Retencion2 = @RetencionConcepto
				WHERE Modulo = 'GAS'
				AND ModuloID = @ID
				AND Retencion2 > 9
				UPDATE MovImpuesto
				SET Retencion2 = @RetencionConcepto
				WHERE Modulo = 'CXP'
				AND ModuloID = @OrigenID
				AND Retencion2 > 9
			END

		END

	END

	IF @Accion = 'AFECTAR'
		AND @Modulo = 'EMB'
	BEGIN
		SELECT @Mov = Mov
			  ,@Estatus = Estatus
		FROM Embarque
		WHERE ID = @ID

		IF @Mov = 'Embarque'
			AND @Estatus = 'CONCLUIDO'
			UPDATE EmbarqueD
			SET ParaComisionChoferMAVI = 1
			WHERE Estado = 'Entregado'
			AND ID = @ID

	END

	IF @Accion = 'AFECTAR'
		AND @Modulo = 'AF'
	BEGIN
		SELECT @Mov = Mov
			  ,@Personal = Personal
		FROM ActivoFijo
		WHERE Id = @Id

		IF @Mov = 'Asignacion'
		BEGIN
			UPDATE Personal
			SET AFComer = 1
			WHERE Personal = @Personal
		END

		IF @Mov = 'Devolucion'
		BEGIN
			UPDATE Personal
			SET AFComer = 0
			WHERE Personal = @Personal
		END

	END

	IF @Modulo = 'DIN'
	BEGIN
		SELECT @Mov = Mov
			  ,@DinMovId = MovID
			  ,@Estatus = Estatus
			  ,@Origen = Origen
			  ,@CtaDineroDin = CtaDinero
			  ,@CtaDineroDesDin = CtaDineroDestino
		FROM Dinero
		WHERE ID = @ID

		IF @Mov = 'Ingreso'
			AND @Estatus = 'CONCLUIDO'
		BEGIN
			INSERT INTO MovFlujo (Sucursal,
			Empresa,
			OModulo,
			OID,
			OMov,
			OMovID,
			DModulo,
			DID,
			DMov,
			DMovID,
			Cancelado)
				SELECT c.Sucursal
					  ,'MAVI'
					  ,'CXC'
					  ,c.ID
					  ,c.Mov
					  ,c.MovID
					  ,'DIN'
					  ,a.ID
					  ,a.Mov
					  ,a.MovID
					  ,0
				FROM Dinero a
					,Venta b
					,Cxc c
				WHERE a.ID = @ID
				AND a.Id = b.IDIngresoMAVI
				AND b.Mov = c.Origen
				AND b.MovID = C.OrigenID

			IF @Origen IS NULL
			BEGIN
				UPDATE Dinero
				SET Dinero.OrigenTipo = 'CXC'
				   ,Dinero.Origen = MovFlujo.OMov
				   ,Dinero.OrigenID = MovFlujo.OMovID
				FROM MovFlujo
				WHERE Dinero.Mov = 'Ingreso'
				AND MovFlujo.DModulo = 'DIN'
				AND Dinero.ID = MovFlujo.DID
				AND Dinero.Mov = MovFlujo.DMov
				AND Dinero.MovID = MovFlujo.DMovID
				AND Dinero.ID = @ID
			END

		END

		IF @Estatus = 'CONCLUIDO'
		BEGIN

			IF @Mov = 'Apertura Caja'
			BEGIN
				UPDATE CtaDinero
				SET Estado = 1
				WHERE CtaDinero = @CtaDineroDesDin
			END

			IF @Mov = 'Corte Caja'
			BEGIN
				UPDATE CtaDinero
				SET Estado = 0
				WHERE CtaDinero = @CtaDineroDin
			END

		END

		IF @Estatus = 'CANCELADO'
		BEGIN

			IF @Mov = 'Apertura Caja'
			BEGIN
				UPDATE CtaDinero
				SET Estado = 0
				WHERE CtaDinero = @CtaDineroDesDin
			END

			IF @Mov = 'Corte Caja'
			BEGIN
				UPDATE CtaDinero
				SET Estado = 1
				WHERE CtaDinero = @CtaDineroDin
			END

		END

	END

	IF @Modulo = 'CXC'
		AND dbo.fnClaveAfectacionMAVI(@Mov, 'CXC') IN ('CXC.C')
		AND @Estatus = 'Cancelado'
	BEGIN
		DECLARE
			C2
			CURSOR FAST_FORWARD FOR
			SELECT Aplica
				  ,AplicaID
			FROM CxcD
			WHERE ID = @ID
			AND Aplica IN ('Nota Cargo', 'Nota Cargo VIU', 'Nota Cargo Mayoreo')
		OPEN C2
		FETCH NEXT FROM C2 INTO @Aplica, @AplicaID
		WHILE @@Fetch_Status = 0
		BEGIN
		SELECT @IDNCMor = ID
		FROM CXC
		WHERE Mov = @Aplica
		AND MovId = @AplicaID
		DECLARE
			crCancelNC
			CURSOR FAST_FORWARD FOR
			SELECT Origen
				  ,OrigenId
			FROM NegociaMoratoriosMAVI
			WHERE IDCobro = @ID
			AND NotaCargoMorId = @IDNCMor
			GROUP BY Origen
					,OrigenId
		OPEN crCancelNC
		FETCH NEXT FROM crCancelNC INTO @MovMor, @MovMorID
		WHILE @@Fetch_Status = 0
		BEGIN
		EXEC spAfectar 'CXC'
					  ,@IDNCMor
					  ,'CANCELAR'
					  ,'Todo'
					  ,NULL
					  ,@Usuario
					  ,NULL
					  ,0
					  ,@Ok OUTPUT
					  ,@OkRef OUTPUT
					  ,NULL
					  ,@Conexion = 0
		FETCH NEXT FROM crCancelNC INTO @MovMor, @MovMorID
		END
		CLOSE crCancelNC
		DEALLOCATE crCancelNC
		FETCH NEXT FROM C2 INTO @Aplica, @AplicaID
		END
		CLOSE C2
		DEALLOCATE C2
	END

	IF DB_NAME() != 'MaviCob'
	BEGIN

		IF @Modulo = 'CXC'
			AND ISNULL(@Accion, '') IN ('CANCELAR', 'AFECTAR')
			AND ISNULL(@Ok, 0) = 0
			AND EXISTS (SELECT ID FROM CXC WHERE ID = @ID AND Mov IN (SELECT DISTINCT MovCargo FROM TcIDM0224_ConfigNotasEspejo UNION ALL SELECT DISTINCT MovCredito FROM TcIDM0224_ConfigNotasEspejo) AND ISNULL(Concepto, '') IN (SELECT DISTINCT ConceptoCargo FROM TcIDM0224_ConfigNotasEspejo UNION ALL SELECT DISTINCT ConceptoCredito FROM TcIDM0224_ConfigNotasEspejo) AND Estatus NOT IN ('CANCELADO', 'SINAFECTAR'))
		BEGIN
			EXEC dbo.SP_MAVIDM0224NotaCreditoEspejo @ID
												   ,@Accion
												   ,@Usuario
												   ,@Ok OUTPUT
												   ,@OkRef OUTPUT
												   ,'DESPUES'
		END

		IF @Modulo = 'CXC'
			AND @Accion = 'AFECTAR'
			AND @Estatus = 'CONCLUIDO'
		BEGIN
			SELECT @Mov = Mov
				  ,@MovID = MovID
				  ,@Estatus = Estatus
				  ,@concepto = Concepto
			FROM CxC
			WHERE ID = @ID

			IF EXISTS (SELECT Aplica, AplicaId FROM CXCD WHERE ID = @ID)
			BEGIN
				SELECT @Aplica = Aplica
					  ,@Aplicaid = AplicaId
				FROM CXCD
				WHERE ID = @ID

				IF EXISTS (SELECT Id FROM CxC JOIN CONDICION CO ON cxc.condicion = co.condicion WHERE MOV = @Aplica AND MOVID = @Aplicaid AND dbo.fnClaveAfectacionMavi(Mov, 'VTAS') = 'VTAS.F' AND Estatus = 'CONCLUIDO' AND Saldo = NULL AND co.tipocondicion = 'CONTADO' AND co.grupo = 'MENUDEO')
				BEGIN
					SELECT @OrigenID = v.Id
						  ,@MovF = cc.Mov
						  ,@MovIDF = cc.MovID
						  ,@Empresa = v.Empresa
						  ,@Sucursal = v.Sucursal
					FROM Venta v
					JOIN CXC cc
						ON v.mov = cc.mov
						AND v.movid = cc.movid
					WHERE cc.MOV = @Aplica
					AND cc.MOVID = @Aplicaid

					IF EXISTS (SELECT * FROM PoliticasMonederoAplicadasMavi WHERE Modulo = 'VTAS' AND ID = @OrigenID AND cveEstatus = 'P')
					BEGIN
						EXEC xpMovEstatusCxC @Empresa
											,@Sucursal
											,@Modulo
											,@OrigenID
											,@Estatus
											,@Estatus
											,@Usuario
											,@FechaEmision
											,@FechaRegistro
											,@MovF
											,@MovIDF
											,'VTAS.F'
											,@Ok OUTPUT
											,@OkRef OUTPUT
					END

				END

			END

		END

		IF @Modulo = 'CXC'
			AND @Accion = 'CANCELAR'
			AND @Estatus = 'CANCELADO'
		BEGIN
			SELECT @Mov = Mov
				  ,@MovID = MovID
				  ,@Estatus = Estatus
				  ,@concepto = Concepto
			FROM CxC
			WHERE ID = @ID

			IF EXISTS (SELECT Aplica, AplicaId FROM CXCD WHERE ID = @ID)
			BEGIN
				SELECT @Aplica = Aplica
					  ,@Aplicaid = AplicaId
				FROM CXCD
				WHERE ID = @ID

				IF EXISTS (SELECT Id FROM CxC JOIN CONDICION CO ON cxc.condicion = co.condicion WHERE MOV = @Aplica AND MOVID = @Aplicaid AND dbo.fnClaveAfectacionMavi(Mov, 'VTAS') = 'VTAS.F' AND Estatus <> 'CONCLUIDO' AND ISNULL(Saldo, 0) > 0 AND co.tipocondicion = 'CONTADO' AND co.grupo = 'MENUDEO')
				BEGIN
					SELECT @OrigenID = v.Id
						  ,@MovF = cc.Mov
						  ,@MovIDF = cc.MovID
						  ,@Empresa = v.Empresa
						  ,@Sucursal = v.Sucursal
					FROM Venta v
					JOIN CXC cc
						ON v.mov = cc.mov
						AND v.movid = cc.movid
					WHERE cc.MOV = @Aplica
					AND cc.MOVID = @Aplicaid

					IF EXISTS (SELECT * FROM PoliticasMonederoAplicadasMavi WHERE Modulo = 'VTAS' AND ID = @OrigenID AND ISNULL(cveEstatus, '') = 'A')
					BEGIN
						EXEC xpMovEstatusCxC @Empresa
											,@Sucursal
											,@Modulo
											,@OrigenID
											,@Estatus
											,@Estatus
											,@Usuario
											,@FechaEmision
											,@FechaRegistro
											,@MovF
											,@MovIDF
											,'VTAS.F'
											,@Ok OUTPUT
											,@OkRef OUTPUT
					END

				END

			END

		END

	END

	IF @Modulo = 'CXP'
	BEGIN
		SELECT @Mov = Mov
			  ,@Estatus = Estatus
		FROM Cxp
		WHERE ID = @ID

		IF @Mov = 'Acuerdo Proveedor'
			AND @Estatus = 'PENDIENTE'
			EXEC SP_DM0310MovFlujoAcuerdoProveedores @ID

	END

	IF @Modulo = 'CXP'
		AND @Accion = 'Cancelar'
	BEGIN
		SELECT @Mov = Mov
			  ,@Estatus = Estatus
			  ,@Origen = Origen
			  ,@OrigenIdPed = Origenid
		FROM Cxp
		WHERE ID = @ID

		IF @Mov = 'Acuerdo Proveedor'
			AND @Estatus = 'CANCELADO'
			UPDATE Cxp
			SET Situacion = 'Por Generar Acuerdo'
			WHERE Mov = @origen
			AND MovID = @OrigenIDPed

	END

	IF @Accion = 'Afectar'
		AND @Mov IN ('Factura', 'Factura VIU')
	BEGIN
		SELECT @IdSoporte = ReporteServicio
		FROM Venta
		WHERE ID = @ID

		IF @IdSoporte IS NOT NULL
		BEGIN
			UPDATE s
			SET ControlRepServ = 1
			FROM Soporte s
			WHERE s.ID = @IdSoporte
		END

	END

	IF @Accion = 'Afectar'
		AND @Mov IN ('Factura', 'Factura VIU')
	BEGIN
		SELECT @IdSoporte = ReporteServicio
		FROM Venta
		WHERE ID = @ID

		IF @IdSoporte IS NOT NULL
		BEGIN
			UPDATE s
			SET ControlRepServ = 1
			FROM Soporte s
			WHERE s.ID = @IdSoporte
		END

	END

	IF (@Mov = 'Factura'
		OR @Mov = 'Credilana'
		OR @Mov = 'Devolucion Venta')  --Valida mov para ejecutar sp que calcula monedero x Red DIMA
	BEGIN
		EXEC SpIDM0264_CalcMonederoDima @ID
	END
	/*---------------------------Devoluciones  para congelacion de monedero---------------------------*/

	IF @Modulo = 'CXC'
	BEGIN
		IF (SELECT
				COUNT(*)
			FROM Cxc WITH (NOLOCK)
			WHERE MOV IN ('Dev Anticipo Contado', 'Devolucion Enganche')
			AND Estatus = 'CONCLUIDO'
			AND ID = @ID)
			> 0
		BEGIN
			EXEC SpVTASConsultarIDVentaPorDevolucion @ID
		END
	END
	/*--------------------------------Fin de las devluciones monedero--------------------------------*/

	/*----------------------INICIO DM0358 APLICACION DE BONIFICACIONES EN ENGANCHES-------------------*/
	IF @Modulo = 'VTAS'
	BEGIN
		SELECT
			@Mov = Mov,
			@Estatus = Estatus
		FROM Venta WITH (NOLOCK)
		WHERE ID = @ID

		IF (@Mov = 'Factura'
			OR @Mov = 'Factura VIU')
			AND @Estatus = 'CONCLUIDO'
			EXEC SpCXCBonifXEnganche @ID,
																@Usuario
	END
	/*---------------------FIN DM0358 APLICACION DE BONIFICACIONES EN ENGANCHES-----------------------*/

	/*--------------------------------Periodo de Consolidación Dima Nuevo-----------------------------*/

	IF @Accion = 'Afectar'
		AND @Mov IN ('Factura', 'Credilana')
		AND @Estatus = 'CONCLUIDO'
		AND @CanalVenta = 76
	BEGIN
		SELECT
			@DiasPCDN = Numero
		FROM TablaNumD WITH (NOLOCK)
		WHERE TablaNum = 'DIAS PCDN'
		SELECT
			@FechaAsigVale = MIN(FECHA_ASIGNACION)
		FROM DM0244_FOLIOS_VALES WITH (NOLOCK)
		WHERE CUENTA = @Cte
		IF @FechaEmision <= DATEADD(DAY, @DiasPCDN, @FechaAsigVale)
		BEGIN
			UPDATE Venta WITH (ROWLOCK)
			SET VtaDIMANuevo = 1
			WHERE ID = @ID
		END
	END

	RETURN
END

