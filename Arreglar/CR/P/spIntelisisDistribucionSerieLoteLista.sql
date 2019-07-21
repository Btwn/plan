SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spIntelisisDistribucionSerieLoteLista
@ID                        int,
@iSolicitud                int,
@Version                   float,
@Resultado                 varchar(max) = NULL OUTPUT,
@Ok                        int = NULL OUTPUT,
@OkRef                     varchar(255) = NULL OUTPUT

AS BEGIN
DECLARE
@ReferenciaIS              varchar(100),
@SubReferencia             varchar(100),
@Texto                     xml,
@Empresa                   varchar(5),
@Almacen                   varchar(10),
@Articulo                  varchar(20),
@SubCuenta                 varchar(50)
DECLARE @Tabla Table(
IDR                        int identity(1,1),
SerieLote                  varchar(10),
Existencia                 float
)
BEGIN TRY
SELECT @Empresa = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Empresa'
SELECT @Almacen = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Almacen'
SELECT @Articulo = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Articulo'
SELECT @SubCuenta = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'SubCuenta'
SET @Empresa   = LTRIM(RTRIM(ISNULL(@Empresa,'')))
SET @Almacen   = LTRIM(RTRIM(ISNULL(@Almacen,'')))
SET @Articulo  = LTRIM(RTRIM(ISNULL(@Articulo,'')))
SET @SubCuenta = LTRIM(RTRIM(ISNULL(@SubCuenta,'')))
INSERT INTO @Tabla(SerieLote, Existencia)
SELECT SerieLote, Existencia
FROM SerieLote
WHERE Empresa = @Empresa
AND Almacen = @Almacen
AND Articulo = @Articulo
AND SubCuenta = @SubCuenta
AND Existencia > 0
ORDER BY Existencia DESC, SerieLote
SELECT @Texto = (SELECT LTRIM(RTRIM(ISNULL(SerieLote,'')))    AS SerieLote,
CAST(ISNULL(Existencia,0) AS varchar) AS Existencia
FROM @Tabla AS Tabla
ORDER BY IDR
FOR XML AUTO)
END TRY
BEGIN CATCH
SET @Ok = 1
SELECT @OkRef = LTRIM(RTRIM(LEFT(ERROR_MESSAGE(),255)))
END CATCH
SELECT @ReferenciaIS = Referencia FROM IntelisisService WHERE ID = @ID
SET @Resultado = '<?xml version="1.0" encoding="windows-1252"?><Intelisis Sistema="Intelisis" Contenido="Resultado" Referencia=' + CHAR(34) + ISNULL(@ReferenciaIS,'') + CHAR(34) + ' SubReferencia=' + CHAR(34) + ISNULL(@SubReferencia,'') + CHAR(34) + ' Version=' + CHAR(34) + ISNULL(CONVERT(varchar ,@Version),'') + CHAR(34) + '><Resultado IntelisisServiceID=' + CHAR(34) + ISNULL(CONVERT(varchar,@ID),'')  + CHAR(34)  + ' Ok=' + CHAR(34) + ISNULL(CONVERT(varchar,@Ok),'') + CHAR(34) + ' OkRef=' + CHAR(34) + ISNULL(@OkRef,'') + CHAR(34) + '>' + ISNULL(CONVERT(varchar(max),@Texto),'') + '</Resultado></Intelisis>'
SET @Resultado = REPLACE(@Resultado,'<BR>','.')
END

