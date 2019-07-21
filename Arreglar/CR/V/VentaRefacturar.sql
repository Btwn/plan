SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER VIEW VentaRefacturar

AS
SELECT v.ID, v.Empresa, v.Mov, v.MovID, v.Cliente, v.Importe, v.Impuestos, c.Nombre, v.Sucursal, v.Almacen, v.FechaEmision, v.Estatus, v.Moneda, v.Usuario
FROM Venta v JOIN MovTipo m ON v.Mov = m.Mov AND m.Modulo = 'VTAS'
JOIN Cte c ON v.Cliente = c.Cliente
WHERE v.Estatus NOT IN ('SINAFECTAR','CANCELADO')
AND m.Clave IN ('VTAS.N')
AND v.Refacturado = 0
AND v.Importe > 0.0

