SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spIntelisisWMSInfoTarimasSurtidoP
@ID				int,
@iSolicitud		int,
@Version		float,
@Resultado		varchar(max) = NULL OUTPUT,
@Ok				int = NULL OUTPUT,
@OkRef			varchar(255) = NULL OUTPUT

AS BEGIN
DECLARE
@Texto				xml,
@ReferenciaIS		varchar(100),
@SubReferencia		varchar(100),
@Tarima                    varchar(20),
@Posicion                  varchar(10)
DECLARE
@Tabla Table(
Tarima                    varchar(20),
Articulo                  varchar(20),
Cantidad                  varchar(100),
Unidad                    varchar(20),
Posicion                  varchar(10),
DescripcionPosicion       varchar(100),
PosicionDestino           varchar(10),
DescripcionPosicionDestino  varchar(100)
)
SELECT  @Tarima  = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Tarima'
INSERT @Tabla(Tarima,Articulo,    Cantidad,     Unidad,   Posicion,DescripcionPosicion, PosicionDestino,DescripcionPosicionDestino)
SELECT d.Tarima,a.Articulo,CONVERT(varchar, a.Disponible),aa.UnidadCompra,d.Posicion,ISNULL(ap.Descripcion,''),    d.PosicionDestino,ISNULL(apd .Descripcion,'')
FROM TMAD d  WITH(NOLOCK) JOIN TMA  t  WITH(NOLOCK) ON t.ID = d.ID
JOIN MovTipo m  WITH(NOLOCK) ON m.Mov = t.Mov AND m.Modulo = 'TMA'
JOIN ArtDisponibleTarima a  WITH(NOLOCK) ON a.Tarima = d.Tarima
JOIN Art aa  WITH(NOLOCK) ON a.Articulo = aa.Articulo
JOIN AlmPos ap  WITH(NOLOCK) ON ap.Posicion = d.Posicion
JOIN AlmPos apd  WITH(NOLOCK) ON apd.Posicion = d.PosicionDestino
WHERE  t.Estatus = 'PENDIENTE'
AND  m.Clave='TMA.OSUR'
AND m.SubClave='TMA.OSURP'
AND d.CantidadA IN (NULL,0)
AND (d.Procesado is null or d.Procesado = 0)
AND d.Tarima = ISNULL(@Tarima,d.Tarima)
SELECT @Texto =(SELECT * FROM @Tabla TMA
FOR XML AUTO)
IF @@ERROR <> 0 SET @Ok = 1
BEGIN
SELECT @ReferenciaIS = Referencia
FROM IntelisisService
WITH(NOLOCK) WHERE ID = @ID
IF @@ERROR <> 0 SET @Ok = 1
IF @Ok IS NOT NULL SELECT @OkRef = Descripcion FROM MensajeLista WITH(NOLOCK) WHERE Mensaje = @Ok
BEGIN
SELECT @Resultado = '<?xml version="1.0" encoding="windows-1252"?><Intelisis Sistema="Intelisis" Contenido="Resultado" Referencia=' + CHAR(34) + ISNULL(@ReferenciaIS,'') + CHAR(34) + ' SubReferencia=' + CHAR(34) + ISNULL(@SubReferencia,'') + CHAR(34) + ' Version=' + CHAR(34) + ISNULL(CONVERT(varchar ,@Version),'') + CHAR(34) + '><Resultado IntelisisServiceID=' + CHAR(34) + ISNULL(CONVERT(varchar,@ID),'')  + CHAR(34)  + ' Ok=' + CHAR(34) + ISNULL(CONVERT(varchar,@Ok),'') + CHAR(34) + ' OkRef=' + CHAR(34) + ISNULL(@OkRef,'') + CHAR(34) + '>' + CONVERT(varchar(max),@Texto) + '</Resultado></Intelisis>'
IF @@ERROR <> 0 SET @Ok = 1
END
END
END

