SET DATEFIRST 7    
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1  
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spAutoGenerarOP
@Sucursal		int,
@Accion		char(20),
@Modulo	      	char(5),
@ID                  int,
@Mov			char(20),
@MovID		varchar(20),
@MovTipo		char(20),
@Empresa		char(5),
@Usuario		char(10),
@FechaRegistro	datetime,
@Cliente		char(10),
@ProdSerieLote	varchar(50),
@Ok			int		OUTPUT,
@OkRef		varchar(255)	OUTPUT

AS BEGIN
DECLARE
@IDProd		int,
@IDGenerar		int,
@ContID		int,
@GenerarMov		char(20),
@GenerarMovID	char(20),
@AutoReservar	bit
SELECT @IDProd = NULL
SELECT @GenerarMov   = ProdOrdenProduccion
FROM EmpresaCfgMov WITH (NOLOCK) 
WHERE Empresa = @Empresa
SELECT @AutoReservar = ProdAutoReservar
FROM EmpresaCfg2 WITH (NOLOCK) 
WHERE Empresa = @Empresa
IF @Accion = 'CANCELAR'
BEGIN
SELECT @IDProd = MAX(ID)
FROM Prod WITH (NOLOCK) 
WHERE Empresa = @Empresa AND OrigenTipo = @Modulo AND Origen = @Mov AND OrigenID = @MovID AND Mov = @GenerarMov
AND Estatus <> 'CANCELADO'
END ELSE
BEGIN
IF EXISTS(SELECT d.* FROM VentaD d WITH (NOLOCK) , Art a WITH (NOLOCK)  WHERE d.Articulo = a.Articulo AND a.SeProduce = 1 AND d.ID = @ID)
BEGIN
INSERT Prod (UltimoCambio, Sucursal,  SucursalOrigen, SucursalDestino, OrigenTipo,  Origen,  OrigenID,  Empresa,  Usuario,  Estatus,      Mov,         FechaEmision,  VerDestino, AutoReservar,  Almacen, Concepto, Proyecto, Moneda, TipoCambio, Referencia, Observaciones, Prioridad, FechaEntrega)
SELECT GETDATE(),     @Sucursal, @Sucursal,      @Sucursal,       @Modulo,     @Mov,    @MovID,    @Empresa, @Usuario, 'SINAFECTAR', @GenerarMov, FechaEmision,  1,          @AutoReservar, Almacen, Concepto, Proyecto, Moneda, TipoCambio, Referencia, Observaciones, Prioridad, FechaRequerida
FROM Venta WITH (NOLOCK) 
WHERE ID = @ID
SELECT @IDProd = SCOPE_IDENTITY()
INSERT ProdD (ID,      Renglon,   RenglonSub,   RenglonID,   RenglonTipo,   Almacen,   Articulo,   SubCuenta,   Cantidad,            Unidad,   Factor,   CantidadInventario,   ProdSerieLote,  DestinoTipo, Destino, DestinoID, Cliente,  FechaRequerida,   FechaEntrega,     DescripcionExtra,   Ruta)
SELECT  @IDProd, d.Renglon, d.RenglonSub, d.RenglonID, d.RenglonTipo, d.Almacen, d.Articulo, d.SubCuenta, d.CantidadPendiente, d.Unidad, d.Factor, d.CantidadInventario, @ProdSerieLote, @Modulo,     @Mov,    @MovID,    @Cliente, d.FechaRequerida, d.FechaRequerida, d.DescripcionExtra, a.ProdRuta
FROM VentaD d WITH (NOLOCK) , Art a WITH (NOLOCK) 
WHERE d.ID = @ID AND d.Articulo = a.Articulo AND a.SeProduce = 1
END
END
IF @IDProd IS NOT NULL
BEGIN
IF @Accion <> 'CANCELAR'
EXEC spProdExplotar @Sucursal, @Empresa, @Usuario, @Accion, 'PROD', @IDProd, @FechaRegistro, 1, @Ok OUTPUT, @OkRef OUTPUT, @EnSilencio = 1
EXEC spInv @IDProd, 'PROD', @Accion, 'TODO', @FechaRegistro, NULL, @Usuario, 0, 0, NULL,
@GenerarMov OUTPUT, @GenerarMovID OUTPUT, @IDGenerar OUTPUT, @ContID,
@Ok OUTPUT, @OkRef OUTPUT
IF @Ok IS NULL
BEGIN
EXEC spMovFlujo @Sucursal, @Accion, @Empresa, @Modulo, @ID, @Mov, @MovID, 'PROD', @IDProd, @GenerarMov, @GenerarMovID, @Ok OUTPUT
IF @Accion <> 'CANCELAR'
SELECT @Ok = 80030, @OkRef = 'Movimiento: '+RTRIM(@GenerarMov) + ' ' +LTRIM(Convert(Char, @GenerarMovID))
END
END
RETURN
END

