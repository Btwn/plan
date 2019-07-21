SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER VIEW VentaPendienteAsignada

AS
SELECT v.Empresa, v.Cliente, vd.Articulo,
"CantidadPendiente" = sum(vd.cantidadPendiente),
"CantidadAsignada" = (SELECT SUM(od.CantidadPendiente) FROM Compra o JOIN CompraD od ON o.ID = od.ID JOIN MovTipo omt ON o.Mov = omt.Mov AND OMT.Modulo = 'COMS' WHERE omt.Clave IN ('COMS.O', 'COMS.OG', 'COMS.OI') AND o.Estatus = 'PENDIENTE' AND od.Articulo = vd.Articulo AND od.Cliente = v.Cliente)
FROM Venta v
JOIN VentaD vd ON v.ID = vd.ID
JOIN MovTipo mt ON v.Mov = mt.Mov AND MT.Modulo = 'VTAS'
WHERE mt.Clave IN ('VTAS.P', 'VTAS.S', 'VTAS.F', 'VTAS.FC', 'VTAS.FG', 'VTAS.FX') AND v.Estatus = 'PENDIENTE'
GROUP BY v.Empresa, v.Cliente, vd.Articulo

