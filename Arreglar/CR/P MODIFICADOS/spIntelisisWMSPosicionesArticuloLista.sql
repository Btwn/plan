SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spIntelisisWMSPosicionesArticuloLista
@ID                        int,
@iSolicitud                int,
@Version                   float,
@Resultado                 varchar(max) = NULL OUTPUT,
@Ok                        int = NULL OUTPUT,
@OkRef                     varchar(255) = NULL OUTPUT

AS BEGIN
DECLARE
@Texto                     xml,
@ReferenciaIS              varchar(100),
@SubReferencia             varchar(100),
@Empresa                   varchar(5),
@Sucursal                  varchar(10),
@Almacen                   varchar(10),
@Tipo                      varchar(20),
@Tarima                    varchar(20),
@Articulo                  varchar(20),
@TMAID                     int,
@ValidarCapacidad          bit
DECLARE @Tabla Table(
Almacen                    varchar(10),
Posicion                   varchar(10),
Tipo                       varchar(20),
Descripcion                varchar(100),
Pasillo                    int,
Fila                       int,
Nivel                      int,
Zona                       varchar(50),
Capacidad                  int,
Estatus                    varchar(15),
ArticuloEsp                varchar(20),
Alto                       float,
Largo                      float,
Ancho                      float,
Volumen                    float,
PesoMaximo                 float,
Orden                      int,
TipoRotacion               varchar(10),
Subtipo                    varchar(20)
)
BEGIN TRY
SELECT @Empresa = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Empresa'
SELECT @Sucursal = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Sucursal'
SELECT @Almacen = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Almacen'
SELECT @Tipo = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Tipo'
SELECT @Tarima = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Tarima'
SELECT @Articulo = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Articulo'
SET @Empresa  = LTRIM(RTRIM(ISNULL(@Empresa,'')))
SET @Sucursal = LTRIM(RTRIM(ISNULL(@Sucursal,'')))
SET @Almacen  = LTRIM(RTRIM(ISNULL(@Almacen,'')))
SET @Tipo     = LTRIM(RTRIM(ISNULL(@Tipo,'')))
SET @Tarima   = LTRIM(RTRIM(ISNULL(@Tarima,'')))
SET @Articulo = LTRIM(RTRIM(ISNULL(@Articulo,'')))
SET @TMAID = NULL
SET @ValidarCapacidad = 1
INSERT INTO @Tabla(Almacen, Posicion, Tipo, Descripcion, Pasillo, Fila, Nivel, Zona, Capacidad, Estatus, ArticuloEsp, Alto, Largo, Ancho, Volumen, PesoMaximo, Orden, TipoRotacion, Subtipo)
SELECT Almacen, Posicion, Tipo, Descripcion, Pasillo, Fila, Nivel, Zona, Capacidad, Estatus, ArticuloEsp, Alto, Largo, Ancho, Volumen, PesoMaximo, Orden, TipoRotacion, Subtipo
FROM dbo.fnWMSPosicionDestinoLista(@Almacen, @Articulo, @Tipo, @Empresa, @Tarima, @TMAID, @ValidarCapacidad)
SELECT @Texto = (SELECT LTRIM(RTRIM(ISNULL(Almacen,'')))      AS Almacen,
LTRIM(RTRIM(ISNULL(Posicion,'')))     AS Posicion,
LTRIM(RTRIM(ISNULL(Tipo,'')))         AS Tipo,
LTRIM(RTRIM(ISNULL(Descripcion,'')))  AS Descripcion,
CAST(ISNULL(Pasillo,0) AS varchar)    AS Pasillo,
CAST(ISNULL(Fila,0) AS varchar)       AS Fila,
CAST(ISNULL(Nivel,0) AS varchar)      AS Nivel,
LTRIM(RTRIM(ISNULL(Zona,'')))         AS Zona,
CAST(ISNULL(Capacidad,0) AS varchar)  AS Capacidad,
LTRIM(RTRIM(ISNULL(Estatus,'')))      AS Estatus,
LTRIM(RTRIM(ISNULL(ArticuloEsp,'')))  AS ArticuloEsp,
CAST(ISNULL(Alto,0) AS varchar)       AS Alto,
CAST(ISNULL(Largo,0) AS varchar)      AS Largo,
CAST(ISNULL(Ancho,0) AS varchar)      AS Ancho,
CAST(ISNULL(Volumen,0) AS varchar)    AS Volumen,
CAST(ISNULL(PesoMaximo,0) AS varchar) AS PesoMaximo,
CAST(ISNULL(Orden,0) AS varchar)      AS Orden,
LTRIM(RTRIM(ISNULL(TipoRotacion,''))) AS TipoRotacion,
LTRIM(RTRIM(ISNULL(Subtipo,'')))      AS Subtipo
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

