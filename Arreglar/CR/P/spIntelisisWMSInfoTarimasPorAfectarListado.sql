SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spIntelisisWMSInfoTarimasPorAfectarListado
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
@Empresa                      char(5),
@Mov                          varchar(20),
@MovID                        varchar(20),
@IdTma                        int,
@Renglon                      float,
@Tarima                       varchar(20),
@Posicion                     varchar(10),
@LeerPosicionOrigen           bit,
@CfgMultiUnidades             bit,
@CfgMultiUnidadesNivel        char(20),
@ArticuloEsp                  varchar(20),
@Unidad_Art                   varchar(20),
@Factor                       float,
@Alm_Art                      char(20),
@CantidadU                    float,
@ValidarZona                  bit,
@Cantidad                     float
DECLARE @Tabla Table(
IdTma                         int,
Renglon                       float,
Tarima                        varchar(20),
Articulo                      varchar(20),
Cantidad                      float,
Descripcion1                  varchar(100),
Almacen                       varchar(10),
Posicion                      varchar(10),
DescripcionPosicion           varchar(100),
PosicionDestino               varchar(10),
DescripcionPosicionDestino    varchar(100),
Mov                           varchar(20),
Folio                         varchar(20),
LeerPosicionOrigen            bit,
Unidad                        varchar(50),
CantidadUnidad                float,
ValidarZona                   bit
)
BEGIN TRY
SELECT @Empresa = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Empresa'
SELECT @Mov = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Mov'
SELECT @MovID = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'MovID'
SELECT @Tarima = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Tarima'
SELECT @Posicion = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Posicion'
SELECT @IdTma = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'IdTma'
SELECT @Renglon = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Renglon'
SET @Empresa    = LTRIM(RTRIM(ISNULL(@Empresa,'')))
SET @Mov        = LTRIM(RTRIM(ISNULL(@Mov,'')))
SET @MovID      = LTRIM(RTRIM(ISNULL(@MovID,'')))
SET @Tarima     = LTRIM(RTRIM(ISNULL(@Tarima,'')))
SET @Posicion   = LTRIM(RTRIM(ISNULL(@Posicion,'')))
SET @IdTma      = CAST(ISNULL(@IdTma,0) AS int)
SET @Renglon    = CAST(ISNULL(@Renglon,0) AS float)
SELECT @LeerPosicionOrigen = ISNULL(WMSLeerPosicionOrigen,1),
@ValidarZona = ISNULL(WMSValidarZona,1)
FROM EmpresaCfg
WHERE Empresa = @Empresa
INSERT @Tabla(IdTma, Renglon, Tarima, Almacen, Articulo, Cantidad, Posicion, PosicionDestino, Mov, Folio, LeerPosicionOrigen, Unidad, CantidadUnidad, ValidarZona)
SELECT @IdTma, @Renglon, Tarima, Almacen, Articulo,
CASE WHEN ISNULL(CantidadPendiente, 0 ) > 0 THEN CantidadPendiente ELSE CantidadPicking END,
Posicion, PosicionDestino, @Mov, @MovID, @LeerPosicionOrigen,
Unidad, CantidadUnidad, @ValidarZona
FROM TMAD
WHERE ID = @IdTma
AND Renglon = @Renglon
SELECT TOP 1 @Cantidad = Cantidad FROM @Tabla
IF ISNULL(@Cantidad,0) = 0
BEGIN
SELECT @Cantidad = ISNULL(Disponible,0) - ISNULL(Apartado,0)
FROM ArtDisponibleTarima
WHERE Tarima = @Tarima
UPDATE @Tabla SET Cantidad = @Cantidad
END
UPDATE @Tabla
SET DescripcionPosicion = b.Descripcion
FROM @Tabla a
JOIN AlmPos b ON (a.Almacen = b.Almacen AND a.Posicion = b.Posicion)
UPDATE @Tabla
SET DescripcionPosicionDestino = b.Descripcion
FROM @Tabla a
JOIN AlmPos b ON (a.Almacen = b.Almacen AND a.PosicionDestino = b.Posicion)
UPDATE @Tabla
SET Descripcion1 = b.Descripcion1
FROM @Tabla a
JOIN Art b ON (a.Articulo = b.Articulo)
SELECT @Texto = (SELECT ISNULL(Tarima,'')                             AS Tarima,
ISNULL(Articulo,'')                           AS Articulo,
CAST(ISNULL(Cantidad,0) AS varchar)           AS Cantidad,
ISNULL(Descripcion1,'')                       AS Descripcion1,
ISNULL(Almacen,'')                            AS Almacen,
ISNULL(Posicion,'')                           AS Posicion,
ISNULL(DescripcionPosicion,'')                AS DescripcionPosicion,
ISNULL(PosicionDestino,'')                    AS PosicionDestino,
ISNULL(DescripcionPosicionDestino,'')         AS DescripcionPosicionDestino,
ISNULL(Mov,'')                                AS Mov,
ISNULL(Folio,'')                              AS Folio,
CAST(ISNULL(LeerPosicionOrigen,0) AS varchar) AS LeerPosicionOrigen,
ISNULL(Unidad,'')                             AS Unidad,
CAST(ISNULL(CantidadUnidad,0) AS varchar)     AS CantidadUnidad,
CAST(ISNULL(ValidarZona,0) AS varchar)        AS ValidarZona
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
SET @Resultado = REPLACE(@Resultado,'<BR>','.')
END

