SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE xpPOSAfectarDineroD
@IDAnterior		varchar(50),
@IDNuevo		varchar(50),
@Sucursal		int,
@MovClave       varchar(20),
@Ok				int		OUTPUT,
@OkRef			varchar(255)	OUTPUT
AS
BEGIN
DECLARE
@Empresa				varchar(5),
@RedondeosMonetarios	int,
@Moneda					varchar(10),
@TipoCambio				float,
@Renglon				int,
@ImporteD				money,
@TipoCambioD			float,
@ReferenciaD			varchar(50),
@DecimalesCantidades	int,
@Fondo					varchar(50)
SELECT @Empresa = Empresa
FROM Dinero
WHERE ID = @IDNuevo
SELECT @RedondeosMonetarios = RedondeosMonetarios
FROM POSCfg
WHERE Empresa = @Empresa
SELECT @DecimalesCantidades = DecimalesCantidades
FROM EmpresaGral
WHERE Empresa = @Empresa
SELECT TOP 1 @Moneda = Moneda, @TipoCambio = TipoCambio
FROM POSLTipoCambioRef
WHERE EsPrincipal = 1 AND Sucursal = @Sucursal
SELECT @Fondo = NULLIF(F8,'')
FROM POSCobroFormasPago
WHERE Empresa = @Empresa AND Sucursal = @Sucursal
IF (SELECT POSMonedaAct FROM POSCfg WHERE Empresa = @Empresa) = 1 AND @MovClave IN ('POS.CPC','POS.CC')
BEGIN
IF EXISTS (SELECT dd.* FROM DineroD dd JOIN FormaPago fp ON dd.FormaPago = fp.FormaPago WHERE dd.ID = @IDNuevo AND fp.POSMoneda <> @Moneda)
BEGIN
DECLARE crST1 CURSOR LOCAL FOR
SELECT dd.Renglon, dd.Importe, dd.TipoCambio, dd.Referencia
FROM DineroD dd
JOIN FormaPago fp ON dd.FormaPago = fp.FormaPago
WHERE dd.ID = @IDNuevo
AND fp.POSMoneda <> @Moneda
OPEN crST1
FETCH NEXT FROM crST1 INTO @Renglon, @ImporteD, @TipoCambioD, @ReferenciaD
WHILE @@FETCH_STATUS <> -1
BEGIN
IF @@FETCH_STATUS <> -2
BEGIN
UPDATE DineroD SET
Importe = ROUND (@ImporteD * @TipoCambioD, @DecimalesCantidades),
Referencia = 'POS ' + CONVERT(VARCHAR,@ImporteD) + ' TC. ' + CONVERT(VARCHAR,@TipoCambioD),
TipoCambio = @TipoCambio,
Moneda = @Moneda
WHERE ID = @IDNuevo
AND Renglon = @Renglon
END
FETCH NEXT FROM crST1 INTO @Renglon, @ImporteD, @TipoCambioD, @ReferenciaD
END
CLOSE crST1
DEALLOCATE crST1
UPDATE Dinero SET Importe = (SELECT SUM(ISNULL(Importe,0)) FROM DineroD WHERE ID = @IDNuevo) WHERE ID = @IDNuevo
END
END
IF (SELECT POSMonedaAct FROM POSCfg WHERE Empresa = @Empresa) = 1 AND @MovClave IN ('POS.FTE','POS.STE') AND (SELECT Moneda  FROM Dinero WHERE ID = @IDNuevo) <> @Moneda
BEGIN
DECLARE crST2 CURSOR LOCAL FOR
SELECT dd.Renglon, dd.Importe, dd.TipoCambio, dd.Referencia
FROM DineroD dd
JOIN FormaPago fp ON dd.FormaPago = fp.FormaPago
WHERE dd.ID = @IDNuevo
AND fp.POSMoneda <> @Moneda
OPEN crST2
FETCH NEXT FROM crST2 INTO @Renglon, @ImporteD, @TipoCambioD, @ReferenciaD
WHILE @@FETCH_STATUS <> -1
BEGIN
IF @@FETCH_STATUS <> -2
BEGIN
UPDATE DineroD SET
Importe = ROUND (@ImporteD * @TipoCambioD, @DecimalesCantidades),
Referencia = 'POS ' + CONVERT(VARCHAR,@ImporteD) + ' TC. ' + CONVERT(VARCHAR,@TipoCambioD),
TipoCambio = @TipoCambio,
Moneda = @Moneda
WHERE ID = @IDNuevo
AND Renglon = @Renglon
END
FETCH NEXT FROM crST2 INTO @Renglon, @ImporteD, @TipoCambioD, @ReferenciaD
END
CLOSE crST2
DEALLOCATE crST2
UPDATE Dinero SET Importe = (SELECT SUM(ISNULL(Importe,0)) FROM DineroD WHERE ID = @IDNuevo), Moneda = @Moneda, TipoCambio = @TipoCambio WHERE ID = @IDNuevo
END
IF (SELECT POSMonedaAct FROM POSCfg WHERE Empresa = @Empresa) = 1 AND @MovClave IN ('POS.TCM')
BEGIN
DECLARE crST2 CURSOR LOCAL FOR
SELECT dd.Renglon, dd.Importe, dd.TipoCambio, dd.Referencia
FROM DineroD dd
JOIN FormaPago fp ON dd.FormaPago = fp.FormaPago
WHERE dd.ID = @IDNuevo
AND fp.POSMoneda <> @Moneda
OPEN crST2
FETCH NEXT FROM crST2 INTO @Renglon, @ImporteD, @TipoCambioD, @ReferenciaD
WHILE @@FETCH_STATUS <> -1
BEGIN
IF @@FETCH_STATUS <> -2
BEGIN
UPDATE DineroD SET
Importe = ROUND (@ImporteD * @TipoCambioD, @DecimalesCantidades),
Referencia = 'POS ' + CONVERT(VARCHAR,@ImporteD) + ' TC. ' + CONVERT(VARCHAR,@TipoCambioD),
TipoCambio = @TipoCambio,
Moneda = @Moneda
WHERE ID = @IDNuevo
AND Renglon = @Renglon
END
FETCH NEXT FROM crST2 INTO @Renglon, @ImporteD, @TipoCambioD, @ReferenciaD
END
CLOSE crST2
DEALLOCATE crST2
UPDATE Dinero SET Importe = (SELECT SUM(ISNULL(Importe,0)) FROM DineroD WHERE ID = @IDNuevo), Moneda = @Moneda, TipoCambio = @TipoCambio WHERE ID = @IDNuevo
END
IF @MovClave = 'POS.CC' 
BEGIN
DELETE FROM DineroD WHERE ID = @IDNuevo AND Importe = 0 AND FormaPago <> @Fondo
IF EXISTS (SELECT * FROM DineroD WHERE ID = @IDNuevo AND FormaPago <> @Fondo) AND (SELECT Importe FROM DineroD WHERE ID = @IDNuevo AND FormaPago = @Fondo) = 0
DELETE FROM DineroD WHERE ID = @IDNuevo AND FormaPago = @Fondo
END
RETURN
END

