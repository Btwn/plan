SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER FUNCTION fnWMSTablaHerramienta (@Estacion int, @Empresa char(5), @Sucursal int) 
RETURNS TABLE
AS
RETURN (
SELECT v.ID,
v.Mov,
v.MovID,
v.FechaEmision,
v.FechaRequerida,
v.Cliente Contacto,
CASE WHEN ISNULL(ca.Direccion,'') = '' AND ISNULL(c.Direccion,'') = '' THEN ''
WHEN ISNULL(ca.Direccion,'') <> '' AND ISNULL(c.Direccion,'') = '' THEN ca.Direccion
WHEN ISNULL(ca.Direccion,'') = '' AND ISNULL(c.Direccion,'') <> '' THEN c.Direccion
ELSE c.Direccion END +
CASE WHEN ISNULL(ca.DireccionNumero,'') = '' AND ISNULL(c.DireccionNumero,'') = '' THEN ''
WHEN ISNULL(ca.DireccionNumero,'') <> '' AND ISNULL(c.DireccionNumero,'') = '' THEN ' - ' + ca.DireccionNumero
WHEN ISNULL(ca.DireccionNumero,'') = '' AND ISNULL(c.DireccionNumero,'') <> '' THEN ' - ' + c.DireccionNumero
ELSE c.DireccionNumero END +
CASE WHEN ISNULL(ca.DireccionNumeroInt,'') = '' AND ISNULL(c.DireccionNumeroInt,'') = '' THEN ''
WHEN ISNULL(ca.DireccionNumeroInt,'') <> '' AND ISNULL(c.DireccionNumeroInt,'') = '' THEN ' - ' + ca.DireccionNumeroInt
WHEN ISNULL(ca.DireccionNumeroInt,'') = '' AND ISNULL(c.DireccionNumeroInt,'') <> '' THEN ' - ' + c.DireccionNumeroInt
ELSE c.DireccionNumeroInt END +
CASE WHEN ISNULL(ca.Delegacion,'') = '' AND ISNULL(c.Delegacion,'') = '' THEN ''
WHEN ISNULL(ca.Delegacion,'') <> '' AND ISNULL(c.Delegacion,'') = '' THEN ' - ' + ca.Delegacion
WHEN ISNULL(ca.Delegacion,'') = '' AND ISNULL(c.Delegacion,'') <> '' THEN ' - ' + c.Delegacion
ELSE c.Delegacion END +
CASE WHEN ISNULL(ca.Estado,'') = '' AND ISNULL(c.Estado,'') = '' THEN ''
WHEN ISNULL(ca.Estado,'') <> '' AND ISNULL(c.Estado,'') = '' THEN ', ' + ca.Estado
WHEN ISNULL(ca.Estado,'') = '' AND ISNULL(c.Estado,'') <> '' THEN ', ' + c.Estado
ELSE c.Estado END Direccion, 
ISNULL(ISNULL(ca.CodigoPostal, c.CodigoPostal),'') CodigoPostal,
ISNULL(ISNULL(ca.Ruta , c.Ruta),'') Ruta,
CASE ISNULL(e.WMSAndenSurtidoContacto,0) WHEN 1 THEN c.DefPosicionSurtido ELSE ISNULL(v.PosicionWMS, a.DefPosicionSurtido) END AndenSurtido,
c.Nombre,
'VTAS' Modulo,
v.Sucursal,  
s.Sucursal AS SucursalDestino,
s.Nombre AS NomSucursalDestino,  
v.Almacen,
WMSSurtidoPosicionTrabajo.Posicion,
(SELECT Sucursal FROM Alm WHERE Almacen = v.Almacen) SucursalOrigen 
FROM WMSModuloMovimiento wm
JOIN Venta v ON wm.Modulo = 'VTAS' AND wm.Movimiento = v.Mov /*AND v.Sucursal=@Sucursal*/ 
JOIN Cte c ON v.Cliente = c.Cliente
JOIN VentaD vd ON v.ID = vd.ID AND NULLIF(vd.Tarima,'') IS NULL AND vd.CantidadPendiente > 0 /* vd.CantidadReservada > 0 */
JOIN Alm a ON vd.Almacen = a.Almacen
LEFT JOIN CteEnviarA ca ON c.Cliente = ca.Cliente AND v.EnviarA = ca.ID
LEFT JOIN WMSModuloTarima wmt ON 'VTAS' = wmt.Modulo AND vd.ID = wmt.IDModulo AND vd.Renglon = wmt.Renglon AND vd.RenglonSub = wmt.RenglonSub AND wmt.Tarima IS NOT NULL
JOIN Alm l ON l.Almacen = v.Almacen AND l.WMS = 1 AND l.Sucursal=v.Sucursal 
JOIN EmpresaCfg e ON e.Empresa = @Empresa
JOIN MovTipo m ON v.Mov = m.Mov AND m.Modulo = 'VTAS'
LEFT OUTER JOIN Alm al ON al.Almacen = v.AlmacenDestino
LEFT OUTER JOIN Sucursal s ON s.AlmacenPrincipal = al.Almacen
LEFT OUTER JOIN EmpresaCfg2 g ON v.Empresa = g.Empresa
LEFT OUTER JOIN Unidad u ON vd.Unidad = u.Unidad
LEFT OUTER JOIN ArtUnidad au ON vd.Articulo = au.Articulo AND vd.Unidad = au.Unidad
LEFT OUTER JOIN RepParam p ON p.Estacion = @Estacion
LEFT OUTER JOIN WMSSurtidoPosicionTrabajo ON v.ID = WMSSurtidoPosicionTrabajo.ModuloID AND WMSSurtidoPosicionTrabajo.Modulo = 'VTAS'
WHERE v.Cliente = CASE ISNULL(NULLIF(p.InfoContacto,''),'(Todos)')
WHEN '(Todos)' THEN v.Cliente
WHEN 'Cliente' THEN ISNULL(NULLIF(RTRIM(LTRIM(p.InfoContactoEspecifico)),''), v.Cliente)
ELSE ''
END
AND ISNULL(v.FechaRequerida,'') = CASE WHEN ISNULL(p.InfoFechaRequerida,'') = '' THEN ISNULL(v.FechaRequerida,'') ELSE ISNULL(p.InfoFechaRequerida,'') END
AND ISNULL(c.Categoria,'') = ISNULL(NULLIF(RTRIM(LTRIM(p.InfoContactoCat)),''), ISNULL(c.Categoria,''))
AND ISNULL(c.Grupo,'') = ISNULL(NULLIF(RTRIM(LTRIM(p.InfoContactoGrupo)),''), ISNULL(c.Grupo,''))
AND ISNULL(c.Familia,'') = ISNULL(NULLIF(RTRIM(LTRIM(p.InfoContactoFam)),''), ISNULL(c.Familia,''))
AND ISNULL(c.Ruta,'') = ISNULL(NULLIF(RTRIM(LTRIM(p.InfoContactoRuta)),''), ISNULL(c.Ruta,''))
AND ISNULL(c.Estado,'') = ISNULL(NULLIF(RTRIM(LTRIM(p.InfoContactoEstado)),''), ISNULL(c.Estado,''))
AND ISNULL(c.Zona,'') = ISNULL(NULLIF(RTRIM(LTRIM(p.InfoContactoZona)),''), ISNULL(c.Zona,''))
AND ISNULL(c.Pais,'') = ISNULL(NULLIF(RTRIM(LTRIM(p.InfoContactoPais)),''), ISNULL(c.Pais,''))
AND ISNULL(c.CodigoPostal,'') = ISNULL(NULLIF(RTRIM(LTRIM(p.InfoContactoCP)),''), ISNULL(c.CodigoPostal,''))
AND ISNULL(c.EnviarA,'') = ISNULL(NULLIF(RTRIM(LTRIM(p.InfoClienteEnviarA)),''),ISNULL(c.EnviarA,''))
AND v.Estatus = 'PENDIENTE'
GROUP BY v.ID, v.Mov, v.MovID, v.FechaEmision, v.FechaRequerida, v.Cliente,
ca.Direccion, c.Direccion, ca.DireccionNumero, c.DireccionNumero, ca.DireccionNumeroInt, c.DireccionNumeroInt, ca.Delegacion, c.Delegacion, ca.Estado, c.Estado, c.Nombre,
ISNULL(ISNULL(ca.CodigoPostal , c.CodigoPostal),''), ISNULL(ISNULL(ca.Ruta , c.Ruta),''),
ISNULL(v.PosicionWMS, a.DefPosicionSurtido), v.Sucursal, e.WMSAndenSurtidoContacto, c.DefPosicionSurtido,  
s.Sucursal, s.Nombre,
v.Almacen, WMSSurtidoPosicionTrabajo.Posicion
UNION ALL
SELECT v.ID,
v.Mov,
v.MovID,
v.FechaEmision,
v.FechaRequerida,
v.Proveedor,
ISNULL(c.Direccion,'') + CASE WHEN ISNULL(c.DireccionNumero,'') = '' THEN '' ELSE ' - ' + c.DireccionNumero END +
CASE WHEN ISNULL(c.DireccionNumeroInt,'') = '' THEN '' ELSE ' ' + c.DireccionNumeroInt END +
CASE WHEN ISNULL(c.Delegacion,'') = '' THEN '' ELSE ' ' + c.Delegacion END +
CASE WHEN ISNULL(c.Estado,'') = '' THEN '' ELSE ', ' + c.Estado END Direccion, 
c.Nombre,
ISNULL(ISNULL(NULL , c.CodigoPostal),'') CodigoPostal,
ISNULL(ISNULL(NULL , c.Ruta),'') Ruta,
CASE ISNULL(e.WMSAndenSurtidoContacto,0) WHEN 1 THEN c.DefPosicionSurtido ELSE ISNULL(ISNULL(c.DefPosicionSurtido, v.PosicionWMS), a.DefPosicionSurtido) END AndenSurtido,
'COMS' Modulo,
v.Sucursal,  
NULL AS SucursalDestino,
NULL AS NomSucursalDestino,
v.Almacen,
WMSSurtidoPosicionTrabajo.Posicion,
(SELECT Sucursal FROM Alm WHERE Almacen = v.Almacen) SucursalOrigen
FROM WMSModuloMovimiento wm
JOIN Compra v ON wm.Modulo = 'COMS' AND wm.Movimiento = v.Mov AND v.Estatus IN(SELECT Estatus FROM WMSModuloMovimiento WHERE Movimiento = v.Mov AND Modulo = 'COMS') /*AND v.Sucursal=@Sucursal*/ 
JOIN Prov c ON v.Proveedor = c.Proveedor
JOIN CompraD vd ON v.ID = vd.ID AND NULLIF(vd.Tarima,'') IS NULL 
JOIN Alm a ON vd.Almacen = a.Almacen
JOIN Alm l ON l.Almacen = v.Almacen AND l.WMS = 1 AND l.Sucursal=v.Sucursal 
JOIN EmpresaCfg e ON e.Empresa = @Empresa
JOIN MovTipo m ON v.Mov = m.Mov AND m.Modulo = 'COMS'
LEFT OUTER JOIN EmpresaCfg2 g ON v.Empresa = g.Empresa
LEFT OUTER JOIN Unidad u ON vd.Unidad = u.Unidad
LEFT OUTER JOIN ArtUnidad au ON vd.Articulo = au.Articulo AND vd.Unidad = au.Unidad
LEFT OUTER JOIN RepParam p ON p.Estacion = @Estacion
LEFT OUTER JOIN WMSSurtidoPosicionTrabajo ON v.ID = WMSSurtidoPosicionTrabajo.ModuloID AND WMSSurtidoPosicionTrabajo.Modulo = 'COMS'
WHERE v.Proveedor = CASE ISNULL(NULLIF(p.InfoContacto,''),'(Todos)')
WHEN '(Todos)' THEN v.Proveedor
WHEN 'Proveedor' THEN ISNULL(NULLIF(p.InfoContactoEspecifico, ''),v.Proveedor)
ELSE ''
END
AND ISNULL(v.FechaRequerida,'') = CASE WHEN ISNULL(p.InfoFechaRequerida,'') = '' THEN ISNULL(v.FechaRequerida,'') ELSE ISNULL(p.InfoFechaRequerida,'') END
AND ISNULL(c.Categoria,'') = ISNULL(NULLIF(RTRIM(LTRIM(p.InfoContactoCat)),''), ISNULL(c.Categoria,''))
AND ISNULL(c.Familia,'') = ISNULL(NULLIF(RTRIM(LTRIM(p.InfoContactoFam)),''), ISNULL(c.Familia,''))
AND ISNULL(c.Ruta,'') = ISNULL(NULLIF(RTRIM(LTRIM(p.InfoContactoRuta)),''), ISNULL(c.Ruta,''))
AND ISNULL(c.Estado,'') = ISNULL(NULLIF(RTRIM(LTRIM(p.InfoContactoEstado)),''), ISNULL(c.Estado,''))
AND ISNULL(c.Zona,'') = ISNULL(NULLIF(RTRIM(LTRIM(p.InfoContactoZona)),''), ISNULL(c.Zona,''))
AND ISNULL(c.Pais,'') = ISNULL(NULLIF(RTRIM(LTRIM(p.InfoContactoPais)),''), ISNULL(c.Pais,''))
AND ISNULL(c.CodigoPostal,'') = ISNULL(NULLIF(RTRIM(LTRIM(p.InfoContactoCP)),''), ISNULL(c.CodigoPostal,''))
AND v.Estatus = 'PENDIENTE'
GROUP BY v.ID, v.Mov, v.MovID, v.FechaEmision, v.FechaRequerida, v.Proveedor,
c.Direccion, c.Nombre, c.DireccionNumero, c.DireccionNumeroInt, c.Delegacion, c.Estado, 
ISNULL(ISNULL(NULL , c.CodigoPostal),''), ISNULL(ISNULL(NULL , c.Ruta),''),
ISNULL(ISNULL(c.DefPosicionSurtido, v.PosicionWMS), a.DefPosicionSurtido), v.Sucursal, e.WMSAndenSurtidoContacto, c.DefPosicionSurtido, 
v.Almacen, WMSSurtidoPosicionTrabajo.Posicion
UNION ALL
SELECT v.ID,
v.Mov,
v.MovID,
v.FechaEmision,
v.FechaRequerida,
v.Almacen,
ISNULL(a.Direccion,'') + CASE WHEN ISNULL(a.Delegacion,'') = '' THEN '' ELSE ' ' + a.Delegacion END + CASE WHEN ISNULL(a.Estado,'') = '' THEN '' ELSE ', ' + a.Estado END Direccion, 
a.Nombre,
ISNULL(ISNULL(NULL , a.CodigoPostal),'') CodigoPostal,
ISNULL(ISNULL(NULL , a.Ruta),'') Ruta,
ISNULL(v.PosicionWMS, a.DefPosicionSurtido) AndenSurtido,
'INV' Modulo,
v.Sucursal,  
s.Sucursal AS SucursalDestino,
ISNULL(s.Nombre,'') + CASE WHEN ISNULL(v.Observaciones,'') = '' THEN '' ELSE ' (' + v.Observaciones + ')' END AS NomSucursalDestino, 
v.Almacen,
WMSSurtidoPosicionTrabajo.Posicion,
(SELECT Sucursal FROM Alm WHERE Almacen = v.Almacen) SucursalOrigen
FROM WMSModuloMovimiento wm
JOIN Inv v ON wm.Modulo = 'INV' AND wm.Movimiento = v.Mov AND v.Estatus IN(SELECT Estatus FROM WMSModuloMovimiento WHERE Movimiento = v.Mov AND Modulo = 'INV') /*AND v.Sucursal=@Sucursal*/ 
JOIN InvD vd ON v.ID = vd.ID
AND NULLIF(vd.Tarima,'') IS NULL 
AND vd.CantidadPendiente > 0 /*AND vd.CantidadReservada > 0 */
JOIN Alm a ON vd.Almacen = a.Almacen
JOIN MovTipo m ON v.Mov = m.Mov AND m.Modulo = 'INV'
JOIN Alm l ON l.Almacen = v.Almacen AND l.WMS = 1 AND l.Sucursal=v.Sucursal 
LEFT OUTER JOIN Alm al ON al.Almacen = v.AlmacenDestino
LEFT OUTER JOIN Sucursal s ON s.AlmacenPrincipal = al.Almacen
LEFT OUTER JOIN EmpresaCfg2 g ON v.Empresa = g.Empresa
LEFT OUTER JOIN Unidad u ON vd.Unidad = u.Unidad
LEFT OUTER JOIN ArtUnidad au ON vd.Articulo = au.Articulo AND vd.Unidad = au.Unidad
LEFT OUTER JOIN RepParam p ON p.Estacion = @Estacion
LEFT OUTER JOIN WMSSurtidoPosicionTrabajo ON v.ID = WMSSurtidoPosicionTrabajo.ModuloID AND WMSSurtidoPosicionTrabajo.Modulo = 'INV'
WHERE v.Almacen = CASE ISNULL(NULLIF(p.InfoContacto,''),'(Todos)')
WHEN '(Todos)' THEN v.Almacen
WHEN 'Almacen' THEN ISNULL(NULLIF(p.InfoContactoEspecifico, ''),v.Almacen)
ELSE ''
END
AND ISNULL(v.FechaRequerida,'') = CASE WHEN ISNULL(p.InfoFechaRequerida,'') = '' THEN ISNULL(v.FechaRequerida,'') ELSE ISNULL(p.InfoFechaRequerida,'') END
AND ISNULL(a.Grupo,'') = ISNULL(NULLIF(RTRIM(LTRIM(p.InfoContactoGrupo)),''), ISNULL(a.Grupo,''))
AND ISNULL(a.Ruta,'') = ISNULL(NULLIF(RTRIM(LTRIM(p.InfoContactoRuta)),''), ISNULL(a.Ruta,''))
AND ISNULL(a.Estado,'') = ISNULL(NULLIF(RTRIM(LTRIM(p.InfoContactoEstado)),''), ISNULL(a.Estado,''))
AND ISNULL(a.Zona,'') = ISNULL(NULLIF(RTRIM(LTRIM(p.InfoContactoZona)),''), ISNULL(a.Zona,''))
AND ISNULL(a.Pais,'') = ISNULL(NULLIF(RTRIM(LTRIM(p.InfoContactoPais)),''), ISNULL(a.Pais,''))
AND ISNULL(a.CodigoPostal,'') = ISNULL(NULLIF(RTRIM(LTRIM(p.InfoContactoCP)),''), ISNULL(a.CodigoPostal,''))
AND v.Estatus = 'PENDIENTE'
AND ISNULL(v.OrigenTipo,'') <> 'EXTVT'
GROUP BY v.Almacen, WMSSurtidoPosicionTrabajo.Posicion, v.ID, v.Mov, v.MovID, v.FechaEmision, v.FechaRequerida, v.Almacen,
ISNULL(a.Direccion,''), a.Nombre, a.Delegacion, a.Estado, 
ISNULL(ISNULL(NULL , a.CodigoPostal),''), ISNULL(ISNULL(NULL , a.Ruta),''),
ISNULL(v.PosicionWMS, a.DefPosicionSurtido), v.Sucursal,s.Sucursal,s.Nombre,v.Observaciones)       

