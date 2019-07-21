SET DATEFIRST 7    
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1  
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spCBLoteRenglon
@Empresa			char(5),
@Modulo			char(5),
@ID				int,
@MovTipo			char(20),
@Estatus                    char(15),
@Sucursal			int,
@CfgMultiUnidades		bit,
@CfgMultiUnidadesNivel	char(20),
@CfgCompraCostoSugerido  	char(20),
@Moneda			char(10),
@TipoCambio			float,
@Proveedor			char(10),
@Almacen			char(10),
@FechaRequerida		datetime,
@Cuenta			char(20),
@SubCuenta			varchar(50),
@Unidad			varchar(50),
@Cantidad			float,
@SerieLote			varchar(50),
@Renglon			float	OUTPUT,
@RenglonID			int	OUTPUT,
@AplicaMov			char(20)	= NULL,
@AplicaMovID		varchar(20)	= NULL,
@Paquete			int		= NULL,
@ZonaImpuesto		varchar(50)	= NULL

AS BEGIN
DECLARE
@Articulo			char(20),
@ArtTipo			char(20),
@ArtImpuesto1		float,
@ArtImpuesto2		float,
@ArtImpuesto3		money,
@ArtRuta			char(20),
@Ruta			char(20),
@Orden			int,
@Centro			char(10),
@Tipo			char(20),
@RenglonTipo		char(1),
@RenglonSub                 int,
@Costo			float,
@CantidadInventario		float,
@Precio			float,
@ListaPrecios		varchar(30),
@FechaEmision		datetime,
@Contacto			varchar(10),
@EnviarA			int,
@Mov			varchar(20),
@Factor                     float
SELECT @Articulo = NULL, @Contacto = NULL, @EnviarA = NULL
SELECT @Articulo      = Articulo,
@ArtTipo       = Tipo,
@ArtImpuesto1  = Impuesto1,
@ArtImpuesto2  = Impuesto2,
@ArtImpuesto3  = Impuesto3,
@ArtRuta	= ProdRuta,
@Unidad        = ISNULL(@Unidad, CASE WHEN @Modulo IN ('COMS', 'PROD') THEN UnidadCompra ELSE Unidad END)
FROM Art WITH (NOLOCK)
WHERE Articulo = @Cuenta AND UPPER(Estatus) = 'ALTA'
IF @Modulo = 'VTAS' SELECT @Mov = Mov, @FechaEmision = FechaEmision, @Contacto = Cliente, @EnviarA = EnviarA FROM Venta  WITH (NOLOCK) WHERE ID = @ID ELSE
IF @Modulo = 'COMS' SELECT @Mov = Mov, @FechaEmision = FechaEmision, @Contacto = Proveedor                   FROM Compra WITH (NOLOCK) WHERE ID = @ID
EXEC spZonaImp @ZonaImpuesto, @ArtImpuesto1 OUTPUT
EXEC spZonaImp @ZonaImpuesto, @ArtImpuesto2 OUTPUT
EXEC spZonaImp @ZonaImpuesto, @ArtImpuesto3 OUTPUT
EXEC spTipoImpuesto @Modulo, @ID, @Mov, @FechaEmision, @Empresa, @Sucursal, @Contacto = @Contacto, @EnviarA = @EnviarA, @Articulo = @Articulo, @EnSilencio = 1, @Impuesto1 = @ArtImpuesto1 OUTPUT, @Impuesto2 = @ArtImpuesto2 OUTPUT, @Impuesto3 = @ArtImpuesto3 OUTPUT
SELECT @Factor =  dbo.fnArtUnidadFactor(@Empresa, @Articulo,@Unidad)
IF @CfgMultiUnidades = 0 SELECT @Unidad = NULL
IF @Articulo IS NOT NULL
BEGIN
EXEC xpCantidadInventario @Articulo, @SubCuenta, @Unidad, @CfgMultiUnidades, @CfgMultiUnidadesNivel, @Cantidad, @CantidadInventario OUTPUT
EXEC spVerCosto @Sucursal, @Empresa, @Proveedor, @Articulo, @SubCuenta, @Unidad, @CfgCompraCostoSugerido, @Moneda, @TipoCambio, @Costo OUTPUT, 0
EXEC spRenglonTipo @ArtTipo, @SubCuenta, @RenglonTipo OUTPUT
SELECT @Renglon = @Renglon + 2048.0, @RenglonID = @RenglonID + 1
IF @Modulo = 'INV'
BEGIN
IF @Estatus = 'PENDIENTE'
BEGIN
SELECT @Renglon = Renglon, @RenglonSub = RenglonSub FROM InvD WHERE ID = @ID AND Almacen = @Almacen AND Articulo = @Articulo AND ISNULL(SubCuenta, '') = ISNULL(@SubCuenta, '') AND ISNULL(ProdSerieLote, '') = ISNULL(@SerieLote, '')
UPDATE InvD WITH (ROWLOCK) SET CantidadA = ISNULL(CantidadA, 0) + ISNULL(@Cantidad, 0) WHERE ID = @ID AND Renglon = @Renglon AND RenglonSub = @RenglonSub
END ELSE
INSERT InvD (ID,  Renglon,  RenglonSub, RenglonID,  RenglonTipo,  ProdSerieLote, Almacen,  Articulo,  SubCuenta,  Cantidad,  Unidad,  CantidadInventario,  Costo,  FechaRequerida,  Aplica,     AplicaID,     Paquete)
VALUES (@ID, @Renglon, 0,          @RenglonID, @RenglonTipo, @SerieLote,    @Almacen, @Articulo, @SubCuenta, @Cantidad, @Unidad, @CantidadInventario, @Costo, @FechaRequerida, @AplicaMov, @AplicaMovID, @Paquete)
END ELSE
IF @Modulo = 'VTAS'
BEGIN
IF @Estatus = 'PENDIENTE'
BEGIN
SELECT @Renglon = Renglon, @RenglonSub = RenglonSub FROM VentaD WHERE ID = @ID AND Almacen = @Almacen AND Articulo = @Articulo AND ISNULL(SubCuenta, '') = ISNULL(@SubCuenta, '')
UPDATE VentaD WITH (ROWLOCK) SET CantidadA = ISNULL(CantidadA, 0) + ISNULL(@Cantidad, 0) WHERE ID = @ID AND Renglon = @Renglon AND RenglonSub = @RenglonSub
END ELSE
BEGIN
SELECT @ListaPrecios = ListaPreciosEsp FROM Venta WITH (NOLOCK) WHERE ID = @ID
EXEC spPrecioEsp @ListaPrecios, @Moneda, @Articulo, @SubCuenta, @Precio OUTPUT
INSERT VentaD (ID,  Renglon,  RenglonSub, RenglonID,  RenglonTipo,  Impuesto1,     Impuesto2,     Impuesto3,              Almacen,  Articulo,  SubCuenta,  Cantidad,  Unidad,  CantidadInventario,  Costo,  FechaRequerida,  Precio,  Aplica,     AplicaID,     Paquete)
VALUES (@ID, @Renglon, 0,          @RenglonID, @RenglonTipo, @ArtImpuesto1, @ArtImpuesto2, @ArtImpuesto3*@Factor, @Almacen, @Articulo, @SubCuenta, @Cantidad, @Unidad, @CantidadInventario, @Costo, @FechaRequerida, @Precio, @AplicaMov, @AplicaMovID, @Paquete)
END
END ELSE
IF @Modulo = 'COMS'
IF @Estatus = 'PENDIENTE'
BEGIN
SELECT @Renglon = Renglon, @RenglonSub = RenglonSub FROM CompraD WITH (NOLOCK) WHERE ID = @ID AND Almacen = @Almacen AND Articulo = @Articulo AND ISNULL(SubCuenta, '') = ISNULL(@SubCuenta, '')
UPDATE CompraD WITH (ROWLOCK) SET CantidadA = ISNULL(CantidadA, 0) + ISNULL(@Cantidad, 0) WHERE ID = @ID AND Renglon = @Renglon AND RenglonSub = @RenglonSub
END ELSE
INSERT CompraD (ID,  Renglon,  RenglonSub, RenglonID,  RenglonTipo,  Impuesto1,     Impuesto2,     Impuesto3,             Almacen,  Articulo,  SubCuenta,  Cantidad,  Unidad,  CantidadInventario,  Costo,  FechaRequerida,  Aplica,     AplicaID,     Paquete)
VALUES (@ID, @Renglon, 0,          @RenglonID, @RenglonTipo, @ArtImpuesto1, @ArtImpuesto2, @ArtImpuesto3*@Factor, @Almacen, @Articulo, @SubCuenta, @Cantidad, @Unidad, @CantidadInventario, @Costo, @FechaRequerida, @AplicaMov, @AplicaMovID, @Paquete)
ELSE
IF @Modulo = 'PROD'
BEGIN
IF @Estatus = 'PENDIENTE'
BEGIN
SELECT @Renglon = Renglon, @RenglonSub = RenglonSub FROM ProdD WITH (NOLOCK) WHERE ID = @ID AND Almacen = @Almacen AND Articulo = @Articulo AND ISNULL(SubCuenta, '') = ISNULL(@SubCuenta, '') AND ISNULL(ProdSerieLote, '') = ISNULL(@SerieLote, '')
UPDATE ProdD WITH (ROWLOCK) SET CantidadA = ISNULL(CantidadA, 0) + ISNULL(@Cantidad, 0) WHERE ID = @ID AND Renglon = @Renglon AND RenglonSub = @RenglonSub
END ELSE
BEGIN
SELECT @Ruta = NULL, @Centro = NULL, @Tipo = NULL
IF @MovTipo = 'PROD.E' SELECT @Tipo = 'Entrada'
IF @SerieLote IS NULL
SELECT @Ruta = @ArtRuta
ELSE
SELECT @Ruta = MIN(Ruta), @Orden = MIN(Orden), @Centro = MIN(Centro)
FROM ProdSerieLotePendiente WITH (NOLOCK)
WHERE Empresa = @Empresa AND ProdSerieLote = @SerieLote AND Articulo = @Articulo AND ISNULL(SubCuenta, '') = ISNULL(@SubCuenta, '')
INSERT ProdD (ID,  Renglon,  RenglonSub, RenglonID,  RenglonTipo,  ProdSerieLote, Ruta,  Orden,  Centro,  Tipo,  Almacen,  Articulo,  SubCuenta,  Cantidad,  Unidad,  CantidadInventario,  Costo,  FechaRequerida,  Aplica,     AplicaID,     Paquete)
VALUES (@ID, @Renglon, 0,          @RenglonID, @RenglonTipo, @SerieLote,    @Ruta, @Orden, @Centro, @Tipo, @Almacen, @Articulo, @SubCuenta, @Cantidad, @Unidad, @CantidadInventario, @Costo, @FechaRequerida, @AplicaMov, @AplicaMovID, @Paquete)
END
END
END
END

