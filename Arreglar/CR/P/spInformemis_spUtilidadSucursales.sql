SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spInformemis_spUtilidadSucursales
@EstacionTrabajo		int

AS BEGIN
DECLARE
@Empresa			varchar	(5),
@Sucursal			int,
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
@Sucursal		=	InfoSucursal,
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
EXEC spContactoDireccionHorizontal @EstacionTrabajo, 'Empresa', @Empresa, @Empresa, 1, 1, 1, 1
SELECT @Direccion2 = Direccion2,
@Direccion3 = Direccion3,
@Direccion4 = Direccion4
FROM ContactoDireccionHorizontal
WHERE Estacion = @EstacionTrabajo
DECLARE @Vermis_spUtilidadSucursales TABLE
(
Sucursal		int		NULL,
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
DECLARE @mis_spUtilidadSucursales TABLE
(
Sucursal		int		NULL,
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
INSERT INTO @Vermis_spUtilidadSucursales
EXEC mis_spUtilidadSucursal @Empresa, @FechaD, @FechaA, @Sucursal, @Desglosar
INSERT INTO @mis_spUtilidadSucursales
SELECT *, @Desglosar, @Desglosar, @FechaD, @FechaA, NULL, NULL, NULL, 0, 0, @Titulo, @Reporte, @Direccion2, @Direccion3, @Direccion4, NULL, @EmpresaNombre, @Nombre FROM @Vermis_spUtilidadSucursales
SELECT @Contador = 0
DECLARE crOrden CURSOR FAST_FORWARD FOR
SELECT Sucursal
FROM @mis_spUtilidadSucursales
ORDER BY Utilidad DESC, Sucursal, UtilidadD DESC
OPEN crOrden
FETCH NEXT FROM crOrden INTO @Sucursal
WHILE @@FETCH_STATUS = 0
BEGIN
IF EXISTS(SELECT * FROM @mis_spUtilidadSucursales WHERE Sucursal = @Sucursal AND Orden1 IS NULL)
BEGIN
SELECT @Nombre = Nombre FROM Sucursal WHERE Sucursal = @Sucursal
SELECT @Contador = @Contador + 1
UPDATE @mis_spUtilidadSucursales SET Orden1 = @Contador, Nombre = @Nombre WHERE Sucursal = @Sucursal
END
FETCH NEXT FROM crOrden INTO @Sucursal
END
CLOSE crOrden
DEALLOCATE crOrden
SELECT @Utilidad = 0.00, @Venta  = 0.00, @Costo  = 0.00
DECLARE crGrafica CURSOR FAST_FORWARD FOR
SELECT Sucursal, Orden1, CASE WHEN @Desglosar = 'No' THEN SUM(Utilidad) ELSE SUM(UtilidadD) END, SUBSTRING(Nombre, 1, 30), CASE WHEN @Desglosar = 'No' THEN SUM(ImporteNeto) ELSE SUM(ImporteNetoD) END,CASE WHEN @Desglosar = 'No' THEN SUM(CostoNeto) ELSE SUM(CostoNetoD) END
FROM @mis_spUtilidadSucursales
GROUP BY Sucursal, Nombre, Orden1
ORDER BY Orden1, Sucursal
OPEN crGrafica
FETCH NEXT FROM crGrafica INTO @Sucursal, @Orden, @Utilidad, @Nombre, @Venta, @Costo
WHILE @@FETCH_STATUS = 0
BEGIN
INSERT INTO @mis_spUtilidadSucursales(GraficaArgumento, GraficaValor, Grafica1, Grafica2, Orden1, GraficaSerie, Titulo, Reporte, Direccion2, Direccion3, Direccion4, EmpresaNombre, Desglosar, Desglosar2, FechaD, FechaA)
SELECT 'Costo', @Costo, 1, 0, 0, @Nombre, @Titulo, @Reporte, @Direccion2, @Direccion3, @Direccion4, @EmpresaNombre, '', @Desglosar, @FechaD, @FechaA
INSERT INTO @mis_spUtilidadSucursales(GraficaArgumento, GraficaValor, Grafica1, Grafica2, Orden1, GraficaSerie, Titulo, Reporte, Direccion2, Direccion3, Direccion4, EmpresaNombre, Desglosar, Desglosar2, FechaD, FechaA)
SELECT 'Importe Venta', @Venta, 1, 0, 0, @Nombre, @Titulo, @Reporte, @Direccion2, @Direccion3, @Direccion4, @EmpresaNombre, '', @Desglosar, @FechaD, @FechaA
INSERT INTO @mis_spUtilidadSucursales(GraficaArgumento, GraficaValor, Grafica1, Grafica2, Orden1, GraficaSerie, Titulo, Reporte, Direccion2, Direccion3, Direccion4, EmpresaNombre, Desglosar, Desglosar2, FechaD, FechaA)
SELECT 'Utilidad', @Utilidad, 1, 0, 0, @Nombre, @Titulo, @Reporte, @Direccion2, @Direccion3, @Direccion4, @EmpresaNombre, '', @Desglosar, @FechaD, @FechaA
FETCH NEXT FROM crGrafica INTO @Sucursal, @Orden, @Utilidad, @Nombre, @Venta, @Costo
END
CLOSE crGrafica
DEALLOCATE crGrafica
SELECT @Graficar = NULL
SELECT @Graficar = ISNULL(COUNT(DISTINCT GraficaSerie),0)
FROM @mis_spUtilidadSucursales
WHERE Grafica1 = 1
IF @GraficarTipo = 'Mas Sobresalientes' AND @Graficar > @GraficarCantidad
DELETE @mis_spUtilidadSucursales
WHERE GraficaSerie NOT IN(
SELECT  TOP (@GraficarCantidad) GraficaSerie
FROM
(
SELECT
'GraficaSerie'   = GraficaSerie,
'GraficaValor'   = SUM(ISNULL(GraficaValor,0.00))
FROM @mis_spUtilidadSucursales
WHERE Grafica1 = 1
GROUP BY GraficaSerie
) AS x
GROUP BY x.GraficaSerie
ORDER BY SUM(ISNULL(x.GraficaValor,0.00))DESC)
AND Grafica1 = 1
IF @GraficarTipo = 'Menos Sobresalientes' AND @Graficar > @GraficarCantidad
DELETE @mis_spUtilidadSucursales
WHERE GraficaSerie NOT IN(
SELECT  TOP (@GraficarCantidad) GraficaSerie
FROM
(
SELECT
'GraficaSerie'   = GraficaSerie,
'GraficaValor'   = SUM(ISNULL(GraficaValor,0.00))
FROM @mis_spUtilidadSucursales
WHERE Grafica1 = 1
GROUP BY GraficaSerie
) AS x
GROUP BY x.GraficaSerie
ORDER BY SUM(ISNULL(x.GraficaValor,0.00))ASC)
AND Grafica1 = 1
SELECT *, @Etiqueta as Etiqueta, @VerGraficaDetalle as VerGraficaDetalle FROM @mis_spUtilidadSucursales
END

