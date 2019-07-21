SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER VIEW ArtSubRemisionado

AS
SELECT
v.Empresa,
d.Articulo,
d.SubCuenta,
d.Almacen,
"Remisionado"=Sum(d.CantidadPendiente)
FROM Venta v
JOIN VentaD d ON v.ID = d.ID
JOIN MovTipo mt ON v.Mov = mt.Mov AND mt.Modulo = 'VTAS'
WHERE
v.Estatus = 'PENDIENTE'
AND mt.Clave = 'VTAS.R'
GROUP BY
v.Empresa, d.Articulo, d.SubCuenta, d.Almacen

