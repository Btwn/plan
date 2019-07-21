SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spIntelisisRADOPck_MovListado
@ID				int,
@iSolicitud		int,
@Version		float,
@Resultado		varchar(max) = NULL OUTPUT,
@Ok				int = NULL OUTPUT,
@OkRef			varchar(255) = NULL OUTPUT

AS BEGIN
DECLARE
@Texto						xml,
@ReferenciaIS				varchar(100),
@SubReferencia				varchar(100),
@Mov						varchar(20),
@MovID			            varchar(20),
@Empresa				    varchar(5),
@Sucursal			        int,
@Sucursal2					varchar(100),
@Tarima						varchar(20),
@Posicion					varchar(10),
@ArticuloEsp			    varchar(20),
@Descripcion1			    varchar(100),
@UnidadCompra				varchar(50),
@Cantidad			        float,
@Tipo						varchar(20),
@Disponible				    float,
@DescripcionPosicion		varchar(100),
@PosicionDestino			varchar(10),
@DescripcionPosicionDestino varchar(100)  ,
@Completo                   int,
@Codigo					    varchar(50),
@Descripcion			    varchar(100),
@Almacen                    VARCHAR(20),
@Usuario			        varchar(20),
@Factor FLOAT,
@Unidad VARCHAR(20),
@Minimo FLOAT,
@Agente VARCHAR(20),
@PosicionD					varchar(10),
@Montacargas                varchar(20),
@IDAcceso					int,
@Estacion					int
SELECT @Estacion=@@SPID 
DECLARE  @Tabla Table(
Tarima                        varchar(20),
Posicion						varchar(10),
FechaCaducidad                datetime,
Disponible   				    varchar(100),
Cantidad						varchar(100),
Unidad     					varchar(50)
)
SELECT  @Sucursal2  = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Sucursal'
SELECT  @Empresa  = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Empresa'
SELECT  @ArticuloEsp  = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'ArticuloEsp'
SELECT  @Posicion  = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Posicion'
SELECT  @Usuario  = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Usuario'
SELECT @Agente = DefAgente, @Almacen=DefAlmacen, @Sucursal=Sucursal FROM Usuario WITH(NOLOCK) WHERE Usuario = @Usuario
IF (SELECT COUNT(*) FROM TMA a WITH(NOLOCK)
INNER JOIN TMAD b WITH(NOLOCK) ON a.ID = b.ID
INNER JOIN MovTipo m  WITH(NOLOCK) ON m.Mov = a.Mov AND m.Modulo = 'TMA'
WHERE m.Clave IN ('TMA.OADO','TMA.ORADO','TMA.SADO','TMA.SRADO')
AND a.Estatus = 'PENDIENTE' AND (b.Posicion = @Posicion) AND a.Almacen = @Almacen
AND ISNULL(b.Procesado, 0) = 0
) > 0
BEGIN
SELECT @Ok=13077
END
IF @Ok IS NULL
BEGIN
INSERT @Tabla(Posicion, Tarima, FechaCaducidad, Disponible, Cantidad, Unidad /*, DescripcionPosicion*/)
SELECT b.Posicion, a.Tarima, b.FechaCaducidad, a.Disponible, a.Disponible/d.Factor AS Cantidad, c.UnidadCompra AS Unidad /*, ISNULL(ap.Descripcion,'')*/
FROM ArtdisponibleTarima a WITH(NOLOCK)
INNER JOIN Tarima b WITH(NOLOCK) ON a.Tarima = b.Tarima AND a.Almacen = b.Almacen
INNER JOIN Art c  WITH(NOLOCK) ON a.Articulo = c.Articulo
INNER JOIN ArtUnidad d  WITH(NOLOCK) ON d.Articulo = a.Articulo AND d.Unidad = c.UnidadCompra
INNER JOIN AlmPos ap  WITH(NOLOCK) ON ap.Almacen = a.Almacen AND ap.Posicion = b.Posicion
WHERE a.Articulo = @ArticuloEsp AND ap.Tipo = 'Ubicacion' AND b.Estatus = 'ALTA'
AND a.Disponible > 0 AND a.Almacen = @Almacen
ORDER BY a.Tarima
END
SELECT @Texto =(SELECT ISNULL(Tarima, '') 'Tarima', ISNULL(Posicion, '') 'Posicion', ISNULL(FechaCaducidad, '') 'FechaCaducidad', ISNULL(Disponible, '') 'Disponible', ISNULL(Cantidad, '') 'Cantidad', ISNULL(Unidad, '') 'Unidad' FROM @Tabla FOR XML AUTO)
IF @Ok IS NULL AND @Texto IS NULL 
SELECT @Ok = 14055, @OkRef='' 
IF @Ok IS NOT NULL SELECT @Descripcion = Descripcion FROM MensajeLista WITH(NOLOCK) WHERE Mensaje = @Ok
SELECT @Resultado = '<?xml version="1.0" encoding="windows-1252"?><Intelisis Sistema="Intelisis" Contenido="Resultado" Referencia=' + CHAR(34) + ISNULL(@ReferenciaIS,'') + CHAR(34) + ' SubReferencia=' + CHAR(34) + ISNULL(@SubReferencia,'') + CHAR(34) + ' Version=' + CHAR(34) + ISNULL(CONVERT(varchar ,@Version),'') + CHAR(34) + '><Resultado IntelisisServiceID=' + CHAR(34) + ISNULL(CONVERT(varchar,@ID),'')  + CHAR(34)  + ' Ok=' + CHAR(34) + ISNULL(CONVERT(varchar,@Ok),'') + CHAR(34) + ' OkRef=' + CHAR(34) + ISNULL(@OkRef,'') + CHAR(34) + ' Descripcion="' + ISNULL(@Descripcion,'') +'">' + CONVERT(varchar(max),ISNULL(@Texto,'')) + '</Resultado></Intelisis>'
IF @@ERROR <> 0 SET @Ok = 1
END

