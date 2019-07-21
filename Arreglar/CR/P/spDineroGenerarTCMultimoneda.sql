SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spDineroGenerarTCMultimoneda
@Accion			varchar(20),
@Empresa          		varchar(5),
@Sucursal	      		int,
@Usuario			varchar(10),
@ID               		int,
@Mov			varchar(20),
@MovID			varchar(20),
@MovTipo                    varchar(20),
@SubClave                   varchar(20),
@Estatus                    varchar(15),
@EstatusNuevo               varchar(15),
@Ok               		int          OUTPUT,
@OkRef            		varchar(255) OUTPUT

AS BEGIN
DECLARE
@Moneda               varchar(10),
@DineroID             int,
@DineroMov            varchar(20),
@CtaDinero            varchar(10),
@CtaDineroDestino	  varchar(10),
@Importe              money,
@ImporteTotal         money,
@FormaPago            varchar(50),
@Referencia           varchar(50),
@Renglon              float,
@SucursalD            int,
@MovIDGenerar         varchar(20),
@TipoCambio           float,
@OModulo              varchar(20),
@OID                  int,
@FechaEmision         datetime,
@RequiereReferencia   bit
SET @FechaEmision = dbo.fnFechaSinHora(GETDATE())
SELECT @DineroMov = CajaTransferencia
FROM EmpresaCfgMov WHERE Empresa = @Empresa
IF (@Accion = 'AFECTAR'  AND @MovTipo = 'DIN.TC'   AND @SubClave ='DIN.TCMULTIMONEDA' AND @EstatusNuevo = 'CONCLUIDO')
BEGIN
DECLARE crMoneda CURSOR FOR
SELECT Importe, FormaPago,   CtaDinero, CtaDineroDestino, Moneda, TipoCambio
FROM DineroD
WHERE ID = @ID
OPEN crMoneda
FETCH NEXT FROM crMoneda INTO @Importe, @FormaPago,  @CtaDinero, @CtaDineroDestino, @Moneda, @TipoCambio
WHILE @@FETCH_STATUS = 0 AND @Ok IS NULL
BEGIN
SELECT @RequiereReferencia = ISNULL(RequiereReferencia, 0)
FROM FormaPago
WHERE FormaPago = @FormaPago
INSERT Dinero (Sucursal,  SucursalOrigen,  SucursalDestino,  Empresa, Mov,        Importe,  FechaEmision,  Concepto,  Proyecto,  Moneda,  TipoCambio,  Usuario, Referencia, Observaciones, Estatus,      CtaDinero, CtaDineroDestino, Cajero,   ConDesglose, OrigenTipo, Origen, OrigenID,Prioridad,FormaPago)
SELECT         Sucursal,  SucursalOrigen,  SucursalDestino,  Empresa, @DineroMov, @Importe, @FechaEmision, Concepto,  Proyecto,  @Moneda, @TipoCambio, Usuario, CASE WHEN @RequiereReferencia = 1 THEN ISNULL(Referencia,'(Varios)') ELSE Referencia END , Observaciones, 'SINAFECTAR', @CtaDinero, @CtaDineroDestino,Cajero,   0,           OrigenTipo,      Mov,    MovID,Prioridad, @FormaPago
FROM Dinero WHERE ID = @ID
IF @@ERROR <> 0 SELECT @Ok = 1
SELECT @DineroID = SCOPE_IDENTITY()
IF @Ok IS NULL AND @DineroID IS NOT NULL
BEGIN
EXEC spAfectar 'DIN', @DineroID, 'AFECTAR', 'Todo', NULL, @Usuario, @EnSilencio = 1, @Conexion = 1, @Ok = @Ok OUTPUT, @OkRef = @OkRef OUTPUT
SELECT @MovIDGenerar = MovID FROM Dinero WHERE ID = @DineroID
EXEC spMovFlujo @Sucursal, 'AFECTAR', @Empresa, 'DIN', @ID, @Mov, @MovID, 'DIN', @DineroID, @DineroMov, @MovIDGenerar, @Ok OUTPUT
END
FETCH NEXT FROM crMoneda INTO  @Importe, @FormaPago,  @CtaDinero, @CtaDineroDestino, @Moneda, @TipoCambio
END
CLOSE crMoneda
DEALLOCATE crMoneda
END
IF (@Accion = 'CANCELAR'  AND @MovTipo = 'DIN.TC'   AND @SubClave ='DIN.TCMULTIMONEDA' AND @EstatusNuevo = 'CANCELADO')
BEGIN
DECLARE crCancelar CURSOR FOR
SELECT DModulo, DID
FROM MovFlujo
WHERE OID = @ID AND OModulo = 'DIN' and Empresa = @Empresa
ORDER BY DID
OPEN crCancelar
FETCH NEXT FROM crCancelar INTO  @OModulo,@OID
WHILE @@FETCH_STATUS = 0 AND @Ok IS NULL
BEGIN
EXEC spAfectar @OModulo, @OID, 'CANCELAR', 'Todo', NULL, @Usuario, @EnSilencio = 1, @Conexion = 1, @Ok = @Ok OUTPUT, @OkRef = @OkRef OUTPUT
FETCH NEXT FROM crCancelar INTO  @OModulo,@OID
END
CLOSE crCancelar
DEALLOCATE crCancelar
END
END

