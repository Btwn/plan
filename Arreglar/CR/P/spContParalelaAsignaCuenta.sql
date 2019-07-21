SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROC spContParalelaAsignaCuenta
@ID				int,
@CuentaD		varchar(20),
@CuentaA		varchar(20),
@CuentaAsignada	varchar(40),
@Ok				int			 = NULL OUTPUT,
@OkRef			varchar(255) = NULL OUTPUT

AS BEGIN
DECLARE @Cuenta		varchar(20),
@Rama			varchar(20),
@Tipo			varchar(15),
@NoRamas		int
SELECT @NoRamas = COUNT(DISTINCT Rama)
FROM ContParalelaCta
WHERE Cuenta >= @CuentaD
AND Cuenta <= @CuentaA
AND Estatus = 'ALTA'
AND ID = @ID
IF @Ok IS NULL AND NOT EXISTS(SELECT * FROM ContParalelaCta WHERE ID = @ID AND Cuenta = @CuentaD)
SELECT @Ok = 1, @OkRef = 'Cuenta Incorrecta. '  + ISNULL(@CuentaD, '')
IF @Ok IS NULL AND NOT EXISTS(SELECT * FROM ContParalelaCta WHERE ID = @ID AND Cuenta = @CuentaA)
SELECT @Ok = 1, @OkRef = 'Cuenta Incorrecta. '  + ISNULL(@CuentaA, '')
IF @Ok IS NULL AND @NoRamas > 1
SELECT @Ok = 1, @OkRef = 'Las cuentas deben pertenecer a la misma Rama.'
IF @Ok IS NULL AND @NoRamas <= 1
BEGIN
UPDATE ContParalelaCta
SET CuentaAsignada = @CuentaAsignada
WHERE Cuenta >= @CuentaD
AND Cuenta <= @CuentaA
AND Estatus = 'ALTA'
AND ID = @ID
SELECT @Ok = 8080, @OkRef = 'Proceso concluído con éxito'
END
SELECT @OkRef
END

