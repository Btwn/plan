SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spInformeCXCAntiguedadSaldos
(
@EstacionTrabajo		int
)

AS
BEGIN
DECLARE
@Empresa				varchar(5),
@ClienteD				varchar(10),
@ClienteA				varchar(10),
@Moneda					varchar(10),
@Hoy					datetime,
@De01A15D				datetime,
@De01A15A				datetime,
@De16A30D				datetime,
@De16A30A				datetime,
@De31A60D				datetime,
@De31A60A				datetime,
@De61A90D				datetime,
@De61A90A				datetime,
@MasDe90				datetime,
@Etiqueta				bit,
@VerGraficaDetalle		bit,
@InfoDesglosar			varchar(20)
DECLARE @Datos TABLE
(
Estacion					int,
Empresa					varchar(5) COLLATE DATABASE_DEFAULT NULL,
EmpresaNombre			varchar(100) COLLATE DATABASE_DEFAULT NULL,
Cliente					varchar(10) COLLATE DATABASE_DEFAULT NULL,
ClienteNombre			varchar(100) COLLATE DATABASE_DEFAULT NULL,
Moneda					varchar(10) COLLATE DATABASE_DEFAULT NULL,
MonedaContable			varchar(10) COLLATE DATABASE_DEFAULT NULL,
Mov						varchar(21) COLLATE DATABASE_DEFAULT NULL,
MovID					varchar(20) COLLATE DATABASE_DEFAULT NULL,
Referencia				varchar(50) COLLATE DATABASE_DEFAULT NULL,
FechaEmision				datetime,
Vencimiento				datetime,
DiasMoratorios			int,
AlCorriente				float,
De01A15					float,
De16A30					float,
De31A60					float,
De61A90					float,
MasDe90					float,
AlCorrienteMC			float,
De01A15MC				float,
De16A30MC				float,
De31A60MC				float,
De61A90MC				float,
MasDe90MC				float,
GraficaArgumento			varchar(100) COLLATE DATABASE_DEFAULT NULL,
GraficaValor				float NULL,
Grafica					int NULL DEFAULT 0,
InfoDesglosar			varchar(20)
)
DECLARE @Grafica TABLE
(
Estacion					int NULL,
Empresa					varchar(5) COLLATE DATABASE_DEFAULT NULL,
EmpresaNombre			varchar(100) COLLATE DATABASE_DEFAULT NULL,
Cliente					varchar(10) COLLATE DATABASE_DEFAULT NULL,
ClienteNombre			varchar(100) COLLATE DATABASE_DEFAULT NULL,
Moneda					varchar(10) COLLATE DATABASE_DEFAULT NULL,
MonedaContable			varchar(10) COLLATE DATABASE_DEFAULT NULL,
Mov						varchar(20) COLLATE DATABASE_DEFAULT NULL,
MovID					varchar(20) COLLATE DATABASE_DEFAULT NULL,
Referencia				varchar(50) COLLATE DATABASE_DEFAULT NULL,
FechaEmision				datetime,
Vencimiento				datetime,
DiasMoratorios			int,
AlCorriente				float,
De01A15					float,
De16A30					float,
De31A60					float,
De61A90					float,
MasDe90					float,
AlCorrienteMC			float,
De01A15MC				float,
De16A30MC				float,
De31A60MC				float,
De61A90MC				float,
MasDe90MC				float,
GraficaArgumento			varchar(100) COLLATE DATABASE_DEFAULT NULL,
GraficaValor				float NULL,
Grafica					int NULL DEFAULT 0
)
SET @Hoy = GETDATE()
EXEC spExtraerFecha @Hoy OUTPUT
SET @De01A15D = DATEADD(day,-15,@Hoy)
SET @De01A15A = DATEADD(day,-1,@Hoy)
SET @De16A30D = DATEADD(day,-30,@Hoy)
SET @De16A30A = DATEADD(day,-16,@Hoy)
SET @De31A60D = DATEADD(day,-60,@Hoy)
SET @De31A60A = DATEADD(day,-31,@Hoy)
SET @De61A90D = DATEADD(day,-90,@Hoy)
SET @De61A90A = DATEADD(day,-61,@Hoy)
SET @MasDe90 = DATEADD(day,-91,@Hoy)
SELECT
@Empresa           =    InfoEmpresa,
@ClienteD          =    NULLIF(InfoClienteD,''),
@ClienteA          =    NULLIF(InfoClienteA,''),
@Moneda            =	CASE WHEN InfoMoneda IN( '(Todas)', '') THEN NULL ELSE InfoMoneda END,
@Etiqueta		   =	ISNULL(InfoEtiqueta,0),
@VerGraficaDetalle = ISNULL(VerGraficaDetalle,0),
@InfoDesglosar     =    ISNULL(InfoDesglosar,'No')
FROM RepParam WITH(NOLOCK)
 WHERE Estacion = @EstacionTrabajo
