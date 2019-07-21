SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spIntelisisWMSOSurtidoPendientes
@ID            int,
@iSolicitud    int,
@Version       float,
@Resultado     varchar(max) = NULL OUTPUT,
@Ok            int = NULL OUTPUT,
@OkRef         varchar(255) = NULL OUTPUT

AS BEGIN
DECLARE
@Empresa            varchar(5),
@Sucursal2          varchar(100),
@Usuario            varchar(20),
@Texto              xml,
@ReferenciaIS       varchar(100),
@SubReferencia      varchar(100),
@Mov                varchar(20),
@MovC               varchar(20),
@MovI               varchar(20),
@MovID              varchar(20),
@Montacarga         varchar(20),
@Sucursal           int,
@Agente             varchar(10),
@Descripcion        varchar(100),
@Movimiento         varchar(20),
@Clave              varchar(20),
@SubClave           varchar(20)
DECLARE @Tabla table(
Mov               varchar(20),
MovID             varchar(20),
Fecha             datetime,
Prioridad         int,
Completo          bit,
Almacen           varchar(10),
OrigenTipo        varchar(10),
Origen            varchar(20),
OrigenID          varchar(20)
)
SELECT @Empresa = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Empresa'
SELECT @Sucursal2= Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Sucursal'
SELECT @Usuario = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Usuario'
SELECT @Montacarga = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Montacarga'
SELECT  @Movimiento = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Movimiento'
SELECT @Clave = Clave,
@SubClave = SubClave
FROM MovTipo
WITH(NOLOCK) WHERE Modulo = 'TMA'
AND Mov = @Movimiento
SELECT @Sucursal = Sucursal
FROM Sucursal
WITH(NOLOCK) WHERE Nombre = @Sucursal2
SELECT @Agente = DefAgente
FROM Usuario
WITH(NOLOCK) WHERE Usuario = @Usuario
IF @Agente IS NULL SELECT @Ok = 20930
SELECT @MovC = TMAOrdenSurtido FROM EmpresaCfgMovWMS WITH(NOLOCK) WHERE Empresa = @Empresa
SELECT @MovI = TMAOrdenSurtidoPCK FROM EmpresaCfgMovWMS WITH(NOLOCK) WHERE Empresa = @Empresa
INSERT INTO @Tabla(Mov,MovID,Fecha,Prioridad,Completo,Almacen,OrigenTipo,Origen,OrigenID)
SELECT DISTINCT t.Mov,
t.MovID,
t.FechaEmision,
CASE WHEN t.Prioridad = 'Alta' THEN 1
WHEN t.Prioridad = 'Normal' THEN 2
WHEN t.Prioridad = 'Baja' THEN 3
WHEN t.Prioridad IS NULL THEN 4 END,
CASE WHEN @Clave = 'TMA.OSUR' AND t.Mov = @MovC THEN 1
WHEN @Clave = 'TMA.OSUR' AND t.Mov = @MovI THEN 0
WHEN @Clave = 'TMA.OPCKTARIMA' THEN 0 END,
t.Almacen,
t.OrigenTipo,
t.Origen,
t.OrigenID
FROM TMA t
 WITH(NOLOCK) JOIN TMAD d  WITH(NOLOCK) ON t.id = d.ID
JOIN MovTipo m  WITH(NOLOCK) ON m.Mov = t.Mov AND m.Modulo = 'TMA'
WHERE t.Estatus = 'PENDIENTE'
AND m.Clave = @Clave
AND d.Montacarga = @Agente
AND t.Empresa = @Empresa
AND t.Sucursal = @Sucursal
AND d.procesado = 0
ORDER BY t.FechaEmision ASC
SELECT @Texto = (SELECT ISNULL(Mov,'') AS Mov,
ISNULL(MovID,'') AS MovID,
ISNULL(Fecha,'') AS Fecha,
CAST(ISNULL(Prioridad,0) AS varchar) AS Prioridad,
CAST(ISNULL(Completo,0) AS varchar) AS Completo,
ISNULL(Almacen,'') AS Almacen,
ISNULL(OrigenTipo,'') AS OrigenTipo,
ISNULL(Origen,'') AS Origen,
ISNULL(OrigenID,'') AS OrigenID
FROM @Tabla AS TMA
ORDER BY Prioridad, Fecha DESC
FOR XML AUTO)
SELECT @ReferenciaIS = Referencia
FROM IntelisisService
WITH(NOLOCK) WHERE ID = @ID
IF @Ok IS NOT NULL SELECT @Descripcion = Descripcion FROM MensajeLista WITH(NOLOCK) WHERE Mensaje = @Ok
SET @Resultado = '<?xml version="1.0" encoding="windows-1252"?><Intelisis Sistema="Intelisis" Contenido="Resultado" Referencia=' + CHAR(34) + ISNULL(@ReferenciaIS,'') + CHAR(34) + ' SubReferencia=' + CHAR(34) + ISNULL(@SubReferencia,'') + CHAR(34) + ' Version=' + CHAR(34) + ISNULL(CONVERT(varchar ,@Version),'') + CHAR(34) + '><Resultado IntelisisServiceID=' + CHAR(34) + ISNULL(CONVERT(varchar,@ID),'')  + CHAR(34)  + ' Ok=' + CHAR(34) + ISNULL(CONVERT(varchar,@Ok),'') + CHAR(34) + ' OkRef=' + CHAR(34) + ISNULL(@OkRef,'') + CHAR(34) + ' Descripcion="' + ISNULL(@Descripcion,'') +'">' + CONVERT(varchar(max), ISNULL(@Texto,'')) + '</Resultado></Intelisis>'
END

