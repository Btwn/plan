SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spPreparaDatosSurtir
@Modulo       varchar(5),
@Id           int,
@Articulo     varchar(20),
@Renglon      float,
@RenglonID    int,
@Empresa      varchar(5),
@Tarima		  varchar(20),
@SerieLote	  varchar(50)

AS
BEGIN
IF @Modulo = 'VTAS'
BEGIN
SELECT Modulo,
Mov,
ID,
SUM(Cantidad),
Posicion,
Articulo,
SubCuenta,
Almacen,
Unidad,
CantidadUnidad,
Factor,
RenglonID,
SerieLote,
Tarima
FROM
(
SELECT  'VTAS' Modulo,
v.Mov,
v.ID,
SUM(ISNULL(slm.Cantidad, ISNULL(vd.CantidadInventario,vd.Cantidad))) AS Cantidad,
CASE ISNULL(e.WMSAndenSurtidoContacto,0) WHEN 1 THEN ISNULL(NULLIF(c.DefPosicionSurtido,''), ISNULL(v.PosicionWMS, a.DefPosicionSurtido)) ELSE ISNULL(v.PosicionWMS, a.DefPosicionSurtido) END as Posicion,
vd.Articulo,
vd.SubCuenta,
vd.Almacen,
vd.Unidad,
vd.Cantidad CantidadUnidad,
CASE g.NivelFactorMultiUnidad WHEN 'Unidad' THEN ISNULL( u.Factor, 1) ELSE ISNULL( au.Factor, 1) END Factor,
vd.RenglonID,
slm.SerieLote,
ISNULL(slm.Tarima,@Tarima) Tarima
FROM Venta v WITH (NOLOCK)
JOIN VentaD vd WITH (NOLOCK) ON v.ID = vd.ID
LEFT JOIN SerieLoteMov slm WITH (NOLOCK) ON vd.ID = slm.ID AND vd.RenglonID = slm.RenglonID AND vd.Articulo = slm.Articulo AND ISNULL(vd.SubCuenta,'') = ISNULL(slm.SubCuenta,ISNULL(vd.SubCuenta,'')) AND slm.Modulo = @Modulo AND v.Empresa = slm.Empresa
JOIN Cte c WITH (NOLOCK) ON v.Cliente = c.Cliente
LEFT JOIN CteEnviarA ca WITH (NOLOCK) ON c.Cliente = ca.Cliente AND vd.EnviarA = ca.ID
JOIN Alm a WITH (NOLOCK) ON vd.Almacen = a.Almacen
JOIN EmpresaCfg e WITH (NOLOCK) ON e.Empresa = @Empresa
LEFT JOIN WMSModuloTarima w WITH (NOLOCK) ON w.IDModulo = v.ID AND w.Modulo = 'VTAS' AND w.IDTMA IS NOT NULL AND Utilizar = 1
LEFT JOIN TMA t WITH (NOLOCK) ON t.ID = w.IDTMA AND t.Estatus <> 'CANCELADO'
LEFT JOIN EmpresaCfg2 g WITH (NOLOCK) ON v.Empresa = g.Empresa
LEFT JOIN Unidad u WITH (NOLOCK) ON vd.Unidad = u.Unidad
LEFT JOIN ArtUnidad au WITH (NOLOCK) ON vd.Articulo = au.Articulo AND vd.Unidad = au.Unidad
WHERE v.ID = @Id
AND vd.Articulo = @Articulo
AND vd.Renglon  = @Renglon
AND vd.RenglonID = @RenglonID
AND ISNULL(slm.Tarima,@Tarima) = ISNULL(@Tarima,'')
AND ISNULL(slm.SerieLote,'') = ISNULL(@SerieLote,'')
AND v.Estatus = (SELECT Estatus FROM WMSModuloMovimiento WITH (NOLOCK) WHERE Modulo = 'VTAS' AND Movimiento = v.Mov)
AND NULLIF(vd.Tarima,'') IS NULL
AND Isnull(vd.CantidadPendiente, '') > 0
GROUP BY v.Mov, v.ID, CASE ISNULL(e.WMSAndenSurtidoContacto,0) WHEN 1 THEN ISNULL(NULLIF(c.DefPosicionSurtido,''),ISNULL(v.PosicionWMS, a.DefPosicionSurtido)) ELSE ISNULL(v.PosicionWMS, a.DefPosicionSurtido) END, vd.Articulo, vd.SubCuenta, vd.Almacen, g.NivelFactorMultiUnidad, ISNULL( u.Factor, 1), ISNULL( au.Factor, 1), vd.Unidad, vd.Cantidad, ISNULL( u.Factor, 1),vd.RenglonID, slm.SerieLote, slm.Tarima
) AS x
GROUP BY Modulo, Mov, ID, Posicion, Articulo, SubCuenta, Almacen, Unidad, CantidadUnidad, Factor, RenglonID, SerieLote, Tarima
ORDER BY Posicion, Tarima, Articulo, SubCuenta, Almacen, Unidad, CantidadUnidad, Factor
END
ELSE
IF @Modulo = 'COMS'
BEGIN
SELECT Modulo,
Mov,
ID,
SUM(Cantidad),
Posicion,
Articulo,
SubCuenta,
Almacen,
Unidad,
CantidadUnidad,
Factor,
RenglonID,
SerieLote,
Tarima
FROM
(
SELECT 'COMS' Modulo,
v.Mov,
v.ID,
SUM(ISNULL(slm.Cantidad, ISNULL(vd.CantidadInventario,vd.Cantidad))) AS Cantidad,
CASE ISNULL(e.WMSAndenSurtidoContacto,0) WHEN 1 THEN ISNULL(NULLIF(c.DefPosicionSurtido,''),ISNULL(v.PosicionWMS, a.DefPosicionSurtido)) ELSE ISNULL(v.PosicionWMS, a.DefPosicionSurtido) END as Posicion,
vd.Articulo,
vd.SubCuenta,
vd.Almacen,
vd.Unidad,
vd.Cantidad CantidadUnidad,
CASE g.NivelFactorMultiUnidad WHEN 'Unidad' THEN ISNULL( u.Factor, 1) ELSE ISNULL( au.Factor, 1) END Factor,
vd.RenglonID,
slm.SerieLote,
ISNULL(slm.Tarima,@Tarima) Tarima
FROM Compra v WITH (NOLOCK)
JOIN CompraD vd WITH (NOLOCK) ON v.ID = vd.ID
LEFT JOIN SerieLoteMov slm WITH (NOLOCK) ON vd.ID = slm.ID AND vd.RenglonID = slm.RenglonID AND vd.Articulo = slm.Articulo AND ISNULL(vd.SubCuenta,'') = ISNULL(slm.SubCuenta,ISNULL(vd.SubCuenta,'')) AND slm.Modulo = @Modulo AND v.Empresa = slm.Empresa
JOIN Prov c WITH (NOLOCK) ON v.Proveedor = c.Proveedor
JOIN Alm a WITH (NOLOCK) ON vd.Almacen = a.Almacen
JOIN EmpresaCfg e WITH (NOLOCK) ON e.Empresa = @Empresa
LEFT JOIN WMSModuloTarima w WITH (NOLOCK) ON w.IDModulo = v.ID AND w.Modulo = 'COMS' AND w.IDTMA IS NOT NULL AND Utilizar = 1
LEFT JOIN TMA t WITH (NOLOCK) ON t.ID = w.IDTMA AND t.Estatus <> 'CANCELADO'
LEFT JOIN EmpresaCfg2 g WITH (NOLOCK) ON v.Empresa = g.Empresa
LEFT JOIN Unidad u WITH (NOLOCK) ON vd.Unidad = u.Unidad
LEFT JOIN ArtUnidad au WITH (NOLOCK) ON vd.Articulo = au.Articulo AND vd.Unidad = au.Unidad
WHERE v.ID = @Id
AND vd.Articulo = @Articulo
AND vd.Renglon  = @Renglon
AND vd.RenglonID = @RenglonID
AND ISNULL(slm.Tarima,@Tarima) = ISNULL(@Tarima,'')
AND ISNULL(slm.SerieLote,'') = ISNULL(@SerieLote,'')
AND v.Estatus = (SELECT Estatus FROM WMSModuloMovimiento WITH (NOLOCK) WHERE Modulo = 'COMS' AND Movimiento = v.Mov)
AND NULLIF(vd.Tarima,'') IS NULL
GROUP BY v.Mov, v.ID, CASE ISNULL(e.WMSAndenSurtidoContacto,0) WHEN 1 THEN ISNULL(NULLIF(c.DefPosicionSurtido,''),ISNULL(v.PosicionWMS, a.DefPosicionSurtido)) ELSE ISNULL(v.PosicionWMS, a.DefPosicionSurtido) END, vd.Articulo, vd.Almacen, e.WMSAndenSurtidoContacto, c.DefPosicionSurtido, g.NivelFactorMultiUnidad, ISNULL( u.Factor, 1), ISNULL( au.Factor, 1), vd.Unidad, vd.Cantidad, ISNULL( u.Factor, 1), vd.SubCuenta, vd.RenglonID, slm.SerieLote, slm.Tarima
) AS x
GROUP BY Modulo, Mov, ID, Posicion, Articulo, Almacen, Unidad, CantidadUnidad, Factor, SubCuenta, RenglonID, SerieLote, Tarima
ORDER BY Posicion, Tarima, Articulo, Almacen, Unidad, CantidadUnidad, Factor, SubCuenta
END
ELSE
IF @Modulo = 'INV'
BEGIN
SELECT Modulo,
Mov,
ID,
SUM(Cantidad),
Posicion,
Articulo,
SubCuenta,
Almacen,
Unidad,
CantidadUnidad,
Factor,
RenglonID,
SerieLote,
Tarima
FROM
(
SELECT 'INV' Modulo,
v.Mov,
v.ID,
SUM(ISNULL(slm.Cantidad, ISNULL(vd.CantidadInventario,vd.Cantidad))) AS Cantidad,
ISNULL(v.PosicionWMS, a.DefPosicionSurtido) as Posicion,
vd.Articulo,
vd.SubCuenta,
vd.Almacen,
vd.Unidad,
vd.Cantidad CantidadUnidad,
CASE g.NivelFactorMultiUnidad WHEN 'Unidad' THEN ISNULL( u.Factor, 1) ELSE ISNULL( au.Factor, 1) END Factor,
vd.RenglonID, slm.SerieLote, ISNULL(slm.Tarima,@Tarima) Tarima
FROM Inv v WITH (NOLOCK)
JOIN InvD vd WITH (NOLOCK) ON v.ID = vd.ID
LEFT JOIN SerieLoteMov slm WITH (NOLOCK) ON vd.ID = slm.ID
AND vd.RenglonID = slm.RenglonID
AND vd.Articulo = slm.Articulo
AND ISNULL(vd.SubCuenta,'') = ISNULL(slm.SubCuenta,ISNULL(vd.SubCuenta,''))
AND slm.Modulo = @Modulo
AND v.Empresa = slm.Empresa
JOIN Alm a WITH (NOLOCK) ON vd.Almacen = a.Almacen
JOIN EmpresaCfg e WITH (NOLOCK) ON e.Empresa = @Empresa
LEFT JOIN WMSModuloTarima w WITH (NOLOCK) ON w.IDModulo = v.ID AND w.Modulo = @Modulo AND w.IDTMA IS NOT NULL AND Utilizar = 1
LEFT JOIN TMA t WITH (NOLOCK) ON t.ID = w.IDTMA AND t.Estatus <> 'CANCELADO'
LEFT JOIN EmpresaCfg2 g WITH (NOLOCK) ON v.Empresa = g.Empresa
LEFT JOIN Unidad u WITH (NOLOCK) ON vd.Unidad = u.Unidad
LEFT JOIN ArtUnidad au WITH (NOLOCK) ON vd.Articulo = au.Articulo AND vd.Unidad = au.Unidad
WHERE v.ID = @Id
AND vd.Articulo = @Articulo
AND vd.Renglon  = @Renglon
AND vd.RenglonID = @RenglonID
AND ISNULL(slm.Tarima,@Tarima) = ISNULL(@Tarima,'')
AND ISNULL(slm.SerieLote,'') = ISNULL(@SerieLote,'')
AND v.Estatus = (SELECT Estatus FROM WMSModuloMovimiento WITH (NOLOCK) WHERE Modulo = @Modulo AND Movimiento = v.Mov)
AND NULLIF(vd.Tarima,'') IS NULL
AND ISNULL(vd.CantidadPendiente,'') > 0
GROUP BY v.Mov, v.ID, ISNULL(v.PosicionWMS, a.DefPosicionSurtido), vd.Articulo, vd.Almacen, g.NivelFactorMultiUnidad, ISNULL( u.Factor, 1), ISNULL( au.Factor, 1), vd.Unidad, vd.Cantidad, ISNULL( u.Factor, 1), vd.SubCuenta, vd.RenglonID, slm.SerieLote, slm.Tarima
) AS x
GROUP BY Modulo, Mov, ID, Posicion, Articulo, SubCuenta, Almacen, Unidad, CantidadUnidad, Factor, RenglonID, SerieLote, Tarima
ORDER BY Posicion, Tarima, Articulo, SubCuenta, Almacen, Unidad, CantidadUnidad, Factor
END
END

