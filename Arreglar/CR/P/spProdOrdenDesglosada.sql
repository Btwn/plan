SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spProdOrdenDesglosada
@Sucursal		int,
@Empresa		char(5),
@Usuario		char(10),
@AutoReservar		bit,
@GenerarOrdenConsumo	bit,
@InvMov			char(20),
@Almacen		char(10),
@AlmacenDestino		char(10),
@Modulo			char(5),
@ID			int,
@Mov			char(20),
@MovID			varchar(20),
@FechaEmision		datetime,
@FechaRegistro		datetime,
@CfgMultiUnidades	bit,
@CfgMultiUnidadesNivel	char(20),
@Ok             	int          OUTPUT,
@OkRef          	varchar(255) OUTPUT

AS BEGIN
DECLARE
@Accion			 char(20),
@Estatus			 char(15),
@Producto			 char(20),
@SubProducto		 varchar(50),
@Articulo			 char(20),
@SubCuenta			 varchar(50),
@Ruta			 varchar(20),
@Cantidad			 float,
@Unidad			 varchar(50),
@CantidadInventario		 float,
@Lote		 	 varchar(50),
@Factor			 float,
@ArtTipo			 char(20),
@ArtTipoOpcion		 char(20),
@ArtSeProduce		 bit,
@ArtImpuesto1		 float,
@ArtImpuesto2		 float,
@ArtImpuesto3		 money,
@Merma			 float,
@Desperdicio		 float,
@InvID			 int,
@InvMovID			 varchar(20),
@InvEstatus		 	 char(15),
@Renglon			 float,
@RenglonID			 int,
@RenglonSub			 int,
@Costo			 money,
@FechaRequerida		 datetime,
@IDGenerar			 int,
@ContID			 int,
@VolverAfectar		 bit,
@RenglonTipo		 char(1),
@DetalleTipo		 varchar(20)
SELECT @Estatus = 'SINAFECTAR', @DetalleTipo = NULL
IF @GenerarOrdenConsumo = 1
SELECT @DetalleTipo = 'Salida'
INSERT Inv (Sucursal,  OrigenTipo, Origen,  OrigenID, Empresa,   Usuario,  Estatus,  Mov,     FechaEmision,  Proyecto,   Moneda,   TipoCambio,   Referencia,   Observaciones,   Prioridad,   Almacen,  AlmacenDestino,  VerLote)
SELECT @Sucursal, @Modulo,    p.Mov,   p.MovID,  p.Empresa, @Usuario, @Estatus, @InvMov, @FechaEmision, p.Proyecto, p.Moneda, m.TipoCambio, p.Referencia, p.Observaciones, p.Prioridad, @Almacen, @AlmacenDestino, 1
FROM Prod p, Mon m
WHERE m.Moneda = p.Moneda AND p.ID = @ID
SELECT @InvID = SCOPE_IDENTITY()
SELECT @Renglon = 0.0, @RenglonID = 0
IF @GenerarOrdenConsumo = 1
DECLARE crProdExp CURSOR FOR
SELECT Producto, SubProducto, Lote, Articulo, SubCuenta, Unidad, FechaRequerida, Cantidad, Factor, Merma, Desperdicio
FROM ProdProgramaMaterial
WHERE ID = @ID AND AlmacenDestino = @Almacen
ORDER BY Lote, Articulo, SubCuenta, Unidad, FechaRequerida, Producto, SubProducto
ELSE
DECLARE crProdExp CURSOR FOR
SELECT Producto, SubProducto, Lote, Articulo, SubCuenta, Unidad, FechaRequerida, Cantidad, Factor, Merma, Desperdicio
FROM ProdProgramaMaterial
WHERE ID = @ID AND AlmacenOrigen = @Almacen AND AlmacenDestino = @AlmacenDestino
ORDER BY Lote, Articulo, SubCuenta, Unidad, FechaRequerida, Producto, SubProducto
OPEN crProdExp
FETCH NEXT FROM crProdExp INTO @Producto, @SubProducto, @Lote, @Articulo, @SubCuenta, @Unidad, @FechaRequerida, @Cantidad, @Factor, @Merma, @Desperdicio
WHILE @@FETCH_STATUS <> -1 AND @Ok IS NULL AND ISNULL(@Cantidad, 0) <> 0
BEGIN
IF @@FETCH_STATUS <> -2 AND @Ok IS NULL
BEGIN
EXEC xpCantidadInventario @Articulo, @SubCuenta, @Unidad, @CfgMultiUnidades, @CfgMultiUnidadesNivel, @Cantidad, @CantidadInventario OUTPUT
SELECT @ArtTipo       = Tipo,
@ArtTipoOpcion = TipoOpcion,
@ArtSeProduce  = SeProduce,
@ArtImpuesto1  = Impuesto1,
@ArtImpuesto2  = Impuesto2,
@ArtImpuesto3  = Impuesto3
FROM Art
WHERE Articulo = @Articulo
EXEC spRenglonTipo @ArtTipo, @SubCuenta, @RenglonTipo OUTPUT
SELECT @Renglon = @Renglon + 2048.0, @RenglonID = @RenglonID + 1
INSERT InvD (Sucursal,  ID,      Renglon, RenglonSub, RenglonID,  RenglonTipo,  Almacen,  Producto,  SubProducto,  ProdSerieLote,  Articulo,  SubCuenta,  Cantidad,  Merma,  Desperdicio,  Unidad,  CantidadInventario, Factor,  FechaRequerida,  Tipo)
VALUES (@Sucursal, @InvID, @Renglon, 0,          @RenglonID, @RenglonTipo, @Almacen, @Producto, @SubProducto, @Lote,          @Articulo, @SubCuenta, @Cantidad, @Merma, @Desperdicio, @Unidad, @CantidadInventario, @Factor, @FechaRequerida, @DetalleTipo)
IF @ArtTipoOpcion <> 'NO' AND NULLIF(RTRIM(@SubCuenta), '') IS NULL AND EXISTS(SELECT * FROM ArtOpcion WHERE Articulo = @Articulo AND Requerido = 1) SELECT @Ok = 20730, @OkRef = @Articulo
IF @ArtTipoOpcion =  'NO' AND NULLIF(RTRIM(@SubCuenta), '') IS NOT NULL SELECT @Ok = 20740, @OkRef = @Articulo
END
FETCH NEXT FROM crProdExp INTO @Producto, @SubProducto, @Lote, @Articulo, @SubCuenta, @Unidad, @FechaRequerida, @Cantidad, @Factor, @Merma, @Desperdicio
END
CLOSE crProdExp
DEALLOCATE crProdExp
IF @RenglonID > 0
BEGIN
UPDATE Inv SET RenglonID = @RenglonID WHERE ID = @InvID
IF @AutoReservar = 1 SELECT @Accion = 'RESERVARPARCIAL' ELSE SELECT @Accion = 'AFECTAR'
IF @Ok IS NULL
EXEC spInv @InvID, 'INV', @Accion, 'TODO', @FechaRegistro, NULL, @Usuario, 1, 0, NULL,
@InvMov OUTPUT, @InvMovID OUTPUT, @IDGenerar OUTPUT, @ContID OUTPUT,
@Ok OUTPUT, @OkRef OUTPUT, @VolverAfectar
IF @Ok = 80060 SELECT @Ok = NULL, @OkRef = NULL
EXEC spMovFlujo @Sucursal, @Accion, @Empresa, @Modulo, @ID, @Mov, @MovID, 'INV', @InvID, @InvMov, @InvMovID, @Ok OUTPUT
END ELSE
DELETE Inv WHERE ID = @InvID
RETURN
END

