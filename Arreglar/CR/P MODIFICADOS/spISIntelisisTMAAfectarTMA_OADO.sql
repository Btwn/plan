SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spISIntelisisTMAAfectarTMA_OADO
@ID				int,
@iSolicitud		int,
@Version		float,
@Resultado		varchar(max) = NULL OUTPUT,
@Ok				int = NULL OUTPUT,
@OkRef			varchar(255) = NULL OUTPUT

AS BEGIN
DECLARE
@IDGenerar					int,
@IDAcceso					int,
@MovTipo					varchar(20),
@ReferenciaIS				varchar(100),
@Usuario2					varchar(10),
@Estacion					int,
@SubReferencia				varchar(100),
@Empresa   				    varchar(5),
@Mov   					    varchar(20),
@MovID   					varchar(20),
@Sucursal                   int,
@ID2                        int,
@Tarima                     varchar(20),
@Sucursal2                  varchar(100),
@Posicion                   varchar(20),
@PosicionDestino            varchar(20),
@Usuario                    varchar(15),
@Montacargas                varchar(20),
@Estatus                    varchar(20),
@Agente                     varchar(20),
@Modificar                  bit,
@Procesado                  bit,
@Mov2  					    varchar(20),
@Mov3  					    varchar(20),
@MovID2   					varchar(20),
@PosicionDGenerar           varchar(20),
@Descripcion                varchar(100),
@CantidadParcial            float, 
@ArticuloEsp			    varchar(20),
@Factor                     FLOAT,
@Unidad                     VARCHAR(20),
@Almacen                    VARCHAR(20),
@Disponible				    float, 
@PosicionDestinoOrigen      varchar(20), 
@RequiereMontacarga         int 
BEGIN TRANSACTION
SELECT @Estacion=@@SPID 
IF @Ok IS NULL
BEGIN
SELECT  @Empresa = NULLIF(Empresa,'')FROM openxml (@iSolicitud,'/Intelisis/Solicitud/TMA')
WITH(Empresa    varchar(255))
SELECT  @MovID = NULLIF(MovID,'')FROM openxml (@iSolicitud,'/Intelisis/Solicitud/TMA')
WITH(MovID    varchar(255))
SELECT  @Mov= NULLIF(Mov,'')FROM openxml (@iSolicitud,'/Intelisis/Solicitud/TMA')
WITH(Mov    varchar(255))
SELECT  @Tarima = NULLIF(Tarima,'')FROM openxml (@iSolicitud,'/Intelisis/Solicitud/TMA')
WITH(Tarima   varchar(255))
SELECT  @Posicion = NULLIF(Posicion,'')FROM openxml (@iSolicitud,'/Intelisis/Solicitud/TMA')
WITH(Posicion   varchar(255))
SELECT  @PosicionDestino = NULLIF(PosicionDestino,'')FROM openxml (@iSolicitud,'/Intelisis/Solicitud/TMA')
WITH(PosicionDestino   varchar(255))
SELECT  @Usuario = NULLIF(Usuario,'')FROM openxml (@iSolicitud,'/Intelisis/Solicitud/TMA')
WITH(Usuario   varchar(255))
SELECT  @Sucursal2 = NULLIF(Sucursal,'')FROM openxml (@iSolicitud,'/Intelisis/Solicitud/TMA')
WITH(Sucursal   varchar(255))
SELECT  @Montacargas = NULLIF(Montacarga,'')FROM openxml (@iSolicitud,'/Intelisis/Solicitud/TMA')
WITH(Montacarga   varchar(255))
SELECT  @CantidadParcial = ISNULL(CONVERT(float, CantidadParcial),0) FROM openxml (@iSolicitud,'/Intelisis/Solicitud/TMA')
WITH(CantidadParcial   varchar(255))
END
SELECT @Disponible = 0 
SELECT @Agente = DefAgente, @Almacen=DefAlmacen, @Sucursal = Sucursal FROM Usuario WITH (NOLOCK) WHERE Usuario = @Usuario
SELECT @RequiereMontacarga=ISNULL(RequiereMontacarga,0) FROM MapeoMovMovil WITH (NOLOCK) WHERE Modulo='TMA' AND Mov=@Mov 
SELECT @Modificar = ISNULL(ModificarPosicionSugeridaWMS,0) FROM Usuario WITH (NOLOCK) WHERE Usuario = @Usuario 
SELECT @MovTipo = Clave FROM MovTipo WITH (NOLOCK) WHERE Mov = @Mov AND Modulo = 'TMA'
SELECT @Sucursal = Sucursal FROM Sucursal WITH (NOLOCK) WHERE Nombre = @Sucursal2
IF @MovTipo NOT IN ('TMA.ORADO','TMA.OADO') SELECT @Ok = 35005, @OkRef = @Mov
IF @Ok IS NULL
BEGIN
IF @Ok IS NULL AND NOT EXISTS(SELECT * FROM TMA t WITH (NOLOCK) JOIN TMAD d WITH (NOLOCK) ON t.ID = d. ID  WHERE  d.Tarima = @Tarima  AND t.Empresa = @Empresa AND t.Sucursal = @Sucursal AND t.Mov=@Mov AND t.MovID= @MovID) SELECT @Ok = 13110 
IF @Ok IS NULL AND NOT EXISTS(SELECT * FROM Montacarga WITH (NOLOCK) WHERE Montacarga = @Montacargas) AND @RequiereMontacarga=1 SELECT @Ok = 20948 
END
IF @Ok IS NULL
BEGIN
IF NOT EXISTS(SELECT * FROM TMA t WITH (NOLOCK) JOIN TMAD d WITH (NOLOCK) ON t.ID = d. ID  WHERE  d.Tarima = @Tarima AND d.PosicionDestino = @PosicionDestino AND t.Empresa = @Empresa AND t.Mov=@Mov AND t.MovID= @MovID AND t.Sucursal = @Sucursal)
BEGIN
IF @Modificar=0 SELECT @Ok = 71027
END
END
IF @Ok IS NULL
BEGIN
SELECT @ID2 = ID FROM TMA WITH (NOLOCK) WHERE Empresa = @Empresa AND Sucursal = @Sucursal AND Mov = @Mov AND MovID = @MovID
SELECT @Estatus = Estatus FROM TMA WITH (NOLOCK) WHERE ID = @ID2
SELECT @Procesado = ISNULL(Procesado, 0) FROM TMAD WITH (NOLOCK) WHERE ID = @ID2 AND Tarima = @Tarima
SET @ArticuloEsp=''
SELECT @ArticuloEsp = ISNULL(b.Articulo,'') FROM Tarima a WITH (NOLOCK)
INNER JOIN ArtDisponibleTarima b WITH (NOLOCK) ON a.Tarima = b.Tarima
WHERE a.Almacen = @Almacen AND a.Estatus = 'ALTA' AND a.Posicion = @PosicionDestino
IF @Ok IS NULL AND @ArticuloEsp='' AND @CantidadParcial>0 Select @Ok=13030
IF @Ok IS NULL
IF NOT EXISTS(SELECT ISNULL(Posicion,'') FROM AlmPos WITH (NOLOCK) WHERE Posicion=@PosicionDestino) SET @Ok=13030
SELECT @Factor = dbo.fnArtUnidadFactor(@Empresa, @ArticuloEsp, UnidadTraspaso),
@Unidad = UnidadTraspaso
FROM Art a WITH (NOLOCK)
WHERE a.Articulo = @ArticuloEsp
UPDATE TMAD WITH (ROWLOCK)
SET CantidadA = 1,
PosicionDestino = @PosicionDestino 
WHERE Tarima = @Tarima  AND ID = @ID2
IF @Ok IS NULL AND @Estatus = 'Pendiente' AND @MovTipo = 'TMA.OADO'
BEGIN
SELECT @Mov3 = TMAAcomodo FROM EmpresaCfgMovWMS WITH (NOLOCK) WHERE Empresa = @Empresa
EXEC @IDGenerar =  spAfectar 'TMA', @ID2, 'GENERAR', 'Seleccion', @Mov3, @Usuario, @Estacion,@EnSilencio = 1, @Conexion = 1, @Ok = @Ok OUTPUT , @OkRef = @OkRef OUTPUT
IF @Ok BETWEEN 80030 AND 81000 SELECT @Ok = NULL , @OkRef = NULL
SELECT @Agente = DefAgente FROM Usuario WITH (NOLOCK) WHERE Usuario = @Usuario
IF @Agente IS NULL SELECT @Ok = 20930
UPDATE TMA WITH (ROWLOCK) SET Montacarga = @Montacargas , Agente = @Agente
WHERE ID = @IDGenerar
IF @Ok IS NULL
EXEC spAfectar 'TMA', @IDGenerar, 'AFECTAR', 'Todo', NULL, @Usuario, @Estacion,@EnSilencio = 1, @Conexion = 1, @Ok = @Ok OUTPUT ,@OkRef = @OkRef OUTPUT
IF @Ok BETWEEN 80030 AND 81000 SELECT @Ok = NULL , @OkRef = NULL
END
IF @Ok IS NULL AND @Estatus = 'Pendiente' AND @MovTipo = 'TMA.ORADO'
BEGIN
SELECT @Mov3 = TMAReacomodo FROM EmpresaCfgMovWMS WITH (NOLOCK) WHERE Empresa = @Empresa
EXEC @IDGenerar =  spAfectar 'TMA', @ID2, 'GENERAR', 'Seleccion', @Mov3, @Usuario, @Estacion,@EnSilencio = 1, @Conexion = 1, @Ok = @Ok OUTPUT , @OkRef = @OkRef OUTPUT
IF @Ok BETWEEN 80030 AND 81000 SELECT @Ok = NULL , @OkRef = NULL
SELECT @Agente = DefAgente FROM Usuario WITH (NOLOCK) WHERE Usuario = @Usuario
IF @Agente IS NULL SELECT @Ok = 20930
IF @Ok IS NULL AND @CantidadParcial>0
BEGIN
UPDATE TMAD WITH (ROWLOCK)
SET CantidadPicking=@CantidadParcial*@Factor, CantidadUnidad=@CantidadParcial
WHERE Tarima = @Tarima  AND ID = @IDGenerar
END
UPDATE TMA WITH (ROWLOCK) SET Montacarga = @Montacargas , Agente = @Agente
WHERE ID = @IDGenerar
IF @Ok IS NULL
EXEC spAfectar 'TMA', @IDGenerar, 'AFECTAR', 'Todo', NULL, @Usuario, @Estacion,@EnSilencio = 1, @Conexion = 1, @Ok = @Ok OUTPUT ,@OkRef = @OkRef OUTPUT
IF @Ok BETWEEN 80030 AND 81000 SELECT @Ok = NULL , @OkRef = NULL
IF @Ok IS NULL AND @CantidadParcial>0
BEGIN
SELECT @Disponible = ISNULL(b.Disponible,0) FROM Tarima a WITH (NOLOCK)
INNER JOIN ArtDisponibleTarima b WITH (NOLOCK) ON a.Tarima = b.Tarima
WHERE a.Almacen = @Almacen
AND a.Estatus = 'ALTA'
AND a.Tarima=@Tarima
END
END
IF @Ok IS NULL
SELECT @ReferenciaIS = Referencia
FROM IntelisisService WITH (NOLOCK)
WHERE ID = @ID
SELECT @Mov2='', @MovID2='', @PosicionDGenerar='', @Descripcion=''
IF @Ok IS NULL
BEGIN
SELECT @Mov2 = isnull(Mov,'') , @MovID2 = isnull(MovID,'') FROM TMA WITH (NOLOCK) WHERE ID = @IDGenerar
SELECT @PosicionDGenerar = isnull(PosicionDestino,'')  FROM TMAD WITH (NOLOCK) WHERE ID = @IDGenerar
SELECT @Descripcion = isnull(Descripcion,'') FROM AlmPos WITH (NOLOCK) WHERE Posicion = @PosicionDGenerar
END
END
IF @@ERROR <> 0 SET @Ok = 1
IF @Ok IS NOT NULL SELECT @OkRef = REPLACE(Descripcion, '<BR>', '') FROM MensajeLista WITH (NOLOCK) WHERE Mensaje = @Ok
IF @Ok IS NULL
BEGIN
IF (SELECT Estatus FROM TMA WITH (NOLOCK) WHERE ID = @IDGenerar) = 'SINAFECTAR'
SELECT @Ok = -1
ELSE
SELECT @OkRef = RTRIM(Mov)+' '+RTRIM(MovID) FROM TMA WITH (NOLOCK) WHERE ID = @IDGenerar
END
SET @Resultado = '<?xml version="1.0" encoding="windows-1252"?><Intelisis Sistema="Intelisis" Contenido="Resultado" Referencia=' + CHAR(34) + ISNULL(@ReferenciaIS,'') + CHAR(34) + ' SubReferencia=' + CHAR(34) + ISNULL(@SubReferencia,'') + CHAR(34) + ' Version=' + CHAR(34) + ISNULL(CONVERT(varchar ,@Version),'') + CHAR(34) + '><Resultado IntelisisServiceID=' + CHAR(34) + ISNULL(CONVERT(varchar,@ID),'') + CHAR(34) + ' Modulo="TMA" ModuloID =' + CHAR(34) + ISNULL(CONVERT(varchar,@IDGenerar),'') + CHAR(34) +'  Mov=' + CHAR(34) + ISNULL(@Mov2,'') + CHAR(34) +'  MovID=' + CHAR(34) + ISNULL(@MovID2,'') + CHAR(34)  +'  PosicionDestino=' + CHAR(34) + ISNULL(@PosicionDGenerar,'') + CHAR(34) +'  DescripcionPosicionDestino=' + CHAR(34) + ISNULL(@Descripcion,'') + CHAR(34) + '  Disponible=' + CHAR(34) + ISNULL(CONVERT(varchar,@Disponible),'') + CHAR(34) + ' Ok=' + CHAR(34) + ISNULL(CONVERT(varchar,@Ok),'') + CHAR(34) + ' OkRef=' + CHAR(34) + ISNULL(@OkRef,'') + CHAR(34) + '/></Intelisis>'
IF @Ok IS NULL OR @Ok = -1
BEGIN
COMMIT TRANSACTION
END ELSE
BEGIN
ROLLBACK TRANSACTION
END
END

