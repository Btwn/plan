SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spProdOrdenConcentrada
@Sucursal		int,
@Empresa		char(5),
@Usuario		char(10),
@AutoReservar		bit,
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
@Articulo			 char(20),
@SubCuenta			 varchar(50),
@Ruta			 varchar(20),
@Cantidad			 float,
@Unidad			 varchar(50),
@CantidadInventario		 float,
@ArtTipo			 char(20),
@ArtImpuesto1		 float,
@ArtImpuesto2		 float,
@ArtImpuesto3		 money,
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
@RenglonTipo		 char(1)
INSERT Inv (OrigenTipo, Origen,  OrigenID, Empresa,   Sucursal,  Usuario,  Estatus,      Mov,     FechaEmision,  Proyecto,   Moneda,   TipoCambio,   Referencia,   Observaciones,   Prioridad,   Almacen,  AlmacenDestino)
SELECT @Modulo,    p.Mov,   p.MovID,  p.Empresa, @Sucursal, @Usuario, 'SINAFECTAR', @InvMov, @FechaEmision, p.Proyecto, p.Moneda, m.TipoCambio, p.Referencia, p.Observaciones, p.Prioridad, @Almacen, @AlmacenDestino
FROM Prod p, Mon m
WHERE m.Moneda = p.Moneda AND p.ID = @ID
SELECT @InvID = SCOPE_IDENTITY()
SELECT @Renglon = 0.0, @RenglonID = 0
DECLARE crProdExp CURSOR FOR
SELECT Articulo, SubCuenta, Unidad, FechaRequerida, SUM(Cantidad)
FROM ProdProgramaMaterial
WHERE ID = @ID AND ISNULL(NULLIF(AlmacenOrigen, '(DEMANDA)'), @Almacen) = @Almacen AND AlmacenDestino = @AlmacenDestino
GROUP BY Articulo, SubCuenta, Unidad, FechaRequerida
ORDER BY Articulo, SubCuenta, Unidad, FechaRequerida
OPEN crProdExp
FETCH NEXT FROM crProdExp INTO @Articulo, @SubCuenta, @Unidad, @FechaRequerida, @Cantidad
WHILE @@FETCH_STATUS <> -1 AND @Ok IS NULL AND ISNULL(@Cantidad, 0) <> 0
BEGIN
IF @@FETCH_STATUS <> -2 AND @Ok IS NULL
BEGIN
EXEC xpCantidadInventario @Articulo, @SubCuenta, @Unidad, @CfgMultiUnidades, @CfgMultiUnidadesNivel, @Cantidad, @CantidadInventario OUTPUT
SELECT @ArtTipo       = Tipo,
@ArtImpuesto1  = Impuesto1,
@ArtImpuesto2  = Impuesto2,
@ArtImpuesto3  = Impuesto3
FROM Art
WHERE Articulo = @Articulo
EXEC spRenglonTipo @ArtTipo, @SubCuenta, @RenglonTipo OUTPUT
SELECT @Renglon = @Renglon + 2048.0, @RenglonID = @RenglonID + 1
INSERT InvD (Sucursal,  ID,     Renglon,  RenglonSub, RenglonID,  RenglonTipo,  Almacen,  Articulo,  SubCuenta,  Cantidad,  Unidad,  CantidadInventario,  FechaRequerida)
VALUES (@Sucursal, @InvID, @Renglon, 0,          @RenglonID, @RenglonTipo, @Almacen, @Articulo, @SubCuenta, @Cantidad, @Unidad, @CantidadInventario, @FechaRequerida)
END
FETCH NEXT FROM crProdExp INTO @Articulo, @SubCuenta, @Unidad, @FechaRequerida, @Cantidad
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
EXEC spMovFlujo @Sucursal, @Accion, @Empresa, @Modulo, @ID, @Mov, @MovID, 'INV', @InvID, @InvMov, @InvMovID, @Ok OUTPUT
END ELSE
DELETE Inv WHERE ID = @InvID
RETURN
END

