SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spIntelisisWMSMovimientoCompleto
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
@Empresa                   varchar(5),
@Modulo                    varchar(5),
@Mov                       varchar(20),
@MovID                     varchar(20),
@ModuloID                  int,
@Mensaje                   varchar (255)
DECLARE @Tabla Table(
IDR                      int identity(1,1),
Pendientes               int,
MovimientoCompleto       bit,
Mensaje                  varchar (255)
)
BEGIN TRY
SELECT @Empresa = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Empresa'
SELECT @Modulo = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Modulo'
SELECT @Mov = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Mov'
SELECT @MovID = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'MovID'
SET @Empresa = LTRIM(RTRIM(ISNULL(@Empresa,'')))
SET @Modulo  = LTRIM(RTRIM(ISNULL(@Modulo,'')))
SET @Mov     = LTRIM(RTRIM(ISNULL(@Mov,'')))
SET @MovID   = LTRIM(RTRIM(ISNULL(@MovID,'')))
IF @Modulo = 'TMA' SELECT @ModuloID = ID FROM TMA WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID
IF ISNULL(@ModuloID ,0) = 0
BEGIN
SET @Ok = 14055
INSERT INTO @Tabla (Mensaje)
SELECT Descripcion FROM MensajeLista WHERE Mensaje = @Ok
SET @Ok = NULL
END
ELSE
BEGIN
INSERT INTO @Tabla (Pendientes,MovimientoCompleto)
SELECT ISNULL(SUM(CantidadPendiente),0), 0 FROM TMAD WHERE ID = @ModuloID
IF (SELECT COUNT(IDR) FROM @Tabla) = 0 INSERT INTO @Tabla(Pendientes) VALUES (0)
UPDATE @Tabla SET MovimientoCompleto = 1 WHERE Pendientes = 0
END
SELECT @Texto = (SELECT CAST(ISNULL(MovimientoCompleto,0) AS varchar) AS MovimientoCompleto,
ISNULL(Mensaje,'')                            AS Mensaje
FROM @Tabla AS Tabla
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

