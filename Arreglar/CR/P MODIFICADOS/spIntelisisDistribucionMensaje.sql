SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spIntelisisDistribucionMensaje
@ID              int,
@iSolicitud      int,
@Version         float,
@Resultado       varchar(max) = NULL OUTPUT,
@Ok              int = NULL OUTPUT,
@OkRef           varchar(255) = NULL OUTPUT

AS BEGIN
DECLARE
@Texto         xml,
@ReferenciaIS  varchar(100),
@SubReferencia varchar(100),
@sMensaje      varchar(20),
@Mensaje       int
DECLARE @Tabla   table(
Mensaje        int,
Descripcion    varchar(255),
Tipo           varchar(50)
)
BEGIN TRY
SELECT @sMensaje = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Mensaje'
SET @sMensaje = ISNULL(@sMensaje,'0')
SET @Mensaje = CAST(@sMensaje AS int)
INSERT INTO @Tabla (Mensaje, Descripcion, Tipo)
SELECT @Mensaje, Descripcion, Tipo FROM MensajeLista WITH(NOLOCK) WHERE Mensaje = @Mensaje
SELECT @Texto = (SELECT CAST(ISNULL(Mensaje,0) AS varchar)   AS Ok,
LTRIM(RTRIM(ISNULL(Descripcion,''))) AS Descripcion,
LTRIM(RTRIM(ISNULL(Tipo,'')))        AS Tipo
FROM @Tabla AS Tabla
FOR XML AUTO)
IF NOT ISNULL(@Ok, 0) = 0 SELECT @OkRef = Descripcion FROM MensajeLista WITH(NOLOCK) WHERE Mensaje = @Ok
END TRY
BEGIN CATCH
SET @Ok = 1
SELECT @OkRef = LTRIM(RTRIM(LEFT(ERROR_MESSAGE(),255)))
END CATCH
SELECT @ReferenciaIS = Referencia, @SubReferencia = SubReferencia FROM IntelisisService WITH(NOLOCK) WHERE ID = @ID
SET @Resultado = '<?xml version="1.0" encoding="windows-1252"?><Intelisis Sistema="Intelisis" Contenido="Resultado" Referencia=' + CHAR(34) + ISNULL(@ReferenciaIS,'') + CHAR(34) + ' SubReferencia=' + CHAR(34) + ISNULL(@SubReferencia,'') + CHAR(34) + ' Version=' + CHAR(34) + ISNULL(CONVERT(varchar ,@Version),'') + CHAR(34) + '><Resultado IntelisisServiceID=' + CHAR(34) + ISNULL(CONVERT(varchar,@ID),'')  + CHAR(34)  + ' Ok=' + CHAR(34) + ISNULL(CONVERT(varchar,@Ok),'') + CHAR(34) + ' OkRef=' + CHAR(34) + ISNULL(@OkRef,'') + CHAR(34) + '>' + ISNULL(CONVERT(varchar(max),@Texto),'') + '</Resultado></Intelisis>'
SET @Resultado = REPLACE(@Resultado,'<BR>','.')
END

