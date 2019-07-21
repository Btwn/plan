SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spIntelisisWMSMovimientosInvLista
@ID                        int,
@iSolicitud                int,
@Version                   float,
@Resultado                 varchar(max) = NULL OUTPUT,
@Ok                        int = NULL OUTPUT,
@OkRef                     varchar(255) = NULL OUTPUT

AS BEGIN
DECLARE
@Texto                     xml,
@ReferenciaIS              varchar(100),
@SubReferencia             varchar(100),
@Modulo                    varchar(5),
@Clave                     varchar(20)
DECLARE @Tabla Table(
Movimiento                 varchar(20),
Clave                      varchar(20),
SubClave                   varchar(20)
)
BEGIN TRY
SELECT @Modulo = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Modulo'
SELECT @Clave = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Clave'
SET @Modulo = LTRIM(RTRIM(ISNULL(@Modulo,'')))
SET @Clave  = LTRIM(RTRIM(ISNULL(@Clave,'')))
INSERT INTO @Tabla (Movimiento, Clave, SubClave)
SELECT Mov, Clave, SubClave
FROM MovTipo
WHERE Modulo = @Modulo
AND Clave = @Clave
ORDER BY Orden
SELECT @Texto = (SELECT LTRIM(RTRIM(ISNULL(Movimiento,'')))  AS Movimiento,
LTRIM(RTRIM(ISNULL(Clave,'')))       AS Clave,
LTRIM(RTRIM(ISNULL(SubClave,'')))    AS SubClave
FROM @Tabla AS TMA
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

