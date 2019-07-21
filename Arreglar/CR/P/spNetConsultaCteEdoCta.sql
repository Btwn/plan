SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spNetConsultaCteEdoCta
@Desde			varchar(100),
@Hasta			varchar(100),
@Cliente		varchar(10),
@Empresa		varchar(50)
AS BEGIN
DECLARE
@DesdeD		date,
@HastaD		date
SET @DesdeD =  Convert(date,@Desde,120)
SET @HastaD =  Convert(date,@Hasta,120)
DECLARE @EstadoCuentaCtes TABLE
(
MODULOID     INT NULL,
MOV          VARCHAR(20) NULL,
MOVID        VARCHAR(20) NULL,
Fecha        DATETIME NULL,
Concepto     VARCHAR(100) NULL,
Moneda       VARCHAR(20) NULL,
TipoCambio   MONEY NULL,
Cargo        MONEY NULL,
Abono        MONEY NULL,
Saldo        MONEY NULL,
Vencimiento  DATETIME NULL,
Modulo       varchar(5) null,
CUENTA       VARCHAR(100) NULL,
APLICA       VARCHAR(20) NULL,
APLICAID     VARCHAR(20)NULL
)
DECLARE @EstadoCuentaCtes1 TABLE
(
MOV        VARCHAR(20) NULL,
MOVID      VARCHAR(20) NULL,
Cargo      MONEY NULL,
Abono      MONEY NULL,
Saldo      MONEY NULL,
APLICA       VARCHAR(20) NULL,
APLICAID     VARCHAR(20)NULL
)
INSERT @EstadoCuentaCtes (MODULOID, MOV, MOVID, Fecha, MONEDA, TipoCambio, Cargo, Abono, Modulo, CUENTA, APLICA, APLICAID)
SELECT DISTINCT MODULOID, MOV, MOVID, Fecha, MONEDA, TipoCambio, SUM(Cargo), SUM(Abono), Modulo, CUENTA, APLICA, APLICAID
FROM AUXILIAR
WHERE RAMA = 'CXC'
GROUP BY MODULOID, MOV, MOVID, Fecha, MONEDA, TipoCambio, Modulo, ModuloId, CUENTA, APLICA, APLICAID
INSERT @EstadoCuentaCtes1(MOV, MOVID, Cargo, Abono, Saldo, Aplica, AplicaID)
SELECT DISTINCT Aplica, AplicaID, SUM(Cargo) ,SUM(Abono),0, A.Aplica, A.AplicaID
FROM AUXILIAR A
WHERE A.RAMA = 'CXC'
AND ((MOV + MOVID) <> APLICA + APLICAID)
GROUP BY Aplica, AplicaID
SELECT CONVERT(VARCHAR(10),A.Fecha,105) [Fecha],
RTRIM(A.MOV) + ' ' + RTRIM(ISNULL(A.MOVID,'')) [Movimiento],
ISNULL(C.concepto,'') [Concepto],
ISNULL(C.Estatus,'') [Estatus],
ISNULL(A.Moneda,'') [Moneda],
dbo.fnFormatoMonedaDec(CONVERT(DECIMAL(30,10),A.tipocambio),2) [Tipocambio],
dbo.fnFormatoMonedaDec(CONVERT(DECIMAL(30,10),ISNULL(A.Cargo,0.00) + ISNULL(B.Cargo,0.00)),2) [Cargo],
dbo.fnFormatoMonedaDec(CONVERT(DECIMAL(30,10),ISNULL(B.Abono,0.00) + ISNULL(A.Abono,0.00)),2) [Abono],
dbo.fnFormatoMonedaDec(CONVERT(DECIMAL(30,10),((ISNULL(A.Cargo,0.00) + ISNULL(B.Cargo,0.00)) - (ISNULL(B.Abono,0.00) + ISNULL(A.Abono,0.00)))),2) [Saldo],
CONVERT(VARCHAR(10),C.Vencimiento,105) [Vencimiento],
RTRIM(ISNULL(A.MOVID,'')) [MovID]
FROM @EstadoCuentaCtes A
LEFT JOIN @EstadoCuentaCtes1 B ON A.MOV = B.MOV AND A.MOVID = B.MOVID
JOIN CXC C ON C.ID = A.MODULOID
JOIN Cte ON A.Cuenta = Cte.Cliente
LEFT JOIN MovTipo MT ON MT.Modulo = A.Modulo AND C.Mov = MT.Mov
WHERE Cte.Cliente = @Cliente
AND MT.Clave NOT IN ('CXC.EST','CXC.SD','CXC.SCH')
AND C.Estatus NOT IN ('CANCELADO')
AND C.Vencimiento BETWEEN @DesdeD AND @HastaD
AND A.AplicaID  = CASE WHEN A.AplicaID = A.MovID AND A.Aplica = A.Mov THEN A.AplicaID END
ORDER BY CONVERT(DATETIME,C.Vencimiento) DESC
RETURN
END

