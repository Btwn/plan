SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spInformeInvCapaPorFecha
@EstacionTrabajo		int

AS BEGIN
DECLARE
@Empresa			varchar	(5),
@Articulo			varchar	(20),
@ArticuloD			varchar	(20),
@ArticuloA			varchar	(20),
@Nombre				varchar	(100),
@CostoTotal			float,
@Existencia			float,
@Contador			int,
@Orden				int,
@EmpresaNombre		varchar	(100),
@Titulo				varchar	(100),
@Reporte			varchar	(200),
@Direccion2			varchar	(100),
@Direccion3			varchar	(100),
@Direccion4			varchar	(100),
@FechaD				datetime,
@FechaA				datetime,
@ContMoneda			varchar	(30),
@Graficar			int,
@GraficarFecha		int,
@GraficarTipo		varchar(30),
@Etiqueta			bit,
@GraficarCantidad	int,
@Verdadero			bit,
@Falso				bit,
@InvValuacionOtraMoneda varchar(10),
@VerGraficaDetalle		bit
SELECT @Verdadero = 1, @Falso = 0
SELECT
@Empresa		=	InfoEmpresa,
@FechaD			=	InfoFechaD,
@FechaA			=	InfoFechaA,
@ArticuloD		=	InfoArticuloD,
@ArticuloA		=	InfoArticuloA,
@Titulo			=	RepTitulo,
@GraficarTipo	=	ISNULL(InformeGraficarTipo,  '(Todos)'),
@Etiqueta		=	ISNULL(InfoEtiqueta, @Falso),
@GraficarCantidad = ISNULL(InformeGraficarCantidad, 5),
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
DECLARE @InvCapaPorFecha TABLE
(
Articulo			varchar(20)	COLLATE Database_Default NULL,
Fecha				datetime	NULL,
Existencia 		float(8)	NULL,
Costo				float(8)	NULL,
Movimiento			varchar(50)	COLLATE Database_Default NULL,
Descripcion		varchar(255)COLLATE Database_Default NULL,
CostoTotal			float(8)	NULL,
FechaD				datetime	NULL,
FechaA				datetime	NULL,
Orden1				int			NULL,
GraficaArgumento	varchar(100) COLLATE DATABASE_DEFAULT NULL,
GraficaValor		float		NULL,
Grafica1			int			NULL DEFAULT 0,
Grafica2			int			NULL DEFAULT 0,
Titulo				varchar(100)COLLATE DATABASE_DEFAULT NULL,
Reporte			varchar(200)COLLATE DATABASE_DEFAULT NULL,
Direccion2			varchar(100)COLLATE DATABASE_DEFAULT NULL,
Direccion3			varchar(100)COLLATE DATABASE_DEFAULT NULL,
Direccion4			varchar(100)COLLATE DATABASE_DEFAULT NULL,
GraficaSerie		varchar(100)COLLATE DATABASE_DEFAULT NULL,
EmpresaNombre		varchar(100)COLLATE DATABASE_DEFAULT NULL,
Nombre				varchar(100)COLLATE DATABASE_DEFAULT NULL,
InvValuacionOtraMoneda			varchar(10)COLLATE DATABASE_DEFAULT DEFAULT 'NO' NULL,
OtraMonedaTipoCambio			float(8)	NULL,
OtraMonedaCostoTotal			float(8)	NULL,
Sistema			varchar(10)COLLATE DATABASE_DEFAULT NULL
)
SELECT @InvValuacionOtraMoneda = InvValuacionOtraMoneda FROM EmpresaCfg2 WHERE Empresa = @Empresa
INSERT @InvCapaPorFecha (Articulo, Fecha, Existencia, Costo, Movimiento, Descripcion, CostoTotal, InvValuacionOtraMoneda, OtraMonedaTipoCambio, OtraMonedaCostoTotal, Sistema)
SELECT InvCapa.Articulo,
InvCapa.Fecha,
dbo.fnInvCapaExistenciaPorFecha(InvCapa.ID, @FechaA) ExistenciaPorFecha,
InvCapa.Costo,
InvCapa.Mov + ' ' + ISNULL(InvCapa.MovID,''),
Art.Descripcion1,
(dbo.fnInvCapaExistenciaPorFecha(InvCapa.ID, @FechaA))*InvCapa.Costo CostoTotalPorFecha,
ISNULL(NULLIF(@InvValuacionOtraMoneda,''),'NO'),
ISNULL(InvCapa.OtraMonedaTipoCambio,1),
((dbo.fnInvCapaExistenciaPorFecha(InvCapa.ID, @FechaA))*InvCapa.Costo) * ISNULL(InvCapa.OtraMonedaTipoCambio,1),
CASE WHEN InvCapa.Sistema = 'U' THEN 'UEPS' ELSE CASE WHEN InvCapa.Sistema = 'P' THEN 'PEPS' END END
FROM InvCapa
 WITH(NOLOCK) JOIN Art  WITH(NOLOCK) ON InvCapa.Articulo=Art.Articulo
