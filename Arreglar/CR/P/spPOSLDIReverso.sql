SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spPOSLDIReverso
@ID				varchar(36),
@FormaPago		varchar(50),
@Empresa        varchar(5),
@Usuario        varchar(10),
@Sucursal       int,
@Ok				int	OUTPUT,
@OkRef			varchar(255) OUTPUT

AS
BEGIN
DECLARE
@Importe			float,
@Referencia			varchar(50),
@Monedero			varchar(36),
@CtaDinero			varchar(10),
@Servicio			varchar(20),
@ServicioInverso	varchar(20),
@Fecha				datetime,
@Caja				varchar(10),
@Cajero				varchar(10),
@Host				varchar(20),
@Cluster			varchar(20),
@ImporteRef         float,
@TipoCambio         float,
@MonedaRef          varchar(10),
@MovClave           varchar(20)
EXEC spPOSHost @Host	OUTPUT, @Cluster OUTPUT
SELECT
@Caja = Caja,
@Cajero = Cajero
FROM POSHost
WHERE Host = @Host
SELECT @MovClave = mt.Clave
FROM POSL p JOIN MovTipo mt ON p.Mov = mt.Mov AND mt.Modulo = 'POS'
WHERE p.ID = @ID
SELECT @Fecha = GETDATE()
DECLARE crFormaPago CURSOR LOCAL FOR
SELECT
SUM(Importe),
Referencia,
Monedero,
CtaDinero,
SUM(ImporteRef),
TipoCambio,
MonedaRef
FROM POSLCobro pc
WHERE pc.ID = @ID
AND FormaPago = @FormaPago
GROUP BY ID, Referencia, Monedero, CtaDinero, TipoCambio, MonedaRef
HAVING SUM(Importe) > 0
OPEN crFormaPago
FETCH NEXT FROM crFormaPago INTO @Importe, @Referencia, @Monedero, @CtaDinero, @ImporteRef, @TipoCambio, @MonedaRef
WHILE @@FETCH_STATUS <> -1
BEGIN
IF @@FETCH_STATUS <> -2
BEGIN
SELECT
@Servicio = Servicio,
@ServicioInverso = ServicioInverso
FROM POSLDIFormaPago plfp
WHERE plfp.FormaPago = @FormaPago
IF @MovClave NOT IN ('POS.N','POS.F', 'POS.FA', 'POS.P')
SELECT @Servicio = NULL, @ServicioInverso = NULL
IF @Servicio IS NOT NULL AND @ServicioInverso IS NULL
SELECT @Ok = 20500, @OkRef = 'Es necesario configurar el Servicio Inverso de la Forma de Pago'
IF @Importe IS NULL OR @Importe <0.1 OR @Importe = 0.0
SELECT @Ok  = 30447
IF @Ok IS NULL AND @ServicioInverso IS NOT NULL
BEGIN
EXEC spPOSLDI @ServicioInverso, @ID, @Monedero, @Empresa, @Usuario, @Sucursal, NULL, @Importe, 1, NULL, @Ok OUTPUT, @OkRef OUTPUT
END
IF @Ok IS NULL
BEGIN
IF NULLIF(@ServicioInverso,'') IS NULL
AND @MovClave IN ('POS.AC', 'POS.ACM', 'POS.AP', 'POS.CAC', 'POS.CACM', 'POS.CC', 'POS.CCC',
'POS.CCCM', 'POS.CCM', 'POS.CPC', 'POS.CPCM', 'POS.N', 'POS.F', 'POS.CTCM', 'POS.CTRM',
'POS.EC', 'POS.IC', 'POS.TCM', 'POS.TRM')
BEGIN
DELETE POSLCobro WHERE ID = @ID AND FormaPago = @FormaPago
END
ELSE
IF NULLIF(@ServicioInverso,'') IS NULL
AND @MovClave NOT IN ('POS.AC', 'POS.ACM', 'POS.AP', 'POS.CAC', 'POS.CACM', 'POS.CC', 'POS.CCC',
'POS.CCCM', 'POS.CCM', 'POS.CPC', 'POS.CPCM', 'POS.N', 'POS.F', 'POS.CTCM', 'POS.CTRM',
'POS.EC', 'POS.IC', 'POS.TCM', 'POS.TRM')
BEGIN
INSERT POSLCobro (
ID, FormaPago, Importe, Referencia, CtaDinero, Monedero, Fecha, Caja, Cajero, Host, ImporteRef, TipoCambio, MonedaRef)
VALUES (
@ID, @FormaPago, @Importe*(-1), @Referencia, @CtaDinero, @Monedero, @Fecha, @Caja, @Cajero, @Host, @ImporteRef*(-1), @TipoCambio, @MonedaRef)
END
END
END
FETCH NEXT FROM crFormaPago INTO @Importe, @Referencia, @Monedero, @CtaDinero, @ImporteRef, @TipoCambio, @MonedaRef
END
CLOSE crFormaPago
DEALLOCATE crFormaPago
END

