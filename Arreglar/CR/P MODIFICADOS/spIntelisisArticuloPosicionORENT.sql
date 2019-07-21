SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spIntelisisArticuloPosicionORENT
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
@Descripcion1			    varchar(150), 
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
Posicion						varchar(10),
ArticuloEsp					varchar(20),
Descripcion1			        varchar(150), 
Unidad     					varchar(50),
Cantidad						varchar(100)
)
SELECT  @Sucursal2  = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Sucursal'
SELECT  @Empresa  = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Empresa'
SELECT  @Tarima  = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Tarima'
SELECT  @Posicion  = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Posicion'
SELECT  @Usuario = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Usuario'
SELECT  @Montacargas = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Montacarga'
SELECT @Agente = DefAgente, @Almacen=DefAlmacen, @Sucursal=Sucursal FROM Usuario WITH(NOLOCK) WHERE Usuario = @Usuario
SELECT @Cantidad = Disponible FROM ArtDisponibleTarima WITH(NOLOCK) WHERE Tarima = @Tarima AND Almacen = @Almacen AND Empresa = @Empresa
IF @Cantidad <= 0 BEGIN
SELECT @Ok=13250
END
SET @ArticuloEsp=''
SELECT @ArticuloEsp = isnull(b.Articulo,'') FROM Tarima a  WITH(NOLOCK)
INNER JOIN ArtDisponibleTarima b  WITH(NOLOCK) ON a.Tarima = b.Tarima
WHERE a.Almacen = @Almacen AND a.Estatus = 'ALTA' AND a.Posicion = @Posicion
IF @ArticuloEsp='' Select @Ok=13030
SELECT @Factor = dbo.fnArtUnidadFactor(@Empresa, @ArticuloEsp, UnidadTraspaso),
@Minimo = MinimoTarima,
@Unidad = UnidadTraspaso,
@Descripcion1=a.Descripcion1+' CB:' + ISNULL(c.Codigo,'')+
'-CAPACIDAD:'+CONVERT(varchar, ISNULL(a.CantidadPresentacion, 0))+ ' '+ ISNULL(a.Presentacion, '')
FROM Art a
 WITH(NOLOCK) JOIN CB c  WITH(NOLOCK) ON c.Cuenta = a.Articulo
WHERE a.Articulo = @ArticuloEsp
/*AND c.CodigoPrincipal=1*/
SELECT @Cantidad=@Cantidad / @Factor
IF @Ok IS NULL
INSERT @Tabla(Posicion, ArticuloEsp, Descripcion1, Unidad, Cantidad)
SELECT ISNULL(@Posicion,''), ISNULL(@ArticuloEsp,''), ISNULL(@Descripcion1,''), ISNULL(@Unidad,''), ISNULL(@Cantidad,'')
SELECT @Texto =(SELECT * FROM @Tabla TMA
FOR XML AUTO)
IF @Ok IS NULL AND @Texto IS NULL 
SELECT @Ok = 14055, @OkRef='' 
IF @Ok IS NOT NULL SELECT @Descripcion = Descripcion FROM MensajeLista WITH(NOLOCK) WHERE Mensaje = @Ok
SELECT @Resultado = '<?xml version="1.0" encoding="windows-1252"?><Intelisis Sistema="Intelisis" Contenido="Resultado" Referencia=' + CHAR(34) + ISNULL(@ReferenciaIS,'') + CHAR(34) + ' SubReferencia=' + CHAR(34) + ISNULL(@SubReferencia,'') + CHAR(34) + ' Version=' + CHAR(34) + ISNULL(CONVERT(varchar ,@Version),'') + CHAR(34) + '><Resultado IntelisisServiceID=' + CHAR(34) + ISNULL(CONVERT(varchar,@ID),'')  + CHAR(34)  + ' Ok=' + CHAR(34) + ISNULL(CONVERT(varchar,@Ok),'') + CHAR(34) + ' OkRef=' + CHAR(34) + ISNULL(@OkRef,'') + CHAR(34) + ' Descripcion="' + ISNULL(@Descripcion,'') +'">' + CONVERT(varchar(max),ISNULL(@Texto,'')) + '</Resultado></Intelisis>'
IF @@ERROR <> 0 SET @Ok = 1
END

