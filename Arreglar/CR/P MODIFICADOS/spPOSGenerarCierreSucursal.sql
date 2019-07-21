SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spPOSGenerarCierreSucursal
@Empresa				varchar(5),
@Sucursal				int,
@Estacion				int,
@Usuario				varchar(10),
@Mov					varchar(20),
@CtaDineroDestino		varchar(10),
@Fecha					datetime

AS
BEGIN
DECLARE
@Ok						int,
@OkRef					varchar(255),
@FechaActual			datetime,
@Caja					varchar(10),
@ID						varchar(50),
@Cajero					varchar(10),
@Host					varchar(10),
@Cluster				varchar(10),
@RedondeoMonetarios		int,
@Codigo					varchar(30),
@Moneda					varchar(10),
@FormaPago				varchar(50),
@POSMonedaAct			bit
SELECT @POSMonedaAct = POSMonedaAct
FROM POSCfg WITH (NOLOCK)
WHERE Empresa = @Empresa
SELECT @Caja = DefCtaDinero, @Cajero = DefCajero
FROM Usuario WITH (NOLOCK)
WHERE Usuario = @Usuario
SELECT @RedondeoMonetarios = dbo.fnPOSRedondeoMonetarios(@Empresa)
SELECT @Fecha = dbo.fnFechaSinHora(@Fecha)
SELECT @Moneda = Moneda
FROM POSLTipoCambioRef WITH (NOLOCK)
WHERE Sucursal = @Sucursal AND EsPrincipal = 1 AND TipoCambio = 1.0
SELECT TOP 1 @FormaPago = FormaPago
FROM FormaPago WITH (NOLOCK)
WHERE Moneda = @Moneda
EXEC spPOSHost @Host OUTPUT, @Cluster OUTPUT
SELECT TOP 1 @Codigo = Codigo
FROM CB WITH (NOLOCK)
WHERE TipoCuenta = 'Accion' AND Accion = 'CONCLUIR MOVIMIENTO'
IF NOT EXISTS(SELECT * FROM POSFechaCierre WITH (NOLOCK) WHERE Sucursal = @Sucursal)
SELECT @Ok = 1 , @OkRef = ''
SELECT @FechaActual = Fecha
FROM POSFechaCierre WITH (NOLOCK)
WHERE Sucursal = @Sucursal
IF EXISTS (SELECT * FROM POSEstatusCajasCierre WITH (NOLOCK) WHERE Sucursal = @Sucursal AND Fecha = @FechaActual AND Caja <> @Caja)
SELECT @Ok = 30448, @OkRef = '('+(SELECT TOP 1 Caja FROM POSEstatusCajasCierre WITH (NOLOCK) WHERE Sucursal = @Sucursal AND dbo.fnFechaSinHora(Fecha) = @FechaActual AND Caja <> @Caja )+')'
IF (SELECT Abierto FROM POSEstatusCaja WITH (NOLOCK) WHERE Caja = @Caja) = 0
SELECT @Ok =30440, @OkRef = @Caja
IF @Ok IS NOT NULL
SELECT @OkRef = Descripcion +' '+ ISNULL(@OkRef,'')
FROM MensajeLista WITH (NOLOCK)
WHERE Mensaje = @Ok
IF @Ok IS NULL
BEGIN
EXEC spPOSMovNuevo @Empresa, 'DIN', @Sucursal, @Usuario, @Estacion, @ID OUTPUT, NULL
UPDATE POSL WITH (ROWLOCK) SET Mov = @Mov, Modulo = 'DIN', CtaDineroDestino = @CtaDineroDestino WHERE ID = @ID
IF @@ERROR <> 0
SET @Ok = 1
IF @Ok IS NULL
BEGIN
IF EXISTS(SELECT * FROM   POSCierreSucursalD p WITH (NOLOCK)     WHERE p.Estacion = @Estacion AND p.Sucursal = @Sucursal HAVING SUM(Importe) >0.0)
BEGIN
INSERT POSLCobro (
ID, FormaPago, Importe, Referencia, CtaDinero, Fecha, Caja,
Cajero, Host, ImporteRef, TipoCambio, MonedaRef, CtaDineroDestino)
SELECT
@ID, p.FormaPago,ROUND(ROUND(p.Importe,@RedondeoMonetarios)* t.TipoCambio,@RedondeoMonetarios), p.Referencia, @Caja, @Fecha, @Caja,
@Cajero, @Host, p.Importe, t.TipoCambio,  CASE WHEN @POSMonedaAct = 0 THEN f.Moneda ELSE f.POSMoneda END, @CtaDineroDestino
FROM POSCierreSucursalD p WITH (NOLOCK) JOIN FormaPago f WITH (NOLOCK) ON p.FormaPago = f.FormaPago
JOIN POSLTipoCambioRef t WITH (NOLOCK) ON t.Moneda = CASE WHEN @POSMonedaAct = 0 THEN f.Moneda ELSE f.POSMoneda END AND t.Sucursal = p.Sucursal
WHERE p.Estacion = @Estacion
AND p.Sucursal = @Sucursal
IF @@ERROR <> 0
SET @Ok = 1
END
ELSE
BEGIN
INSERT POSLCobro (
ID, FormaPago, Importe, Referencia, CtaDinero, Fecha, Caja, Cajero, Host, ImporteRef, TipoCambio, MonedaRef, CtaDineroDestino)
SELECT
@ID, @FormaPago, 0.0, NULL, @Caja, @Fecha, @Caja, @Cajero, @Host, 0.0, 1.0, @Moneda, @CtaDineroDestino
IF @@ERROR <> 0
SET @Ok = 1
END
END
IF @Ok IS NULL
EXEC spPOS @Estacion , @Codigo, @Empresa, 'VTAS', @Sucursal, @Usuario, NULL, @ID, 0, null, 0, 0, NULL, NULL, NULL, @EnSilencio = 1,
@Ok = @Ok OUTPUT, @OkRef = @OkRef OUTPUT
END
IF @Ok IS NULL
SELECT @OkRef = 'PROCEDIMIENTO CONCLUIDO CON EXITO'
SELECT @OkRef
RETURN
END

