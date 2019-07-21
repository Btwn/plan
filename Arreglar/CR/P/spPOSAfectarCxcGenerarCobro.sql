SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spPOSAfectarCxcGenerarCobro
@IDAnterior		varchar(50),
@IDNuevo		int,
@Empresa        varchar(5),
@Sucursal       int,
@Usuario        varchar(10),
@Moneda			varchar(10),
@Ok				int		OUTPUT,
@OkRef			varchar(255)	OUTPUT

AS
BEGIN
DECLARE
@Importe				float,
@FormaCobro				varchar(50),
@Referencia				varchar(50),
@Importe1				float,
@Importe2				float,
@Importe3				float,
@Importe4				float,
@Importe5				float,
@FormaCobro1			varchar(50),
@FormaCobro2			varchar(50),
@FormaCobro3			varchar(50),
@FormaCobro4			varchar(50),
@FormaCobro5			varchar(50),
@Referencia1			varchar(50),
@Referencia2			varchar(50),
@Referencia3			varchar(50),
@Referencia4			varchar(50),
@Referencia5			varchar(50),
@Caja					varchar(10),
@Cajero					varchar(10),
@TipoCambio				float,
@Monedero				varchar(20),
@FormaCobroMonedero		varchar(50),
@Mov					varchar(20),
@MovID					varchar(20),
@IDGenerar				int,
@MonederoTipoCambio		float,
@MonederoImporte		float,
@ContMoneda				varchar(10),
@ContMonedaTC			float
SELECT @FormaCobroMonedero = CxcFormaCobroTarjetas, @ContMoneda = ContMoneda
FROM EmpresaCfg
WHERE Empresa = @Empresa
SELECT @ContMonedaTC = TipoCambio
FROM POSLTipoCambioRef
WHERE Sucursal = @Sucursal AND Moneda = @ContMoneda
IF @OK IS NULL
EXEC @IDGenerar = spAfectar 'CXC', @IDNuevo, 'GENERAR', 'Todo', 'Cobro', @Usuario, @EnSilencio = 1, @Conexion = 1, @Ok = @Ok OUTPUT, @OkRef = @OkRef OUTPUT
IF @Ok IS NULL
SET @Ok = 1
IF @Ok BETWEEN 80030 AND 81000
SET @Ok = NULL
IF @Ok IS NULL AND @IDGenerar IS NOT NULL
BEGIN
DECLARE crPOSCobro CURSOR LOCAL FOR
SELECT TOP 5 p.ImporteRef, p.FormaPago, p.Referencia, p.TipoCambio, p.Monedero, p.MonederoTipoCambio, p.MonederoImporte
FROM POSLCobro p
WHERE ID = @IDAnterior
OPEN crPOSCobro
FETCH NEXT FROM crPOSCobro INTO @Importe, @FormaCobro, @Referencia, @TipoCambio, @Monedero, @MonederoTipoCambio, @MonederoImporte
WHILE @@FETCH_STATUS <> -1
BEGIN
IF @@FETCH_STATUS <> -2
BEGIN
IF @Importe1 IS NULL
BEGIN
SELECT @Importe1 = @Importe, @FormaCobro1 = @FormaCobro, @Referencia1 = @Referencia
END
ELSE IF @Importe2 IS NULL
BEGIN
SELECT @Importe2 = @Importe, @FormaCobro2 = @FormaCobro, @Referencia2 = @Referencia
END
ELSE IF @Importe3 IS NULL
BEGIN
SELECT @Importe3 = @Importe, @FormaCobro3 = @FormaCobro, @Referencia3 = @Referencia
END
ELSE IF @Importe4 IS NULL
BEGIN
SELECT @Importe4 = @Importe, @FormaCobro4 = @FormaCobro, @Referencia4 = @Referencia
END
ELSE IF @Importe5 IS NULL
BEGIN
SELECT @Importe5 = @Importe, @FormaCobro5 = @FormaCobro, @Referencia5 = @Referencia
END
IF @FormaCobro = @FormaCobroMonedero AND @Monedero IS NOT NULL
BEGIN
INSERT TarjetaSerieMov(
Empresa, ID, Modulo, Serie, Sucursal, Importe, TipoCambioTarjeta, ImporteTarjeta)
SELECT
@Empresa, @IDNuevo, 'VTAS', @Monedero, @Sucursal, @MonederoImporte, @MonederoTipoCambio, @Importe
IF @@ERROR <> 0
SET @Ok = 1
END
END
FETCH NEXT FROM crPOSCobro INTO @Importe, @FormaCobro, @Referencia, @TipoCambio, @Monedero, @MonederoTipoCambio, @MonederoImporte
END
CLOSE crPOSCobro
DEALLOCATE crPOSCobro
END
UPDATE Cxc
SET ConDesglose = 1,
Moneda = @Moneda,
TipoCambio = CASE WHEN @Moneda <> @ContMoneda THEN  (@TipoCambio/@ContMonedaTC) ELSE @TipoCambio END,
ClienteMoneda = @Moneda,
ClienteTipoCambio = CASE WHEN @Moneda <> @ContMoneda THEN  (@TipoCambio/@ContMonedaTC) ELSE @TipoCambio END,
FormaCobro1 = @FormaCobro1,
FormaCobro2 = @FormaCobro2,
FormaCobro3 = @FormaCobro3,
FormaCobro4 = @FormaCobro4,
FormaCobro5 = @FormaCobro5,
Importe1 = @Importe1,
Importe2 = @Importe2,
Importe3 = @Importe3,
Importe4 = @Importe4,
Importe5 = @Importe5,
Referencia1 = @Referencia1,
Referencia2 = @Referencia2,
Referencia3 = @Referencia3,
Referencia4 = @Referencia4,
Referencia5 = @Referencia5,
Importe = ISNULL(@Importe1,0.0)+ISNULL(@Importe2,0.0)+ISNULL(@Importe3,0.0)+ISNULL(@Importe4,0.0)+ISNULL(@Importe5,0.0),
OrigenTipo = 'POS'
WHERE ID = @IDGenerar
IF @@ERROR <> 0
SET @Ok = 1
IF (@Ok IS NULL OR @Ok = 80030) AND @IDGenerar IS NOT NULL
EXEC spAfectar 'CXC', @IDGenerar, 'AFECTAR', 'Todo', NULL, @Usuario, @EnSilencio = 1, @Conexion = 1, @Ok = @Ok OUTPUT, @OkRef = @OkRef OUTPUT
IF @Ok BETWEEN 80030 AND 81000
SET @Ok = NULL
END

