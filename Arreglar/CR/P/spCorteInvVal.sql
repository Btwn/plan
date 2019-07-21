SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spCorteInvVal
@EstacionTrabajo		int,
@ModuloCorte			bit		= 0,
@ModuloID				int		= 0,
@Ok                		int         = NULL OUTPUT,
@OkRef             		varchar(255)= NULL OUTPUT

AS BEGIN
DECLARE
@Empresa			varchar	(5),
@Articulo			varchar	(20),
@ArticuloD			varchar	(20),
@ArticuloA			varchar	(20),
@Almacen			varchar	(20),
@Valuacion			varchar	(50),
@Nombre				varchar	(100),
@Contador			int,
@Orden				int,
@EmpresaNombre		varchar	(100),
@Titulo				varchar	(100),
@Reporte			varchar	(200),
@Direccion2			varchar	(100),
@Direccion3			varchar	(100),
@Direccion4			varchar	(100),
@Desglosar			varchar	(50),
@FechaD				datetime,
@FechaA				datetime,
@ContMoneda			varchar	(30),
@Venta				float,
@Costo				float,
@Utilidad			float,
@Graficar			int,
@GraficarFecha		int,
@GraficarTipo		varchar(30),
@Etiqueta			bit,
@GraficarCantidad	int,
@Verdadero			bit,
@Falso				bit,
@VerGraficaDetalle	bit
DECLARE @ContactoDireccion TABLE
(
Contacto				varchar(10)  COLLATE DATABASE_DEFAULT NULL,
Direccion1				varchar(255) COLLATE DATABASE_DEFAULT NULL,
Direccion2				varchar(255) COLLATE DATABASE_DEFAULT NULL,
Direccion3				varchar(255) COLLATE DATABASE_DEFAULT NULL,
Direccion4				varchar(255) COLLATE DATABASE_DEFAULT NULL,
Direccion5				varchar(255) COLLATE DATABASE_DEFAULT NULL,
Direccion6				varchar(255) COLLATE DATABASE_DEFAULT NULL,
Direccion7				varchar(255) COLLATE DATABASE_DEFAULT NULL,
Direccion8				varchar(255) COLLATE DATABASE_DEFAULT NULL
)
SELECT @Verdadero = 1, @Falso = 0
SELECT
@Empresa		=	InfoEmpresa,
@FechaA			=	InfoFechaA,
@ArticuloD		=	InfoArticuloD,
@ArticuloA		=	InfoArticuloA,
@Almacen		=	CASE WHEN InfoAlmacen IN('', '(Todos)', '(Todas)') THEN NULL ELSE InfoAlmacen END,
@Valuacion		=	ISNULL(InfoInvVal, '(Sin Valuar)'),
@Desglosar		=	InfoDesglosar,
@Titulo			=	RepTitulo,
@GraficarTipo	= ISNULL(InformeGraficarTipo,  '(Todos)'),
@Etiqueta		= ISNULL(InfoEtiqueta, @Falso),
@GraficarCantidad = ISNULL(InformeGraficarCantidad, 5),
@VerGraficaDetalle = ISNULL(VerGraficaDetalle,0)
FROM RepParam
WHERE Estacion = @EstacionTrabajo
SELECT @ContMoneda = ContMoneda FROM EmpresaCfg WHERE Empresa = @Empresa
SELECT @EmpresaNombre = Nombre FROM Empresa WHERE Empresa = @Empresa
EXEC spContactoDireccionHorizontal @EstacionTrabajo, 'Empresa', @Empresa, @Empresa, 1,1,1,1
INSERT @ContactoDireccion(
Contacto, Direccion1, Direccion2, Direccion3, Direccion4,Direccion5, Direccion6, Direccion7, Direccion8)
SELECT Contacto, Direccion1, Direccion2, Direccion3, Direccion4,Direccion5, Direccion6, Direccion7, Direccion8
FROM ContactoDireccionHorizontal
WHERE Estacion = @EstacionTrabajo
SELECT @Direccion2 = Direccion2,
@Direccion3 = Direccion3,
@Direccion4 = Direccion4
FROM @ContactoDireccion
/*
SELECT @Direccion2 = Direccion2,
@Direccion3 = Direccion3,
@Direccion4 = Direccion4
FROM dbo.fnContactoDireccionHorizontal('Empresa', @Empresa, 1, 1, 1, 1)
*/
DECLARE @VerInvVal TABLE
(
ID					int			NULL,
Articulo			char(20)	COLLATE Database_Default NULL,
Descripcion			varchar(100)COLLATE Database_Default NULL,
PrecioLista			money		NULL,
Precio2				money		NULL,
Precio3				money		NULL,
Precio4				money		NULL,
Precio5				money		NULL,
Precio6				money		NULL,
Precio7				money		NULL,
Precio8				money		NULL,
Precio9				money		NULL,
Precio10			money		NULL,
CostoEstandar		money		NULL,
CostoReposicion		money		NULL,
CostoPromedio		money		NULL,
UltimoCosto			money		NULL,
Moneda				char(10)	COLLATE Database_Default NULL,
Almacen				char(10)	COLLATE Database_Default NULL,
Nombre2				varchar(100)COLLATE Database_Default NULL,
Existencias			float		NULL
)
DECLARE @InvVal TABLE
(
ID					int			NULL,
Articulo			char(20)	COLLATE Database_Default NULL,
Descripcion			varchar(100)COLLATE Database_Default NULL,
PrecioLista			money		NULL,
Precio2				money		NULL,
Precio3				money		NULL,
Precio4				money		NULL,
Precio5				money		NULL,
Precio6				money		NULL,
Precio7				money		NULL,
Precio8				money		NULL,
Precio9				money		NULL,
Precio10			money		NULL,
CostoEstandar		money		NULL,
CostoReposicion		money		NULL,
CostoPromedio		money		NULL,
UltimoCosto			money		NULL,
Moneda				char(10)	COLLATE Database_Default NULL,
Almacen				char(10)	COLLATE Database_Default NULL,
Nombre2				varchar(100)COLLATE Database_Default NULL,
Existencias			float		NULL,
Desglosar			varchar(5)	NULL,
Desglosar2			varchar(5)	NULL,
FechaD				datetime	NULL,
FechaA				datetime	NULL,
Orden1				int			NULL,
GraficaArgumento	varchar(100) COLLATE DATABASE_DEFAULT NULL,
GraficaValor		float		NULL,
Grafica1			int			NULL DEFAULT 0,
Grafica2			int			NULL DEFAULT 0,
Titulo				varchar(100)NULL,
Reporte				varchar(200)NULL,
Direccion2			varchar(100)NULL,
Direccion3			varchar(100)NULL,
Direccion4			varchar(100)NULL,
GraficaSerie		varchar(100) COLLATE DATABASE_DEFAULT NULL,
EmpresaNombre		varchar(100) COLLATE DATABASE_DEFAULT NULL,
Nombre				varchar(100)COLLATE DATABASE_DEFAULT NULL,
ValuacionNombre		varchar(100)COLLATE DATABASE_DEFAULT NULL,
ValuacionValor		float		NULL,
ValuacionValorArtConCosto		float		NULL
)
INSERT INTO @VerInvVal
EXEC spInvVal @ArticuloD, @ArticuloA, @Almacen, @Valuacion, @FechaA, @Empresa
INSERT INTO @InvVal
SELECT *, @Desglosar, @Desglosar, @FechaD, @FechaA, NULL, NULL, NULL, 0, 0, @Titulo, @Reporte, @Direccion2, @Direccion3, @Direccion4, NULL, @EmpresaNombre, @Nombre, @Valuacion,
CASE @Valuacion WHEN 'Costo Promedio'	THEN ISNULL(CostoPromedio,0.00)
WHEN 'Ultimo Costo'		THEN ISNULL(UltimoCosto,0.00)
WHEN 'Costo Estandar'	THEN ISNULL(CostoEstandar,0.00)
WHEN 'Costo Reposicion' THEN ISNULL(CostoReposicion,0.00)
WHEN 'Precio Lista'		THEN ISNULL(PrecioLista,0.00)
WHEN 'Precio 2'			THEN ISNULL(Precio2,0.00)
WHEN 'Precio 3'			THEN ISNULL(Precio3,0.00)
WHEN 'Precio 4'			THEN ISNULL(Precio4,0.00)
WHEN 'Precio 5'			THEN ISNULL(Precio5,0.00)
WHEN 'Precio 6'			THEN ISNULL(Precio6,0.00)
WHEN 'Precio 7'			THEN ISNULL(Precio7,0.00)
WHEN 'Precio 8'			THEN ISNULL(Precio8,0.00)
WHEN 'Precio 9'			THEN ISNULL(Precio9,0.00)
WHEN 'Precio 10'		THEN ISNULL(Precio10,0.00)
ELSE 0.00				END, NULL
FROM @VerInvVal
SELECT @Contador = 0
DECLARE crOrden CURSOR FAST_FORWARD FOR
SELECT Articulo
FROM @InvVal
ORDER BY Articulo
OPEN crOrden
FETCH NEXT FROM crOrden INTO @Articulo
WHILE @@FETCH_STATUS = 0
BEGIN
IF EXISTS(SELECT * FROM @InvVal WHERE Articulo = @Articulo AND Orden1 IS NULL)
BEGIN
SELECT @Nombre = Descripcion1 FROM Art WHERE articulo = @Articulo
SELECT @Contador = @Contador + 1
UPDATE @InvVal SET Orden1 = @Contador, Nombre = @Nombre WHERE Articulo = @Articulo
END
UPDATE @InvVal
SET ValuacionValorArtConCosto =	CASE @Valuacion	WHEN 'Costo Promedio'	THEN (SELECT CostoPromedio	 FROM ArtConCosto WHERE Articulo = @Articulo AND Empresa = @Empresa)
WHEN 'Ultimo Costo'		THEN (SELECT UltimoCosto	 FROM ArtConCosto WHERE Articulo = @Articulo AND Empresa = @Empresa)
WHEN 'Costo Estandar'	THEN (SELECT CostoEstandar	 FROM ArtConCosto WHERE Articulo = @Articulo AND Empresa = @Empresa)
WHEN 'Costo Reposicion' THEN (SELECT CostoReposicion FROM ArtConCosto WHERE Articulo = @Articulo AND Empresa = @Empresa)
ELSE ValuacionValor
END
WHERE Articulo = @Articulo
FETCH NEXT FROM crOrden INTO @Articulo
END
CLOSE crOrden
DEALLOCATE crOrden
SELECT @Costo  = 0.00
DECLARE crGrafica CURSOR FAST_FORWARD FOR
SELECT Articulo, Orden1, SUM(ISNULL(CostoPromedio,0.00)), Nombre
FROM @InvVal
GROUP BY Articulo, Nombre, Orden1
ORDER BY Orden1, Articulo
OPEN crGrafica
FETCH NEXT FROM crGrafica INTO @Articulo, @Orden, @Costo, @Nombre
WHILE @@FETCH_STATUS = 0
BEGIN
INSERT INTO @InvVal(GraficaArgumento, GraficaValor, Grafica1, Grafica2, Orden1, GraficaSerie, Titulo, Reporte, Direccion2, Direccion3, Direccion4, EmpresaNombre, Desglosar, Desglosar2, FechaD, FechaA, ValuacionNombre, ValuacionValor)
SELECT @Valuacion, @Costo, 1, 0, 0, @Nombre, @Titulo, @Reporte, @Direccion2, @Direccion3, @Direccion4, @EmpresaNombre, '', @Desglosar, @FechaD, @FechaA, @Valuacion, 0.00
FETCH NEXT FROM crGrafica INTO @Articulo, @Orden, @Costo, @Nombre
END
CLOSE crGrafica
DEALLOCATE crGrafica
SELECT @Graficar = NULL
SELECT @Graficar = ISNULL(COUNT(DISTINCT GraficaSerie),0)
FROM @InvVal
WHERE Grafica1 = 1
IF @GraficarTipo = 'Mas Sobresalientes' AND @Graficar > @GraficarCantidad
DELETE @InvVal
WHERE GraficaSerie NOT IN(
SELECT  TOP (@GraficarCantidad) GraficaSerie
FROM
(
SELECT
'GraficaSerie'   = GraficaSerie,
'GraficaValor'   = SUM(ISNULL(GraficaValor,0.00))
FROM @InvVal
WHERE Grafica1 = 1
GROUP BY GraficaSerie
) AS x
GROUP BY x.GraficaSerie
ORDER BY SUM(ISNULL(x.GraficaValor,0.00))DESC)
AND Grafica1 = 1
IF @GraficarTipo = 'Menos Sobresalientes' AND @Graficar > @GraficarCantidad
DELETE @InvVal
WHERE GraficaSerie NOT IN(
SELECT  TOP (@GraficarCantidad) GraficaSerie
FROM
(
SELECT
'GraficaSerie'   = GraficaSerie,
'GraficaValor'   = SUM(ISNULL(GraficaValor,0.00))
FROM @InvVal
WHERE Grafica1 = 1
GROUP BY GraficaSerie
) AS x
GROUP BY x.GraficaSerie
ORDER BY SUM(ISNULL(x.GraficaValor,0.00))ASC)
AND Grafica1 = 1
IF ISNULL(@ModuloCorte, 0) = 0
SELECT *, @Etiqueta as Etiqueta, @VerGraficaDetalle as VerGraficaDetalle FROM @InvVal
ELSE
BEGIN
INSERT INTO #CorteD(
Cuenta,						PrecioLista,			Precio2,			Precio3,			Precio4,			Precio5,			Precio6,
Precio7,					Precio8,				Precio9,			Precio10,			CostoEstandar,		CostoReposicion,	CostoPromedio,
UltimoCosto,				Moneda,					Grupo,				SaldoU,				Fecha,				ValuacionNombre,	ValuacionValor,
ValuacionValorArtConCosto,	ID)
SELECT Articulo,					PrecioLista,			Precio2,			Precio3,			Precio4,			Precio5,			Precio6,
Precio7,					Precio8,				Precio9,			Precio10,			CostoEstandar,		CostoReposicion,	CostoPromedio,
UltimoCosto,				Moneda,					Almacen,			Existencias,		FechaA,				ValuacionNombre,	ValuacionValor,
ValuacionValorArtConCosto,	@ModuloID
FROM @InvVal
WHERE ISNULL(Orden1, 0) <> 0
INSERT INTO #ContactoDireccion(
Contacto,				Direccion2,				Direccion3,				Direccion4)
SELECT @Empresa,				@Direccion2,			@Direccion3,			@Direccion4
END
END

