SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER VIEW POSCFDFlexPendiente

AS
SELECT c.Modulo, c.ID, p.Mov, p.MovID, c.FechaEmision, c.Estatus, c.CFDFlexEstatus, c.Importe, c.Impuestos, c.Cliente_Proveedor, c.Empresa, c.Sucursal, p.ID IDPOS, c.Mov MovVenta, c.MovID MovIDVenta
FROM CFDFlexPendiente c WITH(NOLOCK)
JOIN POSL p WITH(NOLOCK) ON p.Empresa = c.Empresa AND p.Origen = c.Mov AND p.OrigenID = c.MovID AND c.Modulo = 'VTAS'
WHERE p.Estatus = 'FACTURADO'