INSERT @Datos (Estacion, Empresa, EmpresaNombre, Cliente, ClienteNombre, Moneda, MonedaContable, Mov, MovID, Referencia, FechaEmision, Vencimiento, DiasMoratorios, AlCorriente, De01A15, De16A30, De31A60, De61A90, MasDe90, AlCorrienteMC, De01A15MC, De16A30MC, De31A60MC, De61A90MC, MasDe90MC, Grafica, InfoDesglosar)
SELECT
@EstacionTrabajo,
Empresa.Empresa,
Empresa.Nombre,
CxcInfo.Cliente,
Cte.Nombre,
CxcInfo.Moneda,
EmpresaCfg.ContMoneda,
CxcInfo.Mov,
CxcInfo.MovID,
CxcInfo.Referencia,
CxcInfo.FechaEmision,
CxcInfo.Vencimiento,
ISNULL(CASE WHEN CxcInfo.Saldo > 0.00 THEN DATEDIFF(DAY, CxcInfo.Vencimiento, @Hoy) END,0),
CASE WHEN ISNULL(CASE WHEN CxcInfo.Saldo > 0.00 THEN DATEDIFF(DAY, CxcInfo.Vencimiento, @Hoy) END,0) <= 0 THEN CxcInfo.Saldo ELSE NULL END,
CASE WHEN CxcInfo.Vencimiento BETWEEN @De01A15D AND @De01A15A AND ISNULL(CASE WHEN CxcInfo.Saldo > 0.00 THEN CxcInfo.DiasMoratorios END,0) > 0 THEN CxcInfo.Saldo ELSE NULL END,
CASE WHEN CxcInfo.Vencimiento BETWEEN @De16A30D AND @De16A30A AND ISNULL(CASE WHEN CxcInfo.Saldo > 0.00 THEN CxcInfo.DiasMoratorios END,0) > 0 THEN CxcInfo.Saldo ELSE NULL END,
CASE WHEN CxcInfo.Vencimiento BETWEEN @De31A60D AND @De31A60A AND ISNULL(CASE WHEN CxcInfo.Saldo > 0.00 THEN CxcInfo.DiasMoratorios END,0) > 0 THEN CxcInfo.Saldo ELSE NULL END,
CASE WHEN CxcInfo.Vencimiento BETWEEN @De61A90D AND @De61A90A AND ISNULL(CASE WHEN CxcInfo.Saldo > 0.00 THEN CxcInfo.DiasMoratorios END,0) > 0 THEN CxcInfo.Saldo ELSE NULL END,
CASE WHEN CxcInfo.Vencimiento <= @MasDe90 AND ISNULL(CASE WHEN CxcInfo.Saldo > 0.00 THEN CxcInfo.DiasMoratorios END,0) > 0 THEN CxcInfo.Saldo ELSE NULL END,
CASE WHEN ISNULL(CASE WHEN CxcInfo.Saldo > 0.00 THEN DATEDIFF(DAY, CxcInfo.Vencimiento, @Hoy) END,0) <= 0 THEN dbo.fnImporteAMonedaContable(CxcInfo.Saldo,Cxc.TipoCambio,EmpresaCfg.ContMoneda) ELSE NULL END,
CASE WHEN CxcInfo.Vencimiento BETWEEN @De01A15D AND @De01A15A AND ISNULL(CASE WHEN CxcInfo.Saldo > 0.00 THEN CxcInfo.DiasMoratorios END,0) > 0 THEN dbo.fnImporteAMonedaContable(CxcInfo.Saldo,Cxc.TipoCambio,EmpresaCfg.ContMoneda) ELSE NULL END,
CASE WHEN CxcInfo.Vencimiento BETWEEN @De16A30D AND @De16A30A AND ISNULL(CASE WHEN CxcInfo.Saldo > 0.00 THEN CxcInfo.DiasMoratorios END,0) > 0 THEN dbo.fnImporteAMonedaContable(CxcInfo.Saldo,Cxc.TipoCambio,EmpresaCfg.ContMoneda) ELSE NULL END,
CASE WHEN CxcInfo.Vencimiento BETWEEN @De31A60D AND @De31A60A AND ISNULL(CASE WHEN CxcInfo.Saldo > 0.00 THEN CxcInfo.DiasMoratorios END,0) > 0 THEN dbo.fnImporteAMonedaContable(CxcInfo.Saldo,Cxc.TipoCambio,EmpresaCfg.ContMoneda) ELSE NULL END,
CASE WHEN CxcInfo.Vencimiento BETWEEN @De61A90D AND @De61A90A AND ISNULL(CASE WHEN CxcInfo.Saldo > 0.00 THEN CxcInfo.DiasMoratorios END,0) > 0 THEN dbo.fnImporteAMonedaContable(CxcInfo.Saldo,Cxc.TipoCambio,EmpresaCfg.ContMoneda) ELSE NULL END,
CASE WHEN CxcInfo.Vencimiento <= @MasDe90 AND ISNULL(CASE WHEN CxcInfo.Saldo > 0.00 THEN CxcInfo.DiasMoratorios END,0) > 0 THEN dbo.fnImporteAMonedaContable(CxcInfo.Saldo,Cxc.TipoCambio,EmpresaCfg.ContMoneda) ELSE NULL END,
0, @InfoDesglosar
FROM CxcInfo  WITH(NOLOCK) JOIN Cte
 WITH(NOLOCK) ON CxcInfo.Cliente = Cte.Cliente LEFT OUTER JOIN Cxc
 WITH(NOLOCK) ON Cxc.Empresa = CxcInfo.Empresa AND Cxc.Mov = CxcInfo.Mov AND Cxc.MovID = CxcInfo.MovID LEFT OUTER JOIN Empresa
 WITH(NOLOCK) ON Empresa.Empresa = CxcInfo.Empresa JOIN EmpresaCfg
 WITH(NOLOCK) ON EmpresaCfg.Empresa = Empresa.Empresa
