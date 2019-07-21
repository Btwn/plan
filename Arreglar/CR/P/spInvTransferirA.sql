SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spInvTransferirA
@Empresa		char(5),
@Sucursal		int,
@Usuario		char(10),
@Accion		char(20),
@Modulo		char(5),
@ID          	int,
@Mov			char(20),
@MovID		varchar(20),
@FechaEmision	datetime,
@FechaRegistro	datetime,
@Ok			int		OUTPUT,
@OkRef		varchar(255)	OUTPUT

AS BEGIN
DECLARE
@InvID		int,
@InvMov		varchar(20),
@InvMovID		varchar(20),
@Almacen		varchar(10),
@AlmacenDestino	varchar(10)
SELECT @InvMov = InvTransferencia
FROM EmpresaCfgMov
WHERE Empresa = @Empresa
IF @Accion = 'CANCELAR'
BEGIN
DECLARE crCancelarTransferirA CURSOR LOCAL FOR
SELECT ID, Mov, MovID
FROM Inv
WHERE Empresa = @Empresa AND OrigenTipo = @Modulo AND Origen = @Mov AND OrigenID = @MovID AND Estatus IN ('PENDIENTE', 'CONCLUIDO')
OPEN crCancelarTransferirA
FETCH NEXT FROM crCancelarTransferirA INTO @InvID, @InvMov, @InvMovID
WHILE @@FETCH_STATUS <> -1 AND @Ok IS NULL
BEGIN
IF @@FETCH_STATUS <> -2
BEGIN
EXEC spAfectar 'INV', @InvID, 'CANCELAR', 'TODO', @Usuario = @Usuario, @EnSilencio = 1, @Ok = @Ok OUTPUT, @OkRef = @OkRef OUTPUT, @FechaRegistro = @FechaRegistro, @Conexion = 1
EXEC spMovFlujo @Sucursal, 'CANCELAR', @Empresa, @Modulo, @ID, @Mov, @MovID, 'INV', @InvID, @InvMov, @InvMovID, @Ok OUTPUT
END
FETCH NEXT FROM crCancelarTransferirA INTO @InvID, @InvMov, @InvMovID
END
CLOSE crCancelarTransferirA
DEALLOCATE crCancelarTransferirA
END ELSE
BEGIN
IF @Modulo = 'VTAS'
BEGIN
DECLARE crTransferirA CURSOR LOCAL FOR
SELECT DISTINCT Almacen, TransferirA
FROM VentaD
WHERE ID = @ID AND ISNULL(NULLIF(RTRIM(TransferirA), ''), Almacen) <> Almacen
OPEN crTransferirA
FETCH NEXT FROM crTransferirA INTO @Almacen, @AlmacenDestino
WHILE @@FETCH_STATUS <> -1 AND @Ok IS NULL
BEGIN
IF @@FETCH_STATUS <> -2
BEGIN
INSERT Inv (
Empresa,  Sucursal,  Mov,     Almacen,  AlmacenDestino,  FechaEmision,  Concepto, Referencia, Proyecto, UEN, Usuario, Estatus,       Moneda, TipoCambio, OrigenTipo, Origen, OrigenID)
SELECT @Empresa, @Sucursal, @InvMov, @Almacen, @AlmacenDestino, @FechaEmision, Concepto, Referencia, Proyecto, UEN, @Usuario, 'SINAFECTAR', Moneda, TipoCambio, @Modulo,    @Mov,   @MovID
FROM Venta
WHERE ID = @ID
SELECT @InvID = SCOPE_IDENTITY()
INSERT InvD (
ID,     Renglon, RenglonSub, Sucursal, Almacen, Articulo, SubCuenta, Cantidad, Unidad, Factor)
SELECT @InvID, Renglon, RenglonSub, Sucursal, Almacen, Articulo, SubCuenta, Cantidad, Unidad, Factor
FROM VentaD
WHERE ID = @ID AND Almacen = @Almacen AND TransferirA = @AlmacenDestino
INSERT SerieLoteMov (
Sucursal,  Empresa,   Modulo, ID,     RenglonID,   Articulo,   SubCuenta,   SerieLote,   Cantidad)
SELECT @Sucursal, m.Empresa, 'INV',  @InvID, m.RenglonID, m.Articulo, m.SubCuenta, m.SerieLote, m.Cantidad
FROM SerieLoteMov m
JOIN VentaD d ON d.ID = @ID AND Almacen = @Almacen AND TransferirA = @AlmacenDestino
WHERE m.Modulo = @Modulo AND m.ID = @ID AND m.RenglonID = d.RenglonID AND m.Articulo = d.Articulo AND m.SubCuenta = ISNULL(d.SubCuenta, '')
EXEC spAfectar 'INV', @InvID, 'AFECTAR', 'TODO', @Usuario = @Usuario, @EnSilencio = 1, @Ok = @Ok OUTPUT, @OkRef = @OkRef OUTPUT, @FechaRegistro = @FechaRegistro, @Conexion = 1
IF @Ok IS NULL
BEGIN
SELECT @InvMovID = MovID
FROM Inv
WHERE ID = @InvID
EXEC spMovFlujo @Sucursal, 'AFECTAR', @Empresa, @Modulo, @ID, @Mov, @MovID, 'INV', @InvID, @InvMov, @InvMovID, @Ok OUTPUT
END
END
FETCH NEXT FROM crTransferirA INTO @Almacen, @AlmacenDestino
END
CLOSE crTransferirA
DEALLOCATE crTransferirA
END
END
RETURN
END

