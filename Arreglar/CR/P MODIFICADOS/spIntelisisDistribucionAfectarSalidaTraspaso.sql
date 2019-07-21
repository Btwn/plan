SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spIntelisisDistribucionAfectarSalidaTraspaso
@ID                      int,
@iSolicitud              int,
@Version                 float,
@Resultado               varchar(max) = NULL OUTPUT,
@Ok                      int = NULL OUTPUT,
@OkRef                   varchar(255) = NULL OUTPUT

AS BEGIN
DECLARE
@Empresa                 varchar(5),
@Sucursal                int,
@Usuario                 varchar(10),
@ReferenciaIS            varchar(100),
@SubReferencia           varchar(100),
@xml                     xml,
@Texto                   xml
DECLARE
@sModuloID               varchar(100),
@ModuloID                int,
@MovimientoGenerar       varchar(20),
@IDGenerar               int,
@Estacion                int,
@FechaRegistro           datetime,
@Mensaje                 varchar(255)
DECLARE @TablaInvD table(
IDX                      int identity (1,1),
ID                       int,
Renglon                  float,
RenglonSub               int,
RenglonID                int,
Articulo                 varchar(20),
SubCuenta                varchar(50),
CantidadA                float
)
DECLARE @TablaSerieLoteMov table(
IDX                      int identity (1,1),
Empresa                  varchar(5),
Modulo                   varchar(5),
ID                       int,
RenglonID                int,
Articulo                 varchar(20),
SubCuenta                varchar(50),
SerieLote                varchar(50),
Cantidad                 float,
Sucursal                 int
)
DECLARE @Tabla Table(
Mensaje                  varchar(255)
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
SELECT @sModuloID = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'ModuloID'
SELECT @MovimientoGenerar = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'MovimientoGenerar'
SET @Empresa           = LTRIM(RTRIM(ISNULL(@Empresa,'')))
SET @Sucursal          = LTRIM(RTRIM(ISNULL(@Sucursal,'')))
SET @Usuario           = LTRIM(RTRIM(ISNULL(@Usuario,'')))
SET @ModuloID          = CAST(ISNULL(@sModuloID,'0') AS int)
SET @MovimientoGenerar = LTRIM(RTRIM(ISNULL(@MovimientoGenerar,'')))
SET @IDGenerar         = 0
SET @Mensaje           = ''
SET @Estacion          = @@SPID
SET @FechaRegistro     = dbo.fnFechaSinHora(GETDATE())
INSERT INTO @TablaInvD (ID, Renglon, RenglonSub, RenglonID, Articulo, SubCuenta, CantidadA)
SELECT ID, Renglon, RenglonSub, RenglonID, Articulo, SubCuenta, CantidadA
FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Tabla')
WITH (ID          int           '@ID',
Renglon     float         '@Renglon',
RenglonSub  int           '@RenglonSub',
RenglonID   int           '@RenglonID',
Articulo    varchar (20)  '@Articulo',
SubCuenta   varchar (50)  '@SubCuenta',
CantidadA   float         '@CantidadA');
INSERT INTO @TablaSerieLoteMov (Empresa, Modulo, ID, RenglonID, Articulo, SubCuenta, SerieLote, Cantidad, Sucursal)
SELECT Empresa, Modulo, ID, RenglonID, Articulo, SubCuenta, SerieLote, Cantidad, Sucursal
FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Tabla2')
WITH (Empresa     varchar (5)   '@Empresa',
Modulo      varchar (5)   '@Modulo',
ID          int           '@ID',
RenglonID   int           '@RenglonID',
Articulo    varchar (20)  '@Articulo',
SubCuenta   varchar (50)  '@SubCuenta',
SerieLote   varchar (50)  '@SerieLote',
Cantidad    float         '@Cantidad',
Sucursal    int           '@Sucursal');
UPDATE InvD
 WITH(ROWLOCK) SET CantidadA = ISNULL(b.CantidadA,0)
FROM InvD a
JOIN @TablaInvD b
ON (a.ID        = b.ID
AND a.Renglon    = b.Renglon
AND a.RenglonSub = b.RenglonSub
AND a.RenglonID  = b.RenglonID)
DELETE SerieLoteMov WHERE Empresa = @Empresa AND ID = @ModuloID
INSERT INTO SerieLoteMov (Empresa, Modulo, ID, RenglonID, Articulo, SubCuenta, SerieLote, Cantidad, Sucursal)
SELECT Empresa, Modulo, ID, RenglonID, Articulo, SubCuenta, SerieLote, Cantidad, Sucursal
FROM @TablaSerieLoteMov
EXEC @IDGenerar = spAfectar 'INV', @ModuloID, 'AFECTAR', 'Todo', NULL, @Usuario, @Estacion, @EnSilencio = 1, @Conexion = 0, @Ok = @Ok OUTPUT, @OkRef = @OkRef OUTPUT
IF ISNULL(@OK,0) BETWEEN 80030 AND 81000
BEGIN
SELECT @Mensaje = RTRIM(LTRIM(ISNULL(Descripcion,''))) + ' '  + RTRIM(LTRIM(ISNULL(@OkRef,''))) FROM MensajeLista with(nolock) WHERE Mensaje = @Ok
INSERT INTO @Tabla (Mensaje) VALUES (@Mensaje)
SET @Ok = NULL
SET @OkRef = NULL
END
ELSE
BEGIN
SELECT @Mensaje = Descripcion FROM MensajeLista WITH(NOLOCK) WHERE Mensaje = @Ok
INSERT INTO @Tabla (Mensaje) VALUES(@Mensaje)
END
END TRY
BEGIN CATCH
SELECT @Mensaje = LTRIM(RTRIM(LEFT(ERROR_MESSAGE(),255)))
INSERT INTO @Tabla (Mensaje) VALUES (@Mensaje)
SET @Ok = 1
SELECT @OkRef = Descripcion FROM MensajeLista WITH(NOLOCK) WHERE Mensaje = @Ok
END CATCH
SELECT @Texto = (SELECT TOP 5 LTRIM(RTRIM(ISNULL(Mensaje,''))) AS Mensaje FROM @Tabla AS Tabla FOR XML AUTO)
SELECT @ReferenciaIS = Referencia FROM IntelisisService WITH(NOLOCK) WHERE ID = @ID
SET @Resultado = '<?xml version="1.0" encoding="windows-1252"?><Intelisis Sistema="Intelisis" Contenido="Resultado" Referencia=' + CHAR(34) + ISNULL(@ReferenciaIS,'') + CHAR(34) + ' SubReferencia=' + CHAR(34) + ISNULL(@SubReferencia,'') + CHAR(34) + ' Version=' + CHAR(34) + ISNULL(CONVERT(varchar ,@Version),'') + CHAR(34) + '><Resultado IntelisisServiceID=' + CHAR(34) + ISNULL(CONVERT(varchar,@ID),'')  + CHAR(34)  + ' Ok=' + CHAR(34) + ISNULL(CONVERT(varchar,@Ok),'') + CHAR(34) + ' OkRef=' + CHAR(34) + ISNULL(@OkRef,'') + CHAR(34) + '>' + ISNULL(CONVERT(varchar(max),@Texto),'') + '</Resultado></Intelisis>'
SET @Resultado = REPLACE(@Resultado,'<BR>','.')
END

