SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spIntelisisWMSInfoSerieLote
@ID                      int,
@iSolicitud              int,
@Version                 float,
@Resultado               varchar(max) = NULL OUTPUT,
@Ok                      int = NULL OUTPUT,
@OkRef                   varchar(255) = NULL OUTPUT

AS BEGIN
DECLARE
@Empresa                 varchar(5),
@Modulo                  varchar(5),
@ModuloID                varchar(255),
@RenglonID               varchar(255),
@Articulo                varchar(20),
@ModuloID2               int,
@RenglonID2              int,
@ReferenciaIS            varchar(100),
@SubReferencia           varchar(100),
@Texto                   xml
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
SET @Empresa    = LTRIM(RTRIM(ISNULL(@Empresa,'')))
SET @Modulo     = LTRIM(RTRIM(ISNULL(@Modulo,'')))
SET @Articulo   = LTRIM(RTRIM(ISNULL(@Articulo,'')))
SET @ModuloID2  = CAST(ISNULL(@ModuloID,'0') AS int)
SET @RenglonID2 = CAST(ISNULL(@RenglonID,'0') AS int)
IF @ModuloID2 > 0
BEGIN
DECLARE @Tabla Table(
RenglonID            int,
Articulo             varchar(20),
SerieLote            varchar(50),
Cantidad             float
)
INSERT INTO @Tabla(RenglonID,Articulo,SerieLote,Cantidad)
SELECT ISNULL(RenglonID,0),
ISNULL(Articulo,''),
ISNULL(SerieLote,''),
ISNULL(Cantidad,0.0)
FROM SerieLoteMov
WITH(NOLOCK) WHERE Empresa = @Empresa
AND Modulo = @Modulo
AND ID = @ModuloID
AND RenglonID = @RenglonID2
AND Articulo = @Articulo
ORDER BY SerieLote
SELECT @Texto = (SELECT CAST(RenglonID AS VARCHAR) AS RenglonID,
ISNULL(Articulo,'') AS Articulo,
ISNULL(SerieLote,'') AS SerieLote,
CAST(Cantidad AS VARCHAR) AS Cantidad
FROM @Tabla AS TMA
FOR XML AUTO)
END
ELSE
BEGIN
SET @Ok = 10160
END
SELECT @ReferenciaIS = Referencia
FROM IntelisisService
WITH(NOLOCK) WHERE ID = @ID
IF @Ok IS NOT NULL
SELECT @OkRef = Descripcion FROM MensajeLista WITH(NOLOCK) WHERE Mensaje = @Ok
SET @Resultado = '<?xml version="1.0" encoding="windows-1252"?><Intelisis Sistema="Intelisis" Contenido="Resultado" Referencia=' + CHAR(34) + ISNULL(@ReferenciaIS,'') + CHAR(34) + ' SubReferencia=' + CHAR(34) + ISNULL(@SubReferencia,'') + CHAR(34) + ' Version=' + CHAR(34) + ISNULL(CONVERT(varchar ,@Version),'') + CHAR(34) + '><Resultado IntelisisServiceID=' + CHAR(34) + ISNULL(CONVERT(varchar,@ID),'')  + CHAR(34)  + ' Ok=' + CHAR(34) + ISNULL(CONVERT(varchar,@Ok),'') + CHAR(34) + ' OkRef=' + CHAR(34) + ISNULL(@OkRef,'') + CHAR(34) + '>' + ISNULL(CONVERT(varchar(max),@Texto),'') + '</Resultado></Intelisis>'
SET @Resultado = REPLACE(@Resultado,'<BR>','.')
END