WHERE CxcInfo.Empresa = @Empresa
AND CxcInfo.Cliente BETWEEN @ClienteD AND @ClienteA
AND CxcInfo.Moneda = ISNULL(@Moneda, CxcInfo.Moneda)
ORDER BY CxcInfo.Cliente, CxcInfo.Moneda, CxcInfo.Mov, CxcInfo.Vencimiento DESC
INSERT @Grafica (Estacion, Empresa, EmpresaNombre, Cliente, ClienteNombre, MonedaContable, GraficaArgumento, GraficaValor, Grafica)
SELECT
@EstacionTrabajo,
Empresa.Empresa,
Empresa.Nombre,
CxcInfo.Cliente,
Cte.Nombre,
EmpresaCfg.ContMoneda,
'Al Corriente',
SUM(ISNULL(CASE WHEN ISNULL(CASE WHEN CxcInfo.Saldo > 0.00 THEN DATEDIFF(DAY, CxcInfo.Vencimiento, @Hoy) END,0) <= 0 THEN dbo.fnImporteAMonedaContable(CxcInfo.Saldo,Cxc.TipoCambio,EmpresaCfg.ContMoneda) ELSE NULL END,0.00)),
1
FROM CxcInfo  WITH(NOLOCK) JOIN Cte
 WITH(NOLOCK) ON CxcInfo.Cliente = Cte.Cliente JOIN Cxc
 WITH(NOLOCK) ON Cxc.Empresa = CxcInfo.Empresa AND Cxc.Mov = CxcInfo.Mov AND Cxc.MovID = CxcInfo.MovID JOIN Empresa
 WITH(NOLOCK) ON Empresa.Empresa = CxcInfo.Empresa JOIN EmpresaCfg
 WITH(NOLOCK) ON EmpresaCfg.Empresa = Empresa.Empresa
