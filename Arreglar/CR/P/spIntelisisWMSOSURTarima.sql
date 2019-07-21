SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spIntelisisWMSOSURTarima
@ID            int,
@iSolicitud    int,
@Version       float,
@Resultado     varchar(max) = NULL OUTPUT,
@Ok            int = NULL OUTPUT,
@OkRef         varchar(255) = NULL OUTPUT

AS BEGIN
DECLARE
@Texto                        xml,
@ReferenciaIS                 varchar(100),
@SubReferencia                varchar(100),
@Mov                          varchar(20),
@MovID                        varchar(20),
@Empresa                      varchar(5),
@Sucursal                     int,
@Sucursal2                    varchar(100),
@Tarima                       varchar(20),
@Posicion                     varchar(10),
@Articulo                     varchar(20),
@Cantidad                     float,
@CantidadUnidad               float,
@Tipo                         varchar(20),
@Disponible                   float,
@DescripcionPosicion          varchar(100),
@PosicionDestino              varchar(10),
@DescripcionPosicionDestino   varchar(100)  ,
@Completo                     int,
@Codigo                       varchar(50),
@Unidad                       varchar(20), 
@Factor                       float      ,  
@Movimiento                   varchar(20),
@OrdenPCKTarima                     varchar(20)
DECLARE @Tabla Table(
Folio                         varchar(20),
Tarima                        varchar(20),
Posicion                      varchar(10),
Tipo                          varchar(20),
Articulo                      varchar(20),
Cantidad                      varchar(100),
CantidadUnidad                varchar(100),
Unidad                        varchar(20),  
DescripcionPosicion           varchar(100),
PosicionDestino               varchar(10),
DescripcionPosicionDestino    varchar(100),
Codigo                        varchar(50)
)
SELECT @Sucursal2  = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Sucursal'
SELECT @Empresa  = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Empresa'
SELECT @Mov  = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Mov'
SELECT @MovID  = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'MovID'
SELECT @Movimiento = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Movimiento'
SELECT @Tarima  = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Tarima'
SELECT @Completo  = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Completo'
SELECT @Articulo  = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Articulo'
IF @Completo = 0
BEGIN
SET @Movimiento = LTRIM(RTRIM(ISNULL(@Movimiento,'')))
SELECT @OrdenPCKTarima = TMAOrdenPCKTarima FROM EmpresaCfgMovWMS WHERE Empresa = @Empresa
SET @OrdenPCKTarima = LTRIM(RTRIM(ISNULL(@OrdenPCKTarima,'')))
IF @Movimiento = @OrdenPCKTarima 
SELECT @Mov = TMAOrdenPCKTarima FROM EmpresaCfgMovWMS WHERE Empresa = @Empresa
ELSE
SELECT @Mov = TMAOrdenSurtidoPCK FROM EmpresaCfgMovWMS WHERE Empresa = @Empresa
END
IF @Completo = 1
SELECT @Mov = TMAOrdenSurtido FROM EmpresaCfgMovWMS WHERE Empresa = @Empresa
IF @Completo = 3
SELECT @Mov = TMASurtidoTransito FROM EmpresaCfgMovWMS WHERE Empresa = @Empresa
SELECT @Articulo                   = LTRIM(RTRIM(ISNULL(a.Articulo,''))),
@Cantidad                   = CONVERT(varchar,ISNULL(ISNULL(d.CantidadPendiente,d.CantidadPicking)/ISNULL(dbo.fnArtUnidadFactor(@Empresa, a.Articulo, d.Unidad),1) ,0)), 
@CantidadUnidad             = ISNULL(d.CantidadUnidad, 0), 
@DescripcionPosicion        = ISNULL(ap.Descripcion,''),
@PosicionDestino            = d.PosicionDestino,
@DescripcionPosicionDestino = ISNULL(apd .Descripcion,''),
@Posicion                   = d.Posicion,
@Tipo                       = ap.Tipo,
@Unidad                     = ISNULL(d.Unidad, '') 
FROM TMA t
JOIN TMAD d ON t.ID = d.ID
JOIN ArtDisponibleTarima a ON d.Tarima = a.Tarima AND t.Empresa = a.Empresa AND a.Almacen = d.Almacen
JOIN AlmPos ap  ON ap.Posicion = d.Posicion AND d.Almacen = ap.Almacen
JOIN AlmPos apd ON apd.Posicion = d.PosicionDestino AND apd.Almacen = d.Almacen
JOIN MovTipo mt ON mt.Mov = t.Mov AND Modulo = 'TMA'
WHERE  t.Empresa = @Empresa
AND d.Tarima = @Tarima
AND t.mov = @Mov
AND t.MovID = @MovID
SELECT @Codigo = ISNULL(Codigo,'')
FROM CB
WHERE Cuenta = @Articulo
SELECT @Disponible = Disponible
FROM ArtDisponibleTarima
WHERE Articulo = @Articulo
AND Tarima = @Tarima
AND Empresa = @Empresa
SELECT @Tipo = Tipo
FROM AlmPos
WHERE Posicion = @Posicion
IF @Ok IS NULL
INSERT @Tabla(Folio, Tarima, Posicion, Tipo, Articulo,
Cantidad, CantidadUnidad, Unidad, DescripcionPosicion, PosicionDestino,
DescripcionPosicionDestino, Codigo)
SELECT ISNULL(@MovID,''), ISNULL(@Tarima,''), ISNULL(@Posicion,''), ISNULL(@Tipo,''), ISNULL(@Articulo,''),
ISNULL(CONVERT(varchar,@Cantidad),''), ISNULL(CONVERT(varchar,@CantidadUnidad),''), ISNULL(CONVERT(varchar,@Unidad),''), ISNULL(@DescripcionPosicion,''), ISNULL(@PosicionDestino,''),
ISNULL(@DescripcionPosicionDestino,''), ISNULL(@Codigo,'')
SELECT @Texto = ISNULL((SELECT * FROM @Tabla TMA
FOR XML AUTO), '')
IF @@ERROR <> 0 SET @Ok = 1
SELECT @ReferenciaIS = Referencia
FROM IntelisisService
WHERE ID = @ID
IF @@ERROR <> 0 SET @Ok = 1
IF @Ok IS NOT NULL SELECT @OkRef = Descripcion FROM MensajeLista WHERE Mensaje = @Ok
SELECT @Resultado = '<?xml version="1.0" encoding="windows-1252"?><Intelisis Sistema="Intelisis" Contenido="Resultado" Referencia=' + CHAR(34) + ISNULL(@ReferenciaIS,'') + CHAR(34) + ' SubReferencia=' + CHAR(34) + ISNULL(@SubReferencia,'') + CHAR(34) + ' Version=' + CHAR(34) + ISNULL(CONVERT(varchar ,@Version),'') + CHAR(34) + '><Resultado IntelisisServiceID=' + CHAR(34) + ISNULL(CONVERT(varchar,@ID),'')  + CHAR(34)  + ' Ok=' + CHAR(34) + ISNULL(CONVERT(varchar,@Ok),'') + CHAR(34) + ' OkRef=' + CHAR(34) + ISNULL(@OkRef,'') + CHAR(34) + '>' + CONVERT(varchar(max),@Texto) + '</Resultado></Intelisis>'
IF @@ERROR <> 0 SET @Ok = 1
END

