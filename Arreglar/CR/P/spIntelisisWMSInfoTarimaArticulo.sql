SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spIntelisisWMSInfoTarimaArticulo
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
@Posicion                  varchar(20),
@Tarima                    varchar(20),
@Articulo                  varchar(20),
@SubCuenta                 varchar(50)
DECLARE @Tabla Table(
Articulo                   varchar(20),
ArticuloDescripcion        varchar(100),
SubCuenta                  varchar(50),
Tipo                       varchar(20),
UnidadVenta                varchar(50),
UnidadCompra               varchar(50),
UnidadTraspaso             varchar(50),
Factor                     float,
Tarima                     varchar(20),
EstatusControlCalidad      varchar(50),
TarimaEstatus              varchar(15)
)
BEGIN TRY
SELECT @Empresa = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Empresa'
SELECT @Sucursal = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Sucursal'
SELECT @Posicion = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Posicion'
SELECT @Tarima = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Tarima'
SELECT @Articulo = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Articulo'
SELECT @SubCuenta = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'SubCuenta'
SET @Empresa   = LTRIM(RTRIM(ISNULL(@Empresa,'')))
SET @Sucursal  = CAST(ISNULL(@Sucursal,'0') AS int)
SET @Posicion  = LTRIM(RTRIM(ISNULL(@Posicion,'')))
SET @Tarima    = LTRIM(RTRIM(ISNULL(@Tarima,'')))
SET @Articulo  = LTRIM(RTRIM(ISNULL(@Articulo,'')))
SET @SubCuenta = LTRIM(RTRIM(ISNULL(@SubCuenta,'')))
IF NOT EXISTS (SELECT TOP 1 Tarima FROM Tarima WHERE Tarima = @Tarima)
BEGIN
SET @Ok = 1
SET @OkRef = 'La tarima ' + @Tarima + ' no existe.'
END
IF ISNULL(@ok,0) = 0 AND NOT EXISTS (SELECT TOP 1 Articulo FROM Art WHERE Articulo = @Articulo)
BEGIN
SET @Ok = 1
SET @OkRef = 'El artículo ' + @Articulo + ' no existe.'
END
IF ISNULL(@ok,0) = 0
BEGIN
INSERT INTO @Tabla(Articulo, ArticuloDescripcion, SubCuenta, Tipo, UnidadVenta, UnidadCompra, UnidadTraspaso, Tarima)
SELECT Articulo, Descripcion1, @SubCuenta, Tipo, Unidad, UnidadCompra, ISNULL(UnidadTraspaso,'pza'), @Tarima
FROM Art
WHERE Articulo = @Articulo
UPDATE @Tabla
SET Factor = b.Factor
FROM @Tabla a
JOIN ArtUnidad b ON (a.Articulo = b.Articulo AND a.UnidadTraspaso = b.Unidad)
UPDATE @Tabla
SET TarimaEstatus = b.Estatus,
EstatusControlCalidad = b.EstatusControlCalidad
FROM @Tabla a
JOIN Tarima b ON (a.Tarima = b.Tarima)
END
SELECT @Texto = (SELECT LTRIM(RTRIM(ISNULL(Articulo,'')))              AS Articulo,
LTRIM(RTRIM(ISNULL(ArticuloDescripcion,'')))   AS ArticuloDescripcion,
LTRIM(RTRIM(ISNULL(SubCuenta,'')))             AS SubCuenta,
LTRIM(RTRIM(ISNULL(Tipo,'')))                  AS Tipo,
LTRIM(RTRIM(ISNULL(UnidadVenta,'')))           AS UnidadVenta,
LTRIM(RTRIM(ISNULL(UnidadCompra,'')))          AS UnidadCompra,
LTRIM(RTRIM(ISNULL(UnidadTraspaso,'')))        AS UnidadTraspaso,
CAST(ISNULL(Factor,0) AS varchar)              AS Factor,
LTRIM(RTRIM(ISNULL(EstatusControlCalidad,''))) AS EstatusControlCalidad,
LTRIM(RTRIM(ISNULL(TarimaEstatus,'')))         AS TarimaEstatus
FROM @Tabla AS TMA
FOR XML AUTO)
END TRY
BEGIN CATCH
SET @Ok = 1
SELECT @OkRef = LTRIM(RTRIM(LEFT(ERROR_MESSAGE(),255)))
END CATCH
SELECT @ReferenciaIS = Referencia FROM IntelisisService WHERE ID = @ID
SET @Resultado = '<?xml version="1.0" encoding="windows-1252"?><Intelisis Sistema="Intelisis" Contenido="Resultado" Referencia=' + CHAR(34) + ISNULL(@ReferenciaIS,'') + CHAR(34) + ' SubReferencia=' + CHAR(34) + ISNULL(@SubReferencia,'') + CHAR(34) + ' Version=' + CHAR(34) + ISNULL(CONVERT(varchar ,@Version),'') + CHAR(34) + '><Resultado IntelisisServiceID=' + CHAR(34) + ISNULL(CONVERT(varchar,@ID),'')  + CHAR(34)  + ' Ok=' + CHAR(34) + ISNULL(CONVERT(varchar,@Ok),'') + CHAR(34) + ' OkRef=' + CHAR(34) + ISNULL(@OkRef,'') + CHAR(34) + '>' + ISNULL(CONVERT(varchar(max),@Texto),'') + '</Resultado></Intelisis>'
SET @Resultado = REPLACE(@Resultado,'<BR>','.')
END

