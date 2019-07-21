SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spIntelisisWMSTarimasLista
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
@Almacen                   varchar(10),
@Mov                       varchar(20),
@MovID                     varchar(20),
@Articulo                  varchar(20),
@Usuario                   varchar(20),
@Tipo                      varchar(20),
@Posicion                  varchar(20),
@IdTma                     int
DECLARE @Tabla Table(
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
EstatusControlCalidad      varchar(50)
)
BEGIN TRY
SELECT @Empresa = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Empresa'
SELECT @Almacen = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Almacen'
SELECT @Mov = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Mov'
SELECT @MovID = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'MovID'
SELECT @Articulo = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Articulo'
SET @Empresa  = LTRIM(RTRIM(ISNULL(@Empresa,'')))
SET @Almacen  = LTRIM(RTRIM(ISNULL(@Almacen,'')))
SET @Mov      = LTRIM(RTRIM(ISNULL(@Mov,'')))
SET @MovID    = LTRIM(RTRIM(ISNULL(@MovID,'')))
SET @Articulo = LTRIM(RTRIM(ISNULL(@Articulo,'')))
SELECT @Usuario = Usuario FROM IntelisisService WHERE ID = @ID
SET @Usuario = LTRIM(RTRIM(ISNULL(@Usuario,'')))
IF LTRIM(RTRIM(ISNULL(@Almacen,''))) = ''
SELECT @Almacen = LTRIM(RTRIM(ISNULL(DefAlmacen,''))) From Usuario WHERE Usuario = @Usuario
SET @Almacen  = LTRIM(RTRIM(ISNULL(@Almacen,'')))
SELECT @IdTma = ID FROM TMA WHERE Mov = @Mov AND MovID = @MovID
SELECT @Posicion = Posicion FROM TMAD WHERE ID = @IdTma
SELECT @Tipo = Tipo FROM AlmPos WHERE Posicion = @Posicion
INSERT INTO @Tabla(Tarima, Existencia, Disponible, Apartado, Posicion, Descripcion, Tipo, Pasillo, Fila, Nivel, Zona, EstatusControlCalidad)
SELECT t.Tarima,
ISNULL(d.Disponible,0) + ISNULL(d.Apartado,0),
ISNULL(d.Disponible,0),
ISNULL(d.Apartado,0),
a.Posicion,
a.Descripcion,
a.Tipo,
ISNULL(a.Pasillo,0),
ISNULL(a.Fila,0),
ISNULL(a.Nivel,0),
a.Zona,
LTRIM(RTRIM(ISNULL(t.EstatusControlCalidad,'')))
FROM Tarima t
JOIN AlmPos a ON (t.Posicion = a.Posicion)
JOIN ArtDisponibleTarima d ON (t.Tarima = d.Tarima)
WHERE d.Empresa = @Empresa
AND d.Almacen = @Almacen
AND t.Estatus = 'ALTA'
AND a.Tipo = @Tipo
AND t.Articulo = @Articulo
DELETE @Tabla WHERE LEN(EstatusControlCalidad) > 0
SELECT @Texto = (SELECT DISTINCT
LTRIM(RTRIM(ISNULL(Tarima,'')))              AS Tarima,
CAST(ISNULL(Existencia,0) AS varchar)        AS Existencia,
CAST(ISNULL(Disponible,0) AS varchar)        AS Disponible,
CAST(ISNULL(Apartado,0) AS varchar)          AS Apartado,
LTRIM(RTRIM(ISNULL(Posicion,'')))            AS Posicion,
LTRIM(RTRIM(ISNULL(Descripcion,'')))         AS Descripcion,
LTRIM(RTRIM(ISNULL(Tipo,'')))                AS Tipo,
CAST(ISNULL(Pasillo,0) AS varchar)           AS Pasillo,
CAST(ISNULL(Fila,0) AS varchar)              AS Fila,
CAST(ISNULL(Nivel,0) AS varchar)             AS Nivel,
LTRIM(RTRIM(ISNULL(Zona,'')))                AS Zona
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

