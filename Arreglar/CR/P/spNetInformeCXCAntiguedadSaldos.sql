SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spNetInformeCXCAntiguedadSaldos
@PEmpresa				varchar(5),
@PClienteD				varchar(10),
@PClienteA				varchar(10),
@PMoneda					varchar(10),
@PInfoDesglosar			varchar(20)
AS
BEGIN
DECLARE
@Empresa				varchar(5),
@ClienteD				varchar(10),
@ClienteA				varchar(10),
@Moneda					varchar(10),
@Hoy					datetime,
@De01A30D				datetime,
@De01A30A				datetime,
@De31A60D				datetime,
@De31A60A				datetime,
@De61A90D				datetime,
@De61A90A				datetime,
@De91A120D				datetime,
@De91A120A				datetime,
@MasDe120				datetime,
@Etiqueta				bit,
@VerGraficaDetalle		bit,
@InfoDesglosar			varchar(20)
DECLARE
@Cliente varchar(10),
@Mov varchar(21),
@Mon varchar(10)
SET @Empresa = @PEmpresa
SET @ClienteD = @PClienteD
SET @ClienteA = @PClienteA
SET @Moneda = @PMoneda
SET @InfoDesglosar = @PInfoDesglosar
SET @Hoy = GETDATE()
EXEC spExtraerFecha @Hoy OUTPUT
SET @De01A30D = DATEADD(day,-30,@Hoy)
SET @De01A30A = DATEADD(day,-1,@Hoy)
SET @De31A60D = DATEADD(day,-60,@Hoy)
SET @De31A60A = DATEADD(day,-31,@Hoy)
SET @De61A90D = DATEADD(day,-90,@Hoy)
SET @De61A90A = DATEADD(day,-61,@Hoy)
SET @De91A120D = DATEADD(day,-120,@Hoy)
SET @De91A120A = DATEADD(day,-91,@Hoy)
SET @MasDe120 = DATEADD(day,-121,@Hoy)
CREATE TABLE #InfoCxcDetSaldo
(
Cliente					varchar(10) COLLATE DATABASE_DEFAULT NULL,
ClienteNombre			varchar(100) COLLATE DATABASE_DEFAULT NULL,
Moneda					varchar(10) COLLATE DATABASE_DEFAULT NULL,
Mov						varchar(21) COLLATE DATABASE_DEFAULT NULL,
MovID					varchar(20) COLLATE DATABASE_DEFAULT NULL,
Referencia				varchar(50) COLLATE DATABASE_DEFAULT NULL,
FechaEmision				datetime,
Vencimiento				datetime,
DiasMoratorios			int,
AlCorriente				float,
Plazo1					float,
Plazo2					float,
Plazo3					float,
Plazo4					float,
PlazoMayor					float
)
INSERT INTO #InfoCxcDetSaldo (Cliente,ClienteNombre,Moneda,Mov,MovID,Referencia,FechaEmision,Vencimiento,DiasMoratorios,AlCorriente,Plazo1,Plazo2,Plazo3,Plazo4,PlazoMayor)
SELECT
CxcInfo.Cliente,
Cte.Nombre,
CxcInfo.Moneda,
CxcInfo.Mov,
CxcInfo.MovID,
CxcInfo.Referencia,
CxcInfo.FechaEmision,
CxcInfo.Vencimiento,
ISNULL(CASE WHEN CxcInfo.Saldo > 0.00 THEN DATEDIFF(DAY, CxcInfo.Vencimiento, @Hoy) END,0) as DiasMoratorios,
CASE WHEN ISNULL(CASE WHEN CxcInfo.Saldo > 0.00 THEN DATEDIFF(DAY, CxcInfo.Vencimiento, @Hoy) END,0) <= 0 THEN ISNULL(CxcInfo.Saldo,0)  ELSE 0 END as Alcorriente,
CASE WHEN CxcInfo.Vencimiento BETWEEN @De01A30D AND @De01A30A AND ISNULL(CASE WHEN CxcInfo.Saldo > 0.00 THEN CxcInfo.DiasMoratorios END,0) > 0 THEN ISNULL(CxcInfo.Saldo,0) ELSE 0 END as Plazo1,
CASE WHEN CxcInfo.Vencimiento BETWEEN @De31A60D AND @De31A60A AND ISNULL(CASE WHEN CxcInfo.Saldo > 0.00 THEN CxcInfo.DiasMoratorios END,0) > 0 THEN ISNULL(CxcInfo.Saldo,0) ELSE 0 END as Plazo2,
CASE WHEN CxcInfo.Vencimiento BETWEEN @De61A90D AND @De61A90A AND ISNULL(CASE WHEN CxcInfo.Saldo > 0.00 THEN CxcInfo.DiasMoratorios END,0) > 0 THEN ISNULL(CxcInfo.Saldo,0) ELSE 0 END as Plazo3,
CASE WHEN CxcInfo.Vencimiento BETWEEN @De91A120D AND @De91A120A AND ISNULL(CASE WHEN CxcInfo.Saldo > 0.00 THEN CxcInfo.DiasMoratorios END,0) > 0 THEN ISNULL(CxcInfo.Saldo,0) ELSE 0 END as Plazo4,
CASE WHEN CxcInfo.Vencimiento <= @MasDe120 AND ISNULL(CASE WHEN CxcInfo.Saldo > 0.00 THEN CxcInfo.DiasMoratorios END,0) > 0 THEN ISNULL(CxcInfo.Saldo,0) ELSE 0 END as PlazoMayor
FROM CxcInfo JOIN Cte
ON CxcInfo.Cliente = Cte.Cliente
WHERE CxcInfo.Empresa = @Empresa
AND CxcInfo.Cliente BETWEEN  @ClienteD AND @ClienteA
AND CxcInfo.Moneda = ISNULL(@Moneda, CxcInfo.Moneda)
ORDER BY CxcInfo.Cliente, CxcInfo.Moneda, CxcInfo.Mov, CxcInfo.Vencimiento DESC
IF @PInfoDesglosar = 'Si'
BEGIN
SELECT * FROM #InfoCxcDetSaldo
END
ELSE
BEGIN
SELECT DISTINCT Cliente, Moneda, SUM(ISNULL(AlCorriente,0.0)) as AlCorriente, SUM(ISNULL(Plazo1,0.0)) as Plazo1, SUM(ISNULL(Plazo2,0.0)) as Plazo2,  SUM(ISNULL(Plazo3,0.0)) as Plazo3, SUM(ISNULL(Plazo4,0.0)) as Plazo4 , SUM(ISNULL(PlazoMayor,0.0)) as PlazoMayor FROM #InfoCxcDetSaldo
WHERE #InfoCxcDetSaldo.Cliente  BETWEEN  @ClienteD AND @ClienteA
GROUP BY Cliente, Moneda ORDER BY  Cliente, Moneda
END
DROP TABLE #InfoCxcDetSaldo
END