WHERE CxcInfo.Empresa = @Empresa
AND CxcInfo.Cliente BETWEEN @ClienteD AND @ClienteA
AND CxcInfo.Moneda = ISNULL(@Moneda, CxcInfo.Moneda)
GROUP BY Empresa.Empresa, Empresa.Nombre, CxcInfo.Cliente, Cte.Nombre, EmpresaCfg.ContMoneda
INSERT @Grafica (Estacion, Empresa, EmpresaNombre, Cliente, ClienteNombre, MonedaContable, GraficaArgumento, GraficaValor, Grafica)
SELECT
@EstacionTrabajo,
Empresa.Empresa,
Empresa.Nombre,
CxcInfo.Cliente,
Cte.Nombre,
EmpresaCfg.ContMoneda,
'de 1 a 15 días',
SUM(ISNULL(CASE WHEN CxcInfo.Vencimiento BETWEEN @De01A15D AND @De01A15A AND ISNULL(CASE WHEN CxcInfo.Saldo > 0.00 THEN CxcInfo.DiasMoratorios END,0) > 0 THEN dbo.fnImporteAMonedaContable(CxcInfo.Saldo,Cxc.TipoCambio,EmpresaCfg.ContMoneda) ELSE NULL END,0.0)),
1
FROM CxcInfo  WITH(NOLOCK) JOIN Cte
 WITH(NOLOCK) ON CxcInfo.Cliente = Cte.Cliente JOIN Cxc
 WITH(NOLOCK) ON Cxc.Empresa = CxcInfo.Empresa AND Cxc.Mov = CxcInfo.Mov AND Cxc.MovID = CxcInfo.MovID JOIN Empresa
 WITH(NOLOCK) ON Empresa.Empresa = CxcInfo.Empresa JOIN EmpresaCfg
 WITH(NOLOCK) ON EmpresaCfg.Empresa = Empresa.Empresa
WHERE CxcInfo.Empresa = @Empresa
AND CxcInfo.Cliente BETWEEN @ClienteD AND @ClienteA
AND CxcInfo.Moneda = ISNULL(@Moneda, CxcInfo.Moneda)
GROUP BY Empresa.Empresa, Empresa.Nombre, CxcInfo.Cliente, Cte.Nombre, EmpresaCfg.ContMoneda
INSERT @Grafica (Estacion, Empresa, EmpresaNombre, Cliente, ClienteNombre, MonedaContable, GraficaArgumento, GraficaValor, Grafica)
SELECT
@EstacionTrabajo,
Empresa.Empresa,
Empresa.Nombre,
CxcInfo.Cliente,
Cte.Nombre,
EmpresaCfg.ContMoneda,
'de 16 a 30 días',
SUM(ISNULL(CASE WHEN CxcInfo.Vencimiento BETWEEN @De16A30D AND @De16A30A AND ISNULL(CASE WHEN CxcInfo.Saldo > 0.00 THEN CxcInfo.DiasMoratorios END,0) > 0 THEN dbo.fnImporteAMonedaContable(CxcInfo.Saldo,Cxc.TipoCambio,EmpresaCfg.ContMoneda) ELSE NULL END,0.0)),
1
FROM CxcInfo  WITH(NOLOCK) JOIN Cte
 WITH(NOLOCK) ON CxcInfo.Cliente = Cte.Cliente JOIN Cxc
 WITH(NOLOCK) ON Cxc.Empresa = CxcInfo.Empresa AND Cxc.Mov = CxcInfo.Mov AND Cxc.MovID = CxcInfo.MovID JOIN Empresa
 WITH(NOLOCK) ON Empresa.Empresa = CxcInfo.Empresa JOIN EmpresaCfg
 WITH(NOLOCK) ON EmpresaCfg.Empresa = Empresa.Empresa