WHERE InvCapa.Empresa=@Empresa
AND InvCapa.Articulo BETWEEN @ArticuloD AND @ArticuloA
AND Fecha < @FechaA
ORDER BY InvCapa.Articulo, InvCapa.Fecha
SELECT @Contador = 0
DECLARE crOrden CURSOR FAST_FORWARD FOR
SELECT Articulo
FROM @InvCapaPorFecha
ORDER BY Articulo
OPEN crOrden
FETCH NEXT FROM crOrden  INTO @Articulo
WHILE @@FETCH_STATUS = 0
BEGIN
IF EXISTS(SELECT * FROM @InvCapaPorFecha WHERE Articulo = @Articulo AND Orden1 IS NULL)
BEGIN
SELECT @Contador = @Contador + 1
UPDATE @InvCapaPorFecha SET Orden1 = @Contador WHERE Articulo = @Articulo
END
FETCH NEXT FROM crOrden  INTO @Articulo
END
CLOSE crOrden
DEALLOCATE crOrden
SELECT @CostoTotal  = 0.00, @Existencia = 0.00
DECLARE crGrafica CURSOR FAST_FORWARD FOR
SELECT Articulo, Orden1, SUM(ISNULL(CostoTotal,0.00)), Descripcion, SUM(ISNULL(Existencia,0.00))
FROM @InvCapaPorFecha
GROUP BY Articulo, Descripcion, Orden1
HAVING SUM(ISNULL(Existencia,0.00)) <> 0
ORDER BY Orden1, Articulo
OPEN crGrafica
FETCH NEXT FROM crGrafica  INTO @Articulo, @Orden, @CostoTotal, @Nombre, @Existencia
WHILE @@FETCH_STATUS = 0
BEGIN
INSERT INTO @InvCapaPorFecha(GraficaArgumento, GraficaValor, Grafica1, Grafica2, Orden1, GraficaSerie, Titulo, Reporte, Direccion2, Direccion3, Direccion4, EmpresaNombre, FechaD, FechaA)
SELECT 'CostoTotal', @CostoTotal, 1, 0, 0, @Nombre, @Titulo, @Reporte, @Direccion2, @Direccion3, @Direccion4, @EmpresaNombre, @FechaD, @FechaA
FETCH NEXT FROM crGrafica  INTO @Articulo, @Orden, @CostoTotal, @Nombre, @Existencia
END
CLOSE crGrafica
DEALLOCATE crGrafica
SELECT @Graficar = NULL
SELECT @Graficar = ISNULL(COUNT(DISTINCT GraficaSerie),0)
FROM @InvCapaPorFecha
WHERE Grafica1 = 1
IF @GraficarTipo = 'Mas Sobresalientes' AND @Graficar > @GraficarCantidad
DELETE @InvCapaPorFecha
WHERE GraficaSerie NOT IN(
SELECT  TOP (@GraficarCantidad) GraficaSerie
FROM
(
SELECT
'GraficaSerie'   = GraficaSerie,
'GraficaValor'   = SUM(ISNULL(GraficaValor,0.00))
FROM @InvCapaPorFecha
WHERE Grafica1 = 1
GROUP BY GraficaSerie
) AS x
GROUP BY x.GraficaSerie
ORDER BY SUM(ISNULL(x.GraficaValor,0.00))DESC)
AND Grafica1 = 1
IF @GraficarTipo = 'Menos Sobresalientes' AND @Graficar > @GraficarCantidad
DELETE @InvCapaPorFecha
WHERE GraficaSerie NOT IN(
SELECT  TOP (@GraficarCantidad) GraficaSerie
FROM
(
SELECT
'GraficaSerie'   = GraficaSerie,
'GraficaValor'   = SUM(ISNULL(GraficaValor,0.00))
FROM @InvCapaPorFecha
WHERE Grafica1 = 1
GROUP BY GraficaSerie
) AS x
GROUP BY x.GraficaSerie
ORDER BY SUM(ISNULL(x.GraficaValor,0.00))ASC)
AND Grafica1 = 1
UPDATE @InvCapaPorFecha SET FechaA = @FechaA, FechaD = @FechaD, EmpresaNombre = @EmpresaNombre, Direccion2  = @Direccion2, Direccion3  = @Direccion3, Direccion4  = @Direccion4, Reporte = @Reporte, Titulo = @Titulo
SELECT *, @Etiqueta as Etiqueta, @VerGraficaDetalle as VerGraficaDetalle FROM @InvCapaPorFecha
END

