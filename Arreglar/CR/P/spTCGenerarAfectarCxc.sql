SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROC spTCGenerarAfectarCxc
@Empresa			varchar(5),
@Modulo				varchar(5),
@ID					int,
@CodigoAutorizacion	varchar(255),
@FormaPago			varchar(50),
@Importe			float,
@Accion				varchar(20),
@CancelaRID			int,
@Usuario			varchar(10),
@CxcID				int				OUTPUT,
@Ok					int				OUTPUT,
@OkRef				varchar(255)	OUTPUT

AS
BEGIN
DECLARE @CxMov						varchar(20),
@FechaEmision					datetime,
@Estatus						varchar(15),
@VentaLiquidaIntegralCxc		bit,
@CxEstatus					varchar(15)
SELECT @Estatus = Estatus FROM Venta WHERE ID = @ID
IF @Accion IN('Auth', 'Credit')
BEGIN
SELECT @FechaEmision = GETDATE()
EXEC spExtraerFecha @FechaEmision OUTPUT
IF @Accion = 'Auth'
SELECT @CxMov = CxcMovAnticipo FROM TCCfg WHERE Empresa = @Empresa
ELSE IF @Accion = 'Credit'
BEGIN
SELECT @VentaLiquidaIntegralCxc = ISNULL(VentaLiquidaIntegralCxc, 0) FROM EmpresaCfg WHERE Empresa = @Empresa
IF @VentaLiquidaIntegralCxc = 1
SELECT @CxMov = CxcMovDevolucion FROM TCCfg WHERE Empresa = @Empresa
ELSE
SELECT @CxMov = CxcMovAnticipo FROM TCCfg WHERE Empresa = @Empresa
END
INSERT INTO Cxc(
Empresa, Cliente,   ClienteEnviarA, Agente,    Mov,    TarjetaBancariaAutorizacion,  Importe, Impuestos, Proyecto,   Moneda,    FechaEmision, TipoCambio,    Usuario, Estatus,      ClienteMoneda, ClienteTipoCambio,             CtaDinero,       Vencimiento,   FormaCobro, Sucursal)
SELECT @Empresa, v.Cliente, v.EnviarA,      v.Agente, @CxMov, @CodigoAutorizacion,          @Importe, 0,         v.Proyecto, v.Moneda, @FechaEmision, v.TipoCambio, @Usuario, 'SINAFECTAR', c.DefMoneda,   dbo.fnTipoCambio(c.DefMoneda), u.DefCtaDinero, @FechaEmision, @FormaPago,  v.Sucursal
FROM Venta v
JOIN Cte c ON v.Cliente = c.Cliente
JOIN Usuario u ON u.Usuario = @Usuario
WHERE v.ID = @ID
SELECT @CxcID = @@IDENTITY
IF @CxcID IS NOT NULL
BEGIN
EXEC spAfectar 'CXC', @CxcID, 'AFECTAR', @Usuario = @Usuario, @Conexion = 1, @EnSilencio = 1, @Ok = @Ok OUTPUT, @OkRef = @OkRef OUTPUT
IF @Ok IS NULL OR @Ok BETWEEN 80030 AND 81000
UPDATE VentaCobro SET TCDelEfectivo = ISNULL(TCDelEfectivo, 0) + ISNULL(@Importe, 0) WHERE ID = @ID
END
END
ELSE IF @Accion = 'Void'
BEGIN
SELECT @CxcID = CxcID FROM TCTransaccion WHERE RID = @CancelaRID
SELECT @CxEstatus = Estatus FROM Cxc WHERE ID = @CxcID
IF @CxcID IS NOT NULL
BEGIN
IF @CxEstatus IN('PENDIENTE', 'CONCLUIDO')
EXEC spAfectar 'CXC', @CxcID, 'CANCELAR', @Usuario = @Usuario, @Conexion = 1, @EnSilencio = 1, @Ok = @Ok OUTPUT, @OkRef = @OkRef OUTPUT
IF @Ok IS NULL OR @Ok BETWEEN 80030 AND 81000
BEGIN
IF @Estatus <> 'CONCLUIDO'
UPDATE VentaCobro SET TCDelEfectivo = ISNULL(TCDelEfectivo, 0) - ISNULL(@Importe, 0) WHERE ID = @ID
END
END
END
IF @Ok IS NULL OR @Ok BETWEEN 80030 AND 81000
SELECT @Ok = NULL, @OkRef = NULL
END