WHERE CxcInfo.Empresa = @Empresa
AND CxcInfo.Cliente BETWEEN @ClienteD AND @ClienteA
AND CxcInfo.Moneda = ISNULL(@Moneda, CxcInfo.Moneda)
GROUP BY Empresa.Empresa, Empresa.Nombre, CxcInfo.Cliente, Cte.Nombre, EmpresaCfg.ContMoneda
INSERT @Grafica (Estacion, Empresa, EmpresaNombre, Cliente, ClienteNombre, MonedaContable, GraficaArgumento, GraficaValor, Grafica)
SELECT
@EstacionTrabajo,
Empresa.Empresa,
Empresa.Nombre,
CxcInfo.Cliente,
Cte.Nombre,
EmpresaCfg.ContMoneda,
'de 31 a 60 días',
SUM(ISNULL(CASE WHEN CxcInfo.Vencimiento BETWEEN @De31A60D AND @De31A60A AND ISNULL(CASE WHEN CxcInfo.Saldo > 0.00 THEN CxcInfo.DiasMoratorios END,0) > 0 THEN dbo.fnImporteAMonedaContable(CxcInfo.Saldo,Cxc.TipoCambio,EmpresaCfg.ContMoneda) ELSE NULL END,0.0)),
1
FROM CxcInfo  WITH(NOLOCK) JOIN Cte
 WITH(NOLOCK) ON CxcInfo.Cliente = Cte.Cliente JOIN Cxc
 WITH(NOLOCK) ON Cxc.Empresa = CxcInfo.Empresa AND Cxc.Mov = CxcInfo.Mov AND Cxc.MovID = CxcInfo.MovID JOIN Empresa
 WITH(NOLOCK) ON Empresa.Empresa = CxcInfo.Empresa JOIN EmpresaCfg
 WITH(NOLOCK) ON EmpresaCfg.Empresa = Empresa.Empresa
WHERE CxcInfo.Empresa = @Empresa
AND CxcInfo.Cliente BETWEEN @ClienteD AND @ClienteA
AND CxcInfo.Moneda = ISNULL(@Moneda, CxcInfo.Moneda)
GROUP BY Empresa.Empresa, Empresa.Nombre, CxcInfo.Cliente, Cte.Nombre, EmpresaCfg.ContMoneda
INSERT @Grafica (Estacion, Empresa, EmpresaNombre, Cliente, ClienteNombre, MonedaContable, GraficaArgumento, GraficaValor, Grafica)
SELECT
@EstacionTrabajo,
Empresa.Empresa,
Empresa.Nombre,
CxcInfo.Cliente,
Cte.Nombre,
EmpresaCfg.ContMoneda,
'de 61 a 90 días',
SUM(ISNULL(CASE WHEN CxcInfo.Vencimiento BETWEEN @De61A90D AND @De61A90A AND ISNULL(CASE WHEN CxcInfo.Saldo > 0.00 THEN CxcInfo.DiasMoratorios END,0) > 0 THEN dbo.fnImporteAMonedaContable(CxcInfo.Saldo,Cxc.TipoCambio,EmpresaCfg.ContMoneda) ELSE NULL END,0.0)),
1
FROM CxcInfo  WITH(NOLOCK) JOIN Cte
 WITH(NOLOCK) ON CxcInfo.Cliente = Cte.Cliente JOIN Cxc
 WITH(NOLOCK) ON Cxc.Empresa = CxcInfo.Empresa AND Cxc.Mov = CxcInfo.Mov AND Cxc.MovID = CxcInfo.MovID JOIN Empresa
 WITH(NOLOCK) ON Empresa.Empresa = CxcInfo.Empresa JOIN EmpresaCfg
 WITH(NOLOCK) ON EmpresaCfg.Empresa = Empresa.Empresa
