SET DATEFIRST 7
SET ANSI_NULLS ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET ANSI_WARNINGS ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE  [dbo].[spAspelInsertaArticulos]

AS BEGIN
DECLARE	@Observaciones			varchar(30),
@Sucursal		varchar(30),
@Moneda			varchar(30),
@Usuario		varchar(30),
@Conta			int
SELECT @Observaciones = Valor FROM AspelCfg WHERE Descripcion = 'Observaciones'
SELECT @Sucursal = Valor FROM AspelCfg WHERE Descripcion = 'Sucursal'
SELECT @Moneda = Valor FROM AspelCfg WHERE Descripcion = 'Moneda'
SELECT @Usuario = Valor FROM AspelCfg WHERE Descripcion = 'Usuario'
INSERT ArtLinea (Linea,Clave)
SELECT DISTINCT A.Linea, A.Linea from AspelCargaProp A
WHERE Campo = 'Articulo' AND A.Linea <> ''
and a.linea not in (select LINEA from artlinea)
IF NOT EXISTS(SELECT Categoria FROM ArtCat WHERE Categoria = @Observaciones)
INSERT INTO ArtCat (Categoria) VALUES (@Observaciones)
INSERT INTO Art (Articulo, Descripcion1, Impuesto1, Impuesto2, Impuesto3, Unidad, UnidadCompra, UnidadCantidad, TipoCosteo, Tipo, TipoOpcion, Accesorios,
Refacciones, Servicios, Consumibles, MonedaCosto, MonedaPrecio, PrecioLista, FactorAlterno, Estatus, EstatusPrecio, UltimoCambio,
Sustitutos, Alta, Refrigeracion, TieneCaducidad, wMostrar, Usuario, SeVende, SeCompra, SeProduce, EsFormula,
MultiplosOrdenar, RevisionUsuario, TieneMovimientos, EstatusCosto, SolicitarPrecios, Espacios, EspaciosEspecificos,
EspaciosNivel, EspaciosBloquearAnteriores, EspaciosMinutos, BasculaPesar, SerieLoteInfo, FactorCompra, ISAN, ExcluirDescFormaPago,
EsDeducible, TipoCatalogo, AnexosAlFacturar, Actividades, ValidarPresupuestoCompra, SeriesLotesAutoOrden, LotesFijos, LotesAuto,
TieneDireccion, PrecioLiberado, ValidarCodigo, CostoIdentificado, Impuesto1Excento, Linea, Proveedor,
TiempoEntrega, TiempoEntregaUnidad, Precio2, Precio3, Precio4, Precio5, Peso, Volumen, Categoria, Descripcion2, CostoEstandar, CodigoAlterno, AlmacenROP)
SELECT substring(Valor, 1, 20), Nombre, Impuesto1, Impuesto2, Impuesto3,CURP, Unidad, 1.0, substring(TipoCosteo, 1, 10), Tipo, Categoria, 0,
0, 0, 0, @Moneda, Rama, PrecioLista, 1.0, Estatus, 'NUEVO', GETDATE(),
0, GETDATE(), 0, 0, 1, substring(@Usuario, 1, 10), 1, 1, 0, 0,
1.0, substring(@Usuario, 1, 10), 0, 'SINCAMBIO', 0, 0, 0,
'Dia', 1, 60, 0, 0, 1.0, 0, 0,
0, 'Resurtible', 0, 0, 'No', '(Empresa)', 0, 0,
0, 0, 0, 0, 0, Linea, dbo.fnAspelJustificaClave(LTRIM(RTRIM(Proveedor))),
TiempoEntrega, TiempoEntregaU, Precio2, Precio3, Precio4, Precio5, ROUND(Peso, dbo.fnAspelDecimales(CONVERT(VARCHAR, PESO))), Volumen, @Observaciones,
substring(@Observaciones + ': ' + Descripcion2, 1, 100), Costo, substring(Descripcion, 1, 50), '(Demanda)'
FROM AspelCargaProp
WHERE Campo = 'Articulo' and VALOR not in (select articulo from art)
SELECT @Conta = COUNT(*) FROM Art
WHERE Articulo = 'FLETE'
IF @Conta = 0
INSERT INTO Art (Articulo, Descripcion1, Impuesto1, Unidad, UnidadCompra, UnidadCantidad, TipoCosteo, Tipo, TipoOpcion, Accesorios,
Refacciones, Servicios, Consumibles, MonedaCosto, MonedaPrecio, PrecioLista, FactorAlterno, Estatus, EstatusPrecio, UltimoCambio,
Sustitutos, Alta, Refrigeracion, TieneCaducidad, wMostrar, Usuario, SeVende, SeCompra, SeProduce, EsFormula,
MultiplosOrdenar, RevisionUsuario, TieneMovimientos, EstatusCosto, SolicitarPrecios, Espacios, EspaciosEspecificos,
EspaciosNivel, EspaciosBloquearAnteriores, EspaciosMinutos, BasculaPesar, SerieLoteInfo, FactorCompra, ISAN, ExcluirDescFormaPago,
EsDeducible, TipoCatalogo, AnexosAlFacturar, Actividades, ValidarPresupuestoCompra, SeriesLotesAutoOrden, LotesFijos, LotesAuto,
TieneDireccion, PrecioLiberado, ValidarCodigo, CostoIdentificado, Impuesto1Excento, Linea, Proveedor,
TiempoEntrega, TiempoEntregaUnidad, Precio2, Precio3, Precio4, Precio5, Peso, Volumen, Categoria, Observaciones, CostoEstandar, CodigoAlterno)
VALUES('FLETE', 'Fletes Aspel', 15, 'pz', 'pz', 1.0, 'Promedio', 'Normal', 'No', 0,
0, 0, 0, @Moneda, @Moneda, 0.0, 1.0, 'ALTA', 'NUEVO', GETDATE(),
0, GETDATE(), 0, 0, 1, @Usuario, 1, 1, 0, 0,
1.0, @Usuario, 0, 'SINCAMBIO', 0, 0, 0,
'Dia', 1, 60, 0, 0, 1.0, 0, 0,
0, 'Resurtible', 0, 0, 'No', '(Empresa)', 0, 0,
0, 0, 0, 0, 0, '', '',
0, 'Dias', 0.0, 0.0, 0.0, 0.0, 0, 0, @Observaciones, @Observaciones, 0.0, '')
SELECT @Conta = COUNT(*) FROM Art
WHERE Articulo = 'INDIRECTOS'
IF @Conta = 0
INSERT INTO Art (Articulo, Descripcion1, Impuesto1, Unidad, UnidadCompra, UnidadCantidad, TipoCosteo, Tipo, TipoOpcion, Accesorios,
Refacciones, Servicios, Consumibles, MonedaCosto, MonedaPrecio, PrecioLista, FactorAlterno, Estatus, EstatusPrecio, UltimoCambio,
Sustitutos, Alta, Refrigeracion, TieneCaducidad, wMostrar, Usuario, SeVende, SeCompra, SeProduce, EsFormula,
MultiplosOrdenar, RevisionUsuario, TieneMovimientos, EstatusCosto, SolicitarPrecios, Espacios, EspaciosEspecificos,
EspaciosNivel, EspaciosBloquearAnteriores, EspaciosMinutos, BasculaPesar, SerieLoteInfo, FactorCompra, ISAN, ExcluirDescFormaPago,
EsDeducible, TipoCatalogo, AnexosAlFacturar, Actividades, ValidarPresupuestoCompra, SeriesLotesAutoOrden, LotesFijos, LotesAuto,
TieneDireccion, PrecioLiberado, ValidarCodigo, CostoIdentificado, Impuesto1Excento, Linea, Proveedor,
TiempoEntrega, TiempoEntregaUnidad, Precio2, Precio3, Precio4, Precio5, Peso, Volumen, Categoria, Observaciones, CostoEstandar, CodigoAlterno)
VALUES('INDIRECTOS', 'Gastos Indirectos Aspel', 15, 'pz', 'pz', 1.0, 'Promedio', 'Normal', 'No', 0,
0, 0, 0, @Moneda, @Moneda, 0.0, 1.0, 'ALTA', 'NUEVO', GETDATE(),
0, GETDATE(), 0, 0, 1, @Usuario, 1, 1, 0, 0,
1.0, @Usuario, 0, 'SINCAMBIO', 0, 0, 0,
'Dia', 1, 60, 0, 0, 1.0, 0, 0,
0, 'Resurtible', 0, 0, 'No', '(Empresa)', 0, 0,
0, 0, 0, 0, 0, '', '',
0, 'Dias', 0.0, 0.0, 0.0, 0.0, 0, 0, @Observaciones, @Observaciones, 0.0, '')
END

