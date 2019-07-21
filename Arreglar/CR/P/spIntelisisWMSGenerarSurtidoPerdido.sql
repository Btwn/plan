SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spIntelisisWMSGenerarSurtidoPerdido
@ID              int,
@iSolicitud      int,
@Version         float,
@Resultado       varchar(max) = NULL OUTPUT,
@Ok              int = NULL OUTPUT,
@OkRef           varchar(255) = NULL OUTPUT

AS BEGIN
DECLARE
@Texto           xml,
@ReferenciaIS    varchar(100),
@SubReferencia   varchar(100),
@Empresa         varchar(5),
@Usuario         varchar(10),
@ModuloID        int,
@MovGenerar      varchar(20),
@MovIDGenerar    varchar(20),
@IDGenerar       int,
@Estacion        int,
@Montacarga      varchar(20),
@Agente          varchar(20),
@NombreTrans     varchar(20)
DECLARE @Tabla Table(
IDR                 int identity(1,1),
Mensaje             varchar (255)
)
BEGIN TRY
SELECT @Empresa = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Empresa'
SELECT @Usuario = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Usuario'
SELECT @ModuloID = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'ModuloID'
SELECT @Montacarga = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Montacarga'
SET @Empresa     = LTRIM(RTRIM(ISNULL(@Empresa,'')))
SET @Usuario     = LTRIM(RTRIM(ISNULL(@Usuario,'')))
SET @ModuloID    = LTRIM(RTRIM(ISNULL(@ModuloID,'')))
SET @Montacarga  = LTRIM(RTRIM(ISNULL(@Montacarga,'')))
SET @Estacion = @@SPID
SET @NombreTrans = 'TMA_SURPER' + LTRIM(RTRIM(LEFT(CAST(@Estacion AS varchar), 10)))
IF ISNULL(@ModuloID,0) = 0
BEGIN
SET @Ok = 14055
INSERT INTO @Tabla (Mensaje)
SELECT Descripcion FROM MensajeLista WHERE Mensaje = @Ok
SET @Ok = NULL
END
ELSE
BEGIN
BEGIN TRANSACTION @NombreTrans
SELECT @Agente = DefAgente FROM Usuario WHERE Usuario = @Usuario
SELECT @MovGenerar = TMASurtidoPerdido FROM EmpresaCfgMovWMS WHERE Empresa = @Empresa
SET @MovGenerar = LTRIM(RTRIM(ISNULL(@MovGenerar,'')))
EXEC @IDGenerar = spAfectar 'TMA', @ModuloID, 'GENERAR', 'Pendiente', @MovGenerar, @Usuario, @Estacion, @EnSilencio = 1, @Conexion = 1, @Ok = @Ok OUTPUT, @OkRef = @OkRef OUTPUT
IF @Ok BETWEEN 80030 AND 81000 SELECT @Ok = NULL, @OkRef = NULL
IF ISNULL(@Ok,0) = 0
BEGIN
UPDATE TMA SET Montacarga = @Montacarga, Agente = @Agente WHERE ID = @IDGenerar
UPDATE TMAD SET GeneradoEnMovil = 1 WHERE ID = @IDGenerar
EXEC spAfectar 'TMA', @IDGenerar, 'AFECTAR', 'Todo', NULL, @Usuario, @Estacion, @EnSilencio = 1, @Conexion = 1, @Ok = @Ok OUTPUT, @OkRef = @OkRef OUTPUT
IF @Ok BETWEEN 80030 AND 81000 SELECT @Ok = NULL, @OkRef = NULL
END
IF ISNULL(@Ok,0) = 0
BEGIN
UPDATE TMAD SET ProcesadoEnMovil = 1 WHERE ID = @IDGenerar
SELECT @MovIDGenerar = LTRIM(RTRIM(ISNULL(MovID,''))) FROM TMA WHERE ID = @IDGenerar
INSERT INTO @Tabla (Mensaje)
VALUES (@MovGenerar + ' ' + @MovIDGenerar + ' generado con éxito.' )
IF EXISTS (SELECT [name] FROM sys.dm_tran_active_transactions WHERE name = @NombreTrans) COMMIT TRANSACTION @NombreTrans
END
ELSE
BEGIN
SELECT @OkRef = Descripcion FROM MensajeLista WHERE Mensaje = @Ok
INSERT INTO @Tabla (Mensaje) VALUES (@OkRef)
IF EXISTS (SELECT [name] FROM sys.dm_tran_active_transactions WHERE name = @NombreTrans) ROLLBACK TRANSACTION @NombreTrans
END
END
SELECT @Texto = (SELECT ISNULL(Mensaje,'') AS Mensaje
FROM @Tabla AS Tabla
FOR XML AUTO)
END TRY
BEGIN CATCH
SET @Ok = 1
SELECT @OkRef = LTRIM(RTRIM(LEFT(ERROR_MESSAGE(),255)))
IF EXISTS (SELECT [name] FROM sys.dm_tran_active_transactions WHERE name = @NombreTrans) ROLLBACK TRANSACTION @NombreTrans
END CATCH
SELECT @ReferenciaIS = Referencia FROM IntelisisService WHERE ID = @ID
SET @Resultado = '<?xml version="1.0" encoding="windows-1252"?><Intelisis Sistema="Intelisis" Contenido="Resultado" Referencia=' + CHAR(34) + ISNULL(@ReferenciaIS,'') + CHAR(34) + ' SubReferencia=' + CHAR(34) + ISNULL(@SubReferencia,'') + CHAR(34) + ' Version=' + CHAR(34) + ISNULL(CONVERT(varchar ,@Version),'') + CHAR(34) + '><Resultado IntelisisServiceID=' + CHAR(34) + ISNULL(CONVERT(varchar,@ID),'')  + CHAR(34)  + ' Ok=' + CHAR(34) + ISNULL(CONVERT(varchar,@Ok),'') + CHAR(34) + ' OkRef=' + CHAR(34) + ISNULL(@OkRef,'') + CHAR(34) + '>' + ISNULL(CONVERT(varchar(max),@Texto),'') + '</Resultado></Intelisis>'
SET @Resultado = REPLACE(@Resultado,'<BR>','.')
END

