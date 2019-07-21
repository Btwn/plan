SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spPlanArt
@Empresa	     	char(5),
@ArticuloEspecifico  	char(20)    = NULL,
@Hoy		     	datetime    = NULL,
@Debug		     	bit 	    = 0,
@Categoria	     	varchar(50) = NULL,
@Grupo		     	varchar(50) = NULL,
@Familia	     	varchar(50) = NULL,
@Fabricante	     	varchar(50) = NULL,
@Linea		     	varchar(50) = NULL,
@Temporada	     	varchar(50) = NULL,
@ProveedorEspecifico 	char(10)    = NULL,
@Referencia		varchar(50) = NULL,
@ReferenciaModulo	varchar(5)  = NULL,
@OperacionServidor   	varchar(100)= NULL,
@OperacionBase	     	varchar(100)= NULL,
@OperacionLigarServidor bit	    = 1,
@ReferenciaActividad	varchar(50) = NULL

AS BEGIN
DECLARE
@CfgProd			bit,
@TipoPeriodo		varchar(20),
@CalcATP			bit,
@AbortarPrimerError		bit,
@Periodos			int,
@BitacoraID			int,
@BitacoraEstatus		char(15),
@Sucursal			int,
@p				int,
@a				int,
@f				float,
@Ult_ATP			int,
@DA				money,
@DT				money,
@RP				money,
@ATP			money,
@EP				money,
@IS				money,
@RN				money,
@ROPF			money,
@REPF			money,
@ROP			float,
@RO				char(10),
@LO				char(10),
@Almacen			char(10),
@AlmacenDestino		char(10),
@AlmacenOrigen		char(10),
@Articulo			char(20),
@SubCuenta			varchar(50),
@SeVende			bit,
@SeProduce			bit,
@SeCompra			bit,
@Ruta			varchar(20),
@ArtCantidad		float,
@ArtUnidad			varchar(50),
@LoteOrdenar		varchar(30),
@InvSeguridad		float,
@CantidadOrdenar		float,
@MultiplosOrdenar		float,
@CantidadOrdenarTiempo	float,
@TiempoEntrega		int,
@TiempoEntregaUnidad 	varchar(10),
@TiempoEntregaSeg		int,
@TiempoEntregaSegUnidad 	varchar(10),
@FechaEntrega		datetime,
@FechaEntregaLOP		datetime,
@FechaLiberacion		datetime,
@FechaCongelada		datetime,
@PeriodoROP			int,
@PeriodoLOP			int,
@PeriodoLOPF		int,
@PeriodoLODF		int,
@PeriodoInicialDemanda	int,
@PeriodoCongelado		int,
@Vuelta			int,
@Ok				int,
@OkRef			varchar(255),
@Dias			int,
@PrimerDia			datetime,
@CfgPlanSinDemanda		 bit,
@CfgPlanIgnorarDemanda	 bit,
@CfgPlanIgnorarZonaCongelada bit,
@CfgPlanISDemanda		 bit,
@CfgMermaIncluida		 bit,
@CfgDesperdicioIncluido	 bit,
@CfgTipoMerma		 char(1),
@CfgMultiUnidades		 bit,
@CfgMultiUnidadesNivel 	 char(20),
@CfgPlanHist		 bit,
@CfgPlanBasePresupuesto	 bit,
@Accion			 varchar(20),
@Proveedor			 char(10),
@AlmacenROP			 char(10),
@AlmacenTipo		 char(15),
@RutaDistribucion		 varchar(50),
@EsDistribucion		 bit,
@InsertoPlanArtSinDemanda	 bit,
@DRP			 int,
@UltDRP			 int,
@DRPDistribucion		 bit,
@VueltaDistribucion		 int,
@CfgRutaDistribucion         varchar(50),
@CfgRutaDistribucionNivelArticulo bit,
@CfgPlanTESeguridad		bit,
@CfgDiasHabiles		varchar(20),
@CfgPlanRecorrerLiberacion	bit,
@EstadoOmision		varchar(20),
@CorridaOrden		varchar(50),
@FechaInicio		datetime,
@CfgPlanInicio		varchar(20),
@Mensaje			varchar(255),
@OperacionRemota		varchar(255),
@CoberturaEnMeses		float,
@EP2			float,
@RN2			float,
@RD				char(10),
@SODF			char(10)
SET NOCOUNT ON
/* Explicacion
Cuando se maneja DRP y MRP es muy importante que primero se recalcule el DRP y despues el MRP
para ello en la tabla #PlanCorrida se metio el campo DRP, lo que hace este cursor es mientras exista
algo que recalcular que sea DRP = 1, lo va a hacer y despues DRP = 0
Las vueltas son importantes para el DRP ya que se va recalculando de donde hay demanda para arriba.
*/
SELECT @OperacionRemota = NULL,
@TipoPeriodo	  = 'SEMANA',
@FechaInicio     = GETDATE()
IF @OperacionBase IS NOT NULL
BEGIN
SELECT @OperacionRemota = ''
IF @OperacionServidor IS NOT NULL SELECT @OperacionRemota = RTRIM(@OperacionServidor) + '.'
SELECT @OperacionRemota = @OperacionRemota + RTRIM(@OperacionBase)+'.dbo.'
END
IF @OperacionServidor IS NOT NULL AND @OperacionLigarServidor = 1
EXEC sp_addlinkedserver @OperacionServidor
SELECT @Mensaje = NULL
IF @ArticuloEspecifico IS NULL
BEGIN
INSERT PlanBitacora (Empresa, Categoria, Grupo, Familia, Fabricante, Linea, Temporada, Proveedor, Referencia, Estatus, FechaInicio)
VALUES (@Empresa, @Categoria, @Grupo, @Familia, @Fabricante, @Linea, @Temporada, @ProveedorEspecifico, @Referencia, 'BORRADOR', @FechaInicio)
SELECT @BitacoraID = SCOPE_IDENTITY()
SELECT @Categoria	        = NULLIF(NULLIF(RTRIM(@Categoria), '(Todos)'), ''),
@Grupo		= NULLIF(NULLIF(RTRIM(@Grupo), '(Todos)'), ''),
@Familia	        = NULLIF(NULLIF(RTRIM(@Familia), '(Todos)'), ''),
@Fabricante	        = NULLIF(NULLIF(RTRIM(@Fabricante), '(Todos)'), ''),
@Linea		= NULLIF(NULLIF(RTRIM(@Linea), '(Todos)'), ''),
@Temporada	        = NULLIF(NULLIF(RTRIM(@Temporada), '(Todos)'), ''),
@ProveedorEspecifico = NULLIF(NULLIF(RTRIM(@ProveedorEspecifico), '(TODOS)'), ''),
@Referencia	        = NULLIF(NULLIF(NULLIF(RTRIM(@Referencia), '(Todos)'), ''), '0'),
@ReferenciaModulo    = NULLIF(NULLIF(NULLIF(RTRIM(@ReferenciaModulo), '(Todos)'), ''), '0')
END
SELECT @CfgRutaDistribucionNivelArticulo = 0, @InsertoPlanArtSinDemanda = 0
SELECT @Ok = NULL, @OkRef = NULL
SELECT @CfgProd = Prod,
@CfgDiasHabiles = DiasHabiles
FROM EmpresaGral
WHERE Empresa = @Empresa
SELECT @CfgMermaIncluida       = ProdMermaIncluida,
@CfgDesperdicioIncluido = ProdDesperdicioIncluido,
@CfgMultiUnidades       = MultiUnidades,
@CfgMultiUnidadesNivel  = ISNULL(UPPER(NivelFactorMultiUnidad), 'UNIDAD'),
@CfgRutaDistribucion    = NULLIF(RTRIM(RutaDistribucion), ''),
@CfgRutaDistribucionNivelArticulo = ISNULL(RutaDistribucionNivelArticulo, 0),
@CfgPlanSinDemanda	 = PlanSinDemanda,
@CfgPlanIgnorarDemanda  = ISNULL(PlanIgnorarDemandaDirecta, 0),
@CfgPlanIgnorarZonaCongelada = ISNULL(PlanIgnorarZonaCongelada, 0),
@CfgPlanISDemanda	 = PlanISDemanda,
@CfgPlanTESeguridad     = PlanTESeguridad,
@CfgTipoMerma		 = ISNULL(ProdTipoMerma, '%'),
@Periodos	         = ISNULL(ProdPeriodosCorrida, 10),
@CalcATP		 = ISNULL(PlanCalcATP, 1),
@AbortarPrimerError     = ISNULL(PlanAbortarPrimerError, 1),
@EstadoOmision		 = ISNULL(NULLIF(RTRIM(PlanEstadoOmision), ''), 'Plan'),
@CorridaOrden		 = UPPER(NULLIF(RTRIM(PlanCorridaOrden), '')),
@TipoPeriodo	 	 = UPPER(ISNULL(RTRIM(PlanTipoPeriodo), 'SEMANA')),
@CfgPlanHist		 = PlanAutoGuardarHist,
@CfgPlanBasePresupuesto = ISNULL(PlanBasePresupuesto, 0),
@CfgPlanRecorrerLiberacion = ISNULL(PlanRecorrerLiberacion, 0),
@CfgPlanInicio       = ISNULL(PlanInicio, 'HOY')
FROM EmpresaCfg2
WHERE Empresa = @Empresa
IF @CfgProd = 1 SELECT /*| = 0, @CfgPlanISDemanda = 0, */@EstadoOmision = 'Plan'
IF @ArticuloEspecifico IS NOT NULL SELECT @AbortarPrimerError = 1
EXEC spPlanArtBorrar @Empresa, @ArticuloEspecifico, @OperacionRemota
CREATE TABLE #PlanCorrida (
Articulo 	char(20) 	COLLATE Database_Default NOT NULL,
SubCuenta 	varchar(50) 	COLLATE Database_Default NOT NULL,
Almacen		char(10)	COLLATE Database_Default NOT NULL,
DRP		int		NOT NULL	DEFAULT 0,
Vuelta		int		NOT NULL,
EsDistribucion	bit		NOT NULL	DEFAULT 0,
CONSTRAINT tempPlanCorrida PRIMARY KEY CLUSTERED (Articulo, SubCuenta, Almacen, DRP, Vuelta))
/*
CREATE TABLE #PlanCorrida2 (
Articulo 	char(20) 	COLLATE Database_Default NOT NULL,
SubCuenta 	varchar(50) 	COLLATE Database_Default NOT NULL,
Almacen		char(10)	COLLATE Database_Default NOT NULL,
DRP		int		NOT NULL	DEFAULT 0,
Vuelta		int		NOT NULL,
EsDistribucion	bit		NOT NULL	DEFAULT 0,
CONSTRAINT tempPlanCorrida2 PRIMARY KEY CLUSTERED (Articulo, SubCuenta, Almacen, DRP, Vuelta))
*/
IF @Hoy IS NULL SELECT @Hoy = GETDATE()
EXEC spExtraerFecha @Hoy OUTPUT
IF @TipoPeriodo = 'DIA'
BEGIN
SELECT @PrimerDia = @Hoy
EXEC spPlanArtDay @Empresa, @Periodos, @ArticuloEspecifico, @Hoy, @CfgPlanSinDemanda, @CfgPlanISDemanda, @CfgPlanIgnorarDemanda,
@Categoria, @Grupo, @Familia, @Fabricante, @Linea, @Temporada, @ProveedorEspecifico, @Referencia, @ReferenciaModulo, @ReferenciaActividad
END ELSE
IF @TipoPeriodo = 'SEMANA'
BEGIN
SELECT @PrimerDia = DATEADD(day, -DATEPART(weekday, @Hoy)+1, @Hoy)
IF @CfgPlanInicio = 'PRIMER DIA PERIODO' SELECT @Hoy = @PrimerDia
EXEC spPlanArtWeek @Empresa, @Periodos, @ArticuloEspecifico, @Hoy, @CfgPlanSinDemanda, @CfgPlanISDemanda, @CfgPlanIgnorarDemanda,
@Categoria, @Grupo, @Familia, @Fabricante, @Linea, @Temporada, @ProveedorEspecifico, @Referencia, @ReferenciaModulo, @ReferenciaActividad
END ELSE
IF @TipoPeriodo = 'MES'
BEGIN
SELECT @PrimerDia = DATEADD(day, -DATEPART(day, @Hoy)+1, @Hoy)
IF @CfgPlanInicio = 'PRIMER DIA PERIODO' SELECT @Hoy = @PrimerDia
EXEC spPlanArtMonth @Empresa, @Periodos, @ArticuloEspecifico, @Hoy, @CfgPlanSinDemanda, @CfgPlanISDemanda, @CfgPlanIgnorarDemanda,
@Categoria, @Grupo, @Familia, @Fabricante, @Linea, @Temporada, @ProveedorEspecifico, @Referencia, @ReferenciaModulo, @ReferenciaActividad
END
INSERT #PlanCorrida (Articulo, SubCuenta, Almacen, Vuelta, DRP)
SELECT p.Articulo, ISNULL(p.SubCuenta, ''), p.Almacen, 0, CASE WHEN a.AlmacenROP IN (p.Almacen, '(Demanda)') THEN 0 ELSE 1 END
FROM PlanArt p, Art a
WHERE p.Empresa = @Empresa AND p.Articulo = a.Articulo AND p.Articulo = ISNULL(@ArticuloEspecifico, p.Articulo)
GROUP BY p.Articulo, ISNULL(p.SubCuenta, ''), p.Almacen, a.AlmacenROP
IF @ReferenciaModulo = 'VTAS' AND @Referencia IS NOT NULL
BEGIN
DELETE #PlanCorrida
WHERE Articulo NOT IN(
SELECT d.Articulo
FROM Venta v
JOIN VentaD d ON v.ID = d.ID
WHERE RTRIM(v.Mov) +' ' + RTRIM(v.MovID) = @Referencia)
END
IF @ReferenciaModulo = 'INV' AND @Referencia IS NOT NULL
BEGIN
DELETE #PlanCorrida
WHERE Articulo NOT IN(
SELECT d.Articulo
FROM Inv v
JOIN InvD d ON v.ID = d.ID
WHERE RTRIM(v.Mov) +' ' + RTRIM(v.MovID) = @Referencia)
END
IF @ReferenciaModulo = 'PROY' AND @Referencia IS NOT NULL
BEGIN
DELETE #PlanCorrida
WHERE Articulo NOT IN(
SELECT d.Articulo
FROM Venta v
JOIN VentaD d ON v.ID = d.ID
WHERE v.Proyecto = @Referencia)
END
UPDATE #PlanCorrida
SET DRP = 0
FROM #PlanCorrida pc
JOIN ArtAlm aa ON aa.Empresa = @Empresa AND aa.Almacen = pc.Almacen AND aa.Articulo = pc.Articulo AND ISNULL(aa.SubCuenta, '') = ISNULL(pc.SubCuenta, '') AND AbastecimientoDirecto = 1
/*
INSERT #PlanCorrida2 (
Articulo, SubCuenta, Almacen, DRP, Vuelta, EsDistribucion)
SELECT Articulo, SubCuenta, Almacen, DRP, Vuelta, EsDistribucion
FROM #PlanCorrida
WHERE Articulo IN (SELECT DISTINCT Material FROM ArtMaterial)
DELETE #PlanCorrida
WHERE Articulo IN (SELECT DISTINCT Material FROM ArtMaterial)
IF NOT EXISTS(SELECT * FROM #PlanCorrida)
BEGIN
INSERT #PlanCorrida (
Articulo, SubCuenta, Almacen, DRP, Vuelta, EsDistribucion)
SELECT Articulo, SubCuenta, Almacen, DRP, Vuelta, EsDistribucion
FROM #PlanCorrida2
DELETE #PlanCorrida2
END
*/
IF EXISTS(SELECT * FROM RutaDistribucionD WHERE AlmacenOrigen = AlmacenDestino)
SELECT @Ok = 20851
SELECT @UltDRP = NULL
WHILE EXISTS(SELECT * FROM #PlanCorrida) AND @Ok IS NULL
BEGIN
IF EXISTS(SELECT * FROM #PlanCorrida WHERE DRP = 1) SELECT @DRP = 1 ELSE SELECT @DRP = 0
IF @DRP <> @UltDRP SELECT @Vuelta = 0, @UltDRP = @DRP
IF @CorridaOrden = 'ALMACEN'
DECLARE crCorrida CURSOR FOR
SELECT p.Articulo, ISNULL(p.SubCuenta, ''), p.Almacen, p.EsDistribucion
FROM #PlanCorrida p
JOIN Art ON p.Articulo = Art.Articulo
LEFT OUTER JOIN Alm ON p.Almacen = Alm.Almacen
WHERE p.Vuelta <= @Vuelta
AND DRP = @DRP
ORDER BY Alm.Orden, Alm.Almacen, p.Articulo, p.SubCuenta
ELSE
DECLARE crCorrida CURSOR FOR
SELECT p.Articulo, ISNULL(p.SubCuenta, ''), p.Almacen, p.EsDistribucion
FROM #PlanCorrida p, Art
WHERE p.Vuelta <= @Vuelta AND p.Articulo = Art.Articulo
AND DRP = @DRP
ORDER BY p.Articulo, p.SubCuenta
OPEN crCorrida
FETCH NEXT FROM crCorrida INTO @Articulo, @SubCuenta, @Almacen, @EsDistribucion
WHILE @@FETCH_STATUS <> -1 AND @Ok IS NULL
BEGIN
IF @@FETCH_STATUS <> -2
BEGIN
/*        
DELETE #PlanCorrida2
WHERE Articulo = @Articulo AND ISNULL(SubCuenta, '') = @SubCuenta AND Almacen = @Almacen
*/
IF @Debug = 1 SELECT "Articulo" = @Articulo, "SubCuenta" = @SubCuenta, "Almacen" = @Almacen, "DRP" = @EsDistribucion
SELECT @AlmacenTipo = UPPER(Tipo) FROM Alm WHERE Almacen = @Almacen
IF @@ROWCOUNT = 0 SELECT @Ok = 20830, @OkRef = @Almacen
DELETE PlanArt
WHERE Empresa = @Empresa AND AlmacenDestino = @Almacen AND Articulo = @Articulo AND SubCuenta = @SubCuenta AND Acronimo = 'RD'
IF @ArticuloEspecifico IS NULL
EXEC spPlanArtOPEliminar @Empresa, @Almacen, @Articulo, @SubCuenta, @OperacionRemota
SELECT @Proveedor = NULL, @InvSeguridad = 0.0
SELECT @SeVende 	       = SeVende,
@SeProduce 	       = SeProduce,
@SeCompra    	       = SeCompra,
@Ruta		       = ProdRuta,
@TiempoEntrega	       = ISNULL(TiempoEntrega, 0),
@TiempoEntregaUnidad    = TiempoEntregaUnidad,
@TiempoEntregaSeg       = ISNULL(TiempoEntregaSeg, 0),
@TiempoEntregaSegUnidad = TiempoEntregaSegUnidad,
@AlmacenROP	       = NULLIF(RTRIM(AlmacenROP), ''),
@RutaDistribucion       = NULLIF(RTRIM(RutaDistribucion), ''),
@ArtCantidad	       = ISNULL(NULLIF(ProdCantidad, 0.0), 1.0),
@ArtUnidad	       = UnidadCompra,
@Proveedor 	       = Proveedor
FROM Art
WHERE Articulo = @Articulo
IF @CfgPlanTESeguridad = 0
SELECT @TiempoEntregaSeg = 0, @TiempoEntregaSegUnidad = NULL
SELECT @InvSeguridad = 0, @LoteOrdenar = NULL, @CantidadOrdenar = 0, @MultiplosOrdenar = 1, @CantidadOrdenarTiempo = 0
SELECT @InvSeguridad     	= ISNULL(Minimo, 0),
@LoteOrdenar 	 	= UPPER(LoteOrdenar),
@CantidadOrdenar	 	= ISNULL(CantidadOrdenar, 0),
@MultiplosOrdenar 	= ISNULL(NULLIF(MultiplosOrdenar, 0.0), 1),
@CantidadOrdenarTiempo	= ISNULL(CantidadOrdenarTiempo, 0)
FROM ArtAlm
WHERE Empresa = @Empresa AND Articulo = @Articulo AND Almacen = @Almacen AND NULLIF(SubCuenta, '') = NULLIF(@SubCuenta, '')
IF @@ROWCOUNT = 0 AND NULLIF(@SubCuenta, '') IS NULL
SELECT @InvSeguridad     	= ISNULL(Minimo, 0),
@LoteOrdenar 	   	= UPPER(LoteOrdenar),
@CantidadOrdenar  	= ISNULL(CantidadOrdenar, 0),
@MultiplosOrdenar 	= ISNULL(NULLIF(MultiplosOrdenar, 0.0), 1),
@CantidadOrdenarTiempo = ISNULL(CantidadOrdenarTiempo, 0)
FROM ArtAlm
WHERE Empresa = @Empresa AND Articulo = @Articulo AND Almacen = @Almacen AND NULLIF(SubCuenta, '') IS NULL
IF @CfgRutaDistribucionNivelArticulo = 0 OR @RutaDistribucion IS NULL SELECT @RutaDistribucion = @CfgRutaDistribucion
EXEC spIncTiempo @PrimerDia, @TiempoEntrega, @TiempoEntregaUnidad, @FechaCongelada OUTPUT
IF @TipoPeriodo = 'DIA'    SELECT @PeriodoCongelado = DATEDIFF(day, @PrimerDia, @FechaCongelada)   ELSE
IF @TipoPeriodo = 'SEMANA' SELECT @PeriodoCongelado = DATEDIFF(week, @PrimerDia, @FechaCongelada)  ELSE
IF @TipoPeriodo = 'MES'    SELECT @PeriodoCongelado = DATEDIFF(month, @PrimerDia, @FechaCongelada)
IF @CfgPlanIgnorarZonaCongelada = 1 SELECT @PeriodoCongelado = -1
IF EXISTS(SELECT * FROM ArtPlanEx WHERE Articulo = @Articulo)
EXEC spPlanArtExcepcion @EsDistribucion, @Articulo, @SubCuenta, @Almacen,
@Ruta OUTPUT, @LoteOrdenar OUTPUT, @CantidadOrdenar OUTPUT, @MultiplosOrdenar OUTPUT, @CantidadOrdenarTiempo OUTPUT,
@TiempoEntrega OUTPUT, @TiempoEntregaUnidad OUTPUT, @TiempoEntregaSeg OUTPUT, @TiempoEntregaSegUnidad OUTPUT,
@InvSeguridad OUTPUT, @AlmacenROP OUTPUT, @RutaDistribucion OUTPUT, @Proveedor OUTPUT,
@Ok OUTPUT, @OkRef OUTPUT
IF UPPER(@AlmacenROP) = '(DEMANDA)' SELECT @AlmacenROP = @Almacen
IF @Almacen <> @AlmacenROP
SELECT /*@LoteOrdenar = 'LOTE POR LOTE', */@TiempoEntrega = 0, @TiempoEntregaSeg = 0
IF NULLIF(RTRIM(@AlmacenROP), '') IS NULL SELECT @Ok = 20855, @OkRef = RTRIM(@Articulo)
IF @LoteOrdenar = 'LOTE POR LOTE' SELECT @CantidadOrdenar = 1, @MultiplosOrdenar = 1 ELSE
IF @LoteOrdenar = 'CANTIDAD FIJA' SELECT @MultiplosOrdenar = @CantidadOrdenar
IF @CfgPlanISDemanda = 1 OR @Referencia IS NOT NULL SELECT @InvSeguridad = 0
EXEC spPlanArtLeyenda @Empresa, @Articulo, @SubCuenta, @Almacen,
@CantidadOrdenar, @MultiplosOrdenar, @CantidadOrdenarTiempo, @InvSeguridad, @TiempoEntrega,
@TiempoEntregaUnidad, @TiempoEntregaSeg, @TiempoEntregaSegUnidad
SELECT @MultiplosOrdenar = ISNULL(NULLIF(@MultiplosOrdenar, 0.0), 1)
DELETE #PlanCorrida WHERE CURRENT OF crCorrida
DELETE PlanArt
WHERE Empresa = @Empresa AND Almacen = @Almacen AND Articulo = @Articulo AND SubCuenta = @SubCuenta
AND Acronimo IN ('DA', 'DT', 'ATP', 'EP', 'RN', 'ROP', 'REP', 'LOP', 'LEP'/*, 'LOPF', 'LODF'*/)
IF @CfgPlanISDemanda = 0
DELETE PlanArt
WHERE Empresa = @Empresa AND Almacen = @Almacen AND Articulo = @Articulo AND SubCuenta = @SubCuenta
AND Acronimo = 'IS'
IF @DRP = 0 OR @EsDistribucion = 1
SELECT @RD = 'RD', @SODF = 'SODF' 
ELSE
SELECT @RD = '', @SODF = ''
IF @DRP = 0 OR @EsDistribucion = 1
INSERT PlanArt (Empresa, Almacen, Articulo, SubCuenta, Acronimo, Cantidad, Periodo)
SELECT @Empresa, @Almacen, @Articulo, @SubCuenta, 'DA', SUM(Cantidad), Periodo
FROM PlanArt
WHERE Empresa = @Empresa AND Acronimo IN ('IS', 'PV', 'PVE', 'SOL', 'OT', 'OI', 'RB', @RD)
AND Articulo = @Articulo AND SubCuenta = @SubCuenta AND Almacen = @Almacen
GROUP BY Periodo
ELSE
INSERT PlanArt (Empresa, Almacen, Articulo, SubCuenta, Acronimo, Cantidad, Periodo)
SELECT @Empresa, @Almacen, @Articulo, @SubCuenta, 'DA', SUM(Cantidad), Periodo
FROM PlanArt
WHERE Empresa = @Empresa AND Acronimo IN ('IS', 'PV', 'PVE', 'SOL', 'OT', 'OI', 'RB', @RD)
AND Articulo = @Articulo AND SubCuenta = @SubCuenta AND Almacen = @Almacen AND OrigenPlan = 0
GROUP BY Periodo
INSERT PlanArt (Empresa, Almacen, Articulo, SubCuenta, Acronimo, Cantidad, Periodo)
SELECT @Empresa, @Almacen, @Articulo, @SubCuenta, 'DT', SUM(Cantidad), Periodo
FROM PlanArt
WHERE Empresa = @Empresa AND Acronimo = 'DA'
AND Articulo = @Articulo AND SubCuenta = @SubCuenta AND Almacen = @Almacen AND Periodo <= @PeriodoCongelado
GROUP BY Periodo
INSERT PlanArt (Empresa, Almacen, Articulo, SubCuenta, Acronimo, Cantidad, Periodo)
SELECT @Empresa, @Almacen, @Articulo, @SubCuenta, 'DT', MAX(Cantidad), Periodo
FROM PlanArt
WHERE Empresa = @Empresa AND Acronimo IN ('DA', 'PRV')
AND Articulo = @Articulo AND SubCuenta = @SubCuenta AND Almacen = @Almacen AND Periodo > @PeriodoCongelado
GROUP BY Periodo
SELECT @EP = 0.0, @Ult_ATP = 0
SELECT @EP = ISNULL(SUM(Cantidad), 0.0) FROM PlanArt WHERE Empresa = @Empresa AND Almacen = @Almacen AND Articulo = @Articulo AND SubCuenta = @SubCuenta AND Acronimo = 'E' AND Periodo < 0
SELECT @ATP = @EP
IF @EP <> 0.0
INSERT PlanArt (Empresa,  Almacen,  Articulo,  SubCuenta,  Acronimo, Cantidad, Periodo)
VALUES (@Empresa, @Almacen, @Articulo, @SubCuenta, 'EP',     @EP,      -1)
SELECT @p = 0, @PeriodoInicialDemanda = NULL
WHILE @p <= @Periodos
BEGIN
SELECT @Accion = NULL, @RP = 0.0, @DT = 0.0, @RN = 0.0, @ROPF = 0.0, @REPF = 0.0, @ROP = 0.0, @IS = 0.0
IF @p = 0
BEGIN
SELECT @RP  = ISNULL(SUM(Cantidad), 0.0) FROM PlanArt WHERE Empresa = @Empresa AND Almacen = @Almacen AND Articulo = @Articulo AND SubCuenta = @SubCuenta AND Acronimo IN ('RP', 'ROPF', 'REPF') AND Periodo <= 0
SELECT @DT  = ISNULL(SUM(Cantidad), 0.0) FROM PlanArt WHERE Empresa = @Empresa AND Almacen = @Almacen AND Articulo = @Articulo AND SubCuenta = @SubCuenta AND Acronimo IN ('DT', @SODF)          AND Periodo <= 0
SELECT @DA  = ISNULL(SUM(Cantidad), 0.0) FROM PlanArt WHERE Empresa = @Empresa AND Almacen = @Almacen AND Articulo = @Articulo AND SubCuenta = @SubCuenta AND Acronimo = 'DA'                    AND Periodo <= 0
END ELSE
BEGIN
SELECT @RP  = ISNULL(SUM(Cantidad), 0.0) FROM PlanArt WHERE Empresa = @Empresa AND Almacen = @Almacen AND Articulo = @Articulo AND SubCuenta = @SubCuenta AND Acronimo IN ('RP', 'ROPF', 'REPF') AND Periodo = @p
SELECT @DT  = ISNULL(SUM(Cantidad), 0.0) FROM PlanArt WHERE Empresa = @Empresa AND Almacen = @Almacen AND Articulo = @Articulo AND SubCuenta = @SubCuenta AND Acronimo IN ('DT', @SODF)          AND Periodo = @p
SELECT @DA  = ISNULL(SUM(Cantidad), 0.0) FROM PlanArt WHERE Empresa = @Empresa AND Almacen = @Almacen AND Articulo = @Articulo AND SubCuenta = @SubCuenta AND Acronimo = 'DA'                    AND Periodo = @p
SELECT @IS  = ISNULL(SUM(Cantidad), 0.0) FROM PlanArt WHERE Empresa = @Empresa AND Almacen = @Almacen AND Articulo = @Articulo AND SubCuenta = @SubCuenta AND Acronimo = 'IS'                    AND Periodo = @p
END
/*if @p=1  and @Almacen = 'PT'
select  "EP" = @EP, "RP" = @RP, "DT" = @DT*/
SELECT @EP = @EP + @RP - @DT
IF @CfgPlanBasePresupuesto = 0 OR NULLIF(RTRIM(@LoteOrdenar), '') IS NOT NULL
BEGIN
IF ((@CfgPlanSinDemanda = 1 AND @InvSeguridad > 0) OR @DA > 0 OR @DT > 0) AND @PeriodoInicialDemanda IS NULL SELECT @PeriodoInicialDemanda = @p
IF @EP = 0.0 AND @PeriodoInicialDemanda IS NOT NULL SELECT @RN = @InvSeguridad ELSE
IF @EP < 0.0 SELECT @RN = -@EP + @InvSeguridad ELSE
IF @EP > 0.0 AND @EP < @InvSeguridad SELECT @RN = @InvSeguridad - @EP
IF @CfgPlanIgnorarZonaCongelada = 0 AND @CfgPlanSinDemanda = 0 AND @RN <= @InvSeguridad AND @p <= @PeriodoCongelado SELECT @RN = 0	
END
IF @CfgPlanBasePresupuesto = 1 AND NULLIF(RTRIM(@LoteOrdenar), '') IS NULL AND EXISTS(SELECT * FROM PlanArt WHERE Empresa = @Empresa AND Acronimo = 'DT' AND Articulo = @Articulo)
BEGIN
EXEC spPlanCoberturaEnMeses @Empresa, @Almacen, @Articulo, @SubCuenta, @p, @EP, @CoberturaEnMeses OUTPUT
IF @CoberturaEnMeses < @InvSeguridad
BEGIN
EXEC spPlanCantidadOrdenarEnMeses @Empresa, @Almacen, @Articulo, @SubCuenta, @p, @EP, @CantidadOrdenarTiempo, @RN OUTPUT
IF @EP < 0.0 SELECT @RN = -@EP
SELECT @EP2 = @EP + @RN
EXEC spPlanCoberturaEnMeses @Empresa, @Almacen, @Articulo, @SubCuenta, @p, @EP2, @CoberturaEnMeses OUTPUT
IF @CoberturaEnMeses < @InvSeguridad
BEGIN
EXEC spPlanCantidadOrdenarEnMeses @Empresa, @Almacen, @Articulo, @SubCuenta, @p, @EP2, @CantidadOrdenarTiempo, @RN2 OUTPUT
SELECT @RN = @RN + @RN2
END
END
END
/*if @p=1  and @Almacen = 'PT'
select "RN" = @RN, "EP" = @EP, "DT" = @DT, "CantidadOrdenar" = @CantidadOrdenar, "InvSeguridad" = @InvSeguridad*/
SELECT @ROPF = ISNULL(SUM(Cantidad), 0.0) FROM PlanArt WHERE Empresa = @Empresa AND Almacen = @Almacen AND Articulo = @Articulo AND SubCuenta = @SubCuenta AND Acronimo = 'ROPF' AND Periodo = @p
SELECT @REPF = ISNULL(SUM(Cantidad), 0.0) FROM PlanArt WHERE Empresa = @Empresa AND Almacen = @Almacen AND Articulo = @Articulo AND SubCuenta = @SubCuenta AND Acronimo = 'REPF' AND Periodo = @p
IF @RN > 0.0
BEGIN
SELECT @ROP = @RN
IF @LoteOrdenar IN ('CANTIDAD MINIMA / MULTIPLOS', 'CANTIDAD FIJA')
BEGIN
IF @RN < @CantidadOrdenar SELECT @ROP = @CantidadOrdenar
SELECT @ROP = ROUND(CEILING(CONVERT(float, @ROP) / @MultiplosOrdenar) * @MultiplosOrdenar, 10)
END
IF @ROP <> 0.0
BEGIN
SELECT @PeriodoROP = @p
IF @TipoPeriodo = 'DIA'    SELECT @FechaEntrega = DATEADD(day, @p, @PrimerDia)   ELSE
IF @TipoPeriodo = 'SEMANA' SELECT @FechaEntrega = DATEADD(week, @p, @PrimerDia)  ELSE
IF @TipoPeriodo = 'MES'    SELECT @FechaEntrega = DATEADD(month, @p, @PrimerDia)
IF (SELECT AbastecimientoDirecto FROM ArtAlm aa WHERE aa.Empresa = @Empresa AND aa.Almacen = @Almacen AND aa.Articulo = @Articulo AND ISNULL(aa.SubCuenta, '') = ISNULL(@SubCuenta, '')) = 1
SELECT @AlmacenROP = @Almacen
SELECT @AlmacenOrigen = @AlmacenROP, @AlmacenDestino = @Almacen
IF @AlmacenROP <> @Almacen AND @AlmacenTipo <> 'PROCESO'
BEGIN
SELECT @RO = 'REP', @LO = 'LEP', @Accion = 'Distribuir'
SELECT @AlmacenOrigen       = AlmacenOrigen,
@TiempoEntrega       = TiempoEntrega,
@TiempoEntregaUnidad = TiempoEntregaUnidad
FROM RutaDistribucionD
WHERE Ruta = @RutaDistribucion AND AlmacenDestino = @AlmacenDestino
IF @@ROWCOUNT = 0
BEGIN
SELECT @Ok = 20850, @OkRef = '<BR><BR>Origen: '+RTRIM(@AlmacenOrigen)+', Destino:'+RTRIM(@AlmacenDestino)+', Articulo:'+RTRIM(@Articulo)
END ELSE
BEGIN
IF NULLIF(RTRIM(@AlmacenOrigen), '') IS NULL SELECT @Ok = 20855, @OkRef = RTRIM(@Articulo)
IF EXISTS(SELECT * FROM Art WHERE Articulo = @Articulo AND AlmacenROP = @AlmacenOrigen) SELECT @DRPDistribucion = 0 ELSE SELECT @DRPDistribucion = 1
IF @DRP = @DRPDistribucion SELECT @VueltaDistribucion = @Vuelta + 1 ELSE SELECT @VueltaDistribucion = 0
IF NOT EXISTS(SELECT * FROM #PlanCorrida WHERE Articulo = @Articulo AND SubCuenta = @SubCuenta AND Almacen = @AlmacenOrigen AND DRP = @DRPDistribucion AND Vuelta = @VueltaDistribucion) AND @Ok IS NULL
INSERT #PlanCorrida (Articulo,  SubCuenta,  Almacen,        DRP,			Vuelta, 		EsDistribucion)
VALUES (@Articulo, @SubCuenta, @AlmacenOrigen, @DRPDistribucion,	@VueltaDistribucion, 	1)
EXEC spPlanArtLeyenda @Empresa, @Articulo, @SubCuenta, @Almacen,
@CantidadOrdenar, @MultiplosOrdenar, @CantidadOrdenarTiempo, @InvSeguridad, @TiempoEntrega,
@TiempoEntregaUnidad, @TiempoEntregaSeg, @TiempoEntregaSegUnidad
END
END ELSE
BEGIN
SELECT @RO = 'ROP', @LO = 'LOP', @Accion = NULL, @AlmacenDestino = NULL
IF @TiempoEntregaSeg > 0
BEGIN
EXEC spDecTiempo @FechaEntrega, @TiempoEntregaSeg, @TiempoEntregaSegUnidad, @FechaEntrega OUTPUT
IF @TipoPeriodo = 'DIA'    SELECT @PeriodoROP = DATEDIFF(day, @PrimerDia, @FechaEntrega)   ELSE
IF @TipoPeriodo = 'SEMANA' SELECT @PeriodoROP = DATEDIFF(week, @PrimerDia, @FechaEntrega)  ELSE
IF @TipoPeriodo = 'MES'    SELECT @PeriodoROP = DATEDIFF(month, @PrimerDia, @FechaEntrega)
END
END
INSERT PlanArt (Empresa,  Almacen,  Articulo,  SubCuenta,  Acronimo, Cantidad, Periodo)
VALUES (@Empresa, @Almacen, @Articulo, @SubCuenta, @RO,      @ROP,     @PeriodoROP)
EXEC spDecTiempo @FechaEntrega, @TiempoEntrega, @TiempoEntregaUnidad, @FechaLiberacion OUTPUT
IF @CfgPlanRecorrerLiberacion = 1
EXEC spRetrocederDiaHabil @CfgDiasHabiles, 0, @FechaLiberacion OUTPUT
IF @TipoPeriodo = 'DIA'    SELECT @FechaEntregaLOP = DATEADD(day, @PeriodoROP, @PrimerDia)  ELSE
IF @TipoPeriodo = 'SEMANA' SELECT @FechaEntregaLOP = DATEADD(week, @PeriodoROP, @PrimerDia) ELSE
IF @TipoPeriodo = 'MES'    SELECT @FechaEntregaLOP = DATEADD(month, @PeriodoROP, @PrimerDia)
EXEC spDecTiempo @FechaEntregaLOP, @TiempoEntrega, @TiempoEntregaUnidad, @FechaLiberacion OUTPUT
IF @CfgPlanRecorrerLiberacion = 1
EXEC spRetrocederDiaHabil @CfgDiasHabiles, 0, @FechaLiberacion OUTPUT
IF @TipoPeriodo = 'DIA'    SELECT @PeriodoLOP = DATEDIFF(day, @PrimerDia, @FechaLiberacion)   ELSE
IF @TipoPeriodo = 'SEMANA' SELECT @PeriodoLOP = DATEDIFF(week, @PrimerDia, @FechaLiberacion)  ELSE
IF @TipoPeriodo = 'MES'    SELECT @PeriodoLOP = DATEDIFF(month, @PrimerDia, @FechaLiberacion)
IF @Accion = 'Distribuir' AND @Ok IS NULL
BEGIN
UPDATE PlanArt
SET Cantidad = ISNULL(Cantidad, 0.0) + @ROP
WHERE Empresa = @Empresa AND Almacen = @AlmacenOrigen AND AlmacenDestino = @AlmacenDestino AND Articulo = @Articulo AND SubCuenta = @SubCuenta AND Acronimo = 'RD' AND Periodo = @PeriodoLOP
IF @@ROWCOUNT = 0
INSERT PlanArt (Empresa,  Almacen,        AlmacenDestino,  Articulo,  SubCuenta,  Acronimo, Cantidad, Periodo)
VALUES (@Empresa, @AlmacenOrigen, @AlmacenDestino, @Articulo, @SubCuenta, 'RD',     @ROP,     @PeriodoLOP)
UPDATE PlanArtFlujo
SET MaterialCantidad = ISNULL(MaterialCantidad, 0) + @ROP,
ProductoCantidad = ISNULL(ProductoCantidad, 0) + @ROP
WHERE Empresa = @Empresa AND Material = @Articulo AND MaterialPeriodo = @PeriodoLOP AND MaterialSubCuenta = ISNULL(@SubCuenta, '') AND MaterialAlmacen = @AlmacenOrigen AND MaterialAcronimo = 'LEP' AND Producto = @Articulo AND ProductoPeriodo = @PeriodoROP AND ProductoSubCuenta = ISNULL(@SubCuenta, '') AND ProductoAlmacen = @AlmacenDestino AND ProductoAcronimo = 'RD'
IF @@ROWCOUNT = 0
INSERT PlanArtFlujo (Empresa,  Material,  MaterialPeriodo, MaterialSubCuenta,      MaterialAlmacen, MaterialAcronimo, Producto,  ProductoPeriodo, ProductoSubCuenta,      ProductoAlmacen, ProductoAcronimo, MaterialCantidad, ProductoCantidad)
VALUES (@Empresa, @Articulo, @PeriodoLOP,     ISNULL(@SubCuenta, ''), @AlmacenOrigen, 'LEP',             @Articulo, @PeriodoROP,     ISNULL(@SubCuenta, ''), @AlmacenDestino,  'RD',            @ROP,             @ROP)
END
UPDATE PlanArt
SET Cantidad = ISNULL(Cantidad, 0.0) + @ROP
WHERE Empresa = @Empresa AND Almacen = @Almacen AND Articulo = @Articulo AND SubCuenta = @SubCuenta AND Acronimo = @LO AND Periodo = @PeriodoLOP
IF @@ROWCOUNT = 0
INSERT PlanArt (Empresa,  Almacen,  Articulo,  SubCuenta,  Acronimo, Cantidad, Periodo)
VALUES (@Empresa, @Almacen, @Articulo, @SubCuenta, @LO,      @ROP,     @PeriodoLOP)
IF @ArticuloEspecifico IS NULL AND (@Accion = 'Distribuir' OR @DRP = 0) AND @Ok IS NULL
BEGIN
IF ISNULL(@ROP, 0) <> 0.0
BEGIN
IF @Accion IS NULL
BEGIN
IF @SeProduce = 1 AND @CfgProd = 1 SELECT @Accion = 'Producir' ELSE SELECT @Accion = 'Comprar'
END
SELECT @Sucursal = Sucursal FROM Alm WHERE Almacen = @AlmacenOrigen
EXEC spPlanArtOPActualizar @Sucursal, @Empresa, @AlmacenOrigen, @AlmacenDestino, @Articulo, @SubCuenta,
@FechaLiberacion,  @FechaEntrega,
@ROP, @Ruta, @ArtUnidad, @Proveedor, @Accion, @EstadoOmision,
@OperacionRemota
IF @Accion = 'Producir'
EXEC spPlanArtExplotar @Empresa, @AlmacenOrigen, @Vuelta, @p, @PeriodoLOP, @Articulo, @SubCuenta, @ROP,
@ArtCantidad, @ArtUnidad, @LO,
@CfgMermaIncluida, @CfgDesperdicioIncluido, @CfgTipoMerma, @CfgMultiUnidades, @CfgMultiUnidadesNivel,
@Ok OUTPUT, @OkRef OUTPUT
END
END
END
END
SELECT @EP = @ROP + @EP + @IS
IF @EP <> 0.0
INSERT PlanArt (Empresa, Almacen, Articulo, SubCuenta, Acronimo, Cantidad, Periodo) VALUES (@Empresa, @Almacen, @Articulo, @SubCuenta, 'EP', @EP, @p)
IF @RN > 0.0
INSERT PlanArt (Empresa, Almacen, Articulo, SubCuenta, Acronimo, Cantidad, Periodo) VALUES (@Empresa, @Almacen, @Articulo, @SubCuenta, 'RN', @RN, @p)
IF @SeVende = 1 AND @CalcATP = 1
BEGIN
IF (@RP > 0.0 OR @ROP > 0.0)
BEGIN
IF @ATP < 0.0
SELECT @Ult_ATP = @Ult_ATP + 1
ELSE
WHILE @Ult_ATP < @p
BEGIN
INSERT PlanArt (Empresa, Almacen, Articulo, SubCuenta, Acronimo, Cantidad, Periodo) VALUES (@Empresa, @Almacen, @Articulo, @SubCuenta, 'ATP', @ATP, @Ult_ATP)
SELECT @Ult_ATP = @Ult_ATP + 1
END
END
SELECT @ATP = @ATP - @DA + @RP + @ROP + @IS
END
SELECT @p = @p + 1
END
IF @SeVende = 1 AND @CalcATP = 1
BEGIN
IF @ATP > 0.0
WHILE @Ult_ATP <= @Periodos
BEGIN
INSERT PlanArt (Empresa, Almacen, Articulo, SubCuenta, Acronimo, Cantidad, Periodo) VALUES (@Empresa, @Almacen, @Articulo, @SubCuenta, 'ATP', @ATP, @Ult_ATP)
SELECT @Ult_ATP = @Ult_ATP + 1
END
END
END
IF @Ok IS NOT NULL AND @ArticuloEspecifico IS NULL
BEGIN
SELECT @Mensaje = RTRIM(Descripcion)+' '+RTRIM(@OkRef) FROM MensajeLista WHERE Mensaje = @Ok
EXEC spPlanMensaje @BitacoraID, @Mensaje
IF @AbortarPrimerError = 0 SELECT @Ok = NULL, @OkRef = NULL
END
FETCH NEXT FROM crCorrida INTO @Articulo, @SubCuenta, @Almacen, @EsDistribucion
END 
CLOSE crCorrida
DEALLOCATE crCorrida
SELECT @Vuelta = @Vuelta + 1
/*
IF NOT EXISTS(SELECT * FROM #PlanCorrida)
BEGIN
INSERT #PlanCorrida (
Articulo, SubCuenta, Almacen, DRP, Vuelta, EsDistribucion)
SELECT Articulo, SubCuenta, Almacen, DRP, Vuelta, EsDistribucion
FROM #PlanCorrida2
DELETE #PlanCorrida2
END
*/
END  
IF @ArticuloEspecifico IS NULL
BEGIN
IF @Ok IS NULL AND NOT EXISTS(SELECT * FROM PlanMensaje WHERE BitacoraID = @BitacoraID)
BEGIN
UPDATE Version SET UltimaCorrida = GETDATE(), PlanReferencia = @Referencia, PlanReferenciaModulo = @ReferenciaModulo
IF @CfgPlanHist = 1 EXEC spPlanHist 1
SELECT @BitacoraEstatus = 'CONCLUIDO'
SELECT @Mensaje = "Se generó con éxito la Corrida Planeación."
END ELSE
BEGIN
SELECT @BitacoraEstatus = 'BAJA'
IF @Ok IS NULL
SELECT @Mensaje = "Se generó con ERRORES la Corrida Planeación."
ELSE BEGIN
SELECT @Mensaje = RTRIM(Descripcion)+' '+RTRIM(@OkRef) FROM MensajeLista WHERE Mensaje = @Ok
EXEC spPlanMensaje @BitacoraID, @Mensaje
END
IF @AbortarPrimerError = 1
EXEC spPlanArtBorrar @Empresa, @ArticuloEspecifico, @OperacionRemota
END
EXEC spPlanBitacoraFin @BitacoraID, @BitacoraEstatus, @Mensaje, @Empresa, @Categoria, @Grupo, @Familia, @Fabricante, @Linea, @Temporada, @Proveedor, @FechaInicio, @OperacionRemota
END
IF @OperacionServidor IS NOT NULL AND @OperacionLigarServidor = 1
EXEC sp_dropserver @OperacionServidor
IF @ArticuloEspecifico IS NULL
SELECT "Mensaje" = @Mensaje
RETURN
END

