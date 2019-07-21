SET DATEFIRST 7    
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1  
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE [dbo].[spBonificacionDocRestantes]
 @Bonificacion VARCHAR(50)
,@EnCascada VARCHAR(5)
,@Origen VARCHAR(20)
,@OrigenId VARCHAR(20)
,@Idventa INT
,@lineaVta VARCHAR(50)
,@Sucursal INT
,@TipoSucursal VARCHAR(50)
,@Estacion INT
,@Uen INT
,@Condicion VARCHAR(50)
,@ImporteVenta FLOAT
,@Tipo VARCHAR(10)
,@idCxc INT
,@IdCoBro INT
,@MaxDiasAtrazo FLOAT
,@IdBonifica INT
,@StrBonifica VARCHAR(50)
,@BaseParaAPlicar FLOAT
,@Incluye CHAR(10)
,@MontoBonifPapa FLOAT
,@FechaEmisionBase DATETIME
AS
BEGIN
	DECLARE
		@Empresa VARCHAR(5)
	   ,@Mov VARCHAR(20)
	   ,@MovId VARCHAR(20)
	   ,@FechaEmision DATETIME
	   ,@Concepto VARCHAR(50)
	   ,@TipoCambio FLOAT
	   ,@ClienteEnviarA INT
	   ,@Vencimiento DATETIME
	   ,@Impuestos FLOAT
	   ,@Saldo FLOAT
	   ,@ImporteDocto FLOAT
	   ,@ImporteCasca FLOAT
	   ,@Referencia VARCHAR(50)
	   ,@Documento1de INT
	   ,@DocumentoTotal INT
	   ,@OrigenTipo VARCHAR(20)
	   ,@ExtraeD INT
	   ,@ExtraeA INT
	   ,@MovIdVenta VARCHAR(20)
	   ,@MovVenta VARCHAR(20)
	   ,@DiasMenoresA INT
	   ,@DiasMayoresA INT
	   ,@Id INT
	   ,@IdBonificacion INT
	   ,@Estatus VARCHAR(15)
	   ,@PorcBon1 FLOAT
	   ,@PorcBon1Bas FLOAT
	   ,@MontoBonif FLOAT
	   ,@Financiamiento FLOAT
	   ,@FechaIni DATETIME
	   ,@FechaFin DATETIME
	   ,@PagoTotal BIT
	   ,@ActVigencia BIT
	   ,@CascadaCalc BIT
	   ,@AplicaA CHAR(30)
	   ,@PlazoEjeFin INT
	   ,@VencimientoAntes INT
	   ,@VencimientoDesp INT
	   ,@DiasAtrazo INT
	   ,@Factor FLOAT
	   ,@MesesExced INT
	   ,@Linea FLOAT
	   ,@FechaCancelacion DATETIME
	   ,@FechaRegistro DATETIME
	   ,@Usuario VARCHAR(10)
	   ,@Ok INT
	   ,@OkRef VARCHAR(50)
	   ,@Periodo INT
	   ,@CharReferencia VARCHAR(20)
	   ,@NoPuedeAplicarSola BIT
	   ,@Ejercicio INT
	   ,@LineaCelulares FLOAT
	   ,@LineaCredilanas FLOAT
	   ,@ImporteVenta2 FLOAT
	   ,@LineaMotos VARCHAR(25)
	   ,@MesesAdelanto INT
	   ,@DVextra INT
	   ,@PorcBonextra FLOAT

	IF EXISTS (SELECT * FROM TEMPDB.SYS.SYSOBJECTS WHERE ID = OBJECT_ID('tempdb..#MovsPendientes') AND TYPE = 'U')
		DROP TABLE #MovsPendientes

	SELECT Id
		  ,Empresa
		  ,Mov
		  ,MovId
		  ,FechaEmision
		  ,Concepto
		  ,Estatus
		  ,ClienteEnviarA
		  ,Vencimiento
		  ,Importe
		  ,Impuestos
		  ,Saldo
		  ,Referencia
		  ,PadreMAVI
		  ,PadreIDMAVI
	INTO #MovsPendientes
	FROM CxcPendiente cp WITH (NOLOCK)
	WHERE cp.PadreMAVI = @Origen
	AND cp.PadreIDMAVI = @OrigenId
	AND NOT Referencia IS NULL
	AND cp.Estatus = 'PENDIENTE'
	UPDATE M
	SET Importe = Calc.Calculo
	   ,Impuestos = CAST(0.00 AS MONEY)
	FROM #MovsPendientes M WITH (NOLOCK)
	INNER JOIN (
		SELECT Importe = Doc.Importe + Doc.Impuestos
			  ,Documentos = Con.DANumeroDocumentos
			  ,Doc.PadreMAVI
			  ,Doc.PadreIDMAVI
			  ,Monedero = ISNULL(Mon.Abono, 0)
			  ,Calculo = (((Doc.Importe + Doc.Impuestos)) - ISNULL(Mon.Abono, 0)) / Con.DANumeroDocumentos
		FROM dbo.Cxc Doc WITH (NOLOCK)
		LEFT JOIN dbo.Condicion Con WITH (NOLOCK)
			ON Con.Condicion = Doc.Condicion
		LEFT JOIN dbo.AuxiliarP Mon WITH (NOLOCK)
			ON Mon.Mov = Doc.Mov
			AND Mon.MovID = Doc.MovID
			AND ISNULL(Mon.Abono, 0) > 0
		WHERE Doc.Mov = @Origen
		AND Doc.MovID = @OrigenId
		AND Doc.Estatus <> 'CANCELADO'
	) Calc
		ON Calc.PadreMAVI = M.PadreMAVI
		AND Calc.PadreIDMAVI = M.PadreIDMAVI
	SELECT @Ok = NULL
		  ,@OkRef = ''
		  ,@Ejercicio = YEAR(GETDATE())
		  ,@Periodo = MONTH(GETDATE())
		  ,@Mov = ''
		  ,@DiasMenoresA = 0
		  ,@DiasMayoresA = 0
		  ,@CharReferencia = 0
		  ,@ImporteCasca = 0.00
	SELECT @ImporteVenta2 = 0.00
	SELECT @Mov = Mov
	FROM CXC WITH (NOLOCK)
	WHERE Id = @IdCxc

	IF @Incluye = 'Incluye'
		SELECT @IdBonificacion = Id
			  ,@PorcBon1Bas = PorcBon1
			  ,@Financiamiento = Financiamiento
			  ,@FechaIni = FechaIni
			  ,@FechaFin = FechaFin
			  ,@PagoTotal = PagoTotal
			  ,@AplicaA = AplicaA
			  ,@PlazoEjeFin = PlazoEjeFin
			  ,@VencimientoAntes = VencimientoAntes
			  ,@VencimientoDesp = VencimientoDesp
			  ,@DiasAtrazo = DiasAtrazo
			  ,@DiasMenoresA = DiasMenoresA
			  ,@DiasMayoresA = DiasMayoresA
			  ,@Factor = Factor
			  ,@Linea = Linea
			  ,@NoPuedeAplicarSola = ISNULL(NoPuedeAplicarSola, 0)
		FROM (
			SELECT Id
				  ,PorcBon1
				  ,Financiamiento
				  ,FechaIni
				  ,FechaFin
				  ,PagoTotal
				  ,AplicaA
				  ,PlazoEjeFin
				  ,VencimientoAntes
				  ,VencimientoDesp
				  ,DiasAtrazo
				  ,DiasMenoresA
				  ,DiasMayoresA
				  ,Factor
				  ,Linea
				  ,NoPuedeAplicarSola
				  ,ROW_NUMBER() OVER (PARTITION BY Bonificacion ORDER BY id) perbonif
			FROM MaviBonificacionConf WITH (NOLOCK)
			JOIN MaviBonificacionMov bm WITH (NOLOCK)
				ON ID = bm.IDBonificacion
			WHERE Bonificacion = @Bonificacion
			AND Estatus = 'CONCLUIDO'
			AND FechaIni <= @FechaEmisionBase
			AND FechaFin >= @FechaEmisionBase
			AND bm.Movimiento = @Mov
		) Boni
		WHERE perbonif = 1

	SELECT @Mov = ''

	IF @Incluye <> 'Incluye'
		SELECT @IdBonificacion = Id
			  ,@PorcBon1bas = PorcBon1
			  ,@Financiamiento = Financiamiento
			  ,@FechaIni = FechaIni
			  ,@FechaFin = FechaFin
			  ,@PagoTotal = PagoTotal
			  ,@AplicaA = AplicaA
			  ,@PlazoEjeFin = PlazoEjeFin
			  ,@VencimientoAntes = VencimientoAntes
			  ,@VencimientoDesp = VencimientoDesp
			  ,@DiasAtrazo = DiasAtrazo
			  ,@DiasMenoresA = DiasMenoresA
			  ,@DiasMayoresA = DiasMayoresA
			  ,@Factor = Factor
			  ,@Linea = Linea
			  ,@NoPuedeAplicarSola = ISNULL(NoPuedeAplicarSola, 0)
		FROM MaviBonificacionConf WITH (NOLOCK)
		WHERE Bonificacion = @Bonificacion
		AND ID = @IdBonifica
		AND Estatus = 'CONCLUIDO'
		AND FechaIni <= @FechaEmisionBase
		AND FechaFin >= @FechaEmisionBase

	IF EXISTS (SELECT * FROM tempdb.sys.sysobjects WHERE id = OBJECT_ID('tempdb.dbo.#CrCxCPendientes') AND TYPE = 'U')
		DROP TABLE #CrCxCPendientes

	CREATE TABLE #CrCxCPendientes (
		Consec INT IDENTITY
	   ,IdCxC INT
	   ,Empresa VARCHAR(50)
	   ,Mov VARCHAR(30)
	   ,MovId VARCHAR(30)
	   ,FechaEmision DATETIME
	   ,ClienteEnviarA INT
	   ,Vencimiento DATETIME
	   ,ImporteDocto FLOAT
	   ,Impuestos FLOAT
	   ,Saldo FLOAT
	   ,Concepto VARCHAR(50) NULL
	   ,Referencia VARCHAR(50) NULL
	)

	IF @Tipo = 'Total'
		AND @NoPuedeAplicarSola = 0
	BEGIN
		INSERT INTO #CrCxCPendientes (IdCxC, Empresa, Mov, MovId, FechaEmision, ClienteEnviarA, Vencimiento, ImporteDocto, Impuestos,
		Saldo, Concepto, Referencia)
			SELECT Id
				  ,Empresa
				  ,Mov
				  ,MovId
				  ,FechaEmision
				  ,ClienteEnviarA
				  ,Vencimiento
				  ,Importe
				  ,Impuestos
				  ,Saldo
				  ,Concepto
				  ,Referencia
			FROM #MovsPendientes cp
			WHERE cp.PadreMAVI = @Origen
			AND cp.PadreIDMAVI = @OrigenId
			AND NOT Referencia IS NULL
			AND cp.Estatus = 'PENDIENTE'
			UNION
			SELECT cp.Id
				  ,cp.Empresa
				  ,cp.Mov
				  ,cp.MovId
				  ,cp.FechaEmision
				  ,cp.ClienteEnviarA
				  ,cp.Vencimiento
				  ,cp.Importe
				  ,cp.Impuestos
				  ,cp.Saldo
				  ,cp.Concepto
				  ,cp.Referencia
			FROM CxcPendiente cp WITH (NOLOCK)
			JOIN NegociaMoratoriosMAVI nmm WITH (NOLOCK)
				ON (cp.Mov = nmm.Mov AND cp.MovID = nmm.MovID)
			WHERE cp.PadreMAVI = @Origen
			AND cp.PadreIDMAVI = @OrigenId
			AND cp.Estatus = 'PENDIENTE'
			AND (nmm.Mov LIKE '%Nota Cargo%' OR nmm.Mov LIKE '%Contra Recibo%')
			AND nmm.IDCobro = @IdCoBro
	END
	ELSE

	IF ISNULL(@Tipo, '') <> 'Total'
		AND @NoPuedeAplicarSola = 0
	BEGIN
		INSERT INTO #CrCxCPendientes (IdCxC, Empresa, Mov, MovId, FechaEmision, ClienteEnviarA, Vencimiento, ImporteDocto, Impuestos,
		Saldo, Concepto, Referencia)
			SELECT Id
				  ,Empresa
				  ,Mov
				  ,MovId
				  ,FechaEmision
				  ,ClienteEnviarA
				  ,Vencimiento
				  ,Importe
				  ,Impuestos
				  ,Saldo
				  ,Concepto
				  ,Referencia
			FROM #MovsPendientes cp
			WHERE cp.PadreMAVI = @Origen
			AND cp.PadreIDMAVI = @OrigenId
			AND NOT Referencia IS NULL
			AND cp.Estatus = 'PENDIENTE'
			UNION
			SELECT cp.Id
				  ,cp.Empresa
				  ,cp.Mov
				  ,cp.MovId
				  ,cp.FechaEmision
				  ,cp.ClienteEnviarA
				  ,cp.Vencimiento
				  ,cp.Importe
				  ,cp.Impuestos
				  ,cp.Saldo
				  ,cp.Concepto
				  ,cp.Referencia
			FROM CxcPendiente cp WITH (NOLOCK)
			JOIN NegociaMoratoriosMAVI nmm WITH (NOLOCK)
				ON (cp.Mov = nmm.Mov AND cp.MovID = nmm.MovID)
			WHERE cp.PadreMAVI = @Origen
			AND cp.PadreIDMAVI = @OrigenId
			AND cp.Estatus = 'PENDIENTE'
			AND (nmm.Mov LIKE '%Nota Cargo%' OR nmm.Mov LIKE '%Contra Recibo%')
			AND nmm.IDCobro = @IdCoBro
	END

	SELECT @DVextra = MaxDV
		  ,@PorcBonextra = PorcBon
	FROM MaviBonificacionConVencimiento WITH (NOLOCK)
	WHERE IdBonificacion = @IdBonifica

	IF @NoPuedeAplicarSola = 1
	BEGIN
		INSERT INTO #CrCxCPendientes (IdCxC, Empresa, Mov, MovId, FechaEmision, ClienteEnviarA, Vencimiento, ImporteDocto, Impuestos,
		Saldo, Concepto, Referencia)
			SELECT TOP (1) Id
						  ,Empresa
						  ,Mov
						  ,MovId
						  ,FechaEmision
						  ,ClienteEnviarA
						  ,Vencimiento
						  ,Importe
						  ,Impuestos
						  ,Saldo
						  ,Concepto
						  ,Referencia
			FROM #MovsPendientes cp
			WHERE cp.PadreMAVI = @Origen
			AND cp.PadreIDMAVI = @OrigenId
			AND NOT Referencia IS NULL
			AND cp.Estatus = 'PENDIENTE'
	END

	IF @IDBonificacion IS NOT NULL
	BEGIN
		DECLARE
			@totreg INT
		   ,@recorre INT
		SELECT @totreg = MAX(Consec)
			  ,@recorre = 1
		FROM #CrCxCPendientes
		WHILE @recorre <= @totreg
		BEGIN
		SELECT @IdCxC = IdCxC
			  ,@Empresa = Empresa
			  ,@Mov = Mov
			  ,@MovId = MovId
			  ,@FechaEmision = FechaEmision
			  ,@Concepto = Concepto
			  ,@ClienteEnviarA = ClienteEnviarA
			  ,@Vencimiento = Vencimiento
			  ,@ImporteDocto = ImporteDocto
			  ,@Impuestos = Impuestos
			  ,@Saldo = Saldo
			  ,@Concepto = Concepto
			  ,@Referencia = Referencia
		FROM #CrCxCPendientes
		WHERE Consec = @recorre
		SELECT @ImporteDocto = @ImporteDocto + ISNULL(@Impuestos, 0.00)
			  ,@PorcBon1 = @PorcBon1Bas
			  ,@Ok = NULL
			  ,@OkRef = ''

		IF @Mov LIKE '%Nota Cargo%'
		BEGIN

			IF ISNULL(@Concepto, '') NOT LIKE 'CANC COBRO%'
				SELECT @Ok = 1
					  ,@OkRef = 'La Nota No Pertenece a un Concepto para Bonificaci�n'

		END

		IF PATINDEX('%/%', @Referencia) > 0
		BEGIN
			SELECT @ExtraeD = PATINDEX('%(%', @Referencia)
				  ,@ExtraeA = PATINDEX('%/%', @Referencia)
			SELECT @Documento1de = SUBSTRING(@Referencia, @ExtraeD + 1, @ExtraeA - @ExtraeD - 1)
			SELECT @ExtraeD = PATINDEX('%/%', @Referencia)
				  ,@ExtraeA = PATINDEX('%)%', @Referencia)
			SELECT @DocumentoTotal = SUBSTRING(@Referencia, @ExtraeD + 1, @ExtraeA - @ExtraeD - 1)
		END

		IF @VencimientoAntes <> 0
			AND (NOT @Mov LIKE '%Nota Cargo%' OR NOT @Mov LIKE '%Contra%')
		BEGIN
			SET @CharReferencia = RTRIM(@VencimientoAntes) + '/' + RTRIM(@DocumentoTotal)

			IF NOT EXISTS (SELECT ID FROM CxcPendiente WITH (NOLOCK) WHERE PadreMAVI = @Origen AND PadreIDMAVI = @OrigenId AND Estatus = 'PENDIENTE' AND referencia LIKE '%' + @CharReferencia + '%')
				SELECT @Ok = 1
					  ,@OkRef = 'Excede el N�mero M�nimo del Pago a jalar'

		END

		IF @VencimientoDesp <= @Documento1de
			AND @VencimientoDesp <> 0
			AND (NOT @Mov LIKE '%Nota Cargo%' OR NOT @Mov LIKE '%Contra%')
		BEGIN
			SET @CharReferencia = RTRIM(@Documento1de) + '/' + RTRIM(@DocumentoTotal)

			IF NOT EXISTS (SELECT ID FROM CxcPendiente WITH (NOLOCK) WHERE PadreMAVI = @Origen AND PadreIDMAVI = @OrigenID AND Estatus = 'PENDIENTE' AND referencia LIKE '%' + @CharReferencia + '%')
				SELECT @Ok = 1
					  ,@OkRef = 'Excede el Numero Maximo del Pago a jalar'

		END

		IF @DiasAtrazo <> 0
			AND @Mov <> 'Nota Cargo'
		BEGIN

			IF @MaxDiasAtrazo > @DiasAtrazo
				SELECT @Ok = 1
					  ,@OkRef = 'Excede el n�mero de dias de atraso permitidos '

		END

		IF @DiasMenoresA <> 0
			AND @Bonificacion NOT LIKE '%Contado Comercial%'
		BEGIN

			IF @DiasMenoresA < DATEDIFF(DAY, @FechaEmision, GETDATE())
				SELECT @Ok = 1
					  ,@OkRef = 'Excede d�as menores' + CONVERT(CHAR(30), @DiasMenoresA)

		END

		IF @DiasMayoresA <> 0
			AND @Bonificacion NOT LIKE '%Contado Comercial%'
		BEGIN

			IF @DiasMayoresA > DATEDIFF(DAY, @FechaEmision, GETDATE())
				SELECT @Ok = 1
					  ,@OkRef = 'Excede d�as mayores' + CONVERT(CHAR(30), @DiasMayoresA)

		END

		IF @VencimientoDesp <> 0
		BEGIN
			SET @CharReferencia = '(' + RTRIM(@VencimientoDesp) + '/' + RTRIM(@DocumentoTotal)

			IF dbo.fnFechaSinHora(GETDATE()) <= dbo.fnFechaSinHora((
					SELECT c.Vencimiento
					FROM Cxc c WITH (NOLOCK)
					WHERE c.Origen = @Origen
					AND c.OrigenID = @OrigenId
					AND c.Referencia LIKE '%' + @CharReferencia + '%'
				)
				)
				SELECT @Ok = 1
					  ,@OkRef = 'No cumple con el l�mite de pago posterior2'

		END

		IF @PorcBon1 = 0
			AND @Linea <> 0
			SELECT @PorcBon1 = @Linea

		IF @Linea < (
				SELECT ISNULL(PorcLin, 0.00)
				FROM MaviBonificacionLinea WITH (NOLOCK)
				WHERE IdBonificacion = @id
				AND Linea = @LineaVta
			)
			SELECT @Linea = (
				 SELECT ISNULL(PorcLin, 0.00)
				 FROM MaviBonificacionLinea WITH (NOLOCK)
				 WHERE IdBonificacion = @id
				 AND Linea = @LineaVta
			 )

		SELECT @LineaCredilanas = ISNULL(PorcLin, 0.00)
		FROM MaviBonificacionLinea mbl WITH (NOLOCK)
		WHERE Linea LIKE '%Credilana%'
		AND IdBonificacion = @IdBonificacion
		SELECT @LineaCelulares = ISNULL(PorcLin, 0.00)
		FROM MaviBonificacionLinea mbl WITH (NOLOCK)
		WHERE Linea LIKE '%Celular%'
		AND IdBonificacion = @IdBonificacion
		SELECT @LineaMotos = ISNULL(PorcLin, 0.00)
		FROM MaviBonificacionLinea mbl WITH (NOLOCK)
		WHERE Linea LIKE '%MOTOCICLETA%'
		AND IdBonificacion = @IdBonificacion

		IF EXISTS (SELECT IdBonificacion FROM MaviBonificacionCanalVta BonCan WITH (NOLOCK) WHERE BonCan.IdBonificacion = @IdBonificacion)
		BEGIN

			IF NOT EXISTS (SELECT IdBonificacion FROM MaviBonificacionCanalVta BonCan WITH (NOLOCK) WHERE CONVERT(VARCHAR(10), BonCan.CanalVenta) = @ClienteEnviarA AND BonCan.IdBonificacion = @IdBonificacion)
				SELECT @Ok = 1
					  ,@OkRef = 'Venta de Canal No Configurada Para esta Bonificaci�n'

		END

		IF EXISTS (SELECT IdBonificacion FROM MaviBonificacionUEN mbu WITH (NOLOCK) WHERE mbu.idBonificacion = @IdBonificacion)
		BEGIN

			IF NOT @UEN IS NULL
				AND NOT EXISTS (SELECT IdBonificacion FROM MaviBonificacionUEN mbu WITH (NOLOCK) WHERE mbu.UEN = @UEN AND mbu.idBonificacion = @IdBonificacion)
				SELECT @Ok = 1
					  ,@OkRef = 'UEN No Configurada Para este Caso'

		END

		IF EXISTS (SELECT IdBonificacion FROM MaviBonificacionCondicion WITH (NOLOCK) WHERE IdBonificacion = @IdBonificacion)
		BEGIN

			IF NOT EXISTS (SELECT IdBonificacion FROM MaviBonificacionCondicion WITH (NOLOCK) WHERE COndicion = @Condicion AND IdBonificacion = @IdBonificacion)
				SELECT @Ok = 1
					  ,@OkRef = 'Condicion No Configurada Para esta Bonificaci�n'

		END

		IF EXISTS (SELECT IdBonificacion FROM MaviBonificacionExcluye Exc WITH (NOLOCK) WHERE BonificacionNo = @Bonificacion)
		BEGIN

			IF EXISTS (SELECT BonTest.IdBonificacion FROM MaviBonificacionTest BonTest WITH (NOLOCK) JOIN MaviBonificacionExcluye Exc WITH (NOLOCK) ON (Bontest.IdBonificacion = Exc.IdBonificacion) WHERE Exc.BonificacionNo = @Bonificacion AND Bontest.OkRef = '' AND BonTest.MontoBonif > 0 AND idcobro = @IdCoBro AND Origen = @Origen AND OrigenId = @OrigenId)
				SELECT @Ok = 1
					  ,@OkRef = 'Excluye esta Bonificacion Una anterior Detalle'

		END

		IF EXISTS (SELECT IdBonificacion FROM MaviBonificacionSucursal Exc WITH (NOLOCK) WHERE IdBonificacion = @IdBonificacion)
		BEGIN

			IF NOT @TipoSucursal IS NULL
				AND NOT EXISTS (SELECT IdBonificacion FROM MaviBonificacionSucursal WITH (NOLOCK) WHERE Sucursal = @TipoSucursal AND idBonificacion = @IdBonificacion)
				SELECT @Ok = 1
					  ,@OkRef = 'Bonificaci�n No Configurada Para este tipo de Sucursal'

		END

		IF NOT EXISTS (SELECT IdBonificacion FROM MaviBonificacionTest WITH (NOLOCK) WHERE idBonificacion = RTRIM(@IdBonificacion) AND Docto = @IdCxC AND Estacion = @Estacion AND MontoBonif = @MontoBonif)
		BEGIN

			IF @AplicaA = 'Importe de Factura'
			BEGIN

				IF @Linea <> 0
					SELECT @PorcBon1 = @Linea

				IF @LineaCelulares <> 0
					AND @Bonificacion NOT LIKE '%Contado%'
					AND @Bonificacion NOT LIKE '%Atraso%'
					SELECT @PorcBon1 = @LineaCelulares

				IF @LineaCredilanas <> 0
					AND @Bonificacion NOT LIKE '%Contado%'
					AND @Bonificacion NOT LIKE '%Atraso%'
					SELECT @PorcBon1 = @LineaCredilanas

				IF @EnCascada = 'Si'
					SELECT @ImporteVenta2 = @ImporteVenta - @MontoBonifPapa

				IF @EnCascada <> 'Si'
					SELECT @ImporteVenta2 = @ImporteVenta

				SELECT @MontoBonif = (@PorcBon1 / 100) * @ImporteVenta2
			END

			IF @Bonificacion LIKE '%Adelanto%'
				AND @Tipo = 'Total'
			BEGIN

				IF @Linea <> 0
					SELECT @PorcBon1 = @Linea

				IF ISNULL(@LineaCelulares, 0) <> 0
					AND @lineaVta LIKE '%CELULAR%'
					SELECT @PorcBon1 = @LineaCelulares

				IF ISNULL(@LineaCredilanas, 0) <> 0
					AND @lineaVta LIKE '%CREDILA%'
					SELECT @PorcBon1 = @LineaCredilanas

				IF @Bonificacion LIKE '%Contado%'
					SELECT @PorcBon1 = @LineaMotos

				IF @EnCascada = 'Si'
					SELECT @ImporteVenta2 = @ImporteVenta - @MontoBonifPapa

				IF @EnCascada <> 'Si'
					SELECT @ImporteVenta2 = @ImporteVenta

				SELECT @MesesAdelanto = COUNT(ID)
				FROM Cxc WITH (NOLOCK)
				WHERE PadreMAVI = @Origen
				AND PadreIDMAVI = @OrigenId
				AND PadreMAVI <> Mov
				AND Vencimiento > GETDATE()

				IF @MesesAdelanto > @DocumentoTotal
					SELECT @MesesAdelanto = @DocumentoTotal

				SELECT @PorcBon1 = @PorcBon1 * @MesesAdelanto
				SELECT @ImporteVenta2 = (@ImporteVenta2 / @DocumentoTotal) * @MesesAdelanto
				SELECT @ImporteVenta2 = @ImporteVenta2 / (
					 SELECT COUNT(ID)
					 FROM (
						 SELECT Id
							   ,Empresa
							   ,Mov
							   ,MovId
							   ,FechaEmision
							   ,Concepto
							   ,ClienteEnviarA
							   ,Vencimiento
							   ,Importe
							   ,Impuestos
							   ,Saldo
							   ,Referencia
						 FROM Cxc cp WITH (NOLOCK)
						 WHERE cp.PadreMAVI = @Origen
						 AND cp.PadreIDMAVI = @OrigenId
						 AND NOT Referencia IS NULL
						 AND cp.Estatus = 'PENDIENTE'
						 UNION
						 SELECT cp.Id
							   ,cp.Empresa
							   ,cp.Mov
							   ,cp.MovId
							   ,cp.FechaEmision
							   ,cp.Concepto
							   ,cp.ClienteEnviarA
							   ,cp.Vencimiento
							   ,cp.Importe
							   ,cp.Impuestos
							   ,cp.Saldo
							   ,cp.Referencia
						 FROM CxcPendiente cp WITH (NOLOCK)
						 JOIN NegociaMoratoriosMAVI nmm WITH (NOLOCK)
							 ON (cp.Mov = nmm.Mov AND cp.MovID = nmm.MovID)
						 WHERE cp.PadreMAVI = @Origen
						 AND cp.PadreIDMAVI = @OrigenId
						 AND cp.Estatus = 'PENDIENTE'
						 AND (nmm.Mov LIKE '%Nota Cargo%' OR nmm.Mov LIKE '%Contra Recibo%')
						 AND nmm.IDCobro = @IdCoBro
					 ) x
				 )
			END

			IF @AplicaA <> 'Importe de Factura'
				AND @Bonificacion <> 'Bonificacion Pago Puntual'
				SELECT @MontoBonif = (@PorcBon1 / 100) * @ImporteVenta2

			IF @AplicaA <> 'Importe de Factura'
				AND @Bonificacion = 'Bonificacion Pago Puntual'
				SELECT @MontoBonif = (@PorcBon1 / 100) * @ImporteDocto

			IF NOT @Ok IS NULL
				SELECT @MontoBonif = 0.00
					  ,@PorcBon1 = 0.00

			IF @Bonificacion LIKE '%Puntual%'
				AND (dbo.fnFechaSinHora(GETDATE()) > (dbo.fnFechaSinHora(@Vencimiento)))
			BEGIN

				IF (
						SELECT DV = DATEDIFF(dd, @Vencimiento, CONVERT(DATETIME, CONVERT(VARCHAR(10), GETDATE(), 10)))
					)
					<= @DVextra
					SELECT @PorcBon1 = @PorcBonextra
						  ,@MontoBonif = (@PorcBonextra / 100) * @ImporteDocto
				ELSE
					SELECT @Ok = 1
						  ,@OkRef = 'Excede el vencimiento'
						  ,@MontoBonif = 0.00
						  ,@PorcBon1 = 0.00

			END

			IF @Bonificacion LIKE '%Adelanto%'
				AND dbo.fnFechaSinHora(GETDATE()) >= dbo.fnFechaSinHora(@Vencimiento)
				SELECT @MontoBonif = 0.00
					  ,@PorcBon1 = 0.00
					  ,@Ok = 1
					  ,@OkRef = 'Por el Vencimiento del Docto'

			IF @Bonificacion LIKE '%Adelanto%'
				AND @Tipo <> 'Total'
				SELECT @MontoBonif = 0.00
					  ,@PorcBon1 = 0.00
					  ,@Ok = 1
					  ,@OkRef = 'Adelanto Aplica a puro Total'

			IF @Bonificacion LIKE '%Atraso%'
				AND @Tipo <> 'Total'
				SELECT @MontoBonif = 0.00
					  ,@PorcBon1 = 0.00

			IF @Bonificacion LIKE '%Atraso%'
				AND @Tipo <> 'Total'
				SELECT @BaseParaAPlicar = @BaseParaAPlicar - @MontoBonifPapa

			IF @Bonificacion LIKE '%Atraso%'
				SELECT @BaseParaAPlicar = @ImporteVenta2

			IF @Bonificacion LIKE '%Puntual%'
				SELECT @BaseParaAPlicar = @ImporteDocto

			INSERT MaviBonificacionTest (idBonificacion, IdCoBro, Docto, Bonificacion, Estacion, Documento1de, DocumentoTotal, Mov, MovId, Origen, OrigenId, ImporteVenta, ImporteDocto, MontoBonif, TipoSucursal, LineaVta, IdVenta, UEN, Condicion, PorcBon1,
			Financiamiento, Ok, OkRef, Factor, Sucursal1, PlazoEjeFin, FechaEmision, Vencimiento, LineaCelulares, LineaCredilanas, DiasMenoresA, DiasMayoresA, BaseParaAPlicar)
				VALUES (@IdBonificacion, @IdCoBro, @IdCxC, ISNULL(@Bonificacion, ''), @Estacion, ISNULL(@Documento1de, 0), ISNULL(@DocumentoTotal, 0), ISNULL(@Mov, ''), ISNULL(@MovId, ''), ISNULL(@Origen, ''), ISNULL(@OrigenId, ''), ROUND(ISNULL(@ImporteVenta, 0.00), 2), ROUND(ISNULL(@ImporteDocto, 0.00), 2), ROUND(ISNULL(@MontoBonif, 0.00), 2), ISNULL(@TipoSucursal, ''), ISNULL(@LineaVta, ''), ISNULL(@IdVenta, 0), ISNULL(@UEN, 0), ISNULL(@Condicion, ''), ISNULL(@PorcBon1, 0.00), ISNULL(@Financiamiento, 0.00), ISNULL(@Ok, 0), ISNULL(@OkRef, ''), ISNULL(@factor, 0.00), @Sucursal, @PlazoEjeFin, @FechaEmision, @Vencimiento, ISNULL(@LineaCelulares, 0.00), ISNULL(@LineaCredilanas, 0.00), @DiasMenoresA, @DiasMayoresA, ROUND(ISNULL(@BaseParaAPlicar, 0.00), 2))
		END

		SET @recorre = @recorre + 1
		END
	END

	IF EXISTS (SELECT * FROM TEMPDB.SYS.SYSOBJECTS WHERE ID = OBJECT_ID('tempdb..#MovsPendientes') AND TYPE = 'U')
		DROP TABLE #MovsPendientes

	IF EXISTS (SELECT * FROM tempdb.sys.sysobjects WHERE id = OBJECT_ID('tempdb.dbo.#CrCxCPendientes') AND TYPE = 'U')
		DROP TABLE #CrCxCPendientes

END

