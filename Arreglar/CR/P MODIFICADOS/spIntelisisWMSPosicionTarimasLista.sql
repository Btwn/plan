SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spIntelisisWMSPosicionTarimasLista
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
@Usuario                   varchar(20),
@Empresa                   varchar(5),
@Sucursal                  int,
@sSucursal                 varchar(20),
@Almacen                   varchar(10),
@Posicion                  varchar(10),
@Tarima                    varchar(20),
@Articulo                  varchar(20)
DECLARE @Tabla table(
Tarima                     varchar(20),
Existencia                 float,
Disponible                 float,
Apartado                   float
)
BEGIN TRY
SELECT @Empresa = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Empresa'
SELECT @sSucursal = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Sucursal'
SELECT @Almacen = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Almacen'
SELECT @Posicion = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Posicion'
SELECT @Tarima = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Tarima'
SELECT @Articulo = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Articulo'
SET @Empresa   = LTRIM(RTRIM(ISNULL(@Empresa,'')))
SET @sSucursal = LTRIM(RTRIM(ISNULL(@sSucursal,'0')))
SET @Almacen   = LTRIM(RTRIM(ISNULL(@Almacen,'')))
SET @Posicion  = LTRIM(RTRIM(ISNULL(@Posicion,'')))
SET @Articulo  = LTRIM(RTRIM(ISNULL(@Articulo,'')))
IF ISNUMERIC(@sSucursal) = 1
SET @Sucursal = CAST(@sSucursal AS int)
ELSE
SET @Sucursal = 0
SELECT @Usuario = Usuario FROM IntelisisService WITH(NOLOCK) WHERE ID = @ID
SET @Usuario = LTRIM(RTRIM(ISNULL(@Usuario,'')))
IF LTRIM(RTRIM(ISNULL(@Almacen,''))) = ''
BEGIN
SELECT @Almacen = LTRIM(RTRIM(ISNULL(DefAlmacen,'')))
FROM Usuario
WITH(NOLOCK) WHERE Usuario = @Usuario
SET @Almacen = LTRIM(RTRIM(ISNULL(@Almacen,'')))
END
INSERT INTO @Tabla(Tarima, Existencia, Disponible, Apartado)
SELECT t.Tarima,
ISNULL(d.Disponible,0) + ISNULL(d.Apartado,0),
ISNULL(d.Disponible,0),
ISNULL(d.Apartado,0)
FROM Tarima t
 WITH(NOLOCK) JOIN AlmPos a  WITH(NOLOCK) ON (t.Posicion = a.Posicion)
JOIN ArtDisponibleTarima d  WITH(NOLOCK) ON (t.Tarima = d.Tarima)
WHERE d.Empresa  = @Empresa
AND d.Almacen  = @Almacen
AND d.Articulo = @Articulo
AND t.Posicion = @Posicion
AND t.Estatus  = 'ALTA'
AND t.Tarima <> @Tarima
SELECT @Texto = (SELECT LTRIM(RTRIM(ISNULL(Tarima,'')))       AS Tarima,
CAST(ISNULL(Existencia,0) AS varchar) AS Existencia,
CAST(ISNULL(Disponible,0) AS varchar) AS Disponible,
CAST(ISNULL(Apartado,0) AS varchar)   AS Apartado
FROM @Tabla AS TMA
ORDER BY Tarima
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

