SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spIntelisisWMSOSURMovListado
@ID                           int,
@iSolicitud                   int,
@Version                      float,
@Resultado                    varchar(max) = NULL OUTPUT,
@Ok                           int = NULL OUTPUT,
@OkRef                        varchar(255) = NULL OUTPUT

AS BEGIN
DECLARE
@Texto                        xml,
@ReferenciaIS                 varchar(100),
@SubReferencia                varchar(100),
@Mov                          varchar(20),
@MovID                        varchar(20),
@Empresa                      varchar(5),
@Sucursal                     int,
@Completo                     int,
@Sucursal2                    varchar(100),
@Articulo                     varchar(20),
@Cantidad                     float,
@Unidad                       varchar(20),
@Descripcion                  varchar(100),
@Movimiento                   varchar(20),
@Clave                        varchar(20)
DECLARE @Tabla Table(
Tarima                        varchar(20),
Articulo                      varchar(20),
Cantidad                      varchar(100),
Descripcion                   varchar(100),
Posicion                      varchar(10),
DescripcionPosicion           varchar(100),
PosicionDestino               varchar(10),
DescripcionPosicionDestino    varchar(100),
Mov                           varchar(20),
Folio                         varchar(20),
Unidad                        varchar(20),
ArtCambioClave                varchar(20)
)
SELECT @Sucursal2 = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Sucursal'
SELECT @Empresa = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Empresa'
SELECT @Completo = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Completo'
SELECT @Movimiento = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Movimiento'
SELECT @MovID = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'MovID'
SELECT @Sucursal = Sucursal
FROM Sucursal WITH(NOLOCK)
WHERE Nombre = @Sucursal2
SELECT @Clave = Clave
FROM MovTipo WITH(NOLOCK)
WHERE Modulo = 'TMA'
AND Mov = @Movimiento
IF @Completo = 1
SELECT @Mov = TMAOrdenSurtido FROM EmpresaCfgMovWMS WITH(NOLOCK) WHERE Empresa = @Empresa
IF @Completo = 0
BEGIN
IF @Clave IN('TMA.OPCKTARIMA')
SELECT @Mov = TMAOrdenPCKTarima FROM EmpresaCfgMovWMS WITH(NOLOCK) WHERE Empresa = @Empresa
ELSE
SELECT @Mov = TMAOrdenSurtidoPCK FROM EmpresaCfgMovWMS WITH(NOLOCK) WHERE Empresa = @Empresa
END
INSERT @Tabla(Tarima, Articulo, Cantidad, Descripcion, Posicion, DescripcionPosicion, PosicionDestino, DescripcionPosicionDestino, Mov, Folio, Unidad, ArtCambioClave)
SELECT d.Tarima,
a.Articulo,
CONVERT(varchar,ISNULL(d.CantidadPicking/ISNULL(dbo.fnArtUnidadFactor(@Empresa, a.Articulo, d.Unidad),1) ,0)),
aa.Descripcion1,
d.Posicion,
ISNULL(ap.Descripcion,''),
d.PosicionDestino,
ISNULL(apd .Descripcion,''),
t.Mov,
t.MovID,
d.Unidad,
LTRIM(RTRIM(ISNULL(d.ArtCambioClave,'')))
FROM TMAD d  WITH(NOLOCK) JOIN TMA t  WITH(NOLOCK) ON t.ID = d.ID
JOIN MovTipo m  WITH(NOLOCK) ON m.Mov = t.Mov AND m.Modulo = 'TMA'
JOIN ArtDisponibleTarima a  WITH(NOLOCK) ON a.Tarima = d.Tarima AND d.Almacen = a.Almacen AND a.Empresa = t.Empresa
JOIN Art aa  WITH(NOLOCK) ON a.Articulo = aa.Articulo
JOIN AlmPos ap  WITH(NOLOCK) ON ap.Posicion = d.Posicion AND d.Almacen = ap.Almacen
JOIN AlmPos apd  WITH(NOLOCK) ON apd.Posicion = d.PosicionDestino AND apd.Almacen = d.Almacen
WHERE t.Mov = @Mov
AND t.MovID = @MovID
AND t.Empresa = @Empresa
AND t.Sucursal = @Sucursal
AND t.Estatus IN('PENDIENTE', 'CONCLUIDO') 
/*
SELECT TOP 1 @Unidad=d.Unidad 
FROM TMAD d  WITH(NOLOCK) JOIN TMA  t  WITH(NOLOCK) ON t.ID = d.ID
JOIN MovTipo m  WITH(NOLOCK) ON m.Mov = t.Mov AND m.Modulo = 'TMA'
JOIN ArtDisponibleTarima a  WITH(NOLOCK) ON a.Tarima = d.Tarima
JOIN Art aa  WITH(NOLOCK) ON a.Articulo = aa.Articulo
JOIN AlmPos ap  WITH(NOLOCK) ON ap.Posicion = d.Posicion AND d.Almacen = ap.Almacen
JOIN AlmPos apd  WITH(NOLOCK) ON apd.Posicion = d.PosicionDestino AND apd.Almacen = d.Almacen
WHERE  t.Mov = @Mov
AND t.MovID = @MovID
AND t.Empresa = @Empresa
AND t.Sucursal = @Sucursal
AND t.Estatus IN('PENDIENTE', 'CONCLUIDO')
*/
DECLARE crPendiente CURSOR FOR
SELECT a.Articulo, ISNULL(SUM(ISNULL(d.CantidadPicking/ISNULL(dbo.fnArtUnidadFactor(@Empresa, a.Articulo, d.Unidad),1), 0)), 0) 
FROM TMAD d  WITH(NOLOCK) JOIN TMA  t  WITH(NOLOCK) ON t.ID = d.ID
JOIN MovTipo m  WITH(NOLOCK) ON m.Mov = t.Mov AND m.Modulo = 'TMA'
JOIN ArtDisponibleTarima a  WITH(NOLOCK) ON a.Tarima = d.Tarima AND a.Almacen = d.Almacen AND a.Empresa = t.Empresa
JOIN Art aa  WITH(NOLOCK) ON a.Articulo = aa.Articulo
JOIN AlmPos ap  WITH(NOLOCK) ON ap.Posicion = d.Posicion AND d.Almacen = ap.Almacen
JOIN AlmPos apd  WITH(NOLOCK) ON apd.Posicion = d.PosicionDestino AND apd.Almacen = d.Almacen
WHERE t.origen = @Mov
AND t.origenid = @MovID
AND t.Empresa = @Empresa
AND t.Sucursal = @Sucursal
and t.estatus IN ('PROCESAR', 'CONCLUIDO')
GROUP BY a.Articulo, d.Unidad
OPEN crPendiente
FETCH NEXT FROM crPendiente  INTO @Articulo, @Cantidad
WHILE @@FETCH_STATUS = 0 
BEGIN
UPDATE @Tabla
SET Cantidad = (Cantidad - @Cantidad)
WHERE Articulo = @Articulo
FETCH NEXT FROM crPendiente  INTO @Articulo, @Cantidad
END
CLOSE crPendiente
DEALLOCATE crPendiente
SELECT @Texto = (SELECT * FROM @Tabla TMA WHERE CONVERT(float, Cantidad) > 0.0 ORDER BY Posicion FOR XML AUTO)
IF @Texto IS NULL
SELECT @Ok = 14055, @OkRef = 'TMA'
IF @@ERROR <> 0 SET @Ok = 1
SELECT @ReferenciaIS = Referencia
FROM IntelisisService WITH(NOLOCK)
WHERE ID = @ID
IF @@ERROR <> 0 SET @Ok = 1
IF @Ok IS NOT NULL SELECT @Descripcion = Descripcion FROM MensajeLista WITH(NOLOCK) WHERE Mensaje = @Ok
SELECT @Resultado = '<?xml version="1.0" encoding="windows-1252"?><Intelisis Sistema="Intelisis" Contenido="Resultado" Referencia=' + CHAR(34) + ISNULL(@ReferenciaIS,'') + CHAR(34) + ' SubReferencia=' + CHAR(34) + ISNULL(@SubReferencia,'') + CHAR(34) + ' Version=' + CHAR(34) + ISNULL(CONVERT(varchar ,@Version),'') + CHAR(34) + '><Resultado IntelisisServiceID=' + CHAR(34) + ISNULL(CONVERT(varchar,@ID),'')  + CHAR(34)  + ' Ok=' + CHAR(34) + ISNULL(CONVERT(varchar,@Ok),'') + CHAR(34) + ' OkRef=' + CHAR(34) + ISNULL(@OkRef,'') + CHAR(34) + ' Descripcion="' + ISNULL(@Descripcion,'') +'">' + CONVERT(varchar(max),ISNULL(@Texto,'')) + '</Resultado></Intelisis>'
IF @@ERROR <> 0 SET @Ok = 1
END

