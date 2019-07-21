SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spIntelisisWMSAlmacenesLista
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
@sSucursal                 varchar(20),
@SucursalNombre            varchar(100),
@Usuario                   varchar(20),
@Agente                    varchar(10),
@DefAlmacen                varchar(10)
DECLARE @Tabla Table(
Almacen                    varchar(10),
DefAlmacen                 varchar(10)
)
BEGIN TRY
SELECT @Empresa = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Empresa'
SELECT @sSucursal = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Sucursal'
SELECT @SucursalNombre = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'SucursalNombre'
SET @Empresa        = LTRIM(RTRIM(ISNULL(@Empresa,'')))
SET @Sucursal       = CAST(ISNULL(@sSucursal,'0') AS int)
SET @SucursalNombre = LTRIM(RTRIM(ISNULL(@SucursalNombre,'')))
SELECT @Usuario = Usuario FROM IntelisisService WHERE ID = @ID
SET @Usuario = LTRIM(RTRIM(ISNULL(@Usuario,'')))
SELECT @Agente = DefAgente FROM Usuario WHERE Usuario = @Usuario
SET @Agente = LTRIM(RTRIM(ISNULL(@Agente,'')))
SELECT @DefAlmacen = DefAlmacen FROM Usuario WHERE Usuario = @Usuario
INSERT INTO @Tabla (Almacen, DefAlmacen)
SELECT Almacen, @DefAlmacen
FROM Alm
WHERE Sucursal = @Sucursal
AND WMS = 1
AND Estatus = 'ALTA'
SELECT @Texto = (SELECT LTRIM(RTRIM(ISNULL(Almacen,'')))  AS Almacen,
LTRIM(RTRIM(ISNULL(DefAlmacen,''))) AS DefAlmacen
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

