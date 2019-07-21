SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE speCommerceSolicitudISWebMovSituacion
@OrigenID               int,
@Modulo                 varchar(5),
@ModuloID               int,
@Estatus                varchar(15),
@Sucursal               int,
@eCommerceSucursal      varchar(20),
@Ok			int = NULL OUTPUT,
@OkRef	 		varchar(255) = NULL OUTPUT

AS BEGIN
DECLARE
@Usuario     varchar(10),
@ID          int,
@IDAcceso    int,
@Estacion    int,
@Mov         varchar(20),
@MovID       varchar(20),
@OrigenMov   varchar(20),
@OrigenMovID varchar(20),
@Contrasena  varchar(32),
@DropBox     varchar(255),
@Ruta        varchar(255),
@Empresa     varchar(5),
@Situacion   varchar(50),
@SituacioneCcommerce    varchar(50),
@IDSituacioneCcommerce  int,
@xml                    varchar(max),
@xml2                   varchar(max),
@Resultado              varchar(max),
@Solicitud              varchar(max),
@Archivo                varchar(max),
@eCommerceOffLine bit
SELECT @eCommerceOffLine = ISNULL(eCommerceOffLine,0) FROM Sucursal WHERE Sucursal = @Sucursal
SELECT @Usuario = WebUsuario, @DropBox = DirSFTP  FROM WebVersion
SELECT @OrigenMov = Mov, @OrigenMovID = MovID, @Empresa = Empresa FROM Venta WHERE ID = @OrigenID
EXEC spMovInfo2  @ModuloID, @Modulo, @Sucursal OUTPUT, @Mov OUTPUT, @MovID OUTPUT, @Situacion OUTPUT
SELECT @IDSituacioneCcommerce  = se.SituacionEcomerce ,@SituacioneCcommerce = s.Nombre
FROM WebSituacionEstatus se LEFT  WITH(NOLOCK) JOIN WebSituacion s  WITH(NOLOCK) ON se.SituacionEcomerce = s.ID
WHERE Modulo = @Modulo AND Mov = @Mov AND Estatus = @Estatus AND Situacion = ISNULL(@Situacion,'')
SELECT @Ruta = @DropBox + '\' + @eCommerceSucursal
IF @eCommerceOffLine = 1
SELECT @Ruta = @DropBox + '\' + @eCommerceSucursal+'\OffLine'
SELECT @Contrasena = Contrasena FROM Usuario WITH(NOLOCK) WHERE Usuario = @Usuario
SELECT @Estacion = @@SPID
SELECT @Solicitud = '<?xml version="1.0" encoding="windows-1252"?><Intelisis Sistema="Intelisis" Contenido="Solicitud" Referencia="Intelisis.eCommerce.WebMovSituacion" SubReferencia="WebMovSituacion" Version="1.0"><Solicitud><WebMovSituacion IDOrigen="'+ISNULL(CONVERT(varchar,@OrigenID),'')+'" OrigenMov="'+ISNULL(@OrigenMov,'')+'" OrigenMovID="'+ISNULL(@OrigenMovID,'')+'" Modulo="'+ISNULL(@Modulo,'')+'" Mov="'+ISNULL(@Mov,'')+'" MovID="'+ISNULL(@MovID,'')+'" Sucursal="'+ISNULL(CONVERT(varchar,@Sucursal),'')+'" eCommerceSucursal="'+ISNULL(@eCommerceSucursal,'')+'" Estatus="'+ISNULL(@Estatus,'')+'" Situacion="'+ISNULL(@Situacion,'')+'" SituacionID="'+ISNULL(CONVERT(varchar,@IDSituacioneCcommerce),'') +'" SituacioneCommerce="'+ISNULL(@SituacioneCcommerce,'')+'"  Empresa="'+ISNULL(@Empresa,'')+'" />  </Solicitud> </Intelisis>'
EXEC spIntelisisService @Usuario, @Contrasena, @Solicitud, @Resultado OUTPUT, @Ok OUTPUT, @OkRef OUTPUT, 1, 0, @ID OUTPUT
IF @ID IS NOT NULL AND @Ok IS NULL
BEGIN
SELECT @Archivo = @Ruta+'\IE_'+CONVERT(varchar,@ID)+'.xml'
IF @Ok IS NULL
EXEC spRegenerarArchivo @Archivo, @Resultado, @Ok OUTPUT,@OkRef OUTPUT
END
END

