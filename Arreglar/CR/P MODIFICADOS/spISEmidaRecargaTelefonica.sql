SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROC spISEmidaRecargaTelefonica
@ID					int,
@iSolicitud			int,
@SubReferencia		varchar(100),
@Resultado			varchar(max)	OUTPUT,
@Ok					int				OUTPUT,
@OkRef				varchar(255)	OUTPUT,
@CambiarEstatus		bit = 1			OUTPUT,
@Empresa			varchar(5)		OUTPUT 

AS
BEGIN
DECLARE @Estacion				int,
@URL					varchar(255),
@terminalId			varchar(20),
@Version				varchar(2),
@TimeOut				int,
@Reintentos			int,
@clerkId				varchar(20),
@CarrierId			varchar(255),
@ProductId			varchar(255),
@Description			varchar(255),
@ShortDescription		varchar(255),
@RecargaTelefono			varchar(10), 
@RecargaConfirmarTelefono	varchar(10), 
@amount				varchar(10),
@invoiceNo			varchar(20),
@languageOption		varchar(2),
@Respuesta			varchar(max),
@RespuestaXML			xml,
@iResultado			int,
@Sucursal				int,
@ResponseCode			varchar(2),
@ResponseMessage		varchar(250),
@Usuario				varchar(10),
@Contrasena			varchar(32)
SELECT @Estacion = Estacion, @Empresa = Empresa, @URL = URL, @terminalId = terminalId, @Version = Version, @clerkId = clerkId, @ProductId = productId,
@RecargaTelefono = accountId, @amount = amount, @invoiceNo = invoiceNo, @languageOption = languageOption, @Usuario = Usuario, @Contrasena = Contrasena 
FROM OPENXML (@iSolicitud, '/Intelisis/Solicitud/Emida',1)
WITH (Estacion int, Empresa varchar(5), URL varchar(255), terminalId varchar(20), Version varchar(2), clerkId varchar(20), productId varchar(255),
accountId varchar(10), amount varchar(10), invoiceNo varchar(20), languageOption varchar(2), Usuario varchar(10), Contrasena varchar(32))
SELECT @TimeOut = TimeOut, @Reintentos = Reintentos FROM EmidaCfg WITH (NOLOCK) WHERE Empresa = @Empresa
EXEC spWSEmidaPinDistSale @URL, @Version, @terminalId, @clerkId, @productId, @RecargaTelefono, @amount, @invoiceNo, @languageOption, @TimeOut, @Respuesta OUTPUT, @Ok OUTPUT, @OkRef OUTPUT 
IF @Ok IS NULL
BEGIN
SELECT @RespuestaXML = CONVERT(xml, @Respuesta)
EXEC sp_xml_preparedocument @iResultado OUTPUT, @RespuestaXML
SELECT @ResponseCode = RTRIM(ISNULL(ResponseCode, '')), @ResponseMessage = RTRIM(ISNULL(ResponseMessage, ''))
FROM OPENXML(@iResultado, '/PinDistSaleResponse', 2)
WITH (ResponseCode varchar(2), ResponseMessage varchar(250))
IF @ResponseCode <> '00'
SELECT @Ok = 5, @OkRef = @ResponseCode + ' ' + @ResponseMessage
ELSE
SELECT @Ok = NULL, @OkRef = NULL
EXEC sp_xml_removedocument @iResultado
END
ELSE IF @Ok IS NOT NULL
BEGIN
EXEC spEmidaLookUpTransactionByInvocieNo @Estacion, @Empresa, @Sucursal, @Usuario, @Contrasena, @URL, @version, @terminalId, @clerkId, @invoiceNo, @Reintentos, @Respuesta OUTPUT, @Ok OUTPUT,@OkRef OUTPUT
END
SELECT @Resultado = '<Intelisis Sistema="Intelisis" Contenido="Solicitud" Referencia="Emida.RecargaTelefonica" Version="' + ISNULL(@Version, '') + '" Ok="' + ISNULL(CONVERT(varchar, @Ok), '') + '" OkRef="' + ISNULL(CONVERT(varchar, @OkRef), '') + '" >' +
'  <Resultado>' + ISNULL(CONVERT(varchar(max), @Respuesta), '') +
'  </Resultado>' +
'</Intelisis>'
RETURN
END

