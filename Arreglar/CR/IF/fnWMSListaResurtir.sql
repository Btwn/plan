SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER FUNCTION fnWMSListaResurtir (@Estacion int, @Empresa char(5))
RETURNS TABLE
AS
RETURN (
SELECT v.ID, v.Mov, v.MovID, v.FechaEmision, v.FechaRequerida, v.Cliente Contacto,
ISNULL(ISNULL(ca.Direccion, c.Direccion),'') + ' - ' + ISNULL(ISNULL(ca.DireccionNumero , c.DireccionNumero),'') + ' ' + ISNULL(ISNULL(ca.DireccionNumeroInt , c.DireccionNumeroInt),'') +
ISNULL(ISNULL(ca.Delegacion, c.Delegacion),'') + ', ' + ISNULL(ISNULL(ca.Estado, c.Estado),'') Direccion,
ISNULL(ISNULL(ca.CodigoPostal , c.CodigoPostal),'') CodigoPostal, ISNULL(ISNULL(ca.Ruta , c.Ruta),'') Ruta,
CASE ISNULL(e.WMSAndenSurtidoContacto,0) WHEN 1 THEN c.DefPosicionSurtido ELSE ISNULL(v.PosicionWMS, a.DefPosicionSurtido) END AndenSurtido, 'VTAS' Modulo, v.Sucursal
FROM WMSModuloMovimiento wm
JOIN Venta v ON wm.Modulo = 'VTAS' AND wm.Movimiento = v.Mov
JOIN Cte c ON v.Cliente = c.Cliente
JOIN VentaD vd ON v.ID = vd.ID AND NULLIF(vd.Tarima,'') IS NOT NULL AND ISNULL(NULLIF(ISNULL(vd.CantidadReservada,0.00) + ISNULL(vd.CantidadPendiente,0.00),0.00),vd.Cantidad) > 0
JOIN Alm a ON vd.Almacen = a.Almacen
LEFT JOIN CteEnviarA ca ON c.Cliente = ca.Cliente AND vd.EnviarA = ca.ID
LEFT JOIN WMSModuloTarima wmt ON 'VTAS' = wmt.Modulo AND vd.ID = wmt.IDModulo AND vd.Renglon = wmt.Renglon AND vd.RenglonSub = wmt.RenglonSub AND wmt.Tarima IS NOT NULL
JOIN Alm l ON l.Almacen = v.Almacen AND l.WMS = 1
JOIN EmpresaCfg e ON e.Empresa = @Empresa
JOIN MovTipo m ON v.Mov = m.Mov AND m.Modulo = 'VTAS'
LEFT OUTER JOIN EmpresaCfg2 g ON v.Empresa = g.Empresa
LEFT OUTER JOIN Unidad u ON vd.Unidad = u.Unidad
LEFT OUTER JOIN ArtUnidad au ON vd.Articulo = au.Articulo AND vd.Unidad = au.Unidad
LEFT OUTER JOIN RepParam p ON p.Estacion = @Estacion
LEFT OUTER JOIN Venta va ON va.Origen = v.Mov AND va.OrigenID = v.MovID AND va.Empresa = v.Empresa AND va.Estatus <> 'CANCELADO'
LEFT OUTER JOIN MovTipo ma ON va.Mov = ma.Mov AND ma.Modulo = 'VTAS'
WHERE v.Cliente = CASE ISNULL(NULLIF(p.InfoContacto,''),'(Todos)')
WHEN '(Todos)' THEN v.Cliente
WHEN 'Cliente' THEN ISNULL(NULLIF(RTRIM(LTRIM(p.InfoContactoEspecifico)),''), v.Cliente)
ELSE ''
END
AND ISNULL(v.FechaEmision,'') = CASE WHEN ISNULL(p.InfoFechaEmision,'') = '' THEN ISNULL(v.FechaEmision,'') ELSE ISNULL(p.infoFechaEmision,'') END
AND ISNULL(v.FechaRequerida,'') = CASE WHEN ISNULL(p.InfoFechaRequerida,'') = '' THEN ISNULL(v.FechaRequerida,'') ELSE ISNULL(p.InfoFechaRequerida,'') END
AND ISNULL(c.Categoria,'') = ISNULL(NULLIF(RTRIM(LTRIM(p.InfoContactoCat)),''), ISNULL(c.Categoria,''))
AND ISNULL(c.Grupo,'') = ISNULL(NULLIF(RTRIM(LTRIM(p.InfoContactoGrupo)),''), ISNULL(c.Grupo,''))
AND ISNULL(c.Familia,'') = ISNULL(NULLIF(RTRIM(LTRIM(p.InfoContactoFam)),''), ISNULL(c.Familia,''))
AND ISNULL(c.Ruta,'') = ISNULL(NULLIF(RTRIM(LTRIM(p.InfoContactoRuta)),''), ISNULL(c.Ruta,''))
AND ISNULL(c.Estado,'') = ISNULL(NULLIF(RTRIM(LTRIM(p.InfoContactoEstado)),''), ISNULL(c.Estado,''))
AND ISNULL(c.Zona,'') = ISNULL(NULLIF(RTRIM(LTRIM(p.InfoContactoZona)),''), ISNULL(c.Zona,''))
AND ISNULL(c.Pais,'') = ISNULL(NULLIF(RTRIM(LTRIM(p.InfoContactoPais)),''), ISNULL(c.Pais,''))
AND ISNULL(c.CodigoPostal,'') = ISNULL(NULLIF(RTRIM(LTRIM(p.InfoContactoCP)),''), ISNULL(c.CodigoPostal,''))
AND dbo.fnWMSListaResurtirTarima(v.id, 'VTAS') = 0
AND ma.Clave NOT IN('VTAS.F')
GROUP BY v.ID, v.Mov, v.MovID, v.FechaEmision, v.FechaRequerida, v.Cliente,
ISNULL(ISNULL(ca.Direccion, c.Direccion),'') + ' - ' + ISNULL(ISNULL(ca.DireccionNumero , c.DireccionNumero),'') + ' ' + ISNULL(ISNULL(ca.DireccionNumeroInt , c.DireccionNumeroInt),'') +
ISNULL(ISNULL(ca.Delegacion, c.Delegacion),'') + ', ' + ISNULL(ISNULL(ca.Estado, c.Estado),''),
ISNULL(ISNULL(ca.CodigoPostal , c.CodigoPostal),''), ISNULL(ISNULL(ca.Ruta , c.Ruta),''),
ISNULL(v.PosicionWMS, a.DefPosicionSurtido), v.Sucursal, e.WMSAndenSurtidoContacto, c.DefPosicionSurtido
UNION ALL
SELECT v.ID, v.Mov, v.MovID, v.FechaEmision, v.FechaRequerida, v.Proveedor,
ISNULL(ISNULL(NULL, c.Direccion),'') + ' - ' + ISNULL(ISNULL(NULL , c.DireccionNumero),'') + ' ' + ISNULL(ISNULL(NULL , c.DireccionNumeroInt),'') +
ISNULL(ISNULL(NULL, c.Delegacion),'') + ', ' + ISNULL(ISNULL(NULL, c.Estado),'') Direccion,
ISNULL(ISNULL(NULL , c.CodigoPostal),'') CodigoPostal, ISNULL(ISNULL(NULL , c.Ruta),'') Ruta,
CASE ISNULL(e.WMSAndenSurtidoContacto,0) WHEN 1 THEN c.DefPosicionSurtido ELSE ISNULL(ISNULL(c.DefPosicionSurtido, v.PosicionWMS), a.DefPosicionSurtido) END AndenSurtido,'COMS' Modulo, v.Sucursal
FROM WMSModuloMovimiento wm
JOIN Compra v ON wm.Modulo = 'COMS' AND wm.Movimiento = v.Mov
JOIN Prov c ON v.Proveedor = c.Proveedor
JOIN CompraD vd ON v.ID = vd.ID AND NULLIF(vd.Tarima,'') IS NOT NULL
JOIN Alm a ON vd.Almacen = a.Almacen
JOIN Alm l ON l.Almacen = v.Almacen AND l.WMS = 1
JOIN EmpresaCfg e ON e.Empresa = @Empresa
JOIN MovTipo m ON v.Mov = m.Mov AND m.Modulo = 'COMS'
LEFT OUTER JOIN EmpresaCfg2 g ON v.Empresa = g.Empresa
LEFT OUTER JOIN Unidad u ON vd.Unidad = u.Unidad
LEFT OUTER JOIN ArtUnidad au ON vd.Articulo = au.Articulo AND vd.Unidad = au.Unidad
LEFT OUTER JOIN RepParam p ON p.Estacion = @Estacion
LEFT OUTER JOIN Compra va ON va.Origen = v.Mov AND va.OrigenID = v.MovID AND va.Empresa = v.Empresa AND va.Estatus <> 'CANCELADO'
LEFT OUTER JOIN MovTipo ma ON va.Mov = ma.Mov AND ma.Modulo = 'COMS'
WHERE v.Proveedor = CASE ISNULL(NULLIF(p.InfoContacto,''),'(Todos)')
WHEN '(Todos)' THEN v.Proveedor
WHEN 'Proveedor' THEN ISNULL(NULLIF(p.InfoContactoEspecifico, ''),v.Proveedor)
ELSE ''
END
AND ISNULL(v.FechaEmision,'') = CASE WHEN ISNULL(p.InfoFechaEmision,'') = '' THEN ISNULL(v.FechaEmision,'') ELSE ISNULL(p.infoFechaEmision,'') END
AND ISNULL(v.FechaRequerida,'') = CASE WHEN ISNULL(p.InfoFechaRequerida,'') = '' THEN ISNULL(v.FechaRequerida,'') ELSE ISNULL(p.InfoFechaRequerida,'') END
AND ISNULL(c.Categoria,'') = ISNULL(NULLIF(RTRIM(LTRIM(p.InfoContactoCat)),''), ISNULL(c.Categoria,''))
AND ISNULL(c.Familia,'') = ISNULL(NULLIF(RTRIM(LTRIM(p.InfoContactoFam)),''), ISNULL(c.Familia,''))
AND ISNULL(c.Ruta,'') = ISNULL(NULLIF(RTRIM(LTRIM(p.InfoContactoRuta)),''), ISNULL(c.Ruta,''))
AND ISNULL(c.Estado,'') = ISNULL(NULLIF(RTRIM(LTRIM(p.InfoContactoEstado)),''), ISNULL(c.Estado,''))
AND ISNULL(c.Zona,'') = ISNULL(NULLIF(RTRIM(LTRIM(p.InfoContactoZona)),''), ISNULL(c.Zona,''))
AND ISNULL(c.Pais,'') = ISNULL(NULLIF(RTRIM(LTRIM(p.InfoContactoPais)),''), ISNULL(c.Pais,''))
AND ISNULL(c.CodigoPostal,'') = ISNULL(NULLIF(RTRIM(LTRIM(p.InfoContactoCP)),''), ISNULL(c.CodigoPostal,''))
AND dbo.fnWMSListaResurtirTarima(v.id, 'COMS') = 0
AND ma.Clave NOT IN( 'COMS.F')
GROUP BY v.ID, v.Mov, v.MovID, v.FechaEmision, v.FechaRequerida, v.Proveedor,
ISNULL(ISNULL(NULL, c.Direccion),'') + ' - ' + ISNULL(ISNULL(NULL , c.DireccionNumero),'') + ' ' + ISNULL(ISNULL(NULL , c.DireccionNumeroInt),'') +
ISNULL(ISNULL(NULL, c.Delegacion),'') + ', ' + ISNULL(ISNULL(NULL, c.Estado),''),
ISNULL(ISNULL(NULL , c.CodigoPostal),''), ISNULL(ISNULL(NULL , c.Ruta),''),
ISNULL(ISNULL(c.DefPosicionSurtido, v.PosicionWMS), a.DefPosicionSurtido), v.Sucursal, e.WMSAndenSurtidoContacto, c.DefPosicionSurtido
UNION ALL
SELECT v.ID, v.Mov, v.MovID, v.FechaEmision, v.FechaRequerida, v.Almacen,
ISNULL(ISNULL(NULL, a.Direccion),'') + ' - ' + ISNULL(ISNULL(NULL , a.DireccionNumero),'') + ' ' + ISNULL(ISNULL(NULL , a.DireccionNumeroInt),'') +
ISNULL(ISNULL(NULL, a.Delegacion),'') + ', ' + ISNULL(ISNULL(NULL, a.Estado),'') Direccion,
ISNULL(ISNULL(NULL , a.CodigoPostal),'') CodigoPostal, ISNULL(ISNULL(NULL , a.Ruta),'') Ruta,
ISNULL(v.PosicionWMS, a.DefPosicionSurtido) AndenSurtido, 'INV' Modulo, v.Sucursal
FROM WMSModuloMovimiento wm
JOIN Inv v ON wm.Modulo = 'INV' AND wm.Movimiento = v.Mov
JOIN InvD vd ON v.ID = vd.ID AND NULLIF(vd.Tarima,'') IS NOT NULL AND ISNULL(NULLIF(ISNULL(vd.CantidadReservada,0.00) + ISNULL(vd.CantidadPendiente,0.00),0.00),vd.Cantidad) > 0
JOIN Alm a ON vd.Almacen = a.Almacen
JOIN MovTipo m ON v.Mov = m.Mov AND m.Modulo = 'INV'
JOIN Alm l ON l.Almacen = v.Almacen AND l.WMS = 1
LEFT OUTER JOIN EmpresaCfg2 g ON v.Empresa = g.Empresa
LEFT OUTER JOIN Unidad u ON vd.Unidad = u.Unidad
LEFT OUTER JOIN ArtUnidad au ON vd.Articulo = au.Articulo AND vd.Unidad = au.Unidad
LEFT OUTER JOIN RepParam p ON p.Estacion = @Estacion
LEFT OUTER JOIN Inv va ON va.Origen = v.Mov AND va.OrigenID = v.MovID AND va.Empresa = v.Empresa AND va.Estatus <> 'CANCELADO'
LEFT OUTER JOIN MovTipo ma ON va.Mov = ma.Mov AND ma.Modulo = 'INV'
WHERE v.Almacen = CASE ISNULL(NULLIF(p.InfoContacto,''),'(Todos)')
WHEN '(Todos)' THEN v.Almacen
WHEN 'Almacen' THEN ISNULL(NULLIF(p.InfoContactoEspecifico, ''),v.Almacen)
ELSE ''
END
AND ISNULL(v.FechaEmision,'') = CASE WHEN ISNULL(p.InfoFechaEmision,'') = '' THEN ISNULL(v.FechaEmision,'') ELSE ISNULL(p.infoFechaEmision,'') END
AND ISNULL(v.FechaRequerida,'') = CASE WHEN ISNULL(p.InfoFechaRequerida,'') = '' THEN ISNULL(v.FechaRequerida,'') ELSE ISNULL(p.InfoFechaRequerida,'') END
AND ISNULL(a.Grupo,'') = ISNULL(NULLIF(RTRIM(LTRIM(p.InfoContactoGrupo)),''), ISNULL(a.Grupo,''))
AND ISNULL(a.Ruta,'') = ISNULL(NULLIF(RTRIM(LTRIM(p.InfoContactoRuta)),''), ISNULL(a.Ruta,''))
AND ISNULL(a.Estado,'') = ISNULL(NULLIF(RTRIM(LTRIM(p.InfoContactoEstado)),''), ISNULL(a.Estado,''))
AND ISNULL(a.Zona,'') = ISNULL(NULLIF(RTRIM(LTRIM(p.InfoContactoZona)),''), ISNULL(a.Zona,''))
AND ISNULL(a.Pais,'') = ISNULL(NULLIF(RTRIM(LTRIM(p.InfoContactoPais)),''), ISNULL(a.Pais,''))
AND ISNULL(a.CodigoPostal,'') = ISNULL(NULLIF(RTRIM(LTRIM(p.InfoContactoCP)),''), ISNULL(a.CodigoPostal,''))
AND dbo.fnWMSListaResurtirTarima(v.id, 'INV') = 0
AND ma.Clave NOT IN('INV.T', 'INV.EI')
GROUP BY v.ID, v.Mov, v.MovID, v.FechaEmision, v.FechaRequerida, v.Almacen,
ISNULL(ISNULL(NULL, a.Direccion),'') + ' - ' + ISNULL(ISNULL(NULL , a.DireccionNumero),'') + ' ' + ISNULL(ISNULL(NULL , a.DireccionNumeroInt),'') +
ISNULL(ISNULL(NULL, a.Delegacion),'') + ', ' + ISNULL(ISNULL(NULL, a.Estado),''),
ISNULL(ISNULL(NULL , a.CodigoPostal),''), ISNULL(ISNULL(NULL , a.Ruta),''),
ISNULL(v.PosicionWMS, a.DefPosicionSurtido), v.Sucursal
)

