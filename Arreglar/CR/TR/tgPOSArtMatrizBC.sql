SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER TRIGGER tgPOSArtMatrizBC ON Art

FOR UPDATE, DELETE
AS BEGIN
DECLARE
@EsOrigen           bit,
@SincronizaArtSuc   bit
SELECT @EsOrigen = ISNULL(EsOrigen,0), @SincronizaArtSuc = ISNULL(SincronizaArtSuc,0) FROM POSiSync
IF @EsOrigen = 0 RETURN
IF @SincronizaArtSuc = 0 RETURN
IF EXISTS(SELECT * FROM DELETED) AND NOT EXISTS(SELECT * FROM INSERTED)
BEGIN
DELETE POSArtSucursal
FROM POSArtSucursal a JOIN DELETED d ON a.Articulo = d.Articulo
DELETE POSArtCodigoSucursal
FROM POSArtCodigoSucursal a JOIN DELETED d ON a.Articulo = d.Articulo
END
IF EXISTS(SELECT * FROM DELETED) AND  EXISTS(SELECT * FROM INSERTED)
UPDATE POSArtSucursal SET  Rama = i.Rama, Descripcion1 = i.Descripcion1, Descripcion2 = i.Descripcion2, NombreCorto = i.NombreCorto, Grupo = i.Grupo, Categoria = i.Categoria, Familia = i.Familia, Linea = i.Linea, Fabricante = i.Fabricante, Impuesto1 = i.Impuesto1, Impuesto2 = i.Impuesto2, Impuesto3 = i.Impuesto3, Factor = i.Factor, Unidad = i.Unidad, UnidadCompra = i.UnidadCompra, UnidadTraspaso = i.UnidadTraspaso, Tipo = i.Tipo, TipoOpcion = i.TipoOpcion, Accesorios = i.Accesorios, Sustitutos = i.Sustitutos, MonedaPrecio = i.MonedaPrecio, PrecioLista = i.PrecioLista, PrecioMinimo = i.PrecioMinimo, Estatus = i.Estatus, Alta = i.Alta, Precio2 = i.Precio2, Precio3 = i.Precio3, Precio4 = i.Precio4, Precio5 = i.Precio5, Precio6 = i.Precio6, Precio7 = i.Precio7, Precio8 = i.Precio8, Precio9 = i.Precio9, Precio10 = i.Precio10, BasculaPesar = i.BasculaPesar, TieneMovimientos = i.TieneMovimientos, Retencion1 = i.Retencion1, Retencion2 = i.Retencion2, Retencion3 = i.Retencion3, TipoImpuesto1 = i.TipoImpuesto1, TipoImpuesto2 = i.TipoImpuesto2, TipoImpuesto3 = i.TipoImpuesto3, TipoImpuesto4 = i.TipoImpuesto4, TipoImpuesto5 = i.TipoImpuesto5, TipoRetencion1 = i.TipoRetencion1, TipoRetencion2 = i.TipoRetencion2, TipoRetencion3 = i.TipoRetencion3
FROM POSArtSucursal p JOIN INSERTED i ON i.Articulo = p.Articulo
RETURN
END

