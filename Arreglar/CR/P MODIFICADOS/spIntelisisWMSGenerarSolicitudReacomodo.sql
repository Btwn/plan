SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spIntelisisWMSGenerarSolicitudReacomodo
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
@Sucursal                  varchar(10),
@Almacen                   varchar(10),
@Mov                       varchar(20),
@MovID                     varchar(20),
@MontaCarga                varchar(10),
@Prioridad                 varchar(10),
@Tarima                    varchar(20),
@Posicion                  varchar(10),
@PosicionDestino           varchar(10),
@Zona                      varchar(50),
@CantidadPicking           float,
@CantidadPickingTmp        varchar(50),
@Unidad                    varchar(50),
@CantidadUnidad            float,
@Articulo                  varchar(20),
@SubCuenta                 varchar(50),
@FechaEmision              datetime,
@UltimoCambio              datetime,
@Estatus                   varchar(15),
@SucursalOrigen            varchar(10),
@Renglon                   float,
@Procesado                 bit,
@GeneradoEnMovil           bit,
@Usuario                   varchar(20),
@Agente                    varchar(10),
@TMAID                     int,
@CapacidadPosicion         bit,
@Estacion                  int,
@CantidadPendiente         float,
@NombreTrans               varchar(32)
DECLARE @Tabla Table(
ModuloID                   int,
Mov                        varchar(20),
Movid                      varchar(20),
Estatus                    varchar(15),
Mensaje                    varchar(255)
)
BEGIN TRY
SELECT @Empresa = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Empresa'
SELECT @Sucursal = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Sucursal'
SELECT @Almacen = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Almacen'
SELECT @Mov = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Mov'
SELECT @MontaCarga = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'MontaCarga'
SELECT @Prioridad = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Prioridad'
SELECT @Tarima = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Tarima'
SELECT @Posicion = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Posicion'
SELECT @PosicionDestino = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'PosicionDestino'
SELECT @Zona = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Zona'
SELECT @CantidadPickingTmp = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'CantidadPicking'
SELECT @Unidad = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Unidad'
SELECT @Articulo = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Articulo'
SELECT @SubCuenta = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'SubCuenta'
SET @Empresa         = LTRIM(RTRIM(ISNULL(@Empresa,'')))
SET @Sucursal        = LTRIM(RTRIM(ISNULL(@Sucursal,'')))
SET @Almacen         = LTRIM(RTRIM(ISNULL(@Almacen,'')))
SET @Mov             = LTRIM(RTRIM(ISNULL(@Mov,'')))
SET @MontaCarga      = LTRIM(RTRIM(ISNULL(@MontaCarga,'')))
SET @Prioridad       = LTRIM(RTRIM(ISNULL(@Prioridad,'')))
SET @Tarima          = LTRIM(RTRIM(ISNULL(@Tarima,'')))
SET @Posicion        = LTRIM(RTRIM(ISNULL(@Posicion,'')))
SET @PosicionDestino = LTRIM(RTRIM(ISNULL(@PosicionDestino,'')))
SET @Zona            = LTRIM(RTRIM(ISNULL(@Zona,'')))
SET @CantidadPicking = CAST(LTRIM(RTRIM(ISNULL(@CantidadPickingTmp,'0'))) AS float)
SET @Unidad          = LTRIM(RTRIM(ISNULL(@Unidad,'')))
SET @Articulo        = LTRIM(RTRIM(ISNULL(@Articulo,'')))
SET @SubCuenta       = LTRIM(RTRIM(ISNULL(@SubCuenta,'')))
SET @CantidadUnidad  = NULL
SELECT @Usuario = Usuario FROM IntelisisService WITH(NOLOCK) WHERE ID = @ID
SET @Usuario = LTRIM(RTRIM(ISNULL(@Usuario,'')))
SELECT @Agente = DefAgente FROM Usuario WITH(NOLOCK) WHERE Usuario = @Usuario
SET @Agente = LTRIM(RTRIM(ISNULL(@Agente,'')))
SET @TMAID = NULL
SET @CapacidadPosicion = 0
SET @FechaEmision    = GETDATE()
SET @UltimoCambio    = GETDATE()
SET @SucursalOrigen  = @Sucursal
SET @Estatus         = 'SINAFECTAR'
SET @Procesado       = 0
SET @GeneradoEnMovil = 1
SET @Estacion        = @@SPID
SET @NombreTrans     = 'TMA_SRADO' + CAST(@Estacion AS varchar)
INSERT INTO TMA (Empresa, Mov, FechaEmision, UltimoCambio, Usuario, Estatus, Sucursal, SucursalOrigen, Almacen, Agente, MontaCarga, Prioridad)
SELECT @Empresa, @Mov, @FechaEmision, @UltimoCambio, @Usuario, @Estatus, @Sucursal, @SucursalOrigen, @Almacen, @Agente, @MontaCarga, @Prioridad
SELECT @TMAID = SCOPE_IDENTITY()
IF ISNULL(@TMAID,0) > 0
BEGIN
SET @Renglon = 2048
IF LTRIM(RTRIM(ISNULL(@SubCuenta,''))) = '' SET @SubCuenta = NULL
INSERT INTO TMAD (ID, Renglon, Sucursal, SucursalOrigen, Tarima, Almacen, Posicion, PosicionDestino, Zona, CantidadPicking, CantidadPendiente, Procesado, Prioridad, Montacarga, CapacidadPosicion, Unidad, CantidadUnidad, Articulo, SubCuenta, GeneradoEnMovil)
VALUES (@TMAID, @Renglon, @Sucursal, @SucursalOrigen, @Tarima, @Almacen, @Posicion, @PosicionDestino, @Zona, @CantidadPicking, @CantidadPendiente, @Procesado, @Prioridad, @Agente, @CapacidadPosicion, @Unidad, @CantidadUnidad, @Articulo, @SubCuenta, @GeneradoEnMovil)
EXEC spAfectar 'TMA', @TMAID, 'AFECTAR', 'Todo', NULL, @Usuario, @Estacion, @EnSilencio = 1, @Ok = @Ok OUTPUT, @OkRef = @OkRef OUTPUT
IF ISNULL(@Ok,0) = 0
BEGIN
UPDATE TMA  WITH(ROWLOCK) SET @UltimoCambio = GETDATE() WHERE ID = @TMAID
SELECT @Movid = MovID, @Estatus = LTRIM(RTRIM(ISNULL(Estatus,''))) FROM TMA WITH(NOLOCK) WHERE ID = @TMAID
END
ELSE
BEGIN
SELECT @OkRef = Descripcion FROM MensajeLista WITH(NOLOCK) WHERE Mensaje = @Ok
END
END
INSERT INTO @Tabla (ModuloID, Mov, Movid, Estatus, Mensaje)
VALUES (@TMAID, @Mov, @Movid, @Estatus, @OkRef)
END TRY
BEGIN CATCH
SET @Ok = 1
SELECT @OkRef = LTRIM(RTRIM(LEFT(ERROR_MESSAGE(),255)))
END CATCH
SELECT @Texto = (SELECT CAST(ISNULL(ModuloID,0) AS varchar) AS ModuloID,
LTRIM(RTRIM(ISNULL(Mov,'')))        AS Mov,
LTRIM(RTRIM(ISNULL(Movid,'')))      AS Movid,
LTRIM(RTRIM(ISNULL(Estatus,'')))    AS Estatus,
LTRIM(RTRIM(ISNULL(Mensaje,'')))    AS Mensaje
FROM @Tabla AS TMA
FOR XML AUTO)
SELECT @ReferenciaIS = Referencia FROM IntelisisService WITH(NOLOCK) WHERE ID = @ID
SET @Resultado = '<?xml version="1.0" encoding="windows-1252"?><Intelisis Sistema="Intelisis" Contenido="Resultado" Referencia=' + CHAR(34) + ISNULL(@ReferenciaIS,'') + CHAR(34) + ' SubReferencia=' + CHAR(34) + ISNULL(@SubReferencia,'') + CHAR(34) + ' Version=' + CHAR(34) + ISNULL(CONVERT(varchar ,@Version),'') + CHAR(34) + '><Resultado IntelisisServiceID=' + CHAR(34) + ISNULL(CONVERT(varchar,@ID),'')  + CHAR(34)  + ' Ok=' + CHAR(34) + ISNULL(CONVERT(varchar,@Ok),'') + CHAR(34) + ' OkRef=' + CHAR(34) + ISNULL(@OkRef,'') + CHAR(34) + '>' + ISNULL(CONVERT(varchar(max),@Texto),'') + '</Resultado></Intelisis>'
SET @Resultado = REPLACE(@Resultado,'<BR>','.')
END

