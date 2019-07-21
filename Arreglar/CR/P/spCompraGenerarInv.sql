SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spCompraGenerarInv
@ID		int,
@Sucursal	int,
@Usuario	char(10),
@Mov	char(20)

AS BEGIN
DECLARE
@CfgMultiUnidades		bit,
@CfgMultiUnidadesNivel	char(20),
@CfgCompraFactorDinamico	bit,
@UnidadCompra		varchar(50),
@UnidadVenta		varchar(50),
@Decimales			int,
@Ok				int,
@FactorCompra		float,
@FactorVenta		float,
@InvID			int,
@Articulo			char(20),
@SubCuenta			varchar(50),
@Moneda			char(10),
@TipoCambio			float,
@Unidad			varchar(50),
@Precio			float,
@Costo			float,
@Cantidad			float,
@CantidadInventario		float
SELECT @Ok = NULL
SELECT @CfgMultiUnidades = cfg.MultiUnidades,
@CfgMultiUnidadesNivel = ISNULL(UPPER(cfg.NivelFactorMultiUnidad), 'UNIDAD'),
@CfgCompraFactorDinamico = CompraFactorDinamico
FROM Compra c, EmpresaCfg2 cfg
WHERE c.ID = @ID AND cfg.Empresa = c.Empresa
BEGIN TRANSACTION
INSERT Inv (UltimoCambio, Sucursal,  Empresa, Usuario,  Estatus,     Mov,  FechaEmision, Almacen, Proyecto, Moneda, TipoCambio, Referencia, Observaciones, RenglonID)
SELECT GETDATE(),     @Sucursal, Empresa, Usuario, 'SINAFECTAR', @Mov, FechaEmision, Almacen, Proyecto, Moneda, TipoCambio, Referencia, Observaciones, RenglonID
FROM Compra
WHERE ID = @ID
SELECT @InvID = SCOPE_IDENTITY()
INSERT InvD (Sucursal,  ID,     Renglon, RenglonSub, RenglonID, RenglonTipo, Articulo, SubCuenta, Cantidad, CantidadInventario, Unidad, Factor, Almacen, Costo)
SELECT @Sucursal, @InvID, Renglon, RenglonSub, RenglonID, RenglonTipo, Articulo, SubCuenta, Cantidad, CantidadInventario, Unidad, Factor, Almacen, SubTotal/NULLIF(Cantidad, 0)
FROM CompraTCalc
WHERE ID = @ID
DECLARE crInvD CURSOR FOR
SELECT d.Articulo, d.SubCuenta, e.Moneda, e.TipoCambio, d.Unidad, a.Unidad, d.Cantidad, ISNULL(d.CantidadInventario, d.Cantidad), d.Costo
FROM InvD d, Inv e, Art a
WHERE d.ID = e.ID AND e.ID = @InvID AND d.Articulo = a.Articulo
OPEN crInvD
FETCH NEXT FROM crInvD INTO @Articulo, @SubCuenta, @Moneda, @TipoCambio, @UnidadCompra, @UnidadVenta, @Cantidad, @CantidadInventario, @Costo
WHILE @@FETCH_STATUS <> -1
BEGIN
IF @@FETCH_STATUS <> -2
BEGIN
SELECT @FactorCompra = 1.0, @FactorVenta = 1.0, @Unidad = @UnidadCompra
IF @CfgMultiUnidades = 1 AND @CfgCompraFactorDinamico = 0
BEGIN
IF @CfgMultiUnidadesNivel = 'ARTICULO'
BEGIN
EXEC xpArtUnidadFactor @Articulo, @SubCuenta, @UnidadCompra, @FactorCompra OUTPUT, @Decimales OUTPUT, @OK OUTPUT
EXEC xpArtUnidadFactor @Articulo, @SubCuenta, @UnidadVenta, @FactorVenta OUTPUT, @Decimales OUTPUT, @OK OUTPUT
END ELSE
BEGIN
EXEC xpUnidadFactor @Articulo, @SubCuenta, @UnidadCompra, @FactorCompra OUTPUT, @Decimales OUTPUT
EXEC xpUnidadFactor @Articulo, @SubCuenta, @UnidadVenta, @FactorVenta OUTPUT, @Decimales OUTPUT
END
IF @FactorCompra <> @FactorVenta
BEGIN
SELECT @Unidad = @UnidadVenta,
@Cantidad = @Cantidad*@FactorCompra/@FactorVenta,
@Costo    = @FactorVenta*@Costo/@FactorCompra
SELECT @CantidadInventario = @Cantidad*@FactorVenta
END
END
EXEC spVerArtPrecioDescuento @Articulo, @SubCuenta, '(Precio Lista)', @Moneda, @TipoCambio, 1, @Precio OUTPUT
UPDATE InvD
SET Unidad = @Unidad, Cantidad = @Cantidad, CantidadInventario = @CantidadInventario, Costo = @Costo, Precio = @Precio
WHERE CURRENT OF crInvD
END
FETCH NEXT FROM crInvD INTO @Articulo, @SubCuenta, @Moneda, @TipoCambio, @UnidadCompra, @UnidadVenta, @Cantidad, @CantidadInventario, @Costo
END 
CLOSE crInvD
DEALLOCATE crInvD
COMMIT TRANSACTION
RETURN
END

