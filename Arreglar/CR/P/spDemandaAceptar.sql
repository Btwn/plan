SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spDemandaAceptar
@Estacion	int,
@Modulo	char(5),
@ID		int,
@MovTipo	char(20)

AS BEGIN
DECLARE
@Sucursal			int,
@Empresa			char(5),
@Moneda			char(10),
@TipoCambio			float,
@CfgCompraCostoSugerido  	char(20),
@Mov			char(20),
@MovID			varchar(20),
@Renglon			float,
@RenglonID			int,
@LModulo			char(5),
@LID			int,
@LRenglon			float,
@LRenglonSub		int,
@FechaEmision		datetime,
@FechaRequerida		datetime,
@FechaEntrega		datetime,
@Articulo			char(20),
@SubCuenta			varchar(50),
@ProdRuta			varchar(20),
@RenglonTipo		char(1),
@Almacen			char(10),
@Proveedor			char(10),
@Cantidad			float,
@CantidadInventario		float,
@Factor			float,
@Unidad			varchar(50),
@DescripcionExtra		varchar(100),
@Impuesto1			float,
@Impuesto2			float,
@Impuesto3			money,
@Retencion1			float,
@Retencion2			float,
@Retencion3			float,
@Costo			money,
@ProdSerieLote		char(20),
@TiempoEntrega		int,
@TiempoEntregaUnidad	varchar(10),
@ListaPreciosEsp		varchar(20),
@ZonaImpuesto		varchar(50),
@DescuentoCompra		float
SELECT @Renglon = 0.0, @RenglonID = 0, @Proveedor = NULL, @ProdSerieLote = NULL
IF @Modulo = 'PROD'
BEGIN
SELECT @Sucursal = Sucursal, @Empresa = Empresa, @Moneda = Moneda, @TipoCambio = TipoCambio, @FechaEmision = FechaEmision FROM Prod WHERE ID = @ID
SELECT @Renglon = ISNULL(MAX(Renglon), 0.0), @RenglonID = ISNULL(MAX(RenglonID), 0) FROM ProdD WHERE ID = @ID
END ELSE
IF @Modulo = 'INV'
BEGIN
SELECT @Sucursal = Sucursal, @Empresa = Empresa, @Moneda = Moneda, @TipoCambio = TipoCambio, @FechaEmision = FechaEmision FROM Inv WHERE ID = @ID
SELECT @Renglon = ISNULL(MAX(Renglon), 0.0), @RenglonID = ISNULL(MAX(RenglonID), 0) FROM InvD WHERE ID = @ID
END ELSE
IF @Modulo = 'COMS'
BEGIN
SELECT @Sucursal = Sucursal, @Empresa = Empresa, @Moneda = Moneda, @TipoCambio = TipoCambio, @Proveedor = Proveedor, @FechaEmision = FechaEmision, @ListaPreciosEsp = NULLIF(RTRIM(ListaPreciosEsp), ''), @ZonaImpuesto = ZonaImpuesto FROM Compra WHERE ID = @ID
SELECT @Renglon = ISNULL(MAX(Renglon), 0.0), @RenglonID = ISNULL(MAX(RenglonID), 0) FROM CompraD WHERE ID = @ID
END
SELECT @CfgCompraCostoSugerido = CompraCostoSugerido
FROM EmpresaCfg
WHERE Empresa = @Empresa
BEGIN TRANSACTION
DECLARE crLista CURSOR FOR
SELECT Modulo, ID, Renglon, RenglonSub
FROM ListaIDRenglon
WHERE Estacion = @Estacion
ORDER BY IDInterno
OPEN crLista
FETCH NEXT FROM crLista INTO @LModulo, @LID, @LRenglon, @LRenglonSub
WHILE @@FETCH_STATUS <> -1
BEGIN
IF @@FETCH_STATUS <> -2
BEGIN
SELECT @DescripcionExtra = NULL
IF @LModulo = 'VTAS'
SELECT @Mov = e.Mov, @MovID = e.MovID, @RenglonTipo = RenglonTipo, @Articulo = d.Articulo, @SubCuenta = d.SubCuenta, @Almacen = d.Almacen, @Cantidad = d.CantidadPendiente, @Unidad = d.Unidad, @Factor = d.Factor, @FechaRequerida = d.FechaRequerida, @DescripcionExtra = d.DescripcionExtra
FROM Venta e, VentaD d
WHERE e.ID = d.ID AND d.ID = @LID AND d.Renglon = @LRenglon AND d.RenglonSub = @LRenglonSub
ELSE
IF @LModulo = 'INV'
SELECT @Mov = e.Mov, @MovID = e.MovID, @RenglonTipo = RenglonTipo, @Articulo = d.Articulo, @SubCuenta = d.SubCuenta, @Almacen = d.Almacen, @Cantidad = d.CantidadPendiente, @Unidad = d.Unidad, @Factor = d.Factor, @FechaRequerida = d.FechaRequerida
FROM Inv e, InvD d
WHERE e.ID = d.ID AND d.ID = @LID AND d.Renglon = @LRenglon AND d.RenglonSub = @LRenglonSub
SELECT @Renglon = @Renglon + 2048.0, @RenglonID = @RenglonID + 1,
@CantidadInventario = @Cantidad * @Factor
IF @Modulo = 'PROD'
BEGIN
SELECT @ProdRuta = ProdRuta, @TiempoEntrega = TiempoEntrega, @TiempoEntregaUnidad = TiempoEntregaUnidad FROM Art WHERE Articulo = @Articulo
EXEC spIncTiempo @FechaEmision, @TiempoEntrega, @TiempoEntregaUnidad, @FechaEntrega OUTPUT
INSERT ProdD (ID, Renglon, RenglonSub, RenglonID, RenglonTipo,  DestinoTipo, Destino, DestinoID, Articulo, SubCuenta,   Almacen,  Cantidad,  Unidad,  CantidadInventario,  FechaRequerida,  FechaEntrega,  DescripcionExtra,  ProdSerieLote,  Ruta)
VALUES (@ID, @Renglon, 0,        @RenglonID, @RenglonTipo, @LModulo,   @Mov,    @MovID,    @Articulo, @SubCuenta, @Almacen, @Cantidad, @Unidad, @CantidadInventario, @FechaRequerida, @FechaEntrega, @DescripcionExtra, @ProdSerieLote, @ProdRuta)
END ELSE
IF @Modulo = 'INV'
BEGIN
INSERT InvD (ID,  Renglon,  RenglonSub,RenglonID, RenglonTipo,  DestinoTipo, Destino, DestinoID, Articulo, SubCuenta,   Almacen,  Cantidad,  Unidad, CantidadInventario,  FechaRequerida)
VALUES (@ID, @Renglon, 0,        @RenglonID, @RenglonTipo, @LModulo,   @Mov,    @MovID,    @Articulo, @SubCuenta, @Almacen, @Cantidad, @Unidad, @CantidadInventario, @FechaRequerida)
END ELSE
IF @Modulo = 'COMS'
BEGIN
SELECT @Impuesto1 = Impuesto1, @Impuesto2 = Impuesto2, @Impuesto3 = Impuesto3, @Retencion1 = Retencion1, @Retencion2 = Retencion2, @Retencion3 = Retencion3, @DescuentoCompra = DescuentoCompra
FROM Art
WHERE Articulo = @Articulo
EXEC spZonaImp @ZonaImpuesto, @Impuesto1 OUTPUT
EXEC spZonaImp @ZonaImpuesto, @Impuesto2 OUTPUT
EXEC spZonaImp @ZonaImpuesto, @Impuesto3 OUTPUT
EXEC spTipoImpuesto @Modulo, @ID, @Mov, @FechaEmision, @Empresa, @Sucursal, @Contacto = @Proveedor, @Articulo = @Articulo, @EnSilencio = 1, @Impuesto1 = @Impuesto1 OUTPUT, @Impuesto2 = @Impuesto2 OUTPUT, @Impuesto3 = @Impuesto3 OUTPUT
IF @ListaPreciosEsp IS NOT NULL
EXEC spPrecioEsp @ListaPreciosEsp, @Moneda, @Articulo, @SubCuenta, @Costo OUTPUT
ELSE
EXEC spVerCosto @Sucursal, @Empresa, @Proveedor, @Articulo, @SubCuenta, @Unidad, @CfgCompraCostoSugerido, @Moneda, @TipoCambio, @Costo OUTPUT, 0
INSERT CompraD (ID, Renglon, RenglonSub, RenglonID, RenglonTipo,  DestinoTipo, Destino, DestinoID, Articulo, SubCuenta,   Almacen,  Cantidad,  Unidad, CantidadInventario,  FechaRequerida,  Impuesto1,  Impuesto2,  Impuesto3,  Retencion1,  Retencion2,  Retencion3,  Costo,  DescripcionExtra, DescuentoLinea)
VALUES (@ID, @Renglon, 0,        @RenglonID, @RenglonTipo, @LModulo,   @Mov,    @MovID,    @Articulo, @SubCuenta, @Almacen, @Cantidad, @Unidad, @CantidadInventario, @FechaRequerida, @Impuesto1, @Impuesto2, @Impuesto3, @Retencion1, @Retencion2, @Retencion3, @Costo, @DescripcionExtra, @DescuentoCompra)
END
END
FETCH NEXT FROM crLista INTO @LModulo, @LID, @LRenglon, @LRenglonSub
END 
CLOSE crLista
DEALLOCATE crLista
IF @Modulo = 'PROD'
BEGIN
SELECT @FechaEntrega = MIN(FechaRequerida) FROM ProdD WHERE ID = @ID
UPDATE Prod   SET VerDestino = 1, RenglonID = @RenglonID, FechaEntrega = @FechaEntrega WHERE ID = @ID
END ELSE
IF @Modulo = 'INV'
UPDATE Inv SET VerDestino = 1, RenglonID = @RenglonID WHERE ID = @ID
ELSE
IF @Modulo = 'COMS' UPDATE Compra SET VerDestino = 1, RenglonID = @RenglonID WHERE ID = @ID
DELETE ListaIDRenglon WHERE Estacion = @Estacion
COMMIT TRANSACTION
RETURN
END