WHERE CxcInfo.Empresa = @Empresa
AND CxcInfo.Cliente BETWEEN @ClienteD AND @ClienteA
AND CxcInfo.Moneda = ISNULL(@Moneda, CxcInfo.Moneda)
GROUP BY Empresa.Empresa, Empresa.Nombre, CxcInfo.Cliente, Cte.Nombre, EmpresaCfg.ContMoneda
INSERT @Grafica (Estacion, Empresa, EmpresaNombre, Cliente, ClienteNombre, MonedaContable, GraficaArgumento, GraficaValor, Grafica)
SELECT
@EstacionTrabajo,
Empresa.Empresa,
Empresa.Nombre,
CxcInfo.Cliente,
Cte.Nombre,
EmpresaCfg.ContMoneda,
'm�s de 90 días',
SUM(ISNULL(CASE WHEN CxcInfo.Vencimiento <= @MasDe90 AND ISNULL(CASE WHEN CxcInfo.Saldo > 0.00 THEN CxcInfo.DiasMoratorios END,0) > 0 THEN dbo.fnImporteAMonedaContable(CxcInfo.Saldo,Cxc.TipoCambio,EmpresaCfg.ContMoneda) ELSE NULL END,0.0)),
1
FROM CxcInfo  WITH(NOLOCK) JOIN Cte
 WITH(NOLOCK) ON CxcInfo.Cliente = Cte.Cliente JOIN Cxc
 WITH(NOLOCK) ON Cxc.Empresa = CxcInfo.Empresa AND Cxc.Mov = CxcInfo.Mov AND Cxc.MovID = CxcInfo.MovID JOIN Empresa
 WITH(NOLOCK) ON Empresa.Empresa = CxcInfo.Empresa JOIN EmpresaCfg
 WITH(NOLOCK) ON EmpresaCfg.Empresa = Empresa.Empresa
WHERE CxcInfo.Empresa = @Empresa
AND CxcInfo.Cliente BETWEEN @ClienteD AND @ClienteA
AND CxcInfo.Moneda = ISNULL(@Moneda, CxcInfo.Moneda)
GROUP BY Empresa.Empresa, Empresa.Nombre, CxcInfo.Cliente, Cte.Nombre, EmpresaCfg.ContMoneda
INSERT @Datos (Estacion, Empresa, EmpresaNombre, Cliente, ClienteNombre, MonedaContable, GraficaArgumento, GraficaValor, Grafica,InfoDesglosar)
SELECT  Estacion, Empresa, EmpresaNombre, Cliente, ClienteNombre, MonedaContable, GraficaArgumento, GraficaValor, Grafica,@InfoDesglosar
FROM @Grafica
WHERE Grafica = 1
INSERT @Grafica (Estacion, Empresa, EmpresaNombre, MonedaContable, GraficaArgumento, GraficaValor, Grafica)
SELECT
@EstacionTrabajo,
Empresa.Empresa,
Empresa.Nombre,
EmpresaCfg.ContMoneda,
'Al Corriente',
SUM(ISNULL(CASE WHEN ISNULL(CASE WHEN CxcInfo.Saldo > 0.00 THEN DATEDIFF(DAY, CxcInfo.Vencimiento, @Hoy) END,0) <= 0 THEN dbo.fnImporteAMonedaContable(CxcInfo.Saldo,Cxc.TipoCambio,EmpresaCfg.ContMoneda) ELSE NULL END,0.00)),
2
FROM CxcInfo  WITH(NOLOCK) JOIN Cte
 WITH(NOLOCK) ON CxcInfo.Cliente = Cte.Cliente JOIN Cxc
 WITH(NOLOCK) ON Cxc.Empresa = CxcInfo.Empresa AND Cxc.Mov = CxcInfo.Mov AND Cxc.MovID = CxcInfo.MovID JOIN Empresa
 WITH(NOLOCK) ON Empresa.Empresa = CxcInfo.Empresa JOIN EmpresaCfg
 WITH(NOLOCK) ON EmpresaCfg.Empresa = Empresa.Empresa
WHERE CxcInfo.Empresa = @Empresa
AND CxcInfo.Cliente BETWEEN @ClienteD AND @ClienteA
AND CxcInfo.Moneda = ISNULL(@Moneda, CxcInfo.Moneda)
GROUP BY Empresa.Empresa, Empresa.Nombre, EmpresaCfg.ContMoneda
INSERT @Grafica (Estacion, Empresa, EmpresaNombre, MonedaContable, GraficaArgumento, GraficaValor, Grafica)
SELECT
@EstacionTrabajo,
Empresa.Empresa,
Empresa.Nombre,
EmpresaCfg.ContMoneda,
'de 1 a 15 días',
SUM(ISNULL(CASE WHEN CxcInfo.Vencimiento BETWEEN @De01A15D AND @De01A15A AND ISNULL(CASE WHEN CxcInfo.Saldo > 0.00 THEN CxcInfo.DiasMoratorios END,0) > 0 THEN dbo.fnImporteAMonedaContable(CxcInfo.Saldo,Cxc.TipoCambio,EmpresaCfg.ContMoneda) ELSE NULL END,0.0)),
2
FROM CxcInfo  WITH(NOLOCK) JOIN Cte
 WITH(NOLOCK) ON CxcInfo.Cliente = Cte.Cliente JOIN Cxc
 WITH(NOLOCK) ON Cxc.Empresa = CxcInfo.Empresa AND Cxc.Mov = CxcInfo.Mov AND Cxc.MovID = CxcInfo.MovID JOIN Empresa
 WITH(NOLOCK) ON Empresa.Empresa = CxcInfo.Empresa JOIN EmpresaCfg
 WITH(NOLOCK) ON EmpresaCfg.Empresa = Empresa.Empresa
