SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spCancelarFacturaOtroMes
@Sucursal		int,
@Modulo	      	char(5),
@ID                  int,
@Mov			char(20),
@MovID		varchar(20),
@MovTipo		char(20),
@MovMoneda		char(10),
@MovTipoCambio	float,
@Empresa		char(5),
@Usuario		char(10),
@FechaRegistro	datetime,
@CancelacionMov	char(20) 	OUTPUT,
@CancelacionMovID	varchar(20)	OUTPUT,
@Ok			int		OUTPUT,
@OkRef		varchar(255)	OUTPUT

AS BEGIN
DECLARE
@CxID	   		int,
@CxMov			char(20),
@CxMovID			varchar(20),
@Concepto			varchar(50),
@CancelacionID 		int,
@IDGenerar     		int,
@ContID        		int,
@VolverAfectar 		bit,
@CxcAplicacion		char(20),
@GenerarMov 		char(20),
@GenerarMovID		varchar(20),
@Importe			money,
@FormaEnvio			varchar(50),
@Ejercicio	      		int,
@Periodo	      		int,
@CfgVentaSurtirDemas	bit,
@CfgCompraRecibirDemas	bit,
@CfgTransferirDemas		bit,
@CfgBackOrders		bit,
@CfgContX			bit,
@CfgContXGenerar		char(20),
@CfgEmbarcar		bit,
@CfgImpInc			bit,
@CfgPrecioMoneda		bit,
@CfgMultiUnidades		bit,
@CfgMultiUnidadesNivel	char(20),
@CfgCancelarFacturaReservarPedido bit,
@CfgCancelarFacturaFecha	varchar(20),
@CfgCancelarFacturaFisicamente bit,
@AplicaNC			bit,
@FechaCancelacion		datetime,
@EstatusNuevo               varchar(15)
IF @MovTipo NOT IN ('VTAS.F','VTAS.FAR') SELECT @Ok = 30110
IF EXISTS(SELECT * FROM Usuario WHERE Usuario = @Usuario AND BloquearCancelarFactura = 1)
SELECT @Ok = 20995
EXEC spMovTipo @Modulo, @Mov, @FechaRegistro, @Empresa, 'CONCLUIDO', @Concepto OUTPUT, @MovTipo OUTPUT, @Periodo OUTPUT, @Ejercicio OUTPUT, @Ok OUTPUT
SELECT @FormaEnvio = FormaEnvio FROM Venta WHERE ID = @ID
SELECT @CxID = NULL, @AplicaNC = 0
SELECT @CxID = ID, @CxMov = Mov, @CxMovID = MovID
FROM Cxc
WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID AND Estatus = 'PENDIENTE'
IF @CxID IS NOT NULL SELECT @AplicaNC = 1
SELECT @CfgVentaSurtirDemas          = VentaSurtirDemas,
@CfgTransferirDemas	       = TransferirDemas,
@CfgBackOrders	       	       = BackOrders,
@CfgImpInc		       = VentaPreciosImpuestoIncluido,
@CfgPrecioMoneda	       = VentaPrecioMoneda,
@CfgCancelarFacturaReservarPedido = CancelarFacturaReservarPedido,
@CfgCancelarFacturaFecha      = CancelarFacturaFecha,
@CfgCancelarFacturaFisicamente= ISNULL(CancelarFacturaFisicamente, 0)
FROM EmpresaCfg
WHERE Empresa = @Empresa
SELECT @CfgCompraRecibirDemas  	= CompraRecibirDemas,
@CfgMultiUnidades       	= MultiUnidades,
@CfgMultiUnidadesNivel  	= ISNULL(UPPER(NivelFactorMultiUnidad), 'UNIDAD')
FROM EmpresaCfg2
WHERE Empresa = @Empresa
SELECT @CfgContX	     = ContX
FROM EmpresaGral
WHERE Empresa = @Empresa
IF @CfgContX = 1
SELECT @CfgContXGenerar = ISNULL(UPPER(RTRIM(ContXGenerar)), 'NO')
FROM EmpresaCfgModulo
WHERE Empresa = @Empresa
AND Modulo  = @Modulo
IF /*@CxID IS NULL OR */@CfgCancelarFacturaFisicamente = 0 AND EXISTS(SELECT * FROM MovFlujo WHERE Cancelado = 0 AND Empresa = @Empresa AND OModulo = 'CXC' AND OID = @CxID AND DModulo = 'CXC')
SELECT @Ok = 60060, @OkRef = RTRIM(@CxMov)+' '+LTRIM(Convert(Char, @CxMovID))
IF @Ok IS NOT NULL RETURN
IF @FormaEnvio IS NOT NULL AND EXISTS(SELECT * FROM EmpresaCfgMovEsp WHERE Empresa = @Empresa AND Asunto = 'EMB' AND Modulo = @Modulo AND Mov = @Mov)
BEGIN
SELECT @CfgEmbarcar = Embarcar FROM FormaEnvio WHERE FormaEnvio = @FormaEnvio
END
SELECT @CancelacionMov        = CASE WHEN @Mov = AutoRecaudacion THEN AutoCancelacionRecaudacion ELSE VentaCancelacionFactura END,
@CxcAplicacion         = CxcAplicacion
FROM EmpresaCfgMov
WHERE Empresa = @Empresa
BEGIN TRANSACTION
IF UPPER(@CfgCancelarFacturaFecha) = 'FECHA EMISION'
SELECT @FechaCancelacion = FechaEmision FROM Venta WHERE ID = @ID
ELSE
SELECT @FechaCancelacion = @FechaRegistro
EXEC @CancelacionID = spMovCopiar @Sucursal, @Modulo, @ID, @Usuario, @FechaCancelacion, 1, 0
IF @CancelacionID IS NOT NULL
BEGIN
UPDATE Venta
SET Mov = @CancelacionMov,
Moneda = @MovMoneda,
TipoCambio = @MovTipoCambio,
Referencia = '('+RTRIM(@Mov)+' '+LTRIM(CONVERT(char, @MovID))+')',
OrigenTipo = 'VTAS',
Origen     = @Mov,
OrigenID   = @MovID
WHERE ID = @CancelacionID
IF @@ERROR <> 0 SELECT @Ok = 1
EXEC spInv @CancelacionID, @Modulo, 'AFECTAR', 'TODO', @FechaCancelacion, NULL, @Usuario, 1, 0, NULL,
@CancelacionMov OUTPUT, @CancelacionMovID OUTPUT, @IDGenerar OUTPUT, @ContID OUTPUT,
@Ok OUTPUT, @OkRef OUTPUT, @VolverAfectar OUTPUT, @EsCancelacionFactura = 1
IF @Ok = 80030 SELECT @Ok = NULL, @OkRef = NULL
IF @Ok IS NULL AND @CfgCancelarFacturaReservarPedido = 1
BEGIN
EXEC spInvMatar @Sucursal, @ID, 'CANCELAR', 'TODO', @Empresa, @Usuario, @Modulo, @Mov, @MovID, @MovTipo,
'CONCLUIDO', 'CANCELADO', @FechaCancelacion, @FechaCancelacion, @FechaCancelacion, @Ejercicio, @Periodo, 0, 'NORMAL', 'NORMAL',
@CfgVentaSurtirDemas, @CfgCompraRecibirDemas, @CfgTransferirDemas, @CfgBackOrders, @CfgContX, @CfgContXGenerar, @CfgEmbarcar, @CfgImpInc, @CfgMultiUnidades, @CfgMultiUnidadesNivel,
@Ok OUTPUT, @OkRef OUTPUT,
@CfgPrecioMoneda = @CfgPrecioMoneda
IF @Ok IS NULL
EXEC spCancelarFacturaReservarPedido @ID, @Usuario, @FechaCancelacion, @Ok OUTPUT, @OkRef OUTPUT
END
END
IF @Ok IS NULL
BEGIN
IF @CfgCancelarFacturaFisicamente = 1
UPDATE Venta SET CancelacionID = @CancelacionID, FechaCancelacion = @FechaRegistro, Estatus = 'CANCELADO' WHERE ID IN (@ID, @CancelacionID)
ELSE
UPDATE Venta SET CancelacionID = @CancelacionID WHERE ID IN (@ID, @CancelacionID)
EXEC xpCancelarFacturaOtroMes @ID, @CancelacionID, @Ok OUTPUT, @OkRef OUTPUT
END
IF @Ok IS NULL
COMMIT TRANSACTION
ELSE
ROLLBACK TRANSACTION
IF @Ok IS NULL
BEGIN
SELECT @EstatusNuevo = Estatus FROM Venta WHERE ID = @CancelacionID
EXEC spCFDAfectarSinMovFinal  @Empresa, @Modulo, @CancelacionMov, @CancelacionMovID, @CancelacionID, @EstatusNuevo, NULL, @Ok, @OkRef
END
IF @AplicaNC = 1 AND @Ok IS NULL
BEGIN
SELECT @CxID = NULL
SELECT @CxID = DID
FROM Movflujo
WHERE Cancelado = 0 AND Empresa = @Empresa AND OModulo = @Modulo AND OID = @CancelacionID AND DModulo = 'CXC'
IF @CxID IS NOT NULL
BEGIN
EXEC spCx @CxID, 'CXC', 'GENERAR', 'TODO', @FechaCancelacion, @CxcAplicacion, @Usuario, 0, 0,
@GenerarMov OUTPUT, @GenerarMovID OUTPUT, @IDGenerar OUTPUT,
@Ok OUTPUT, @OkRef OUTPUT
IF @Ok = 80030 SELECT @Ok = NULL, @OkRef = NULL
IF @Ok IS NULL
BEGIN
SELECT @Importe = Importe FROM Cxc WHERE ID = @IDGenerar
INSERT CxcD (Sucursal, ID, Renglon, RenglonSub, Aplica, AplicaID, Importe)
VALUES (@Sucursal, @IDGenerar, 2048, 0, @Mov, @MovID, @Importe)
EXEC spCx @IDGenerar, 'CXC', 'AFECTAR', 'TODO', @FechaCancelacion, NULL, @Usuario, 0, 0,
@GenerarMov OUTPUT, @GenerarMovID OUTPUT, @IDGenerar OUTPUT,
@Ok OUTPUT, @OkRef OUTPUT
IF @Ok = 80030 SELECT @Ok = NULL, @OkRef = NULL
IF @Ok IS NOT NULL
BEGIN
SELECT @Ok = NULL, @OkRef = NULL
IF @GenerarMovID IS NULL
DELETE Cxc WHERE ID = @IDGenerar
ELSE
EXEC spCx @IDGenerar, 'CXC', 'CANCELAR', 'TODO', @FechaCancelacion, NULL, @Usuario, 0, 0,
@GenerarMov OUTPUT, @GenerarMovID OUTPUT, @IDGenerar OUTPUT,
@Ok OUTPUT, @OkRef OUTPUT
END
END
END
END
END

