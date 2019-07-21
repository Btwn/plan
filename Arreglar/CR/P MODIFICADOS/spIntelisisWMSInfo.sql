SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spIntelisisWMSInfo
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
@Sucursal                  int,
@sSucursal                 varchar(20),
@Articulo                  varchar(20),
@Posicion                  varchar(20),
@Tarima                    varchar(20)
DECLARE @TablaAlm table(
Almacen                    varchar(10)
)
DECLARE @TablaTarima table(
Tarima                     varchar(20)
)
DECLARE @Tabla Table(
Almacen                    varchar(10),
Articulo                   varchar(20),
ArticuloDescripcion        varchar(100),
SubCuenta                  varchar(50),
Tarima                     varchar(20),
Existencia                 float,
Disponible                 float,
Apartado                   float,
Posicion                   varchar(10),
Descripcion                varchar(100),
Tipo                       varchar(20),
Pasillo                    int,
Fila                       int,
Nivel                      int,
Zona                       varchar(50),
EstatusControlCalidad      varchar(50),
TarimaEstatus              varchar(15),
UnidadVenta                varchar(50),
UnidadCompra               varchar(50),
UnidadTraspaso             varchar(50),
Factor                     float,
ArticuloTipo               varchar(20)
)
BEGIN TRY
SELECT @Empresa = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Empresa'
SELECT @sSucursal = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Sucursal'
SELECT @Articulo = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Articulo'
SELECT @Tarima = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Tarima'
SELECT @Posicion = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Posicion'
SET @Empresa  = LTRIM(RTRIM(ISNULL(@Empresa,'')))
SET @Sucursal = CAST(ISNULL(@sSucursal,'0') AS int)
SET @Articulo = LTRIM(RTRIM(ISNULL(@Articulo,'')))
SET @Tarima   = LTRIM(RTRIM(ISNULL(@Tarima,'')))
SET @Posicion = LTRIM(RTRIM(ISNULL(@Posicion,'')))
IF LEN(@Articulo) > 0
BEGIN
IF NOT EXISTS (SELECT TOP 1 Articulo FROM Art WITH(NOLOCK) WHERE Articulo = @Articulo)
BEGIN
SET @Ok = 1
SET @OkRef = 'El art�culo ' + @Articulo + ' no existe.'
END
END
ELSE IF LEN(@Tarima) > 0
BEGIN
IF NOT EXISTS (SELECT TOP 1 Tarima FROM Tarima WITH(NOLOCK) WHERE Tarima = @Tarima)
BEGIN
SET @Ok = 1
SET @OkRef = 'La tarima ' + @Tarima + ' no existe.'
END
END
ELSE IF LEN(@Posicion) > 0
BEGIN
IF NOT EXISTS (SELECT TOP 1 Posicion FROM AlmPos WITH(NOLOCK) WHERE Posicion = @Posicion)
BEGIN
SET @Ok = 1
SET @OkRef = 'La posici�n ' + @Posicion + ' no existe.'
END
END
ELSE
BEGIN
SET @Ok = 1
SET @OkRef = 'Parametros incorrectos.'
END
IF ISNULL(@Ok,0) = 0
BEGIN
INSERT INTO @TablaAlm (Almacen)
SELECT Almacen
FROM Alm WITH(NOLOCK)
WHERE  Sucursal = @Sucursal
AND WMS = 1
AND Estatus = 'ALTA'
IF LEN(@Articulo) > 0
BEGIN
INSERT INTO @Tabla(ALmacen, Articulo, Tarima, Existencia, Disponible, Apartado, Posicion, Descripcion, Tipo, Pasillo, Fila, Nivel, Zona, EstatusControlCalidad, TarimaEstatus)
SELECT a.Almacen,
@Articulo,
t.Tarima,
ISNULL(adt.Disponible,0) + ISNULL(adt.Apartado,0),
ISNULL(adt.Disponible,0),
ISNULL(adt.Apartado,0),
a.Posicion,
a.Descripcion,
a.Tipo,
ISNULL(a.Pasillo,0),
ISNULL(a.Fila,0),
ISNULL(a.Nivel,0),
a.Zona,
LTRIM(RTRIM(ISNULL(t.EstatusControlCalidad,''))),
t.Estatus
FROM ArtDisponibleTarima adt
LEFT JOIN Tarima t  WITH(NOLOCK) ON (adt.Tarima = t.Tarima)
LEFT JOIN AlmPos a  WITH(NOLOCK) ON (a.Almacen = t.Almacen AND a.Posicion = t.Posicion)
JOIN @TablaAlm al ON (a.Almacen = al.Almacen)
WHERE adt.Empresa = @Empresa
AND adt.Articulo = @Articulo
AND adt.Disponible <> 0
END
ELSE IF LEN(@Tarima) > 0
BEGIN
INSERT INTO @Tabla(Almacen, Articulo, Tarima, Existencia, Disponible, Apartado)
SELECT Almacen, Articulo, Tarima, ISNULL(Disponible,0) + ISNULL(Apartado,0), Disponible, Apartado
FROM ArtDisponibleTarima
WITH(NOLOCK) WHERE Empresa = @Empresa
AND Tarima = @Tarima
UPDATE @Tabla
SET Posicion              = b.Posicion,
EstatusControlCalidad = b.EstatusControlCalidad,
TarimaEstatus         = b.Estatus
FROM @Tabla a
INNER JOIN Tarima b  WITH(NOLOCK) ON (a.Tarima = b.Tarima)
UPDATE @Tabla
SET Descripcion = b.Descripcion,
Tipo        = b.Tipo,
Pasillo     = b.Pasillo,
Fila        = b.Fila,
Nivel       = b.Nivel,
Zona        = b.Zona
FROM @Tabla a
INNER JOIN AlmPos b  WITH(NOLOCK) ON (a.Posicion = b.Posicion)
END
ELSE IF LEN(@Posicion) > 0
BEGIN
INSERT INTO @TablaTarima (Tarima)
SELECT Tarima
FROM Tarima WITH(NOLOCK)
WHERE  Posicion = @Posicion
INSERT INTO @Tabla(Tarima,Almacen,Posicion,TarimaEstatus,Articulo,SubCuenta, Existencia, Disponible, Apartado ,EstatusControlCalidad)
SELECT adt.Tarima, adt.Almacen, @Posicion, t.Estatus, adt.Articulo,t.SubCuenta, ISNULL(adt.Disponible,0) + ISNULL(adt.Apartado,0) , adt.Disponible, adt.Apartado,t.EstatusControlCalidad
FROM ArtDisponibleTarima adt
 WITH(NOLOCK) JOIN @TablaTarima tt ON (adt.Tarima = tt.Tarima)
