SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spIntelisisWMSCerrarTarimasSurtidoTransitoPCK
@ID                 int,
@iSolicitud         int,
@Version            float,
@Resultado          varchar(max) = NULL OUTPUT,
@Ok                 int = NULL OUTPUT,
@OkRef              varchar(255) = NULL OUTPUT

AS BEGIN
DECLARE
@Texto                xml,
@ReferenciaIS         varchar(100),
@SubReferencia        varchar(100),
@Empresa              varchar(5),
@ListaMovimientos     varchar(max),
@Numero               varchar(20),
@Usuario              varchar(10),
@Estacion             int,
@EnSilencio		        bit,
@Fecha                datetime,
@Msg                  varchar(300),
@Delimitador          char(1),
@Inicio               int,
@Fin                  int,
@idx                  int,
@Maximo               int,
@MaxIdx               int
DECLARE @ListaID table (
idx                   int IDENTITY(1,1),
ID                    varchar(10)
)
DECLARE @Tabla table (
Msg                   varchar(300)
)
BEGIN TRY
SELECT @ReferenciaIS = Referencia FROM IntelisisService WHERE ID = @ID
SELECT @Empresa = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Empresa'
SELECT @ListaMovimientos = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'ListaMovimientos'
SET @EnSilencio = 0
SET @Estacion = @@SPID
SET @Fecha = GETDATE()
SET @Delimitador = '~'
SET @Maximo = 1000
SET @idx = 0
SET @Inicio = 1
SET @Fin = CHARINDEX(@Delimitador, @ListaMovimientos)
WHILE (@Inicio < (LEN(@ListaMovimientos) + 1)) AND (@idx < @Maximo)
BEGIN
SET @idx = @idx + 1
IF @Fin = 0 SET @Fin = (LEN(@ListaMovimientos) + 1)
INSERT INTO @ListaID (ID) VALUES(SUBSTRING(@ListaMovimientos, @Inicio, (@Fin - @Inicio)))
SET @Inicio = (@Fin + 1)
SET @Fin = CHARINDEX(@Delimitador, @ListaMovimientos, @Inicio)
END
SELECT @Usuario = Usuario FROM IntelisisService WHERE ID = @ID
DELETE ListaID WHERE Estacion = @Estacion
SELECT @MaxIdx = MAX(idx) FROM @ListaID
SET @MaxIdx = ISNULL(@MaxIdx,0)
SET @idx = 0
WHILE @idx < @MaxIdx
BEGIN
SET @idx = @idx + 1
SELECT @Numero = ID FROM @ListaID WHERE idx = @idx
IF ISNUMERIC(@Numero) = 1
BEGIN
INSERT INTO ListaID (Estacion,ID)
VALUES (@Estacion,CAST(@Numero AS int))
END
END
EXEC spProcesarTMASurtidoTransito @Estacion, @Empresa , @Fecha, @Usuario, NULL, @EnSilencio, @Ok OUTPUT, @OkRef OUTPUT
SET @Msg = ISNULL(@OkRef, '')
SET @Msg = REPLACE(@Msg,'<BR>','.')
INSERT INTO @Tabla(Msg) VALUES(@Msg)
SELECT @Texto = (SELECT ISNULL(Msg,'') AS Msg FROM @Tabla AS TMA FOR XML AUTO)
IF @Ok IS NOT NULL SELECT @OkRef = Descripcion FROM MensajeLista WHERE Mensaje = @Ok
SET @Resultado = '<?xml version="1.0" encoding="windows-1252"?><Intelisis Sistema="Intelisis" Contenido="Resultado" Referencia=' + CHAR(34) + ISNULL(@ReferenciaIS,'') + CHAR(34) + ' SubReferencia=' + CHAR(34) + ISNULL(@SubReferencia,'') + CHAR(34) + ' Version=' + CHAR(34) + ISNULL(CONVERT(varchar ,@Version),'') + CHAR(34) + '><Resultado IntelisisServiceID=' + CHAR(34) + ISNULL(CONVERT(varchar,@ID),'')  + CHAR(34)  + ' Ok=' + CHAR(34) + ISNULL(CONVERT(varchar,@Ok),'') + CHAR(34) + ' OkRef=' + CHAR(34) + ISNULL(@OkRef,'') + CHAR(34) + '>' + ISNULL(CONVERT(varchar(max),@Texto),'') + '</Resultado></Intelisis>'
SET @Resultado = REPLACE(@Resultado,'<BR>','.')
END TRY
BEGIN CATCH
SET @Ok = 1
SELECT @OkRef = Descripcion FROM MensajeLista WHERE Mensaje = @Ok
SELECT @Msg = 'Error: ' + CAST(ERROR_NUMBER() AS varchar) + ', Procedimiento: ' + ERROR_PROCEDURE() + ', Linea: ' + CAST(ERROR_LINE() AS varchar)  + ', Mensaje: '  + ERROR_MESSAGE() + '.'
INSERT INTO @Tabla(Msg) VALUES(@Msg)
SELECT @Texto = (SELECT ISNULL(Msg,'') AS Msg FROM @Tabla AS TMA FOR XML AUTO)
SET @Resultado = '<?xml version="1.0" encoding="windows-1252"?><Intelisis Sistema="Intelisis" Contenido="Resultado" Referencia=' + CHAR(34) + ISNULL(@ReferenciaIS,'') + CHAR(34) + ' SubReferencia=' + CHAR(34) + ISNULL(@SubReferencia,'') + CHAR(34) + ' Version=' + CHAR(34) + ISNULL(CONVERT(varchar ,@Version),'') + CHAR(34) + '><Resultado IntelisisServiceID=' + CHAR(34) + ISNULL(CONVERT(varchar,@ID),'')  + CHAR(34)  + ' Ok=' + CHAR(34) + ISNULL(CONVERT(varchar,@Ok),'') + CHAR(34) + ' OkRef=' + CHAR(34) + ISNULL(@OkRef,'') + CHAR(34) + '>' + ISNULL(CONVERT(varchar(max),@Texto),'') + '</Resultado></Intelisis>'
SET @Resultado = REPLACE(@Resultado,'<BR>','.')
END CATCH
END

