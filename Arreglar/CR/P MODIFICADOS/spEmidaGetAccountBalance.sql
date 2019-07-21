SET DATEFIRST 7    
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1  
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spEmidaGetAccountBalance
@Estacion		int,
@Empresa		varchar(5),
@Sucursal		int,
@Usuario		varchar(10),
@Ok				int			 = NULL OUTPUT,
@OkRef			varchar(255) = NULL OUTPUT

AS
BEGIN
DECLARE @URL			varchar(255),
@URLAnt		varchar(255),
@Version		varchar(2),
@SiteID		varchar(20),
@MerchantID	varchar(20),
@OkDesc		varchar(255),
@OkTipo		varchar(50),
@Solicitud	varchar(max),
@Contrasena	varchar(32),
@Fecha		datetime
SELECT @Fecha = GETDATE()
SELECT @Contrasena = Contrasena FROM Usuario WITH (NOLOCK) WHERE Usuario = @Usuario
SELECT @Version = Version FROM EmidaCfg WITH (NOLOCK) WHERE Empresa = @Empresa
SELECT @URLAnt = ''
WHILE(1=1)
BEGIN
SELECT @URL = MIN(URL)
FROM EmidaURLCfg WITH (NOLOCK)
WHERE Empresa = @Empresa
AND URL > @URLAnt
IF @URL IS NULL BREAK
SELECT @URLAnt = @URL
SELECT @MerchantID = MerchantID FROM EmidaMerchantIDCfg WITH (NOLOCK) WHERE Empresa = @Empresa AND URL = @URL AND Sucursal = @Sucursal
SELECT @SiteID = dbo.fnEmidaSiteID(@Empresa, @URL, @Sucursal, @Usuario)
SELECT @Solicitud = '<Intelisis Sistema="Intelisis" Contenido="Solicitud" Referencia="Emida.AccountBalance" SubReferencia="" Version="' + ISNULL(@Version, '') + '">' +
'  <Solicitud>' +
'    <Emida Estacion="' + CONVERT(varchar, ISNULL(@Estacion, 0)) + '" Empresa="' + ISNULL(dbo.fneDocXmlAUTF8(@Empresa, 0, 1), '') + '" URL="' + ISNULL(@URL, '') + '" SiteID="' + ISNULL(@SiteID, '') + '" Version="' + ISNULL(@Version, '') + '" Sucursal="' + CONVERT(varchar, ISNULL(@Sucursal, 0)) +'" MerchantID="' + ISNULL(@MerchantId, '') + '" />' +
'  </Solicitud>' +
'</Intelisis>'
EXEC spIntelisisService @Usuario, @Contrasena, @Solicitud, @Procesar = 1, @EliminarProcesado = 0, @Ok = @Ok OUTPUT, @OkRef = @OkRef OUTPUT
END
IF @Ok IS NULL
SELECT @OkRef = NULL
ELSE
SELECT @OkDesc = Descripcion,
@OkTipo = Tipo
FROM MensajeLista WITH (NOLOCK)
WHERE Mensaje = @Ok
SELECT @Ok, @OkDesc, @OkTipo, @OkRef, NULL
RETURN
END

