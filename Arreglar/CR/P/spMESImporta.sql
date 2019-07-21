SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spMESImporta
@Empresa        varchar(5),
@Usuario        varchar(10),
@Sucursal       int

AS
BEGIN
DECLARE
@IDCompra         int,
@ID               int,
@MovCompra        varchar(20),
@Serie            varchar(20),
@Numero           varchar(20),
@SucursalMov      int,
@Proveedor        varchar(10),
@Cliente		  varchar(10),
@ZonaImpuesto     varchar(30),
@FechaRequerida   datetime,
@Condicion        varchar(50),
@Concepto         varchar(50),
@Estatus          varchar(15),
@Articulo         varchar(20),
@SubCuenta        varchar(50),
@Almacen          varchar(10),
@AlmacenArt       varchar(10),
@FechaRequeridaD  datetime,
@FechaEntrega     datetime,
@Cantidad         float,
@CantidadInventario float,
@Costo            float,
@CosteMaquinaria  money,
@CosteMaterial    money,
@CosteIndirecto   money,
@CosteOperarios   money,
@PorcIVA          float,
@Unidad           varchar(50),
@CfgMultiUnidades		bit,
@CfgMultiUnidadesNivel		varchar(20),
@ArtTipo            varchar(20),
@Renglon            float,
@RenglonID          int,
@RenglonTipo        varchar(1),
@Lanzamiento        varchar(100),
@OrdenProduccion    varchar(100),
@IDInv            int,
@MovInvE          varchar(20),
@MovInvS          varchar(20),
@Lote             varchar(20),
@FechaEmision     datetime,
@Referencia       varchar(50),
@Moneda           varchar(10),
@TipoCambio       float,
@Propiedades      varchar(20),
@Proyecto         varchar(50),
@SubProyecto      varchar(50),
@Origen			      varchar(20),
@OrigenID         varchar(20),
@IDOport          int,
@Mensaje          varchar(255),
@CostoInv         money,
@Ok               int,
@OkRef            varchar(255),
/*  jsmv contuso 1 y 2 */
@ContUso	        varchar(20),
@ContUso2         varchar(20),
@IDReserva		    int,
@RenglonReserva	  float
CREATE TABLE #MesCompra(
ID               int,
Serie            varchar(20)  NULL,
Numero           varchar(20)  NULL,
Proveedor        varchar(10)  NULL,
FechaEmision     datetime     NULL,
FechaRequerida   datetime     NULL,
Referencia       varchar(50)  NULL,
Condicion        varchar(50)  NULL,
Concepto         varchar(50)  NULL,
Moneda           varchar(10)  NULL,
Estatus          varchar(15)  NULL,
Sucursal         int          NULL,
Renglon          float        NULL,
Articulo         varchar(20)  NULL,
SubCuenta        varchar(50)  NULL,
Almacen          varchar(10)  NULL,
AlmacenArt       varchar(10)  NULL,
FechaRequeridaD  datetime     NULL,
FechaEntrega     datetime     NULL,
Cantidad         float        NULL,
Costo            float        NULL,
PorcIVA          float        NULL,
Unidad           varchar(50)  NULL,
Lanzamiento      varchar(100) NULL,
OrdenProduccion  varchar(100) NULL,
Proyecto         varchar(50)  NULL,
SubProyecto      varchar(50)  NULL)
SELECT @MovCompra = CompraOrden FROM EmpresaCfgMov ecm WHERE ecm.Empresa = @Empresa
SELECT @CfgMultiUnidades         = MultiUnidades,
@CfgMultiUnidadesNivel    = ISNULL(UPPER(NivelFactorMultiUnidad), 'UNIDAD')
FROM EmpresaCfg2
WHERE Empresa = @Empresa
INSERT INTO #MesCompra
(ID,    Serie,    Numero,            Proveedor,    FechaEmision,    FechaRequerida,    Referencia,    Condicion, Moneda,                             Sucursal,    Renglon,    Articulo,    SubCuenta,    Almacen,   AlmacenArt,    FechaRequeridaD, FechaEntrega,       Cantidad,   Costo,                              PorcIVA,    Unidad,         Lanzamiento,    OrdenProduccion,    Proyecto)
SELECT cm.ID, cm.Serie, cm.NumerodePedido, cm.Proveedor, cm.FechaEmision, cm.FechaRequerida, cm.Referencia, cm.Condicion, ISNULL(mm.Descripcion, 'Pesos'), cm.Sucursal, cd.Renglon, cd.Articulo, cd.SubCuenta, cd.Almacen, a.AlmMesComs, cd.FechaEntrega, cd.FechaRequerida, cd.Cantidad, ISNULL(acs.UltimoCosto, cd.Precio), cd.PorcIVA, um.Descripcion, cd.Lanzamiento, cd.OrdenProduccion, cm.Proyecto
FROM CompraMES cm
JOIN CompraDMES cd ON cm.Lanzamiento = cd.Lanzamiento AND cd.NumerodePedido = cm.NumerodePedido
JOIN Art a ON cd.Articulo = a.Articulo
LEFT OUTER JOIN MonMES mm ON cm.Moneda = mm.Moneda
LEFT OUTER JOIN UnidadMes um ON cd.UnidadPedida = um.UnidadMedida
LEFT OUTER JOIN ArtCostoSucursal acs ON acs.Empresa = @Empresa AND acs.Sucursal = ISNULL(cm.Sucursal, 0) AND acs.Articulo = cd.Articulo
WHERE ISNULL(cm.ModuloID, 0) = 0
AND ISNULL(a.AlmMesComs, '') <> ''
AND ISNULL(cm.EstatusIntelIMES, 0) = 0
DECLARE crMesCompra CURSOR FOR
SELECT mc.Serie, mc.Numero, mc.Lanzamiento, mc.Proveedor, mc.Moneda, mc.Almacen, mc.AlmacenArt
FROM #MesCompra mc
JOIN Art a ON mc.Articulo = a.Articulo AND (a.TipoArticulo <> '3')
GROUP BY mc.Serie, mc.Numero, mc.Lanzamiento, mc.Proveedor, mc.Moneda, mc.Almacen, mc.AlmacenArt
OPEN crMesCompra
FETCH NEXT FROM crMesCompra INTO @Serie, @Numero, @Lanzamiento, @Proveedor, @Moneda, @Almacen, @AlmacenArt
WHILE @@FETCH_STATUS = 0
BEGIN
/*  jsmv lee contuso de venta referente a Lanzamiento  LEE EL PRIMERO YA QUE LOS PEDIDOS SON POR SILLAS MUEBLES */
SELECT  @ContUso = NULL, @ContUso2 = NULL
SELECT	TOP 1 @ContUso = ContUso, @ContUso2 = ContUso2
FROM	VentaDMES
WHERE	Lanzamiento = @Lanzamiento
SELECT @IDCompra = NULL
SELECT @TipoCambio = m.TipoCambio FROM Mon m WHERE m.Moneda = @Moneda
SELECT @ZonaImpuesto = p.ZonaImpuesto FROM Prov p WHERE p.Proveedor = @Proveedor
INSERT INTO Compra(Empresa, Mov, FechaEmision, Moneda, TipoCambio, Usuario, Referencia, Observaciones,                          Estatus, Proveedor, Almacen, Condicion, OrigenTipo, Sucursal, ZonaImpuesto, MesLanzamiento)
SELECT TOP 1 @Empresa, @MovCompra, FechaEmision, Moneda, @TipoCambio, @Usuario, @Lanzamiento, RTRIM(@Serie) + ' ' + RTRIM(@Numero), 'CONFIRMAR', mc.Proveedor, @AlmacenArt, Condicion, 'MES', Sucursal, @ZonaImpuesto, @Lanzamiento
FROM #MesCompra mc
JOIN Art a ON mc.Articulo = a.Articulo AND a.TipoArticulo <> '3'
WHERE Serie = @Serie AND Numero = @Numero AND Lanzamiento = @Lanzamiento AND mc.Proveedor = @Proveedor AND mc.Almacen = @Almacen
SELECT @IDCompra = @@IDENTITY
IF @IDCompra IS NOT NULL
BEGIN
DECLARE crMesCompraD CURSOR FOR
SELECT mc.Renglon, mc.Articulo, mc.SubCuenta, mc.FechaRequeridaD, mc.FechaEntrega, mc.Cantidad, mc.Costo, mc.PorcIVA, mc.Unidad, a.Tipo, mc.Lanzamiento, mc.OrdenProduccion
FROM #MesCompra mc
JOIN Art a ON mc.Articulo = a.Articulo AND a.TipoArticulo <> '3'
WHERE mc.Serie = @Serie AND mc.Numero = @Numero AND mc.Lanzamiento = @Lanzamiento AND mc.Proveedor = @Proveedor AND Almacen = @Almacen
OPEN crMesCompraD
FETCH NEXT FROM crMesCompraD INTO @Renglon, @Articulo, @SubCuenta, @FechaRequeridaD, @FechaEntrega, @Cantidad, @Costo, @PorcIVA, @Unidad, @ArtTipo, @Lanzamiento, @OrdenProduccion
WHILE @@FETCH_STATUS = 0
BEGIN
EXEC spZonaImp @ZonaImpuesto, @PorcIVA OUTPUT
SELECT @Costo = (@Costo/@TipoCambio)*dbo.fnArtUnidadFactor(@Empresa, @Articulo, @Unidad)
EXEC spRenglonTipo @ArtTipo, NULL, @RenglonTipo OUTPUT
SELECT @RenglonID = @Renglon
EXEC xpCantidadInventario @Articulo, NULL, @Unidad, @CfgMultiUnidades, @CfgMultiUnidadesNivel, @Cantidad, @CantidadInventario OUTPUT
INSERT INTO CompraD
(ID,        Renglon, RenglonSub, RenglonID,  RenglonTipo,  Cantidad,  CantidadInventario,  Almacen,     Articulo,  SubCuenta,  FechaRequerida,   FechaEntrega,  Costo,  Impuesto1, Unidad, ReferenciaExtra, DescripcionExtra, ContUso, ContUso2, MesLanzamiento)
VALUES(@IDCompra, @Renglon, 0,         @RenglonID, @RenglonTipo, @Cantidad, @CantidadInventario, @AlmacenArt, @Articulo, @SubCuenta, @FechaRequeridaD, @FechaEntrega, @Costo, @PorcIVA, @Unidad, @Lanzamiento, @OrdenProduccion, @ContUso, @ContUso2, @Lanzamiento)
FETCH NEXT FROM crMesCompraD INTO @Renglon, @Articulo, @SubCuenta, @FechaRequeridaD, @FechaEntrega, @Cantidad, @Costo, @PorcIVA, @Unidad, @ArtTipo, @Lanzamiento, @OrdenProduccion
END
CLOSE crMesCompraD
DEALLOCATE crMesCompraD
END
UPDATE CompraMes SET EstatusIntelIMES = 1, ModuloID = @IDCompra
WHERE Serie = @Serie AND NumerodePedido = @Numero AND Lanzamiento = @Lanzamiento AND Proveedor = @Proveedor
UPDATE CompraDMes SET CantidadPendiente = Cantidad, ModuloID = @IDCompra, EstatusIntelIMES = 1
WHERE Serie = @Serie AND NumerodePedido = @Numero AND Lanzamiento = @Lanzamiento AND Almacen = @Almacen
FETCH NEXT FROM crMesCompra INTO @Serie, @Numero, @Lanzamiento, @Proveedor, @Moneda, @Almacen, @AlmacenArt
END
CLOSE crMesCompra
DEALLOCATE crMesCompra
DECLARE crMesCompra CURSOR FOR
SELECT mc.Serie, mc.Numero, mc.Lanzamiento, mc.Proveedor, mc.Moneda, mc.Almacen, mc.AlmacenArt
FROM #MesCompra mc
JOIN Art a ON mc.Articulo = a.Articulo AND a.TipoArticulo = '3'
GROUP BY mc.Serie, mc.Numero, mc.Lanzamiento, mc.Proveedor, mc.Moneda, mc.Almacen, mc.AlmacenArt
OPEN crMesCompra
FETCH NEXT FROM crMesCompra INTO @Serie, @Numero, @Lanzamiento, @Proveedor, @Moneda, @Almacen, @AlmacenArt
WHILE @@FETCH_STATUS = 0
BEGIN
/*  jsmv lee contuso de venta referente a Lanzamiento  LEE EL PRIMERO YA QUE LOS PEDIDOS SON POR SILLAS MUEBLES */
SELECT  @ContUso = NULL, @ContUso2 = NULL
SELECT	TOP 1 @ContUso = ContUso, @ContUso2 = ContUso2
FROM	VentaDMES
WHERE	Lanzamiento = @Lanzamiento
SELECT @IDCompra = NULL
SELECT @TipoCambio = m.TipoCambio FROM Mon m WHERE m.Moneda = @Moneda
SELECT @ZonaImpuesto = p.ZonaImpuesto FROM Prov p WHERE p.Proveedor = @Proveedor
INSERT INTO Compra(Empresa, Mov, FechaEmision, Moneda, TipoCambio, Usuario, Concepto, Referencia, Observaciones,                          Estatus, Proveedor, Almacen, Condicion, OrigenTipo, Sucursal, ZonaImpuesto, MesLanzamiento)
SELECT TOP 1 @Empresa, 'Orden Compra', mc.FechaEmision, mc.Moneda, @TipoCambio, @Usuario, 'Maquila Proveedor', mc.Lanzamiento, RTRIM(@Serie) + ' ' + RTRIM(@Numero), 'CONFIRMAR', mc.Proveedor, @AlmacenArt, mc.Condicion, 'MES', mc.Sucursal, @ZonaImpuesto, @Lanzamiento
FROM #MesCompra mc
JOIN Art a ON mc.Articulo = a.Articulo AND a.TipoArticulo = '3'
WHERE Serie = @Serie AND Numero = @Numero AND Lanzamiento = @Lanzamiento AND mc.Proveedor = @Proveedor AND a.AlmMesComs = @AlmacenArt
SELECT @IDCompra = @@IDENTITY
IF @IDCompra IS NOT NULL
BEGIN
DECLARE crMesCompraD CURSOR FOR
SELECT mc.Renglon, mc.Articulo, mc.SubCuenta, mc.FechaRequeridaD, mc.FechaEntrega, mc.Cantidad, ISNULL(ap.CostoAutorizado, mc.Costo), ISNULL(a.CostoEstandar, 0) + ISNULL(ap.CostoAutorizado, mc.Costo), mc.PorcIVA, mc.Unidad, a.Tipo, mc.Lanzamiento, mc.OrdenProduccion
FROM #MesCompra mc
JOIN Art a ON mc.Articulo = a.Articulo AND a.TipoArticulo = '3'
LEFT OUTER JOIN ArtProv ap ON ap.Articulo = a.Articulo AND ap.Proveedor = @Proveedor
WHERE mc.Serie = @Serie AND mc.Numero = @Numero AND mc.Lanzamiento = @Lanzamiento AND mc.Proveedor = @Proveedor AND a.AlmMesComs = @AlmacenArt
OPEN crMesCompraD
FETCH NEXT FROM crMesCompraD INTO @Renglon, @Articulo, @SubCuenta, @FechaRequeridaD, @FechaEntrega, @Cantidad, @Costo, @CostoInv, @PorcIVA, @Unidad, @ArtTipo, @Lanzamiento, @OrdenProduccion
WHILE @@FETCH_STATUS = 0
BEGIN
EXEC spZonaImp @ZonaImpuesto, @PorcIVA OUTPUT
SELECT @Costo = (@Costo/@TipoCambio)*dbo.fnArtUnidadFactor(@Empresa, @Articulo, @Unidad)
EXEC spRenglonTipo @ArtTipo, NULL, @RenglonTipo OUTPUT
SELECT @RenglonID = @Renglon
EXEC xpCantidadInventario @Articulo, NULL, @Unidad, @CfgMultiUnidades, @CfgMultiUnidadesNivel, @Cantidad, @CantidadInventario OUTPUT
INSERT INTO CompraD
(ID,        Renglon, RenglonSub, RenglonID,  RenglonTipo,  Cantidad,  CantidadInventario,  Almacen,     Articulo,  SubCuenta,  FechaRequerida,   FechaEntrega,  Costo,  CostoInv, Impuesto1, Unidad, ReferenciaExtra, DescripcionExtra, ContUso, ContUso2, MesLanzamiento)
VALUES(@IDCompra, @Renglon, 0,         @RenglonID, @RenglonTipo, @Cantidad, @CantidadInventario, @AlmacenArt, @Articulo, @SubCuenta, @FechaRequeridaD, @FechaEntrega, @Costo, @CostoInv, @PorcIVA, @Unidad, @Lanzamiento, @OrdenProduccion, @ContUso, @ContUso2, @Lanzamiento)
FETCH NEXT FROM crMesCompraD INTO @Renglon, @Articulo, @SubCuenta, @FechaRequeridaD, @FechaEntrega, @Cantidad, @Costo, @CostoInv, @PorcIVA, @Unidad, @ArtTipo, @Lanzamiento, @OrdenProduccion
END
CLOSE crMesCompraD
DEALLOCATE crMesCompraD
END
UPDATE CompraMes SET EstatusIntelIMES = 1, ModuloID = @IDCompra
WHERE Serie = @Serie AND NumerodePedido = @Numero AND Lanzamiento = @Lanzamiento AND Proveedor = @Proveedor
UPDATE CompraDMes SET CantidadPendiente = Cantidad, ModuloID = @IDCompra
FROM Art a
WHERE Serie = @Serie AND NumerodePedido = @Numero AND Lanzamiento = @Lanzamiento 
AND CompraDMes.Articulo = a.Articulo AND a.TipoArticulo = '3' AND a.AlmMesComs = @AlmacenArt
FETCH NEXT FROM crMesCompra INTO @Serie, @Numero, @Lanzamiento, @Proveedor, @Moneda, @Almacen, @AlmacenArt
END
CLOSE crMesCompra
DEALLOCATE crMesCompra
CREATE TABLE #MesInv(
ID               int,
Cliente			varchar(10),
OrdenProduccion  varchar(100) NULL,
Almacen          varchar(10)  NULL,
Articulo         varchar(20)  NULL,
SubCuenta        varchar(50)  NULL,
Cantidad         float        NULL,
Lanzamiento      varchar(50)  NULL,
Lote             varchar(20)  NULL,
Moneda           varchar(10)  NULL,
Unidad           varchar(50)  NULL,
Costo            money        NULL,
CosteMaquinaria  money        NULL,
CosteMaterial    money        NULL,
CosteIndirecto   money        NULL,
CosteOperarios   money        NULL,
FechaRequerida   datetime     NULL,
Proyecto         varchar(50)  NULL,
SubProyecto      varchar(50)  NULL)
IF NOT EXISTS(SELECT mt.Clave FROM MovTipo mt WHERE mt.Modulo = 'INV' AND mt.Mov = 'Entrada Produccion')
INSERT INTO MovTipo
(Modulo, Mov,                 Orden, Clave, SubClave, ConsecutivoModulo, ConsecutivoMov,       Factor)
VALUES('INV', 'Entrada Produccion', 2000, 'INV.E', NULL,    'INV',             'Entrada Produccion', 1     )
IF NOT EXISTS(SELECT mt.Clave FROM MovTipo mt WHERE mt.Modulo = 'INV' AND mt.Mov = 'Consumo Produccion')
INSERT INTO MovTipo
(Modulo, Mov,                 Orden, Clave, SubClave, ConsecutivoModulo, ConsecutivoMov,       Factor)
VALUES('INV', 'Consumo Produccion', 2010, 'INV.S', NULL,    'INV',             'Consumo Produccion', 1     )
IF NOT EXISTS(SELECT mt.Clave FROM MovTipo mt WHERE mt.Modulo = 'COMS' AND mt.Mov = 'EntradaCompraMaquila')
INSERT INTO MovTipo
(Modulo, Mov,                 Orden, Clave, SubClave, ConsecutivoModulo, ConsecutivoMov,       Factor)
VALUES('COMS', 'EntradaCompraMaquila', 50, 'COMS.EG', NULL,    'CXP',             'EntradaCompraMaquila', 1     )
IF NOT EXISTS(SELECT mt.Clave FROM MovTipo mt WHERE mt.Modulo = 'CXP' AND mt.Mov = 'EntradaCompraMaquila')
INSERT INTO MovTipo
(Modulo, Mov,                 Orden, Clave, SubClave, ConsecutivoModulo, ConsecutivoMov,       Factor)
VALUES('CXP', 'EntradaCompraMaquila', 50, 'CXP.F', NULL,    'CXP',             'EntradaCompraMaquila', 1     )
/*
IF NOT EXISTS(SELECT mt.Clave FROM MovTipo mt WHERE mt.Modulo = 'COMS' AND mt.Mov = 'Servicio Maquila')
INSERT INTO MovTipo
(Modulo, Mov,                 Orden, Clave, SubClave, ConsecutivoModulo, ConsecutivoMov,       Factor)
VALUES('COMS', 'Servicio Maquila', 40, 'COMS.O', NULL,    'COMS',             'Servicio Maquila', 1     )
IF NOT EXISTS(SELECT mt.Clave FROM MovTipo mt WHERE mt.Modulo = 'COMS' AND mt.Mov = 'Recibo Maquila')
INSERT INTO MovTipo
(Modulo, Mov,                 Orden, Clave, SubClave, ConsecutivoModulo, ConsecutivoMov,       Factor)
VALUES('COMS', 'Recibo Maquila', 50, 'COMS.CP', NULL,    'COMS',             'Recibo Maquila', 1     )
*/
/*
SELECT @MovInvE = ecm.InvEntradaDiversa,
@MovInvS = ecm.InvSalidaDiversa
FROM EmpresaCfgMov ecm
WHERE ecm.Empresa = @Empresa
*/
SELECT @MovInvE = 'Entrada Produccion'
SELECT @MovInvS = 'Consumo Produccion'
SELECT @FechaEmision = GETDATE()
EXEC spExtraerFecha @FechaEmision OUTPUT
SELECT @CfgMultiUnidades         = MultiUnidades,
@CfgMultiUnidadesNivel    = ISNULL(UPPER(NivelFactorMultiUnidad), 'UNIDAD')
FROM EmpresaCfg2
WHERE Empresa = @Empresa
INSERT INTO #MesInv
(ID, Almacen, Articulo, SubCuenta, Cantidad, Lanzamiento, Lote, Moneda, Unidad, Costo, CosteMaquinaria, CosteMaterial, CosteIndirecto, CosteOperarios, OrdenProduccion, Proyecto, SubProyecto,Cliente)
SELECT mm.ID, mm.Almacen, mm.Articulo, mm.SubCuenta, mm.Cantidad, mm.Lanzamiento, mm.Lote, ISNULL(m.Descripcion, 'Pesos'), um.Descripcion,
((ISNULL(mm.CosteOperarios, 0) + ISNULL(mm.CosteMaterial, 0) + ISNULL(mm.CosteIndirecto, 0) + ISNULL(mm.CosteMaquinaria, 0))/mm.cantidad),
CosteMaquinaria, CosteMaterial, CosteIndirecto, CosteOperarios,
mm.OrdenProduccion, mm.Proyecto, mm.SubProyecto, '1'
FROM MovMES mm
LEFT OUTER JOIN MonMES m ON mm.Moneda = m.Moneda
LEFT OUTER JOIN UnidadMes um ON mm.Unidad = um.UnidadMedida
WHERE mm.ProcesadoINTELISIS = 0
AND mm.Direccion = 'E'
/*
SELECT mm.ID, mm.Almacen, mm.Articulo, mm.SubCuenta, mm.Cantidad, mm.Lanzamiento, mm.Lote, ISNULL(m.Descripcion, 'Pesos'), um.Descripcion,
/*   ISNULL(mm.PrecioCosteMedio, 0)*/
ISNULL(mm.CosteOperarios, 0) + ISNULL(mm.CosteMaterial, 0) + ISNULL(mm.CosteIndirecto, 0) + ISNULL(mm.CosteMaquinaria, 0),
mm.OrdenProduccion, mm.Proyecto, mm.SubProyecto, '1'
FROM MovMES mm
LEFT OUTER JOIN MonMES m ON mm.Moneda = m.Moneda
LEFT OUTER JOIN UnidadMes um ON mm.Unidad = um.UnidadMedida
WHERE mm.ProcesadoINTELISIS = 0
AND mm.Direccion = 'E'
*/
DECLARE crMesInv CURSOR FOR
SELECT mi.Almacen, mi.Moneda, RTRIM(mi.Lanzamiento), mi.Proyecto
FROM #MesInv mi
GROUP BY mi.Almacen, mi.Moneda, RTRIM(mi.Lanzamiento), mi.Proyecto
OPEN crMesInv
FETCH NEXT FROM crMesInv INTO @Almacen, @Moneda, @Referencia, @Proyecto
WHILE @@FETCH_STATUS = 0 AND @Ok IS NULL
BEGIN
SELECT @IDInv = NULL
SELECT @TipoCambio = m.TipoCambio FROM Mon m WHERE m.Moneda = @Moneda
INSERT INTO Inv(Empresa, Mov, FechaEmision, Referencia, Moneda, TipoCambio, Usuario, Estatus, Almacen, OrigenTipo, Sucursal, Proyecto, MesLanzamiento)
VALUES(@Empresa, @MovInvE, @FechaEmision, @Referencia, @Moneda, @TipoCambio, @Usuario, 'SINAFECTAR', @Almacen, 'MES', @Sucursal, @Proyecto, @Referencia)
SELECT @IDInv = @@IDENTITY
SELECT @Renglon = 0, @RenglonID = 0
IF @IDInv IS NOT NULL
BEGIN
DECLARE crMesInvD CURSOR FOR
SELECT mi.ID, mi.Articulo, mi.SubCuenta, mi.Cantidad, mi.Lote, mi.Unidad, mi.Costo, mi.CosteMaquinaria,
mi.CosteMaterial, mi.CosteIndirecto, mi.CosteOperarios, a.Tipo, mi.OrdenProduccion
FROM #MesInv mi
JOIN Art a ON mi.Articulo = a.Articulo
WHERE mi.Almacen = @Almacen
AND mi.Moneda = @Moneda
AND mi.Lanzamiento = @Referencia
AND mi.Proyecto = @Proyecto
OPEN crMesInvD
FETCH NEXT FROM crMesInvD INTO @ID, @Articulo, @SubCuenta, @Cantidad, @Lote, @Unidad, @Costo, @CosteMaquinaria, @CosteMaterial, @CosteIndirecto, @CosteOperarios, @ArtTipo, @OrdenProduccion
WHILE @@FETCH_STATUS = 0 AND @Ok IS NULL
BEGIN
SELECT @Costo = (@Costo/@TipoCambio)*dbo.fnArtUnidadFactor(@Empresa, @Articulo, @Unidad)
EXEC spRenglonTipo @ArtTipo, NULL, @RenglonTipo OUTPUT
SELECT @Renglon = @Renglon + 1048, @RenglonID = @RenglonID + 1
EXEC xpCantidadInventario @Articulo, NULL, @Unidad, @CfgMultiUnidades, @CfgMultiUnidadesNivel, @Cantidad, @CantidadInventario OUTPUT
/*  jsmv Actualizar InvD en Espacios id de MovMes / prodserielote = lote de MES */
INSERT INTO InvD
(ID,     Renglon, RenglonSub, RenglonID,  RenglonTipo,  Cantidad,  CantidadInventario,  Almacen,  Articulo,  SubCuenta,  Costo, Unidad, Espacio, ProdSerieLote, MesLanzamiento, MesProdCostoMaquinaria, MesProdCostoConsumoMat, MesProdCostoIndirecto, MesProdCostoManoObra)
VALUES(@IDInv, @Renglon, 0,         @RenglonID, @RenglonTipo, @Cantidad, @CantidadInventario, @Almacen, @Articulo, @SubCuenta, @Costo, @Unidad, CAST(@id as VARCHAR), @Lote, @Referencia, @CosteMaquinaria, @CosteMaterial, @CosteIndirecto, @CosteOperarios)
SELECT @IDReserva = NULL,  @RenglonReserva = NULL
SELECT TOP 1 @IDReserva  = vdm.ID,  @RenglonReserva = vdm.Renglon
FROM	VentaMES vm
INNER JOIN VentaDMES vdm ON vdm.id = vm.ID
WHERE	vdm.Lanzamiento	= @Referencia AND vdm.Articulo	= @Articulo
/*
IF @IDReserva > 0  and @RenglonReserva > 0
BEGIN
UPDATE  Venta
SET     Situacion = 'Autorizado'
WHERE   ID = @IDReserva
UPDATE VentaD SET	Espacio = CAST(@IDReserva as varchar), CantidadA = @Cantidad , CantidadOrdenada = null, CantidadPendiente = @Cantidad
WHERE ID = @IDReserva AND Renglon = @RenglonReserva
EXEC spAfectar 'VTAS', @IDReserva, 'RESERVAR', 'Seleccion', null, @Usuario  
UPDATE  Venta
SET     Situacion = 'Autorizado x Cobranza'
WHERE   ID = @IDReserva
END
*/
IF @RenglonTipo = 'L'
BEGIN
SELECT @Propiedades = RTRIM(YEAR(@FechaEmision)) + '-' + RTRIM(MONTH(@FechaEmision)) + '-' + RTRIM(DAY(@FechaEmision))
IF NOT EXISTS(SELECT * FROM SerieLoteProp slp WHERE slp.Propiedades = @Propiedades)
INSERT INTO SerieLoteProp(Propiedades, Extra1, Extra2, Fecha1)
VALUES(@Propiedades, @Lote, @OrdenProduccion, @FechaEmision)
INSERT INTO SerieLoteMov(Empresa, Modulo, ID, RenglonID, Articulo, SubCuenta, SerieLote, Cantidad, Propiedades)
VALUES(@Empresa, 'INV', @IDInv, @RenglonID, @Articulo, ISNULL(@SubCuenta, ''), @Lote, @Cantidad, @Propiedades)
END
UPDATE MovMES SET ProcesadoINTELISIS = 1 WHERE ID = @ID
FETCH NEXT FROM crMesInvD INTO @ID, @Articulo, @SubCuenta, @Cantidad, @Lote, @Unidad, @Costo, @CosteMaquinaria, @CosteMaterial, @CosteIndirecto, @CosteOperarios, @ArtTipo, @OrdenProduccion
END
CLOSE crMesInvD
DEALLOCATE crMesInvD
EXEC spAfectar 'INV', @IDInv, 'AFECTAR', NULL, NULL, @Usuario, 0, 1, @Ok OUTPUT, @OkRef OUTPUT, NULL, 0
END
FETCH NEXT FROM crMesInv INTO @Almacen, @Moneda, @Referencia, @Proyecto
END
CLOSE crMesInv
DEALLOCATE crMesInv
DELETE FROM #MesInv
INSERT INTO #MesInv
(ID, Almacen, Articulo, SubCuenta, Cantidad, Lanzamiento, Lote, Moneda, Unidad, Proyecto,Cliente)
SELECT mm.ID, mm.Almacen, mm.Articulo, mm.SubCuenta, mm.Cantidad, mm.Lanzamiento, mm.Lote, ISNULL(m.Descripcion, 'Pesos'), um.Descripcion, mm.Proyecto,'1'
FROM MovMES mm
LEFT OUTER JOIN MonMES m ON mm.Moneda = m.Moneda
LEFT OUTER JOIN UnidadMes um ON mm.Unidad = um.UnidadMedida
WHERE mm.ProcesadoINTELISIS = 0
AND mm.Direccion = 'S'
DECLARE crMesInv CURSOR FOR
SELECT mi.Almacen, mi.Moneda, RTRIM(mi.Lanzamiento), mi.Proyecto
FROM #MesInv mi
GROUP BY mi.Almacen, mi.Moneda, RTRIM(mi.Lanzamiento), mi.Proyecto
OPEN crMesInv
FETCH NEXT FROM crMesInv INTO @Almacen, @Moneda, @Referencia, @Proyecto
WHILE @@FETCH_STATUS = 0 AND @Ok IS NULL
BEGIN
SELECT @IDInv = NULL
SELECT @TipoCambio = m.TipoCambio FROM Mon m WHERE m.Moneda = 'Pesos'
INSERT INTO Inv(Empresa, Mov, FechaEmision, Referencia, Moneda, TipoCambio, Usuario, Estatus, Almacen, OrigenTipo, Sucursal, Proyecto, MesLanzamiento)
VALUES(@Empresa, @MovInvS, @FechaEmision, @Referencia, @Moneda, @TipoCambio, @Usuario, 'SINAFECTAR', @Almacen, 'MES', @Sucursal, @Proyecto, @Referencia)
SELECT @IDInv = @@IDENTITY
SELECT @Renglon = 0, @RenglonID = 0
IF @IDInv IS NOT NULL
BEGIN
DECLARE crMesInvD CURSOR FOR
SELECT mi.ID, mi.Articulo, mi.SubCuenta, mi.Cantidad, mi.Lote, mi.Unidad, mi.Costo, a.Tipo
FROM #MesInv mi
JOIN Art a ON mi.Articulo = a.Articulo
WHERE mi.Almacen = @Almacen
AND mi.Moneda = @Moneda
AND RTRIM(mi.Lanzamiento) = @Referencia
AND mi.Proyecto = @Proyecto
OPEN crMesInvD
FETCH NEXT FROM crMesInvD INTO @ID, @Articulo, @SubCuenta, @Cantidad, @Lote, @Unidad, @Costo, @ArtTipo
WHILE @@FETCH_STATUS = 0 AND @Ok IS NULL
BEGIN
EXEC spRenglonTipo @ArtTipo, NULL, @RenglonTipo OUTPUT
SELECT @Renglon = @Renglon + 1048, @RenglonID = @RenglonID + 1
EXEC xpCantidadInventario @Articulo, NULL, @Unidad, @CfgMultiUnidades, @CfgMultiUnidadesNivel, @Cantidad, @CantidadInventario OUTPUT
INSERT INTO InvD
(ID,     Renglon, RenglonSub, RenglonID,  RenglonTipo,  Cantidad,  Almacen,  Articulo, SubCuenta,  Costo, Unidad, MesLanzamiento)
VALUES(@IDInv, @Renglon, 0,         @RenglonID, @RenglonTipo, @Cantidad, @Almacen, @Articulo, @SubCuenta, @Costo, @Unidad, @Referencia)
IF @RenglonTipo = 'L'
INSERT INTO SerieLoteMov(Empresa, Modulo, ID, RenglonID, Articulo, SubCuenta, SerieLote, Cantidad)
VALUES(@Empresa, 'INV', @IDInv, @RenglonID, @Articulo, @SubCuenta, @Lote, @Cantidad)
UPDATE MovMES SET ProcesadoINTELISIS = 1 WHERE ID = @ID
FETCH NEXT FROM crMesInvD INTO @ID, @Articulo, @SubCuenta, @Cantidad, @Lote, @Unidad, @Costo, @ArtTipo
END
CLOSE crMesInvD
DEALLOCATE crMesInvD
EXEC spAfectar 'INV', @IDInv, 'AFECTAR', NULL, NULL, @Usuario, 0, 1, @Ok OUTPUT, @OkRef OUTPUT, NULL, 0
END
FETCH NEXT FROM crMesInv INTO @Almacen, @Moneda, @Referencia, @Proyecto
END
CLOSE crMesInv
DEALLOCATE crMesInv
DELETE FROM #MesInv
INSERT INTO #MesInv
(ID,    Cliente,  Almacen,          Articulo,    SubCuenta,    Cantidad,          Lanzamiento, Lote,           Moneda,							      Unidad,			  Costo,                FechaRequerida,           Proyecto,     SubProyecto)
SELECT cm.ID, cm.Cliente, cd.AlmacenSalida, cd.Articulo, cd.SubCuenta, cd.CantidadPedida, cd.Lanzamiento, NULL, ISNULL(m.Descripcion, 'Pesos'), um.Descripcion, cd.PrecioIntroducido, cd.FechaEntregaRequerida, cd.Proyecto, cd.SubProyecto
FROM CotizaMes cm
JOIN CotizaDMES cd ON cm.ID = cd.ID
LEFT OUTER JOIN MonMES m ON cm.Moneda = m.Moneda
LEFT OUTER JOIN UnidadMes um ON cd.UnidadPedida = um.UnidadMedida
WHERE cm.EstatusIntelIMES = 0
/*
SELECT mm.ID, mm.Almacen, mm.Articulo, mm.SubCuenta, mm.Cantidad, mm.Lanzamiento, mm.Lote, ISNULL(m.Descripcion, 'Pesos'), um.Descripcion, ISNULL(mm.PrecioCosteMedio, 0) /*ISNULL(mm.CosteOperarios, 0) + ISNULL(mm.CosteMaterial, 0) + ISNULL(mm.CosteIndirecto, 0) + ISNULL(mm.CosteMaquinaria, 0)*/, mm.OrdenProduccion, mm.Proyecto
FROM MovMES mm
LEFT OUTER JOIN MonMES m ON mm.Moneda = m.Moneda
LEFT OUTER JOIN UnidadMes um ON mm.Unidad = um.UnidadMedida
WHERE mm.ProcesadoINTELISIS = 0
AND mm.Direccion = 'C'
*/
DECLARE crMesInv CURSOR FOR
SELECT mi.Cliente, mi.Almacen, mi.Moneda, RTRIM(mi.Lanzamiento), mi.Proyecto, mi.SubProyecto
FROM #MesInv mi
GROUP BY mi.Cliente, mi.Almacen, mi.Moneda, RTRIM(mi.Lanzamiento), mi.Proyecto, mi.SubProyecto
OPEN crMesInv
FETCH NEXT FROM crMesInv INTO @Cliente, @Almacen, @Moneda, @Referencia, @Proyecto, @SubProyecto
WHILE @@FETCH_STATUS = 0 AND @Ok IS NULL
BEGIN
SELECT @IDInv = NULL, @Origen = NULL, @OrigenID = NULL
SELECT @TipoCambio = m.TipoCambio FROM Mon m WHERE m.Moneda = @Moneda
SELECT top 1 @Origen = Mov, @OrigenID = MovID, @IDOport = ID FROM Oportunidad WHERE Estatus = 'REVISION' AND Proyecto = @SubProyecto
INSERT INTO Venta(Empresa, Mov, Cliente, FechaEmision, Referencia, Moneda, TipoCambio, Usuario, Estatus, Almacen, OrigenTipo, Sucursal, Proyecto, Origen, OrigenID, IDOport, FechaRequerida, Condicion, FormaPagoTipo, MesLanzamiento)
VALUES(@Empresa, 'Cotizacion', @Cliente, @FechaEmision, @Referencia, @Moneda, @TipoCambio, @Usuario, 'SINAFECTAR', @Almacen, 'OPORT', @Sucursal, @Proyecto, @Origen, @OrigenID, @IDOport, (@FechaEmision+7), '(Fecha)', 'TRANSFERENCIA', @Referencia)
SELECT @IDInv = @@IDENTITY
SELECT @Renglon = 0, @RenglonID = 0
IF @IDInv IS NOT NULL
BEGIN
DECLARE crMesInvD CURSOR FOR
SELECT mi.ID, mi.Articulo, mi.SubCuenta, mi.Cantidad, mi.Lote, mi.Unidad, mi.Costo, a.Tipo, mi.FechaRequerida, mi.SubProyecto
FROM #MesInv mi
JOIN Art a ON mi.Articulo = a.Articulo
WHERE mi.Cliente = @Cliente
AND mi.Almacen = @Almacen
AND mi.Moneda = @Moneda
AND mi.Lanzamiento = @Referencia
AND mi.Proyecto = @Proyecto
AND a.Situacion = 'MES'
OPEN crMesInvD
FETCH NEXT FROM crMesInvD INTO @ID, @Articulo, @SubCuenta, @Cantidad, @Lote, @Unidad, @Costo, @ArtTipo, @FechaRequerida, @SubProyecto
WHILE @@FETCH_STATUS = 0 AND @Ok IS NULL
BEGIN
SELECT @Costo = (@Costo/@TipoCambio)*dbo.fnArtUnidadFactor(@Empresa, @Articulo, @Unidad)
EXEC spRenglonTipo @ArtTipo, NULL, @RenglonTipo OUTPUT
SELECT @Renglon = @Renglon + 1048, @RenglonID = @RenglonID + 1
EXEC xpCantidadInventario @Articulo, NULL, @Unidad, @CfgMultiUnidades, @CfgMultiUnidadesNivel, @Cantidad, @CantidadInventario OUTPUT
INSERT INTO VentaD
(ID,     Renglon, RenglonSub, RenglonID,  RenglonTipo,  Cantidad,  Almacen,  Articulo,  SubCuenta,  Precio, Unidad, ABC, FechaRequerida, MesLanzamiento)
VALUES(@IDInv, @Renglon, 0,         @RenglonID, @RenglonTipo, @Cantidad, @Almacen, @Articulo, @SubCuenta, @Costo, @Unidad, @SubProyecto, @FechaRequerida, @Referencia)
/*
IF @RenglonTipo = 'L'
BEGIN
SELECT @Propiedades = RTRIM(YEAR(@FechaEmision)) + '-' + RTRIM(MONTH(@FechaEmision)) + '-' + RTRIM(DAY(@FechaEmision))
IF NOT EXISTS(SELECT * FROM SerieLoteProp slp WHERE slp.Propiedades = @Propiedades)
INSERT INTO SerieLoteProp(Propiedades, Extra1, Extra2, Fecha1)
VALUES(@Propiedades, @Lote, @OrdenProduccion, @FechaEmision)
INSERT INTO SerieLoteMov(Empresa, Modulo, ID, RenglonID, Articulo, SubCuenta, SerieLote, Cantidad, Propiedades)
VALUES(@Empresa, 'INV', @IDInv, @RenglonID, @Articulo, ISNULL(@SubCuenta, ''), @Lote, @Cantidad, @Propiedades)
END*/
FETCH NEXT FROM crMesInvD INTO @ID, @Articulo, @SubCuenta, @Cantidad, @Lote, @Unidad, @Costo, @ArtTipo, @FechaRequerida, @SubProyecto
END
CLOSE crMesInvD
DEALLOCATE crMesInvD
UPDATE CotizaMES SET EstatusIntelIMES = 1 WHERE ID = @ID
EXEC spAfectar 'VTAS', @IDInv, 'AFECTAR', NULL, NULL, @Usuario, 0, 1, @Ok OUTPUT, @OkRef OUTPUT, NULL, 0
END
FETCH NEXT FROM crMesInv INTO @Cliente, @Almacen, @Moneda, @Referencia, @Proyecto, @SubProyecto
END
CLOSE crMesInv
DEALLOCATE crMesInv
DELETE FROM #MesInv
SELECT 'Proceso Concluido'
RETURN
END

