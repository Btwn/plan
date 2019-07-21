SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE xpPOSAfectarVentaCobro
@IDAnterior		varchar(50),
@IDNuevo		varchar(50),
@Empresa        varchar(5),
@Sucursal       int,
@Ok				int				OUTPUT,
@OkRef			varchar(255)	OUTPUT
AS
BEGIN
DECLARE
@ContMoneda				varchar(10),
@RedondeosMonetarios	int,
@POSMoneda1				varchar(10),
@POSMoneda2				varchar(10),
@POSMoneda3				varchar(10),
@POSMoneda4				varchar(10),
@POSMoneda5				varchar(10)
SELECT @RedondeosMonetarios = RedondeosMonetarios
FROM POSCfg
WHERE Empresa = @Empresa
SELECT @ContMoneda = RTRIM(ContMoneda)
FROM EmpresaCfg
WHERE Empresa = @Empresa
IF (Select POSMonedaAct from POSCfg where Empresa = @Empresa) = 1
BEGIN
SELECT @POSMoneda1 = NULL, @POSMoneda2 = NULL, @POSMoneda3 = NULL, @POSMoneda4 = NULL, @POSMoneda5 = NULL
SELECT @POSMoneda1 = RTRIM(NULLIF(POSMoneda,'')) FROM FormaPago WHERE FormaPago = (SELECT FormaCobro1 FROM VentaCobro WHERE ID = @IDNuevo)
SELECT @POSMoneda2 = RTRIM(NULLIF(POSMoneda,'')) FROM FormaPago WHERE FormaPago = (SELECT FormaCobro2 FROM VentaCobro WHERE ID = @IDNuevo)
SELECT @POSMoneda3 = RTRIM(NULLIF(POSMoneda,'')) FROM FormaPago WHERE FormaPago = (SELECT FormaCobro3 FROM VentaCobro WHERE ID = @IDNuevo)
SELECT @POSMoneda4 = RTRIM(NULLIF(POSMoneda,'')) FROM FormaPago WHERE FormaPago = (SELECT FormaCobro4 FROM VentaCobro WHERE ID = @IDNuevo)
SELECT @POSMoneda5 = RTRIM(NULLIF(POSMoneda,'')) FROM FormaPago WHERE FormaPago = (SELECT FormaCobro5 FROM VentaCobro WHERE ID = @IDNuevo)
IF @POSMoneda1 IS NOT NULL AND @POSMoneda1 <>  @ContMoneda
UPDATE VentaCobro SET Referencia1 = 'POS ' + CONVERT(VARCHAR,Importe1) +' TC. ' +
CONVERT(VARCHAR,POSTipoCambio1), Importe1 = ROUND((Importe1 * POSTipoCambio1),@RedondeosMonetarios), POSTipoCambio1 = 1 WHERE ID = @IDNuevo
IF @POSMoneda2 IS NOT NULL AND @POSMoneda2 <>  @ContMoneda
UPDATE VentaCobro SET Referencia2 = 'POS ' + CONVERT(VARCHAR,Importe2) +' TC. ' +
CONVERT(VARCHAR,POSTipoCambio2), Importe2 = ROUND((Importe2 * POSTipoCambio2),@RedondeosMonetarios), POSTipoCambio2 = 1 WHERE ID = @IDNuevo
IF @POSMoneda3 IS NOT NULL AND @POSMoneda3 <>  @ContMoneda
UPDATE VentaCobro SET Referencia3 = 'POS ' + CONVERT(VARCHAR,Importe3) +' TC. ' +
CONVERT(VARCHAR,POSTipoCambio3), Importe3 = ROUND((Importe3 * POSTipoCambio3),@RedondeosMonetarios), POSTipoCambio3 = 1 WHERE ID = @IDNuevo
IF @POSMoneda4 IS NOT NULL AND @POSMoneda4 <>  @ContMoneda
UPDATE VentaCobro SET Referencia4 = 'POS ' + CONVERT(VARCHAR,Importe4) +' TC. ' +
CONVERT(VARCHAR,POSTipoCambio4), Importe4 = ROUND((Importe4 * POSTipoCambio4),@RedondeosMonetarios), POSTipoCambio4 = 1 WHERE ID = @IDNuevo
IF @POSMoneda5 IS NOT NULL AND @POSMoneda5 <>  @ContMoneda
UPDATE VentaCobro SET Referencia5 = 'POS ' + CONVERT(VARCHAR,Importe5) +' TC. ' +
CONVERT(VARCHAR,POSTipoCambio5), Importe5 = ROUND((Importe5 * POSTipoCambio5),@RedondeosMonetarios), POSTipoCambio5 = 1 WHERE ID = @IDNuevo
END
RETURN
END

