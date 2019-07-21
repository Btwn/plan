SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE [dbo].[spISIntelisisTMAAfectarTMA_TSURP]
@ID                      int,
@iSolicitud              int,
@Version                 float,
@Resultado               varchar(max) = NULL OUTPUT,
@Ok                      int = NULL OUTPUT,
@OkRef                   varchar(255) = NULL OUTPUT

AS BEGIN
DECLARE
@ReferenciaIS            varchar(100),
@Usuario2                varchar(10),
@Estacion                int,
@Empresa                 varchar(5),
@Usuario                 varchar(15),
@Agente                  varchar(20),
@IDAcceso                int,
@FechaEmision            datetime,
@PosicionDestino         varchar (20),
@SubReferencia           varchar(100),
@Texto                   xml,
@ID2                     int,
@Descripcion             varchar(100),
@Origen                  varchar(20),
@OrigenID                varchar(20),
@TarimaSSFA              varchar(20),
@RefSucursalDes          varchar(100),
@Sucursal                int,
@PesoTarimaSSFA          float,
@Montacarga              varchar(20),
@Almacen                 varchar(10)
DECLARE @Tabla             table (
Msg                      varchar(255)
)
SELECT @Estacion = @@SPID
IF @Ok IS NULL
BEGIN
SELECT @OrigenID = Valor
FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'ID'
SELECT @Montacarga = Valor
FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Montacarga'
SELECT @Empresa = Valor
FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Empresa'
SELECT @PosicionDestino = Valor
FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'PosicionDestino'
SELECT @TarimaSSFA = Valor
FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'TarimaSSFA'
SELECT @PesoTarimaSSFA = ISNULL(CONVERT(float, Valor),0)
FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'PesoTarimaSSFA'
SELECT @RefSucursalDes = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'RefSucursalDes'
END
SET @RefSucursalDes = REPLACE(@RefSucursalDes, CHAR(10), '')
SET @RefSucursalDes = REPLACE(@RefSucursalDes, CHAR(13), '')
SELECT @Sucursal = Sucursal FROM Sucursal WHERE Nombre = @RefSucursalDes
SELECT @Origen = TMAOrdenSurtidoPCK FROM EmpresaCfgMovWMS WHERE Empresa = @Empresa
SELECT @FechaEmision = dbo.fnFechaSinHora(GETDATE())
SELECT @Estacion = ISNULL(@Estacion,1)
/* gina 20150820 La variable montacarta trae el valor del equipo no del agente, causando que la tarima no se cierre*/
SELECT @Usuario = Usuario FROM IntelisisService WHERE ID = @ID
SELECT @Agente = DefAgente FROM Usuario WHERE Usuario = @Usuario
SELECT @Montacarga = @Agente
IF @Ok IS NULL AND NOT EXISTS(SELECT *
FROM TMA t
JOIN TMAD d ON t.ID = d.ID
JOIN MovTipo mt ON t.Mov = mt.Mov AND mt.Modulo='TMA'
WHERE t.OrigenTipo = 'TMA'
AND t.Origen = @Origen 
AND mt.Clave='TMA.TSUR' AND mt.SubClave='TMA.TSURP'
AND t.Estatus = 'PROCESAR'
AND d.PosicionDestino=@PosicionDestino
AND t.SucursalFiltro = @Sucursal
AND d.Montacarga=@Montacarga 
)
AND EXISTS(
SELECT *
FROM TMA t
JOIN TMAD d ON t.ID = d.ID
JOIN MovTipo mt ON t.Mov = mt.Mov AND mt.Modulo='TMA'
WHERE t.OrigenTipo = 'TMA'
AND t.Origen = @Origen 
AND mt.Clave='TMA.TSUR' AND mt.SubClave='TMA.TSURP'
AND t.Estatus = 'PROCESAR'
AND d.PosicionDestino<>@PosicionDestino
AND t.SucursalFiltro = @Sucursal
AND d.Montacarga=@Montacarga 
)
SELECT @Ok=13035
IF @Ok IS NULL AND NOT EXISTS(SELECT *
FROM TMA t
JOIN TMAD d ON t.ID = d.ID
JOIN MovTipo mt ON t.Mov = mt.Mov AND mt.Modulo='TMA'
WHERE t.OrigenTipo = 'TMA'
AND t.Origen = @Origen 
AND mt.Clave='TMA.TSUR' AND mt.SubClave='TMA.TSURP'
AND t.Estatus = 'PROCESAR'
AND d.PosicionDestino=@PosicionDestino
AND t.SucursalFiltro = @Sucursal
AND d.Montacarga=@Montacarga 
) SELECT @Ok=60010
BEGIN TRANSACTION 
IF @Ok IS NULL
BEGIN
DELETE ListaID WHERE Estacion = @Estacion
INSERT ListaID (Estacion,ID)
SELECT @Estacion,d.ID
FROM TMA t
JOIN TMAD d ON t.ID = d.ID
JOIN MovTipo mt ON t.Mov = mt.Mov AND mt.Modulo='TMA'
WHERE t.OrigenTipo = 'TMA'
AND t.Origen = @Origen 
AND mt.Clave='TMA.TSUR' AND mt.SubClave='TMA.TSURP'
AND t.Estatus = 'PROCESAR'
AND d.PosicionDestino = @PosicionDestino
AND t.SucursalFiltro = @Sucursal
AND d.Montacarga = @Montacarga
IF @Ok IS NULL AND EXISTS(
SELECT *
FROM TMA t
JOIN TMAD d ON t.ID = d.ID
JOIN MovTipo mt ON t.Mov = mt.Mov AND mt.Modulo='TMA'
WHERE t.OrigenTipo = 'TMA'
AND t.Origen = @Origen
AND mt.Clave='TMA.TSUR' AND mt.SubClave='TMA.TSURP'
AND t.Estatus = 'PROCESAR'
AND d.PosicionDestino=@PosicionDestino
AND t.SucursalFiltro = @Sucursal
AND d.Montacarga=@Montacarga
)
BEGIN
SET @Ok = 20947
SELECT @OkRef = Descripcion FROM MensajeLista WHERE Mensaje = @Ok
INSERT @Tabla(Msg) SELECT @OkRef
SET @OkRef = NULL
END
IF @Ok IS NULL
BEGIN
EXEC spProcesarTMASurtidoTransito2 @Estacion, @Empresa, @FechaEmision, @Usuario, NULL, 0, @Ok OUTPUT ,@OkRef OUTPUT
INSERT INTO @Tabla(msg) SELECT ISNULL(@OkRef, @PosicionDestino)
SET @OkRef = NULL
END
END
IF @Ok IS NULL
BEGIN
COMMIT TRANSACTION
END
ELSE
BEGIN
ROLLBACK TRANSACTION
SELECT @OkRef = Descripcion FROM MensajeLista WHERE Mensaje = @Ok
END
SELECT @Texto = (SELECT LTRIM(RTRIM(ISNULL(Msg,''))) AS Msg
FROM @Tabla Cierre
FOR XML AUTO)
IF @Ok IS NOT NULL SELECT @OkRef = Descripcion FROM MensajeLista WHERE Mensaje = @Ok
SET @Resultado = '<?xml version="1.0" encoding="windows-1252"?><Intelisis Sistema="Intelisis" Contenido="Resultado" Referencia=' + CHAR(34) + ISNULL(@ReferenciaIS,'') + CHAR(34) + ' SubReferencia=' + CHAR(34) + ISNULL(@SubReferencia,'') + CHAR(34) + ' Version=' + CHAR(34) + ISNULL(CONVERT(varchar ,@Version),'') + CHAR(34) + '><Resultado IntelisisServiceID=' + CHAR(34) + ISNULL(CONVERT(varchar,@ID),'') + CHAR(34) + ' Modulo="TMA" Ok=' + CHAR(34) + ISNULL(CONVERT(varchar,@Ok),'') + CHAR(34) + ' OkRef=' + CHAR(34) + ISNULL(@OkRef,'') + CHAR(34) + '/>'+ ISNULL(CONVERT(varchar(max),@Texto),'') +'</Intelisis>'
SET @Resultado = REPLACE(@Resultado,'<BR>','.')
END