WHERE CxcInfo.Empresa = @Empresa
AND CxcInfo.Cliente BETWEEN @ClienteD AND @ClienteA
AND CxcInfo.Moneda = ISNULL(@Moneda, CxcInfo.Moneda)
GROUP BY Empresa.Empresa, Empresa.Nombre, EmpresaCfg.ContMoneda
INSERT @Grafica (Estacion, Empresa, EmpresaNombre, MonedaContable, GraficaArgumento, GraficaValor, Grafica)
SELECT
@EstacionTrabajo,
Empresa.Empresa,
Empresa.Nombre,
EmpresaCfg.ContMoneda,
'de 16 a 30 días',
SUM(ISNULL(CASE WHEN CxcInfo.Vencimiento BETWEEN @De16A30D AND @De16A30A AND ISNULL(CASE WHEN CxcInfo.Saldo > 0.00 THEN CxcInfo.DiasMoratorios END,0) > 0 THEN dbo.fnImporteAMonedaContable(CxcInfo.Saldo,Cxc.TipoCambio,EmpresaCfg.ContMoneda) ELSE NULL END,0.0)),
2
FROM CxcInfo  WITH(NOLOCK) JOIN Cte
 WITH(NOLOCK) ON CxcInfo.Cliente = Cte.Cliente JOIN Cxc
 WITH(NOLOCK) ON Cxc.Empresa = CxcInfo.Empresa AND Cxc.Mov = CxcInfo.Mov AND Cxc.MovID = CxcInfo.MovID JOIN Empresa
 WITH(NOLOCK) ON Empresa.Empresa = CxcInfo.Empresa JOIN EmpresaCfg
 WITH(NOLOCK) ON EmpresaCfg.Empresa = Empresa.Empresa
WHERE CxcInfo.Empresa = @Empresa
AND CxcInfo.Cliente BETWEEN @ClienteD AND @ClienteA
AND CxcInfo.Moneda = ISNULL(@Moneda, CxcInfo.Moneda)
GROUP BY Empresa.Empresa, Empresa.Nombre, EmpresaCfg.ContMoneda
INSERT @Grafica (Estacion, Empresa, EmpresaNombre, MonedaContable, GraficaArgumento, GraficaValor, Grafica)
SELECT
@EstacionTrabajo,
Empresa.Empresa,
Empresa.Nombre,
EmpresaCfg.ContMoneda,
'de 31 a 60 días',
SUM(ISNULL(CASE WHEN CxcInfo.Vencimiento BETWEEN @De31A60D AND @De31A60A AND ISNULL(CASE WHEN CxcInfo.Saldo > 0.00 THEN CxcInfo.DiasMoratorios END,0) > 0 THEN dbo.fnImporteAMonedaContable(CxcInfo.Saldo,Cxc.TipoCambio,EmpresaCfg.ContMoneda) ELSE NULL END,0.0)),
2
FROM CxcInfo  WITH(NOLOCK) JOIN Cte
 WITH(NOLOCK) ON CxcInfo.Cliente = Cte.Cliente JOIN Cxc
 WITH(NOLOCK) ON Cxc.Empresa = CxcInfo.Empresa AND Cxc.Mov = CxcInfo.Mov AND Cxc.MovID = CxcInfo.MovID JOIN Empresa
 WITH(NOLOCK) ON Empresa.Empresa = CxcInfo.Empresa JOIN EmpresaCfg
 WITH(NOLOCK) ON EmpresaCfg.Empresa = Empresa.Empresa
