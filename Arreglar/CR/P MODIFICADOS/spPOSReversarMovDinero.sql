SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spPOSReversarMovDinero
@Empresa           varchar(5),
@Sucursal          int,
@Usuario           varchar(10),
@ID                varchar(36),
@MovClave          varchar(20),
@Codigo            varchar(50),
@Ok                int OUTPUT,
@OkRef             varchar(255) OUTPUT

AS
BEGIN
DECLARE
@CtaDinero                  varchar(20),
@Caja                       varchar(20),
@CtaDineroDestino           varchar(20),
@Importe                    float
SELECT @CtaDinero = CtaDinero, @CtaDineroDestino = CtaDineroDestino, @Importe = Importe, @Caja = Caja
FROM POSL WITH (NOLOCK) WHERE ID = @Codigo
IF @MovClave IN('POS.CAC', 'POS.CCC', 'POS.CACM', 'POS.CCCM','POS.CTCM','POS.CTRM' )
BEGIN
IF @MovClave IN('POS.CAC', 'POS.CCC', 'POS.CACM', 'POS.CCCM')
UPDATE POSL WITH (ROWLOCK)
SET CtaDinero =  @CtaDineroDestino, CtaDineroDestino = @CtaDinero, Importe = @Importe
WHERE ID = @ID
IF @@ERROR <> 0
SET @Ok = 1
IF @MovClave IN('POS.CTRM','POS.CTCM')
UPDATE POSL WITH (ROWLOCK)
SET CtaDinero =  @CtaDinero, CtaDineroDestino = @CtaDineroDestino , Importe = @Importe, Caja = @CtaDinero
WHERE ID = @ID
IF @@ERROR <> 0
SET @Ok = 1
IF EXISTS(SELECT * FROM POSLCobro WITH (NOLOCK) WHERE ID = @ID)
DELETE  POSLCobro WHERE ID = @ID
IF @MovClave IN('POS.CAC', 'POS.CCC', 'POS.CACM', 'POS.CCCM')
INSERT POSLCobro(
ID, FormaPago, Importe, Referencia, Monedero, CtaDinero, Fecha, Caja, Cajero, Host, ImporteRef, TipoCambio,
Voucher, Banco, MonedaRef, CtaDineroDestino)
SELECT
@ID, FormaPago, Importe, Referencia, Monedero, CtaDineroDestino, Fecha, @Caja, Cajero, Host, ImporteRef, TipoCambio,
Voucher, Banco, MonedaRef, CtaDinero
FROM POSLCobro WITH (NOLOCK)
WHERE ID = @Codigo
IF @@ERROR <> 0
SET @Ok = 1
IF @MovClave IN('POS.CTRM','POS.CTCM')
INSERT POSLCobro(
ID, FormaPago, Importe, Referencia, Monedero, CtaDinero, Fecha, Caja,  Cajero, Host, ImporteRef, TipoCambio,
Voucher, Banco, MonedaRef, CtaDineroDestino)
SELECT
@ID, FormaPago, Importe, Referencia, Monedero, CtaDinero, Fecha, @Caja, Cajero, Host, ImporteRef, TipoCambio,
Voucher, Banco, MonedaRef, CtaDineroDestino
FROM POSLCobro WITH (NOLOCK)
WHERE ID = @Codigo
IF @@ERROR <> 0
SET @Ok = 1
END
END

