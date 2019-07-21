SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER VIEW VerCompraImportacionSerieLote
AS
SELECT c.ID,
c.Empresa,
c.Mov,
c.MovID,
c.FechaEmision,
c.Concepto,
c.Proyecto,
c.Actividad,
c.UEN,
c.Moneda,
c.TipoCambio,
c.Usuario,
c.Referencia,
c.Observaciones,
c.Proveedor,
c.Origen,
c.OrigenID,
c.DescuentosTotales,
c.SubTotal,
c.ImporteTotal,
cd.Renglon,
cd.RenglonSub,
cd.RenglonID,
cd.RenglonTipo,
cd.Articulo,
cd.SubCuenta,
cd.Unidad,
cd.Factor,
cd.CantidadInventario,
cd.Paquete,
cd.PaqueteCantidad,
cd.ImportacionProveedor,
cd.ImportacionReferencia,
sl.SerieLote,
slm.Cantidad,
sl.Almacen,
sl.Existencia,
'Saldo' = sl.Existencia/NULLIF(ISNULL(cd.PaqueteCantidad, 1),0),
sl.Propiedades
FROM CompraCalc c
JOIN MovTipo mt ON c.Mov = mt.Mov AND mt.Modulo = 'COMS' AND mt.Clave IN ('COMS.CC', 'COMS.FL', 'COMS.F', 'COMS.EG', 'COMS.EI')
JOIN CompraD cd ON c.ID = cd.ID
JOIN SerieLoteMov slm ON c.Empresa = slm.Empresa AND slm.Modulo = 'COMS' AND cd.ID = slm.ID AND cd.RenglonID = slm.RenglonID AND cd.Articulo = slm.Articulo AND ISNULL(cd.SubCuenta, '') = ISNULL(slm.SubCuenta, '')
JOIN SerieLote sl ON c.Empresa = sl.Empresa AND cd.Articulo = sl.Articulo AND ISNULL(cd.SubCuenta, '') = ISNULL(sl.SubCuenta, '') AND cd.Almacen = sl.Almacen AND slm.SerieLote = sl.SerieLote
WHERE ISNULL(sl.Existencia, 0) > 0
AND c.Estatus = 'CONCLUIDO'

