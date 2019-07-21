SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spIntelisisTarimasPorAfectarListado
@ID                      int,
@iSolicitud              int,
@Version                 float,
@Resultado               varchar(max) = NULL OUTPUT,
@Ok                      int = NULL OUTPUT,
@OkRef                   varchar(255) = NULL OUTPUT

AS BEGIN
DECLARE
@Texto                   xml,
@ReferenciaIS            varchar(100),
@SubReferencia           varchar(100),
@Usuario                 varchar(20),
@Mov                     varchar(20),
@Clave                   varchar(20),
@Agente                  varchar(10),
@RequiereMontacarga      int,
@SucursalNumero          int,
@SucursalTmp             varchar(20)
DECLARE @Tabla table(
ID                       int,
Mov                      varchar(20),
MovID                    varchar(20),
Renglon                  float,
Almacen                  varchar(10),
Tarima                   varchar(20),
Articulo                 varchar(20),
SubCuenta                varchar(50),
ArtCambioClave           varchar(20),
Descripcion1             varchar(100),
Cantidad                 float,
Unidad                   varchar(50),
Posicion                 varchar(10),
PosicionDestino          varchar(10)
)
BEGIN TRY
SELECT @Usuario = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Usuario'
SELECT @Mov = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Mov'
SELECT @Agente = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Agente'
SELECT @SucursalTmp = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'SucursalNumero'
SET @Usuario     = LTRIM(RTRIM(ISNULL(@Usuario,'')))
SET @Mov         = LTRIM(RTRIM(ISNULL(@Mov,'')))
SET @Agente      = LTRIM(RTRIM(ISNULL(@Agente,'')))
SET @SucursalTmp = LTRIM(RTRIM(ISNULL(@SucursalTmp,'')))
IF ISNUMERIC(@SucursalTmp) = 1
SET @SucursalNumero = CAST(@SucursalTmp AS int)
ELSE
SET @SucursalNumero = NULL
SELECT @Agente = DefAgente FROM Usuario WITH(NOLOCK) WHERE Usuario = @Usuario
IF NOT EXISTS(SELECT * FROM Agente WITH(NOLOCK) WHERE Agente = @Agente) SELECT @Ok = 26090, @OkRef = @Agente
SELECT @RequiereMontacarga = ISNULL(RequiereMontacarga,0) FROM MapeoMovMovil WITH(NOLOCK) WHERE Modulo = 'TMA' AND Mov = @Mov
INSERT INTO @Tabla(ID, Mov, MovID, Renglon, Almacen, Tarima, Posicion, PosicionDestino, Articulo, Subcuenta, ArtCambioClave, Cantidad, Unidad)
SELECT t.ID, t.Mov, t.MovID, d.Renglon, d.Almacen, d.Tarima, d.Posicion, d.PosicionDestino, d.Articulo, d.SubCuenta, d.ArtCambioClave, d.CantidadPendiente, d.Unidad
FROM TMAD d  WITH(NOLOCK) JOIN TMA t  WITH(NOLOCK) ON (t.ID = d.ID)
JOIN MovTipo m  WITH(NOLOCK) ON (m.Mov = t.Mov AND m.Modulo = 'TMA')
JOIN ArtDisponibleTarima a  WITH(NOLOCK) ON (d.Tarima = a.Tarima AND a.Empresa = t.Empresa AND a.Almacen = d.Almacen)
WHERE t.Estatus = 'PENDIENTE'
AND m.Clave IN ('TMA.SADO','TMA.SRADO','TMA.ORADO','TMA.OADO')
AND (d.CantidadA IS NULL OR d.CantidadA = 0)
AND (d.Procesado IS NULL OR d.Procesado = 0)
AND t.Mov = @Mov
AND (a.Articulo IS NOT NULL AND a.Articulo <> '')
AND (d.PosicionDestino IS NOT NULL AND d.PosicionDestino <> '')
AND d.Montacarga = CASE WHEN @RequiereMontacarga = 1 THEN @Agente ELSE d.Montacarga END
AND t.Sucursal = @SucursalNumero
GROUP BY t.ID, t.Mov, t.MovID, d.Renglon, d.Almacen, d.Tarima, d.Posicion, d.PosicionDestino, d.Articulo, d.SubCuenta, d.ArtCambioClave, d.CantidadPendiente, d.Unidad
UPDATE @Tabla
SET Descripcion1 = b.Descripcion1
FROM @Tabla a
JOIN Art b  WITH(NOLOCK) ON (a.Articulo = b.Articulo)
SELECT @Texto = (SELECT CAST(ISNULL(ID,0) AS VARCHAR)         AS ID,
ISNULL(Mov,'')                        AS Mov,
ISNULL(MovID,'')                      AS MovID,
CAST(ISNULL(Renglon,0) AS VARCHAR)    AS Renglon,
ISNULL(Almacen,'')                    AS Almacen,
ISNULL(Tarima,'')                     AS Tarima,
ISNULL(Articulo,'')                   AS Articulo,
ISNULL(SubCuenta,'')                  AS SubCuenta,
ISNULL(ArtCambioClave,'')             AS ArtCambioClave,
LTRIM(RTRIM(ISNULL(Descripcion1,''))) AS Descripcion1,
CAST(ISNULL(Cantidad,0) AS VARCHAR)   AS Cantidad,
ISNULL(Unidad,'')                     AS Unidad,
ISNULL(Posicion,'')                   AS Posicion,
ISNULL(PosicionDestino,'')            AS PosicionDestino
FROM @Tabla AS TMA
FOR XML AUTO)
IF @Ok IS NOT NULL SELECT @OkRef = Descripcion FROM MensajeLista WITH(NOLOCK) WHERE Mensaje = @Ok
END TRY
BEGIN CATCH
SET @Ok = 1
SELECT @OkRef = LTRIM(RTRIM(LEFT(ERROR_MESSAGE(),255)))
END CATCH
SELECT @ReferenciaIS = Referencia FROM IntelisisService WITH(NOLOCK) WHERE ID = @ID
SET @Resultado = '<?xml version="1.0" encoding="windows-1252"?><Intelisis Sistema="Intelisis" Contenido="Resultado" Referencia=' + CHAR(34) + ISNULL(@ReferenciaIS,'') + CHAR(34) + ' SubReferencia=' + CHAR(34) + ISNULL(@SubReferencia,'') + CHAR(34) + ' Version=' + CHAR(34) + ISNULL(CONVERT(varchar ,@Version),'') + CHAR(34) + '><Resultado IntelisisServiceID=' + CHAR(34) + ISNULL(CONVERT(varchar,@ID),'')  + CHAR(34)  + ' Ok=' + CHAR(34) + ISNULL(CONVERT(varchar,@Ok),'') + CHAR(34) + ' OkRef=' + CHAR(34) + ISNULL(@OkRef,'') + CHAR(34) + '>' + ISNULL(CONVERT(varchar(max),@Texto),'') + '</Resultado></Intelisis>'
SET @Resultado = REPLACE(@Resultado,'<BR>','.')
END

