SET DATEFIRST 7    
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1  
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spPOSLDIActivacionMonedero
@ID				varchar(36),
@Usuario	    varchar(10),
@Empresa        varchar(5),
@Sucursal       int,
@Cliente		varchar(10),
@NoTarjeta		varchar(20),
@Importe        float,
@Ok				int = NULL OUTPUT,
@OkRef			varchar(255) = NULL OUTPUT

AS
BEGIN
DECLARE
@Mensaje	varchar(255)
EXEC spPOSLDI 'MON ALTA NUEVO', @ID, @NoTarjeta, @Empresa, @Usuario, @Sucursal, NULL, NULL, 1, NULL, @Ok OUTPUT, @OkRef  OUTPUT, 'POS'
IF @OK IS NULL
EXEC spPOSActivacionMonederoLDI  @ID, @Usuario, @Empresa, @Sucursal, @Cliente, @NoTarjeta, @Ok OUTPUT, @OkRef  OUTPUT
IF @Ok IS NULL
SELECT @Mensaje = 'Monedero Registrado Exitosamente'
SELECT @Ok, @OkRef, @Mensaje
RETURN
END

