SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE speCommerceSolicitudISListaPreciosSubUnidad
@Lista				varchar(20),
@Moneda				varchar(10),
@Articulo			varchar(20),
@SubCuenta			varchar(50),
@Unidad			varchar(50),
@Sucursal           int,
@eCommerceSucursal  varchar(10),
@Estatus			varchar(10),
@Ok			int = NULL OUTPUT,
@OkRef	 		varchar(255) = NULL OUTPUT

AS BEGIN
DECLARE
@ID		   int,
@Usuario     varchar(10),
@IDAcceso    int,
@Estacion    int,
@Contrasena  varchar(32),
@DropBox     varchar(255),
@Ruta        varchar(255),
@Empresa     varchar(5),
@xml         varchar(max),
@xml2        varchar(max),
@Resultado   varchar(max),
@Solicitud   varchar(max),
@Archivo     varchar(max),
@eCommerceOffLine bit
SELECT @eCommerceOffLine = ISNULL(eCommerceOffLine,0) FROM Sucursal WHERE Sucursal = @Sucursal
SELECT @Usuario = WebUsuario, @DropBox = DirSFTP  FROM WebVersion
SELECT @Ruta = @DropBox + '\' + @eCommerceSucursal
IF @eCommerceOffLine = 1
SELECT @Ruta = @DropBox + '\' + @eCommerceSucursal+'\OffLine'
SELECT @Contrasena = Contrasena FROM Usuario WHERE Usuario = @Usuario
SELECT @Estacion = @@SPID
SELECT @Solicitud = '<?xml version="1.0" encoding="windows-1252"?><Intelisis Sistema="Intelisis" Contenido="Solicitud" Referencia="Intelisis.eCommerce.ListaPreciosSubUnidad" SubReferencia="ListaPreciosSubUnidad" Version="1.0"><Solicitud> <ListaPreciosSubUnidad Lista="'+ISNULL(CONVERT(varchar,@Lista),'')+'" Moneda="'+ISNULL(CONVERT(varchar,@Moneda),'')+'" Articulo="'+ISNULL(CONVERT(varchar,@Articulo),'')+'" SubCuenta="'+ISNULL(CONVERT(varchar,@SubCuenta),'')+'" Unidad="'+ISNULL(CONVERT(varchar,@Unidad),'')+'" Sucursal="'+ISNULL(CONVERT(varchar,@Sucursal),'')+'" eCommerceSucursal="'+ISNULL(@eCommerceSucursal,'')+'" Estatus="'+ISNULL(@Estatus,'')+'" Empresa="'+ISNULL(@Empresa,'')+'" />  </Solicitud> </Intelisis>'
EXEC spIntelisisService @Usuario, @Contrasena, @Solicitud, @Resultado OUTPUT, @Ok OUTPUT, @OkRef OUTPUT, 1, 0, @ID OUTPUT
IF @ID IS NOT NULL AND @Ok IS NULL
BEGIN
SELECT @Archivo = @Ruta+'\IE_'+CONVERT(varchar,@ID)+'.xml'
IF @Ok IS NULL
EXEC spRegenerarArchivo @Archivo, @Resultado, @Ok OUTPUT,@OkRef OUTPUT
END
END

