SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spProdAutoAfectarConsumos
@Sucursal		int,
@Empresa		char(5),
@Accion		char(20),
@FechaEmision	datetime,
@FechaRegistro	datetime,
@Usuario		char(10),
@AvanceID		int,
@AvanceMov		char(20),
@AvanceMovID		varchar(20),
@OPID		int,
@OPMov		char(20),
@OPMovID		varchar(20),
@Centro      	char(10),
@ProdSerieLote      	varchar(50),
@Producto		char(20),
@SubProducto		varchar(50),
@CantidadP		float,
@UnidadP		varchar(50),
@Ok                	int          OUTPUT,
@OkRef             	varchar(255) OUTPUT

AS BEGIN
DECLARE
@CfgAfectarConsumo		bit,
@CfgAfectarConsumoParcial	bit,
@CfgMultiUnidades		bit,
@CfgMultiUnidadesNivel	char(20),
@ConsumoMov			char(20),
@ConsumoMovID		varchar(20),
@AplicaMov			char(20),
@AplicaMovID		varchar(20),
@IDConsumo			int,
@IDAplica			int,
@IDGenerar			int,
@ContID			int,
@VolverAfectar		int,
@Almacen			char(10),
@Articulo			char(20),
@ArtTipo	         	varchar(20),
@SubCuenta			varchar(50),
@Cantidad			float,
@Factor			float,
@Merma			float,
@Desperdicio		float,
@CantidadInventario		float,
@Unidad			varchar(50),
@Renglon			float,
@RenglonID			int,
@RenglonTipo		char(1),
@DetalleTipo		varchar(20)
SELECT @CfgMultiUnidades         = MultiUnidades,
@CfgMultiUnidadesNivel    = ISNULL(UPPER(NivelFactorMultiUnidad), 'UNIDAD'),
@CfgAfectarConsumo        = ProdAfectarConsumo,
@CfgAfectarConsumoParcial = ProdAfectarConsumoParcial
FROM EmpresaCfg2
WHERE Empresa = @Empresa
IF @CfgAfectarConsumo = 0 RETURN
SELECT @ConsumoMov = ProdConsumoMaterial
FROM EmpresaCfgMov
WHERE Empresa = @Empresa
IF @Accion = 'CANCELAR'
BEGIN
SELECT @IDConsumo = NULL
SELECT @IDConsumo = ID, @ConsumoMov = Mov, @ConsumoMovID = MovID
FROM Inv
WHERE OrigenTipo = 'PROD' AND Origen = @AvanceMov AND OrigenID = @AvanceMovID AND Estatus = 'CONCLUIDO'
IF @IDConsumo IS NOT NULL
BEGIN
EXEC spInv @IDConsumo, 'INV', 'CANCELAR', 'TODO', @FechaRegistro, NULL, @Usuario, 1, 0, NULL,
@ConsumoMov, @ConsumoMovID OUTPUT, @IDGenerar, @ContID,
@Ok OUTPUT, @OkRef OUTPUT, @VolverAfectar OUTPUT
EXEC spMovFlujo @Sucursal, @Accion, @Empresa, 'PROD', @AvanceID, @AvanceMov, @AvanceMovID, 'INV', @IDConsumo, @ConsumoMov, @ConsumoMovID, @Ok OUTPUT
END
RETURN
END
SELECT @Almacen = Almacen FROM Centro WHERE Centro = @Centro
SELECT @IDAplica = NULL
SELECT @IDAplica = MIN(i.ID)
FROM Inv i, MovTipo mt
WHERE i.OrigenTipo = 'PROD' AND i.Origen = @OPMov AND i.OrigenID = @OPMovID
AND mt.Modulo = 'INV' AND mt.Mov = i.Mov AND mt.Clave = 'INV.SM'
AND i.Almacen = @Almacen AND i.Estatus = 'PENDIENTE'
IF @IDAplica IS NULL RETURN
SELECT @AplicaMov = Mov, @AplicaMovID = MovID
FROM Inv
WHERE ID = @IDAplica
SELECT @DetalleTipo = 'Salida', @Renglon = 0.0, @RenglonID = 0
INSERT Inv (OrigenTipo, Origen,      OrigenID,     Empresa,  Usuario,  Estatus,      Mov,         FechaEmision,  Proyecto,   Moneda,   TipoCambio,   Referencia,   Observaciones,   Prioridad,   Almacen,   Directo, VerLote, Sucursal)
SELECT 'PROD',     @AvanceMov,  @AvanceMovID, @Empresa, @Usuario, 'SINAFECTAR', @ConsumoMov, @FechaEmision, i.Proyecto, i.Moneda, m.TipoCambio, i.Referencia, i.Observaciones, i.Prioridad, i.Almacen, 0, 1, @Sucursal
FROM Inv i, Mon m
WHERE m.Moneda = i.Moneda AND i.ID = @IDAplica
SELECT @IDConsumo = SCOPE_IDENTITY()
DECLARE crConsumo CURSOR FOR
SELECT p.Articulo, p.SubCuenta, CASE WHEN @CfgAfectarConsumoParcial = 1 THEN (p.Cantidad/p.CantidadP)*@CantidadP ELSE p.Cantidad END, p.Unidad, p.Factor, (p.Merma/p.CantidadP)*@CantidadP, (p.Desperdicio/p.CantidadP)*@CantidadP
FROM ProdProgramaMaterial p
LEFT OUTER JOIN ArtMaterial a ON p.Producto = a.Articulo AND p.Articulo = a.Material AND ISNULL(p.Subcuenta,'') = ISNULL(a.Subcuenta, '') AND p.AlmacenOrigen = a.almacen
WHERE p.ID = @OPID AND p.AlmacenDestino = @Almacen AND p.Lote = @ProdSerieLote AND p.Producto = @Producto AND p.SubProducto = @SubProducto AND p.UnidadP = @UnidadP
AND ISNULL(a.Centro,@Centro) = @Centro
OPEN crConsumo
FETCH NEXT FROM crConsumo INTO @Articulo, @SubCuenta, @Cantidad, @Unidad, @Factor, @Merma, @Desperdicio
WHILE @@FETCH_STATUS <> -1 AND @Ok IS NULL AND ISNULL(@Cantidad, 0) <> 0
BEGIN
IF @@FETCH_STATUS <> -2 AND @Ok IS NULL
BEGIN
EXEC xpCantidadInventario @Articulo, @SubCuenta, @Unidad, @CfgMultiUnidades, @CfgMultiUnidadesNivel, @Cantidad, @CantidadInventario OUTPUT
SELECT @ArtTipo = Tipo
FROM Art
WHERE Articulo = @Articulo
EXEC spRenglonTipo @ArtTipo, @SubCuenta, @RenglonTipo OUTPUT
SELECT @Renglon = @Renglon + 2048.0, @RenglonID = @RenglonID + 1
INSERT InvD (ID,         Renglon,  RenglonSub, RenglonID,  RenglonTipo,  Aplica,     AplicaID,     Almacen,  Producto,  SubProducto,  ProdSerieLote,  Articulo,  SubCuenta,  Cantidad,  Merma,  Desperdicio,  Unidad,  CantidadInventario, Factor,  Tipo)
VALUES (@IDConsumo, @Renglon, 0,          @RenglonID, @RenglonTipo, @AplicaMov, @AplicaMovID, @Almacen, @Producto, @SubProducto, @ProdSerieLote, @Articulo, @SubCuenta, @Cantidad, @Merma, @Desperdicio, @Unidad, @CantidadInventario, @Factor, @DetalleTipo)
END
FETCH NEXT FROM crConsumo INTO @Articulo, @SubCuenta, @Cantidad, @Unidad, @Factor, @Merma, @Desperdicio
END
CLOSE crConsumo
DEALLOCATE crConsumo
IF @Renglon = 0
DELETE Inv WHERE ID = @IDConsumo
ELSE
BEGIN
EXEC spInv @IDConsumo, 'INV', 'AFECTAR', 'TODO', @FechaRegistro, NULL, @Usuario, 1, 0, NULL,
@ConsumoMov, @ConsumoMovID OUTPUT, @IDGenerar, @ContID,
@Ok OUTPUT, @OkRef OUTPUT, @VolverAfectar OUTPUT
EXEC spMovFlujo @Sucursal, @Accion, @Empresa, 'PROD', @AvanceID, @AvanceMov, @AvanceMovID, 'INV', @IDConsumo, @ConsumoMov, @ConsumoMovID, @Ok OUTPUT
END
RETURN
END

