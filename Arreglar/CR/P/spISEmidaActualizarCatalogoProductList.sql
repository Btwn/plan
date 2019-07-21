SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROC spISEmidaActualizarCatalogoProductList
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
CREATE TABLE #EmidaProductCfg(
Empresa				varchar(5)	COLLATE DATABASE_DEFAULT NULL,
URL					varchar(255)COLLATE DATABASE_DEFAULT NULL,
ProductId			varchar(255)COLLATE DATABASE_DEFAULT NULL,
Description			varchar(255)COLLATE DATABASE_DEFAULT NULL,
ShortDescription	varchar(255)COLLATE DATABASE_DEFAULT NULL,
Amount				varchar(10)	COLLATE DATABASE_DEFAULT NULL,
CarrierId			varchar(255)COLLATE DATABASE_DEFAULT NULL,
CategoryId			varchar(255)COLLATE DATABASE_DEFAULT NULL,
TransTypeId			varchar(255)COLLATE DATABASE_DEFAULT NULL,
DiscountRate		varchar(10)	COLLATE DATABASE_DEFAULT NULL,
CurrencyCode		varchar(10)	COLLATE DATABASE_DEFAULT NULL,
CurrencySymbol		varchar(10)	COLLATE DATABASE_DEFAULT NULL,
Existe				bit			NOT NULL DEFAULT 0
)
EXEC spWSEmidaGetProductList @URL, @Version, @SiteID, '', '', '', '', @Respuesta OUTPUT, @Ok OUTPUT, @OkRef OUTPUT
IF @Ok IS NULL
BEGIN
SELECT @RespuestaXML = CONVERT(xml, @Respuesta)
EXEC sp_xml_preparedocument @iResultado OUTPUT, @RespuestaXML
SELECT @ResponseCode = ISNULL(ResponseCode, ''), @ResponseMessage = ISNULL(ResponseMessage, '')
FROM OPENXML(@iResultado, '/GetProductListResponse', 2)
WITH (ResponseCode varchar(2), ResponseMessage varchar(250))
IF @ResponseCode NOT IN('00', '')
SELECT @Ok = 5, @OkRef = RTRIM(@ResponseCode) + ' ' + RTRIM(@ResponseMessage)
INSERT INTO #EmidaProductCfg(
Empresa,  URL,  ProductId, Description, ShortDescription, Amount, CarrierId, CategoryId, TransTypeId, DiscountRate, CurrencyCode, CurrencySymbol)
SELECT @Empresa, @URL, ProductId, Description, ShortDescription, Amount, CarrierId, CategoryId, TransTypeId, DiscountRate, CurrencyCode, CurrencySymbol
FROM OPENXML(@iResultado, '/GetProductListResponse/Product', 2) WITH EmidaProductCfg
EXEC sp_xml_removedocument @iResultado
IF @Ok IS NULL
BEGIN
UPDATE a
SET a.Existe = 1
FROM #EmidaProductCfg a
JOIN EmidaProductCfg b ON a.URL = b.URL AND a.CarrierId = b.CarrierId AND a.Empresa = b.Empresa AND a.ProductId = b.ProductId
INSERT INTO EmidaProductCfg(
Empresa, URL, ProductId, Description, ShortDescription, Amount, CarrierId, CategoryId, TransTypeId, DiscountRate, CurrencyCode, CurrencySymbol)
SELECT Empresa, URL, ProductId, Description, ShortDescription, Amount, CarrierId, CategoryId, TransTypeId, DiscountRate, CurrencyCode, CurrencySymbol
FROM #EmidaProductCfg
WHERE ISNULL(Existe, 0) = 0
INSERT INTO EmidaActualizarCatalogos(
Empresa,  Estacion, Catalogo,    Clave,	 Descripcion, URL)
SELECT @Empresa, @Estacion, 'Productos', ProductId, Description, URL
FROM #EmidaProductCfg
WHERE ISNULL(Existe, 0) = 0
END
END
SELECT @Resultado = '<Intelisis Sistema="Intelisis" Contenido="Solicitud" Referencia="Emida.ActualizarCatalogo" SubReferencia="ProductList" Version="' + ISNULL(@Version, '') + '" Ok="' + ISNULL(CONVERT(varchar, @Ok), '') + '" OkRef="' + ISNULL(CONVERT(varchar, @OkRef), '') + '" >' +
'  <Resultado>' + ISNULL(@Respuesta, '') +
'  </Resultado>' +
'</Intelisis>'
RETURN
END

