SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spIntelisisWMSOSURTarimasPckListado
@ID                           int,
@iSolicitud                   int,
@Version                      float,
@Resultado                    varchar(max) = NULL OUTPUT,
@Ok                           int = NULL OUTPUT,
@OkRef                        varchar(255) = NULL OUTPUT

AS BEGIN
DECLARE
@ReferenciaIS                 varchar(100),
@SubReferencia                varchar(100),
@Texto                        xml,
@Empresa                      varchar(5),
@Sucursal                     int,
@SucursalNombre               varchar(100),
@Usuario                      varchar(20),
@Agente                       varchar(10),
@Mov                          varchar(20)
DECLARE @Tabla table(
IdTma                         int,
Renglon                       float,
Tarima                        varchar(20),
MovID                         varchar(20),
Cantidad                      float,
Posicion                      varchar(10),
PosicionDescripcion           varchar(100),
PosicionDestino               varchar(10),
PosicionDestinoDescripcion    varchar(100),
Articulo                      varchar(20),
SubCuenta                     varchar(50),
ArtCambioClave                varchar(20),
Descripcion1                  varchar(100),
ArtTipo                       varchar(20),
OrigenTipo                    varchar(10),
Origen                        varchar(20),
OrigenID                      varchar(20),
IdVenta                       int,
Cliente                       varchar(10),
ClienteNombre                 varchar(100),
Almacen                       varchar(10),
Unidad                        varchar(50)
)
BEGIN TRY
SELECT @Empresa = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Empresa'
SELECT @SucursalNombre = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'SucursalNombre'
SELECT @Usuario = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Usuario'
SELECT @Mov = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Mov'
SET @Empresa        = LTRIM(RTRIM(ISNULL(@Empresa,'')))
SET @SucursalNombre = LTRIM(RTRIM(ISNULL(@SucursalNombre,'')))
SET @Usuario        = LTRIM(RTRIM(ISNULL(@Usuario,'')))
SET @Mov            = LTRIM(RTRIM(ISNULL(@Mov,'')))
SELECT @Sucursal = Sucursal
FROM Sucursal
WITH(NOLOCK) WHERE Nombre = @SucursalNombre
SELECT @Agente = LTRIM(RTRIM(DefAgente))
FROM Usuario
WITH(NOLOCK) WHERE Usuario = @Usuario
IF ISNULL(@Agente,'') = '' SELECT @Ok = 20930
INSERT INTO @Tabla (
IdTma, Renglon, Tarima, MovID, Cantidad,
Posicion, PosicionDestino, Articulo, SubCuenta, ArtCambioClave,
Unidad, OrigenTipo, Origen, OrigenID, Almacen
)
SELECT t.ID, d.Renglon, d.Tarima, t.MovID, d.CantidadPendiente,
d.Posicion, d.PosicionDestino, d.Articulo, d.Subcuenta, d.ArtCambioClave,
d.Unidad, t.OrigenTipo, t.Origen, t.OrigenID, d.Almacen
FROM TMA t
 WITH(NOLOCK) JOIN TMAD d  WITH(NOLOCK) ON (t.id = d.ID)
WHERE t.Empresa = @Empresa
AND t.Sucursal = @Sucursal
AND t.Estatus = 'PENDIENTE'
AND t.Mov = @Mov
AND d.Montacarga = @Agente
AND d.procesado = 0
UPDATE @Tabla
SET Idventa = b.ID,
Cliente = b.Cliente
FROM @Tabla a
JOIN Venta b  WITH(NOLOCK) ON (a.Origen = b.Mov AND a.OrigenID = b.MovID)
WHERE a.OrigenTipo = 'VTAS'
UPDATE @Tabla
SET Idventa = b.ID,
Cliente = b.AlmacenDestino
FROM @Tabla a
JOIN Inv b  WITH(NOLOCK) ON (a.Origen = b.Mov AND a.OrigenID = b.MovID)
WHERE a.OrigenTipo = 'INV'
UPDATE @Tabla
SET ClienteNombre = b.Nombre
FROM @Tabla a
JOIN Cte b  WITH(NOLOCK) ON (a.Cliente = b.Cliente)
WHERE a.OrigenTipo = 'VTAS'
UPDATE @Tabla
SET ClienteNombre = b.Nombre
FROM @Tabla a
JOIN ALm b  WITH(NOLOCK) ON (a.Cliente = b.Almacen)
WHERE a.OrigenTipo = 'INV'
UPDATE @Tabla
SET Descripcion1 = b.Descripcion1,
ArtTipo = b.Tipo
FROM @Tabla a
JOIN Art b  WITH(NOLOCK) ON (a.Articulo = b.Articulo)
UPDATE @Tabla
SET PosicionDescripcion = b.Descripcion
FROM @Tabla a
JOIN AlmPos b  WITH(NOLOCK) ON (a.Almacen = b.Almacen AND a.Posicion = b.Posicion)
UPDATE @Tabla
SET PosicionDestinoDescripcion = b.Descripcion
FROM @Tabla a
JOIN AlmPos b  WITH(NOLOCK) ON (a.Almacen = b.Almacen AND a.PosicionDestino = b.Posicion)
SELECT @Texto = (
SELECT CAST(ISNULL(IdTma,0) AS VARCHAR)                    AS IdTma,
CAST(ISNULL(Renglon,0) AS VARCHAR)                  AS Renglon,
LTRIM(RTRIM(ISNULL(Tarima,'')))                     AS Tarima,
LTRIM(RTRIM(ISNULL(MovID,'')))                      AS MovID,
CAST(ISNULL(Cantidad,0) AS VARCHAR)                 AS Cantidad,
LTRIM(RTRIM(ISNULL(Posicion,'')))                   AS Posicion,
LTRIM(RTRIM(ISNULL(PosicionDescripcion,'')))        AS PosicionDescripcion,
LTRIM(RTRIM(ISNULL(PosicionDestino,'')))            AS PosicionDestino,
LTRIM(RTRIM(ISNULL(PosicionDestinoDescripcion,''))) AS PosicionDestinoDescripcion,
LTRIM(RTRIM(ISNULL(Articulo,'')))                   AS Articulo,
LTRIM(RTRIM(ISNULL(SubCuenta,'')))                  AS SubCuenta,
LTRIM(RTRIM(ISNULL(ArtCambioClave,'')))             AS ArtCambioClave,
LTRIM(RTRIM(ISNULL(Descripcion1,'')))               AS Descripcion1,
LTRIM(RTRIM(ISNULL(ArtTipo,'')))                    AS ArtTipo,
LTRIM(RTRIM(ISNULL(Origen,'')))                     AS Origen,
LTRIM(RTRIM(ISNULL(OrigenID,'')))                   AS OrigenID,
CAST(ISNULL(IdVenta,0) AS VARCHAR)                  AS IdVenta,
LTRIM(RTRIM(ISNULL(Cliente,'')))                    AS Cliente,
LTRIM(RTRIM(ISNULL(ClienteNombre,'')))              AS ClienteNombre,
LTRIM(RTRIM(ISNULL(Almacen,'')))                    AS Almacen,
LTRIM(RTRIM(ISNULL(Unidad,'')))                     AS Unidad
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

