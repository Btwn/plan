SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spIntelisisTMAAfectarMovTMA_PCKTARIMATRAN
@ID                      int,
@iSolicitud              int,
@Version                 float,
@Resultado               varchar(max) = NULL OUTPUT,
@Ok                      int = NULL OUTPUT,
@OkRef                   varchar(255) = NULL OUTPUT

AS BEGIN
DECLARE
@IDGenerar               int,
@MovTipo                 varchar(20),
@ReferenciaIS            varchar(100),
@Usuario2                varchar(10),
@Estacion                int,
@SubReferencia           varchar(100),
@Empresa                 varchar(5),
@Mov                     varchar(20),
@MovID                   varchar(20),
@Sucursal                int,
@ID2                     int,
@Tarima                  varchar(20),
@Sucursal2               varchar(100),
@PosicionDestino         varchar(20),
@Usuario                 varchar(15),
@Montacargas             varchar(20),
@Estatus                 varchar(20),
@Agente                  varchar(20),
@Modificar               bit,
@Procesado               bit,
@Mov2                    varchar(20),
@MovID2                  varchar(20),
@PosicionDGenerar        varchar(20),
@Descripcion             varchar(100),
@Movimiento              varchar(20),
@Almacen                 varchar(20),
@Cantidad                varchar(100)
BEGIN TRANSACTION
SELECT @Estacion = @@SPID
IF @Ok IS NULL
BEGIN
SELECT @Empresa = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Empresa'
SELECT @Sucursal2 = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Sucursal'
SELECT @Usuario = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Usuario'
SELECT @Mov = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Mov'
SELECT @MovID = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'MovID'
SELECT @Tarima = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Tarima'
SELECT @PosicionDestino = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'PosicionDestino'
SELECT @Montacargas = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Montacargas'
SELECT @Cantidad = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Cantidad'
END
SELECT @Sucursal = Sucursal
FROM Sucursal
WHERE Nombre = @Sucursal2
SELECT @ID2 = ID,
@Estatus = Estatus
FROM TMA
WHERE Empresa = @Empresa
AND Sucursal = @Sucursal
AND Mov = @Mov
AND MovID = @MovID
SELECT @Procesado = ISNULL(Procesado,0)
FROM TMAD
WHERE ID = @ID2
AND Tarima = @Tarima
SELECT @Modificar = ModificarPosicionSugeridaWMS
FROM Usuario
WHERE Usuario = @Usuario
SELECT @MovTipo = Clave
FROM MovTipo
WHERE Mov = @Mov
AND Modulo = 'TMA'
IF @MovTipo NOT IN ('TMA.PCKTARIMATRAN')
SELECT @Ok = 35005, @OkRef = @Mov
IF @Ok IS NULL
BEGIN
IF NOT EXISTS(SELECT * FROM Montacarga WHERE Montacarga = @Montacargas)
SET @Ok = 20948
IF NOT EXISTS(SELECT * FROM TMA t JOIN TMAD d ON (t.ID = d.ID) WHERE d.Tarima = @Tarima AND d.PosicionDestino = @PosicionDestino AND t.Empresa = @Empresa AND t.Sucursal = @Sucursal AND t.Mov = @Mov AND t.MovID = @MovID)
BEGIN
IF NOT EXISTS(SELECT * FROM TMA t JOIN TMAD d ON (t.ID = d.ID) WHERE CASE WHEN CHARINDEX('-', d.Tarima, 1) >0 THEN SUBSTRING(d.Tarima, 1, CHARINDEX('-', d.Tarima, 1)-1) ELSE d.Tarima END = @Tarima AND d.PosicionDestino = @PosicionDestino AND t.Empresa = @Empresa AND t.Sucursal = @Sucursal AND t.Mov = @Mov AND t.MovID = @MovID)
SET @Ok = 13035
END
END
IF @Ok IS NULL
BEGIN
UPDATE TMAD
SET CantidadA = CAST(@Cantidad AS float)
WHERE Tarima = @Tarima
AND ID = @ID2
IF @Ok IS NULL AND @Estatus = 'PENDIENTE' AND @MovTipo = 'TMA.PCKTARIMATRAN'
BEGIN
SELECT @Movimiento = TMAPCKTarima
FROM EmpresaCfgMovWMS
WHERE Empresa = @Empresa
EXEC @IDGenerar = spAfectar 'TMA', @ID2, 'GENERAR', 'Seleccion', @Movimiento, @Usuario, @Estacion, @EnSilencio = 1, @Conexion = 1, @Ok = @Ok OUTPUT, @OkRef = @OkRef OUTPUT
IF @Ok BETWEEN 80030 AND 81000
SELECT @Ok = NULL , @OkRef = NULL
SELECT @Agente = DefAgente
FROM Usuario
WHERE Usuario = @Usuario
IF @Agente IS NULL
SELECT @Ok = 20930
IF @Ok IS NULL
BEGIN
UPDATE TMA
SET Montacarga = @Montacargas,
Agente = @Agente
WHERE ID = @IDGenerar
EXEC spAfectar 'TMA', @IDGenerar, 'AFECTAR', 'Todo', NULL, @Usuario, @Estacion, @EnSilencio = 1, @Conexion = 1, @Ok = @Ok OUTPUT, @OkRef = @OkRef OUTPUT
IF @Ok BETWEEN 80030 AND 81000
SELECT @Ok = NULL , @OkRef = NULL
END
SELECT @Mov2 = Mov,
@MovID2 = MovID
FROM TMA
WHERE ID = @IDGenerar
SELECT @PosicionDGenerar = PosicionDestino
FROM TMAD
WHERE ID = @IDGenerar
SELECT @Descripcion = Descripcion
FROM AlmPos
WHERE Almacen = @Almacen
AND Posicion = @PosicionDGenerar
END
END
IF @Ok IS NULL
BEGIN
COMMIT TRANSACTION
END ELSE
BEGIN
ROLLBACK TRANSACTION
END
IF @Ok IS NOT NULL
SELECT @OkRef = Descripcion FROM MensajeLista WHERE Mensaje = @Ok
SELECT @ReferenciaIS = Referencia
FROM IntelisisService
WHERE ID = @ID
SET @Resultado = '<?xml version="1.0" encoding="windows-1252"?><Intelisis Sistema="Intelisis" Contenido="Resultado" Referencia=' + CHAR(34) + ISNULL(@ReferenciaIS,'') + CHAR(34) + ' SubReferencia=' + CHAR(34) + ISNULL(@SubReferencia,'') + CHAR(34) + ' Version=' + CHAR(34) + ISNULL(CONVERT(varchar ,@Version),'') + CHAR(34) + '><Resultado IntelisisServiceID=' + CHAR(34) + ISNULL(CONVERT(varchar,@ID),'') + CHAR(34) + ' Modulo="TMA" ModuloID =' + CHAR(34) + ISNULL(CONVERT(varchar,@IDGenerar),'') + CHAR(34) +'  Mov=' + CHAR(34) + ISNULL(@Mov2,'') + CHAR(34) +'  MovID=' + CHAR(34) + ISNULL(@MovID2,'') + CHAR(34)  +'  PosicionDestino=' + CHAR(34) + ISNULL(@PosicionDGenerar,'') + CHAR(34) +' DescripcionPosicionDestino=' + CHAR(34) + ISNULL(@Descripcion,'') + CHAR(34) +  ' Ok=' + CHAR(34) + ISNULL(CONVERT(varchar,@Ok),'') + CHAR(34) + ' OkRef=' + CHAR(34) + ISNULL(@OkRef,'') + CHAR(34) + '/></Intelisis>'
END

