SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spIntelisisDistribucionSucursal
@ID              int,
@iSolicitud      int,
@Version         float,
@Resultado       varchar(max) = NULL OUTPUT,
@Ok              int = NULL OUTPUT,
@OkRef           varchar(255) = NULL OUTPUT

AS BEGIN
DECLARE
@Texto              xml,
@ReferenciaIS       varchar(100),
@SubReferencia      varchar(100),
@Usuario            varchar(20),
@UsuarioSucursal    bit
DECLARE @Tabla        table(
Sucursal            int,
Nombre              varchar(100)
)
BEGIN TRY
SELECT @Usuario = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Usuario'
SET @Usuario = ISNULL(@Usuario,'')
SELECT @UsuarioSucursal = AccesarOtrasSucursalesEnLinea FROM Usuario WHERE Usuario = @Usuario
IF @UsuarioSucursal = 1
BEGIN
INSERT @Tabla (Sucursal, Nombre)
SELECT Sucursal, Nombre
FROM Sucursal WITH(NOLOCK)
WHERE  Estatus = 'ALTA'
END
ELSE
BEGIN
IF NOT EXISTS(SELECT Sucursal FROM UsuarioSucursalAcceso WITH(NOLOCK) WHERE Usuario = @Usuario)
BEGIN
INSERT @Tabla(Sucursal,Nombre)
SELECT Sucursal, Nombre
FROM Sucursal WITH(NOLOCK)
WHERE  Sucursal IN (SELECT Sucursal FROM Usuario WITH(NOLOCK) WHERE Usuario = @Usuario)
AND Estatus = 'ALTA'
END
ELSE
BEGIN
INSERT @Tabla(Sucursal, Nombre)
SELECT Sucursal, Nombre
FROM Sucursal WITH(NOLOCK)
WHERE  Sucursal IN (SELECT Sucursal FROM UsuarioSucursalAcceso WITH(NOLOCK) WHERE Usuario = @Usuario)
AND Estatus = 'ALTA'
END
END
If (SELECT COUNT(Sucursal) FROM @Tabla) > 0
BEGIN
SELECT @Texto = (SELECT LTRIM(RTRIM(ISNULL(Sucursal,''))) AS Sucursal,
LTRIM(RTRIM(ISNULL(Nombre,'')))   AS Nombre
FROM @Tabla AS Tabla
FOR XML AUTO)
END
ELSE
BEGIN
SET @Texto = ''
SET @OK = 72071
END
IF NOT ISNULL(@Ok, 0) = 0 SELECT @OkRef = Descripcion FROM MensajeLista WITH(NOLOCK) WHERE Mensaje = @Ok
END TRY
BEGIN CATCH
SET @Ok = 1
SELECT @OkRef = LTRIM(RTRIM(LEFT(ERROR_MESSAGE(),255)))
END CATCH
SELECT @ReferenciaIS = Referencia, @SubReferencia = SubReferencia FROM IntelisisService WITH(NOLOCK) WHERE ID = @ID
SET @Resultado = '<?xml version="1.0" encoding="windows-1252"?><Intelisis Sistema="Intelisis" Contenido="Resultado" Referencia=' + CHAR(34) + ISNULL(@ReferenciaIS,'') + CHAR(34) + ' SubReferencia=' + CHAR(34) + ISNULL(@SubReferencia,'') + CHAR(34) + ' Version=' + CHAR(34) + ISNULL(CONVERT(varchar ,@Version),'') + CHAR(34) + '><Resultado IntelisisServiceID=' + CHAR(34) + ISNULL(CONVERT(varchar,@ID),'')  + CHAR(34)  + ' Ok=' + CHAR(34) + ISNULL(CONVERT(varchar,@Ok),'') + CHAR(34) + ' OkRef=' + CHAR(34) + ISNULL(@OkRef,'') + CHAR(34) + '>' + ISNULL(CONVERT(varchar(max),@Texto),'') + '</Resultado></Intelisis>'
SET @Resultado = REPLACE(@Resultado,'<BR>','.')
END

