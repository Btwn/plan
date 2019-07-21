SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spMFALayoutImportar_CostoVentas
@Usuario			varchar(20),
@Empresa			varchar(5),
@Ejercicio		int,
@Periodo			int

AS BEGIN
DELETE Layout_CostoMovs WHERE Empresa = @Empresa AND Ejercicio = @Ejercicio AND Periodo = @Periodo
INSERT INTO Layout_CostoMovs(
Empresa,   Sucursal,   Centro,    Cve_almacen,  Descr_almacen, Tipo_movimiento, es_importacion, es_relacionada, es_deducible,   Num_documento,   Ejercicio,   Periodo, Dia,                   Unidad,   Cantidad, Importe,                                                                                    Material,     Descr_material, CatAlmacen,                 Fecha)
SELECT e.Empresa, e.Sucursal, e.ContUso, e.Almacen,    a.Nombre,        'Otros',         0,              0,              1,            e.MovID,         e.Ejercicio, e.Periodo, DAY(e.FechaEmision), d.Unidad, d.Cantidad, CASE WHEN MovTipo.Clave IN('INV.S') THEN -d.Cantidad*d.Costo ELSE d.Cantidad*d.Costo END, d.Articulo, Art.Descripcion1,   ISNULL(a.Categoria, ''),  e.FechaEmision
FROM Inv e   WITH(NOLOCK)
JOIN InvD d  WITH(NOLOCK) ON e.ID = d.ID
JOIN Alm a   WITH(NOLOCK) ON e.Almacen = a.Almacen
JOIN Art     WITH(NOLOCK) ON d.Articulo = Art.Articulo
JOIN MovTipo WITH(NOLOCK) ON e.Mov = MovTipo.Mov AND MovTipo.Modulo = 'INV'
JOIN MovTipoMFACostoVenta WITH(NOLOCK) ON e.Mov = MovTipoMFACostoVenta.Mov AND MovTipoMFACostoVenta.Modulo = 'INV'
WHERE e.Empresa = @Empresa
AND e.Ejercicio = @Ejercicio
AND e.Periodo = @Periodo
AND e.Estatus IN('PENDIENTE', 'CONCLUIDO')
INSERT INTO Layout_CostoMovs(
Empresa,   Sucursal,   Centro,    Cve_almacen,  Descr_almacen, Tipo_movimiento, es_importacion,                                      es_relacionada, es_deducible,   Num_documento,   Ejercicio,   Periodo, Dia,                   Unidad,   Cantidad, Importe,                                                                               Material,     Descr_material, CatAlmacen,                 Fecha)
SELECT e.Empresa, e.Sucursal, e.ContUso, e.Almacen,    a.Nombre,        'Compras',       CASE MovTipo.Clave WHEN 'COMS.EI' THEN 1 ELSE 0 END, 0,              1,            e.MovID,         e.Ejercicio, e.Periodo, DAY(e.FechaEmision), e.Unidad, e.Cantidad, CASE WHEN MovTipo.Clave IN('COMS.B', 'COMS.D') THEN -e.SubTotal ELSE e.SubTotal END, e.Articulo, Art.Descripcion1,   ISNULL(a.Categoria, ''),  e.FechaEmision
FROM CompraTCalc e
JOIN Alm a      WITH(NOLOCK) ON e.Almacen = a.Almacen
JOIN Art        WITH(NOLOCK) ON e.Articulo = Art.Articulo
JOIN MovTipo    WITH(NOLOCK) ON e.Mov = MovTipo.Mov AND MovTipo.Modulo = 'COMS'
JOIN MovTipoMFACostoVenta WITH(NOLOCK) ON e.Mov = MovTipoMFACostoVenta.Mov AND MovTipoMFACostoVenta.Modulo = 'COMS'
WHERE e.Empresa = @Empresa
AND e.Ejercicio = @Ejercicio
AND e.Periodo = @Periodo
AND e.Estatus IN('PENDIENTE', 'CONCLUIDO')
EXEC sp_layout_importar_costomovs @Usuario, @Empresa, @Ejercicio
RETURN
END

