SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spIntelisisWMSArticuloImprimir
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
@EmpresaNombre             varchar(100),
@Almacen                   varchar(10),
@Sucursal                  int,
@SucursalNombre            varchar(100),
@Usuario                   varchar(20),
@Agente                    varchar(10),
@OrigenTipo                varchar(50),
@Origen                    varchar(20),
@OrigenID                  varchar(20),
@Articulo                  varchar(20),
@ArtDescripcion            varchar(100),
@Subcuenta                 varchar(20),
@Tarima                    varchar(20),
@TarimaSurtido             varchar(20),
@Posicion                  varchar(20),
@Cantidad                  varchar(20),
@Unidad                    varchar(20),
@PosicionDestino           varchar(20),
@MovGenerado               varchar(20),
@MovIDGenerado             varchar(20),
@Fecha                     varchar(20),
@Linea                     varchar(255)
DECLARE @Tabla Table(
idx                        int IDENTITY(1,1),
Linea                      varchar(255)
)
BEGIN TRY
SELECT @Empresa = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Empresa'
SELECT @SucursalNombre = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'SucursalNombre'
SELECT @Usuario = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Usuario'
SELECT @OrigenTipo = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'OrigenTipo'
SELECT @Origen = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Origen'
SELECT @OrigenID = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'OrigenID'
SELECT @Articulo = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Articulo'
SELECT @Tarima = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Tarima'
SELECT @Posicion = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Posicion'
SELECT @Cantidad = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Cantidad'
SELECT @Unidad = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Unidad'
SELECT @PosicionDestino = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'PosicionDestino'
SELECT @MovGenerado = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'MovGenerado'
SELECT @MovIDGenerado = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'MovIDGenerado'
SET @Empresa         = LTRIM(RTRIM(ISNULL(@Empresa,'')))
SET @SucursalNombre  = LTRIM(RTRIM(ISNULL(@SucursalNombre,'')))
SET @Usuario         = LTRIM(RTRIM(ISNULL(@Usuario,'')))
SET @OrigenTipo      = LTRIM(RTRIM(ISNULL(@OrigenTipo,'')))
SET @Origen          = LTRIM(RTRIM(ISNULL(@Origen,'')))
SET @OrigenID        = LTRIM(RTRIM(ISNULL(@OrigenID,'')))
SET @Articulo        = LTRIM(RTRIM(ISNULL(@Articulo,'')))
SET @Tarima          = LTRIM(RTRIM(ISNULL(@Tarima,'')))
SET @Posicion        = LTRIM(RTRIM(ISNULL(@Posicion,'')))
SET @Cantidad        = LTRIM(RTRIM(ISNULL(@Cantidad,'')))
SET @Unidad          = LTRIM(RTRIM(ISNULL(@Unidad,'')))
SET @PosicionDestino = LTRIM(RTRIM(ISNULL(@PosicionDestino,'')))
SET @MovGenerado     = LTRIM(RTRIM(ISNULL(@MovGenerado,'')))
SET @MovIDGenerado   = LTRIM(RTRIM(ISNULL(@MovIDGenerado,'')))
SELECT @EmpresaNombre = LTRIM(RTRIM(ISNULL(Nombre,''))) FROM Empresa WITH(NOLOCK) WHERE Empresa = @Empresa
SELECT @ArtDescripcion = LTRIM(RTRIM(ISNULL(descripcion1,''))) FROM Art WITH(NOLOCK) WHERE Articulo = @Articulo
SET @Linea = '^XA'
INSERT INTO @Tabla (Linea) VALUES (@Linea)
SET @Linea = '^FWR'
INSERT INTO @Tabla (Linea) VALUES (@Linea)
SET @Linea = '^FO600,75'
INSERT INTO @Tabla (Linea) VALUES (@Linea)
SET @Linea = '^A0,50,40'
INSERT INTO @Tabla (Linea) VALUES (@Linea)
SET @Linea = '^FD' + @EmpresaNombre
INSERT INTO @Tabla (Linea) VALUES (@Linea)
SET @Linea = '^FS'
INSERT INTO @Tabla (Linea) VALUES (@Linea)
SET @Linea = '^CF0,40'
INSERT INTO @Tabla (Linea) VALUES (@Linea)
SET @Linea = '^FO580,70'
INSERT INTO @Tabla (Linea) VALUES (@Linea)
SET @Linea = '^GB,700,5'
INSERT INTO @Tabla (Linea) VALUES (@Linea)
SET @Linea = '^FS'
INSERT INTO @Tabla (Linea) VALUES (@Linea)
SET @Linea = '^FO350,80'
INSERT INTO @Tabla (Linea) VALUES (@Linea)
SET @Linea = '^BY4,3,200'
INSERT INTO @Tabla (Linea) VALUES (@Linea)
SET @Linea = '^BCR190'
INSERT INTO @Tabla (Linea) VALUES (@Linea)
SET @Linea = '^FD' + @Articulo
INSERT INTO @Tabla (Linea) VALUES (@Linea)
SET @Linea = '^FS'
INSERT INTO @Tabla (Linea) VALUES (@Linea)
SET @Linea = '^CF0,40'
INSERT INTO @Tabla (Linea) VALUES (@Linea)
SET @Linea = '^FO270,70'
INSERT INTO @Tabla (Linea) VALUES (@Linea)
SET @Linea = '^GB,700,5'
INSERT INTO @Tabla (Linea) VALUES (@Linea)
SET @Linea = '^FS'
INSERT INTO @Tabla (Linea) VALUES (@Linea)
SET @Linea = '^FWR'
INSERT INTO @Tabla (Linea) VALUES (@Linea)
SET @Linea = '^FB650,3,0,C,0'
INSERT INTO @Tabla (Linea) VALUES (@Linea)
SET @Linea = '^FO100,75'
INSERT INTO @Tabla (Linea) VALUES (@Linea)
SET @Linea = '^A0,40,30'
INSERT INTO @Tabla (Linea) VALUES (@Linea)
SET @Linea = '^FD' + @ArtDescripcion
INSERT INTO @Tabla (Linea) VALUES (@Linea)
SET @Linea = '^FS'
INSERT INTO @Tabla (Linea) VALUES (@Linea)
SET @Linea = '^XZ'
INSERT INTO @Tabla (Linea) VALUES (@Linea)
SELECT @Texto = (SELECT ISNULL(Tabla.Linea,'') AS Linea
FROM @Tabla AS Tabla
ORDER BY Tabla.idx
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

