SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spIntelisisWMSInfoSerieLoteSurtidoConsolidado
@ID                      int,
@iSolicitud              int,
@Version                 float,
@Resultado               varchar(max) = NULL OUTPUT,
@Ok                      int = NULL OUTPUT,
@OkRef                   varchar(255) = NULL OUTPUT

AS BEGIN
DECLARE
@Empresa                 varchar(5),
@ReferenciaIS            varchar(100),
@SubReferencia           varchar(100),
@Texto                   xml,
@Almacen                 varchar(10),
@Tarima                  varchar(20),
@Articulo                varchar(20),
@SubCuenta               varchar(50),
@ArtCambioClave          varchar(20),
@Cantidad                float,
@Cantidad2               varchar(100)
DECLARE @Tabla table(
Articulo                 varchar(20),
SubCuenta                varchar(50),
ArtCambioClave           varchar(20),
Descripcion1             varchar(100),
SerieLote                varchar(50),
Cantidad                 float
)
BEGIN TRY
SELECT @Empresa = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Empresa'
SELECT @Almacen = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Almacen'
SELECT @Tarima = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Tarima'
SELECT @Articulo = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Articulo'
SELECT @Subcuenta = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Subcuenta'
SELECT @ArtCambioClave = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'ArtCambioClave'
SELECT @Cantidad2 = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Cantidad'
SET @Empresa        = LTRIM(RTRIM(ISNULL(@Empresa,'')))
SET @Almacen        = LTRIM(RTRIM(ISNULL(@Almacen,'')))
SET @Tarima         = LTRIM(RTRIM(ISNULL(@Tarima,'')))
SET @Articulo       = LTRIM(RTRIM(ISNULL(@Articulo,'')))
SET @SubCuenta      = LTRIM(RTRIM(ISNULL(@SubCuenta,'')))
SET @ArtCambioClave = LTRIM(RTRIM(ISNULL(@ArtCambioClave,'')))
SET @Cantidad2      = LTRIM(RTRIM(ISNULL(@Cantidad2,'0')))
IF ISNUMERIC(@Cantidad2) = 1
SET @Cantidad = CAST(@Cantidad2 AS float)
ELSE
SET @Cantidad = 0
INSERT INTO @Tabla (Articulo, SubCuenta, ArtCambioClave, SerieLote, Cantidad)
SELECT @Articulo, @Subcuenta, @ArtCambioClave, SerieLote, @Cantidad
FROM TarimaSerieLote
WITH(NOLOCK) WHERE Tarima = @Tarima
UPDATE @Tabla
SET Descripcion1 = b.Descripcion1
FROM @Tabla a
JOIN Art b  WITH(NOLOCK) ON (a.Articulo = b.Articulo)
SELECT @Texto = (
SELECT LTRIM(RTRIM(ISNULL(Articulo,'')))       AS Articulo,
LTRIM(RTRIM(ISNULL(SubCuenta,'')))      AS SubCuenta,
LTRIM(RTRIM(ISNULL(ArtCambioClave,''))) AS ArtCambioClave,
LTRIM(RTRIM(ISNULL(Descripcion1,'')))   AS Descripcion1,
LTRIM(RTRIM(ISNULL(SerieLote,'')))      AS SerieLote,
CAST(ISNULL(Cantidad,0) AS VARCHAR)     AS Cantidad
FROM @Tabla AS TMA
FOR XML AUTO)
END TRY
BEGIN CATCH
SET @Ok = 1
SELECT @OkRef = LEFT(LTRIM(RTRIM(ERROR_MESSAGE())), 255)
END CATCH
SELECT @ReferenciaIS = Referencia FROM IntelisisService WITH(NOLOCK) WHERE ID = @ID
SET @Resultado = '<?xml version="1.0" encoding="windows-1252"?><Intelisis Sistema="Intelisis" Contenido="Resultado" Referencia=' + CHAR(34) + ISNULL(@ReferenciaIS,'') + CHAR(34) + ' SubReferencia=' + CHAR(34) + ISNULL(@SubReferencia,'') + CHAR(34) + ' Version=' + CHAR(34) + ISNULL(CONVERT(varchar ,@Version),'') + CHAR(34) + '><Resultado IntelisisServiceID=' + CHAR(34) + ISNULL(CONVERT(varchar,@ID),'')  + CHAR(34)  + ' Ok=' + CHAR(34) + ISNULL(CONVERT(varchar,@Ok),'') + CHAR(34) + ' OkRef=' + CHAR(34) + ISNULL(@OkRef,'') + CHAR(34) + '>' + ISNULL(CONVERT(varchar(max),@Texto),'') + '</Resultado></Intelisis>'
SET @Resultado = REPLACE(@Resultado,'<BR>','.')
END

