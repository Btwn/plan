SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spDineroFaltanteSobrante
@Accion			char(20),
@Empresa          		char(5),
@Sucursal	      		int,
@Usuario			char(10),
@ID               		int,
@Mov			char(20),
@MovID			varchar(20),
@CajeroSaldo      		money,
@CtaDinero			char(10),
@CtaDineroMoneda		char(10),
@TieneSaldoOtrasMonedas	bit,
@Ok               		int          OUTPUT,
@OkRef            		varchar(255) OUTPUT

AS BEGIN
DECLARE
@FechaRegistro	datetime,
@DineroID		int,
@DineroMov		char(20),
@DineroMovID	varchar(20),
@FormaPago		varchar(50),
@MovFaltanteCaja  	varchar(20),
@MovSobranteCaja  	varchar(20),
@ConDesglose	bit,
@Moneda		char(10),
@Importe		money,
@IDGenerar		int
SELECT @FechaRegistro = GETDATE()
SELECT @ConDesglose = DineroDesgloseObligatorio,
@FormaPago   = FormaPagoEfectivo
FROM EmpresaCfg
WHERE Empresa = @Empresa
SELECT @MovFaltanteCaja = CajaFaltanteCaja,
@MovSobranteCaja = CajaSobranteCaja
FROM EmpresaCfgMov
WHERE Empresa = @Empresa
IF @Accion = 'CANCELAR'
BEGIN
DECLARE crCancelarFaltanteSobrante CURSOR LOCAL FOR
SELECT ID
FROM Dinero
WHERE Empresa = @Empresa AND OrigenTipo = 'DIN' AND Origen = @Mov AND OrigenID = @MovID AND Estatus NOT IN ('SINAFECTAR', 'CANCELADO')
OPEN crCancelarFaltanteSobrante
FETCH NEXT FROM crCancelarFaltanteSobrante INTO @DineroID
IF @@ERROR <> 0 SELECT @Ok = 1
WHILE @@FETCH_STATUS <> -1 AND @Ok IS NULL
BEGIN
IF @@FETCH_STATUS <> -2 AND @Ok IS NULL
BEGIN
EXEC spDinero @DineroID, 'DIN', @Accion, 'TODO', @FechaRegistro, NULL, @Usuario, 1, 0,
@DineroMov OUTPUT, @DineroMovID OUTPUT, @IDGenerar OUTPUT, @Ok OUTPUT, @OkRef OUTPUT
IF @Ok IS NULL
EXEC spMovFlujo @Sucursal, @Accion, @Empresa, 'DIN', @ID, @Mov, @MovID, 'DIN', @DineroID, @DineroMov, @DineroMovID, @Ok OUTPUT
END
FETCH NEXT FROM crCancelarFaltanteSobrante INTO @DineroID
END 
CLOSE crCancelarFaltanteSobrante
DEALLOCATE crCancelarFaltanteSobrante
END ELSE
BEGIN
SELECT @Importe = ABS(@CajeroSaldo)
IF @Importe <> 0.0
BEGIN
SELECT @DineroMov = CASE WHEN @CajeroSaldo > 0 THEN @MovFaltanteCaja ELSE @MovSobranteCaja END
INSERT Dinero (OrigenTipo, Origen, OrigenID, Sucursal,  SucursalOrigen, SucursalDestino,  Empresa,  Mov,        FechaEmision,  Moneda,     TipoCambio,     Usuario,  Estatus,      CtaDinero,  Cajero,  Importe,  ConDesglose,  FormaPago,  UEN, Proyecto)
SELECT  'DIN',      @Mov,   @MovID,   Sucursal,  SucursalOrigen, SucursalDestino,  Empresa,  @DineroMov, FechaEmision,  Moneda,     TipoCambio,     Usuario,  'SINAFECTAR', CtaDinero,  Cajero,  @Importe, @ConDesglose, @FormaPago, UEN, Proyecto
FROM Dinero
WHERE ID = @ID
SELECT @DineroID = SCOPE_IDENTITY()
INSERT DineroD (Sucursal,  ID,        Renglon, Importe,  FormaPago)
VALUES (@Sucursal, @DineroID, 2048,    @Importe, @FormaPago)
EXEC spDinero @DineroID, 'DIN', @Accion, 'TODO', @FechaRegistro, NULL, @Usuario, 1, 0,
@DineroMov OUTPUT, @DineroMovID OUTPUT, @IDGenerar OUTPUT, @Ok OUTPUT, @OkRef OUTPUT
IF @Ok IS NULL
EXEC spMovFlujo @Sucursal, @Accion, @Empresa, 'DIN', @ID, @Mov, @MovID, 'DIN', @DineroID, @DineroMov, @DineroMovID, @Ok OUTPUT
END
IF @TieneSaldoOtrasMonedas = 1 AND @Ok IS NULL
BEGIN
DECLARE crFaltanteSobrante CURSOR LOCAL FOR
SELECT Moneda, ISNULL(SUM(Saldo), 0.0)
FROM Saldo
WHERE Empresa = @Empresa
AND Rama = 'DIN'
AND Moneda <> @CtaDineroMoneda
AND Cuenta = @CtaDinero
GROUP BY Moneda
ORDER BY Moneda
OPEN crFaltanteSobrante
FETCH NEXT FROM crFaltanteSobrante INTO @Moneda, @Importe
WHILE @@FETCH_STATUS <> -1 AND @Ok IS NULL AND @Importe <> 0.0
BEGIN
IF @@FETCH_STATUS <> -2 AND @Ok IS NULL
BEGIN
SELECT @DineroMov = CASE WHEN @Importe > 0 THEN @MovFaltanteCaja ELSE @MovSobranteCaja END
INSERT Dinero (OrigenTipo, Origen, OrigenID, Sucursal,    SucursalOrigen,   SucursalDestino,    Empresa,    Mov,        FechaEmision,    Moneda,    TipoCambio,     Usuario,    Estatus,      CtaDinero,    Cajero,    Importe,       ConDesglose,  FormaPago,  UEN,   Proyecto)
SELECT  'DIN',      @Mov,   @MovID,   d.Sucursal,  d.SucursalOrigen, d.SucursalDestino,  d.Empresa,  @DineroMov, d.FechaEmision,  @Moneda,   m.TipoCambio,   d.Usuario,  'SINAFECTAR', d.CtaDinero,  d.Cajero,  ABS(@Importe), @ConDesglose, @FormaPago, d.UEN, d.Proyecto
FROM Dinero d
JOIN Mon m ON m.Moneda = @Moneda
WHERE d.ID = @ID
SELECT @DineroID = SCOPE_IDENTITY()
INSERT DineroD (Sucursal,  ID,        Renglon, Importe,       FormaPago)
SELECT @Sucursal, @DineroID, 2048,    ABS(@Importe), @FormaPago
EXEC spDinero @DineroID, 'DIN', @Accion, 'TODO', @FechaRegistro, NULL, @Usuario, 1, 0,
@DineroMov OUTPUT, @DineroMovID OUTPUT, @IDGenerar OUTPUT, @Ok OUTPUT, @OkRef OUTPUT
IF @Ok IS NULL
EXEC spMovFlujo @Sucursal, @Accion, @Empresa, 'DIN', @ID, @Mov, @MovID, 'DIN', @DineroID, @DineroMov, @DineroMovID, @Ok OUTPUT
END
FETCH NEXT FROM crFaltanteSobrante INTO @Moneda, @Importe
END 
CLOSE crFaltanteSobrante
DEALLOCATE crFaltanteSobrante
END
END
RETURN
END

