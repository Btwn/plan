SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spPOSAfectarVentaCobro
@IDAnterior		varchar(50),
@IDNuevo		varchar(50),
@Empresa        varchar(5),
@Sucursal       int,
@Ok				int				OUTPUT,
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
@TipoCambio1			float,
@TipoCambio2			float,
@TipoCambio3			float,
@TipoCambio4			float,
@TipoCambio5			float,
@Monedero				varchar(20),
@FormaCobroMonedero		varchar(50),
@MonederoTipoCambio		float,
@MonederoImporte		float,
@ContMoneda				varchar(10),
@Moneda					varchar(10),
@ContMonedaTC			float
SELECT @FormaCobroMonedero = CxcFormaCobroTarjetas, @ContMoneda = ContMoneda
FROM EmpresaCfg
WHERE Empresa = @Empresa
SELECT @Moneda = Moneda
FROM POSL
WHERE ID = @IDAnterior
SELECT @ContMonedaTC = TipoCambio
FROM POSLTipoCambioRef
WHERE Sucursal = @Sucursal AND Moneda = @ContMoneda
SELECT TOP 1
@Caja = Caja,
@Cajero = Cajero
FROM POSLCobro plc
WHERE plc.ID = @IDAnterior
CREATE TABLE #POSCobro (
ImporteRef				float,
FormaPago				varchar(50),
Referencia				varchar(50)	NULL,
TipoCambio				float,
Monedero				varchar(36)	NULL,
MonederoTipoCambio		float		NULL,
MonederoImporte			float		NULL)
INSERT INTO #POSCobro (ImporteRef, FormaPago, Referencia, TipoCambio, Monedero, MonederoTipoCambio, MonederoImporte)
SELECT SUM(ISNULL(p.ImporteRef,0)),
p.FormaPago,
dbo.fnPOSVentaCobroReferencia(p.ID, p.FormaPago, p.TipoCambio, p.MonederoTipoCambio),
p.TipoCambio,
dbo.fnPOSVentaCobroMonedero(p.ID, p.FormaPago, p.MonederoTipoCambio),
p.MonederoTipoCambio,
dbo.fnPOSVentaCobroMonederoImporte(p.ID, p.FormaPago, p.MonederoTipoCambio)
FROM POSLCobro p
WHERE ID = @IDAnterior
GROUP BY p.ID, p.FormaPago, p.TipoCambio, p.MonederoTipoCambio
DECLARE crPOSCobro CURSOR LOCAL FOR
SELECT TOP 5 p.ImporteRef,
p.FormaPago,
p.Referencia,
p.TipoCambio,
p.Monedero,
p.MonederoTipoCambio,
p.MonederoImporte
FROM #POSCobro p
OPEN crPOSCobro
FETCH NEXT FROM crPOSCobro INTO @Importe, @FormaCobro, @Referencia, @TipoCambio, @Monedero, @MonederoTipoCambio, @MonederoImporte
WHILE @@FETCH_STATUS <> -1
BEGIN
IF @@FETCH_STATUS <> -2
BEGIN
IF @Importe1 IS NULL
BEGIN
SELECT @Importe1 = @Importe, @FormaCobro1 = @FormaCobro, @Referencia1 = @Referencia, @TipoCambio1 = @TipoCambio
END
ELSE IF @Importe2 IS NULL
BEGIN
SELECT @Importe2 = @Importe, @FormaCobro2 = @FormaCobro, @Referencia2 = @Referencia, @TipoCambio2 = @TipoCambio
END
ELSE IF @Importe3 IS NULL
BEGIN
SELECT @Importe3 = @Importe, @FormaCobro3 = @FormaCobro, @Referencia3 = @Referencia, @TipoCambio3 = @TipoCambio
END
ELSE IF @Importe4 IS NULL
BEGIN
SELECT @Importe4 = @Importe, @FormaCobro4 = @FormaCobro, @Referencia4 = @Referencia, @TipoCambio4 = @TipoCambio
END
ELSE IF @Importe5 IS NULL
BEGIN
SELECT @Importe5 = @Importe, @FormaCobro5 = @FormaCobro, @Referencia5 = @Referencia, @TipoCambio5 = @TipoCambio
END
IF @FormaCobro = @FormaCobroMonedero AND @Monedero IS NOT NULL
BEGIN
IF NOT EXISTS (SELECT * FROM TarjetaSerieMov WHERE Empresa = @Empresa AND Modulo = 'VTAS' AND ID = @IDNuevo AND Serie = @Monedero)
INSERT TarjetaSerieMov(
Empresa, ID, Modulo, Serie, Sucursal, Importe, TipoCambioTarjeta, ImporteTarjeta)
SELECT
@Empresa, @IDNuevo, 'VTAS', @Monedero, @Sucursal, @MonederoImporte, @MonederoTipoCambio, @Importe
ELSE
UPDATE TarjetaSerieMov SET Importe = ISNULL(Importe,0.0)+@MonederoImporte, TipoCambioTarjeta = @MonederoTipoCambio,
ImporteTarjeta = ISNULL(ImporteTarjeta,0.0)+ISNULL(@Importe,0.0)
WHERE Empresa = @Empresa AND Modulo = 'VTAS' AND ID = @IDNuevo AND Serie = @Monedero
IF @@ERROR <> 0
SET @Ok = 1
END
END
FETCH NEXT FROM crPOSCobro INTO @Importe, @FormaCobro, @Referencia, @TipoCambio, @Monedero, @MonederoTipoCambio, @MonederoImporte
END
CLOSE crPOSCobro
DEALLOCATE crPOSCobro
INSERT VentaCobro (
ID, Importe1, Importe2, Importe3, Importe4, Importe5, FormaCobro1, FormaCobro2, FormaCobro3, FormaCobro4, FormaCobro5,
Referencia1, Referencia2, Referencia3, Referencia4, Referencia5, CtaDinero, Cajero,POSTipoCambio1, POSTipoCambio2,
POSTipoCambio3, POSTipoCambio4, POSTipoCambio5 )
VALUES (
@IDNuevo, @Importe1, @Importe2, @Importe3, @Importe4, @Importe5, @FormaCobro1, @FormaCobro2, @FormaCobro3, @FormaCobro4, @FormaCobro5,
@Referencia1, @Referencia2, @Referencia3, @Referencia4, @Referencia5, @Caja, @Cajero, @TipoCambio1, @TipoCambio2,
@TipoCambio3, @TipoCambio4, @TipoCambio5)
IF @@ERROR <> 0
SET @Ok = 1
IF @Ok IS NULL
EXEC xpPOSAfectarVentaCobro @IDAnterior, @IDNuevo, @Empresa, @Sucursal, @Ok OUTPUT, @OkRef OUTPUT
END

