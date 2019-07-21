SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROC spISEmidaAccountBalance
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
@SiteID				varchar(20),
@Version				varchar(2),
@MerchantID			varchar(20),
@Respuesta			varchar(max),
@RespuestaXML			xml,
@iResultado			int,
@Sucursal				int,
@ResponseCode			varchar(2),
@ResponseMessage		varchar(250)
SELECT @Estacion = Estacion, @Empresa = Empresa, @URL = URL, @SiteID = SiteID, @Version = Version, @MerchantID = MerchantID, @Sucursal = Sucursal
FROM OPENXML (@iSolicitud, '/Intelisis/Solicitud/Emida',1)
WITH (Estacion int, Empresa varchar(5), URL varchar(255), SiteID varchar(20), Version varchar(2), MerchantID varchar(20), Sucursal int)
EXEC spWSEmidaGetAccountBalance @URL, @Version, @SiteID, @MerchantID, @Respuesta OUTPUT, @Ok OUTPUT, @OkRef OUTPUT
IF @Ok IS NULL
BEGIN
SELECT @RespuestaXML = CONVERT(xml, @Respuesta)
EXEC sp_xml_preparedocument @iResultado OUTPUT, @RespuestaXML
SELECT @ResponseCode = ISNULL(ResponseCode, ''), @ResponseMessage = ISNULL(ResponseMessage, '')
FROM OPENXML(@iResultado, '/GetAccountBalanceResponse', 2)
WITH (ResponseCode varchar(2), ResponseMessage varchar(250))
IF @ResponseCode <> '00'
SELECT @Ok = 5, @OkRef = RTRIM(@ResponseCode) + ' ' + RTRIM(@ResponseMessage)
IF @Ok IS NULL
BEGIN
DELETE EmidaAccountBalance WHERE Empresa = @Empresa AND URL = @URL AND Sucursal = @Sucursal
INSERT INTO EmidaAccountBalance(
Empresa,  URL,  availableBalance, legalBusinessname, dba, Sucursal)
SELECT @Empresa, @URL, availableBalance, legalBusinessname, dba, @Sucursal
FROM OPENXML(@iResultado, '/GetAccountBalanceResponse', 2) WITH EmidaAccountBalance
END
EXEC sp_xml_removedocument @iResultado
END
SELECT @Resultado = '<Intelisis Sistema="Intelisis" Contenido="Solicitud" Referencia="Emida.AccountBalance" Version="' + ISNULL(@Version, '') + '" Ok="' + ISNULL(CONVERT(varchar, @Ok), '') + '" OkRef="' + ISNULL(CONVERT(varchar, @OkRef), '') + '" >' +
'  <Resultado>' + ISNULL(@Respuesta, '') +
'  </Resultado>' +
'</Intelisis>'
END

