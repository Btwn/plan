SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spIntelisisWMSValidarZona
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
@Empresa                 varchar(5),
@Almacen                 varchar(10),
@Articulo                varchar(20),
@ZonaPosicion            varchar(30),
@ZonaArticulo            varchar(30),
@PosicionDestino         varchar(10),
@ZonaValida              bit,
@i                       int,
@k                       int
DECLARE @TablaArtZona Table(
idx                      int IDENTITY(1,1),
Zona                     varchar(30),
Articulo                 varchar(20),
Orden                    int
)
DECLARE @Tabla Table(
ZonaValida               bit
)
BEGIN TRY
SELECT @Empresa = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Empresa'
SELECT @Almacen = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Almacen'
SELECT @Articulo = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Articulo'
SELECT @PosicionDestino = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'PosicionDestino'
INSERT INTO @TablaArtZona (Zona,Articulo,Orden)
SELECT LTRIM(RTRIM(ISNULL(Zona,''))),
LTRIM(RTRIM(ISNULL(Articulo,''))),
Orden
FROM ArtZona
WHERE Articulo = @Articulo
ORDER BY Orden
DELETE @TablaArtZona WHERE Zona = ''
SELECT @ZonaPosicion = LTRIM(RTRIM(ISNULL(Zona,'')))
FROM AlmPos
WHERE Almacen = @Almacen
AND Posicion = @PosicionDestino
SELECT @k = MAX(idx) FROM @TablaArtZona
SET @k = ISNULL(@k,0)
IF LTRIM(RTRIM(ISNULL(@ZonaPosicion,''))) = '' OR @k = 0
BEGIN
SET @ZonaValida = 1
END
ELSE
BEGIN
SET @ZonaValida = 0
SET @i = 1
WHILE @i <= @k AND @ZonaValida = 0
BEGIN
SELECT @ZonaArticulo = Zona FROM @TablaArtZona WHERE idx = @i
IF @ZonaPosicion = @ZonaArticulo SET @ZonaValida = 1
SET @i = @i + 1
END
END
INSERT INTO @Tabla (ZonaValida) VALUES (@ZonaValida)
SELECT @Texto = (SELECT CAST(ZonaValida AS varchar) AS ZonaValida
FROM @Tabla AS TMA
FOR XML AUTO)
IF @Ok IS NOT NULL SELECT @OkRef = Descripcion FROM MensajeLista WHERE Mensaje = @Ok
END TRY
BEGIN CATCH
SET @Ok = 1
SELECT @OkRef = LTRIM(RTRIM(LEFT(ERROR_MESSAGE(),255)))
END CATCH
SELECT @ReferenciaIS = Referencia FROM IntelisisService WHERE ID = @ID
SET @Resultado = '<?xml version="1.0" encoding="windows-1252"?><Intelisis Sistema="Intelisis" Contenido="Resultado" Referencia=' + CHAR(34) + ISNULL(@ReferenciaIS,'') + CHAR(34) + ' SubReferencia=' + CHAR(34) + ISNULL(@SubReferencia,'') + CHAR(34) + ' Version=' + CHAR(34) + ISNULL(CONVERT(varchar ,@Version),'') + CHAR(34) + '><Resultado IntelisisServiceID=' + CHAR(34) + ISNULL(CONVERT(varchar,@ID),'')  + CHAR(34)  + ' Ok=' + CHAR(34) + ISNULL(CONVERT(varchar,@Ok),'') + CHAR(34) + ' OkRef=' + CHAR(34) + ISNULL(@OkRef,'') + CHAR(34) + '>' + ISNULL(CONVERT(varchar(max),@Texto),'') + '</Resultado></Intelisis>'
END

