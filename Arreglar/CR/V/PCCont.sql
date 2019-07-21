SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER VIEW PCCont

AS
SELECT
ID,
Empresa,
FechaEmision,
Mov,
MovID,
Poliza,
PolizaID,
ContID,
Sucursal,
"Estatus" = CASE WHEN Estatus = 'CANCELADO' THEN 'CANCELADO' WHEN GenerarPoliza = 1 THEN 'PENDIENTE' WHEN GenerarPoliza = 0 AND Poliza IS NOT NULL AND PolizaID IS NOT NULL THEN 'CONTABILIZADO' WHEN GenerarPoliza = 0 AND ContID IS NOT NULL THEN 'PROCESAR' ELSE 'N/A' END
FROM
PC
WHERE
Estatus NOT IN ('SINAFECTAR', 'BORRADOR', 'CONFIRMAR')

