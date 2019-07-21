SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER VIEW CFDFlexPendiente

AS
SELECT 'VTAS' As Modulo, v.ID , v.Mov, v.MovID, v.FechaEmision, v.Estatus, v.CFDFlexEstatus, v.Importe, v.Impuestos, v.Cliente as Cliente_Proveedor, v.Empresa, v.Sucursal
FROM Venta v JOIN MovTipo mt ON v.Mov = mt.Mov
WHERE mt.CFDFlex = 1
AND v.Estatus NOT IN ('SINAFECTAR','CANCELADO')
AND v.CFDFlexEstatus IN('ERROR','PROCESANDO')
UNION ALL
SELECT 'CXC' As Modulo, c.ID, c.Mov, c.MovID, c.FechaEmision, c.Estatus, c.CFDFlexEstatus, c.Importe, c.Impuestos, c.Cliente, c.Empresa, c.Sucursal
FROM Cxc c JOIN MovTipo mt ON c.Mov = mt.Mov
WHERE mt.CFDFlex = 1
AND c.Estatus NOT IN ('SINAFECTAR','CANCELADO')
AND c.CFDFlexEstatus IN('ERROR','PROCESANDO')
UNION ALL
SELECT 'CXP' As Modulo, c.ID, c.Mov, c.MovID, c.FechaEmision, c.Estatus, c.CFDFlexEstatus, c.Importe, c.Impuestos, c.Proveedor, c.Empresa, c.Sucursal
FROM Cxp c JOIN MovTipo mt ON c.Mov = mt.Mov
WHERE mt.CFDFlex = 1
AND c.Estatus NOT IN ('SINAFECTAR','CANCELADO')
AND c.CFDFlexEstatus IN('ERROR','PROCESANDO')
UNION ALL
SELECT 'COMS' As Modulo, c.ID, c.Mov, c.MovID, c.FechaEmision, c.Estatus, c.CFDFlexEstatus, c.Importe, c.Impuestos, c.Proveedor, c.Empresa, c.Sucursal
FROM Compra c JOIN MovTipo mt ON c.Mov = mt.Mov
WHERE mt.CFDFlex = 1
AND c.Estatus NOT IN ('SINAFECTAR','CANCELADO')
AND c.CFDFlexEstatus IN('ERROR','PROCESANDO')
UNION ALL
SELECT 'CORTE' As Modulo, c.ID, c.Mov, c.MovID, c.FechaEmision, c.Estatus, c.CFDFlexEstatus, c.Importe, 0.0, NULL, c.Empresa, c.Sucursal
FROM Corte c JOIN MovTipo mt ON c.Mov = mt.Mov
WHERE mt.CFDFlex = 1
AND c.Estatus NOT IN ('SINAFECTAR','CANCELADO')
AND c.CFDFlexEstatus IN('ERROR','PROCESANDO')

