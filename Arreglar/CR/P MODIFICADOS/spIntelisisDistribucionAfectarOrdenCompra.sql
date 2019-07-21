SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spIntelisisDistribucionAfectarOrdenCompra
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
@Mensaje                 varchar(255)
SET @IDGenerar = 0
SET @Mensaje   = ''
SET @Estacion  = @@SPID
DECLARE @TablaCompraD table(
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
INSERT INTO @TablaCompraD (ID, Renglon, RenglonSub, RenglonID, Articulo, SubCuenta, CantidadA)
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
BEGIN TRANSACTION
UPDATE CompraD WITH(ROWLOCK) SET CantidadA = ISNULL(b.CantidadA,0)
FROM CompraD a
JOIN @TablaCompraD b
ON (a.ID        = b.ID
AND a.Renglon    = b.Renglon
AND a.RenglonSub = b.RenglonSub
AND a.RenglonID  = b.RenglonID)
EXEC @IDGenerar = spAfectar 'COMS', @ModuloID, 'GENERAR', 'Seleccion', @MovimientoGenerar, @Usuario, @Estacion, @EnSilencio = 1, @Conexion = 1, @Ok = @Ok OUTPUT, @OkRef = @OkRef OUTPUT
IF ISNULL(@OK,0) = 0 OR ISNULL(@OK,0) BETWEEN 80030 AND 81000
BEGIN
SET @Ok = NULL
SET @OkRef = NULL
IF (SELECT COUNT(IDX) FROM @TablaSerieLoteMov) > 0
BEGIN
UPDATE @TablaSerieLoteMov SET ID = @IDGenerar
INSERT INTO SerieLoteMov(Empresa, Modulo, ID, RenglonID, Articulo, SubCuenta, SerieLote, Cantidad, Sucursal)
SELECT Empresa, Modulo, ID, RenglonID, Articulo, SubCuenta, SerieLote, Cantidad, Sucursal
FROM @TablaSerieLoteMov
ORDER BY IDX
END
IF @MovimientoGenerar = 'Entrada Compra'
BEGIN
EXEC spAfectar 'COMS', @IDGenerar, 'AFECTAR', 'TODO', NULL, @Usuario, @Estacion, @EnSilencio = 1, @Conexion = 1, @Ok = @Ok OUTPUT, @OkRef = @OkRef OUTPUT
IF @OK BETWEEN 80030 AND 81000 SET @OK = NULL
SELECT @Mensaje = 'Se generó el movimiento ' + LTRIM(RTRIM(ISNULL(Mov,''))) + ' ' + LTRIM(RTRIM(ISNULL(MovID,''))) + ' (' + LTRIM(RTRIM(ISNULL(Estatus,''))) + ').' FROM Compra WITH(NOLOCK) WHERE ID = @IDGenerar
INSERT INTO @Tabla (Mensaje) VALUES(@Mensaje)
END
ELSE IF @MovimientoGenerar = 'Entrada con Gastos'
BEGIN
EXEC spAfectar 'COMS', @IDGenerar, 'CONSECUTIVO', NULL, NULL, @Usuario, @Estacion, @EnSilencio = 1, @Conexion = 1, @Ok = @Ok OUTPUT, @OkRef = @OkRef OUTPUT
IF @OK BETWEEN 80030 AND 81000 SET @OK = NULL
SELECT @Mensaje = 'Se generó el movimiento ' + LTRIM(RTRIM(ISNULL(Mov,''))) + ' ' + LTRIM(RTRIM(ISNULL(MovID,''))) + ' (' + LTRIM(RTRIM(ISNULL(Estatus,''))) + ').' FROM Compra WHERE ID = @IDGenerar
INSERT INTO @Tabla (Mensaje) VALUES(@Mensaje)
END
ELSE IF @MovimientoGenerar = 'Entrada Importacion'
BEGIN
EXEC spAfectar 'COMS', @IDGenerar, 'CONSECUTIVO', NULL, NULL, @Usuario, @Estacion, @EnSilencio = 1, @Conexion = 1, @Ok = @Ok OUTPUT, @OkRef = @OkRef OUTPUT
IF @OK BETWEEN 80030 AND 81000 SET @OK = NULL
SELECT @Mensaje = 'Se generó el movimiento ' + LTRIM(RTRIM(ISNULL(Mov,''))) + ' ' + LTRIM(RTRIM(ISNULL(MovID,''))) + ' (' + LTRIM(RTRIM(ISNULL(Estatus,''))) + ').' FROM Compra WHERE ID = @IDGenerar
INSERT INTO @Tabla (Mensaje) VALUES(@Mensaje)
END
END
ELSE
BEGIN
SELECT @Mensaje = Descripcion FROM MensajeLista WITH(NOLOCK) WHERE Mensaje = @Ok
INSERT INTO @Tabla (Mensaje) VALUES(@Mensaje)
END
IF ISNULL(@OK,0) = 0
BEGIN
COMMIT TRANSACTION
END ELSE
BEGIN
ROLLBACK TRANSACTION
IF NOT @OK BETWEEN 80030 AND 81000
BEGIN
SELECT @Mensaje = Descripcion FROM MensajeLista WITH(NOLOCK) WHERE Mensaje = @Ok
INSERT INTO @Tabla (Mensaje) VALUES(@Mensaje)
END
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

