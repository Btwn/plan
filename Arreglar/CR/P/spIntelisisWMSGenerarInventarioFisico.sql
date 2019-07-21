SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spIntelisisWMSGenerarInventarioFisico
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
@Almacen                   varchar(10),
@Mov                       varchar(20),
@FechaEmision              datetime,
@sFechaEmision             varchar(10),
@Observaciones             varchar(100),
@Agente                    varchar(10),
@Usuario                   varchar(10),
@UltimoCambio              datetime,
@Moneda                    varchar(10),
@TipoCambio                float,
@Estatus                   varchar(15),
@Directo                   bit,
@AlmacenTransito           varchar(10),
@PosicionWMS               varchar(10),
@FechaRequerida            datetime,
@Vencimiento               datetime,
@SucursalOrigen            int,
@IdInv                     int
DECLARE @TablaPosicion table(
PosicionWMS                varchar(10)
)
DECLARE @Tabla Table(
ModuloID                   int,
Mov                        varchar(20),
MovID                      varchar(20),
Estatus                    varchar(15)
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
SELECT @Almacen = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Almacen'
SELECT @Moneda = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Moneda'
SELECT @Mov = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Mov'
SELECT @sFechaEmision = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'FechaEmision'
SELECT @Observaciones = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Observaciones'
SELECT @Agente = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Agente'
SET @Empresa        = LTRIM(RTRIM(ISNULL(@Empresa,'')))
SET @Sucursal       = CAST(ISNULL(@sSucursal,'0') AS int)
SET @SucursalNombre = LTRIM(RTRIM(ISNULL(@SucursalNombre,'')))
SET @Almacen        = LTRIM(RTRIM(ISNULL(@Almacen,'')))
SET @Moneda         = LTRIM(RTRIM(ISNULL(@Moneda,'')))
SET @Mov            = LTRIM(RTRIM(ISNULL(@Mov,'')))
SET @sFechaEmision  = LTRIM(RTRIM(ISNULL(@sFechaEmision,'')))
SET @Observaciones  = LTRIM(RTRIM(ISNULL(@Observaciones,'')))
SET @Agente         = LTRIM(RTRIM(ISNULL(@Agente,'')))
SELECT @Usuario = Usuario FROM IntelisisService WHERE ID = @ID
SET @Usuario = LTRIM(RTRIM(ISNULL(@Usuario,'')))
IF ISNULL(@Agente,'') = ''
SELECT @Agente = DefAgente FROM Usuario WHERE Usuario = @Usuario
SET @FechaEmision   = @sFechaEmision
SET @FechaEmision   = dbo.fnFechaSinHora(@FechaEmision)
SET @FechaRequerida = @FechaEmision
SET @Vencimiento    = @FechaEmision
SET @SucursalOrigen = @Sucursal
SET  @UltimoCambio             = GETDATE()
SET  @Estatus                  = 'SINAFECTAR'
SET  @Directo                  = 1
SET  @AlmacenTransito          = '(TRANSITO)'
INSERT INTO @TablaPosicion EXEC spRegresaPosicion 'INV', 'SALIDA', NULL, @Almacen, @Mov
SELECT TOP 1 @PosicionWMS = PosicionWMS FROM @TablaPosicion
SELECT @TipoCambio = TipoCambio FROM Mon WHERE Moneda = @Moneda
INSERT INTO INV (Empresa, Mov, FechaEmision, UltimoCambio, Moneda, TipoCambio, Usuario, Observaciones, Estatus, Directo, Almacen, AlmacenTransito, FechaRequerida, Vencimiento, Sucursal, Agente, PosicionWMS, SucursalOrigen)
VALUES (@Empresa, @Mov, @FechaEmision, @UltimoCambio, @Moneda, @TipoCambio, @Usuario, @Observaciones, @Estatus, @Directo, @Almacen, @AlmacenTransito, @FechaRequerida, @Vencimiento, @Sucursal, @Agente, @PosicionWMS, @SucursalOrigen)
SET @IdInv = SCOPE_IDENTITY()
INSERT INTO @Tabla (ModuloID, Mov, MovID, Estatus)
SELECT ID, Mov, MovID, Estatus FROM INV WHERE ID = @IdInv
SELECT @Texto = (SELECT CAST(ISNULL(ModuloID,0) AS varchar) AS ModuloID,
LTRIM(RTRIM(ISNULL(Mov,'')))          AS Mov,
LTRIM(RTRIM(ISNULL(MovID,'')))        AS MovID,
LTRIM(RTRIM(ISNULL(Estatus,'')))      AS Estatus
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

