SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER VIEW VentaPedidoAnticipoPendiente

AS
SELECT v.ID, v.Empresa, v.Mov, v.MovID, v.FechaEmision, v.Concepto, v.Proyecto, v.UEN, v.Moneda, v.TipoCambio, v.Usuario, v.Referencia, v.Observaciones, v.Estatus, v.Cliente, v.EnviarA, v.Almacen, v.Agente, v.AgenteServicio, v.AgenteComision, v.FormaEnvio, v.Condicion, v.Vencimiento, v.CtaDinero, v.Descuento, v.DescuentoGlobal, v.Importe, v.Impuestos, v.Saldo, v.DescuentoLineal, v.OrigenTipo, v.Origen, v.OrigenID, v.FechaRegistro, v.Causa, v.Atencion, v.AtencionTelefono, v.ListaPreciosEsp, v.ZonaImpuesto, v.Sucursal, v.SucursalOrigen, v.FechaRequerida, RTRIM(LTRIM(v.Mov))+' '+RTRIM(LTRIM(v.MovID)) MovConsecutivo
FROM Venta v JOIN MovTipo m ON v.Mov = m.Mov  AND m.Modulo = 'VTAS'
WHERE m.Clave = 'VTAS.P'
AND v.Estatus = 'PENDIENTE'

