SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spValeCancelaSaldosTarjetas
@Empresa			varchar(5),
@Usuario			varchar(10),
@Sucursal			int,
@FechaEmision		datetime,
@Ok					int = NULL		OUTPUT,
@OkRef				varchar(255) = NULL		OUTPUT

AS
BEGIN
DECLARE
@ID			int,
@Mov			varchar(20),
@Moneda		varchar(10),
@TipoCambio	float
SELECT @Mov = 'Caducidad Saldo'
SELECT @FechaEmision = dbo.fnFechaSinHora(@FechaEmision)
SELECT @Moneda = ec.ContMoneda FROM EmpresaCfg ec WHERE ec.Empresa = @Empresa
SELECT @TipoCambio = m.TipoCambio FROM Mon m WHERE m.Moneda = @Moneda
INSERT INTO Vale
(Empresa,  Mov,  FechaEmision,  Moneda,  TipoCambio,  Usuario, Observaciones,
Estatus, Sucursal, SucursalOrigen)
VALUES(@Empresa, @Mov, @FechaEmision, @Moneda, @TipoCambio, @Usuario, 'Caducidad Saldo - Cierre de Día',
'SINAFECTAR', @Sucursal, @Sucursal)
SELECT @ID = SCOPE_IDENTITY()
INSERT INTO ValeD(ID, Serie, Sucursal, SucursalOrigen, Importe)
SELECT @ID, Serie, @Sucursal, @Sucursal, dbo.fnVerSaldoVale(Serie)
FROM ValeSerie
WHERE dbo.fnVerSaldoVale(Serie) > 0 AND Empresa = @Empresa AND Moneda = @Moneda
EXEC spAfectar 'VALE', @ID, 'AFECTAR', 'Todo', NULL, @Usuario, @Ok = @Ok OUTPUT, @OkRef = @OkRef OUTPUT
END

