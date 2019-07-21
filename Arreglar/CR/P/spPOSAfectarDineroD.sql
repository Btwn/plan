SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spPOSAfectarDineroD
@IDAnterior		varchar(50),
@IDNuevo		varchar(50),
@Sucursal		int,
@MovClave       varchar(20),
@Ok				int		OUTPUT,
@OkRef			varchar(255)	OUTPUT

AS
BEGIN
DECLARE
@Importe				float,
@FormaCobro				varchar(50),
@Referencia				varchar(50),
@Renglon				float,
@CtaDinero				varchar(10),
@CtaDineroDestino		varchar(10),
@Moneda					varchar(10),
@MonedaMov				varchar(10),
@TipoCambio				float,
@ContMoneda				varchar(10),
@Empresa				varchar(5),
@ContMonedaTC	        float
SELECT @MonedaMov = Moneda, @Empresa = Empresa
FROM POSL
WHERE ID = @IDAnterior
SELECT @ContMoneda = ec.ContMoneda
FROM EmpresaCfg ec
WHERE ec.Empresa = @Empresa
SELECT @ContMonedaTC = TipoCambio
FROM POSLTipoCambioRef
WHERE Sucursal = @Sucursal AND Moneda = @ContMoneda
DECLARE crPOSCobro CURSOR LOCAL FOR
SELECT p.ImporteRef,
p.FormaPago,
Referencia = ISNULL(NULLIF(p.Referencia,''), 'MOVIMIENTO POS'),
CtaDinero,
CtaDineroDestino,
MonedaRef,
CASE WHEN @MonedaMov <> @ContMoneda THEN  (TipoCambio/@ContMonedaTC) ELSE TipoCambio END
FROM POSLCobro p
WHERE ID = @IDAnterior
AND NULLIF(MonedaRef,'') IS NOT NULL
OPEN crPOSCobro
FETCH NEXT FROM crPOSCobro INTO @Importe, @FormaCobro, @Referencia,@CtaDinero,@CtaDineroDestino,@Moneda,@TipoCambio
WHILE @@FETCH_STATUS <> -1
BEGIN
IF @@FETCH_STATUS <> -2
BEGIN
SELECT @Renglon = ISNULL(@Renglon,0) + 2048
IF @MovClave IN('POS.ACM','POS.CCM','POS.CPCM','POS.TCM','POS.CACM','POS.CCCM','POS.CCPCM','POS.CTCM','POS.TRM','POS.CTRM')
BEGIN
IF @MovClave NOT IN('POS.TCM','POS.CTCM')
BEGIN
INSERT DineroD (
ID, Renglon, Importe, FormaPago, Referencia, Sucursal,Moneda,TipoCambio,CtaDinero,CtaDineroDestino)
VALUES (
@IDNuevo, @Renglon, @Importe, @FormaCobro, @Referencia, @Sucursal,@Moneda,@TipoCambio,@CtaDinero,@CtaDineroDestino)
END
IF @MovClave  IN('POS.TCM','POS.CTCM')
BEGIN
INSERT DineroD (
ID, Renglon, Importe, FormaPago, Referencia, Sucursal,Moneda,TipoCambio,CtaDinero,CtaDineroDestino)
VALUES (
@IDNuevo, @Renglon, @Importe, @FormaCobro, @Referencia, @Sucursal,@Moneda,@TipoCambio,@CtaDineroDestino,@CtaDinero)
END
END
IF @MovClave NOT IN('POS.ACM','POS.CCM','POS.CPCM','POS.TCM','POS.CACM','POS.CCCM','POS.CCPCM','POS.CTCM','POS.TRM','POS.CTRM')
BEGIN
INSERT DineroD (
ID, Renglon, Importe, FormaPago, Referencia, Sucursal,Moneda,TipoCambio,CtaDinero,CtaDineroDestino)
VALUES (
@IDNuevo, @Renglon, @Importe, @FormaCobro, @Referencia, @Sucursal,@Moneda,@TipoCambio,@CtaDinero,@CtaDineroDestino)
END
END
FETCH NEXT FROM crPOSCobro INTO @Importe, @FormaCobro, @Referencia,@CtaDinero,@CtaDineroDestino,@Moneda,@TipoCambio
END
CLOSE crPOSCobro
DEALLOCATE crPOSCobro
IF @MovClave IN('POS.ACM','POS.CCM','POS.CPCM','POS.TCM','POS.TRM','POS.AC','POS.CC','POS.CPC','POS.CAC')
BEGIN
SELECT TOP 1 @Moneda = Moneda
FROM POSLTipoCambioRef m
WHERE TipoCambio = 1 AND Sucursal = @Sucursal
IF EXISTS (SELECT * FROM DineroD WHERE Moneda = @Moneda AND ID = @IDNuevo)
BEGIN
SELECT TOP 1 @CtaDinero = CtaDinero,@CtaDineroDestino = CtaDineroDestino,@TipoCambio=TipoCambio
FROM DineroD WHERE ID = @IDNuevo AND Moneda = @Moneda
END
ELSE
BEGIN
SELECT TOP 1 @Moneda = Moneda ,@CtaDinero = CtaDinero,@CtaDineroDestino = CtaDineroDestino,@TipoCambio=TipoCambio
FROM DineroD WHERE ID = @IDNuevo
END
UPDATE Dinero SET Importe = (SELECT SUM(ImporteRef * TipoCambio) FROM POSLCobro WHERE ID = @IDAnterior),
CtaDinero = @CtaDinero,CtaDineroDestino = @CtaDineroDestino,FormaPago = NULL
WHERE ID = @IDNuevo
END
IF @MovClave NOT IN('POS.ACM','POS.CCM','POS.CPCM','POS.TCM','POS.TRM','POS.AC','POS.CC','POS.CPC','POS.CACM','POS.CAC','POS.IC','POS.EC')
BEGIN
SELECT TOP 1 @Moneda = MonedaRef ,@TipoCambio = TipoCambio,@CtaDinero = CtaDinero,@CtaDineroDestino = CtaDineroDestino
FROM POSLCobro
WHERE ID = @IDAnterior
SELECT @Importe =SUM(ImporteRef) FROM POSLCobro WHERE ID = @IDAnterior
IF @MovClave IN ('POS.FTE','POS.STE')
SELECT @CtaDinero = NULL,@CtaDineroDestino  = NULL
UPDATE Dinero SET Importe = ISNULL(@Importe,ISNULL(Importe,0.0)),
CtaDinero = ISNULL(@CtaDinero,CtaDinero),CtaDineroDestino = ISNULL(@CtaDineroDestino,CtaDineroDestino)
WHERE ID = @IDNuevo
END
IF @MovClave IN('POS.IC','POS.EC')
BEGIN
SELECT TOP 1 @Moneda = MonedaRef ,@TipoCambio = TipoCambio,@CtaDinero = CtaDinero,@CtaDineroDestino = CtaDineroDestino
FROM POSLCobro
WHERE ID = @IDAnterior
SELECT @Importe =SUM(ImporteRef) FROM POSLCobro WHERE ID = @IDAnterior
IF @MovClave IN ('POS.FTE','POS.STE')
SELECT @CtaDinero = NULL,@CtaDineroDestino  = NULL
UPDATE Dinero SET Importe = ISNULL(@Importe,ISNULL(Importe,0.0)),
CtaDinero = ISNULL(@CtaDinero,CtaDinero),CtaDineroDestino = ISNULL(@CtaDineroDestino,CtaDineroDestino), Moneda = @Moneda,TipoCambio = @TipoCambio
WHERE ID = @IDNuevo
END
IF @MovClave IN ('POS.CC', 'POS.CPC', 'POS.AC','POS.AP','POS.IC','POS.EC')
BEGIN
SELECT @Importe =SUM(ImporteRef) FROM POSLCobro WHERE ID = @IDAnterior
UPDATE Dinero SET Moneda = @Moneda, TipoCambio = @TipoCambio, Importe = @Importe WHERE ID = @IDNuevo
END
END

