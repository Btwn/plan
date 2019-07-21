SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROC spCorteInvValOtraMoneda
@EstacionTrabajo		int,
@ModuloCorte			bit			= 0,
@ModuloID				int			= 0,
@Ok                		int         = NULL OUTPUT,
@OkRef             		varchar(255)= NULL OUTPUT

AS BEGIN
DECLARE
@Empresa			varchar	(5),
@ArticuloD			varchar	(20),
@ArticuloA			varchar	(20),
@EmpresaNombre		varchar	(100),
@Titulo				varchar	(100),
@Reporte			varchar	(200),
@Direccion2			varchar	(100),
@Direccion3			varchar	(100),
@Direccion4			varchar	(100),
@FechaA				datetime,
@Graficar			int,
@GraficarFecha		int,
@GraficarTipo		varchar(30),
@Etiqueta			bit,
@GraficarCantidad	int,
@Falso				bit,
@Sucursal			int,
@Sistema			char(1),
@ContMoneda			varchar(10),
@SubCuenta			varchar	(20),
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
SELECT @Falso = 0
SELECT
@Empresa		=	InfoEmpresa,
@FechaA			=	InfoFechaA,
@ArticuloD		=	CASE WHEN NULLIF(InfoArticuloD, '') IS NULL THEN (SELECT MIN(Articulo) FROM Art) ELSE NULLIF(InfoArticuloD, '') END,
@ArticuloA		=	CASE WHEN NULLIF(InfoArticuloA, '') IS NULL THEN (SELECT MAX(Articulo) FROM Art) ELSE NULLIF(InfoArticuloA, '') END,
@Titulo			=	RepTitulo,
@GraficarTipo	=	ISNULL(InformeGraficarTipo,  '(Todos)'),
@Etiqueta		=	ISNULL(InfoEtiqueta, @Falso),
@GraficarCantidad = ISNULL(InformeGraficarCantidad, 5),
@Sucursal		=	CASE WHEN InfoSucursal IN(NULL, '') THEN NULL ELSE InfoSucursal END,
@Sistema		=	CASE WHEN InfoInvValOtraMoneda = 'UEPS' THEN 'U' ELSE 'P' END,
@VerGraficaDetalle = ISNULL(VerGraficaDetalle,0)
FROM RepParam
WHERE Estacion = @EstacionTrabajo
SELECT @EmpresaNombre = Nombre FROM Empresa WHERE Empresa = @Empresa
SELECT @ContMoneda = ContMoneda FROM EmpresaCfg WHERE Empresa = @Empresa
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
DECLARE @InvValOtraMoneda TABLE
(
Empresa						char(5)		COLLATE Database_Default NULL,
Sucursal					int			NULL,
Articulo					varchar(20)	COLLATE Database_Default NULL,
Descripcion					varchar(100)COLLATE Database_Default NULL,
SubCuenta					varchar(20)	COLLATE Database_Default NULL,
Existencia					float		NULL,
CostoUnitario				money		NULL,
CostoUnitarioOtraMoneda		money		NULL,
OtraMoneda					varchar(10)	COLLATE Database_Default NULL,
EmpresaSucursal				varchar(100)COLLATE DATABASE_DEFAULT NULL,
FechaA						datetime	NULL,
GraficaArgumento			varchar(100)COLLATE DATABASE_DEFAULT NULL,
GraficaValor				float		NULL,
Grafica1					int			NULL DEFAULT 0,
Titulo						varchar(100)NULL,
Reporte						varchar(200)NULL,
Direccion2					varchar(100)NULL,
Direccion3					varchar(100)NULL,
Direccion4					varchar(100)NULL,
GraficaSerie				varchar(100)COLLATE DATABASE_DEFAULT NULL,
EmpresaNombre				varchar(100)COLLATE DATABASE_DEFAULT NULL,
ArticuloDesde				varchar(20)	COLLATE Database_Default NULL,
ArticuloHasta				varchar(20)	COLLATE Database_Default NULL,
MonedaContable				varchar(10) COLLATE DATABASE_DEFAULT NULL,
Valuacion					varchar(10) COLLATE DATABASE_DEFAULT NULL
)
INSERT INTO @InvValOtraMoneda
SELECT
ic.Empresa,
ic.Sucursal,
ic.Articulo,
a.Descripcion1,
ic.SubCuenta,
SUM(ISNULL(ica.CargoU,0.0) - ISNULL(ica.AbonoU,0.0)) Existencia,
ic.Costo CostoUnitario,
ic.Costo * ISNULL(ic.OtraMonedaTipoCambio, 1) CostoUnitarioOtraMoneda,
ISNULL(ic.OtraMoneda, @ContMoneda),
s.Nombre,
@FechaA, NULL, NULL, 0, @Titulo, @Reporte, @Direccion2, @Direccion3, @Direccion4, NULL, @EmpresaNombre, @ArticuloD, @ArticuloA, @ContMoneda, CASE WHEN @Sistema = 'U' THEN 'UEPS' ELSE 'PEPS' END
FROM InvCapa ic JOIN InvCapaAux ica
ON ic.ID = ica.ID JOIN Art a
ON ic.Articulo = a.Articulo JOIN Sucursal s
ON ic.Sucursal = s.Sucursal
WHERE ic.Empresa = @Empresa
AND ic.Articulo BETWEEN @ArticuloD AND @ArticuloA
AND ic.SubCuenta = ISNULL(@SubCuenta, ic.SubCuenta)
AND ic.Sucursal = ISNULL(@Sucursal, ic.Sucursal)
AND ica.Fecha <= @FechaA
AND ic.Sistema = @Sistema
AND ic.Activa = 1
GROUP BY ic.Empresa, ic.Sucursal, ic.Articulo, ic.SubCuenta, ic.Costo, a.Descripcion1, ic.OtraMonedaTipoCambio, ic.OtraMoneda, s.Nombre
INSERT INTO @InvValOtraMoneda
(GraficaArgumento, GraficaSerie,            GraficaValor,                         Grafica1)
SELECT Articulo,         CostoUnitarioOtraMoneda, Existencia * CostoUnitarioOtraMoneda, 1
FROM @InvValOtraMoneda
SELECT @Graficar = NULL
SELECT @Graficar = ISNULL(COUNT(DISTINCT GraficaSerie),0)
FROM @InvValOtraMoneda
WHERE Grafica1 = 1
IF @GraficarTipo = 'Mas Sobresalientes' AND @Graficar > @GraficarCantidad
DELETE @InvValOtraMoneda
WHERE GraficaArgumento NOT IN(
SELECT  TOP (@GraficarCantidad) GraficaArgumento
FROM
(
SELECT
'GraficaArgumento'   = GraficaArgumento,
'GraficaValor'   = SUM(ISNULL(GraficaValor,0.00))
FROM @InvValOtraMoneda
WHERE Grafica1 = 1
GROUP BY GraficaArgumento
) AS x
GROUP BY x.GraficaArgumento
ORDER BY SUM(ISNULL(x.GraficaValor,0.00))DESC)
AND Grafica1 = 1
IF @GraficarTipo = 'Menos Sobresalientes' AND @Graficar > @GraficarCantidad
DELETE @InvValOtraMoneda
WHERE GraficaArgumento NOT IN(
SELECT  TOP (@GraficarCantidad) GraficaArgumento
FROM
(
SELECT
'GraficaArgumento'   = GraficaArgumento,
'GraficaValor'   = SUM(ISNULL(GraficaValor,0.00))
FROM @InvValOtraMoneda
WHERE Grafica1 = 1
GROUP BY GraficaArgumento
) AS x
GROUP BY x.GraficaArgumento
ORDER BY SUM(ISNULL(x.GraficaValor,0.00))ASC)
AND Grafica1 = 1
IF ISNULL(@ModuloCorte, 0) = 0
SELECT *, @Etiqueta as Etiqueta, @VerGraficaDetalle as VerGraficaDetalle FROM @InvValOtraMoneda
ELSE
BEGIN
INSERT INTO #CorteD(
Sucursal,					Cuenta,					SubCuenta,			SaldoU,				CostoUnitario,
CostoUnitarioOtraMoneda,	Moneda,					Fecha,				MonedaContable,		ValuacionNombre,
ID)
SELECT Sucursal,					Articulo,				SubCuenta,			Existencia,			CostoUnitario,
CostoUnitarioOtraMoneda,	OtraMoneda,				FechaA,				MonedaContable,		Valuacion,
@ModuloID
FROM @InvValOtraMoneda
WHERE ISNULL(Grafica1, 0) = 0
INSERT INTO #ContactoDireccion(
Contacto,				Direccion2,				Direccion3,				Direccion4)
SELECT @Empresa,				@Direccion2,			@Direccion3,			@Direccion4
END
END

