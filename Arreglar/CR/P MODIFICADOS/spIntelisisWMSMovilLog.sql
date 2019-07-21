SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spIntelisisWMSMovilLog
@ID                      int,
@iSolicitud              int,
@Version                 float,
@Resultado               varchar(max) = NULL OUTPUT,
@Ok                      int = NULL OUTPUT,
@OkRef                   varchar(255) = NULL OUTPUT

AS BEGIN
DECLARE
@ReferenciaIS            varchar(100),
@SubReferencia           varchar(100),
@Texto                   xml,
@Aplicacion              varchar(50),
@Empresa                 varchar(5),
@Usuario                 varchar(10),
@Modulo                  varchar(5),
@ModuloID                int,
@RenglonID               int,
@Mov                     varchar(20),
@MovID                   varchar(20),
@Articulo                varchar(20),
@Articulo2               varchar(20),
@SubCuenta               varchar(50),
@SubCuenta2              varchar(50),
@Cantidad                float,
@Cantidad2               float,
@CodigoBarras            varchar(30),
@FechaLog                datetime,
@Mensaje                 varchar(255)
BEGIN TRY
SELECT @Aplicacion = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Aplicacion'
SELECT @Empresa = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Empresa'
SELECT @Usuario = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Usuario'
SELECT @Modulo = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Modulo'
SELECT @ModuloID = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'ModuloID'
SELECT @RenglonID = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'RenglonID'
SELECT @Mov = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Mov'
SELECT @MovID = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'MovID'
SELECT @Articulo = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Articulo'
SELECT @Articulo2 = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Articulo2'
SELECT @SubCuenta = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'SubCuenta'
SELECT @SubCuenta2 = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'SubCuenta2'
SELECT @Cantidad = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Cantidad'
SELECT @Cantidad2 = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Cantidad2'
SELECT @CodigoBarras = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'CodigoBarras'
SELECT @Mensaje = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Mensaje'
DECLARE @Tabla Table(
IDR                 int identity(1,1),
Mensaje             varchar(255)
)
SET @Aplicacion        = LTRIM(RTRIM(ISNULL(@Aplicacion,'')))
SET @Empresa           = LTRIM(RTRIM(ISNULL(@Empresa,'')))
SET @Usuario           = LTRIM(RTRIM(ISNULL(@Usuario,'')))
SET @Modulo            = LTRIM(RTRIM(ISNULL(@Modulo,'')))
SET @ModuloID          = CAST(ISNULL(@ModuloID,0) AS int)
SET @RenglonID         = CAST(ISNULL(@RenglonID,0) AS int)
SET @Mov               = LTRIM(RTRIM(ISNULL(@Mov,'')))
SET @MovID             = LTRIM(RTRIM(ISNULL(@MovID,'')))
SET @Articulo          = LTRIM(RTRIM(ISNULL(@Articulo,'')))
SET @Articulo2         = LTRIM(RTRIM(ISNULL(@Articulo2,'')))
SET @Subcuenta         = LTRIM(RTRIM(ISNULL(@Subcuenta,'')))
SET @Subcuenta2        = LTRIM(RTRIM(ISNULL(@Subcuenta2,'')))
SET @Cantidad          = CAST(ISNULL(@Cantidad,'0') AS float)
SET @Cantidad2         = CAST(ISNULL(@Cantidad2,'0') AS float)
SET @CodigoBarras      = LTRIM(RTRIM(ISNULL(@CodigoBarras,'')))
SET @Mensaje           = LTRIM(RTRIM(ISNULL(@Mensaje,'')))
SET @FechaLog          = GETDATE()
INSERT INTO MovilLog (
Aplicacion,Empresa,Usuario,Modulo,
ModuloID,RenglonID,Mov,MovID,Articulo,
Articulo2,Subcuenta,Subcuenta2,Cantidad,Cantidad2,
CodigoBarras,FechaLog,Mensaje)
VALUES (
@Aplicacion,@Empresa,@Usuario,@Modulo,
@ModuloID,@RenglonID,@Mov,@MovID,@Articulo,
@Articulo2,@Subcuenta,@Subcuenta2,@Cantidad,@Cantidad2,
@CodigoBarras,@FechaLog,@Mensaje)
INSERT INTO @Tabla (Mensaje) VALUES (@Mensaje)
SELECT @Texto = (SELECT CAST(ISNULL(IDR,0) AS varchar) AS IDR,
ISNULL(Mensaje,'')             AS Mensaje
FROM @Tabla AS TMA
FOR XML AUTO)
END TRY
BEGIN CATCH
SET @Ok = 1
SELECT @OkRef = LTRIM(RTRIM(LEFT(ERROR_MESSAGE(),255)))
END CATCH
SELECT @ReferenciaIS = Referencia FROM IntelisisService WITH(NOLOCK) WHERE ID = @ID
SET @Resultado = '<?xml version="1.0" encoding="windows-1252"?><Intelisis Sistema="Intelisis" Contenido="Resultado" Referencia=' + CHAR(34) + ISNULL(@ReferenciaIS,'') + CHAR(34) + ' SubReferencia=' + CHAR(34) + ISNULL(@SubReferencia,'') + CHAR(34) + ' Version=' + CHAR(34) + ISNULL(CONVERT(varchar ,@Version),'') + CHAR(34) + '><Resultado IntelisisServiceID=' + CHAR(34) + ISNULL(CONVERT(varchar,@ID),'')  + CHAR(34)  + ' Ok=' + CHAR(34) + ISNULL(CONVERT(varchar,@Ok),'') + CHAR(34) + ' OkRef=' + CHAR(34) + ISNULL(@OkRef,'') + CHAR(34) + '>' + ISNULL(CONVERT(varchar(max),@Texto),'') + '</Resultado></Intelisis>'
SET @Resultado = REPLACE(@Resultado,'<BR>','.')
END

