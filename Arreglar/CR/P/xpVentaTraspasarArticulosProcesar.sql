SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE xpVentaTraspasarArticulosProcesar
@ID		int,
@Estacion	int,
@Usuario	char(10),
@FechaTrabajo	datetime
AS BEGIN
DECLARE
@Sucursal			int,
@Empresa			char(5),
@Moneda			char(10),
@Mov			char(20),
@MovID			varchar(20),
@TipoCambio			float,
@Articulo			char(20),
@ArtTipo			varchar(20),
@RenglonTipo		char(1),
@Cantidad			float,
@Precio			float,
@Costo			float,
@Accion			varchar(20),
@CantidadPendiente		float,
@CantidadSaldo		float,
@CantidadA			float,
@CantidadNueva		float,
@CantidadReservada		float,
@GenerarID			int,
@FechaRegistro		datetime,
@AlmacenDestino		char(10),
@AlmacenOrigen		char(10),
@Unidad			varchar(50),
@Impuesto1			float,
@Referencia			varchar(50),
@OrdenTraspasoID		int,
@OrdenTraspasoMov		char(20),
@SalidaTraspasoID		int,
@SalidaTraspasoMov		char(20),
@SalidaTraspasoMovID 	varchar(20),
@ReciboTraspasoID		int,
@ReciboTraspasoMov		char(20),
@TransitoID			int,
@Ok				int,
@OkRef			varchar(255)
BEGIN TRANSACTION
SELECT @FechaRegistro = GETDATE(), @Ok = NULL, @OkRef = NULL
SELECT @Mov = Mov, @MovID = MovID, @Empresa = Empresa, @Sucursal = Sucursal, @Moneda = Moneda, @TipoCambio = TipoCambio, @AlmacenDestino = Almacen
FROM Venta
WHERE ID = @ID
SELECT @OrdenTraspasoMov = InvOrdenTraspaso, @SalidaTraspasoMov = InvSalidaTraspaso, @ReciboTraspasoMov = InvReciboTraspaso
FROM EmpresaCfgMov
WHERE Empresa = @Empresa
UPDATE VentaD SET CantidadA = NULL WHERE ID = @ID
DECLARE crVentaTraspasarArticulos CURSOR FOR
SELECT t.Articulo, ISNULL(t.Cantidad, 0.0), t.Precio, t.Costo, t.Accion, t.Referencia, a.Tipo, a.Unidad, a.Impuesto1
FROM VentaTraspasarArticulos t
JOIN Art a ON a.Articulo = t.Articulo
WHERE ID = @ID AND Estacion = @Estacion
OPEN crVentaTraspasarArticulos
FETCH NEXT FROM crVentaTraspasarArticulos INTO @Articulo, @Cantidad, @Precio, @Costo, @Accion, @Referencia, @ArtTipo, @Unidad, @Impuesto1
WHILE @@FETCH_STATUS <> -1 AND @@Error = 0
BEGIN
IF @@FETCH_STATUS <> -2
BEGIN
EXEC spRenglonTipo @ArtTipo, NULL, @RenglonTipo OUTPUT
IF @Accion = 'Agregar'
BEGIN
SELECT @GenerarID = NULL, @CantidadNueva = 0.0, @CantidadPendiente = 0.0
SELECT @CantidadPendiente = ISNULL(SUM(CantidadPendiente), 0.0) FROM VentaD WHERE ID = @ID AND Articulo = @Articulo
IF @Cantidad > @CantidadPendiente SELECT @CantidadNueva = @Cantidad - @CantidadPendiente
IF @CantidadNueva > 0.0
BEGIN
EXEC @GenerarID = spMovCopiar @Sucursal, 'VTAS', @ID, @Usuario, @FechaTrabajo, @Sub = 1, @EnSilencio = 1, @Conexion = 1
IF @GenerarID IS NOT NULL
BEGIN
SELECT @Mov = Mov, @MovID = MovID FROM Venta WHERE ID = @GenerarID
INSERT VentaD (ID, Sucursal, Renglon, RenglonID, RenglonTipo, Almacen, Articulo, Unidad, Cantidad, Costo, Precio, Impuesto1)
VALUES (@GenerarID, @Sucursal, 2048.0, 1, @RenglonTipo, @AlmacenDestino, @Articulo, @Unidad, @CantidadNueva, @Costo, @Precio, @Impuesto1)
EXEC spAfectar 'VTAS', @GenerarID, 'AFECTAR', 'TODO', NULL, @Usuario, @EnSilencio = 1, @Ok = @Ok OUTPUT, @OkRef = @OkRef OUTPUT, @Conexion = 1
END
END
END
IF @Accion = 'Cancelar'
BEGIN
SELECT @CantidadSaldo = @Cantidad
DECLARE crVentaD CURSOR LOCAL FOR
SELECT CantidadReservada
FROM VentaD
WHERE ID = @ID AND Articulo = @Articulo
OPEN crVentaD
FETCH NEXT FROM crVentaD INTO @CantidadReservada
WHILE @@FETCH_STATUS <> -1 AND @@Error = 0 AND @CantidadSaldo > 0.0
BEGIN
IF @@FETCH_STATUS <> -2
BEGIN
IF @CantidadReservada > @CantidadSaldo SELECT @CantidadA = @CantidadSaldo ELSE SELECT @CantidadA = @CantidadReservada
IF ISNULL(@CantidadA, 0.0) > 0.0
BEGIN
UPDATE VentaD SET CantidadA = @CantidadA WHERE CURRENT OF crVentaD
SELECT @CantidadSaldo = @CantidadSaldo - @CantidadA
END
END
FETCH NEXT FROM crVentaD INTO @CantidadReservada
END
CLOSE crVentaD
DEALLOCATE crVentaD
EXEC spAfectar 'VTAS', @ID, 'CANCELAR', 'SELECCION', NULL, @Usuario, @EnSilencio = 1, @Ok = @Ok OUTPUT, @OkRef = @OkRef OUTPUT, @Conexion = 1
SELECT @Cantidad = @Cantidad - ISNULL(@CantidadSaldo, 0.0)
IF ISNULL(@Cantidad, 0.0) > 0.0 AND @Ok IS NULL
BEGIN
EXEC spArtAlmacenOrigenOT @Empresa, @Articulo, @AlmacenDestino, @AlmacenOrigen OUTPUT
INSERT Inv (OrigenTipo, Origen, OrigenID, UltimoCambio,  Sucursal, Empresa, Usuario,  Estatus,     Mov,                FechaEmision,  Almacen,         AlmacenDestino,  Proyecto, Moneda, TipoCambio, Referencia,  Observaciones, FechaRequerida)
SELECT 'VTAS',     Mov,    MovID,    GETDATE(),     @Sucursal, Empresa, Usuario, 'SINAFECTAR', @SalidaTraspasoMov, @FechaTrabajo, @AlmacenDestino, @AlmacenOrigen,  Proyecto, Moneda, TipoCambio, @Referencia, Observaciones, FechaRequerida
FROM Venta
WHERE ID = @ID
SELECT @SalidaTraspasoID = SCOPE_IDENTITY()
INSERT InvD (ID, Sucursal, Renglon, RenglonID, RenglonTipo, Articulo, Unidad, Cantidad, Costo, Precio, Almacen)
VALUES (@SalidaTraspasoID, @Sucursal, 2048.0, 1, @RenglonTipo, @Articulo, @Unidad, @Cantidad, @Costo, @Precio, @AlmacenDestino)
EXEC @TransitoID = spAfectar 'INV', @SalidaTraspasoID, 'AFECTAR', 'TODO', NULL, @Usuario, @EnSilencio = 1, @Ok = @Ok OUTPUT, @OkRef = @OkRef OUTPUT, @Conexion = 1
IF @Ok = 80030 SELECT @Ok = NULL, @OkRef = NULL
IF @TransitoID IS NOT NULL AND @Ok IS NULL
BEGIN
SELECT @SalidaTraspasoMovID = MovID FROM Inv WHERE ID = @SalidaTraspasoID
EXEC spMovFlujo @Sucursal, 'AFECTAR', @Empresa, 'VTAS', @ID, @Mov, @MovID, 'INV', @SalidaTraspasoID, @SalidaTraspasoMov, @SalidaTraspasoMovID, @Ok OUTPUT
EXEC @ReciboTraspasoID = spAfectar 'INV', @TransitoID, 'GENERAR', 'PENDIENTE', @ReciboTraspasoMov, @Usuario, @EnSilencio = 1, @Ok = @Ok OUTPUT, @OkRef = @OkRef OUTPUT, @Conexion = 1
IF @Ok = 80030 SELECT @Ok = NULL, @OkRef = NULL
IF @ReciboTraspasoID IS NOT NULL AND @Ok IS NULL
BEGIN
EXEC spAfectar 'INV', @ReciboTraspasoID, 'AFECTAR', 'TODO', NULL, @Usuario, @EnSilencio = 1, @Ok = @Ok OUTPUT, @OkRef = @OkRef OUTPUT, @Conexion = 1
IF @Ok = 80030 SELECT @Ok = NULL, @OkRef = NULL
END
END
END
END
END
FETCH NEXT FROM crVentaTraspasarArticulos INTO @Articulo, @Cantidad, @Precio, @Costo, @Accion, @Referencia, @ArtTipo, @Unidad, @Impuesto1
END
CLOSE crVentaTraspasarArticulos
DEALLOCATE crVentaTraspasarArticulos
IF @Accion = 'Agregar'
BEGIN
IF EXISTS(SELECT * FROM VentaD WHERE ID = @ID AND ISNULL(CantidadPendiente, 0.0) > 0.0)
BEGIN
EXEC @OrdenTraspasoID = spPedidoGenerarOT @Empresa, @ID, @Sucursal, @Usuario, @OrdenTraspasoMov, @EnSilencio = 1
IF @OrdenTraspasoID IS NOT NULL
BEGIN
EXEC spAfectar 'INV', @OrdenTraspasoID, 'RESERVAR', 'PENDIENTE', NULL, @Usuario, @EnSilencio = 1, @Ok = @Ok OUTPUT, @OkRef = @OkRef OUTPUT, @Conexion = 1
IF @Ok = 80030 SELECT @Ok = NULL, @OkRef = NULL
IF @Ok IS NULL
EXEC @SalidaTraspasoID = spAfectar 'INV', @OrdenTraspasoID, 'GENERAR', 'RESERVADO', @SalidaTraspasoMov, @Usuario, @EnSilencio = 1, @Ok = @Ok OUTPUT, @OkRef = @OkRef OUTPUT, @Conexion = 1
IF @Ok = 80030 SELECT @Ok = NULL, @OkRef = NULL
IF EXISTS(SELECT * FROM InvD WHERE ID = @SalidaTraspasoID) AND @Ok IS NULL
BEGIN
EXEC @TransitoID = spAfectar 'INV', @SalidaTraspasoID, 'AFECTAR', 'TODO', NULL, @Usuario, @EnSilencio = 1, @Ok = @Ok OUTPUT, @OkRef = @OkRef OUTPUT, @Conexion = 1
IF @Ok = 80030 SELECT @Ok = NULL, @OkRef = NULL
IF @TransitoID IS NOT NULL AND @Ok IS NULL
BEGIN
EXEC @ReciboTraspasoID = spAfectar 'INV', @TransitoID, 'GENERAR', 'PENDIENTE', @ReciboTraspasoMov, @Usuario, @EnSilencio = 1, @Ok = @Ok OUTPUT, @OkRef = @OkRef OUTPUT, @Conexion = 1
IF @Ok = 80030 SELECT @Ok = NULL, @OkRef = NULL
IF @ReciboTraspasoID IS NOT NULL AND @Ok IS NULL
BEGIN
DECLARE crReciboTraspaso CURSOR FOR
SELECT Articulo, Costo
FROM InvD
WHERE ID = @ReciboTraspasoID
OPEN crReciboTraspaso
FETCH NEXT FROM crReciboTraspaso INTO @Articulo, @Costo
WHILE @@FETCH_STATUS <> -1 AND @@Error = 0  AND @Ok IS NULL
BEGIN
IF @@FETCH_STATUS <> -2
BEGIN
SELECT @Costo = NULL
SELECT @Costo = MIN(Costo) FROM VentaTraspasarArticulos WHERE ID = @ID AND Estacion = @Estacion AND Articulo = @Articulo
IF @Costo IS NOT NULL
UPDATE InvD SET Costo = @Costo WHERE CURRENT OF crReciboTraspaso
END
FETCH NEXT FROM crReciboTraspaso INTO @Articulo, @Costo
END
CLOSE crReciboTraspaso
DEALLOCATE crReciboTraspaso
IF @Ok IS NULL
EXEC spAfectar 'INV', @ReciboTraspasoID, 'AFECTAR', 'TODO', NULL, @Usuario, @EnSilencio = 1, @Ok = @Ok OUTPUT, @OkRef = @OkRef OUTPUT, @Conexion = 1
IF @Ok = 80030 SELECT @Ok = NULL, @OkRef = NULL
END
END
END ELSE
DELETE Inv WHERE ID = @SalidaTraspasoID
END
END
END
IF @Ok IS NULL
BEGIN
DELETE VentaTraspasarArticulos WHERE ID = @ID AND Estacion = @Estacion
COMMIT TRANSACTION
SELECT 'Se Proceso con Exito el Traspaso'
END ELSE
BEGIN
ROLLBACK TRANSACTION
SELECT Descripcion + ' ' + ISNULL(RTRIM(@OkRef), '') FROM MensajeLista WHERE Mensaje = @Ok
END
RETURN
END

