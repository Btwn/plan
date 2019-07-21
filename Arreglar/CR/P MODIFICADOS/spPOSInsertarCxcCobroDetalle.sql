SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spPOSInsertarCxcCobroDetalle
@ID         	varchar(50),
@IDGenerar		int,
@Empresa        varchar(5),
@Sucursal       int,
@Usuario        varchar(10),
@Moneda			varchar(10),
@MovClave       varchar(20),
@Ok				int		OUTPUT,
@OkRef			varchar(255)	OUTPUT

AS
BEGIN
DECLARE
@Importe				float,
@ImporteTotal			float,
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
@MonederoTipoCambio		float,
@MonederoImporte		float,
@Aplica					varchar(20),
@AplicaID				varchar(20),
@Saldo					float,
@Cliente				varchar(10),
@ContMoneda				varchar(10),
@ContMonedaTC			float,
@FechaEmision			datetime,
@Agente					varchar(10),
@CteEnviarA				int,
@CtaDinero				varchar(10),
@Condicion				varchar(50),
@Impuestos				float,
@IDNuevo				varchar(36),
@ImporteRef				float
SELECT @FormaCobroMonedero = CxcFormaCobroTarjetas, @ContMoneda = ContMoneda
FROM EmpresaCfg WITH(NOLOCK)
WHERE Empresa = @Empresa
SELECT @ContMonedaTC = TipoCambio
FROM POSLTipoCambioRef WITH(NOLOCK)
WHERE Sucursal = @Sucursal AND Moneda = @ContMoneda
SELECT TOP 1 @Aplica = Aplica, @AplicaID = AplicaID
FROM POSLVenta WITH(NOLOCK)
WHERE ID = @ID
SELECT @ImporteTotal = SUM(ImporteRef)
FROM POSLCobro WITH(NOLOCK)
WHERE ID = @ID
SELECT @Cliente = Cliente
FROM Cxc WITH(NOLOCK)
WHERE ID = @IDGenerar
IF @MovClave = 'POS.CXCD'
BEGIN
SELECT TOP 1 @FormaCobro = FormaPago, @TipoCambio = TipoCambio FROM POSLCobro WITH(NOLOCK) WHERE ID = @ID
SELECT @ImporteTotal = SUM(ImporteRef*-1) FROM POSLCobro WITH(NOLOCK) WHERE ID = @ID
END
IF @MovClave = 'POS.CXCC'
BEGIN
SELECT @ImporteTotal = SUM(Precio*-1) FROM POSLVenta WITH(NOLOCK) WHERE ID = @ID
END
IF @Ok IS NULL AND @IDGenerar IS NOT NULL AND @MovClave IN('POS.CXCC')
BEGIN
DECLARE crPOSCobro CURSOR LOCAL FOR
SELECT TOP 5 (p.ImporteRef), p.FormaPago, p.Referencia, p.TipoCambio, p.Monedero, p.MonederoTipoCambio, p.MonederoImporte
FROM POSLCobro p WITH(NOLOCK)
WHERE ID = @ID AND Referencia NOT IN('COMISION CREDITO')
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
@Empresa, @IDGenerar, 'VTAS', @Monedero, @Sucursal, @MonederoImporte, @MonederoTipoCambio, @Importe
IF @@ERROR <> 0
SET @Ok = 1
END
END
FETCH NEXT FROM crPOSCobro INTO @Importe, @FormaCobro, @Referencia, @TipoCambio, @Monedero, @MonederoTipoCambio, @MonederoImporte
END
CLOSE crPOSCobro
DEALLOCATE crPOSCobro
END
SELECT @ImporteRef = SUM(ISNULL(p.ImporteRef,0))
FROM POSLCobro p WITH(NOLOCK)
WHERE ID = @ID AND Referencia IN('COMISION CREDITO')
UPDATE Cxc WITH(ROWLOCK)
SET ConDesglose= CASE WHEN @MovClave = 'POS.CXCC' THEN  1 ELSE  0 END,
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
Importe = (CASE WHEN @MovClave = 'POS.CXCC'
THEN ISNULL(@Importe1,0.0)+ISNULL(@Importe2,0.0)+ISNULL(@Importe3,0.0)+ISNULL(@Importe4,0.0)+ISNULL(@Importe5,0.0)
ELSE @ImporteTotal
END),
OrigenTipo = 'POS',
AplicaManual = 1,
FormaCobro = CASE WHEN @MovClave = 'POS.CXCD' THEN  @FormaCobro ELSE  NULL END
WHERE ID = @IDGenerar
IF @@ERROR <> 0
SET @Ok = 1
SELECT @Saldo = ISNULL(Saldo,0.0)
FROM Cxc WITH(NOLOCK)
WHERE Empresa = @Empresa AND Mov = @Aplica AND MovID = @AplicaID AND Estatus IN ('PENDIENTE', 'CONCLUIDO')
IF @MovClave = 'POS.CXCD'
BEGIN
INSERT CxcD (
ID, Renglon, RenglonSub, Importe, Aplica,  AplicaID, SucursalOrigen)
SELECT
@IDGenerar, 2048.0, 0, CASE WHEN (@ImporteTotal > @Saldo)
THEN @Saldo
ELSE @ImporteTotal
END, @Aplica, @AplicaID, @Sucursal
END
INSERT POSHistMoratorios(
FechaCobro, ID, POSMov, POSMovID, IDGenerado, CXCMov, CXCMovID, Saldo, Moratorios, TasaMoratorios, DiasMoratorios, Moneda, Sucursal,
Empresa, Aplica, AplicaID)
SELECT
GETDATE(), a.ID, a.Mov, a.MovID, @IDGenerar, @Mov, @MovID, a.CXCSaldoTotal, b.Precio, b.TasaMoratorios, b.DiasMoratorios, a.Moneda, @Sucursal,
@Empresa, b.Aplica, b.AplicaID
FROM POSL a WITH(NOLOCK) JOIN POSLVenta b WITH(NOLOCK) on a.ID = b.ID
WHERE a.ID = @ID
AND b.Articulo = 'MORATORIO'
IF @@ERROR <> 0
SET @Ok = 1
IF (@ImporteTotal > @Saldo)
BEGIN
INSERT CxcAplicaDif(
ID, Mov, Concepto, Importe, Impuestos, Cliente, Sucursal, SucursalOrigen)
SELECT
@IDGenerar,'Saldo a Favor', NULL, (@ImporteTotal-@Saldo), 0.0, @Cliente, @Sucursal, @Sucursal
IF @@ERROR <> 0
SET @Ok = 1
END
END

