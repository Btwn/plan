SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spVerAuxCorte
@Estacion	int,
@Empresa	char(5),
@Modulo		char(5),
@FechaD		datetime,
@FechaA		datetime,
@CuentaD	char(10),
@CuentaA	char(10)

AS BEGIN
DECLARE @RedondeoMonetarios int 
SELECT @RedondeoMonetarios = ISNULL(RedondeoMonetarios,0) 
FROM Version
DELETE VerAuxCorte WHERE Estacion = @Estacion
INSERT VerAuxCorte (Estacion, Empresa, Modulo, Moneda, Cuenta, Mov, MovID, Saldo)
SELECT @Estacion, a.Empresa, @Modulo, a.Moneda, a.Cuenta, a.Aplica, a.AplicaID, "Saldo" = (ISNULL(SUM(a.Cargo), 0)-ISNULL(SUM(a.Abono), 0))
FROM Auxiliar a, Rama r
WHERE a.Rama = r.Rama
AND r.Mayor = @Modulo
AND a.Empresa = @Empresa
AND a.Fecha BETWEEN @FechaD AND @FechaA
AND a.Cuenta BETWEEN @CuentaD AND @CuentaA
GROUP BY a.Empresa, a.Moneda, a.Cuenta, a.Aplica, a.AplicaID
HAVING ROUND(ISNULL(SUM(Cargo), 0)-ISNULL(SUM(Abono), 0), @RedondeoMonetarios) <> 0 
ORDER BY a.Empresa, a.Moneda, a.Cuenta, a.Aplica, a.AplicaID
IF @Modulo = 'CXC'
UPDATE VerAuxCorte
SET ModuloID    = e.ID
FROM VerAuxCorte ac, Cxc e
WHERE ac.Estacion = @Estacion AND ac.MovID IS NOT NULL
AND e.Empresa = ac.Empresa AND e.Mov = ac.Mov AND e.MovID = ac.MovID AND e.Estatus IN ('PENDIENTE', 'CONCLUIDO')
ELSE
IF @Modulo = 'CXP'
UPDATE VerAuxCorte
SET ModuloID    = e.ID
FROM VerAuxCorte ac, Cxp e
WHERE ac.Estacion = @Estacion AND ac.MovID IS NOT NULL
AND e.Empresa = ac.Empresa AND e.Mov = ac.Mov AND e.MovID = ac.MovID AND e.Estatus IN ('PENDIENTE', 'CONCLUIDO')
END

