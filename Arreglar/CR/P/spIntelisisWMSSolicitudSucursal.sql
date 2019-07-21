SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spIntelisisWMSSolicitudSucursal
@ID				int,
@iSolicitud		int,
@Version		float,
@Resultado		varchar(max) = NULL OUTPUT,
@Ok				int = NULL OUTPUT,
@OkRef			varchar(255) = NULL OUTPUT

AS BEGIN
DECLARE
@Texto				xml,
@ReferenciaIS		varchar(100),
@SubReferencia		varchar(100),
@Usuario			varchar(20),
@UsuarioSucursal    bit
DECLARE @Sucursal TABLE(Sucursal    int,
Nombre      varchar(100))
SELECT  @Usuario = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Usuario'
SELECT @UsuarioSucursal = AccesarOtrasSucursalesEnLinea FROM Usuario WHERE Usuario = @Usuario
IF @UsuarioSucursal = 1
BEGIN
INSERT @Sucursal(Sucursal,Nombre)
SELECT Sucursal, Nombre
FROM Sucursal
WHERE Estatus = 'ALTA'
END
IF  @UsuarioSucursal = 0
BEGIN
IF NOT EXISTS(SELECT Sucursal FROM UsuarioSucursalAcceso WHERE Usuario=@Usuario)
INSERT @Sucursal(Sucursal,Nombre)
SELECT Sucursal, Nombre
FROM Sucursal
WHERE Sucursal IN (SELECT Sucursal FROM Usuario WHERE Usuario=@Usuario) 
AND Estatus = 'ALTA'
ELSE
INSERT @Sucursal(Sucursal,Nombre)
SELECT Sucursal, Nombre
FROM Sucursal
WHERE Sucursal IN (SELECT Sucursal FROM UsuarioSucursalAcceso WHERE Usuario=@Usuario) 
AND Estatus = 'ALTA'
END
IF EXISTS(SELECT * FROM @Sucursal)
BEGIN
SELECT @Texto =(SELECT Sucursal, Nombre
FROM @Sucursal
FOR XML AUTO)
END
IF NOT EXISTS(SELECT * FROM @Sucursal)
BEGIN
SELECT @Texto =(SELECT TOP 1 0 AS Sucursal,'' AS Nombre
FROM Sucursal
FOR XML AUTO)
SELECT @Ok = 10200, @OkRef = 'El Usuario no Cuenta con Sucursales Definidas'
END
IF @@ERROR <> 0 SET @Ok = 1
BEGIN
SELECT @ReferenciaIS = Referencia
FROM IntelisisService
WHERE ID = @ID
IF @@ERROR <> 0 SET @Ok = 1
SELECT @Resultado = '<?xml version="1.0" encoding="windows-1252"?><Intelisis Sistema="Intelisis" Contenido="Resultado" Referencia=' + CHAR(34) + ISNULL(@ReferenciaIS,'') + CHAR(34) + ' SubReferencia=' + CHAR(34) + ISNULL(@SubReferencia,'') + CHAR(34) + ' Version=' + CHAR(34) + ISNULL(CONVERT(varchar ,@Version),'') + CHAR(34) + '><Resultado IntelisisServiceID=' + CHAR(34) + ISNULL(CONVERT(varchar,@ID),'')  + CHAR(34)  + ' Ok=' + CHAR(34) + ISNULL(CONVERT(varchar,@Ok),'') + CHAR(34) + ' OkRef=' + CHAR(34) + ISNULL(@OkRef,'') + CHAR(34) + '>' + CONVERT(varchar(max),@Texto) + '</Resultado></Intelisis>'
IF @@ERROR <> 0 SET @Ok = 1
END
END

