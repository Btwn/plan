SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spIntelisisDistribucionMovimientosGenerar
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
@Origen                  varchar(50),
@ReferenciaIS            varchar(100),
@SubReferencia           varchar(100),
@xml                     xml,
@Texto                   xml
DECLARE
@sModuloID               varchar(100),
@ModuloID                int,
@MovimientoGenerar       varchar(20),
@IDGenerar               int,
@Estacion                int,
@Mensaje                 varchar(255)
SET @IDGenerar = 0
SET @Mensaje   = ''
SET @Estacion  = @@SPID
DECLARE @Tabla table(
Modulo                   varchar(20),
Origen                   varchar(50),
Destino                  varchar(50),
Orden                    int,
Generar                  varchar(100)
)
SELECT @Empresa = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Empresa'
SELECT @Modulo = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Modulo'
SELECT @Origen = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Origen'
SET @Empresa = LTRIM(RTRIM(ISNULL(@Empresa,'')))
SET @Modulo  = LTRIM(RTRIM(ISNULL(@Modulo,'')))
SET @Origen  = LTRIM(RTRIM(ISNULL(@Origen,'')))
INSERT INTO @Tabla (Modulo, Origen, Destino, Orden, Generar)
SELECT Modulo, OMov, DMov, Orden, Nombre
FROM CfgMovFlujo
WHERE Modulo = @Modulo
AND OMov = @Origen
ORDER BY Orden
SELECT @Texto = (SELECT LTRIM(RTRIM(ISNULL(Modulo,'')))  AS Modulo,
LTRIM(RTRIM(ISNULL(Origen,'')))  AS Origen,
LTRIM(RTRIM(ISNULL(Destino,''))) AS Destino,
CAST(ISNULL(Orden,0) AS varchar) AS Orden,
LTRIM(RTRIM(ISNULL(Generar,''))) AS Generar
FROM @Tabla AS Tabla
FOR XML AUTO)
SELECT @ReferenciaIS = Referencia FROM IntelisisService WHERE ID = @ID
SET @Resultado = '<?xml version="1.0" encoding="windows-1252"?><Intelisis Sistema="Intelisis" Contenido="Resultado" Referencia=' + CHAR(34) + ISNULL(@ReferenciaIS,'') + CHAR(34) + ' SubReferencia=' + CHAR(34) + ISNULL(@SubReferencia,'') + CHAR(34) + ' Version=' + CHAR(34) + ISNULL(CONVERT(varchar ,@Version),'') + CHAR(34) + '><Resultado IntelisisServiceID=' + CHAR(34) + ISNULL(CONVERT(varchar,@ID),'')  + CHAR(34)  + ' Ok=' + CHAR(34) + ISNULL(CONVERT(varchar,@Ok),'') + CHAR(34) + ' OkRef=' + CHAR(34) + ISNULL(@OkRef,'') + CHAR(34) + '>' + ISNULL(CONVERT(varchar(max),@Texto),'') + '</Resultado></Intelisis>'
SET @Resultado = REPLACE(@Resultado,'<BR>','.')
END

