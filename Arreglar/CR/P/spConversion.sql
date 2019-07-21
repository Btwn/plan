SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spConversion
@ID			int,
@Sucursal		int,
@Empresa		char(5)

AS BEGIN
DECLARE
@FechaRegistro	datetime,
@IDCredito		int,
@IDCargo		int,
@IDAplicacion	int,
@IDMovimiento	int,
@Cuenta		char(10),
@Usuario		char(10),
@Modulo 		char(5),
@FechaEmision	datetime,
@MovCargo		char(20),
@MovIDCargo		char(20),
@Mov		char(20),
@MovID		varchar(20),
@MovMoneda		char(10),
@MovTipoCambio	float,
@Movimiento		char(20),
@MovimientoID	varchar(20),
@Moneda		char(10),
@TipoCambio		float,
@Saldo		money,
@SaldoMoneda	char(10),
@SaldoTipoCambio	float,
@SaldoFactor	float,
@SaldoImporte	money,
@SaldoImpuestos	money,
@ImporteTotal	money,
@Importe		money,
@Impuestos		money,
@MovAplicacion	char(20),
@MovIDAplicacion	varchar(20),
@DifCambiaria 	money,
@IVAFiscal		float,
@IEPSFiscal		float,
@concepto		varchar(30),
@Ok			int,
@OkRef		varchar(255),
@Mensaje		varchar(255)
SELECT @Ok = NULL, @OkRef = NULL
SELECT @FechaRegistro = GETDATE()
SELECT @Cuenta = Cuenta,
@Modulo = Modulo,
@Usuario = Usuario,
@FechaEmision = FechaEmision,
@Mov = Mov,
@MovID = MovID,
@MovMoneda = MovMoneda,
@MovTipoCambio = MovTipoCambio,
@Movimiento = Movimiento,
@Moneda = Moneda,
@TipoCambio = TipoCambio
FROM Conversion
WHERE ID = @ID
/*
IF (@Modulo = 'CXC' AND @Mov NOT EXISTS (SELECT * FROM MovTipoCxcCredito WHERE Mov = @Mov)) OR
(@Modulo = 'CXP' AND @Mov NOT EXISTS (SELECT * FROM MovTipoCxpCargo WHERE Mov = @Mov))
BEGIN
EXEC spConversionOtros @ID, @Sucursal, @Empresa
RETURN
END
*/
SELECT @MovCargo = CASE @Modulo WHEN 'CXC' THEN CxcConversionCargo ELSE CxpConversionCredito END,
@MovAplicacion = CASE @Modulo WHEN 'CXC' THEN CxcAplicacion ELSE CxpAplicacion END
FROM EmpresaCfgMov
WHERE Empresa = @Empresa
IF @Modulo = 'CXC' SELECT @IDCredito = ID, @Saldo = Saldo, @SaldoMoneda = ClienteMoneda,   @SaldoTipoCambio = ClienteTipoCambio,   @SaldoFactor = CONVERT(float, Impuestos)/(CONVERT(float, Impuestos)+NULLIF(Importe, 0)), @IVAFiscal = IVAFiscal, @IEPSFiscal = IEPSFiscal FROM Cxc WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID AND Estatus = 'PENDIENTE' AND Cliente = @Cuenta ELSE
IF @Modulo = 'CXP' SELECT @IDCredito = ID, @Saldo = Saldo, @SaldoMoneda = ProveedorMoneda, @SaldoTipoCambio = ProveedorTipoCambio, @SaldoFactor = CONVERT(float, Impuestos)/(CONVERT(float, Impuestos)+NULLIF(Importe, 0)), @IVAFiscal = IVAFiscal, @IEPSFiscal = IEPSFiscal,@concepto=concepto FROM Cxp WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID AND Estatus = 'PENDIENTE' AND Proveedor = @Cuenta
SELECT @ImporteTotal = (@Saldo * @MovTipoCambio) / @TipoCambio
SELECT @SaldoImpuestos = @Saldo * @SaldoFactor,  @Impuestos = @ImporteTotal * @SaldoFactor
SELECT @SaldoImporte = @Saldo - @SaldoImpuestos, @Importe = @ImporteTotal - @Impuestos
SELECT @DifCambiaria = @ImporteTotal - ((@Saldo * @SaldoTipoCambio) / @TipoCambio)
IF @IDCredito IS NOT NULL
BEGIN
BEGIN TRANSACTION
EXEC @IDCargo = spMovCopiar @Sucursal, @Modulo, @IDCredito, @Usuario, @FechaEmision, 1
IF @IDCargo IS NOT NULL
BEGIN
IF @Modulo = 'CXC' UPDATE Cxc SET Mov = @MovCargo, Moneda = @MovMoneda, TipoCambio = @MovTipoCambio, Usuario = @Usuario, Importe = @SaldoImporte, Impuestos = @SaldoImpuestos, IVAFiscal = @IVAFiscal, IEPSFiscal = @IEPSFiscal, AplicaManual = 0, ClienteTipoCambio   = @MovTipoCambio WHERE ID = @IDCargo ELSE
IF @Modulo = 'CXP' UPDATE Cxp SET Mov = @MovCargo, Moneda = @MovMoneda, TipoCambio = @MovTipoCambio, Usuario = @Usuario, Importe = @SaldoImporte, Impuestos = @SaldoImpuestos, IVAFiscal = @IVAFiscal, IEPSFiscal = @IEPSFiscal, AplicaManual = 0, ProveedorTipoCambio = @MovTipoCambio WHERE ID = @IDCargo
EXEC spCx @IDCargo, @Modulo, 'AFECTAR', 'TODO', @FechaRegistro, NULL, @Usuario, 1, 0,
@MovCargo, @MovIDCargo OUTPUT, NULL,
@Ok OUTPUT, @OkRef OUTPUT
END
IF @Ok IS NULL
BEGIN
EXEC spCx @IDCredito, @Modulo, 'GENERAR', 'TODO', @FechaRegistro, @MovAplicacion, @Usuario, 1, 0,
NULL, NULL, @IDAplicacion OUTPUT,
@Ok OUTPUT, @OkRef OUTPUT
IF @Ok = 80030 SELECT @Ok = NULL, @OkRef = NULL
IF @IDAplicacion IS NOT NULL AND @Ok IS NULL
BEGIN
IF @Modulo = 'CXC'
BEGIN
UPDATE Cxc SET Moneda = @MovMoneda, TipoCambio = @MovTipoCambio, ClienteTipoCambio = @MovTipoCambio WHERE ID = @IDAplicacion
INSERT CxcD (ID, Renglon, Aplica, AplicaID, Importe) VALUES (@IDAplicacion, 2048, @MovCargo, @MovIDCargo, @Saldo)
END
IF @Modulo = 'CXP'
BEGIN
UPDATE Cxp SET Moneda = @MovMoneda, TipoCambio = @MovTipoCambio, ProveedorTipoCambio = @MovTipoCambio, concepto=@concepto  WHERE ID = @IDAplicacion
INSERT CxpD (ID, Renglon, Aplica, AplicaID, Importe) VALUES (@IDAplicacion, 2048, @MovCargo, @MovIDCargo, @Saldo)
END
EXEC spCx @IDAplicacion, @Modulo, 'AFECTAR', 'TODO', @FechaRegistro, NULL, @Usuario, 1, 0,
@MovAplicacion, @MovIDAplicacion OUTPUT, NULL,
@Ok OUTPUT, @OkRef OUTPUT
END
END
IF @Ok IS NULL
BEGIN
IF @Modulo = 'CXC'
INSERT Cxc (Sucursal, Empresa, Mov, FechaEmision, Moneda, TipoCambio, Usuario, Estatus,
Cliente, ClienteMoneda, ClienteTipoCambio, Importe, Impuestos, DiferenciaCambiaria, IVAFiscal, IEPSFiscal)
VALUES (@Sucursal, @Empresa, @Movimiento, @FechaEmision, @Moneda, @TipoCambio, @Usuario, 'SINAFECTAR',
@Cuenta, @Moneda,       @TipoCambio,       @Importe, @Impuestos, @DifCambiaria, @IVAFiscal, @IEPSFiscal)
ELSE
IF @Modulo = 'CXP'
INSERT Cxp (Sucursal, Empresa, Mov, FechaEmision, Moneda, TipoCambio, Usuario, Estatus,
Proveedor, ProveedorMoneda, ProveedorTipoCambio, Importe, Impuestos, DiferenciaCambiaria, IVAFiscal, IEPSFiscal)
VALUES (@Sucursal, @Empresa, @Movimiento, @FechaEmision, @Moneda, @TipoCambio, @Usuario, 'SINAFECTAR',
@Cuenta,   @Moneda,          @TipoCambio,       @Importe, @Impuestos, @DifCambiaria, @IVAFiscal, @IEPSFiscal)
SELECT @IDMovimiento = SCOPE_IDENTITY()
EXEC spCx @IDMovimiento, @Modulo, 'AFECTAR', 'TODO', @FechaRegistro, NULL, @Usuario, 1, 0,
@Movimiento, @MovimientoID OUTPUT, NULL,
@Ok OUTPUT, @OkRef OUTPUT
END
IF @Ok IS NULL
COMMIT TRANSACTION
ELSE
ROLLBACK TRANSACTION
END
IF @Ok IS NULL
SELECT @Mensaje = 'Conversion Realizada.<BR><BR>'+RTRIM(@Movimiento)+' '+RTRIM(@MovimientoID)
ELSE
SELECT @Mensaje = Descripcion FROM MensajeLista WHERE Mensaje = @Ok
SELECT @Mensaje
RETURN
END

