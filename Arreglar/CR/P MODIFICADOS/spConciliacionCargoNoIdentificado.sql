SET DATEFIRST 7    
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1  
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spConciliacionCargoNoIdentificado
@Empresa		char(5),
@Sucursal		int,
@ID			int,
@Mov			varchar(20),
@MovID			varchar(20),
@MovTipo		varchar(20),
@CtaDinero		varchar(10),
@Institucion		varchar(20),
@Cuenta			varchar(20),
@Fecha			datetime,
@Concepto		varchar(50),
@Referencia		varchar(50),
@Observaciones		varchar(100),
@Importe		money,
@Auxiliar 		int		OUTPUT,
@ContD 			int		OUTPUT,
@CfgTolerancia		int,
@Usuario     varchar(10),
@Ok 			int		OUTPUT,
@OkRef 			varchar(255)	OUTPUT

AS BEGIN
DECLARE
@ConDesglose	bit,
@FormaPago		varchar(50),
@DineroID		int,
@DineroMov		varchar(20),
@DineroMovID	varchar(20)
SELECT @DineroMov = BancoCargoNoIdentificado
FROM EmpresaCfgMov WITH (NOLOCK)
WHERE Empresa = @Empresa
SELECT @ConDesglose = DineroDesgloseObligatorio,
@FormaPago   = FormaPagoEfectivo
FROM EmpresaCfg WITH (NOLOCK)
WHERE Empresa = @Empresa
INSERT Dinero (
OrigenTipo, Origen, OrigenID, Sucursal,  SucursalOrigen, SucursalDestino,  Empresa,  Mov,        FechaEmision,  Moneda, TipoCambio, Usuario,  Estatus,      CtaDinero,  Importe,  Concepto,  Referencia,  Observaciones,  ConDesglose,  FormaPago,  UEN, Proyecto)
SELECT  'CONC',     @Mov,   @MovID,   @Sucursal, SucursalOrigen, SucursalDestino,  Empresa,  @DineroMov, @Fecha,        Moneda, TipoCambio, Usuario,  'SINAFECTAR', CtaDinero,  @Importe, @Concepto, @Referencia, @Observaciones, @ConDesglose, @FormaPago, UEN, Proyecto
FROM Conciliacion WITH (NOLOCK)
WHERE ID = @ID
SELECT @DineroID = SCOPE_IDENTITY()
INSERT DineroD (Sucursal,  ID,        Renglon, Importe,  FormaPago)
VALUES (@Sucursal, @DineroID, 2048,    @Importe, @FormaPago)
EXEC spAfectar 'DIN', @DineroID, @EnSilencio = 1, @Conexion = 1, @Usuario = @Usuario, @Ok = @Ok OUTPUT, @OkRef = @OkRef OUTPUT
IF @Ok IS NULL
BEGIN
SELECT @DineroMovID = MovID FROM Dinero WITH (NOLOCK) WHERE ID = @DineroID
EXEC spMovFlujo @Sucursal, 'AFECTAR', @Empresa, 'CONC', @ID, @Mov, @MovID, 'DIN', @DineroID, @DineroMov, @DineroMovID, @Ok OUTPUT
EXEC spConciliacionBuscarAux @Empresa, @MovTipo, @DineroID, @CtaDinero, @Cuenta, NULL, @Importe, @Auxiliar OUTPUT, @ContD OUTPUT, @CfgTolerancia, @Ok OUTPUT, @OkRef OUTPUT
END
RETURN
END

