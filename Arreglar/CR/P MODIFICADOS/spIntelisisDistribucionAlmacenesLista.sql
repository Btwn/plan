SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spIntelisisDistribucionAlmacenesLista
@ID              int,
@iSolicitud      int,
@Version         float,
@Resultado       varchar(max) = NULL OUTPUT,
@Ok              int = NULL OUTPUT,
@OkRef           varchar(255) = NULL OUTPUT

AS BEGIN
DECLARE
@Texto         xml,
@ReferenciaIS  varchar(100),
@SubReferencia varchar(100),
@Empresa       varchar(5),
@sSucursal     varchar(10),
@Sucursal      int
DECLARE @Tabla   table(
Almacen        varchar(20),
AlmacenNombre  varchar(100)
)
BEGIN TRY
SELECT @Empresa = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Empresa'
SELECT @sSucursal = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Sucursal'
SET @Empresa   = ISNULL(@Empresa,'')
SET @sSucursal = ISNULL(@sSucursal,'')
IF ISNUMERIC (@sSucursal) = 1
SET @Sucursal = CAST(@sSucursal AS int)
IF ISNULL(@Sucursal,(-1)) >= 0
BEGIN
INSERT INTO @Tabla (Almacen, AlmacenNombre)
SELECT ALmacen, Nombre
FROM Alm WITH(NOLOCK)
WHERE  Sucursal = @Sucursal
AND Estatus = 'ALTA'
AND Tipo = 'Normal'
AND Almacen <> '(TRANSITO)'
END
ELSE
BEGIN
INSERT INTO @Tabla (Almacen, AlmacenNombre)
SELECT ALmacen, Nombre
FROM Alm WITH(NOLOCK)
WHERE  Estatus = 'ALTA'
AND Tipo = 'Normal'
AND Almacen <> '(TRANSITO)'
END
SELECT @Texto = (SELECT LTRIM(RTRIM(ISNULL(Almacen,'')))       AS Almacen,
LTRIM(RTRIM(ISNULL(AlmacenNombre,''))) AS AlmacenNombre
FROM @Tabla AS Tabla
FOR XML AUTO)
IF NOT ISNULL(@Ok, 0) = 0 SELECT @OkRef = Descripcion FROM MensajeLista WITH(NOLOCK) WHERE Mensaje = @Ok
END TRY
BEGIN CATCH
SET @Ok = 1
SELECT @OkRef = LTRIM(RTRIM(LEFT(ERROR_MESSAGE(),255)))
END CATCH
SELECT @ReferenciaIS = Referencia, @SubReferencia = SubReferencia FROM IntelisisService with(nolock) WHERE ID = @ID
SET @Resultado = '<?xml version="1.0" encoding="windows-1252"?><Intelisis Sistema="Intelisis" Contenido="Resultado" Referencia=' + CHAR(34) + ISNULL(@ReferenciaIS,'') + CHAR(34) + ' SubReferencia=' + CHAR(34) + ISNULL(@SubReferencia,'') + CHAR(34) + ' Version=' + CHAR(34) + ISNULL(CONVERT(varchar ,@Version),'') + CHAR(34) + '><Resultado IntelisisServiceID=' + CHAR(34) + ISNULL(CONVERT(varchar,@ID),'')  + CHAR(34)  + ' Ok=' + CHAR(34) + ISNULL(CONVERT(varchar,@Ok),'') + CHAR(34) + ' OkRef=' + CHAR(34) + ISNULL(@OkRef,'') + CHAR(34) + '>' + ISNULL(CONVERT(varchar(max),@Texto),'') + '</Resultado></Intelisis>'
SET @Resultado = REPLACE(@Resultado,'<BR>','.')
END

