SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spCompraGarantiaCostos
@ID		int

AS BEGIN
DECLARE
@Empresa			char(5),
@Proveedor			char(10),
@FechaRegistro		datetime,
@FechaEmision		datetime,
@Directo			bit,
@Usuario			char(10),
@GarantiaCostos		bit,
@GarantiaCostosPlazo	float,
@CompraPerdidaID		int,
@CompraPerdidaMov		char(20),
@CompraPerdidaMovID		varchar(20),
@AplicaID			int,
@AplicaMov			varchar(20),
@AplicaMovID		varchar(20),
@AplicaRenglon		float,
@AplicaRenglonSub		int,
@AplicaCantidad		float,
@AplicaCantidadInventario	float,
@AplicaCosto		float,
@Renglon			float,
@RenglonSub			int,
@RenglonID			int,
@Articulo			char(20),
@SubCuenta			varchar(50),
@Cantidad			float,
@CantidadInventario		float,
@Costo			float,
@Ok				int,
@OkRef			varchar(255),
@Mensaje			varchar(255)
SELECT @Mensaje = NULL, @Ok = NULL, @OkRef = NULL, @CompraPerdidaID = NULL, @FechaRegistro = GETDATE()
SELECT @Directo = Directo, @Empresa = Empresa, @Proveedor = Proveedor, @FechaEmision = FechaEmision, @Usuario = Usuario
FROM Compra
WHERE ID = @ID
SELECT @GarantiaCostos      = ISNULL(GarantiaCostos, 0),
@GarantiaCostosPlazo = ISNULL(GarantiaCostosPlazo, 0)
FROM Prov
WHERE Proveedor = @Proveedor
IF @GarantiaCostos = 1
BEGIN
BEGIN TRANSACTION
SELECT @Renglon = 0.0, @RenglonID = 0
SELECT @CompraPerdidaMov = CompraPerdida
FROM EmpresaCfgMov
WHERE Empresa = @Empresa
DECLARE crCompraPendiente CURSOR FOR
SELECT e.ID, e.Mov, e.MovID, d.Renglon, d.RenglonSub
FROM CompraD d
JOIN Compra e ON e.ID = d.ID AND e.Empresa = @Empresa AND e.Estatus = 'PENDIENTE' AND DATEADD(day, @GarantiaCostosPlazo, e.FechaEmision) < @FechaEmision
JOIN MovTipo mt ON mt.Modulo = 'COMS' AND mt.Mov = e.Mov AND mt.Clave = 'COMS.O'
WHERE ISNULL(d.CantidadPendiente, 0) > 0
OPEN crCompraPendiente
FETCH NEXT FROM crCompraPendiente INTO @AplicaID, @AplicaMov, @AplicaMovID, @AplicaRenglon, @AplicaRenglonSub
WHILE @@FETCH_STATUS <> -1 AND @Ok IS NULL
BEGIN
IF @@FETCH_STATUS <> -2 AND @Ok IS NULL
BEGIN
IF @CompraPerdidaID IS NULL
BEGIN
INSERT Compra (
Sucursal, Empresa, Mov,               Estatus,      FechaEmision, Moneda, TipoCambio, Usuario, Almacen, Proveedor)
SELECT Sucursal, Empresa, @CompraPerdidaMov, 'SINAFECTAR', FechaEmision, Moneda, TipoCambio, Usuario, Almacen, Proveedor
FROM Compra
WHERE ID = @ID
SELECT @CompraPerdidaID = SCOPE_IDENTITY()
END
SELECT @Renglon = @Renglon + 2048.0, @RenglonID = @RenglonID + 1
INSERT CompraD (
ID,               Renglon,  RenglonID,  RenglonTipo, Impuesto1, Impuesto2, Impuesto3, Almacen, Articulo, SubCuenta, Cantidad,          Unidad, CantidadInventario,                                         Costo, FechaRequerida, Aplica,     AplicaID,     Paquete)
SELECT @CompraPerdidaID, @Renglon, @RenglonID, RenglonTipo, Impuesto1, Impuesto2, Impuesto3, Almacen, Articulo, SubCuenta, CantidadPendiente, Unidad, CantidadPendiente*CantidadInventario/NULLIF(Cantidad, 0.0), Costo, FechaRequerida, @AplicaMov, @AplicaMovID, Paquete
FROM CompraD
WHERE ID = @AplicaID AND Renglon = @AplicaRenglon AND RenglonSub = @AplicaRenglonSub
END
FETCH NEXT FROM crCompraPendiente INTO @AplicaID, @AplicaMov, @AplicaMovID, @AplicaRenglon, @AplicaRenglonSub
END  
CLOSE crCompraPendiente
DEALLOCATE crCompraPendiente
IF @CompraPerdidaID IS NOT NULL
EXEC spInv @CompraPerdidaID, 'COMS', 'AFECTAR', 'TODO', @FechaRegistro, NULL, @Usuario, 1, 0, NULL,
@CompraPerdidaMov, @CompraPerdidaMovID OUTPUT, NULL, NULL,
@Ok OUTPUT, @OkRef OUTPUT, 0
DECLARE crComprasD CURSOR FOR
SELECT d.Renglon, d.RenglonSub, d.Articulo, d.SubCuenta, ISNULL(d.Cantidad, 0.0), ISNULL(d.CantidadInventario, 0.0), d.Costo
FROM CompraD d
WHERE d.ID = @ID AND d.Aplica IS NULL
OPEN crComprasD
FETCH NEXT FROM crComprasD INTO @Renglon, @RenglonSub, @Articulo, @SubCuenta, @Cantidad, @CantidadInventario, @Costo
WHILE @@FETCH_STATUS <> -1 AND @Ok IS NULL
BEGIN
IF @@FETCH_STATUS <> -2 AND @Ok IS NULL
BEGIN
DECLARE crCompraPendiente CURSOR LOCAL FOR
SELECT e.ID, e.Mov, e.MovID, d.Renglon, d.RenglonSub, ISNULL(d.CantidadPendiente, 0.0), d.Costo
FROM CompraD d
JOIN Compra e ON e.ID = d.ID AND e.Empresa = @Empresa AND e.Estatus = 'PENDIENTE' AND DATEADD(day, @GarantiaCostosPlazo, e.FechaEmision) >= @FechaEmision
JOIN MovTipo mt ON mt.Modulo = 'COMS' AND mt.Mov = e.Mov AND mt.Clave = 'COMS.O'
WHERE d.Articulo = @Articulo AND ISNULL(d.SubCuenta, '') = ISNULL(@SubCuenta, '') AND d.Costo < @Costo AND ISNULL(d.CantidadPendiente, 0) > 0
OPEN crCompraPendiente
FETCH NEXT FROM crCompraPendiente INTO @AplicaID, @AplicaMov, @AplicaMovID, @AplicaRenglon, @AplicaRenglonSub, @AplicaCantidad, @AplicaCosto
WHILE @@FETCH_STATUS <> -1 AND @Cantidad > 0.0 AND @Ok IS NULL
BEGIN
IF @@FETCH_STATUS <> -2 AND @Cantidad > 0.0
BEGIN
IF @AplicaCantidad > @Cantidad SELECT @AplicaCantidad = @Cantidad
SELECT @AplicaCantidadInventario = @AplicaCantidad*@CantidadInventario/NULLIF(@Cantidad, 0.0)
SELECT @AplicaRenglonSub = MAX(RenglonSub) + 1 FROM CompraD WHERE ID = @ID AND Renglon = @Renglon
INSERT CompraD (
ID,  RenglonSub,        Renglon, RenglonID, RenglonTipo, Impuesto1, Impuesto2, Impuesto3, Almacen, Articulo, SubCuenta, Cantidad,        Unidad, CantidadInventario,        Costo,        FechaRequerida, FechaEntrega, Aplica,     AplicaID,     Paquete, Cliente, Retencion1, Retencion2, Retencion3, Descuento, DescuentoTipo, DescuentoLinea, DescuentoImporte, DescripcionExtra, ReferenciaExtra, DestinoTipo, Destino, DestinoID, ContUso)
SELECT @ID, @AplicaRenglonSub, Renglon, RenglonID, RenglonTipo, Impuesto1, Impuesto2, Impuesto3, Almacen, Articulo, SubCuenta, @AplicaCantidad, Unidad, @AplicaCantidadInventario, @AplicaCosto, FechaRequerida, FechaEntrega, @AplicaMov, @AplicaMovID, Paquete, Cliente, Retencion1, Retencion2, Retencion3, Descuento, DescuentoTipo, DescuentoLinea, DescuentoImporte, DescripcionExtra, ReferenciaExtra, DestinoTipo, Destino, DestinoID, ContUso
FROM CompraD
WHERE ID = @ID AND Renglon = @Renglon AND RenglonSub = @RenglonSub
SELECT @Cantidad = @Cantidad - @AplicaCantidad, @CantidadInventario = @CantidadInventario - @AplicaCantidadInventario,
@Directo = 0
IF @Cantidad > 0.0
UPDATE CompraD
SET Cantidad = Cantidad - @AplicaCantidad,
CantidadInventario = CantidadInventario - @AplicaCantidadInventario
WHERE CURRENT OF crComprasD
ELSE
DELETE CompraD
WHERE CURRENT OF crComprasD
END
FETCH NEXT FROM crCompraPendiente INTO @AplicaID, @AplicaMov, @AplicaMovID, @AplicaRenglon, @AplicaRenglonSub, @AplicaCantidad, @AplicaCosto
END  
CLOSE crCompraPendiente
DEALLOCATE crCompraPendiente
END
FETCH NEXT FROM crComprasD INTO @Renglon, @RenglonSub, @Articulo, @SubCuenta, @Cantidad, @CantidadInventario, @Costo
END  
CLOSE crComprasD
DEALLOCATE crComprasD
UPDATE Compra SET Directo = @Directo WHERE ID = @ID AND Directo <> @Directo
IF @Ok IS NULL
COMMIT TRANSACTION
ELSE
ROLLBACK TRANSACTION
END
IF @Ok IS NULL
SELECT @Mensaje = 'Proceso Concluido con Exito.'
ELSE
SELECT @Mensaje = Descripcion+' '+RTRIM(ISNULL(@OkRef, '')) FROM MensajeLista WHERE Mensaje = @Ok
SELECT @Mensaje
END

