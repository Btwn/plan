SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spPOSMonederoAsociar
@Empresa		varchar(5),
@Monedero		varchar(20),
@Usuario		varchar(10),
@Estacion		int,
@Sucursal		int,
@ID				varchar(36)
AS BEGIN
DECLARE	@Ok			int,
@OkRef		varchar(255),
@Mensaje	varchar(255)
SET @Ok = NULL
SET @OkRef = NULL
SET @Mensaje = NULL
EXEC spPOSWSSolTarjetaMonedero @Empresa, @Monedero ,@Usuario, @Estacion, @Sucursal, @Ok OUTPUT, @OkRef OUTPUT
IF @Ok IS NULL
BEGIN
IF NOT EXISTS (SELECT * FROM POSTarjetaMonedero WITH (NOLOCK) WHERE Empresa = @Empresa AND Serie = @Monedero)
SELECT @Ok = 1, @OkRef = 'LA TARJETA NO EXISTE'
END
IF @Ok IS NULL
EXEC spPOSMonederoAsociar2  @ID, @Monedero, @Usuario, @Estacion
IF @Ok IS NOT NULL
SET @Mensaje = UPPER(NULLIF(@OkRef,''))
SELECT @Mensaje
END

