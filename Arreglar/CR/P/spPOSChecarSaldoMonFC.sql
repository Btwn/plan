SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spPOSChecarSaldoMonFC
@ID				varchar(36),
@NoTarjeta		varchar(36),
@Empresa        varchar(5),
@Usuario        varchar(10),
@Sucursal       int,
@Importe		float

AS
BEGIN
DECLARE
@Ok				int,
@OkRef			varchar(255),
@ImporteS		float
SELECT @Ok = NULL, @OkRef = NULL
EXEC spPOSLDIFacCred 'MON CONSULTA', @ID, @NoTarjeta, @Empresa, @Usuario, @Sucursal, @Ok = @Ok OUTPUT, @OkRef  = @OkRef OUTPUT, @ImporteS = @ImporteS OUTPUT
IF @Ok IS NULL
BEGIN
IF ISNULL(@ImporteS,0) < ISNULL(@Importe,0)
SELECT @OkRef = 'El Saldo del Monedero es Insificiente... Verifique su Saldo'
END
SELECT @OkRef
RETURN
END

