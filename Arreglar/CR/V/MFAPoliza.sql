SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER VIEW MFAPoliza AS
SELECT
empresa                    = cd.Empresa,
ejercicio                  = c.Ejercicio,
periodo                    = c.Periodo,
cuenta_contable            = cd.Cuenta,
cargos                     = ISNULL(SUM(ISNULL(cd.Debe,0.0)),0.0),
abonos                     = ISNULL(SUM(ISNULL(cd.Haber,0.0)),0.0)
FROM ContD cd
JOIN Cont c ON cd.ID = c.ID
JOIN MovTipo mt ON mt.Mov = c.Mov AND mt.Modulo = 'CONT'
WHERE c.Estatus = 'CONCLUIDO'
AND mt.Clave IN ('CONT.P','CONT.C')
AND ISNULL(cd.Presupuesto, 0) = 0
GROUP BY cd.Empresa, c.Ejercicio, c.Periodo, cd.Cuenta

