SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spEmidaGetProduct
@Estacion		int,
@Empresa		varchar(5),
@Usuario		varchar(10),
@URL			varchar(255),
@Version		varchar(2),
@SiteID			varchar(20),
@Ok				int			 = NULL OUTPUT,
@OkRef			varchar(255) = NULL OUTPUT

AS
BEGIN
DECLARE @Respuesta	varchar(max),
@iResultado	int,
@Solicitud	varchar(max),
@Fecha		datetime,
@Contrasena	varchar(32)
SELECT @Fecha = GETDATE()
SELECT @Contrasena = Contrasena FROM Usuario WHERE Usuario = @Usuario
SELECT @Solicitud = '<Intelisis Sistema="Intelisis" Contenido="Solicitud" Referencia="Emida.ActualizarCatalogo" SubReferencia="ProductList" Version="' + ISNULL(@Version, '') + '">' +
'  <Solicitud>' +
'    <Emida Estacion="' + CONVERT(varchar, ISNULL(@Estacion, 0)) + '" Empresa="' + ISNULL(dbo.fneDocXmlAUTF8(@Empresa, 0, 1), '') + '" URL="' + ISNULL(@URL, '') + '" SiteID="' + ISNULL(@SiteID, '') + '" Version="' + ISNULL(@Version, '') + '" />' +
'  </Solicitud>' +
'</Intelisis>'
EXEC spIntelisisService @Usuario, @Contrasena, @Solicitud, @Procesar = 1, @EliminarProcesado = 0, @Ok = @Ok OUTPUT, @OkRef = @OkRef OUTPUT
RETURN
END

