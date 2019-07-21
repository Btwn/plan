SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROC spISEmidaSubmitPayment
@ID					int,
@iSolicitud			int,
@SubReferencia		varchar(100),
@Resultado			varchar(max)	OUTPUT,
@Ok					int				OUTPUT,
@OkRef				varchar(255)	OUTPUT,
@CambiarEstatus		bit = 1			OUTPUT

AS
BEGIN
DECLARE @Estacion				int,
@Empresa				varchar(5),
@URL					varchar(255),
@terminalId			varchar(20),
@Version				varchar(2),
@clerkId				varchar(20),
@bankCode				varchar(20),
@amount				float,
@documentNumber		varchar(25),
@documentDate			varchar(10),
@Respuesta			varchar(max),
@RespuestaXML			xml,
@iResultado			int,
@Sucursal				int,
@ResponseCode			varchar(2),
@ResponseMessage		varchar(250),
@TimeOut				int
SELECT @Estacion = Estacion, @Empresa = Empresa, @URL = URL, @terminalId = terminalId, @Version = Version, @clerkId = clerkId, @bankCode = bankCode,
@amount = amount, @documentDate = documentDate, @documentNumber = documentNumber
FROM OPENXML (@iSolicitud, '/Intelisis/Solicitud/Emida',1)
WITH (Estacion int, Empresa varchar(5), URL varchar(255), terminalId varchar(20), Version varchar(2), clerkId varchar(20),
amount varchar(10), bankCode varchar(20), documentNumber varchar(25), documentDate varchar(10))
EXEC spWSEmidaSubmitPaymentNotification @URL, @version, @terminalId, @amount, @clerkId, @documentNumber, @documentDate, @bankCode, @Respuesta OUTPUT, @Ok OUTPUT, @OkRef OUTPUT
IF @Ok IS NULL
BEGIN
SELECT @RespuestaXML = CONVERT(xml, @Respuesta)
EXEC sp_xml_preparedocument @iResultado OUTPUT, @RespuestaXML
SELECT @ResponseCode = RTRIM(ISNULL(ResponseCode, '')), @ResponseMessage = RTRIM(ISNULL(ResponseMessage, ''))
FROM OPENXML(@iResultado, '/SubmitPaymentNotificationResponse', 2)
WITH (ResponseCode varchar(2), ResponseMessage varchar(250))
IF @ResponseCode = '00'
SELECT @Ok = NULL, @OkRef = NULL
ELSE
SELECT @Ok = 5, @OkRef = @ResponseCode + ' ' + @ResponseMessage
EXEC sp_xml_removedocument @iResultado
END
SELECT @Resultado = '<Intelisis Sistema="Intelisis" Contenido="Solicitud" Referencia="Emida.SubmitPayment" Version="' + ISNULL(@Version, '') + '" Ok="' + ISNULL(CONVERT(varchar, @Ok), '') + '" OkRef="' + ISNULL(CONVERT(varchar, @OkRef), '') + '" >' +
'  <Resultado>' + ISNULL(CONVERT(varchar(max), @Respuesta), '') +
'  </Resultado>' +
'</Intelisis>'
RETURN
END

