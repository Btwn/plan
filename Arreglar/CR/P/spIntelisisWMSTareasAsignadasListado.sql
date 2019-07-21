SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spIntelisisWMSTareasAsignadasListado
@ID                   int,
@iSolicitud           int,
@Version              float,
@Resultado            varchar(max) = NULL OUTPUT,
@Ok                   int = NULL OUTPUT,
@OkRef                varchar(255) = NULL OUTPUT

AS BEGIN
DECLARE
@Texto                xml,
@ReferenciaIS         varchar(100),
@SubReferencia        varchar(100) ,
@Agente               varchar(20),
@IDAcceso             int,
@Estacion             int,
@ModuloID             int
DECLARE @TablaTmp table(
ModuloID              int,
Mov                   varchar(20),
MovID                 varchar(20),
RenglonID             float,
Tarima                varchar(20),
Prioridad             varchar(10),
Clave                 varchar(20),
Posicion              varchar(10),
OrdenPosicion         int,
PosicionDestino       varchar(10),
TarimaCompleta        varchar(10),
Orden                 varchar(10),
Cantidad              float,
CantidadPendiente     float,
Articulo              varchar(20),
CambioClave           varchar(20),
Unidad                varchar(50),
Almacen               varchar(20),
OrigenTipo            varchar(10),
Origen                varchar(20),
OrigenID              varchar(20)
)
DECLARE @Tabla table(
IDR                   int identity(1,1),
ModuloID              int,
Mov                   varchar(20),
MovID                 varchar(20),
RenglonID             float,
Tarima                varchar(20),
Prioridad             varchar(10),
Clave                 varchar(20),
Posicion              varchar(10),
OrdenPosicion         int,
PosicionDestino       varchar(10),
TarimaCompleta        varchar(10),
Orden                 varchar(10),
Cantidad              float,
CantidadPendiente     float,
Articulo              varchar(20),
CambioClave           varchar(20),
Unidad                varchar(50),
Almacen               varchar(20),
OrigenTipo            varchar(10),
Origen                varchar(20),
OrigenID              varchar(20)
)
BEGIN TRY
SELECT @Agente = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Agente'
SET    @Agente   = LTRIM(RTRIM(ISNULL(@Agente,'')))
SELECT @Agente   = DefAgente FROM Usuario WHERE Usuario = @Agente
SET @Estacion = @@SPID
IF NOT EXISTS(SELECT * FROM Agente WHERE Agente = @Agente) SET @Ok = 26090
IF @Ok IS NULL
BEGIN
EXEC spWMSMontacargaTarea @Estacion, 1
INSERT INTO @TablaTmp (
ModuloID, Mov, MovID, RenglonID, Tarima,
Prioridad, Clave, Posicion, PosicionDestino, TarimaCompleta,
Cantidad, CantidadPendiente, Articulo, CambioClave, Unidad,
Almacen, OrigenTipo, Origen, OrigenID
)
SELECT ISNULL(d.ID,0), w.Mov, w.MovID, d.Renglon, d.Tarima,
w.Prioridad, w.Clave, ISNULL(d.Posicion,''), ISNULL(d.PosicionDestino,''), CASE WHEN w.Tarima = 'Picking' THEN '0' ELSE '1' END,
d.CantidadPicking, d.CantidadPendiente, d.Articulo, d.ArtCambioClave, d.Unidad,
w.Almacen, tm.OrigenTipo, tm.Origen, tm.OrigenID
FROM WMSMontacargaTarea w
LEFT JOIN Tarima t ON (w.Tarima = t.Tarima)
JOIN TMAD d ON (w.ID = d.ID AND ISNULL(NULLIF(w.Tarima, 'Picking'), d.Tarima) = d.Tarima)
JOIN TMA tm ON (d.ID = tm.ID)
WHERE w.Montacarga = @Agente
AND w.Estacion = @Estacion
DELETE @TablaTmp WHERE ISNULL(CantidadPendiente,0) = 0 AND Clave NOT IN('TMA.SRADO')
DELETE @TablaTmp WHERE Clave IN('TMA.OPCKTARIMA', 'TMA.PCKTARIMA', 'TMA.PCKTARIMATRAN')
UPDATE @TablaTmp
SET Orden = CASE Prioridad WHEN 'Alta' THEN 1 WHEN 'Media' THEN 2 ELSE 3 END
UPDATE @TablaTmp
SET OrdenPosicion = b.Orden
FROM @TablaTmp a
JOIN AlmPos b
ON (a.Posicion = b.Posicion)
INSERT INTO @Tabla (ModuloID, Mov, MovID, RenglonID, Tarima, Prioridad, Clave, Posicion, OrdenPosicion, PosicionDestino, TarimaCompleta, Orden, Cantidad, CantidadPendiente, Articulo, CambioClave, Unidad, Almacen, OrigenTipo, Origen, OrigenID)
SELECT DISTINCT ModuloID, Mov, MovID, RenglonID, Tarima, Prioridad, Clave, Posicion, OrdenPosicion, PosicionDestino, TarimaCompleta, Orden, Cantidad, CantidadPendiente, Articulo, CambioClave, Unidad, Almacen, OrigenTipo, Origen, OrigenID
FROM @TablaTmp
ORDER BY ModuloID, OrdenPosicion, Tarima
SELECT @Texto = (
SELECT CAST(ISNULL(ModuloID,0) AS VARCHAR)          AS ModuloID,
LTRIM(RTRIM(ISNULL(Mov,'')))                 AS Mov,
LTRIM(RTRIM(ISNULL(MovID,'')))               AS MovID,
CAST(ISNULL(RenglonID,0) AS VARCHAR)         AS RenglonID,
LTRIM(RTRIM(ISNULL(Tarima,'')))              AS Tarima,
LTRIM(RTRIM(ISNULL(Prioridad,'')))           AS Prioridad,
LTRIM(RTRIM(ISNULL(Clave,'')))               AS Clave,
LTRIM(RTRIM(ISNULL(Posicion,'')))            AS Posicion,
CAST(ISNULL(OrdenPosicion,0) AS VARCHAR)     AS OrdenPosicion,
LTRIM(RTRIM(ISNULL(PosicionDestino,'')))     AS PosicionDestino,
LTRIM(RTRIM(ISNULL(TarimaCompleta,'')))      AS TarimaCompleta,
LTRIM(RTRIM(ISNULL(Orden,'')))               AS Orden,
CAST(ISNULL(Cantidad,0) AS VARCHAR)          AS Cantidad,
CAST(ISNULL(CantidadPendiente,0) AS VARCHAR) AS CantidadPendiente,
LTRIM(RTRIM(ISNULL(Articulo,'')))            AS Articulo,
LTRIM(RTRIM(ISNULL(CambioClave,'')))         AS CambioClave,
LTRIM(RTRIM(ISNULL(Unidad,'')))              AS Unidad,
LTRIM(RTRIM(ISNULL(Almacen,'')))             AS Almacen,
LTRIM(RTRIM(ISNULL(OrigenTipo,'')))          AS OrigenTipo,
LTRIM(RTRIM(ISNULL(Origen,'')))              AS Origen,
LTRIM(RTRIM(ISNULL(OrigenID,'')))            AS OrigenID
FROM @Tabla AS TMA
ORDER BY IDR
FOR XML AUTO)
END
IF @Ok IS NOT NULL SELECT @OkRef = Descripcion FROM MensajeLista WHERE Mensaje = @Ok
END TRY
BEGIN CATCH
SET @Ok = 1
SELECT @OkRef = LTRIM(RTRIM(LEFT(ERROR_MESSAGE(),255)))
END CATCH
SELECT @ReferenciaIS = Referencia FROM IntelisisService WHERE ID = @ID
SET @Resultado = '<?xml version="1.0" encoding="windows-1252"?><Intelisis Sistema="Intelisis" Contenido="Resultado" Referencia=' + CHAR(34) + ISNULL(@ReferenciaIS,'') + CHAR(34) + ' SubReferencia=' + CHAR(34) + ISNULL(@SubReferencia,'') + CHAR(34) + ' Version=' + CHAR(34) + ISNULL(CONVERT(varchar ,@Version),'') + CHAR(34) + '><Resultado IntelisisServiceID=' + CHAR(34) + ISNULL(CONVERT(varchar,@ID),'')  + CHAR(34)  + ' Ok=' + CHAR(34) + ISNULL(CONVERT(varchar,@Ok),'') + CHAR(34) + ' OkRef=' + CHAR(34) + ISNULL(@OkRef,'') + CHAR(34) + '>' + ISNULL(CONVERT(varchar(max),@Texto),'') + '</Resultado></Intelisis>'
SET @Resultado = REPLACE(@Resultado,'<BR>','.')
END

