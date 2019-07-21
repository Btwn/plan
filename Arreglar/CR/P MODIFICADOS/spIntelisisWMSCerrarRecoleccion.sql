SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spIntelisisWMSCerrarRecoleccion
@ID                 int,
@iSolicitud         int,
@Version            float,
@Resultado          varchar(max) = NULL OUTPUT,
@Ok                 int = NULL OUTPUT,
@OkRef              varchar(255) = NULL OUTPUT

AS BEGIN
DECLARE
@Texto                xml,
@ReferenciaIS         varchar(100),
@SubReferencia        varchar(100),
@Empresa              varchar(5),
@ListaMovimientos     varchar(max),
@Numero               varchar(20),
@Usuario              varchar(10),
@Sucursal             int,
@sSucursal            varchar(20),
@SucursalNombre       varchar(20),
@Paquete              varchar(20),
@IDOrigen             int,
@IDDestino            int,
@Articulo             varchar(20),
@Subcuenta            varchar(50),
@Cantidad             float,
@Tarima               varchar(20),
@TarimaSurtido        varchar(20),
@Posicion             varchar(10),
@PosicionDestino      varchar(10),
@Fecha                datetime,
@Origen               varchar(20),
@OrigenID             varchar(20),
@Msg                  varchar(300),
@Delimitador          char(1),
@Inicio               int,
@Fin                  int,
@idx                  int,
@Maximo               int,
@MaxIdx               int
DECLARE @TablaPaquete table (
Paquete               varchar(20),
IDOrigen              int,
IDDestino             int,
Articulo              varchar(20),
Subcuenta             varchar(50),
Cantidad              float,
Tarima                varchar(20),
TarimaSurtido         varchar(20),
Posicion              varchar(10),
PosicionDestino       varchar(10),
Sucursal              int,
Usuario               varchar(10),
Fecha                 datetime
)
DECLARE @Tabla table (
Msg                   varchar(300)
)
BEGIN TRY
SELECT @ReferenciaIS = Referencia FROM IntelisisService WITH(NOLOCK) WHERE ID = @ID
SELECT @Empresa = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Empresa'
SELECT @sSucursal = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Sucursal'
SELECT @SucursalNombre = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'SucursalNombre'
SELECT @Usuario = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Usuario'
SELECT @IDOrigen = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'IDOrigen'
SELECT @Origen = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Origen'
SELECT @OrigenID = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'OrigenID'
SELECT @ListaMovimientos = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'ListaMovimientos'
SET @Empresa         = LTRIM(RTRIM(ISNULL(@Empresa,'')))
SET @SucursalNombre  = LTRIM(RTRIM(ISNULL(@SucursalNombre,'')))
SET @Usuario         = LTRIM(RTRIM(ISNULL(@Usuario,'')))
SET @ListaMovimientos = LTRIM(RTRIM(ISNULL(@ListaMovimientos,'')))
IF ISNUMERIC(@sSucursal) = 1 SET @Sucursal = CAST(@sSucursal AS int)
SET @Fecha = GETDATE()
EXEC spConsecutivo 'WMSPaquete', @Sucursal, @Paquete OUTPUT, @Ok = @Ok OUTPUT, @OkRef = @OkRef OUTPUT
IF ISNULL(@OK, 0) = 0
BEGIN
SET @Delimitador = '~'
SET @Maximo = 1000
SET @idx = 0
SET @Inicio = 1
SET @Fin = CHARINDEX(@Delimitador, @ListaMovimientos)
WHILE (@Inicio < (LEN(@ListaMovimientos) + 1)) AND (@idx < @Maximo)
BEGIN
SET @idx = @idx + 1
IF @Fin = 0 SET @Fin = (LEN(@ListaMovimientos) + 1)
INSERT INTO @TablaPaquete (Paquete, IDOrigen, IDDestino, Sucursal, Usuario, Fecha)
VALUES(@Paquete, @IDOrigen, SUBSTRING(@ListaMovimientos, @Inicio, (@Fin - @Inicio)), @Sucursal, @Usuario, @Fecha)
SET @Inicio = (@Fin + 1)
SET @Fin = CHARINDEX(@Delimitador, @ListaMovimientos, @Inicio)
END
UPDATE @TablaPaquete
SET Articulo        = b.Articulo,
Subcuenta       = b.SubCuenta,
Cantidad        = b.CantidadPicking,
Tarima          = b.Tarima,
TarimaSurtido   = c.TarimaSurtido,
Posicion        = b.Posicion,
PosicionDestino = b.PosicionDestino
FROM @TablaPaquete a
JOIN TMAD b  WITH(NOLOCK) ON (a.IDDestino = b.ID)
JOIN TMA c  WITH(NOLOCK) ON (a.IDOrigen = c.ID)
UPDATE TMA
 WITH(ROWLOCK) SET Empacado = 1
FROM TMA a JOIN @TablaPaquete b ON (a.ID = b.IDDestino)
INSERT INTO WMSPaquete (Paquete, IDOrigen, IDDestino, Articulo, Subcuenta, Cantidad, Tarima, TarimaSurtido, Posicion, PosicionDestino, Sucursal, Usuario, Fecha)
SELECT Paquete, IDOrigen, IDDestino, Articulo, Subcuenta, Cantidad, Tarima, TarimaSurtido, Posicion, PosicionDestino, Sucursal, Usuario, Fecha
FROM @TablaPaquete
SET @Msg = 'Paquete ' + @Paquete + ' registrado con �xito.'
INSERT INTO @Tabla(Msg) VALUES(@Msg)
END
ELSE
BEGIN
SET @Msg = LTRIM(RTRIM(ISNULL(@OkRef,'')))
INSERT INTO @Tabla(Msg) VALUES(@Msg)
END
SELECT @Texto = (SELECT ISNULL(Msg,'') AS Msg FROM @Tabla AS TMA FOR XML AUTO)
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

