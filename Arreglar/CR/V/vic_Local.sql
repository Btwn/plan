SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER VIEW vic_Local

AS
SELECT Local					= AlmPos.Posicion,
Lote						= AlmPos.Almacen,
Articulo					= Art.Articulo,
Nombre                   = Art.Descripcion1,
NombreCorto              = Art.NombreCorto,
Descripcion              = Art.Descripcion2,
Rama                     = Art.Rama,
Tipo                     = Art.Tipo,
TipoOpcion				= Art.TipoOpcion,
Cuenta                   = Art.Cuenta,
Familia                  = Art.Familia,
Categoria                = Art.Categoria,
Grupo                    = Art.Grupo,
Usuario                  = Art.Usuario,
Unidad                   = Art.Unidad,
UnidadCompra             = Art.UnidadCompra,
UnidadTraspaso           = Art.UnidadTraspaso,
PrecioVenta              = Art.PrecioLista,
MonedaCosto		        = Art.MonedaCosto,
MonedaPrecioVenta        = Art.MonedaPrecio,
Estatus					= AlmPos.Estatus,
Importe1                 = Art.Impuesto1,
Importe2                 = Art.Impuesto2,
Importe3                 = Art.Impuesto3,
CostoEstandar            = Art.CostoEstandar,
Caducidad				= Art.TieneCaducidad,
Refrigeracion			= Art.Refrigeracion,
FechaAlta				= Art.Alta,
SeProduce				= Art.SeProduce,
SeCompra					= Art.SeCompra,
SeVende					= Art.SeVende,
EsFormula				= Art.EsFormula,
Proveedor				= Art.Proveedor,
CantidadTarima			= Art.CantidadTarima,
UnidadTarima				= Art.UnidadTarima,
MinimoTarima				= Art.MinimoTarima,
AltoTarima				= Art.AltoTarima,
LargoTarima				= Art.LargoTarima,
AnchoTarima				= Art.AnchoTarima,
VolumenTarima			= Art.VolumenTarima,
PesoTarima				= Art.PesoTarima,
CantidadCamaTarima		= Art.CantidadCamaTarima,
CamasTarima				= Art.CamasTarima,
EstibaMaxima				= Art.EstibaMaxima,
ControlArticulo			= Art.ControlArticulo,
DiasCaducidad			= Art.DiasControlCaducidad,
EstibaMismaFecha			= Art.EstibaMismaFecha,
PermiteEstibar			= Art.PermiteEstibar,
TarimasReacomodar		= Art.TarimasReacomodar,
Rotacion					= Art.TipoRotacion
FROM Art
JOIN ArtDisponibleTarima ON Art.Articulo = ArtDisponibleTarima.Articulo
JOIN Tarima ON ArtDisponibleTarima.Tarima = Tarima.Tarima
LEFT JOIN AlmPos ON ArtDisponibleTarima.Almacen = AlmPos.Almacen AND Tarima.posicion = AlmPos.posicion
GROUP BY AlmPos.Posicion, AlmPos.Almacen, Art.Articulo, Art.Descripcion1, Art.NombreCorto, Art.Descripcion2, Art.Rama, Art.Tipo, Art.TipoOpcion, Art.Cuenta, Art.Familia, Art.Categoria, Art.Grupo, Art.Usuario,  Art.Unidad, Art.UnidadCompra,
Art.UnidadTraspaso, Art.PrecioLista, Art.MonedaCosto, Art.MonedaPrecio, AlmPos.Estatus, Art.Impuesto1, Art.Impuesto2, Art.Impuesto3, Art.CostoEstandar, Art.TieneCaducidad, Art.Refrigeracion, Art.Alta, Art.SeProduce, Art.SeCompra,
Art.SeVende, Art.EsFormula, Art.Proveedor, Art.CantidadTarima, Art.UnidadTarima, Art.MinimoTarima, Art.AltoTarima, Art.LargoTarima, Art.AnchoTarima, Art.VolumenTarima, Art.PesoTarima, Art.CantidadCamaTarima, Art.CamasTarima,
Art.EstibaMaxima, Art.ControlArticulo, Art.DiasControlCaducidad, Art.EstibaMismaFecha, Art.PermiteEstibar, Art.TarimasReacomodar, Art.TipoRotacion, AlmPos.Posicion