JOIN Tarima t  WITH(NOLOCK) ON (tt.Tarima = t.Tarima)
UPDATE @Tabla
SET Descripcion = b.Descripcion,
Tipo        = b.Tipo,
Pasillo     = b.Pasillo,
Fila        = b.Fila,
Nivel       = b.Nivel,
Zona        = b.Zona
FROM @Tabla a
INNER JOIN AlmPos b  WITH(NOLOCK) ON (a.Posicion = b.Posicion)
END
UPDATE @Tabla
SET ArticuloDescripcion = ISNULL(b.Descripcion1,''),
UnidadVenta         = ISNULL(b.Unidad,''),
UnidadCompra        = ISNULL(b.UnidadCompra,''),
UnidadTraspaso      = ISNULL(b.UnidadTraspaso,''),
ArticuloTipo        = ISNULL(b.Tipo,'')
FROM @Tabla a
INNER JOIN Art b  WITH(NOLOCK) ON (a.Articulo = b.Articulo)
UPDATE @Tabla
SET Factor = b.Factor
FROM @Tabla a
INNER JOIN ArtUnidad b  WITH(NOLOCK) ON (a.Articulo = b.Articulo AND a.UnidadTraspaso = b.Unidad)
SELECT @Texto = (SELECT DISTINCT
LTRIM(RTRIM(ISNULL(Almacen,'')))               AS Almacen,
LTRIM(RTRIM(ISNULL(Articulo,'')))              AS Articulo,
LTRIM(RTRIM(ISNULL(ArticuloDescripcion,'')))   AS ArticuloDescripcion,
LTRIM(RTRIM(ISNULL(SubCuenta,'')))             AS SubCuenta,
LTRIM(RTRIM(ISNULL(Tarima,'')))                AS Tarima,
CAST(ISNULL(Existencia,0) AS varchar)          AS Existencia,
CAST(ISNULL(Disponible,0) AS varchar)          AS Disponible,
CAST(ISNULL(Apartado,0) AS varchar)            AS Apartado,
LTRIM(RTRIM(ISNULL(Posicion,'')))              AS Posicion,
LTRIM(RTRIM(ISNULL(Descripcion,'')))           AS Descripcion,
LTRIM(RTRIM(ISNULL(Tipo,'')))                  AS Tipo,
CAST(ISNULL(Pasillo,0) AS varchar)             AS Pasillo,
CAST(ISNULL(Fila,0) AS varchar)                AS Fila,
CAST(ISNULL(Nivel,0) AS varchar)               AS Nivel,
LTRIM(RTRIM(ISNULL(Zona,'')))                  AS Zona,
LTRIM(RTRIM(ISNULL(EstatusControlCalidad,''))) AS EstatusControlCalidad,
LTRIM(RTRIM(ISNULL(TarimaEstatus,'')))         AS TarimaEstatus,
LTRIM(RTRIM(ISNULL(UnidadVenta,'')))           AS UnidadVenta,
LTRIM(RTRIM(ISNULL(UnidadCompra,'')))          AS UnidadCompra,
LTRIM(RTRIM(ISNULL(UnidadTraspaso,'')))        AS UnidadTraspaso,
CAST(ISNULL(Factor,0) AS varchar)              AS Factor,
LTRIM(RTRIM(ISNULL(ArticuloTipo,'')))          AS ArticuloTipo
FROM @Tabla AS TMA
ORDER BY Tarima
FOR XML AUTO)
END
END TRY
BEGIN CATCH
SET @Ok = 1
SELECT @OkRef = LTRIM(RTRIM(LEFT(ERROR_MESSAGE(),255)))
END CATCH
SELECT @ReferenciaIS = Referencia FROM IntelisisService WITH(NOLOCK) WHERE ID = @ID
SET @Resultado = '<?xml version="1.0" encoding="windows-1252"?><Intelisis Sistema="Intelisis" Contenido="Resultado" Referencia=' + CHAR(34) + ISNULL(@ReferenciaIS,'') + CHAR(34) + ' SubReferencia=' + CHAR(34) + ISNULL(@SubReferencia,'') + CHAR(34) + ' Version=' + CHAR(34) + ISNULL(CONVERT(varchar ,@Version),'') + CHAR(34) + '><Resultado IntelisisServiceID=' + CHAR(34) + ISNULL(CONVERT(varchar,@ID),'')  + CHAR(34)  + ' Ok=' + CHAR(34) + ISNULL(CONVERT(varchar,@Ok),'') + CHAR(34) + ' OkRef=' + CHAR(34) + ISNULL(@OkRef,'') + CHAR(34) + '>' + ISNULL(CONVERT(varchar(max),@Texto),'') + '</Resultado></Intelisis>'
SET @Resultado = REPLACE(@Resultado,'<BR>','.')
END

