SET DATEFIRST 7    
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1  
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROC spEmidaSubmitPayment
@Empresa		varchar(5),
@Estacion		int,
@Usuario		varchar(10),
@Sucursal		int,
@Ok				int			 = NULL OUTPUT,
@OkRef			varchar(255) = NULL OUTPUT

AS
BEGIN
DECLARE @Version				varchar(2),
@terminalId			varchar(20),
@clerkId				varchar(20),
@URL					varchar(255),
@bankCode				varchar(20),
@iResultado			int,
@Solicitud			varchar(max),
@Fecha				datetime,
@Contrasena			varchar(32),
@amount				float,
@documentNumber		varchar(25),
@documentDate			datetime,
@documentDateTexto	varchar(10),
@OkDesc				varchar(255),
@OkTipo				varchar(50)
SELECT @Version = Version FROM EmidaCfg WITH (NOLOCK) WHERE Empresa = @Empresa
SELECT @Fecha = GETDATE()
SELECT @Contrasena = Contrasena FROM Usuario WITH (NOLOCK) WHERE Usuario = @Usuario
SELECT @URL = EmidaCarrierCfg.URL
FROM EmidaSubmitPayment WITH (NOLOCK)
JOIN EmidaCarrierCfg WITH (NOLOCK) ON EmidaSubmitPayment.CarrierId = EmidaCarrierCfg.CarrierId AND EmidaCarrierCfg.Empresa = @Empresa
WHERE EmidaSubmitPayment.Estacion = @Estacion
SELECT @terminalId = dbo.fnEmidaSiteID(@Empresa, @URL, @Sucursal, @Usuario)
SELECT @ClerkID = Agente.ClerkID
FROM Agente WITH (NOLOCK)
JOIN Usuario WITH (NOLOCK) ON Agente.Agente = Usuario.DefAgente
WHERE Usuario = @Usuario
SELECT @bankCode = EmidaBankCode
FROM InstitucionFin WITH (NOLOCK)
JOIN EmidaSubmitPayment WITH (NOLOCK) ON InstitucionFin.Institucion = EmidaSubmitPayment.Institucion
WHERE EmidaSubmitPayment.Estacion = @Estacion
SELECT @amount		 = amount,
@documentNumber = documentNumber,
@documentDate	 = documentDate
FROM EmidaSubmitPayment WITH (NOLOCK)
WHERE Estacion = @Estacion
IF DATEPART(mm, @documentDate) < 10
SELECT @documentDateTexto = '0' + CONVERT(varchar, DATEPART(mm, @documentDate)) + '/'
ELSE
SELECT @documentDateTexto = CONVERT(varchar, DATEPART(mm, @documentDate)) + '/'
IF DATEPART(dd, @documentDate) < 10
SELECT @documentDateTexto = @documentDateTexto + '0' + CONVERT(varchar, DATEPART(dd, @documentDate)) + '/'
ELSE
SELECT @documentDateTexto = @documentDateTexto + CONVERT(varchar, DATEPART(dd, @documentDate)) + '/'
SELECT @documentDateTexto = @documentDateTexto + CONVERT(varchar, DATEPART(yy, @documentDate))
SELECT @Solicitud = '<Intelisis Sistema="Intelisis" Contenido="Solicitud" Referencia="Emida.SubmitPayment" SubReferencia="" Version="' + ISNULL(@Version, '') + '">' +
'  <Solicitud>' +
'    <Emida Estacion="' + CONVERT(varchar, ISNULL(@Estacion, 0)) + '" Empresa="' + ISNULL(dbo.fneDocXmlAUTF8(@Empresa, 0, 1), '') + '" URL="' + ISNULL(@URL, '') + '" terminalId="' + ISNULL(@terminalId, '') + '" Version="' + ISNULL(@Version, '') + '" clerkId="' + ISNULL(@clerkId, '') + '" bankCode="' + ISNULL(@bankCode, '') + '" amount="' + ISNULL(CONVERT(varchar, @amount), '') + '" documentNumber="' + ISNULL(@documentNumber, '') + '" documentDate="' + ISNULL(@documentDateTexto, '') + '" />' +
'  </Solicitud>' +
'</Intelisis>'
EXEC spIntelisisService @Usuario, @Contrasena, @Solicitud, @Procesar = 1, @EliminarProcesado = 0, @Ok = @Ok OUTPUT, @OkRef = @OkRef OUTPUT
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