WHERE CxcInfo.Empresa = @Empresa
AND CxcInfo.Cliente BETWEEN @ClienteD AND @ClienteA
AND CxcInfo.Moneda = ISNULL(@Moneda, CxcInfo.Moneda)
GROUP BY Empresa.Empresa, Empresa.Nombre, EmpresaCfg.ContMoneda
INSERT @Grafica (Estacion, Empresa, EmpresaNombre, MonedaContable, GraficaArgumento, GraficaValor, Grafica)
SELECT
@EstacionTrabajo,
Empresa.Empresa,
Empresa.Nombre,
EmpresaCfg.ContMoneda,
'de 61 a 90 días',
SUM(ISNULL(CASE WHEN CxcInfo.Vencimiento BETWEEN @De61A90D AND @De61A90A AND ISNULL(CASE WHEN CxcInfo.Saldo > 0.00 THEN CxcInfo.DiasMoratorios END,0) > 0 THEN dbo.fnImporteAMonedaContable(CxcInfo.Saldo,Cxc.TipoCambio,EmpresaCfg.ContMoneda) ELSE NULL END,0.0)),
2
FROM CxcInfo  WITH(NOLOCK) JOIN Cte
 WITH(NOLOCK) ON CxcInfo.Cliente = Cte.Cliente JOIN Cxc
 WITH(NOLOCK) ON Cxc.Empresa = CxcInfo.Empresa AND Cxc.Mov = CxcInfo.Mov AND Cxc.MovID = CxcInfo.MovID JOIN Empresa
 WITH(NOLOCK) ON Empresa.Empresa = CxcInfo.Empresa JOIN EmpresaCfg
 WITH(NOLOCK) ON EmpresaCfg.Empresa = Empresa.Empresa
WHERE CxcInfo.Empresa = @Empresa
AND CxcInfo.Cliente BETWEEN @ClienteD AND @ClienteA
AND CxcInfo.Moneda = ISNULL(@Moneda, CxcInfo.Moneda)
GROUP BY Empresa.Empresa, Empresa.Nombre, EmpresaCfg.ContMoneda
INSERT @Grafica (Estacion, Empresa, EmpresaNombre, MonedaContable, GraficaArgumento, GraficaValor, Grafica)
SELECT
@EstacionTrabajo,
Empresa.Empresa,
Empresa.Nombre,
EmpresaCfg.ContMoneda,
'm�s de 90 días',
SUM(ISNULL(CASE WHEN CxcInfo.Vencimiento <= @MasDe90 AND ISNULL(CASE WHEN CxcInfo.Saldo > 0.00 THEN CxcInfo.DiasMoratorios END,0) > 0 THEN dbo.fnImporteAMonedaContable(CxcInfo.Saldo,Cxc.TipoCambio,EmpresaCfg.ContMoneda) ELSE NULL END,0.0)),
2
FROM CxcInfo  WITH(NOLOCK) JOIN Cte
 WITH(NOLOCK) ON CxcInfo.Cliente = Cte.Cliente JOIN Cxc
 WITH(NOLOCK) ON Cxc.Empresa = CxcInfo.Empresa AND Cxc.Mov = CxcInfo.Mov AND Cxc.MovID = CxcInfo.MovID JOIN Empresa
 WITH(NOLOCK) ON Empresa.Empresa = CxcInfo.Empresa JOIN EmpresaCfg
 WITH(NOLOCK) ON EmpresaCfg.Empresa = Empresa.Empresa
WHERE CxcInfo.Empresa = @Empresa
AND CxcInfo.Cliente BETWEEN @ClienteD AND @ClienteA
AND CxcInfo.Moneda = ISNULL(@Moneda, CxcInfo.Moneda)
GROUP BY Empresa.Empresa, Empresa.Nombre, EmpresaCfg.ContMoneda
INSERT @Datos (Estacion, Empresa, EmpresaNombre, MonedaContable, GraficaArgumento, GraficaValor, Grafica,InfoDesglosar)
SELECT  Estacion, Empresa, EmpresaNombre, MonedaContable, GraficaArgumento, GraficaValor, Grafica,@InfoDesglosar
FROM @Grafica
WHERE Grafica = 2
SELECT *, @Etiqueta as Etiqueta, @VerGraficaDetalle as VerGraficaDetalle FROM @Datos ORDER BY Grafica
END

