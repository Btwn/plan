SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spIntelisisWMSArticuloCBLista
@ID                 int,
@iSolicitud         int,
@Version            float,
@Resultado          varchar(max) = NULL OUTPUT,
@Ok                 int = NULL OUTPUT,
@OkRef              varchar(255) = NULL OUTPUT

AS BEGIN
DECLARE
@Texto              xml,
@ReferenciaIS       varchar(100),
@SubReferencia      varchar(100),
@Articulo           varchar(20)
SELECT @Articulo = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Articulo'
DECLARE @Tabla Table(
Codigo              varchar(30),
Unidad              varchar(50),
Factor              varchar(255)
)
INSERT INTO @Tabla(Codigo, Unidad, Factor)
SELECT ISNULL(c.Codigo,''),
ISNULL(c.Unidad,''),
CAST(ISNULL(a.Factor,0) AS varchar(255))
FROM CB c
JOIN ArtUnidad a ON (c.Cuenta = a.Articulo AND c.Unidad = a.Unidad)
WHERE c.TipoCuenta = 'Articulos'
AND c.Cuenta = @Articulo
SELECT @Texto = (SELECT * FROM @Tabla AS TMA FOR XML AUTO)
IF @Texto IS NULL SELECT @Ok = 20560
SELECT @ReferenciaIS = Referencia
FROM IntelisisService
WHERE ID = @ID
IF @Ok IS NOT NULL
BEGIN
SELECT @OkRef = LTRIM(RTRIM(ISNULL(Descripcion,''))) FROM MensajeLista WHERE Mensaje = @Ok
SET @OkRef = @OkRef + ' ' + @Articulo
SET @OkRef = LTRIM(RTRIM(@OkRef))
END
SET @Resultado = '<?xml version="1.0" encoding="windows-1252"?><Intelisis Sistema="Intelisis" Contenido="Resultado" Referencia=' + CHAR(34) + ISNULL(@ReferenciaIS,'') + CHAR(34) + ' SubReferencia=' + CHAR(34) + ISNULL(@SubReferencia,'') + CHAR(34) + ' Version=' + CHAR(34) + ISNULL(CONVERT(varchar ,@Version),'') + CHAR(34) + '><Resultado IntelisisServiceID=' + CHAR(34) + ISNULL(CONVERT(varchar,@ID),'') + CHAR(34) + ' Ok=' + CHAR(34) + ISNULL(CONVERT(varchar,@Ok),'') + CHAR(34) + ' OkRef=' + CHAR(34) + ISNULL(@OkRef,'') + CHAR(34) + '>' + CONVERT(varchar(max), ISNULL(@Texto,'')) + '</Resultado></Intelisis>'
END

