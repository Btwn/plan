SET DATEFIRST 7    
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1  
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE [dbo].[spBonificacionesCalculaTabla]
 @IdCxC INT
,@Estacion INT = 1
,@Tipo CHAR(10)
,@IdCobro INT
AS
BEGIN
	DECLARE
		@Empresa VARCHAR(5)
	   ,@Mov VARCHAR(20)
	   ,@MovId VARCHAR(20)
	   ,@FechaEmision DATETIME
	   ,@Concepto VARCHAR(50)
	   ,@UEN INT
	   ,@TipoCambio FLOAT
	   ,@ClienteEnviarA INT
	   ,@Condicion VARCHAR(50)
	   ,@Vencimiento DATETIME
	   ,@ImporteVenta FLOAT
	   ,@ImporteDocto FLOAT
	   ,@ImporteCasca FLOAT
	   ,@Impuestos FLOAT
	   ,@Saldo FLOAT
	   ,@Referencia VARCHAR(50)
	   ,@Documento1de INT
	   ,@DocumentoTotal INT
	   ,@OrigenTipo VARCHAR(20)
	   ,@Origen VARCHAR(20)
	   ,@OrigenId VARCHAR(20)
	   ,@Sucursal INT
	   ,@TipoSucursal VARCHAR(50)
	   ,@ExtraeD INT
	   ,@ExtraeA INT
	   ,@IdVenta INT
	   ,@MovIdVenta VARCHAR(20)
	   ,@MovVenta VARCHAR(20)
	   ,@LineaVta VARCHAR(50)
	   ,@MaxDiasAtrazo FLOAT
	   ,@DiasMenoresA INT
	   ,@DiasMayoresA INT
	   ,@Id INT
	   ,@Bonificacion VARCHAR(50)
	   ,@Estatus VARCHAR(15)
	   ,@PorcBon1 FLOAT
	   ,@MontoBonif FLOAT
	   ,@Financiamiento FLOAT
	   ,@FechaIni DATETIME
	   ,@FechaFin DATETIME
	   ,@PagoTotal BIT
	   ,@ActVigencia BIT
	   ,@CascadaCalc BIT
	   ,@AplicaA CHAR(30)
	   ,@PlazoEjeFin INT
	   ,@VAlBonif FLOAT
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
	   ,@Ejercicio INT
	   ,@BonificHijo VARCHAR(50)
	   ,@BonificHijoCascad VARCHAR(5)
	   ,@Refinan VARCHAR(5)
	   ,@LineaCelulares FLOAT
	   ,@DiasVencimiento INT
	   ,@LineaCredilanas FLOAT
	   ,@BaseParaAplicar FLOAT
	   ,@PadreMavi VARCHAR(20)
	   ,@PadreMaviID VARCHAR(20)
	   ,@EsOrigenNulo INT
	   ,@LineaMotos FLOAT
	   ,@LineaBonif VARCHAR(25)
	   ,@FechaEmisionFact DATETIME
	SELECT @OkRef = ''
		  ,@Ejercicio = YEAR(GETDATE())
		  ,@Periodo = MONTH(GETDATE())
		  ,@MaxDiasAtrazo = 0.00
		  ,@Mov = ''
		  ,@DiasMenoresA = 0
		  ,@DiasMayoresA = 0
	SELECT @CharReferencia = 0
		  ,@ImporteVenta = 0.00
		  ,@ImporteDocto = 0.00
		  ,@MesesExced = 0
		  ,@ImporteCasca = 0.00
		  ,@BaseParaAplicar = 0.00
		  ,@EsOrigenNulo = 0

	IF @IdCobro = NULL
		SELECT @IdCobro = 0

	SELECT @Empresa = c.Empresa
		  ,@Mov = c.Mov
		  ,@MovId = c.MovId
		  ,@FechaEmision = c.FechaEmision
		  ,@Concepto = c.Concepto
		  ,@UEN = c.UEN
		  ,@FechaEmisionFact = c.fechaemision
		  ,@TipoCambio = c.TipoCambio
		  ,@ClienteEnviarA = c.ClienteEnviarA
		  ,@Condicion = c.Condicion
		  ,@Vencimiento = c.Vencimiento
		  ,@ImporteDocto = c.Importe + c.Impuestos
		  ,@Impuestos = c.Impuestos
		  ,@Saldo = c.Saldo
		  ,@Vencimiento = c.Vencimiento
		  ,@Concepto = c.Concepto
		  ,@Referencia = ISNULL(c.ReferenciaMAvi, c.Referencia)
		  ,@OrigenTipo = c.OrigenTipo
		  ,@Origen = c.Origen
		  ,@OrigenId = c.OrigenId
		  ,@Sucursal = c.SucursalOrigen
		  ,@MaxDiasAtrazo = ISNULL(cm.MaxDiasVencidosMAVI, 0.00)
		  ,@PadreMavi = c.PadreMAVI
		  ,@PadreMaviID = c.PadreIDMAVI
	FROM CXC c
	LEFT JOIN CXCMAVI cm
		ON cm.id = c.id
	WHERE c.Id = @IdCxC

	IF @origen IS NULL
	BEGIN
		SELECT @Empresa = c.Empresa
			  ,@Mov = c.Mov
			  ,@MovId = c.MovId
			  ,@FechaEmision = c.FechaEmision
			  ,@Concepto = c.Concepto
			  ,@UEN = c.UEN
			  ,@TipoCambio = c.TipoCambio
			  ,@ClienteEnviarA = c.ClienteEnviarA
			  ,@Condicion = c.Condicion
			  ,@Vencimiento = c.Vencimiento
			  ,@ImporteDocto = c.Importe + c.Impuestos
			  ,@Impuestos = c.Impuestos
			  ,@Saldo = c.Saldo
			  ,@Vencimiento = c.Vencimiento
			  ,@Concepto = c.Concepto
			  ,@Referencia = ISNULL(c.ReferenciaMAvi, c.Referencia)
			  ,@OrigenTipo = c.OrigenTipo
			  ,@Origen = c.Origen
			  ,@OrigenId = c.OrigenId
			  ,@Sucursal = c.SucursalOrigen
			  ,@MaxDiasAtrazo = ISNULL(cm.MaxDiasVencidosMAVI, 0.00)
		FROM CXC c
		LEFT JOIN CXCMAVI cm
			ON cm.id = c.id
		WHERE c.Mov = @Mov
		AND c.Movid = @MovId
		SELECT @Origen = @Mov
			  ,@OrigenId = @MovId
		SELECT @EsOrigenNulo = 1
		SELECT TOP (1) @LineaVta = Linea
					  ,@ImporteVenta = PrecioToTal
					  ,@Sucursal = SucursalVenta
		FROM BonifSIMAVI
		WHERE IDCxc = @idcxc
	END

	DELETE MaviBonificacionTest
	WHERE Origen = @PadreMavi
		AND OrigenId = @PadreMaviID

	IF @Referencia IS NULL
		OR RTRIM(@Referencia) = ''
		OR NOT @Referencia LIKE '%/%'
	BEGIN
		SELECT TOP (1) @Referencia = Referencia
		FROM Cxc
		WHERE PadreMavi = @Mov
		AND PadreIDMAVI = @MovID
		AND Mov = 'Documento'
		ORDER BY MovID
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

	EXEC spMAviBuscaCxCVentaBonif @MovID
								 ,@Mov
								 ,@MovIdVenta OUTPUT
								 ,@MovVenta OUTPUT
								 ,@IdVenta OUTPUT

	IF @importeventa IS NULL
		SELECT TOP (1) @LineaVta = Linea
					  ,@ImporteVenta = PrecioToTal
					  ,@Sucursal = SucursalVenta
		FROM BonifSIMAVI
		WHERE IDCxc = @IdVenta

	IF @Mov LIKE '%Refinan%'
		SELECT @Refinan = 'Ok'
			  ,@ImporteVenta = Importe + Impuestos
		FROM Cxc
		WHERE Mov = @Mov
		AND MovID = @MovID

	IF @Refinan IS NULL
		OR @LineaVta IS NULL
	BEGIN
		SELECT @LineaVta = ISNULL(A.Linea, '')
		FROM venta
			,ventad
			 LEFT OUTER JOIN Art a
				 ON a.Articulo = ventad.Articulo
		WHERE venta.id = ventad.id
		AND venta.id = @IdVenta

		IF @ImporteVenta IS NULL
			OR @ImporteVenta = 0
			SELECT @ImporteVenta = PrecioToTal
			FROM Venta
			WHERE Id = @IdVenta

	END
	ELSE
	BEGIN
		SELECT @Sucursal = 39
			  ,@LineaVta = ''
		SELECT @ImporteVenta = Importe
		FROM Cxc
		WHERE id = @IdVenta
	END

	SELECT @TipoSucursal = SucursalTipo.Tipo
	FROM Sucursal
		,SucursalTipo
	WHERE Sucursal.Tipo = SucursalTipo.Tipo
	AND Sucursal.Sucursal = @Sucursal

	IF EXISTS (SELECT SolC.FechaEmision FROM Venta Fac INNER JOIN Venta Ped ON Fac.Origen = Ped.Mov AND Fac.OrigenID = Ped.MovID INNER JOIN Venta AnaC ON Ped.Origen = AnaC.Mov AND Ped.OrigenID = AnaC.MovID INNER JOIN Venta SolC ON AnaC.Origen = SolC.Mov AND AnaC.OrigenID = SolC.MovID WHERE Fac.Mov = @Mov AND Fac.MovID = @MovID)
	BEGIN
		SELECT @FechaEmision = SolC.FechaEmision
		FROM Venta Fac
		INNER JOIN Venta Ped
			ON Fac.Origen = Ped.Mov
			AND Fac.OrigenID = Ped.MovID
		INNER JOIN Venta AnaC
			ON Ped.Origen = AnaC.Mov
			AND Ped.OrigenID = AnaC.MovID
		INNER JOIN Venta SolC
			ON AnaC.Origen = SolC.Mov
			AND AnaC.OrigenID = SolC.MovID
		WHERE Fac.Mov = @Mov
		AND Fac.MovID = @MovID
	END

	SELECT @ImporteVenta = (((Doc.Importe + Doc.Impuestos)) - ISNULL(Mon.Abono, 0))
	FROM dbo.Cxc Doc
	LEFT JOIN dbo.Condicion Con
		ON Con.Condicion = Doc.Condicion
	LEFT JOIN dbo.AuxiliarP Mon
		ON Mon.Mov = Doc.Mov
		AND Mon.MovID = Doc.MovID
		AND ISNULL(Mon.Abono, 0) > 0
	WHERE Doc.Mov = @Mov
	AND Doc.MovID = @MovID

	IF EXISTS (SELECT * FROM tempdb.sys.sysobjects WHERE id = OBJECT_ID('tempdb.dbo.#CrBonifAplicar') AND TYPE = 'U')
		DROP TABLE #CrBonifAplicar

	CREATE TABLE #CrBonifAplicar (
		reg INT IDENTITY
	   ,Id INT
	   ,Bonificacion VARCHAR(100)
	   ,PorcBon1 FLOAT NULL
	   ,Financiamiento FLOAT NULL
	   ,FechaIni DATETIME
	   ,FechaFin DATETIME
	   ,PagoTotal BIT
	   ,ActVigencia BIT
	   ,AplicaA VARCHAR(30) NULL
	   ,PlazoEjeFin INT
	   ,VencimientoAntes INT NULL
	   ,VencimientoDesp INT NULL
	   ,DiasAtrazo INT NULL
	   ,DiasMenoresA INT NULL
	   ,DiasMayoresA INT NULL
	   ,Factor FLOAT NULL
	   ,Linea FLOAT NULL
	   ,FechaCancelacion DATETIME NULL
	   ,FechaRegistro DATETIME NULL
	   ,Usuario VARCHAR(10) NULL
	   ,LineaBonif VARCHAR(50) NULL
	)

	IF @Tipo = 'Total'
	BEGIN
		INSERT INTO #CrBonifAplicar (Id, Bonificacion, PorcBon1, Financiamiento, FechaIni, FechaFin, PagoTotal, ActVigencia, AplicaA, PlazoEjeFin, VencimientoAntes
		, VencimientoDesp, DiasAtrazo, DiasMenoresA, DiasMayoresA, Factor, Linea, FechaCancelacion, FechaRegistro, Usuario, LineaBonif)
			SELECT mbc.Id
				  ,mbc.Bonificacion
				  ,mbc.PorcBon1
				  ,mbc.Financiamiento
				  ,mbc.FechaIni
				  ,mbc.FechaFin
				  ,mbc.PagoTotal
				  ,mbc.ActVigencia
				  ,mbc.AplicaA
				  ,mbc.PlazoEjeFin
				  ,VencimientoAntes = ISNULL(mbc.VencimientoAntes, 0)
				  ,VencimientoDesp = ISNULL(mbc.VencimientoDesp, 0)
				  ,DiasAtrazo = ISNULL(mbc.DiasAtrazo, 0)
				  ,DiasMenoresA = ISNULL(mbc.DiasMenoresA, 0)
				  ,DiasMayoresA = ISNULL(mbc.DiasMayoresA, 0)
				  ,mbc.Factor
				  ,Linea = ISNULL(mbc.Linea, 0.00)
				  ,mbc.FechaCancelacion
				  ,mbc.FechaRegistro
				  ,mbc.Usuario
				  ,mbl.Linea
			FROM MaviBonificacionConf mbc
			INNER JOIN MaviBonificacionMoV mbmv
				ON mbc.Id = mbmv.IdBonificacion
			INNER JOIN dbo.MaviBonificacionCondicion mbc2
				ON mbc2.IdBonificacion = mbc.ID
			LEFT JOIN dbo.MaviBonificacionLinea mbl
				ON mbl.IdBonificacion = mbc.ID
			WHERE mbmv.Movimiento = @Mov
			AND COndicion = @Condicion
			AND mbc.Estatus = 'CONCLUIDO'
			AND @FechaEmision BETWEEN mbc.FechaIni AND mbc.FechaFin
			AND mbc.NoPuedeAplicarSola = 0
			ORDER BY mbc.Orden DESC
	END
	ELSE
	BEGIN
		INSERT INTO #CrBonifAplicar (Id, Bonificacion, PorcBon1, Financiamiento, FechaIni, FechaFin, PagoTotal, ActVigencia, AplicaA, PlazoEjeFin, VencimientoAntes
		, VencimientoDesp, DiasAtrazo, DiasMenoresA, DiasMayoresA, Factor, Linea, FechaCancelacion, FechaRegistro, Usuario, LineaBonif)
			SELECT mbc.Id
				  ,mbc.Bonificacion
				  ,mbc.PorcBon1
				  ,mbc.Financiamiento
				  ,mbc.FechaIni
				  ,mbc.FechaFin
				  ,mbc.PagoTotal
				  ,mbc.ActVigencia
				  ,mbc.AplicaA
				  ,mbc.PlazoEjeFin
				  ,ISNULL(mbc.VencimientoAntes, 0)
				  ,ISNULL(mbc.VencimientoDesp, 0)
				  ,ISNULL(mbc.DiasAtrazo, 0)
				  ,ISNULL(mbc.DiasMenoresA, 0)
				  ,ISNULL(mbc.DiasMayoresA, 0)
				  ,mbc.Factor
				  ,ISNULL(mbc.Linea, 0.00)
				  ,mbc.FechaCancelacion
				  ,mbc.FechaRegistro
				  ,mbc.Usuario
				  ,NULL
			FROM MaviBonificacionConf mbc
			INNER JOIN MaviBonificacionMoV mbmv
				ON mbc.Id = mbmv.IdBonificacion
			INNER JOIN dbo.MaviBonificacionCondicion mbc2
				ON mbc2.IdBonificacion = mbc.ID
			WHERE mbmv.Movimiento = @Mov
			AND COndicion = @Condicion
			AND mbc.Estatus = 'CONCLUIDO'
			AND @FechaEmision BETWEEN mbc.FechaIni AND mbc.FechaFin
			AND mbc.NoPuedeAplicarSola = 0
			AND NOT mbc.Bonificacion LIKE '%Contado Comercial%'
			ORDER BY mbc.Orden DESC
	END

	DECLARE
		@totbonifs INT
	   ,@recorre INT
	   ,@tincluye INT
	   ,@avanza INT
	SELECT @totbonifs = MAX(reg)
		  ,@recorre = 1
	FROM #CrBonifAplicar
	WHILE @recorre <= @totbonifs
	BEGIN
	SELECT @Ok = NULL
		  ,@OkRef = NULL
		  ,@Id = Id
		  ,@Bonificacion = Bonificacion
		  ,@PorcBon1 = PorcBon1
		  ,@Financiamiento = Financiamiento
		  ,@FechaIni = FechaIni
		  ,@FechaFin = FechaFin
		  ,@PagoTotal = PagoTotal
		  ,@ActVigencia = ActVigencia
		  ,@AplicaA = AplicaA
		  ,@PlazoEjeFin = PlazoEjeFin
		  ,@VencimientoAntes = VencimientoAntes
		  ,@VencimientoDesp = VencimientoDesp
		  ,@DiasAtrazo = DiasAtrazo
		  ,@DiasMenoresA = DiasMenoresA
		  ,@DiasMayoresA = DiasMayoresA
		  ,@Factor = Factor
		  ,@Linea = Linea
		  ,@FechaCancelacion = FechaCancelacion
		  ,@FechaRegistro = FechaRegistro
		  ,@Usuario = Usuario
		  ,@LineaBonif = LineaBonif
	FROM #CrBonifAplicar
	WHERE reg = @recorre
	DECLARE
		@LineaVentaBonif VARCHAR(50)
	SELECT TOP 1 @LineaVentaBonif = ISNULL(Linea, @LineaVta)
	FROM BonifSIMAVI
	WHERE IDCxc = @IdVenta
	AND Linea IN (SELECT mbl.Linea FROM MaviBonificacionConf mbc INNER JOIN MaviBonificacionMoV mbmv ON mbc.Id = mbmv.IdBonificacion INNER JOIN MaviBonificacionCondicion mbc2 ON mbc2.IdBonificacion = mbc.ID LEFT JOIN MaviBonificacionLinea mbl ON ID = mbl.IdBonificacion WHERE mbmv.Movimiento = @Mov AND COndicion = @Condicion AND mbc.Estatus = 'CONCLUIDO' AND @FechaEmision BETWEEN mbc.FechaIni AND mbc.FechaFin AND mbc.NoPuedeAplicarSola = 0 AND Bonificacion LIKE '%Contado Comercial%')
	SELECT @LineaVentaBonif = ISNULL(A.Linea, @LineaVta)
	FROM venta
		,ventad
		 LEFT OUTER JOIN Art a
			 ON a.Articulo = ventad.Articulo
	WHERE venta.id = ventad.id
	AND venta.id = @IdVenta
	AND A.Linea IN (SELECT mbl.Linea FROM MaviBonificacionConf mbc INNER JOIN MaviBonificacionMoV mbmv ON mbc.Id = mbmv.IdBonificacion INNER JOIN MaviBonificacionCondicion mbc2 ON mbc2.IdBonificacion = mbc.ID LEFT JOIN MaviBonificacionLinea mbl ON ID = mbl.IdBonificacion WHERE mbmv.Movimiento = @Mov AND COndicion = @Condicion AND mbc.Estatus = 'CONCLUIDO' AND @FechaEmision BETWEEN mbc.FechaIni AND mbc.FechaFin AND mbc.NoPuedeAplicarSola = 0 AND Bonificacion LIKE '%Contado Comercial%')
	SELECT @LineaVentaBonif = ISNULL(@LineaVentaBonif, @LineaVta)
	SELECT @LineaVta = @LineaVentaBonif

	IF @LineaVentaBonif IN (SELECT mbl.Linea FROM MaviBonificacionConf mbc INNER JOIN MaviBonificacionMoV mbmv ON mbc.Id = mbmv.IdBonificacion INNER JOIN MaviBonificacionCondicion mbc2 ON mbc2.IdBonificacion = mbc.ID LEFT JOIN MaviBonificacionLinea mbl ON ID = mbl.IdBonificacion WHERE mbmv.Movimiento = @Mov AND COndicion = @Condicion AND mbc.Estatus = 'CONCLUIDO' AND @FechaEmision BETWEEN mbc.FechaIni AND mbc.FechaFin AND mbc.NoPuedeAplicarSola = 0 AND Bonificacion LIKE '%Contado Comercial%')
		AND @Bonificacion LIKE '%Contado Comercial%'
	BEGIN

		IF ISNULL(@LineaBonif, '') <> ''
			AND ISNULL(@LineaVentaBonif, '') <> ''
			AND @Bonificacion LIKE '%Contado Comercial%'
		BEGIN

			IF @LineaBonif = @LineaVentaBonif
				SELECT @Ok = NULL
					  ,@OkRef = NULL

		END
		ELSE
			SELECT @Ok = 1
				  ,@OkRef = 'No cumple con el parametro linea para esta bonificacion'

	END
	ELSE

	IF ISNULL(@LineaBonif, '') = ''
		AND ISNULL(@LineaVentaBonif, '') <> ''
		AND @Bonificacion LIKE '%Contado Comercial%'
	BEGIN

		IF EXISTS (SELECT Bonificacion FROM dbo.MaviBonificacionTest WHERE Bonificacion = @Bonificacion AND Ok = 0 AND IdCobro = @IdCobro)
			SELECT @Ok = 1
				  ,@OkRef = 'No cumple con el parametro de la linea para esta bonificacion'
		ELSE
			SELECT @Ok = NULL
				  ,@OkRef = NULL

	END
	ELSE

	IF @Bonificacion LIKE '%Contado Comercial%'
		SELECT @Ok = 1
			  ,@OkRef = 'No cumple con el parametro de la linea para esta bonificacion'

	SELECT @LineaBonif = ''

	IF @Bonificacion LIKE '%Adelanto%'
		AND @LineaVta <> @LineaBonif
		AND @Tipo = 'Total'
		AND EXISTS (SELECT * FROM MaviBonificacionTest WHERE IdCobro = @IdCobro AND Ok = 0 AND Bonificacion = @Bonificacion)
		SELECT @Ok = 1
			  ,@OkRef = 'No cumple con el parametro de la linea para esta bonificacion'

	IF @Tipo = 'Total'
		AND @Bonificacion NOT LIKE '%Adelanto%'
		AND EXISTS (SELECT IdBonificacion FROM MaviBonificacionExcluye WHERE BonificacionNo = @Bonificacion AND IdBonificacion IN (SELECT ID FROM (SELECT mbc.ID, Ok = CASE WHEN @EsOrigenNulo = 0 THEN CASE WHEN dbo.fnFechaSinHora(GETDATE()) >= dbo.fnFechaSinHora((SELECT c.Vencimiento + 1 FROM Cxc c WHERE c.Origen = @Origen AND c.OrigenID = @OrigenId AND c.Referencia LIKE '%' + '(' + RTRIM(mbc.VencimientoAntes) + '/' + RTRIM(@DocumentoTotal) + '%')) THEN 1 ELSE 0 END ELSE CASE WHEN dbo.fnFechaSinHora(GETDATE()) > dbo.fnFechaSinHora(ISNULL((SELECT c.Vencimiento FROM Cxc c WHERE c.Origen = @Origen AND c.OrigenID = @OrigenId AND c.Referencia LIKE '%' + '(' + RTRIM(mbc.VencimientoAntes) + '/' + RTRIM(@DocumentoTotal) + '%'), (CASE WHEN mbc.VencimientoAntes = 1 THEN @Vencimiento WHEN mbc.VencimientoAntes > 1 THEN DATEADD(mm, (mbc.VencimientoAntes - @Documento1de), (SELECT Vencimiento FROM CxC WHERE Origen = @Origen AND OrigenID = @OrigenId AND Referencia = @Referencia)) END))) THEN 1 ELSE 0 END END, DiasAtrazo = CASE WHEN @MaxDiasAtrazo > mbc.DiasAtrazo AND mbc.DiasAtrazo <> 0 THEN 1 ELSE 0 END, DiasMenoresA = CASE WHEN @Condicion LIKE '%PP%' AND mbc.DiasMenoresA <> 0 THEN CASE WHEN mbc.DiasMenoresA < DATEDIFF(DAY, @FechaEmisionFact, GETDATE()) THEN 1 ELSE 0 END WHEN @Condicion LIKE '%DIF%' AND mbc.DiasMenoresA <> 0 THEN CASE WHEN mbc.DiasMenoresA < DATEDIFF(DAY, @FechaEmisionFact, GETDATE()) THEN 1 ELSE 0 END ELSE 0 END, DiasMayoresA = CASE WHEN @Condicion LIKE '%PP%' AND mbc.DiasMayoresA <> 0 THEN CASE WHEN mbc.DiasMayoresA >= DATEDIFF(dd, @FechaEmisionFact, @Vencimiento) THEN 1 ELSE 0 END WHEN @Condicion LIKE '%DIF%' AND mbc.DiasMayoresA <> 0 THEN CASE WHEN mbc.DiasMayoresA <= DATEDIFF(DAY, @FechaEmisionFact, GETDATE()) THEN 1 ELSE 0 END ELSE 0 END FROM MaviBonificacionConf mbc INNER JOIN MaviBonificacionMoV mbmv ON mbc.Id = mbmv.IdBonificacion INNER JOIN MaviBonificacionCondicion mbc2 ON mbc2.IdBonificacion = mbc.ID LEFT JOIN MaviBonificacionLinea mbl ON ID = mbl.IdBonificacion WHERE mbmv.Movimiento = @Mov AND COndicion = @Condicion AND mbc.Estatus = 'CONCLUIDO' AND @FechaEmision BETWEEN mbc.FechaIni AND mbc.FechaFin AND mbc.NoPuedeAplicarSola = 0 AND Bonificacion = 'Bonificacion Contado Comercial') Cont WHERE Ok = 0 AND DiasAtrazo = 0 AND DiasMenoresA = 0 AND DiasMayoresA = 0))
		SELECT @Ok = 1
			  ,@OkRef = 'Se excluye esta bonificacion por otra'

	IF @VencimientoAntes <> 0
		AND @Bonificacion NOT LIKE '%Adelanto%'
		AND @Tipo = 'Total'
	BEGIN
		SET @CharReferencia = '(' + RTRIM(@VencimientoAntes) + '/' + RTRIM(@DocumentoTotal)

		IF @EsOrigenNulo = 0
		BEGIN

			IF dbo.fnFechaSinHora(GETDATE()) >= dbo.fnFechaSinHora((
					SELECT c.Vencimiento + 1
					FROM Cxc c
					WHERE c.Origen = @Origen
					AND c.OrigenID = @OrigenId
					AND c.Referencia LIKE '%' + @CharReferencia + '%'
				)
				)
				SELECT @Ok = 1
					  ,@OkRef = 'No cumple con el límite de pago posterior1'

		END
		ELSE
		BEGIN

			IF (dbo.fnFechaSinHora(GETDATE()) > dbo.fnFechaSinHora(ISNULL((
					SELECT c.Vencimiento
					FROM Cxc c
					WHERE c.Origen = @Origen
					AND c.OrigenID = @OrigenId
					AND c.Referencia LIKE '%' + @CharReferencia + '%'
				)
				,
				(CASE
					WHEN @VencimientoAntes = 1 THEN @Vencimiento
					WHEN @VencimientoAntes > 1 THEN DATEADD(mm, (@VencimientoAntes - @Documento1de), (
							SELECT Vencimiento
							FROM CxC
							WHERE Origen = @Origen
							AND OrigenID = @OrigenId
							AND Referencia = @Referencia
						)
						)
				END))))
				SELECT @Ok = 1
					  ,@OkRef = 'No cumple con el límite de pago posterior1'

		END

	END

	IF @VencimientoAntes <> 0
		AND @Bonificacion LIKE '%Adelanto%'
		AND @Tipo = 'Total'
	BEGIN
		SET @CharReferencia = '(' + RTRIM(@VencimientoAntes) + '/' + RTRIM(@DocumentoTotal)

		IF dbo.fnFechaSinHora(GETDATE()) >= dbo.fnFechaSinHora((
				SELECT c.Vencimiento + 1
				FROM Cxc c
				WHERE c.Origen = @Origen
				AND c.OrigenID = @OrigenId
				AND c.Referencia LIKE '%' + @CharReferencia + '%'
			)
			)
			SELECT @Ok = 1
				  ,@OkRef = 'No cumple con el límite de pago posterior1'

	END

	IF @VencimientoDesp <> 0
		AND @Bonificacion LIKE '%Adelanto%'
		AND @Tipo = 'Total'
	BEGIN
		SET @CharReferencia = '(' + RTRIM(@VencimientoDesp) + '/' + RTRIM(@DocumentoTotal)

		IF (dbo.fnFechaSinHora(GETDATE()) <=
			dbo.fnFechaSinHora(ISNULL((
				SELECT c.Vencimiento
				FROM Cxc c
				WHERE c.Origen = @Origen
				AND c.OrigenID = @OrigenId
				AND c.Referencia LIKE '%' + @CharReferencia + '%'
			)
			,
			(CASE
				WHEN @VencimientoDesp = 1 THEN @Vencimiento
				WHEN @VencimientoDesp > 1 THEN DATEADD(mm, (@VencimientoDesp - @Documento1de), (
						SELECT Vencimiento
						FROM CxC
						WHERE Origen = @Origen
						AND OrigenID = @OrigenId
						AND Referencia = @Referencia
					)
					)
			END))))
			SELECT @Ok = 1
				  ,@OkRef = 'No cumple con el límite de pago posterior1'

	END

	IF @DiasAtrazo <> 0
		AND @Bonificacion LIKE '%Contado Comercial%'
	BEGIN

		IF @MaxDiasAtrazo > @DiasAtrazo
			SELECT @Ok = 1
				  ,@OkRef = 'Excede el número de dias de atraso permitidos '

	END

	IF @DiasMenoresA <> 0
		AND @Bonificacion LIKE '%Contado Comercial%'
		AND @Condicion LIKE '%PP%'
	BEGIN

		IF @DiasMenoresA < DATEDIFF(DAY, @FechaEmisionFact, GETDATE())
			SELECT @Ok = 1
				  ,@OkRef = 'Excede días menores'

	END

	IF @DiasMayoresA <> 0
		AND @Bonificacion LIKE '%Contado Comercial%'
		AND @Condicion LIKE '%PP%'
	BEGIN

		IF @DiasMayoresA >= DATEDIFF(dd, @FechaEmisionFact, @Vencimiento)
			SELECT @Ok = 1
				  ,@OkRef = 'Excede dias mayores'

	END

	IF @DiasMenoresA <> 0
		AND @Bonificacion LIKE '%Contado Comercial%'
		AND @Condicion LIKE '%DIF%'
	BEGIN

		IF @DiasMenoresA < DATEDIFF(DAY, @FechaEmisionFact, GETDATE())
			SELECT @Ok = 1
				  ,@OkRef = 'Excede días menores' + CONVERT(CHAR(30), @DiasMenoresA)

	END

	IF @DiasMayoresA <> 0
		AND @Bonificacion LIKE '%Contado Comercial%'
		AND @Condicion LIKE '%DIF%'
	BEGIN

		IF GETDATE() >= (@FechaEmisionFact + @DiasMayoresA)
			SELECT @Ok = 1
				  ,@OkRef = 'Excede días mayores' + CONVERT(CHAR(30), @DiasMayoresA)

	END

	IF @PorcBon1 = 0
		AND @Linea <> 0
		SELECT @PorcBon1 = @Linea

	IF @Linea < (
			SELECT ISNULL(PorcLin, 0.00)
			FROM MaviBonificacionLinea
			WHERE IdBonificacion = @id
			AND Linea = @LineaVta
		)
		SELECT @Linea = (
			 SELECT ISNULL(PorcLin, 0.00)
			 FROM MaviBonificacionLinea
			 WHERE IdBonificacion = @id
			 AND Linea = @LineaVta
		 )

	SELECT @LineaCelulares = ISNULL(PorcLin, 0.00)
	FROM MaviBonificacionLinea mbl
	WHERE Linea LIKE '%Credilana%'
	AND IdBonificacion = @Id
	SELECT @LineaCredilanas = ISNULL(PorcLin, 0.00)
	FROM MaviBonificacionLinea mbl
	WHERE Linea LIKE '%Celular%'
	AND IdBonificacion = @Id
	SELECT @LineaMotos = ISNULL(PorcLin, 0.00)
	FROM MaviBonificacionLinea mbl
	INNER JOIN MaviBonificacionCondicion Mbc
		ON Mbc.IdBonificacion = mbl.IdBonificacion
	WHERE Mbc.COndicion = @Condicion
	AND @Bonificacion LIKE '%Contado Comercial%'
	AND Mbl.IdBonificacion = @Id
	AND Linea = @LineaBonif

	IF EXISTS (SELECT IdBonificacion FROM MaviBonificacionCanalVta BonCan WHERE BonCan.IdBonificacion = @id)
	BEGIN

		IF NOT EXISTS (SELECT IdBonificacion FROM MaviBonificacionCanalVta BonCan WHERE CONVERT(VARCHAR(10), BonCan.CanalVenta) = @ClienteEnviarA AND BonCan.IdBonificacion = @id)
			SELECT @Ok = 1
				  ,@OkRef = 'Venta de Canal No Configurada Para esta Bonificación'

	END

	IF EXISTS (SELECT IdBonificacion FROM MaviBonificacionUEN mbu WHERE mbu.idBonificacion = @Id)
	BEGIN

		IF NOT @UEN IS NULL
			AND NOT EXISTS (SELECT IdBonificacion FROM MaviBonificacionUEN mbu WHERE mbu.UEN = @UEN AND mbu.idBonificacion = @Id)
			SELECT @Ok = 1
				  ,@OkRef = 'UEN No Configurada Para este Caso'

	END

	IF EXISTS (SELECT IdBonificacion FROM MaviBonificacionCondicion WHERE IdBonificacion = @Id)
	BEGIN

		IF NOT EXISTS (SELECT IdBonificacion FROM MaviBonificacionCondicion WHERE COndicion = @Condicion AND IdBonificacion = @Id)
			SELECT @Ok = 1
				  ,@OkRef = 'Condicion No Configurada Para esta Bonificación'

	END

	IF EXISTS (SELECT IdBonificacion FROM MaviBonificacionExcluye Exc WHERE BonificacionNo = @Bonificacion)
	BEGIN

		IF EXISTS (SELECT BonTest.IdBonificacion FROM MaviBonificacionTest BonTest, MaviBonificacionExcluye Exc WHERE Bontest.IdBonificacion = Exc.IdBonificacion AND Bontest.OkRef = '' AND Exc.BonificacionNo = @Bonificacion AND BonTest.IdCobro = @IdCobro AND BonTest.MontoBonif > 0 AND BonTest.Origen = @Mov AND BonTest.OrigenId = @MovId)
			SELECT @Ok = 1
				  ,@OkRef = 'Excluye esta Bonificacion Una anterior '

	END

	IF NOT @TipoSucursal IS NULL
		AND NOT EXISTS (SELECT IdBonificacion FROM MaviBonificacionSucursal WHERE Sucursal = RTRIM(@TipoSucursal) AND idBonificacion = RTRIM(@Id))
		SELECT @Ok = 1
			  ,@OkRef = 'Bonificación No Configurada Para este tipo de Sucursal'

	IF NOT EXISTS (SELECT IdBonificacion FROM MaviBonificacionTest WHERE idBonificacion = RTRIM(@Id) AND Docto = @IdCxC)
	BEGIN
		SELECT @MesesExced = ISNULL(@DocumentoTotal, 0) - ISNULL(@PlazoEjeFin, 0)
		SELECT @Factor = 1 + (@MesesExced * (ISNULL(@Financiamiento, 0.00) / 100))
		SELECT @BaseParaAplicar = ISNULL(@ImporteVenta / @Factor, 0.00)

		IF @AplicaA = 'Importe de Factura'
		BEGIN

			IF @Linea <> 0
				SELECT @PorcBon1 = @Linea

			IF @LineaCelulares <> 0
				AND @Bonificacion NOT LIKE '%Contado%'
				AND @Bonificacion NOT LIKE '%Atraso%'
				SELECT @PorcBon1 = ISNULL(@LineaCelulares, 0.00)

			IF @LineaCredilanas <> 0
				AND @Bonificacion NOT LIKE '%Contado%'
				AND @Bonificacion NOT LIKE '%Atraso%'
				SELECT @PorcBon1 = ISNULL(@LineaCredilanas, 0.00)

			IF @Bonificacion LIKE '%Contado%'
				SELECT @PorcBon1 = ISNULL(@LineaMotos, @PorcBon1)

			SELECT @MontoBonif = (@PorcBon1 / 100) * (@ImporteVenta / @Factor)
		END

		IF @AplicaA <> 'Importe de Factura'
			SELECT @MontoBonif = (@PorcBon1 / 100) * @ImporteDocto

		IF @Bonificacion LIKE '%Contado Comercial%'
			AND @Ok IS NULL
		BEGIN
			SELECT @MontoBonif = @ImporteVenta - ((@ImporteVenta / @Factor) - @MontoBonif)
		END

		IF NOT @Ok IS NULL
			SELECT @MontoBonif = 0.00
				  ,@PorcBon1 = 0.00

		IF @Bonificacion LIKE '%Adelanto%'
			AND dbo.fnFechaSinHora(GETDATE()) = dbo.fnFechaSinHora(@Vencimiento)
			SELECT @MontoBonif = 0.00
				  ,@PorcBon1 = 0.00

		IF @Bonificacion LIKE '%Contado Comercial%'
			AND @Ok IS NULL
			SELECT @MontoBonif = ISNULL(@MontoBonif, 0) - Bonif
			FROM (
				SELECT CMov.Mov
					  ,CMov.MovID
					  ,Bonif = ISNULL(SUM(cd.Importe), 0)
				FROM Cxc CMov
				INNER JOIN Cxc Ccte
					ON Ccte.Cliente = CMov.Cliente
					AND Ccte.Mov LIKE 'Nota Credito%'
					AND Ccte.Estatus = 'CONCLUIDO'
				INNER JOIN Cxc CBonif
					ON Ccte.ID = CBonif.ID
				INNER JOIN CxcD cd
					ON CBonif.ID = cd.ID
				INNER JOIN Cxc CPadre
					ON CPadre.Mov = cd.Aplica
					AND CPadre.MovID = cd.AplicaID
					AND CPadre.PadreMAVI = CMov.Mov
					AND CPadre.PadreIDMAVI = CMov.MovID
				WHERE Ccte.Concepto LIKE '%PAGO PUNTUAL%'
				AND CMov.Mov = @Mov
				AND CMov.MovID = @MovId
				GROUP BY CMov.Mov
						,CMov.MovID
			) Resta

		IF @Bonificacion LIKE '%Contado Comercial%'
		BEGIN
			INSERT MaviBonificacionTest (idBonificacion, IdCoBro, Docto, Bonificacion, Estacion, Documento1de, DocumentoTotal, Mov,
			MovId, Origen, OrigenId, ImporteDocto, ImporteVenta, MontoBonif, TipoSucursal, LineaVta, IdVenta, UEN, Condicion, PorcBon1, Financiamiento, Ok, OkRef, Factor, Sucursal1, PlazoEjeFin, FechaEmision, Vencimiento, LineaCelulares, LineaCredilanas, DiasMenoresA, DiasMayoresA, BaseParaAplicar)
				VALUES (@Id, @IdCobro, @IdCxC, ISNULL(@Bonificacion, ''), @Estacion, ISNULL(@Documento1de, 0), ISNULL(@DocumentoTotal, 0), ISNULL(@Mov, ''), ISNULL(@MovId, ''), ISNULL(@Origen, ''), ISNULL(@OrigenId, ''), ROUND(ISNULL(@ImporteDocto, 0.00), 2), ROUND(ISNULL(@ImporteVenta, 0.00), 2), ROUND(ISNULL(@MontoBonif, 0.00), 2), ISNULL(@TipoSucursal, ''), ISNULL(@LineaVta, ''), ISNULL(@IdVenta, 0), ISNULL(@UEN, 0), ISNULL(@Condicion, ''), ISNULL(@PorcBon1, 0.00), ISNULL(@Financiamiento, 0.00), ISNULL(@Ok, 0), ISNULL(@OkRef, ''), ISNULL(@Factor, 0.00), @Sucursal, @PlazoEjeFin, @FechaEmision, @Vencimiento, ISNULL(@LineaCelulares, 0.00), ISNULL(@LineaCredilanas, 0.0), @DiasMenoresA, @DiasMayoresA, ROUND(ISNULL(@BaseParaAplicar, 0.00), 2))
		END

	END

	IF (@Ok IS NULL AND EXISTS (SELECT IdBonificacion FROM MaviBonificacionIncluye Exc WHERE Exc.IdBonificacion = @Id) AND EXISTS (SELECT Movimiento FROM MaviBonificacionMoV WHERE Movimiento = @Mov AND IdBonificacion IN (SELECT id FROM MaviBonificacionConf WHERE Bonificacion LIKE '%Atraso%'))
		)
		OR (@Ok IS NULL AND @Tipo = 'Total' AND NOT @Bonificacion LIKE '%Contado Comercial%')
		OR (@Ok IS NULL AND @Tipo = 'Total' AND NOT @Bonificacion LIKE '%Adelanto%')
		OR (@Ok IS NULL AND @Tipo <> 'Total' AND NOT @Bonificacion LIKE '%Contado Comercial%')
	BEGIN

		IF (@Ok IS NULL AND EXISTS (SELECT IdBonificacion FROM MaviBonificacionIncluye Exc WHERE Exc.IdBonificacion = @Id) AND EXISTS (SELECT Movimiento FROM MaviBonificacionMoV WHERE Movimiento = @Mov AND IdBonificacion IN (SELECT id FROM MaviBonificacionConf WHERE Bonificacion LIKE '%Atraso%'))
			)
		BEGIN

			IF EXISTS (SELECT * FROM tempdb.sys.sysobjects WHERE id = OBJECT_ID('tempdb.dbo.#crVerificaDetalle') AND TYPE = 'U')
				DROP TABLE #crVerificaDetalle

			SELECT ROW_NUMBER() OVER (ORDER BY BonificacionNo) ind
				  ,BonificHijo = BonificacionNo
				  ,BonificHijoCascad = EnCascada
			INTO #crVerificaDetalle
			FROM MaviBonificacionIncluye
			WHERE IdBonificacion = @Id
			ORDER BY Orden
			SET @tincluye = 0
			SET @avanza = 0
			SELECT @tincluye = MAX(ind)
				  ,@avanza = 1
			FROM #crVerificaDetalle
			WHILE @avanza <= @tincluye
			AND @Ok IS NULL
			BEGIN
			SELECT @BonificHijo = BonificHijo
				  ,@BonificHijoCascad = BonificHijoCascad
			FROM #crVerificaDetalle
			WHERE ind = @avanza

			IF RTRIM(@BonificHijo) LIKE '%Atraso%'
				AND @Bonificacion LIKE '%Adelanto%'
				SELECT @BaseParaAPlicar = @ImporteVenta

			IF RTRIM(@BonificHijo) LIKE '%Atraso%'
				AND @Bonificacion LIKE '%Comercial%'
				SELECT @BaseParaAPlicar = @ImporteVenta * (@PorcBon1 / 100)

			EXEC spBonificacionDocRestantes @BonificHijo
										   ,@BonificHijoCascad
										   ,@PadreMavi
										   ,@PadreMaviID
										   ,@Idventa
										   ,@lineaVta
										   ,@Sucursal
										   ,@TipoSucursal
										   ,@Estacion
										   ,@Uen
										   ,@Condicion
										   ,@ImporteVenta
										   ,@Tipo
										   ,@IdCxC
										   ,@IdCobro
										   ,@MaxDiasAtrazo
										   ,@Id
										   ,@Bonificacion
										   ,@BaseParaAPlicar
										   ,'Incluye'
										   ,@MontoBonif
										   ,@FechaEmision
			SET @avanza = @avanza + 1
			END
		END

		IF (@Ok IS NULL AND @Tipo = 'Total' AND NOT @Bonificacion LIKE '%Contado Comercial%')
			OR (@Ok IS NULL AND @Tipo <> 'Total' AND NOT @Bonificacion LIKE '%Contado Comercial%')
		BEGIN
			EXEC spBonificacionDocRestantes @Bonificacion
										   ,'No'
										   ,@PadreMavi
										   ,@PadreMaviId
										   ,@Idventa
										   ,@lineaVta
										   ,@Sucursal
										   ,@TipoSucursal
										   ,@Estacion
										   ,@Uen
										   ,@Condicion
										   ,@ImporteVenta
										   ,@Tipo
										   ,@IdCxC
										   ,@IdCobro
										   ,@MaxDiasAtrazo
										   ,@Id
										   ,@Bonificacion
										   ,@BaseParaAPlicar
										   ,''
										   ,@MontoBonif
										   ,@FechaEmision
		END

	END

	SET @recorre = @recorre + 1
	END
END
GO