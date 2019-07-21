SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROC spISEmidaActualizarCatalogoCarrierList
@ID					int,
@iSolicitud			int,
@Estacion			int,
@Empresa			varchar(5),
@URL				varchar(255),
@SiteID				varchar(20),
@Version			varchar(2),
@Resultado			varchar(max)	OUTPUT,
@Ok					int				OUTPUT,
@OkRef				varchar(255)	OUTPUT

AS
BEGIN
DECLARE @Respuesta		varchar(max),
@RespuestaXML		xml,
@iResultado		int,
@ResponseCode		varchar(2),
@ResponseMessage	varchar(250)
CREATE TABLE #EmidaCarrierCfg(
Empresa			varchar(5)		COLLATE DATABASE_DEFAULT NULL,
URL				varchar(255)	COLLATE DATABASE_DEFAULT NULL,
CarrierId		varchar(255)	COLLATE DATABASE_DEFAULT NULL,
Description		varchar(255)	COLLATE DATABASE_DEFAULT NULL,
ProductCount	varchar(10)		COLLATE DATABASE_DEFAULT NULL,
Existe			bit				NOT NULL DEFAULT 0
)
EXEC spWSEmidaGetCarrierList @URL, @Version, @SiteID, '', '', '', '', @Respuesta OUTPUT, @Ok OUTPUT, @OkRef OUTPUT
SELECT @RespuestaXML = CONVERT(xml, @Respuesta)
IF @Ok IS NULL
BEGIN
EXEC sp_xml_preparedocument @iResultado OUTPUT, @RespuestaXML
SELECT @ResponseCode = ISNULL(ResponseCode, ''), @ResponseMessage = ISNULL(ResponseMessage, '')
FROM OPENXML(@iResultado, '/GetCarrierListResponse', 2)
WITH (ResponseCode varchar(2), ResponseMessage varchar(250))
IF @ResponseCode NOT IN('00', '')
SELECT @Ok = 5, @OkRef = RTRIM(@ResponseCode) + ' ' + RTRIM(@ResponseMessage)
INSERT INTO #EmidaCarrierCfg(
Empresa,  URL,  CarrierId, Description, ProductCount)
SELECT @Empresa, @URL, CarrierId, Description, ProductCount
FROM OPENXML(@iResultado, '/GetCarrierListResponse/Carrier', 2) WITH EmidaCarrierCfg
EXEC sp_xml_removedocument @iResultado
IF @Ok IS NULL
BEGIN
UPDATE a
SET a.Existe = 1
FROM #EmidaCarrierCfg a
JOIN EmidaCarrierCfg b ON a.URL = b.URL AND a.CarrierId = b.CarrierId AND a.Empresa = b.Empresa
INSERT INTO EmidaCarrierCfg(
Empresa, URL, CarrierId, Description, ProductCount)
SELECT Empresa, URL, CarrierId, Description, ProductCount
FROM #EmidaCarrierCfg
WHERE ISNULL(Existe, 0) = 0
INSERT INTO EmidaActualizarCatalogos(
Empresa,  Estacion, Catalogo,      Clave,	   Descripcion, URL)
SELECT @Empresa, @Estacion, 'Proveedores', CarrierId, Description, URL
FROM #EmidaCarrierCfg
WHERE ISNULL(Existe, 0) = 0
END
END
SELECT @Resultado = '<Intelisis Sistema="Intelisis" Contenido="Solicitud" Referencia="Emida.ActualizarCatalogo" SubReferencia="CarrierList" Version="' + ISNULL(@Version, '') + '" Ok="' + ISNULL(CONVERT(varchar, @Ok), '') + '" OkRef="' + ISNULL(CONVERT(varchar, @OkRef), '') + '" >' +
'  <Resultado>' + ISNULL(CONVERT(varchar(max), @RespuestaXML), '') +
'  </Resultado>' +
'</Intelisis>'
RETURN
END

