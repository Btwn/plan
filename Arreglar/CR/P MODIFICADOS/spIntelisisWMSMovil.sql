SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spIntelisisWMSMovil
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
@Mov                     varchar(20),
@MovID                   varchar(20),
@Renglon                 float,
@Renglon2                varchar(100),
@Generado                char(1),
@Procesado               char(1),
@IdTma                   int
DECLARE @Tabla table(
IdTma                    int,
Mov                      varchar(20),
MovID                    varchar(20),
Renglon                  float,
Generado                 char(1),
Procesado                char(1)
)
BEGIN TRY
SELECT @Empresa = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Empresa'
SELECT @Mov = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Mov'
SELECT @MovID = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'MovID'
SELECT @Renglon2 = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Renglon'
SELECT @Generado = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Generado'
SELECT @Procesado = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Procesado'
SET @Empresa   = LTRIM(RTRIM(ISNULL(@Empresa,'')))
SET @Mov       = LTRIM(RTRIM(ISNULL(@Mov,'')))
SET @MovID     = LTRIM(RTRIM(ISNULL(@MovID,'')))
SET @Renglon2  = LTRIM(RTRIM(ISNULL(@Renglon2,'0')))
SET @Generado  = ISNULL(@Generado,'0')
SET @Procesado = ISNULL(@Procesado,'0')
IF ISNUMERIC(@Renglon2) = 1
SET @Renglon = CAST(ISNULL(@Renglon2,'0') AS float)
ELSE
SET @Renglon = 0
SELECT @IdTma = ID
FROM TMA
WITH(NOLOCK) WHERE Empresa = @Empresa
AND Mov = @Mov
AND MovID = @MovID
IF EXISTS(SELECT GeneradoEnMovil FROM TMAD WITH(NOLOCK) WHERE ID = @IdTma AND GeneradoEnMovil = 1)
SET @Generado = '1'
IF @Renglon = 0
BEGIN
UPDATE TMAD
 WITH(ROWLOCK) SET GeneradoEnMovil  = CAST(@Generado AS bit),
ProcesadoEnMovil = CAST(@Procesado AS bit)
WHERE ID = @IdTma
END
ELSE
BEGIN
UPDATE TMAD
 WITH(ROWLOCK) SET GeneradoEnMovil  = CAST(@Generado AS bit),
ProcesadoEnMovil = CAST(@Procesado AS bit)
WHERE ID = @IdTma
AND Renglon = @Renglon
END
INSERT INTO @Tabla (IdTma,Mov,MovID,Renglon,Generado,Procesado) VALUES (@IdTma,@Mov,@MovID,@Renglon,@Generado,@Procesado)
SELECT @Texto = (
SELECT CAST(ISNULL(IdTma,0) AS VARCHAR)     AS IdTma,
LTRIM(RTRIM(ISNULL(Mov,'')))         AS Mov,
LTRIM(RTRIM(ISNULL(MovID,'')))       AS MovID,
CAST(ISNULL(Renglon,0) AS VARCHAR)   AS Renglon,
LTRIM(RTRIM(ISNULL(Generado,'')))    AS Generado,
LTRIM(RTRIM(ISNULL(Procesado,'')))   AS Procesado
FROM @Tabla AS TMA
FOR XML AUTO)
IF @Ok IS NOT NULL SELECT @OkRef = Descripcion FROM MensajeLista WITH(NOLOCK) WHERE Mensaje = @Ok
END TRY
BEGIN CATCH
SET @Ok = 1
SELECT @OkRef = LEFT(LTRIM(RTRIM(ERROR_MESSAGE())), 255)
END CATCH
SELECT @ReferenciaIS = Referencia FROM IntelisisService WITH(NOLOCK) WHERE ID = @ID
SET @Resultado = '<?xml version="1.0" encoding="windows-1252"?><Intelisis Sistema="Intelisis" Contenido="Resultado" Referencia=' + CHAR(34) + ISNULL(@ReferenciaIS,'') + CHAR(34) + ' SubReferencia=' + CHAR(34) + ISNULL(@SubReferencia,'') + CHAR(34) + ' Version=' + CHAR(34) + ISNULL(CONVERT(varchar ,@Version),'') + CHAR(34) + '><Resultado IntelisisServiceID=' + CHAR(34) + ISNULL(CONVERT(varchar,@ID),'')  + CHAR(34)  + ' Ok=' + CHAR(34) + ISNULL(CONVERT(varchar,@Ok),'') + CHAR(34) + ' OkRef=' + CHAR(34) + ISNULL(@OkRef,'') + CHAR(34) + '>' + ISNULL(CONVERT(varchar(max),@Texto),'') + '</Resultado></Intelisis>'
SET @Resultado = REPLACE(@Resultado,'<BR>','.')
END

