SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spIntelisisWMSEtiquetaSurtidoImprimir
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
@Modulo                    varchar(5),
@ModuloID                  int,
@Renglon                   float,
@Mov                       varchar(20),
@MovID                     varchar(20),
@Articulo                  varchar(20),
@ArtDescripcion            varchar(100),
@Subcuenta                 varchar(50),
@Cantidad                  float,
@CodigoBarras              varchar(30),
@Linea                     varchar(255)
DECLARE @Tabla Table(
idx                        int IDENTITY(1,1),
Linea                      varchar(255)
)
BEGIN TRY
SELECT @Empresa = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Empresa'
SELECT @Sucursal = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Sucursal'
SELECT @Usuario = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Usuario'
SELECT @Modulo = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Modulo'
SELECT @ModuloID = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'ModuloID'
SELECT @Renglon = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Renglon'
SELECT @Mov = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Mov'
SELECT @MovID = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'MovID'
SELECT @Articulo = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Articulo'
SELECT @SubCUenta = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'SubCUenta'
SELECT @Cantidad = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Cantidad'
SELECT @CodigoBarras = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'CodigoBarras'
SET @Empresa         = LTRIM(RTRIM(ISNULL(@Empresa,'')))
SET @Sucursal        = CAST(ISNULL(@Sucursal,'0') AS int)
SET @Usuario         = LTRIM(RTRIM(ISNULL(@Usuario,'')))
SET @Modulo          = LTRIM(RTRIM(ISNULL(@Modulo,'')))
SET @ModuloID        = CAST(ISNULL(@ModuloID,'0') AS int)
SET @Renglon         = CAST(ISNULL(@Renglon,'0') AS int)
SET @Mov             = LTRIM(RTRIM(ISNULL(@Mov,'')))
SET @MovID           = LTRIM(RTRIM(ISNULL(@MovID,'')))
SET @Articulo        = LTRIM(RTRIM(ISNULL(@Articulo,'')))
SET @Subcuenta       = LTRIM(RTRIM(ISNULL(@Subcuenta,'')))
SET @Cantidad        = CAST(ISNULL(@Cantidad,'0') AS int)
SET @CodigoBarras    = LTRIM(RTRIM(ISNULL(@CodigoBarras,'')))
SELECT @EmpresaNombre = LTRIM(RTRIM(ISNULL(Nombre,''))) FROM Empresa WITH(NOLOCK) WHERE Empresa = @Empresa
SELECT @SucursalNombre = LTRIM(RTRIM(ISNULL(Nombre,''))) FROM Sucursal WITH(NOLOCK) WHERE Sucursal = @Sucursal
SELECT @ArtDescripcion = LTRIM(RTRIM(ISNULL(Descripcion1,''))) FROM Art WITH(NOLOCK) WHERE Articulo = @Articulo
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
END TRY
BEGIN CATCH
SET @Ok = 1
SELECT @OkRef = LTRIM(RTRIM(LEFT(ERROR_MESSAGE(),255)))
END CATCH
SELECT @ReferenciaIS = Referencia FROM IntelisisService WITH(NOLOCK) WHERE ID = @ID
SET @Resultado = '<?xml version="1.0" encoding="windows-1252"?><Intelisis Sistema="Intelisis" Contenido="Resultado" Referencia=' + CHAR(34) + ISNULL(@ReferenciaIS,'') + CHAR(34) + ' SubReferencia=' + CHAR(34) + ISNULL(@SubReferencia,'') + CHAR(34) + ' Version=' + CHAR(34) + ISNULL(CONVERT(varchar ,@Version),'') + CHAR(34) + '><Resultado IntelisisServiceID=' + CHAR(34) + ISNULL(CONVERT(varchar,@ID),'')  + CHAR(34)  + ' Ok=' + CHAR(34) + ISNULL(CONVERT(varchar,@Ok),'') + CHAR(34) + ' OkRef=' + CHAR(34) + ISNULL(@OkRef,'') + CHAR(34) + '>' + ISNULL(CONVERT(varchar(max),@Texto),'') + '</Resultado></Intelisis>'
SET @Resultado = REPLACE(@Resultado,'<BR>','.')
END

