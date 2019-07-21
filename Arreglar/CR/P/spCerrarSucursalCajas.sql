SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spCerrarSucursalCajas
@Estacion	int,
@Empresa	char(5),
@Sucursal	int,
@Usuario	char(10),
@Fecha		datetime,
@Ok		int		OUTPUT,
@OkRef		varchar(255)	OUTPUT

AS BEGIN
DECLARE
@DineroID		int,
@DineroMov		char(20),
@DineroMovID	varchar(20),
@Cajero		char(10),
@Caja		char(10),
@CtaDestino		char(10),
@Moneda		char(10),
@TipoCambio		float
SELECT @DineroMov = CajaCorteCaja FROM EmpresaCfgMov WHERE Empresa = @Empresa
SELECT @CtaDestino = DefCtaDineroTrans FROM Usuario WHERE Usuario = @Usuario
SELECT @Moneda = m.Moneda, @TipoCambio = m.TipoCambio
FROM EmpresaCfg cfg, Mon m
WHERE cfg.Empresa = @Empresa AND m.Moneda = cfg.ContMoneda
DECLARE crCtaDinero CURSOR FOR
SELECT c.CtaDinero
FROM DineroSaldo s, CtaDinero c
WHERE s.CtaDinero = c.CtaDinero AND c.Tipo = 'Caja' AND ISNULL(s.Saldo, 0) <> ISNULL(c.FondoFijo, 0)
AND c.CorteAutoCerrarDia = 1
OPEN crCtaDinero
FETCH NEXT FROM crCtaDinero INTO @Caja
WHILE @@FETCH_STATUS <> -1 AND @Ok IS NULL
BEGIN
IF @@FETCH_STATUS <> -2
BEGIN
SELECT @Cajero = NULLIF(RTRIM(Cajero), '')
FROM CtaDineroCajero
WHERE Moneda = '' AND CtaDinero = @Caja
INSERT Dinero (Empresa,  Sucursal,  Usuario,  Mov,        FechaEmision, CtaDinero, CtaDineroDestino, Moneda,  TipoCambio,  Cajero,  Estatus)
VALUES (@Empresa, @Sucursal, @Usuario, @DineroMov, @Fecha,       @Caja,     @CtaDestino,      @Moneda, @TipoCambio, @Cajero, 'SINAFECTAR')
SELECT @DineroID = SCOPE_IDENTITY()
EXEC spDineroSugerirCorte @Sucursal, @DineroID, @Empresa, @Caja, @Moneda
IF EXISTS(SELECT * FROM DineroD WHERE ID = @DineroID)
EXEC spAfectar 'DIN', @DineroID, @Usuario = @Usuario, @EnSilencio = 1, @Ok = @Ok OUTPUT, @OkRef = @OkRef OUTPUT
ELSE
DELETE Dinero WHERE ID = @DineroID
END
FETCH NEXT FROM crCtaDinero INTO @Caja
END 
CLOSE crCtaDinero
DEALLOCATE crCtaDinero
RETURN
END

