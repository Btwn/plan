SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spIntelisisDistribucionInfoSerieLote
@ID                        int,
@iSolicitud                int,
@Version                   float,
@Resultado                 varchar(max) = NULL OUTPUT,
@Ok                        int = NULL OUTPUT,
@OkRef                     varchar(255) = NULL OUTPUT

AS BEGIN
DECLARE
@Empresa                   varchar(5),
@Modulo                    varchar(5),
@ModuloID                  varchar(255),
@RenglonID                 varchar(255),
@Articulo                  varchar(20),
@SubCuenta                 varchar(50),
@ModuloID2                 int,
@RenglonID2                int,
@ReferenciaIS              varchar(100),
@SubReferencia             varchar(100),
@Texto                     xml
BEGIN TRY
SELECT @Empresa = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Empresa'
SELECT @Modulo = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Modulo'
SELECT @ModuloID = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'ModuloID'
SELECT @RenglonID = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'RenglonID'
SELECT @Articulo = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Articulo'
SELECT @SubCuenta = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'SubCuenta'
SET @Empresa    = LTRIM(RTRIM(ISNULL(@Empresa,'')))
SET @Modulo     = LTRIM(RTRIM(ISNULL(@Modulo,'')))
SET @Articulo   = LTRIM(RTRIM(ISNULL(@Articulo,'')))
SET @SubCuenta  = LTRIM(RTRIM(ISNULL(@SubCuenta,'')))
SET @ModuloID2  = CAST(ISNULL(@ModuloID,'0') AS int)
SET @RenglonID2 = CAST(ISNULL(@RenglonID,'0') AS int)
IF @ModuloID2 > 0
BEGIN
DECLARE @Tabla Table(
RenglonID            int,
Articulo             varchar(20),
SubCuenta            varchar(50),
SerieLote            varchar(50),
Cantidad             float
)
INSERT INTO @Tabla(RenglonID, Articulo, SubCuenta, SerieLote, Cantidad)
SELECT ISNULL(RenglonID,0),
ISNULL(Articulo,''),
ISNULL(SubCuenta,''),
ISNULL(SerieLote,''),
ISNULL(Cantidad,0.0)
FROM SerieLoteMov
WITH(NOLOCK) WHERE Empresa = @Empresa
AND Modulo = @Modulo
AND ID = @ModuloID
AND RenglonID = @RenglonID2
AND Articulo  = @Articulo
AND SubCuenta = @SubCuenta
ORDER BY SerieLote
END
ELSE
BEGIN
SET @Ok = 10160
END
IF NOT ISNULL(@Ok, 0) = 0 SELECT @OkRef = Descripcion FROM MensajeLista WITH(NOLOCK) WHERE Mensaje = @Ok
END TRY
BEGIN CATCH
SET @Ok = 1
SELECT @OkRef = LTRIM(RTRIM(LEFT(ERROR_MESSAGE(),255)))
END CATCH
SELECT @ReferenciaIS = Referencia FROM IntelisisService WITH(NOLOCK) WHERE ID = @ID
SELECT @Texto = (SELECT CAST(ISNULL(RenglonID,0) AS VARCHAR) AS RenglonID,
LTRIM(RTRIM(ISNULL(Articulo,'')))    AS Articulo,
LTRIM(RTRIM(ISNULL(SubCuenta,'')))   AS SubCuenta,
LTRIM(RTRIM(ISNULL(SerieLote,'')))   AS SerieLote,
CAST(ISNULL(Cantidad,0) AS VARCHAR)  AS Cantidad
FROM @Tabla AS Tabla
FOR XML AUTO)
SET @Resultado = '<?xml version="1.0" encoding="windows-1252"?><Intelisis Sistema="Intelisis" Contenido="Resultado" Referencia=' + CHAR(34) + ISNULL(@ReferenciaIS,'') + CHAR(34) + ' SubReferencia=' + CHAR(34) + ISNULL(@SubReferencia,'') + CHAR(34) + ' Version=' + CHAR(34) + ISNULL(CONVERT(varchar ,@Version),'') + CHAR(34) + '><Resultado IntelisisServiceID=' + CHAR(34) + ISNULL(CONVERT(varchar,@ID),'')  + CHAR(34)  + ' Ok=' + CHAR(34) + ISNULL(CONVERT(varchar,@Ok),'') + CHAR(34) + ' OkRef=' + CHAR(34) + ISNULL(@OkRef,'') + CHAR(34) + '>' + ISNULL(CONVERT(varchar(max),@Texto),'') + '</Resultado></Intelisis>'
SET @Resultado = REPLACE(@Resultado,'<BR>','.')
END

