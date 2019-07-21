SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spIntelisisTMAAfectarMovTMA_OPCKTARIMA
@ID                        int,
@iSolicitud                int,
@Version                   float,
@Resultado                 varchar(max) = NULL OUTPUT,
@Ok                        int = NULL OUTPUT,
@OkRef                     varchar(255) = NULL OUTPUT

AS BEGIN
DECLARE
@IDGenerar               int,
@IDAcceso                int,
@MovTipo                 varchar(20),
@ReferenciaIS            varchar(100),
@Estacion                int,
@SubReferencia           varchar(100),
@Empresa                 varchar(5),
@Mov                     varchar(20),
@MovID                   varchar(20),
@Mov2                    varchar(20),
@Mov3                    varchar(20),
@MovID2                  varchar(20),
@Sucursal                int,
@ID2                     int,
@Tarima                  varchar(20),
@Sucursal2               varchar(100),
@Posicion                varchar(20),
@PosicionDestino         varchar(20),
@Usuario                 varchar(15),
@Cantidad                float(20),
@Estatus                 varchar(20),
@Articulo                varchar(20),
@SubClave                varchar(20),
@Procesado               bit,
@Montacargas             varchar(20),
@Agente                  varchar(20),
@CB                      varchar(30),
@SubCuenta               varchar(50),
@Unidad                  varchar(20),
@UnidadCompra            varchar(20),
@Factor                  float ,
@Almacen                 varchar(20),
@Disponible              float,
@PosicionDGenerar        varchar(20),
@DescripcionPosicionD    varchar(20),
@TarimaGenerar           varchar(20)
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
SELECT @Articulo = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Articulo'
SELECT @SubCuenta = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'SubCuenta'
SELECT @Cantidad = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Cantidad'
SELECT @Unidad = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Unidad'
SELECT @Montacargas = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Montacargas'
END
SELECT @MovTipo = Clave
FROM MovTipo
WITH(NOLOCK) WHERE Modulo = 'TMA'
AND Mov = @Mov
IF @MovTipo <> 'TMA.OPCKTARIMA'
SELECT @Ok = 35005, @OkRef = @Mov
SELECT @Factor = dbo.fnArtUnidadFactor(@Empresa, @Articulo, @Unidad)
SET @Cantidad = @Cantidad * @Factor
IF @Ok IS NULL
IF NOT EXISTS(SELECT *
FROM TMAD d
 WITH(NOLOCK) JOIN TMA t  WITH(NOLOCK) ON (t.ID = d.ID )
JOIN MovTipo m  WITH(NOLOCK) ON (m.Mov = t.Mov AND m.Modulo = 'TMA' AND t.MovID = @MovID)
JOIN ArtDisponibleTarima a  WITH(NOLOCK) ON (a.Tarima = d.Tarima AND a.Almacen = d.Almacen AND a.Empresa = t.Empresa)
WHERE a.Articulo = @Articulo
AND m.Clave = @MovTipo
AND a.Tarima = @Tarima)
SET @Ok = 13070
IF @Ok IS NULL
IF NOT EXISTS(SELECT *
FROM TMAD d
 WITH(NOLOCK) JOIN TMA t  WITH(NOLOCK) ON (t.ID = d.ID)
JOIN MovTipo m  WITH(NOLOCK) ON (m.Mov = t.Mov AND m.Modulo = 'TMA' AND t.MovID = @MovID)
JOIN ArtDisponibleTarima a  WITH(NOLOCK) ON (a.Tarima = d.Tarima AND a.Almacen = d.Almacen AND a.Empresa = t.Empresa)
WHERE a.Articulo = @Articulo
AND m.Clave = @MovTipo
AND a.Tarima = @Tarima)
SET @Ok = 13070
IF @Ok IS NULL
IF NOT EXISTS(SELECT *
FROM TMAD d
 WITH(NOLOCK) JOIN TMA t  WITH(NOLOCK) ON (t.ID = d.ID)
JOIN MovTipo m  WITH(NOLOCK) ON (m.Mov = t.Mov AND m.Modulo = 'TMA' AND t.MovID = @MovID)
JOIN ArtDisponibleTarima a  WITH(NOLOCK) ON (a.Tarima = d.Tarima AND a.Almacen = d.Almacen AND a.Empresa = t.Empresa)
WHERE a.Articulo = @Articulo
AND m.Clave = @MovTipo
AND a.Tarima = @Tarima
AND a.Disponible >= @Cantidad)
SET @Ok = 20020
SELECT @Agente = DefAgente,
@Almacen = DefAlmacen
FROM Usuario
WITH(NOLOCK) WHERE Usuario = @Usuario
IF @Agente IS NULL
SELECT @Ok = 20930
IF @Ok = 20020
SELECT @Disponible = ISNULL(b.Disponible,0)/ISNULL(@Factor,1)
FROM Tarima a WITH(NOLOCK)
INNER JOIN ArtDisponibleTarima b  WITH(NOLOCK) ON (a.Tarima = b.Tarima)
WHERE a.Almacen = @Almacen
AND a.Estatus = 'ALTA'
AND a.Tarima = @Tarima
AND b.Articulo = @Articulo
AND b.Empresa = @Empresa
IF @Ok IS NULL AND @Cantidad < 1
SET @OK = 20015
IF @Ok IS NULL
BEGIN
SELECT @ID2 = ID,
@Estatus = Estatus
FROM TMA
WITH(NOLOCK) WHERE Empresa = @Empresa
AND Mov = @Mov
AND MovID = @MovID
SELECT @Procesado = ISNULL(Procesado,0)
FROM TMAD
WITH(NOLOCK) WHERE ID = @ID2
AND Tarima = @Tarima
IF @Procesado = 0
UPDATE TMAD
 WITH(ROWLOCK) SET CantidadA = @Cantidad
