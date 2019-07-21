SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER VIEW VentaSurtirColor

AS
SELECT DISTINCT
v.Empresa,
v.ID,
v.Mov,
v.MovID,
d.Almacen,
d.Articulo,
"Color" = SUBSTRING(d.SubCuenta, 1, CHARINDEX('/', d.SubCuenta)-1),
"Talla" = SUBSTRING(d.SubCuenta, CHARINDEX('/', d.SubCuenta)+1, 20),
d.FechaRequerida,
d.Renglon,
d.RenglonSub,
v.Cliente,
d.EnviarA,
"Cantidad" = SUM(Cantidad)-ISNULL(SUM(CantidadCancelada), 0.0),
"CantidadOrdenada"  = SUM(CantidadOrdenada),
"CantidadReservada" = SUM(CantidadReservada),
"CantidadPendiente" = SUM(CantidadPendiente)
FROM VentaD d
JOIN Venta v ON v.ID = d.ID
JOIN MovTipo mt ON v.Mov = mt.Mov AND mt.Modulo = 'VTAS'
WHERE
v.Estatus = 'PENDIENTE' AND mt.Clave IN ('VTAS.P', 'VTAS.S', 'VTAS.F', 'VTAS.FC', 'VTAS.FG', 'VTAS.FX')
GROUP BY
v.Empresa, v.ID, v.Mov, v.MovID, d.Almacen, d.Articulo, SUBSTRING(d.SubCuenta, 1, CHARINDEX('/', d.SubCuenta)-1), SUBSTRING(d.SubCuenta, CHARINDEX('/', d.SubCuenta)+1, 20), d.FechaRequerida, d.Renglon, d.RenglonSub, v.Cliente, d.EnviarA

