SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spIntelisisArticuloEspPosicion
@ID                           int,
@iSolicitud                   int,
@Version                      float,
@Resultado                    varchar(max) = NULL OUTPUT,
@Ok                           int = NULL OUTPUT,
@OkRef                        varchar(255) = NULL OUTPUT

AS BEGIN
DECLARE
@Texto                        xml,
@ReferenciaIS                 varchar(100),
@SubReferencia                varchar(100),
@Mov                          varchar(20),
@MovID                        varchar(20),
@Empresa                      varchar(5),
@Almacen                      varchar(10),
@Sucursal                     int,
@Sucursal2                    varchar(100),
@Tarima                       varchar(20),
@Posicion                     varchar(10),
@ArticuloEsp                  varchar(20),
@ArtTipo                      varchar(20),
@Descripcion1                 varchar(100),
@UnidadCompra                 varchar(50),
@Cantidad                     float,
@Tipo                         varchar(20),
@Disponible                   float,
@DescripcionPosicion          varchar(100),
@PosicionDestino              varchar(10),
@DescripcionPosicionDestino   varchar(100),
@Completo                     int,
@Codigo                       varchar(50),
@Descripcion                  varchar(100),
@Zona                         varchar(50),
@Pasillo                      varchar(50),
@Fila                         varchar(50),
@Nivel                        varchar(50),
@Movimiento                   varchar(20),
@IdTma                        int,
@ArtCambioClave               varchar(20)
DECLARE @Tabla Table(
Folio                         varchar(20),
Tarima                        varchar(20),
Posicion                      varchar(10),
Tipo                          varchar(20),
ArticuloEsp                   varchar(20),
ArtCambioClave                varchar(20),
ArtTipo                       varchar(20),
Descripcion1                  varchar(100),
UnidadCompra                  varchar(50),
DescripcionPosicion           varchar(100),
PosicionDestino               varchar(10),
DescripcionPosicionDestino    varchar(100),
Zona                          varchar(50),
Pasillo                       varchar(50),
Fila                          varchar(50),
Nivel                         varchar(50)
)
SELECT @Empresa = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Empresa'
SELECT @Sucursal2 = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Sucursal'
SELECT @Almacen = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Almacen'
SELECT @Movimiento = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Movimiento'
SELECT @MovID = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'MovID'
SELECT @Tarima = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Tarima'
SELECT @Posicion = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Posicion'
SET @Empresa    = LTRIM(RTRIM(ISNULL(@Empresa,'')))
SET @Sucursal2  = LTRIM(RTRIM(ISNULL(@Sucursal2,'')))
SET @Almacen    = LTRIM(RTRIM(ISNULL(@Almacen,'')))
SET @Movimiento = LTRIM(RTRIM(ISNULL(@Movimiento,'')))
SET @MovID      = LTRIM(RTRIM(ISNULL(@MovID,'')))
SET @Tarima     = LTRIM(RTRIM(ISNULL(@Tarima,'')))
SET @Posicion   = LTRIM(RTRIM(ISNULL(@Posicion,'')))
SET @Mov = @Movimiento
IF @Ok IS NULL
IF NOT EXISTS(SELECT ISNULL(Posicion,'') FROM AlmPos WHERE Posicion = @Posicion) SET @Ok = 13030
IF @Ok IS NULL
IF NOT EXISTS(SELECT ISNULL(ArticuloEsp,'') FROM AlmPos WHERE Posicion = @Posicion) SET @Ok = 13075
IF @Ok IS NULL
BEGIN
SELECT TOP 1 @Sucursal = Sucursal FROM Sucursal WHERE Nombre = @Sucursal2
SELECT @IdTma = ID
FROM TMA
WHERE Empresa = @Empresa
AND Sucursal = @Sucursal
AND Almacen = @Almacen
AND Mov = @Mov
AND MovID = @MovID
SELECT @PosicionDestino = PosicionDestino
FROM TMAD WHERE ID = @IdTma
AND Almacen = @Almacen
AND Posicion = @Posicion
AND Tarima = @Tarima
SELECT @Tipo = ap.Tipo,
@DescripcionPosicion = ISNULL(ap.Descripcion,''),
@ArticuloEsp = ap.ArticuloEsp,
@ArtTipo = ar.Tipo,
@Descripcion1 = ar.Descripcion1,
@UnidadCompra = ar.UnidadCompra,
@Zona = ISNULL(ap.Zona,''),
@Pasillo = CAST(ISNULL(ap.Pasillo,0) AS Varchar(50)),
@Fila = CAST(ISNULL(ap.Fila,0) AS Varchar(50)),
@Nivel = CAST(ISNULL(ap.Nivel,0) AS Varchar(50))
FROM AlmPos ap
JOIN Art ar ON ar.Articulo = ap.ArticuloEsp
WHERE ap.Posicion = @Posicion
SELECT @DescripcionPosicionDestino = Descripcion
FROM AlmPos
WHERE Almacen = @Almacen
AND Posicion = @PosicionDestino
SELECT @ArtCambioClave = LTRIM(RTRIM(ISNULL(ArtCambioClave,'')))
FROM TMAD WHERE ID = @IdTma
AND Almacen = @Almacen
AND Posicion = @Posicion
AND Tarima = @Tarima
AND Articulo = @ArticuloEsp
INSERT @Tabla(
Folio,Tarima,Posicion,Tipo,ArticuloEsp,
ArtCambioClave,Descripcion1,UnidadCompra,DescripcionPosicion,PosicionDestino,
ArtTipo,DescripcionPosicionDestino,Zona,Pasillo,Fila,
Nivel)
SELECT @MovID,@Tarima,@Posicion,@Tipo,@ArticuloEsp,
@ArtCambioClave,@Descripcion1,@UnidadCompra,@DescripcionPosicion,@PosicionDestino,
@ArtTipo,@DescripcionPosicionDestino,@Zona,@Pasillo,@Fila,
@Nivel
SELECT @Texto = (SELECT ISNULL(Folio,'')                      AS Folio,
ISNULL(Tarima,'')                     AS Tarima,
ISNULL(Posicion,'')                   AS Posicion,
ISNULL(Tipo,'')                       AS Tipo,
ISNULL(ArticuloEsp,'')                AS ArticuloEsp,
ISNULL(ArtCambioClave,'')             AS ArtCambioClave,
ISNULL(ArtTipo,'')                    AS ArtTipo,
ISNULL(Descripcion1,'')               AS Descripcion1,
ISNULL(UnidadCompra,'')               AS UnidadCompra,
ISNULL(DescripcionPosicion,'')        AS DescripcionPosicion,
ISNULL(PosicionDestino,'')            AS PosicionDestino,
ISNULL(DescripcionPosicionDestino,'') AS DescripcionPosicionDestino,
ISNULL(Zona,'')                       AS Zona,
ISNULL(Pasillo,'')                    AS Pasillo,
ISNULL(Fila,'')                       AS Fila,
ISNULL(Nivel,'')                      AS Nivel
FROM @Tabla AS TMA
FOR XML AUTO)
IF @Texto IS NULL SET @Ok = 14055
END
SELECT @ReferenciaIS = Referencia FROM IntelisisService WHERE ID = @ID
IF @Ok IS NOT NULL SELECT @Descripcion = Descripcion FROM MensajeLista WHERE Mensaje = @Ok
SET @Resultado = '<?xml version="1.0" encoding="windows-1252"?><Intelisis Sistema="Intelisis" Contenido="Resultado" Referencia=' + CHAR(34) + ISNULL(@ReferenciaIS,'') + CHAR(34) + ' SubReferencia=' + CHAR(34) + ISNULL(@SubReferencia,'') + CHAR(34) + ' Version=' + CHAR(34) + ISNULL(CONVERT(varchar ,@Version),'') + CHAR(34) + '><Resultado IntelisisServiceID=' + CHAR(34) + ISNULL(CONVERT(varchar,@ID),'')  + CHAR(34)  + ' Ok=' + CHAR(34) + ISNULL(CONVERT(varchar,@Ok),'') + CHAR(34) + ' OkRef=' + CHAR(34) + ISNULL(@OkRef,'') + CHAR(34) + ' Descripcion="' + ISNULL(@Descripcion,'') +'">' + CONVERT(varchar(max),ISNULL(@Texto,'')) + '</Resultado></Intelisis>'
SET @Resultado = REPLACE(@Resultado,'<BR>','.')
END

