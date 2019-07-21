SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spPOSGeneraFaltante
@Empresa		varchar(5),
@Sucursal		int,
@Usuario		varchar(10),
@ID				varchar(50),
@MovClave		varchar(20),
@Caja			varchar(10),
@Ok				int				OUTPUT,
@OkRef			varchar(255)    OUTPUT

AS
BEGIN
DECLARE
@CorteFormaPago			varchar(50),
@CorteImporte			float,
@Diferencia				float,
@SaldoCaja				float,
@MovInsertar			varchar(20),
@MovIDInsertar			varchar(20),
@IDInsertar				varchar(36),
@FechaEmision			datetime,
@Moneda					varchar(20),
@TipoCambio				float,
@Cliente				varchar(10),
@Agente					varchar(10),
@Almacen				varchar(10),
@Cajero					varchar(10),
@CtaDinero				varchar(10),
@CtaDineroDestino		varchar(10),
@Host					varchar(20),
@Cluster				varchar(20),
@Importe				float,
@ImporteRef				float,
@POSMoneda				varchar(20),
@TipoCambioRef			float,
@MonedaPrincipal		varchar(20),
@RedondeoMonetarios		int,
@POSMonedaAct			bit
SELECT @POSMonedaAct = POSMonedaAct FROM POSCfg WITH(NOLOCK) WHERE Empresa = @Empresa
SELECT @RedondeoMonetarios = dbo.fnPOSRedondeoMonetarios(@Empresa)
SELECT TOP 1 @MonedaPrincipal = Moneda
FROM POSLTipoCambioRef WITH(NOLOCK)
WHERE TipoCambio = 1	  AND Sucursal = @Sucursal AND EsPrincipal = 1
EXEC spPOSHost @Host OUTPUT, @Cluster OUTPUT
DECLARE crPOSLCobro CURSOR LOCAL FOR
SELECT plc.FormaPago, Importe = ROUND(SUM(plc.Importe),@RedondeoMonetarios)
FROM POSLCobro plc WITH(NOLOCK)
WHERE plc.ID = @ID
GROUP BY plc.FormaPago
UNION
SELECT plc.FormaPago, Importe = 0
FROM POSLCobro plc WITH(NOLOCK)
INNER JOIN POSL p WITH(NOLOCK) ON plc.ID = p.ID
INNER JOIN MovTipo mt WITH(NOLOCK) ON p.Mov = mt.Mov
AND mt.Modulo = 'POS'
WHERE p.Caja = @Caja
AND p.Estatus NOT IN ('CANCELADO', 'SINAFECTAR','PENDIENTE')
AND p.Empresa = @Empresa
AND plc.FormaPago NOT IN (SELECT plc.FormaPago
FROM POSLCobro plc WITH(NOLOCK)
WHERE plc.ID = @ID )
GROUP BY plc.FormaPago
OPEN crPOSLCobro
FETCH NEXT FROM crPOSLCobro INTO @CorteFormaPago, @CorteImporte
WHILE @@FETCH_STATUS <> -1
BEGIN
IF @@FETCH_STATUS <> -2
BEGIN
SELECT @Diferencia = 0.0, @POSMoneda = NULL, @ImporteRef = 0, @TipoCambioRef = NULL, @SaldoCaja = 0.0
SELECT @SaldoCaja = ROUND(SUM(plc.Importe * mt.Factor),@RedondeoMonetarios)
FROM POSLCobro plc WITH(NOLOCK)
INNER JOIN POSL p WITH(NOLOCK) ON plc.ID = p.ID
INNER JOIN MovTipo mt WITH(NOLOCK) ON p.Mov = mt.Mov
AND mt.Modulo = 'POS'
WHERE p.Caja = @Caja
AND p.Estatus NOT IN ('CANCELADO', 'SINAFECTAR','PENDIENTE')
AND p.Empresa = @Empresa
AND plc.FormaPago = @CorteFormaPago
GROUP BY plc.FormaPago
SELECT @Diferencia = ISNULL(@SaldoCaja,0) - ROUND(ISNULL(@CorteImporte,0),@RedondeoMonetarios)
SELECT @MovInsertar = NULL
IF ISNULL(@Diferencia,0) > 0
BEGIN
SELECT TOP 1 @MovInsertar = Mov
FROM MovTipo mt WITH(NOLOCK)
WHERE mt.Modulo = 'POS'
AND mt.Clave = 'POS.FTE'
SELECT @Importe = @Diferencia
END
IF ISNULL(@Diferencia,0) < 0
BEGIN
SELECT TOP 1 @MovInsertar = Mov
FROM MovTipo mt WITH(NOLOCK)
WHERE mt.Modulo = 'POS'
AND mt.Clave = 'POS.STE'
SELECT @Importe = @Diferencia * (-1)
END
IF @Ok IS NULL AND NULLIF(@MovInsertar,'') IS NOT NULL
BEGIN
SELECT
@FechaEmision = p.FechaEmision,
@Moneda = p.Moneda,
@TipoCambio = p.TipoCambio,
@Cliente = p.Cliente,
@Agente = p.Agente,
@Cajero = p.Cajero,
@Almacen = p.Almacen,
@CtaDinero = p.CtaDinero,
@CtaDineroDestino = p.CtaDineroDestino,
@Sucursal = p.Sucursal,
@Caja  = p.Caja
FROM POSL p WITH(NOLOCK)
WHERE p.ID = @ID
SELECT @POSMoneda = CASE WHEN @POSMonedaAct = 0 THEN NULLIF(Moneda,'') ELSE NULLIF(POSMoneda,'') END
FROM FormaPago fp WITH(NOLOCK)
WHERE fp.FormaPago = @CorteFormaPago
IF ISNULL(@POSMoneda, @MonedaPrincipal) <> @MonedaPrincipal
BEGIN
IF NOT EXISTS(SELECT TOP 1 TipoCambio FROM POSLTipoCambioRef WITH(NOLOCK) WHERE Sucursal = @Sucursal AND Moneda = @POSMoneda)
SELECT @ok = 35040, @okRef = @CorteFormaPago
END
IF ISNULL(@POSMoneda, @MonedaPrincipal) <> @MonedaPrincipal
SELECT @TipoCambioRef = ISNULL(ROUND(TipoCambio,@RedondeoMonetarios),1.0)
FROM POSLTipoCambioRef WITH(NOLOCK)
WHERE Sucursal = @Sucursal  AND Moneda = @POSMoneda
SELECT @ImporteRef = ISNULL(@ImporteRef,1.0)
SELECT @ImporteRef = ROUND(@Importe / ISNULL(@TipoCambioRef,1.0),@RedondeoMonetarios)
SELECT @IDInsertar = NEWID()
EXEC spPOSConsecutivoAuto @Empresa, @Sucursal, @MovInsertar, @MovIDInsertar OUTPUT, NULL, NULL, NULL, NULL, @Ok OUTPUT, @OkRef OUTPUT
IF @MovInsertar IS NOT NULL
INSERT POSL (
ID, Empresa, Modulo, Mov, MovID, FechaEmision, FechaRegistro, Moneda,
TipoCambio, Usuario, Estatus, Cliente, Almacen, Agente, Cajero, CtaDinero, Importe,
CtaDineroDestino, Sucursal, Host, IDR, Cluster, Caja)
VALUES (
@IDInsertar, @Empresa, 'DIN',  @MovInsertar, @MovIDInsertar, @FechaEmision, GETDATE(), ISNULL(@POSMoneda, @MonedaPrincipal),
ISNULL(@TipoCambioRef,1.0), @Usuario, 'CONCLUIDO', @Cliente, @Almacen, @Agente, @Cajero, @Caja, @Importe,
@CtaDineroDestino, @Sucursal, @Host, @ID, @Cluster, @Caja)
IF @MovInsertar IS NOT NULL
INSERT POSLCobro (
ID, FormaPago, Importe, CtaDinero, Fecha, Caja, Cajero, Host, ImporteRef,
TipoCambio,MonedaRef,CtaDineroDestino)
VALUES (
@IDInsertar, @CorteFormaPago, @Importe, @Caja, dbo.fnFechaSinHora(GETDATE()), @Caja, @Cajero, @Host, @ImporteRef,
ISNULL(@TipoCambioRef,1.0),@POSMoneda,@CtaDineroDestino)
END
END
FETCH NEXT FROM crPOSLCobro INTO @CorteFormaPago, @CorteImporte
END
CLOSE crPOSLCobro
DEALLOCATE crPOSLCobro
END

