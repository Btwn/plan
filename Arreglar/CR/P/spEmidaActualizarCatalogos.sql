SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spEmidaActualizarCatalogos
@Estacion		int,
@Empresa		varchar(5),
@Usuario		varchar(10),
@Sucursal		int,
@Ok				int			 = NULL OUTPUT,
@OkRef			varchar(255) = NULL OUTPUT

AS
BEGIN
DECLARE @Solicitud	varchar(max),
@URL			varchar(255),
@URLAnt		varchar(255),
@Version		varchar(2),
@SiteID		varchar(20),
@OkDesc		varchar(255),
@OkTipo		varchar(50)
DELETE EmidaActualizarCatalogos WHERE Estacion = @Estacion
SELECT @Version = Version FROM EmidaCfg WHERE Empresa = @Empresa
SELECT @URLAnt = ''
WHILE(1=1)
BEGIN
SELECT @URL = MIN(URL)
FROM EmidaURLCfg
WHERE Empresa = @Empresa
AND URL > @URLAnt
IF @URL IS NULL BREAK
SELECT @URLAnt = @URL
SELECT @SiteID = dbo.fnEmidaSiteID(@Empresa, @URL, @Sucursal, @Usuario)
IF @Ok IS NULL
EXEC spEmidaGetCarrier @Estacion, @Empresa, @Usuario, @URL, @Version, @SiteID, @Ok = @Ok OUTPUT, @OkRef = @OkRef OUTPUT
IF @Ok IS NULL
EXEC spEmidaGetProduct @Estacion, @Empresa, @Usuario, @URL, @Version, @SiteID, @Ok = @Ok OUTPUT, @OkRef = @OkRef OUTPUT
END
IF @Ok IS NULL
SELECT @OkRef = NULL
ELSE
SELECT @OkDesc = Descripcion,
@OkTipo = Tipo
FROM MensajeLista
WHERE Mensaje = @Ok
SELECT @Ok, @OkDesc, @OkTipo, @OkRef, NULL
END

