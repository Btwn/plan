SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spPOSInsertarPOSVentaCobro
@ID         	varchar(50),
@Empresa        varchar(5),
@Sucursal       int,
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
@TipoCambio1			float,
@TipoCambio2			float,
@TipoCambio3			float,
@TipoCambio4			float,
@TipoCambio5			float,
@Monedero				varchar(20),
@FormaCobroMonedero		varchar(50),
@MonederoTipoCambio		float,
@MonederoImporte		float,
@Condicion				varchar(50)
SELECT @FormaCobroMonedero = CxcFormaCobroTarjetas
FROM EmpresaCfg WITH(NOLOCK)
WHERE Empresa = @Empresa
IF EXISTS(SELECT * FROM POSVentaCobro WITH(NOLOCK) WHERE ID = @ID)
DELETE POSVentaCobro WHERE ID = @ID
SELECT TOP 1
@Caja = Caja,
@Cajero = Cajero
FROM POSLCobro plc WITH(NOLOCK)
WHERE plc.ID = @ID
SELECT @Condicion =  Condicion
FROM POSL WITH(NOLOCK)
WHERE ID = @ID
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
FROM POSLCobro p WITH(NOLOCK)
WHERE ID = @ID
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
INSERT POSTarjetaSerieMov(
Empresa, ID, Modulo, Serie, Sucursal, Importe, TipoCambioTarjeta, ImporteTarjeta)
SELECT
@Empresa, @ID, 'VTAS', @Monedero, @Sucursal, @MonederoImporte, @MonederoTipoCambio, @Importe
IF @@ERROR <> 0
SET @Ok = 1
END
END
FETCH NEXT FROM crPOSCobro INTO @Importe, @FormaCobro, @Referencia, @TipoCambio, @Monedero, @MonederoTipoCambio, @MonederoImporte
END
CLOSE crPOSCobro
DEALLOCATE crPOSCobro
INSERT POSVentaCobro (
ID, Importe1, Importe2, Importe3, Importe4, Importe5, FormaCobro1, FormaCobro2, FormaCobro3, FormaCobro4, FormaCobro5,
Referencia1, Referencia2, Referencia3, Referencia4, Referencia5, CtaDinero, Cajero,POSTipoCambio1, POSTipoCambio2,
POSTipoCambio3, POSTipoCambio4, POSTipoCambio5, Condicion )
VALUES (
@ID, @Importe1, @Importe2, @Importe3, @Importe4, @Importe5, @FormaCobro1, @FormaCobro2, @FormaCobro3, @FormaCobro4, @FormaCobro5,
@Referencia1, @Referencia2, @Referencia3, @Referencia4, @Referencia5, @Caja, @Cajero, @TipoCambio1, @TipoCambio2,
@TipoCambio3, @TipoCambio4, @TipoCambio5, @Condicion)
IF @@ERROR <> 0
SET @Ok = 1
END

