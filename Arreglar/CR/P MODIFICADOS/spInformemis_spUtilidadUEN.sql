SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spInformemis_spUtilidadUEN
@EstacionTrabajo		int

AS BEGIN
DECLARE
@Empresa			varchar	(5),
@UEN				int,
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
@VerGraficaDetalle		bit
SELECT @Verdadero = 1, @Falso = 0
SELECT
@Empresa		=	InfoEmpresa,
@FechaD			=	InfoFechaD,
@FechaA			=	InfoFechaA,
@UEN			=	InfoUEN,
@Desglosar		=	InfoDesglosar,
@Titulo			=	RepTitulo,
@GraficarTipo	= ISNULL(InformeGraficarTipo,  '(Todos)'),
@Etiqueta		= ISNULL(InfoEtiqueta, @Falso),
@GraficarCantidad = ISNULL(InformeGraficarCantidad, 5),
@VerGraficaDetalle = ISNULL(VerGraficaDetalle,0),
@VerGraficaDetalle = ISNULL(VerGraficaDetalle,0)
FROM RepParam
WITH(NOLOCK) WHERE Estacion = @EstacionTrabajo
SELECT @ContMoneda = ContMoneda FROM EmpresaCfg WITH(NOLOCK) WHERE Empresa = @Empresa
SELECT @EmpresaNombre = Nombre FROM Empresa WITH(NOLOCK) WHERE Empresa = @Empresa
EXEC spContactoDireccionHorizontal @EstacionTrabajo, 'Empresa', @Empresa, @Empresa, 1, 1, 1, 1
SELECT @Direccion2 = Direccion2,
@Direccion3 = Direccion3,
@Direccion4 = Direccion4
FROM ContactoDireccionHorizontal
WITH(NOLOCK) WHERE Estacion = @EstacionTrabajo
DECLARE @Vermis_spUtilidadUEN TABLE
(
UEN		int		NULL,
Mov		char(20)	COLLATE Database_Default NULL,
MovID		varchar(20)	COLLATE Database_Default NULL,
DescuentoGlobal	float(8)	NULL,
CantidadNeta 	float(8)	NULL,
ImporteBruto	money		NULL,
ImporteNeto	money		NULL,
CostoNeto		money		NULL,
ComisionNeta	money		NULL,
Utilidad		money		NULL,
UtilidadPor	float(8)	NULL,
DescuentoGlobalD	float(8)	NULL,
CantidadNetaD 	float(8)	NULL,
ImporteBrutoD	money		NULL,
ImporteNetoD	money		NULL,
CostoNetoD		money		NULL,
ComisionNetaD	money		NULL,
UtilidadD		money		NULL,
UtilidadPorD	float(8)	NULL
)
DECLARE @mis_spUtilidadUEN TABLE
(
UEN		int		NULL,
Mov		char(20)	COLLATE Database_Default NULL,
MovID		varchar(20)	COLLATE Database_Default NULL,
DescuentoGlobal	float(8)	NULL,
CantidadNeta 	float(8)	NULL,
ImporteBruto	money		NULL,
ImporteNeto	money		NULL,
CostoNeto		money		NULL,
ComisionNeta	money		NULL,
Utilidad		money		NULL,
UtilidadPor	float(8)	NULL,
DescuentoGlobalD	float(8)	NULL,
CantidadNetaD 	float(8)	NULL,
ImporteBrutoD	money		NULL,
ImporteNetoD	money		NULL,
CostoNetoD		money		NULL,
ComisionNetaD	money		NULL,
UtilidadD		money		NULL,
UtilidadPorD	float(8)	NULL,
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
Reporte			varchar(200)NULL,
Direccion2			varchar(100)NULL,
Direccion3			varchar(100)NULL,
Direccion4			varchar(100)NULL,
GraficaSerie		varchar(100) COLLATE DATABASE_DEFAULT NULL,
EmpresaNombre		varchar(100) COLLATE DATABASE_DEFAULT NULL,
Nombre				varchar(100) COLLATE DATABASE_DEFAULT NULL
)
INSERT INTO @Vermis_spUtilidadUEN
EXEC mis_spUtilidadUEN @Empresa, @FechaD, @FechaA, @UEN, @Desglosar
INSERT INTO @mis_spUtilidadUEN
SELECT *, @Desglosar, @Desglosar, @FechaD, @FechaA, NULL, NULL, NULL, 0, 0, @Titulo, @Reporte, @Direccion2, @Direccion3, @Direccion4, NULL, @EmpresaNombre, @Nombre FROM @Vermis_spUtilidadUEN
SELECT @Contador = 0
DECLARE crOrden CURSOR FAST_FORWARD FOR
SELECT UEN
FROM @mis_spUtilidadUEN
ORDER BY Utilidad DESC, UEN, UtilidadD DESC
OPEN crOrden
FETCH NEXT FROM crOrden  INTO @UEN
WHILE @@FETCH_STATUS = 0
BEGIN
IF EXISTS(SELECT * FROM @mis_spUtilidadUEN WHERE UEN = @UEN AND Orden1 IS NULL)
BEGIN
SELECT @Nombre = Nombre FROM UEN WITH(NOLOCK) WHERE UEN = @UEN
SELECT @Contador = @Contador + 1
UPDATE @mis_spUtilidadUEN SET Orden1 = @Contador, Nombre = @Nombre WHERE UEN = @UEN
END
FETCH NEXT FROM crOrden  INTO @UEN
END
CLOSE crOrden
DEALLOCATE crOrden
SELECT @Utilidad = 0.00, @Venta  = 0.00, @Costo  = 0.00
DECLARE crGrafica CURSOR FAST_FORWARD FOR
SELECT UEN, Orden1, CASE WHEN @Desglosar = 'No' THEN SUM(Utilidad) ELSE SUM(UtilidadD) END, SUBSTRING(Nombre, 1, 30), CASE WHEN @Desglosar = 'No' THEN SUM(ImporteNeto) ELSE SUM(ImporteNetoD) END,CASE WHEN @Desglosar = 'No' THEN SUM(CostoNeto) ELSE SUM(CostoNetoD) END
FROM @mis_spUtilidadUEN
GROUP BY UEN, Nombre, Orden1
ORDER BY Orden1, UEN
OPEN crGrafica
FETCH NEXT FROM crGrafica  INTO @UEN, @Orden, @Utilidad, @Nombre, @Venta, @Costo
WHILE @@FETCH_STATUS = 0
BEGIN
INSERT INTO @mis_spUtilidadUEN(GraficaArgumento, GraficaValor, Grafica1, Grafica2, Orden1, GraficaSerie, Titulo, Reporte, Direccion2, Direccion3, Direccion4, EmpresaNombre, Desglosar, Desglosar2, FechaD, FechaA)
SELECT 'Costo', @Costo, 1, 0, 0, @Nombre, @Titulo, @Reporte, @Direccion2, @Direccion3, @Direccion4, @EmpresaNombre, '', @Desglosar, @FechaD, @FechaA
INSERT INTO @mis_spUtilidadUEN(GraficaArgumento, GraficaValor, Grafica1, Grafica2, Orden1, GraficaSerie, Titulo, Reporte, Direccion2, Direccion3, Direccion4, EmpresaNombre, Desglosar, Desglosar2, FechaD, FechaA)
SELECT 'Importe Venta', @Venta, 1, 0, 0, @Nombre, @Titulo, @Reporte, @Direccion2, @Direccion3, @Direccion4, @EmpresaNombre, '', @Desglosar, @FechaD, @FechaA
INSERT INTO @mis_spUtilidadUEN(GraficaArgumento, GraficaValor, Grafica1, Grafica2, Orden1, GraficaSerie, Titulo, Reporte, Direccion2, Direccion3, Direccion4, EmpresaNombre, Desglosar, Desglosar2, FechaD, FechaA)
SELECT 'Utilidad', @Utilidad, 1, 0, 0, @Nombre, @Titulo, @Reporte, @Direccion2, @Direccion3, @Direccion4, @EmpresaNombre, '', @Desglosar, @FechaD, @FechaA
FETCH NEXT FROM crGrafica  INTO @UEN, @Orden, @Utilidad, @Nombre, @Venta, @Costo
END
CLOSE crGrafica
DEALLOCATE crGrafica
SELECT @Graficar = NULL
SELECT @Graficar = ISNULL(COUNT(DISTINCT GraficaSerie),0)
FROM @mis_spUtilidadUEN
WHERE Grafica1 = 1
IF @GraficarTipo = 'Mas Sobresalientes' AND @Graficar > @GraficarCantidad
DELETE @mis_spUtilidadUEN
WHERE GraficaSerie NOT IN(
SELECT  TOP (@GraficarCantidad) GraficaSerie
FROM
(
SELECT
'GraficaSerie'   = GraficaSerie,
'GraficaValor'   = SUM(ISNULL(GraficaValor,0.00))
FROM @mis_spUtilidadUEN
WHERE Grafica1 = 1
GROUP BY GraficaSerie
) AS x
GROUP BY x.GraficaSerie
ORDER BY SUM(ISNULL(x.GraficaValor,0.00))DESC)
AND Grafica1 = 1
IF @GraficarTipo = 'Menos Sobresalientes' AND @Graficar > @GraficarCantidad
DELETE @mis_spUtilidadUEN
WHERE GraficaSerie NOT IN(
SELECT  TOP (@GraficarCantidad) GraficaSerie
FROM
(
SELECT
'GraficaSerie'   = GraficaSerie,
'GraficaValor'   = SUM(ISNULL(GraficaValor,0.00))
FROM @mis_spUtilidadUEN
WHERE Grafica1 = 1
GROUP BY GraficaSerie
) AS x
GROUP BY x.GraficaSerie
ORDER BY SUM(ISNULL(x.GraficaValor,0.00))ASC)
AND Grafica1 = 1
SELECT *, @Etiqueta as Etiqueta FROM @mis_spUtilidadUEN
END

