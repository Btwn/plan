SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER VIEW VerVenta

AS
SELECT
v.ID,
v.Empresa,
v.Mov,
v.MovID,
v.Moneda,
v.FechaEmision,
v.FechaRequerida,
v.Proyecto,
v.UEN,
v.Concepto,
v.Estatus,
v.Cliente,
v.EnviarA,
v.Agente,
v.Importe,
v.DescuentoGlobal,
v.SobrePrecio,
v.Referencia,
"SubTotal"= CONVERT(money, dbo.fnSubTotal(v.Importe, v.DescuentoGlobal, v.SobrePrecio)),
v.Impuestos,
"Total"= CONVERT(money, dbo.fnSubTotal(v.Importe, v.DescuentoGlobal, v.SobrePrecio)) + v.Impuestos,
v.Saldo,
"SaldoImpuestos" = CONVERT(money, dbo.fnR3(dbo.fnSubTotal(v.Importe, v.DescuentoGlobal, v.SobrePrecio)+ v.Impuestos, v.Impuestos, v.Saldo)),
"MovTipo" = mt.Clave,
v.Sucursal,
v.SucursalOrigen,
v.Espacio,
v.Almacen,
v.AlmacenDestino,
v.ServicioSerie,
v.ServicioPlacas,
v.ServicioFecha,
v.ServicioArticulo,
v.ServicioNumeroEconomico
FROM Venta v
JOIN MovTipo mt ON v.Mov = mt.Mov AND mt.Modulo = 'VTAS'

