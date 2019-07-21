SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spISIntelisisTMAAfectarTMA_SADO
@ID                           int,
@iSolicitud                   int,
@Version                      float,
@Resultado                    varchar(max) = NULL OUTPUT,
@Ok                           int = NULL OUTPUT,
@OkRef                        varchar(255) = NULL OUTPUT

AS BEGIN
DECLARE
@IDGenerar                    int,
@IDAcceso                     int,
@MovTipo                      varchar(20),
@ReferenciaIS                 varchar(100),
@Usuario2                     varchar(10),
@Estacion                     int,
@SubReferencia                varchar(100),
@Empresa                      varchar(5),
@Mov                          varchar(20),
@MovID                        varchar(20),
@Sucursal                     int,
@IdTma                        int,
@Renglon                      float,
@Tarima                       varchar(20),
@SucursalNombre               varchar(100),
@Posicion                     varchar(20),
@PosicionDestino              varchar(20),
@Usuario                      varchar(15),
@Montacargas                  varchar(20),
@Estatus                      varchar(20),
@Agente                       varchar(20),
@Modificar                    bit,
@Procesado                    bit,
@Mov2                         varchar(20),
@Mov3                         varchar(20),
@MovID2                       varchar(20),
@PosicionDestinoGenerar       varchar(20),
@DescripcionPosicionDestino   varchar(100),
@PosicionDestinoOrigen        varchar(20),
@RequiereMontacarga           int,
@NombreTrans                  varchar(20)
BEGIN TRY
SET @Estacion = @@SPID
SET @NombreTrans = 'AfectarTMA_SADO' + LTRIM(RTRIM(LEFT(CAST(@Estacion AS varchar), 5)))
SELECT @Empresa = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Empresa'
SELECT @Mov = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Mov'
SELECT @MovID = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'MovID'
SELECT @IdTma = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'IdTma'
SELECT @Renglon = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Renglon'
SELECT @Tarima = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Tarima'
SELECT @Posicion = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Posicion'
SELECT @PosicionDestino = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'PosicionDestino'
SELECT @Usuario = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Usuario'
SELECT @SucursalNombre = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'SucursalNombre'
SELECT @Montacargas = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Montacarga'
SET @Empresa         = LTRIM(RTRIM(ISNULL(@Empresa,'')))
SET @Mov             = LTRIM(RTRIM(ISNULL(@Mov,'')))
SET @MovID           = LTRIM(RTRIM(ISNULL(@MovID,'')))
SET @IdTma           = CAST(ISNULL(@IdTma,0) AS int)
SET @Renglon         = CAST(ISNULL(@Renglon,0) AS float)
SET @Tarima          = LTRIM(RTRIM(ISNULL(@Tarima,'')))
SET @Posicion        = LTRIM(RTRIM(ISNULL(@Posicion,'')))
SET @PosicionDestino = LTRIM(RTRIM(ISNULL(@PosicionDestino,'')))
SET @Usuario         = LTRIM(RTRIM(ISNULL(@Usuario,'')))
SET @SucursalNombre  = LTRIM(RTRIM(ISNULL(@SucursalNombre,'')))
SET @Montacargas     = LTRIM(RTRIM(ISNULL(@Montacargas,'')))
SELECT @MovTipo = Clave FROM MovTipo WHERE Mov = @Mov AND Modulo = 'TMA'
SELECT @Sucursal = Sucursal FROM Sucursal WHERE Nombre = @SucursalNombre
SELECT @RequiereMontacarga = ISNULL(RequiereMontacarga,0) FROM MapeoMovMovil WHERE Modulo='TMA' AND Mov = @Mov
SELECT @Modificar = ISNULL(ModificarPosicionSugeridaWMS,0), @Agente = DefAgente FROM Usuario WHERE Usuario = @Usuario
SELECT @Estatus = Estatus FROM TMA WHERE ID = @IdTma
SELECT @Procesado = ISNULL(Procesado,0) FROM TMAD WHERE ID = @IdTma AND Renglon = @Renglon
IF @MovTipo NOT IN('TMA.SADO','TMA.SRADO') SET @Ok = 35005
IF @Ok IS NULL AND NOT (@Estatus = 'PENDIENTE') SET @OK = 10015
IF @Ok IS NULL AND @Procesado = 1 SET @Ok = 60090
IF @Ok IS NULL AND @Agente IS NULL SELECT @Ok = 20930
IF @Ok IS NULL AND NOT EXISTS(SELECT * FROM TMA t JOIN TMAD d ON t.ID = d. ID WHERE d.Tarima = @Tarima AND t.Empresa = @Empresa AND t.Mov = @Mov AND t.MovID = @MovID) SELECT @Ok = 13110
IF @Ok IS NULL AND NOT EXISTS(SELECT * FROM Montacarga WHERE Montacarga = @Montacargas) AND @RequiereMontacarga = 1 SELECT @Ok = 20948
IF @Ok IS NULL
BEGIN
IF NOT EXISTS(SELECT * FROM TMA t JOIN TMAD d ON (t.ID = d.ID) WHERE d.Posicion = @Posicion AND d.Tarima = @Tarima AND t.Empresa = @Empresa AND t.Mov = @Mov AND t.MovID = @MovID)
BEGIN
IF @Modificar = 0 SELECT @Ok = 71027
END
END
IF @Ok IS NULL
BEGIN
BEGIN TRANSACTION @NombreTrans
UPDATE TMAD SET CantidadA = 1 WHERE ID = @IdTma AND Renglon = @Renglon
IF @MovTipo = 'TMA.SADO'
BEGIN
SELECT @Mov3 = TMAOrdenAcomodo FROM EmpresaCfgMovWMS WHERE Empresa = @Empresa
EXEC @IDGenerar = spAfectar 'TMA', @IdTma, 'GENERAR', 'Seleccion', @Mov3, @Usuario, @Estacion, @EnSilencio = 1, @Conexion = 1, @Ok = @Ok OUTPUT, @OkRef = @OkRef OUTPUT
IF @Ok BETWEEN 80030 AND 81000 SELECT @Ok = NULL, @OkRef = NULL
IF @Ok IS NULL
BEGIN
UPDATE TMA SET Montacarga = @Montacargas, Agente = @Agente WHERE ID = @IDGenerar
EXEC spAfectar 'TMA', @IDGenerar, 'AFECTAR', 'Todo', NULL, @Usuario, @Estacion, @EnSilencio = 1, @Conexion = 1, @Ok = @Ok OUTPUT, @OkRef = @OkRef OUTPUT
IF @Ok BETWEEN 80030 AND 81000 SELECT @Ok = NULL, @OkRef = NULL
END
END
IF @MovTipo = 'TMA.SRADO'
BEGIN
SELECT @Mov3 = TMAOrdenReacomodo FROM EmpresaCfgMovWMS WHERE Empresa = @Empresa
EXEC @IDGenerar = spAfectar 'TMA', @IdTma, 'GENERAR', 'Seleccion', @Mov3, @Usuario, @Estacion, @EnSilencio = 1, @Conexion = 1, @Ok = @Ok OUTPUT, @OkRef = @OkRef OUTPUT
IF @Ok BETWEEN 80030 AND 81000 SELECT @Ok = NULL, @OkRef = NULL
IF @Ok IS NULL
BEGIN
UPDATE TMA SET Montacarga = @Montacargas, Agente = @Agente WHERE ID = @IDGenerar
EXEC spAfectar 'TMA', @IDGenerar, 'AFECTAR', 'Todo', NULL, @Usuario, @Estacion, @EnSilencio = 1, @Conexion = 1, @Ok = @Ok OUTPUT, @OkRef = @OkRef OUTPUT
IF @Ok BETWEEN 80030 AND 81000 SELECT @Ok = NULL, @OkRef = NULL
END
END
IF @Ok IS NULL
BEGIN
SELECT @Mov2 = LTRIM(RTRIM(ISNULL(Mov,''))), @MovID2 = LTRIM(RTRIM(ISNULL(MovID,''))) FROM TMA WHERE ID = @IDGenerar
SELECT @PosicionDestinoGenerar = LTRIM(RTRIM(ISNULL(PosicionDestino,''))) FROM TMAD WHERE ID = @IDGenerar
SELECT @DescripcionPosicionDestino = LTRIM(RTRIM(ISNULL(Descripcion,''))) FROM AlmPos WHERE Posicion = @PosicionDestinoGenerar
IF EXISTS (SELECT [name] FROM sys.dm_tran_active_transactions WHERE name = @NombreTrans) COMMIT TRANSACTION @NombreTrans
END
ELSE
BEGIN
IF EXISTS (SELECT [name] FROM sys.dm_tran_active_transactions WHERE name = @NombreTrans) ROLLBACK TRANSACTION @NombreTrans
SELECT @OkRef = Descripcion FROM MensajeLista WHERE Mensaje = @Ok
END
END
END TRY
BEGIN CATCH
SET @Ok = 1
SELECT @OkRef = LTRIM(RTRIM(LEFT(ERROR_MESSAGE(),255)))
END CATCH
SELECT @ReferenciaIS = Referencia FROM IntelisisService WHERE ID = @ID
SET @Resultado = '<?xml version="1.0" encoding="windows-1252"?><Intelisis Sistema="Intelisis" Contenido="Resultado" Referencia=' + CHAR(34) + ISNULL(@ReferenciaIS,'') + CHAR(34) + ' SubReferencia=' + CHAR(34) + ISNULL(@SubReferencia,'') + CHAR(34) + ' Version=' + CHAR(34) + ISNULL(CONVERT(varchar ,@Version),'') + CHAR(34) + '><Resultado IntelisisServiceID=' + CHAR(34) + ISNULL(CONVERT(varchar,@ID),'') + CHAR(34) + ' Modulo="TMA" ModuloID =' + CHAR(34) + ISNULL(CONVERT(varchar,@IDGenerar),'') + CHAR(34) +'  Mov=' + CHAR(34) + ISNULL(@Mov2,'') + CHAR(34) +'  MovID=' + CHAR(34) + ISNULL(@MovID2,'') + CHAR(34)  +'  PosicionDestino=' + CHAR(34) + ISNULL(@PosicionDestinoGenerar,'') + CHAR(34) +'  DescripcionPosicionDestino=' + CHAR(34) + ISNULL(@DescripcionPosicionDestino,'') + CHAR(34) +  ' Ok=' + CHAR(34) + ISNULL(CONVERT(varchar,@Ok),'') + CHAR(34) + ' OkRef=' + CHAR(34) + ISNULL(@OkRef,'') + CHAR(34) + '/></Intelisis>'
SET @Resultado = REPLACE(@Resultado,'<BR>','.')
END

