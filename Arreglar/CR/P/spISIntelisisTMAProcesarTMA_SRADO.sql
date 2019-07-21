SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spISIntelisisTMAProcesarTMA_SRADO
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
@Articulo    			    varchar(20),
@Descripcion1			    varchar(100),
@UnidadCompra				varchar(50),
@Cantidad			        float,
@Tipo						varchar(20),
@Disponible				    float,
@DescripcionPosicion		varchar(100),
@PosicionDestino			varchar(10),
@DescripcionPosicionDestino varchar(100),
@Completo                   int,
@Codigo					    varchar(50),
@Descripcion			    varchar(100),
@Almacen                    VARCHAR(20),
@Usuario			        varchar(20),
@Factor                     FLOAT,
@Unidad                     VARCHAR(20),
@Minimo                     FLOAT,
@Agente                     VARCHAR(20),
@PosicionD					varchar(10),
@Montacargas                varchar(20),
@IDAcceso					int,
@Estacion					int,
@MovOrigen			        varchar(20),
@MovIDOrigen		        varchar(20),
@IDOrigen			        int,
@Mov2  					    varchar(20),
@Mov3  					    varchar(20),
@MovID2   					varchar(20),
@IDDestino			        int
BEGIN TRANSACTION
SELECT @Estacion=@@SPID 
SELECT  @Empresa = NULLIF(Empresa,'')FROM openxml (@iSolicitud,'/Intelisis/Solicitud/TMA')
WITH(Empresa    varchar(255))
SELECT  @Sucursal = NULLIF(Sucursal,'')FROM openxml (@iSolicitud,'/Intelisis/Solicitud/TMA')
WITH(Sucursal    varchar(255))
SELECT  @Usuario = NULLIF(Usuario,'')FROM openxml (@iSolicitud,'/Intelisis/Solicitud/TMA')
WITH(Usuario   varchar(255))
SELECT  @MovID = NULLIF(MovID,'') FROM openxml (@iSolicitud,'/Intelisis/Solicitud/TMA')
WITH(MovID    varchar(255))
SELECT  @Mov= NULLIF(Mov,'')FROM openxml (@iSolicitud,'/Intelisis/Solicitud/TMA')
WITH(Mov    varchar(255))
SELECT  @Tarima = NULLIF(Tarima,'')FROM openxml (@iSolicitud,'/Intelisis/Solicitud/TMA')
WITH(Tarima   varchar(255))
SELECT  @Posicion = NULLIF(Posicion,'')FROM openxml (@iSolicitud,'/Intelisis/Solicitud/TMA')
WITH(Posicion   varchar(255))
SELECT  @Articulo  = Articulo FROM openxml (@iSolicitud,'/Intelisis/Solicitud/TMA')
WITH(Articulo   varchar(255))
SELECT @Agente = DefAgente, @Almacen=DefAlmacen, @Sucursal=Sucursal FROM Usuario WHERE Usuario = @Usuario
IF NULLIF(RTRIM(@Articulo), '') IS NULL
SELECT @Articulo = Articulo FROM ArtDisponibleTarima WHERE Tarima = @Tarima AND Almacen = @Almacen
IF (SELECT COUNT(*) FROM TMA a /*WITH(NOLOCK)*/
INNER JOIN TMAD b /*WITH(NOLOCK)*/ ON a.ID = b.ID
INNER JOIN MovTipo m ON m.Mov = a.Mov AND m.Modulo = 'TMA'
WHERE m.Clave IN (/*'TMA.OADO',*/'TMA.ORADO',/*'TMA.SADO',*/'TMA.SRADO')
AND a.Estatus = 'PENDIENTE' AND
b.PosicionDestino IN(SELECT Posicion FROM AlmPos WHERE Almacen=@Almacen AND ArticuloEsp=@Articulo AND Tipo='Domicilio') AND a.Almacen = @Almacen
AND ISNULL(b.Procesado, 0) = 0
) > 0
BEGIN
SELECT @Ok=13077
END
IF @OK IS NULL
BEGIN
SELECT @IDOrigen = ID FROM TMA WHERE Empresa = @Empresa AND Sucursal = @Sucursal AND Mov = @Mov AND MovID = @MovID
EXEC spISTMAGenerarTMA_SRADO  @IDOrigen,  @Empresa, @Sucursal, @Usuario, @Tarima, @Posicion, @Articulo, @IDDestino OUTPUT, @Ok OUTPUT , @OkRef OUTPUT
END
IF @Ok IS NULL AND @IDDestino IS NULL
SELECT @Ok = 13125, @OkRef=@Articulo
IF @Ok IS NULL
SELECT @ReferenciaIS = Referencia
FROM IntelisisService
WHERE ID = @IDDestino
SELECT @Mov2='', @MovID2=''
IF @Ok IS NULL
BEGIN
SELECT @Mov2 = isnull(Mov,'') , @MovID2 = isnull(MovID,'') FROM TMA WHERE ID = @IDDestino
END
IF @@ERROR <> 0 SET @Ok = 1
IF @Ok IS NOT NULL SELECT @OkRef = REPLACE(Descripcion, '<BR>', '') FROM MensajeLista WHERE Mensaje = @Ok
IF @Ok IS NULL
BEGIN
IF (SELECT Estatus FROM TMA WHERE ID = @IDDestino) = 'SINAFECTAR'
SELECT @Ok = -1
ELSE
SELECT @OkRef = RTRIM(Mov)+' '+RTRIM(MovID) FROM TMA WHERE ID = @IDDestino
END
IF @Ok IS NOT NULL SELECT @Descripcion = Descripcion FROM MensajeLista WHERE Mensaje = @Ok
SELECT @Resultado = '<?xml version="1.0" encoding="windows-1252"?><Intelisis Sistema="Intelisis" Contenido="Resultado" Referencia=' + CHAR(34) + ISNULL(@ReferenciaIS,'') + CHAR(34) + ' SubReferencia=' + CHAR(34) + ISNULL(@SubReferencia,'') + CHAR(34) + ' Version=' + CHAR(34) + ISNULL(CONVERT(varchar ,@Version),'') + CHAR(34) + '><Resultado IntelisisServiceID=' + CHAR(34) + ISNULL(CONVERT(varchar,@ID),'')  + CHAR(34)  + ' Ok=' + CHAR(34) + ISNULL(CONVERT(varchar,@Ok),'') + CHAR(34) + ' OkRef=' + CHAR(34) + ISNULL(@OkRef,'') + CHAR(34) + ' Descripcion="' + ISNULL(@Descripcion,'') +'">' + CONVERT(varchar(max),ISNULL(@Texto,'')) + '</Resultado></Intelisis>'
IF @@ERROR <> 0 SET @Ok = 1
IF @Ok IS NULL OR @Ok = -1
BEGIN
COMMIT TRANSACTION
END ELSE
BEGIN
ROLLBACK TRANSACTION
END
END