WHERE ID = @ID2
AND Tarima = @Tarima
IF @Ok IS NULL AND @Estatus = 'PENDIENTE' AND @MovTipo = 'TMA.OPCKTARIMA'
BEGIN
SELECT @Mov3 = TMAPCKTarimaTransito
FROM EmpresaCfgMovWMS
WITH(NOLOCK) WHERE Empresa = @Empresa
EXEC @IDGenerar = spAfectar 'TMA', @ID2, 'GENERAR', 'Seleccion', @Mov3, @Usuario, @Estacion, @EnSilencio = 1, @Conexion = 1, @Ok = @Ok OUTPUT, @OkRef = @OkRef OUTPUT
UPDATE TMA
 WITH(ROWLOCK) SET Montacarga = @Montacargas,
Agente = @Agente
WHERE ID = @IDGenerar
IF @Ok BETWEEN 80030 AND 81000
SELECT @Ok = NULL, @OkRef = NULL
EXEC spAfectar 'TMA', @IDGenerar, 'AFECTAR', 'Todo', NULL, @Usuario, @Estacion, @EnSilencio = 1, @Conexion = 1, @Ok = @Ok OUTPUT, @OkRef = @OkRef OUTPUT
IF @Ok BETWEEN 80030 AND 81000
SELECT @Ok = NULL, @OkRef = NULL
END
SELECT @ReferenciaIS = Referencia
FROM IntelisisService
WITH(NOLOCK) WHERE ID = @ID
SELECT @Mov2   = LTRIM(RTRIM(ISNULL(Mov,''))),
@MovID2 = LTRIM(RTRIM(ISNULL(MovID,'')))
FROM TMA
WITH(NOLOCK) WHERE ID = @IDGenerar
SELECT @PosicionDGenerar = PosicionDestino,
@TarimaGenerar = Tarima
FROM TMAD
WITH(NOLOCK) WHERE ID = @IDGenerar
SELECT @DescripcionPosicionD = Descripcion
FROM AlmPos
WITH(NOLOCK) WHERE ALmacen = @Almacen
AND Posicion = @PosicionDGenerar
END
IF @Ok IS NULL
BEGIN
COMMIT TRANSACTION
END ELSE
BEGIN
ROLLBACK TRANSACTION
END
IF @Ok IS NOT NULL
SELECT @OkRef = Descripcion FROM MensajeLista WITH(NOLOCK) WHERE Mensaje = @Ok
IF @Ok = 20020
SELECT @OkRef = @OkRef + '. ' + 'Disponible Actual = '+ CAST(ISNULL(@Disponible,0) AS varchar)
SET @Resultado = '<?xml version="1.0" encoding="windows-1252"?><Intelisis Sistema="Intelisis" Contenido="Resultado" Referencia=' + CHAR(34) + ISNULL(@ReferenciaIS,'') + CHAR(34) + ' SubReferencia=' + CHAR(34) + ISNULL(@SubReferencia,'') + CHAR(34) + ' Version=' + CHAR(34) + ISNULL(CONVERT(varchar ,@Version),'') + CHAR(34) + '><Resultado IntelisisServiceID=' + CHAR(34) + ISNULL(CONVERT(varchar,@ID),'') + CHAR(34) + ' Modulo="TMA" ModuloID =' + CHAR(34) + ISNULL(CONVERT(varchar,@IDGenerar),'') + CHAR(34) +'  Mov=' + CHAR(34) + ISNULL(@Mov2,'') + CHAR(34) + ' MovID=' + CHAR(34) + ISNULL(@MovID2,'') + CHAR(34) + ' PosicionDestino=' + CHAR(34) + ISNULL(@PosicionDGenerar,'') + CHAR(34) + ' DescripcionPosicionDestino=' + CHAR(34) + ISNULL(@DescripcionPosicionD,'') + CHAR(34)  + ' Tarima=' + CHAR(34) + ISNULL(@TarimaGenerar,'') + CHAR(34) + ' Ok=' + CHAR(34) + ISNULL(CONVERT(varchar,@Ok),'') + CHAR(34) + ' OkRef=' + CHAR(34) + ISNULL(@OkRef,'') + CHAR(34) + '/></Intelisis>'
END

