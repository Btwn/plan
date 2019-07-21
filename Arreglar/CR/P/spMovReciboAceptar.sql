SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spMovReciboAceptar
@Modulo		char(5),
@ID		int,
@AplicaMov	varchar(20),
@AplicaMovID	varchar(20)

AS BEGIN
DECLARE
@Empresa			char(5),
@Sucursal			int,
@Estatus			char(15),
@ZonaImpuesto		varchar(30),
@CfgMultiUnidades		bit,
@CfgMultiUnidadesNivel	char(20),
@Renglon			float,
@RenglonID			int,
@RenglonTipo		char(1),
@Articulo			char(20),
@SubCuenta			varchar(20),
@Cantidad			float,
@CantidadInventario 	float,
@ReciboCantidad		float,
@ReciboCosto		float,
@Unidad			varchar(50),
@Costo			float,
@Lote			varchar(50),
@Caducidad			datetime,
@Impuesto1			float,
@Impuesto2			float,
@Impuesto3			float,
@ArtTipo 			varchar(20),
@Almacen			char(10),
@AlmacenDestino		char(10),
@AplicaID			int,
@LotesFijos			bit,
@TieneCaducidad		bit,
@AplicaUnidad		varchar(50),
@Factor			float,
@AplicaFactor		float,
@DescuentoGlobal		float,
@Descuento			varchar(50),
@Condicion			varchar(50),
@Referencia			varchar(50),
@AplicaContUso		varchar(20),
@AplicaDescuentoLinea	float,
@DescuentoImporte		float,
@Origen			varchar(20),
@OrigenID			varchar(20),
@FechaEmision		datetime,
@Contacto			varchar(10),
@EnviarA			int,
@Mov			varchar(20)
BEGIN TRANSACTION
SELECT @ZonaImpuesto = NULL, @AplicaID = NULL, @AplicaMov = NULLIF(RTRIM(NULLIF(@AplicaMov, '0')), ''), @AplicaMovID = NULLIF(RTRIM(NULLIF(@AplicaMovID, '0')), '')
IF @Modulo = 'COMS'
BEGIN
SELECT @FechaEmision = FechaEmision, @Contacto = Proveedor, @Empresa = Empresa, @Sucursal = Sucursal, @ZonaImpuesto = NULLIF(RTRIM(ZonaImpuesto), ''), @Almacen = Almacen, @Mov = Mov FROM Compra WHERE ID = @ID
SELECT @Renglon = ISNULL(MAX(Renglon), 0.0), @RenglonID = ISNULL(MAX(RenglonID), 0) FROM CompraD WHERE ID = @ID
SELECT @AplicaID = ID, @DescuentoGlobal = DescuentoGlobal, @Descuento = Descuento, @Condicion = Condicion, @Referencia = Referencia, @Origen = Origen, @OrigenID = OrigenID FROM Compra WHERE Empresa = @Empresa AND Estatus = 'PENDIENTE' AND Mov = @AplicaMov AND MovID = @AplicaMovID
END ELSE
IF @Modulo = 'INV'
BEGIN
SELECT @FechaEmision = FechaEmision, @Empresa = Empresa, @Sucursal = Sucursal, @Almacen = Almacen, @Mov = Mov FROM Inv WHERE ID = @ID
SELECT @Renglon = ISNULL(MAX(Renglon), 0.0), @RenglonID = ISNULL(MAX(RenglonID), 0) FROM InvD WHERE ID = @ID
SELECT @AplicaID = ID, @Referencia = Referencia, @Origen = Origen, @OrigenID = OrigenID FROM Inv WHERE Empresa = @Empresa AND Estatus = 'PENDIENTE' AND Mov = @AplicaMov AND MovID = @AplicaMovID
END
SELECT @CfgMultiUnidades = MultiUnidades,
@CfgMultiUnidadesNivel = ISNULL(UPPER(NivelFactorMultiUnidad), 'UNIDAD')
FROM EmpresaCfg2
WHERE Empresa = @Empresa
IF @Modulo = 'COMS' DELETE CompraD WHERE ID = @ID
IF @Modulo = 'INV'  DELETE InvD    WHERE ID = @ID
DELETE SerieLoteMov WHERE Empresa = @Empresa AND Modulo = @Modulo AND ID = @ID
DECLARE crMovReciboAceptar CURSOR
FOR SELECT r.Articulo, r.SubCuenta, r.Cantidad, r.Unidad, r.Costo, NULLIF(RTRIM(r.Lote), ''), r.Caducidad, a.Impuesto1, a.Impuesto2, a.Impuesto3, a.Tipo, a.LotesFijos, a.TieneCaducidad
FROM MovRecibo r, Art a
WHERE r.Modulo = @Modulo AND r.ModuloID = @ID AND r.Articulo = a.Articulo
OPEN crMovReciboAceptar
FETCH NEXT FROM crMovReciboAceptar INTO @Articulo, @SubCuenta, @Cantidad, @Unidad, @Costo, @Lote, @Caducidad, @Impuesto1, @Impuesto2, @Impuesto3, @ArtTipo, @LotesFijos, @TieneCaducidad
WHILE @@FETCH_STATUS <> -1
BEGIN
IF @@FETCH_STATUS <> -2 AND @Cantidad > 0
BEGIN
IF @LotesFijos = 0 SELECT @Lote = NULL
IF @TieneCaducidad = 0 SELECT @Caducidad = NULL
EXEC spZonaImp @ZonaImpuesto, @Impuesto1 OUTPUT
EXEC spZonaImp @ZonaImpuesto, @Impuesto2 OUTPUT
EXEC spZonaImp @ZonaImpuesto, @Impuesto3 OUTPUT
EXEC spTipoImpuesto @Modulo, @ID, @Mov, @FechaEmision, @Empresa, @Sucursal, @Contacto, @Articulo = @Articulo, @EnSilencio = 1, @Impuesto1 = @Impuesto1 OUTPUT, @Impuesto2 = @Impuesto2 OUTPUT, @Impuesto3 = @Impuesto3 OUTPUT
EXEC spRenglonTipo @ArtTipo, @SubCuenta, @RenglonTipo OUTPUT
SELECT @Renglon = @Renglon + 2048, @RenglonID = @RenglonID + 1
EXEC xpCantidadInventario @Articulo, @SubCuenta, @Unidad, @CfgMultiUnidades, @CfgMultiUnidadesNivel, @Cantidad, @CantidadInventario OUTPUT
SELECT @Factor = @CantidadInventario / @Cantidad
SELECT @ReciboCantidad = @Cantidad,
@ReciboCosto = @Costo,
@AplicaUnidad = @Unidad
IF @Modulo = 'COMS'
BEGIN
IF @AplicaID IS NOT NULL
BEGIN
SELECT @AplicaUnidad = MIN(Unidad), @AplicaFactor = MIN(Factor), @AplicaContUso = MIN(ContUso), @AplicaDescuentoLinea = MIN(DescuentoLinea)
FROM CompraD
WHERE ID = @AplicaID AND Articulo = @Articulo AND ISNULL(SubCuenta, '') = ISNULL(@SubCuenta, '') AND ISNULL(CantidadPendiente, 0) > 0
SELECT @ReciboCantidad = @Cantidad * @Factor / @AplicaFactor,
@ReciboCosto = @Costo / @Factor * @AplicaFactor
END
EXEC xpCantidadInventario @Articulo, @SubCuenta, @AplicaUnidad, @CfgMultiUnidades, @CfgMultiUnidadesNivel, @ReciboCantidad, @CantidadInventario OUTPUT
SELECT @DescuentoImporte = @ReciboCantidad * @ReciboCosto * (@AplicaDescuentoLinea/100.0)
INSERT CompraD (Sucursal,  ID,  Renglon,  RenglonSub, RenglonID,  RenglonTipo,  Articulo,  SubCuenta,  DescuentoLinea,        DescuentoImporte,  Unidad,        Cantidad,        CantidadInventario,  Almacen,  Aplica,     AplicaID,     Costo,        Impuesto1,  Impuesto2,  Impuesto3,          FechaCaducidad, ContUso)
VALUES (@Sucursal, @ID, @Renglon, 0,          @RenglonID, @RenglonTipo, @Articulo, @SubCuenta, @AplicaDescuentoLinea, @DescuentoImporte, @AplicaUnidad, @ReciboCantidad, @CantidadInventario, @Almacen, @AplicaMov, @AplicaMovID, @ReciboCosto, @Impuesto1, @Impuesto2, @Impuesto3*@Factor, @Caducidad,     @AplicaContUso)
END ELSE
IF @Modulo = 'INV'
BEGIN
IF @AplicaID IS NOT NULL
BEGIN
SELECT @AlmacenDestino = AlmacenDestino FROM Inv WHERE ID = @AplicaID
UPDATE InvD SET Almacen = @AlmacenDestino WHERE ID = @AplicaID AND Almacen <> @AlmacenDestino
SELECT @AplicaUnidad = MIN(Unidad), @AplicaFactor = MIN(Factor), @AplicaContUso = MIN(ContUso)
FROM InvD
WHERE ID = @AplicaID AND Articulo = @Articulo AND ISNULL(SubCuenta, '') = ISNULL(@SubCuenta, '') AND ISNULL(CantidadPendiente, 0) > 0
SELECT @ReciboCantidad = @Cantidad * @Factor / @AplicaFactor,
@ReciboCosto = @Costo / @Factor * @AplicaFactor
END
EXEC xpCantidadInventario @Articulo, @SubCuenta, @AplicaUnidad, @CfgMultiUnidades, @CfgMultiUnidadesNivel, @ReciboCantidad, @CantidadInventario OUTPUT
INSERT InvD (Sucursal,  ID,  Renglon,  RenglonSub, RenglonID,  RenglonTipo,  Articulo,  SubCuenta,  Unidad,        Cantidad,        CantidadInventario,  Almacen,  Aplica,     AplicaID,     Costo,        ContUso)
VALUES (@Sucursal, @ID, @Renglon, 0,          @RenglonID, @RenglonTipo, @Articulo, @SubCuenta, @AplicaUnidad, @ReciboCantidad, @CantidadInventario, @Almacen, @AplicaMov, @AplicaMovID, @ReciboCosto, @AplicaContUso)
END
IF @Modulo = 'INV'
INSERT SerieLoteMov (Empresa, Sucursal,  Modulo, ID,    RenglonID,  Articulo,  SubCuenta,              SerieLote, Cantidad, ArtCostoInv)
SELECT  @Empresa, @Sucursal, @Modulo, @ID, @RenglonID, @Articulo, ISNULL(@SubCuenta, ''), SerieLote, Cantidad, ArtCostoInv
FROM fnSerieLoteMovParcial (@Empresa, @Modulo, @AplicaID, @Articulo, @SubCuenta, @CantidadInventario)
ELSE
IF @Lote IS NOT NULL
INSERT SerieLoteMov (Empresa,  Sucursal,  Modulo,  ID,  RenglonID,  Articulo,  SubCuenta,              SerieLote, Cantidad)
VALUES (@Empresa, @Sucursal, @Modulo, @ID, @RenglonID, @Articulo, ISNULL(@SubCuenta, ''), @Lote,     @CantidadInventario)
END
FETCH NEXT FROM crMovReciboAceptar INTO @Articulo, @SubCuenta, @Cantidad, @Unidad, @Costo, @Lote, @Caducidad, @Impuesto1, @Impuesto2, @Impuesto3, @ArtTipo, @LotesFijos, @TieneCaducidad
END  
CLOSE crMovReciboAceptar
DEALLOCATE crMovReciboAceptar
IF @Modulo = 'COMS'
BEGIN
IF EXISTS(SELECT * FROM CompraD WHERE ID = @ID) SELECT @Estatus = 'BORRADOR' ELSE SELECT @Estatus = 'SINAFECTAR'
UPDATE Compra SET OrigenTipo = @Modulo, Origen = @AplicaMov, OrigenID = @AplicaMovID, Estatus = @Estatus, Directo = CASE WHEN @AplicaMov IS NULL THEN 1 ELSE 0 END, RenglonID = @RenglonID, DescuentoGlobal = @DescuentoGlobal, Descuento = @Descuento, Condicion = @Condicion, Referencia = ISNULL(NULLIF(RTRIM(Referencia), ''), @Referencia) WHERE ID = @ID
END ELSE
IF @Modulo = 'INV'
BEGIN
IF EXISTS(SELECT * FROM InvD WHERE ID = @ID) SELECT @Estatus = 'BORRADOR' ELSE SELECT @Estatus = 'SINAFECTAR'
UPDATE Inv SET OrigenTipo = @Modulo, Origen = @AplicaMov, OrigenID = @AplicaMovID, Estatus = @Estatus, Directo = CASE WHEN @AplicaMov IS NULL THEN 1 ELSE 0 END, RenglonID = @RenglonID, Referencia = ISNULL(NULLIF(RTRIM(Referencia), ''), @Referencia) WHERE ID = @ID
END
COMMIT TRANSACTION
RETURN
END

