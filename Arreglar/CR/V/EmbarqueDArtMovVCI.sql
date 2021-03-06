SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER VIEW EmbarqueDArtMovVCI
AS
SELECT
eda.ID,
eda.Modulo,
eda.ModuloID,
m.Nombre ModuloNombre,
ISNULL(v.Mov,c.Mov) + ' ' + CASE WHEN v.Mov IS NOT NULL THEN ISNULL(v.MovID,'') ELSE ISNULL(c.MovID,'') END Mov,
ISNULL(v.Estatus,c.Estatus) Estatus,
ISNULL(vd.Articulo,cd.Articulo) Articulo,
ISNULL(vd.SubCuenta,cd.SubCuenta) SubCuenta,
a.Descripcion1 Descripcion,
eda.Cantidad,
eda.CantidadTotal,
eda.ImporteTotal,
(ISNULL(eda.Cantidad,0.0)*ISNULL(eda.ImporteTotal,0.0))/ISNULL(eda.CantidadTotal,0.0) Importe
FROM EmbarqueDArt eda JOIN Modulo m
ON m.Modulo = eda.Modulo LEFT OUTER JOIN Venta v
ON v.ID = eda.ModuloID AND eda.Modulo = 'VTAS' LEFT OUTER JOIN Compra c
ON c.ID = eda.ModuloID AND eda.Modulo = 'COMS' LEFT OUTER JOIN VentaD vd
ON vd.ID = v.ID AND vd.Renglon = eda.Renglon AND vd.RenglonSub = eda.RenglonSub LEFT OUTER JOIN CompraD cd
ON cd.ID = c.ID AND cd.Renglon = eda.Renglon AND cd.RenglonSub = eda.RenglonSub LEFT OUTER JOIN Art a
ON a.Articulo = ISNULL(vd.Articulo,cd.Articulo) JOIN EmbarqueD ed
ON ed.ID = eda.ID AND ed.EmbarqueMov = eda.EmbarqueMov
WHERE ed.DesembarqueParcial = 0
UNION ALL
SELECT
ed.ID,
em.Modulo,
em.ModuloID,
m.Nombre ModuloNombre,
i.Mov + ' ' + ISNULL(i.MovID,'') Mov,
i.Estatus Estatus,
id.Articulo,
id.SubCuenta,
a.Descripcion1 Descripcion,
id.Cantidad Cantidad,
id.Cantidad CantidadTotal,
ISNULL(id.Cantidad,0.0)*ISNULL(id.Costo,0.0) ImporteTotal,
ISNULL(id.Cantidad,0.0)*ISNULL(id.Costo,0.0) Importe
FROM EmbarqueD ed JOIN EmbarqueMov em
ON em.ID = ed.EmbarqueMov LEFT OUTER JOIN Modulo m
ON m.Modulo = em.Modulo LEFT OUTER JOIN Inv i
ON i.ID = em.ModuloID LEFT OUTER JOIN InvD id
ON id.ID = i.ID LEFT OUTER JOIN Art a
ON a.Articulo = id.Articulo
WHERE em.Modulo = 'INV'
AND ed.DesembarqueParcial = 0

