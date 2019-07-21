SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spIntelisisDistribucionCbInfo
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
@CodigoBarras            varchar(30)
SELECT @CodigoBarras = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'CodigoBarras'
SET @CodigoBarras = LTRIM(RTRIM(ISNULL(@CodigoBarras,'')))
DECLARE @Tabla   table(
Articulo                 varchar(20),
SubCuenta                varchar(50),
Descripcion              varchar(100),
Descripcion2             varchar(255),
NombreCorto              varchar(20),
Tipo                     varchar(20),
Unidad                   varchar(50),
Factor                   float
)
INSERT INTO @Tabla (Articulo, SubCuenta, Unidad, Factor)
SELECT Cuenta, SubCuenta, Unidad, Cantidad
FROM CB
WHERE Codigo = @CodigoBarras
UPDATE @Tabla
SET Descripcion = ISNULL(b.Descripcion1, ''),
Descripcion2 = ISNULL(b.Descripcion2, ''),
NombreCorto = ISNULL(b.NombreCorto, ''),
Tipo = ISNULL(b.Tipo, '')
FROM @Tabla a
INNER JOIN Art b ON (a.Articulo = b.Articulo)
SELECT @Texto = (SELECT LTRIM(RTRIM(ISNULL(Articulo,'')))     AS Articulo,
LTRIM(RTRIM(ISNULL(SubCuenta,'')))    AS SubCuenta,
LTRIM(RTRIM(ISNULL(Descripcion,'')))  AS Descripcion,
LTRIM(RTRIM(ISNULL(Descripcion2,''))) AS Descripcion2,
LTRIM(RTRIM(ISNULL(NombreCorto,'')))  AS NombreCorto,
LTRIM(RTRIM(ISNULL(Tipo,'')))         AS Tipo,
LTRIM(RTRIM(ISNULL(Unidad,'')))       AS Unidad,
CAST(ISNULL(Factor,1) AS varchar)     AS Factor
FROM @Tabla AS Tabla
FOR XML AUTO)
SELECT @ReferenciaIS = Referencia
FROM IntelisisService
WHERE ID = @ID
IF @Ok IS NOT NULL
SELECT @OkRef = Descripcion FROM MensajeLista WHERE Mensaje = @Ok
SET @Resultado = '<?xml version="1.0" encoding="windows-1252"?><Intelisis Sistema="Intelisis" Contenido="Resultado" Referencia=' + CHAR(34) + ISNULL(@ReferenciaIS,'') + CHAR(34) + ' SubReferencia=' + CHAR(34) + ISNULL(@SubReferencia,'') + CHAR(34) + ' Version=' + CHAR(34) + ISNULL(CONVERT(varchar ,@Version),'') + CHAR(34) + '><Resultado IntelisisServiceID=' + CHAR(34) + ISNULL(CONVERT(varchar,@ID),'')  + CHAR(34)  + ' Ok=' + CHAR(34) + ISNULL(CONVERT(varchar,@Ok),'') + CHAR(34) + ' OkRef=' + CHAR(34) + ISNULL(@OkRef,'') + CHAR(34) + '>' + ISNULL(CONVERT(varchar(max),@Texto),'') + '</Resultado></Intelisis>'
SET @Resultado = REPLACE(@Resultado,'<BR>','.')
END

