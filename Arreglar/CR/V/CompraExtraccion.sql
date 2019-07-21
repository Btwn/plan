SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER VIEW CompraExtraccion
AS
SELECT cel.Estacion,
cel.ID,
cel.Renglon,
cel.RenglonSub,
cel.RenglonID,
cel.SerieLote,
cel.CantidadA,
cel.Observaciones,
cd.RenglonTipo,
cd.Articulo,
cd.SubCuenta,
cd.Unidad,
cd.Factor,
cd.CantidadInventario,
cd.Paquete,
cd.PaqueteCantidad,
cd.ReferenciaExtra,
cd.DescripcionExtra,
cd.ImportacionReferencia,
slm.Cantidad,
sl.Existencia,
'Saldo' = sl.Existencia/NULLIF(ISNULL(cd.PaqueteCantidad, 1),0),
sl.Propiedades
FROM CompraExtraccionLista cel
JOIN Compra c ON cel.ID = c.ID
JOIN CompraD cd ON cel.ID = cd.ID AND cel.Renglon = cd.Renglon AND cel.RenglonSub = cd.RenglonSub
JOIN SerieLoteMov slm ON c.Empresa = slm.Empresa AND slm.Modulo = 'COMS' AND cd.ID = slm.ID AND cd.RenglonID = slm.RenglonID AND cd.Articulo = slm.Articulo AND ISNULL(cd.SubCuenta, '') = ISNULL(slm.SubCuenta, '') AND cel.SerieLote = slm.SerieLote
JOIN SerieLote sl ON c.Empresa = sl.Empresa AND cd.Articulo = sl.Articulo AND ISNULL(cd.SubCuenta, '') = ISNULL(sl.SubCuenta, '') AND cel.SerieLote = sl.SerieLote AND cd.Almacen = sl.Almacen
WHERE ISNULL(sl.Existencia, 0) > 0

