SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spIntelisisWMSTarimasArticuloLista
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
@Usuario                   varchar(20),
@Articulo                  varchar(20),
@Unidad                    varchar(50),
@Tarima                    varchar(20)
DECLARE @Tabla Table(
Tarima                     varchar(20),
Almacen                    varchar(10),
Posicion                   varchar(10),
Articulo                   varchar(20),
SubCuenta                  varchar(50),
Cantidad                   float,
Unidad                     varchar(50),
Tipo                       varchar(20),
Descripcion                varchar(100),
Pasillo                    int,
Fila                       int,
Nivel                      int,
Zona                       varchar(50),
ArticuloEsp                varchar(20),
Existencia                 float,
Disponible                 float,
Apartado                   float,
EstatusControlCalidad      varchar(50)
)
BEGIN TRY
SELECT @Empresa = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Empresa'
SELECT @Sucursal = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Sucursal'
SELECT @Articulo = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Articulo'
SELECT @Tarima = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Tarima'
SET @Empresa  = LTRIM(RTRIM(ISNULL(@Empresa,'')))
SET @Sucursal = LTRIM(RTRIM(ISNULL(@Sucursal,'')))
SET @Articulo = LTRIM(RTRIM(ISNULL(@Articulo,'')))
SET @Tarima   = LTRIM(RTRIM(ISNULL(@Tarima,'')))
SELECT @Usuario = Usuario FROM IntelisisService WHERE ID = @ID
SET @Usuario = LTRIM(RTRIM(ISNULL(@Usuario,'')))
SELECT @Unidad = ISNULL(UnidadCompra, ISNULL(Unidad,'pza')) FROM Art WHERE Articulo = @Articulo
INSERT INTO @Tabla(Tarima, Almacen, Posicion, Articulo, SubCuenta, Unidad, Tipo, Descripcion, Pasillo, Fila, Nivel, Zona, ArticuloEsp, Existencia, Disponible, Apartado, EstatusControlCalidad)
SELECT t.Tarima,
t.Almacen,
t.Posicion,
t.Articulo,
t.SubCuenta,
@Unidad,
a.Tipo,
a.Descripcion,
ISNULL(a.Pasillo,0),
ISNULL(a.Fila,0),
ISNULL(a.Nivel,0),
a.Zona,
a.ArticuloEsp,
ISNULL(d.Disponible,0) + ISNULL(d.Apartado,0),
ISNULL(d.Disponible,0),
ISNULL(d.Apartado,0),
LTRIM(RTRIM(ISNULL(t.EstatusControlCalidad,'')))
FROM Tarima t
LEFT JOIN AlmPos a ON (t.Almacen = a.Almacen AND t.Posicion = a.Posicion)
JOIN ArtDisponibleTarima d ON (t.Tarima = d.Tarima)
JOIN Alm aa ON  (a.Almacen = aa.Almacen)
JOIN Sucursal s ON (aa.Sucursal = s.Sucursal)
WHERE t.Estatus = 'ALTA'
AND s.Sucursal = @Sucursal
AND d.Articulo = @Articulo
AND d.Disponible > 0
DELETE @Tabla WHERE LEN(EstatusControlCalidad) > 0
IF LEN(ISNULL(@Tarima,'')) > 0
BEGIN
DELETE @Tabla WHERE NOT Tarima = @Tarima
UPDATE @Tabla SET Articulo = @Articulo
END
UPDATE @Tabla SET Cantidad = Existencia
SELECT @Texto = (SELECT LTRIM(RTRIM(ISNULL(Tarima,'')))                AS Tarima,
LTRIM(RTRIM(ISNULL(Almacen,'')))               AS Almacen,
LTRIM(RTRIM(ISNULL(Posicion,'')))              AS Posicion,
LTRIM(RTRIM(ISNULL(Articulo,'')))              AS Articulo,
LTRIM(RTRIM(ISNULL(SubCuenta,'')))             AS SubCuenta,
CAST(ISNULL(Cantidad,0) AS varchar)            AS Cantidad,
LTRIM(RTRIM(ISNULL(Unidad,'')))                AS Unidad,
LTRIM(RTRIM(ISNULL(Tipo,'')))                  AS Tipo,
LTRIM(RTRIM(ISNULL(Descripcion,'')))           AS Descripcion,
CAST(ISNULL(Pasillo,0) AS varchar)             AS Pasillo,
CAST(ISNULL(Fila,0) AS varchar)                AS Fila,
CAST(ISNULL(Nivel,0) AS varchar)               AS Nivel,
LTRIM(RTRIM(ISNULL(Zona,'')))                  AS Zona,
LTRIM(RTRIM(ISNULL(ArticuloEsp,'')))           AS ArticuloEsp,
CAST(ISNULL(Existencia,0) AS varchar)          AS Existencia,
CAST(ISNULL(Disponible,0) AS varchar)          AS Disponible,
CAST(ISNULL(Apartado,0) AS varchar)            AS Apartado,
LTRIM(RTRIM(ISNULL(EstatusControlCalidad,''))) AS EstatusControlCalidad
FROM @Tabla AS TMA
ORDER BY Tarima
FOR XML AUTO)
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

