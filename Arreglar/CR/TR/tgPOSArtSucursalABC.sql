SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER TRIGGER tgPOSArtSucursalABC ON POSArtSucursal

FOR UPDATE, DELETE,INSERT
AS BEGIN
DECLARE
@EsOrigen           bit,
@SincronizaArtSuc   bit
SELECT @EsOrigen = ISNULL(EsOrigen,0), @SincronizaArtSuc = ISNULL(SincronizaArtSuc,0) FROM POSiSync
IF @EsOrigen = 1 RETURN
IF @SincronizaArtSuc = 0 RETURN
IF EXISTS(SELECT * FROM DELETED) AND NOT EXISTS(SELECT * FROM INSERTED)
BEGIN
DELETE Art FROM Art a JOIN DELETED d ON a.Articulo = d.Articulo AND a.TieneMovimientos = 0
UPDATE Art SET  Estatus = 'BAJA'
FROM Art a JOIN DELETED d ON d.Articulo = a.Articulo AND a.TieneMovimientos = 1
END
IF EXISTS(SELECT * FROM DELETED) AND  EXISTS(SELECT * FROM INSERTED)
UPDATE Art SET  Rama = i.Rama, Descripcion1 = i.Descripcion1, Descripcion2 = i.Descripcion2, NombreCorto = i.NombreCorto, Grupo = i.Grupo, Categoria = i.Categoria, Familia = i.Familia, Linea = i.Linea, Fabricante = i.Fabricante, Impuesto1 = i.Impuesto1, Impuesto2 = i.Impuesto2, Impuesto3 = i.Impuesto3, Factor = i.Factor, Unidad = i.Unidad, UnidadCompra = i.UnidadCompra, UnidadTraspaso = i.UnidadTraspaso, Tipo = i.Tipo, TipoOpcion = i.TipoOpcion, Accesorios = i.Accesorios, Sustitutos = i.Sustitutos, MonedaPrecio = i.MonedaPrecio, PrecioLista = i.PrecioLista, PrecioMinimo = i.PrecioMinimo, Estatus = i.Estatus, Alta = i.Alta, Precio2 = i.Precio2, Precio3 = i.Precio3, Precio4 = i.Precio4, Precio5 = i.Precio5, Precio6 = i.Precio6, Precio7 = i.Precio7, Precio8 = i.Precio8, Precio9 = i.Precio9, Precio10 = i.Precio10, BasculaPesar = i.BasculaPesar, TieneMovimientos = i.TieneMovimientos, Retencion1 = i.Retencion1, Retencion2 = i.Retencion2, Retencion3 = i.Retencion3, MonedaCosto = ISNULL(i.MonedaCosto,'Pesos'), TipoCosteo = i.TipoCosteo, Calificacion = ISNULL(i.Calificacion,0), TipoImpuesto1 = i.TipoImpuesto1, TipoImpuesto2 = i.TipoImpuesto2, TipoImpuesto3 = i.TipoImpuesto3, TipoImpuesto4 = i.TipoImpuesto4, TipoImpuesto5 = i.TipoImpuesto5, TipoRetencion1 = i.TipoRetencion1, TipoRetencion2 = i.TipoRetencion2, TipoRetencion3 = i.TipoRetencion3
FROM Art a JOIN INSERTED i ON i.Articulo = a.Articulo
IF NOT EXISTS(SELECT * FROM DELETED) AND  EXISTS(SELECT * FROM INSERTED)
BEGIN
INSERT Art(Articulo,     Descripcion1,     Descripcion2,     NombreCorto,     Grupo,     Categoria,     Familia,     Linea,     Fabricante,     Impuesto1,     Impuesto2,     Impuesto3,     Factor,     Unidad,     UnidadCompra,     UnidadTraspaso,     Tipo,     TipoOpcion,     Accesorios,     Sustitutos,     MonedaPrecio,     PrecioLista,     PrecioMinimo,     Estatus,     Alta,     Precio2,     Precio3,     Precio4,     Precio5,     Precio6,     Precio7,     Precio8,     Precio9,     Precio10,     BasculaPesar,     TieneMovimientos,     Retencion1,     Retencion2,     Retencion3, MonedaCosto,TipoCosteo, Calificacion, TipoImpuesto1, TipoImpuesto2, TipoImpuesto3, TipoImpuesto4, TipoImpuesto5, TipoRetencion1, TipoRetencion2, TipoRetencion3)
SELECT     Articulo,     Descripcion1,     Descripcion2,     NombreCorto,     Grupo,     Categoria,     Familia,     Linea,     Fabricante,     Impuesto1,     Impuesto2,     Impuesto3,     Factor,     Unidad,     UnidadCompra,     UnidadTraspaso,     Tipo,     TipoOpcion,     Accesorios,     Sustitutos,     MonedaPrecio,     PrecioLista,     PrecioMinimo,     Estatus,     Alta,     Precio2,     Precio3,     Precio4,     Precio5,     Precio6,     Precio7,     Precio8,     Precio9,     Precio10,     BasculaPesar,     TieneMovimientos,     Retencion1,     Retencion2,     Retencion3, MonedaCosto,TipoCosteo, Calificacion, TipoImpuesto1, TipoImpuesto2, TipoImpuesto3, TipoImpuesto4, TipoImpuesto5, TipoRetencion1, TipoRetencion2, TipoRetencion3
FROM Inserted
WHERE Articulo NOT IN (SELECT Articulo FROM Art)
GROUP BY Articulo,     Descripcion1,     Descripcion2,     NombreCorto,     Grupo,     Categoria,     Familia,     Linea,     Fabricante,     Impuesto1,     Impuesto2,     Impuesto3,     Factor,     Unidad,     UnidadCompra,     UnidadTraspaso,     Tipo,     TipoOpcion,     Accesorios,     Sustitutos,     MonedaPrecio,     PrecioLista,     PrecioMinimo,     Estatus,     Alta,     Precio2,     Precio3,     Precio4,     Precio5,     Precio6,     Precio7,     Precio8,     Precio9,     Precio10,     BasculaPesar,     TieneMovimientos,     Retencion1,     Retencion2,     Retencion3, MonedaCosto,TipoCosteo, Calificacion, TipoImpuesto1, TipoImpuesto2, TipoImpuesto3, TipoImpuesto4, TipoImpuesto5, TipoRetencion1, TipoRetencion2, TipoRetencion3
UPDATE Art SET  Rama = i.Rama, Descripcion1 = i.Descripcion1, Descripcion2 = i.Descripcion2, NombreCorto = i.NombreCorto, Grupo = i.Grupo, Categoria = i.Categoria, Familia = i.Familia, Linea = i.Linea, Fabricante = i.Fabricante, Impuesto1 = i.Impuesto1, Impuesto2 = i.Impuesto2, Impuesto3 = i.Impuesto3, Factor = i.Factor, Unidad = i.Unidad, UnidadCompra = i.UnidadCompra, UnidadTraspaso = i.UnidadTraspaso, Tipo = i.Tipo, TipoOpcion = i.TipoOpcion, Accesorios = i.Accesorios, Sustitutos = i.Sustitutos, MonedaPrecio = i.MonedaPrecio, PrecioLista = i.PrecioLista, PrecioMinimo = i.PrecioMinimo, Estatus = i.Estatus, Alta = i.Alta, Precio2 = i.Precio2, Precio3 = i.Precio3, Precio4 = i.Precio4, Precio5 = i.Precio5, Precio6 = i.Precio6, Precio7 = i.Precio7, Precio8 = i.Precio8, Precio9 = i.Precio9, Precio10 = i.Precio10, BasculaPesar = i.BasculaPesar, TieneMovimientos = i.TieneMovimientos, Retencion1 = i.Retencion1, Retencion2 = i.Retencion2, Retencion3 = i.Retencion3, MonedaCosto = ISNULL(i.MonedaCosto,'Pesos'), TipoCosteo = i.TipoCosteo, Calificacion = ISNULL(i.Calificacion,0), TipoImpuesto1 = i.TipoImpuesto1, TipoImpuesto2 = i.TipoImpuesto2, TipoImpuesto3 = i.TipoImpuesto3, TipoImpuesto4 = i.TipoImpuesto4, TipoImpuesto5 = i.TipoImpuesto5, TipoRetencion1 = i.TipoRetencion1, TipoRetencion2 = i.TipoRetencion2, TipoRetencion3 = i.TipoRetencion3
FROM Art a JOIN INSERTED i ON i.Articulo = a.Articulo
END
RETURN
END

