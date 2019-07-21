SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spPedidoGenerarINV_OTm
@Empresa			char(5),
@ID				int,
@Sucursal			int,
@Usuario			char(10),
@InvMov			char(20),
@Almacen			char(10),
@AlmacenDestino		char(10),
@BackOrdersMovimiento	bit

AS BEGIN
DECLARE
@Mov		char(20),
@MovID		varchar(20),
@InvID		int,
@InvMovID		varchar(20),
@Articulo		char(20),
@SubCuenta		varchar(50),
@DestinoTipo 	char(10),
@Destino	 	char(20),
@DestinoID	 	char(20),
@FechaRegistro	datetime,
@Ok			int,
@OkRef		varchar(255)
SELECT @DestinoTipo = NULL, @Destino = NULL, @DestinoID = NULL, @FechaRegistro = GETDATE(), @Ok = NULL, @OkRef = NULL
IF @BackOrdersMovimiento = 1
SELECT @DestinoTipo = 'VTAS', @Destino = Mov, @DestinoID = MovID
FROM Venta
WHERE ID = @ID
BEGIN TRANSACTION
SELECT @Mov = Mov, @MovID = MovID FROM Venta WHERE ID = @ID
INSERT Inv (OrigenTipo, Origen, OrigenID, UltimoCambio,  Sucursal,  Empresa, Usuario,  Estatus,     Mov,     FechaEmision, Almacen,  AlmacenDestino,  Proyecto, Moneda, TipoCambio, Referencia, Observaciones, FechaRequerida, VerDestino)
SELECT 'VTAS',      Mov,    MovID,    GETDATE(),     @Sucursal, Empresa, Usuario, 'SINAFECTAR', @InvMov, FechaEmision, @Almacen, @AlmacenDestino, Proyecto, Moneda, TipoCambio, Referencia, Observaciones, FechaRequerida, @BackOrdersMovimiento
FROM Venta
WHERE ID = @ID
SELECT @InvID = SCOPE_IDENTITY()
INSERT InvD (Sucursal,  ID,     Renglon,   RenglonSub,   RenglonID,   RenglonTipo,    Articulo,   SubCuenta,   Cantidad,            Unidad,   Precio,   CantidadInventario,                                             Almacen,   FechaRequerida,   DestinoTipo,  Destino,  DestinoID,  DescripcionExtra)
SELECT @Sucursal, @InvID, d.Renglon, d.RenglonSub, d.RenglonID, ot.RenglonTipo, d.Articulo, d.SubCuenta, d.CantidadPendiente, d.Unidad, d.Precio, d.CantidadPendiente*d.CantidadInventario/NULLIF(d.Cantidad, 0), ot.Origen, d.FechaRequerida, @DestinoTipo, @Destino, @DestinoID, d.DescripcionExtra
FROM VentaD d, Venta v, #GenerarOT ot
WHERE v.ID = @ID AND d.ID = v.ID AND d.Renglon = ot.Renglon AND d.RenglonSub = ot.RenglonSub
AND /*ot.Origen = @Almacen AND */ot.Destino = @AlmacenDestino
COMMIT TRANSACTION
EXEC spInv @InvID, 'INV', 'AFECTAR', 'TODO', @FechaRegistro, NULL, @Usuario, 0, 0, NULL,
@InvMov, @InvMovID OUTPUT, NULL, NULL,
@Ok OUTPUT, @OkRef OUTPUT, NULL
EXEC spMovFlujo @Sucursal, 'AFECTAR', @Empresa, 'VTAS', @ID, @Mov, @MovID, 'INV', @InvID, @InvMov, @InvMovID, @Ok OUTPUT
RETURN
END

