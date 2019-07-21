SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spISIntelisisTMAAfectarTMA_ORENT
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
@Estacion					int,
@Mov2  					    varchar(20),
@Mov3  					    varchar(20),
@MovID2   					varchar(20),
@Modulo2                    varchar(5)
BEGIN TRANSACTION
SELECT @Estacion=@@SPID 
DECLARE  @Tabla Table(
Posicion						varchar(10),
ArticuloEsp					varchar(20),
Descripcion1			        varchar(100),
UnidadCompra					varchar(50),
Cantidad						varchar(100),
DescripcionPosicion			varchar(100)
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
SELECT  @PosicionD  = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'PosicionD'
SELECT  @Usuario = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Usuario'
SELECT  @Montacargas = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Montacarga'
SELECT  @Cantidad = ISNULL(CONVERT(float, Valor),0) FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH(Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Cantidad'
SELECT @Agente = DefAgente, @Almacen=DefAlmacen, @Sucursal = Sucursal FROM Usuario WHERE Usuario = @Usuario
IF @Cantidad <= 0 BEGIN
SELECT @Ok=13250
END
SET @ArticuloEsp=''
SELECT @ArticuloEsp = isnull(b.Articulo,'') FROM Tarima a /*WITH(NOLOCK)*/
INNER JOIN ArtDisponibleTarima b /*WITH(NOLOCK)*/ ON a.Tarima = b.Tarima
WHERE a.Almacen = @Almacen AND a.Estatus = 'ALTA' AND a.Posicion = @Posicion
IF @Ok IS NULL AND @ArticuloEsp='' Select @Ok=13030
IF @Ok IS NULL
IF NOT EXISTS(SELECT ISNULL(Posicion,'') FROM AlmPos WHERE Posicion=@Posicion) SET @Ok=13030
SELECT @Factor = dbo.fnArtUnidadFactor(@Empresa, @ArticuloEsp, UnidadTraspaso),
@Minimo = MinimoTarima,
@Unidad = UnidadTraspaso,
@Descripcion1=a.Descripcion1
FROM Art a
WHERE a.Articulo = @ArticuloEsp
IF @Ok IS NULL
BEGIN
INSERT INTO TMA (Empresa, Mov, FechaEmision, Usuario, Referencia, Estatus, Sucursal, Almacen, Agente,
Montacarga, Prioridad, SucursalOrigen, SucursalDestino)
SELECT @Empresa, 'Orden Re-Entarimado', dbo.fnFechaSinHora(getdate()), @Usuario, 'Solicitud desde IntelisisMobile','SINAFECTAR',
@Sucursal, @Almacen, @Agente, @Montacargas, 'Normal', @Sucursal, @Sucursal
SET @ID = @@IDENTITY
INSERT INTO TMAD (ID, Renglon, Tarima, Almacen, Posicion, PosicionDestino, Sucursal, Prioridad, Montacarga, Unidad, CantidadUnidad, CantidadPicking)
SELECT @ID, 0, @Tarima, @Almacen, @Posicion, @PosicionD, @Sucursal,'Normal',@Agente,@Unidad, @Cantidad, @Cantidad*@Factor
CREATE TABLE #MovR
(Folio VARCHAR(255) NULL, Descripcion VARCHAR(255) NULL,Tipo VARCHAR(20) NULL, Valor VARCHAR(255) NULL, ID INT NULL)
INSERT INTO #MovR
EXEC spAfectar 'TMA', @ID, 'AFECTAR', 'Todo', NULL, @Usuario, @Estacion, @EnSilencio = 1, @Conexion = 1, @Ok = @Ok OUTPUT ,@OkRef = @OkRef OUTPUT
IF @Ok BETWEEN 80030 AND 81000 SELECT @Ok = NULL , @OkRef = NULL
END
IF @Ok IS NULL
SELECT @ReferenciaIS = Referencia
FROM IntelisisService
WHERE ID = @ID
SELECT @Mov2='', @MovID2='', @Descripcion='', @Modulo2=''
IF @Ok IS NULL
BEGIN
SELECT @Mov2=mv2.DMov, @MovID2=mv2.DMovid, @Modulo2=mv2.DModulo
FROM MovFlujo mv1, MovFlujo mv2
WHERE mv1.OModulo='TMA'
AND mv1.OMov='Orden Re-Entarimado'
AND mv1.OId=@ID
AND mv2.OModulo=mv1.DModulo
AND mv2.OMov=mv1.DMov
AND mv2.OId=mv1.DId
END
IF @@ERROR <> 0 SET @Ok = 1
IF @Ok IS NOT NULL SELECT @OkRef = REPLACE(Descripcion, '<BR>', '') FROM MensajeLista WHERE Mensaje = @Ok
IF @Ok IS NULL
BEGIN
IF (SELECT Estatus FROM TMA WHERE ID = @ID) = 'SINAFECTAR'
SELECT @Ok = -1
ELSE
SELECT @OkRef = RTRIM(@Mov2)+' '+RTRIM(@MovID2)
END
SELECT @Resultado = '<?xml version="1.0" encoding="windows-1252"?><Intelisis Sistema="Intelisis" Contenido="Resultado" Referencia=' + CHAR(34) + ISNULL(@ReferenciaIS,'') + CHAR(34) + ' SubReferencia=' + CHAR(34) + ISNULL(@SubReferencia,'') + CHAR(34) + ' Version=' + CHAR(34) + ISNULL(CONVERT(varchar ,@Version),'') + CHAR(34) + '><Resultado IntelisisServiceID=' + CHAR(34) + ISNULL(CONVERT(varchar,@ID),'')  + CHAR(34)  + ' Ok=' + CHAR(34) + ISNULL(CONVERT(varchar,@Ok),'') + CHAR(34) + ' OkRef=' + CHAR(34) + ISNULL(@OkRef,'') + CHAR(34) + ' Descripcion="' + ISNULL(@Descripcion,'') +'">' + CONVERT(varchar(max),ISNULL(@Texto,'')) + '</Resultado></Intelisis>'
IF @Ok IS NULL OR @Ok = -1
BEGIN
COMMIT TRANSACTION
END ELSE
BEGIN
ROLLBACK TRANSACTION
END
END

