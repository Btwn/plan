SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spIntelisisWMSInfoPesoTarima
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
@PosicionDestino            varchar(20),
@Usuario                    varchar(15),
@Montacargas                varchar(20),
@Estatus                    varchar(20),
@Agente                     varchar(20),
@Modificar                  bit,
@Procesado                  bit,
@Mov2  					    varchar(20),
@MovID2   					varchar(20),
@PosicionDGenerar           varchar(20),
@Descripcion                varchar(100),
@Movimiento					varchar(20),
@Tipo						varchar(20),
@TarimaSurtido              varchar(20), 
@PesoTarimaCalculado        float,
@Texto				        xml    
DECLARE @Tabla table(
PesoTarima   float)
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
SELECT  @PosicionDestino = NULLIF(PosicionDestino,'')FROM openxml (@iSolicitud,'/Intelisis/Solicitud/TMA')
WITH(PosicionDestino   varchar(255))
SELECT  @Usuario = NULLIF(Usuario,'')FROM openxml (@iSolicitud,'/Intelisis/Solicitud/TMA')
WITH(Usuario   varchar(255))
SELECT  @Sucursal2 = NULLIF(Sucursal,'')FROM openxml (@iSolicitud,'/Intelisis/Solicitud/TMA')
WITH(Sucursal   varchar(255))
SELECT  @Montacargas = NULLIF(Montacarga,'')FROM openxml (@iSolicitud,'/Intelisis/Solicitud/TMA')
WITH(Montacarga   varchar(255))
END
SELECT @MovTipo = Clave FROM MovTipo WITH(NOLOCK) WHERE Mov = @Mov AND Modulo = 'TMA'
SELECT @Sucursal = Sucursal FROM Sucursal WITH(NOLOCK) WHERE Nombre = @Sucursal2
SELECT @ID2=t.ID, @MovID = t.MovID, @Mov=t.Mov FROM TMA t  WITH(NOLOCK) JOIN TMAD d   WITH(NOLOCK) ON t.ID = d.ID WHERE t.Empresa = @Empresa AND d.Tarima = @Tarima AND t.Mov = @Mov AND t.MovID = @MovID
IF @MovTipo NOT IN ('TMA.TSUR') SELECT @Ok = 35005, @OkRef = @Mov
IF @Ok IS NULL
BEGIN
IF NOT EXISTS(SELECT * FROM Montacarga WITH(NOLOCK) WHERE Montacarga = @Montacargas) SELECT @Ok = 20936
IF NOT EXISTS(SELECT * FROM TMA t  WITH(NOLOCK) JOIN TMAD d  WITH(NOLOCK) ON t.ID = d. ID  WHERE  d.Tarima = @Tarima  AND t.Empresa = @Empresa AND t.Mov=@Mov AND t.MovID= @MovID) SELECT @Ok = 13110
IF NOT EXISTS(SELECT * FROM TMA t  WITH(NOLOCK) JOIN TMAD d  WITH(NOLOCK) ON t.ID = d. ID  WHERE  d.Tarima = @Tarima AND d.PosicionDestino = @PosicionDestino AND t.Empresa = @Empresa AND t.Mov=@Mov AND t.MovID= @MovID) SELECT @Ok = 13035
END
IF @Ok IS NULL
INSERT INTO @Tabla   SELECT dbo.fnTarimaPeso(@ID2, @Tarima)
SELECT @Texto =(SELECT CONVERT(varchar,PesoTarima) PesoTarima FROM @Tabla
FOR XML AUTO)
IF @@ERROR <> 0 SET @Ok = 1
BEGIN
SELECT @ReferenciaIS = Referencia
FROM IntelisisService
WITH(NOLOCK) WHERE ID = @ID
IF @@ERROR <> 0 SET @Ok = 1
IF @Ok IS NOT NULL SELECT @OkRef = Descripcion FROM MensajeLista WITH(NOLOCK) WHERE Mensaje = @Ok
SELECT @Resultado = '<?xml version="1.0" encoding="windows-1252"?><Intelisis Sistema="Intelisis" Contenido="Resultado" Referencia=' + CHAR(34) + ISNULL(@ReferenciaIS,'') + CHAR(34) + ' SubReferencia=' + CHAR(34) + ISNULL(@SubReferencia,'') + CHAR(34) + ' Version=' + CHAR(34) + ISNULL(CONVERT(varchar ,@Version),'') + CHAR(34) + '><Resultado IntelisisServiceID=' + CHAR(34) + ISNULL(CONVERT(varchar,@ID),'')  + CHAR(34)  + ' Ok=' + CHAR(34) + ISNULL(CONVERT(varchar,@Ok),'') + CHAR(34) + ' OkRef=' + CHAR(34) + ISNULL(@OkRef,'') + CHAR(34) +  '>' + CONVERT(varchar(max),ISNULL(@Texto,'')) + '</Resultado></Intelisis>'      
IF @@ERROR <> 0 SET @Ok = 1
END
END

