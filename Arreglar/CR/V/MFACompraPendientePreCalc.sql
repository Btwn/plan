SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER VIEW MFACompraPendientePreCalc AS
SELECT DISTINCT
c.ID,
p.Empresa,
p.Origen,
p.OrigenID,
YEAR(c.FechaEmision) Ejercicio,
MONTH(c.FechaEmision) Periodo
FROM Cxp p
JOIN Compra c ON c.MovID = p.OrigenID AND c.Mov = p.Origen
WHERE p.OrigenTipo = 'COMS'
AND c.Estatus IN ('PENDIENTE','CONCLUIDO')

