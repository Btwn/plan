SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spPOSInsertarPOSArtSucursal
@Estacion           int

AS
BEGIN
DECLARE @Tabla table(
Articulo  varchar(20),
Sucursal  int,
Host      varchar(20))
INSERT @Tabla(
Articulo, Sucursal, Host)
SELECT
a.Clave, t.Sucursal, s.Host
FROM ListaSt a JOIN  POSArtSucursalTemp t ON a.Estacion = t.Estacion
JOIN Sucursal s ON s.Sucursal = t.Sucursal
WHERE a.Estacion = @Estacion
EXCEPT
SELECT Articulo, Sucursal,Host
FROM POSArtSucursal
INSERT POSArtCodigoSucursal(
Sucursal, Codigo, Articulo, SubCuenta, Host, Cantidad, Unidad)
SELECT
t.Sucursal, c.Codigo, a.Clave,   c.SubCuenta , s.Host, c.Cantidad, c.Unidad
FROM ListaSt a JOIN  POSArtSucursalTemp t ON a.Estacion = t.Estacion
JOIN Sucursal s ON s.Sucursal = t.Sucursal
JOIN CB c ON c.Cuenta = a.Clave AND c.TipoCuenta = 'Articulos'
WHERE a.Estacion = @Estacion
EXCEPT
SELECT Sucursal,   Codigo,   Articulo,  SubCuenta,    Host, Cantidad,   Unidad
FROM POSArtCodigoSucursal
INSERT POSArtSucursal(
Articulo, Sucursal, Host, Rama, Descripcion1, Descripcion2, NombreCorto, Grupo, Categoria, Familia, Linea, Fabricante,
Impuesto1, Impuesto2, Impuesto3, Factor, Unidad, UnidadCompra, UnidadTraspaso, Tipo, TipoOpcion, Accesorios, Sustitutos,
MonedaPrecio, PrecioLista, PrecioMinimo, Estatus, Alta, Precio2, Precio3, Precio4, Precio5, Precio6, Precio7,
Precio8, Precio9, Precio10, BasculaPesar, TieneMovimientos, Retencion1, Retencion2, Retencion3, MonedaCosto, TipoCosteo,
Calificacion, TipoImpuesto1, TipoImpuesto2, TipoImpuesto3, TipoImpuesto4, TipoImpuesto5, TipoRetencion1, TipoRetencion2,
TipoRetencion3)
SELECT
a.Articulo, a.Sucursal, a.Host, art.Rama, art.Descripcion1, art.Descripcion2, art.NombreCorto, art.Grupo, art.Categoria, art.Familia, art.Linea, art.Fabricante,
art.Impuesto1, art.Impuesto2, art.Impuesto3, art.Factor, art.Unidad, art.UnidadCompra, art.UnidadTraspaso, art.Tipo, art.TipoOpcion, art.Accesorios, art.Sustitutos,
art.MonedaPrecio, art.PrecioLista, art.PrecioMinimo, art.Estatus, art.Alta, art.Precio2, art.Precio3, art.Precio4, art.Precio5, art.Precio6, art.Precio7,
art.Precio8, art.Precio9, art.Precio10, art.BasculaPesar, art.TieneMovimientos, art.Retencion1, art.Retencion2, art.Retencion3 , art.MonedaCosto, art.TipoCosteo,
art.Calificacion, art.TipoImpuesto1, art.TipoImpuesto2, art.TipoImpuesto3, art.TipoImpuesto4, art.TipoImpuesto5, art.TipoRetencion1, art.TipoRetencion2,
art.TipoRetencion3
FROM @Tabla a JOIN Art art ON a.Articulo = art.Articulo
SELECT 'Operación Realizada Exitosamente'
END

