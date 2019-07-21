SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spPOSVerificaCBFormaPago
@Empresa		varchar(5)

AS
BEGIN
DECLARE	@FormaPago			varchar (50),
@FormaPagoRef		varchar (50),
@CfgMultiMoneda		bit,
@Ok					int,
@OkRef				varchar(255),
@ContMoneda			varchar(10),
@MovIngresos		varchar(10),
@MovEgresos			varchar(10),
@Moneda				varchar(10)
SELECT @CfgMultiMoneda = MultiMoneda FROM POSCfg WHERE Empresa = @Empresa
SELECT @ContMoneda = ContMoneda
FROM EmpresaCfg
WHERE Empresa = @Empresa
DECLARE crSE1 CURSOR LOCAL FOR
SELECT cb.FormaPago,  fp.MovIngresos, fp.MovEgresos, nullif(fp.Moneda,'')
FROM CB cb
JOIN FormaPago fp ON cb.FormaPago = fp.FormaPago
WHERE cb.TipoCuenta = 'Forma Pago'
OPEN crSE1
FETCH NEXT FROM crSE1 INTO @FormaPago, @MovIngresos, @MovEgresos, @Moneda
WHILE @@FETCH_STATUS <> -1
BEGIN
IF @@FETCH_STATUS <> -2 AND @Ok IS NULL
BEGIN
SELECT @FormaPagoRef = @FormaPago
IF @Moneda IS NULL
SELECT @Ok = 1, @OkRef = 'La Forma de Pago no cuenta con Moneda, Forma Pago '
IF @MovIngresos <> 'Ingreso' AND @Ok IS NULL
SELECT @Ok = 2, @OkRef = 'El Movimiento de Ingresos debe ser Ingreso, Forma Pago '
IF @MovEgresos <> 'Egreso' AND @Ok IS NULL
SELECT @Ok = 3, @OkRef = 'El Movimiento de Egresos debe ser Egreso, Forma Pago '
IF @CfgMultiMoneda = 0 AND @Ok IS NULL
BEGIN
IF @Moneda <> @ContMoneda
SELECT @Ok = 4, @OkRef = 'No está configurada la opción de Multimoneda, Forma Pago '
END
END
FETCH NEXT FROM crSE1 INTO @FormaPago, @MovIngresos, @MovEgresos, @Moneda
END
CLOSE crSE1
DEALLOCATE crSE1
IF NULLIF(@OkRef,'') IS NOT NULL
SELECT @OkRef = @OkRef + @FormaPagoRef
SELECT @OkRef
END

