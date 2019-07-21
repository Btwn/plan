SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE speCommerceSolicitudISExistenciaSucursal
@Inicial	bit = 0,
@Ok			int = NULL OUTPUT,
@OkRef	 		varchar(255) = NULL OUTPUT

AS BEGIN
DECLARE
@Usuario     varchar(10),
@ID          int,
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
@Sucursal    int,
@eCommerceSucursal      varchar(10),
@eCommerceOffLine bit
SELECT @Usuario = WebUsuario, @DropBox = DirSFTP  FROM WebVersion
SELECT @Contrasena = Contrasena FROM Usuario WHERE Usuario = @Usuario
SELECT @Estacion = @@SPID
IF(@Inicial = 1)
BEGIN
INSERT eCommerceSaldoU(Articulo, SubCuenta)
SELECT a.Articulo,ISNULL(a.SubCuenta ,'')
FROM WebArt a LEFT OUTER JOIN eCommerceSaldoU u ON a.Articulo = u.Articulo AND ISNULL(a.SubCuenta,'')=u.Subcuenta
WHERE u.Articulo IS NULL AND a.Articulo IS NOT NULL
GROUP BY a.Articulo,a.SubCuenta
INSERT eCommerceSaldoU(Articulo, SubCuenta)
SELECT a.Articulo,ISNULL(a.SubCuenta ,'')
FROM WebArtVariacionCombinacion a LEFT OUTER JOIN eCommerceSaldoU u ON a.Articulo = u.Articulo AND ISNULL(a.SubCuenta,'')=u.Subcuenta
WHERE u.Articulo IS NULL AND a.Articulo IS NOT NULL
GROUP BY a.Articulo,a.SubCuenta
END
TRUNCATE TABLE eCommerceExistenciaSucursal
INSERT eCommerceExistenciaSucursal(Articulo,   SubCuenta,   Inventario,   SKU,   Situacion,   Sucursal)
SELECT                             a.Articulo, a.SubCuenta, SUM(a.Inventario), a.SKU, dbo.fnWebArtEstausExistencia(SKU, Sucursal) Situacion, a.Sucursal
FROM WebArtExistenciaSucursal a JOIN eCommerceSaldoU e ON a.Articulo = e.Articulo AND ISNULL(a.SubCuenta,'') = ISNULL(e.SubCuenta,'')
GROUP BY a.Sucursal, a.Articulo, a.SubCuenta, a.SKU, Situacion
IF EXISTS(SELECT * FROM Sucursal WHERE eCommerce = 1 AND NULLIF(eCommerceSucursal,'') IS NOT NULL)
BEGIN
DECLARE crSucursal CURSOR local FOR
SELECT Sucursal, eCommerceSucursal
FROM Sucursal
WHERE eCommerce = 1 AND NULLIF(eCommerceSucursal,'') IS NOT NULL
OPEN crSucursal
FETCH NEXT FROM crSucursal INTO @Sucursal, @eCommerceSucursal
WHILE @@FETCH_STATUS = 0 AND @Ok IS NULL
BEGIN
SELECT @eCommerceOffLine = ISNULL(eCommerceOffLine,0), @eCommerceSucursal = eCommerceSucursal FROM Sucursal WHERE Sucursal = @Sucursal
SELECT @Ruta = @DropBox + '\' + @eCommerceSucursal
IF @eCommerceOffLine = 1
SELECT @Ruta = @DropBox + '\' + @eCommerceSucursal+'\OffLine'
IF EXISTS(SELECT * FROM eCommerceExistenciaSucursal)
BEGIN
SELECT @Solicitud = '<?xml version="1.0" encoding="windows-1252"?><Intelisis Sistema="Intelisis" Contenido="Solicitud" Referencia="Intelisis.eCommerce.ExistenciaSucursal" SubReferencia="ExistenciaSucursal" Version="1.0"><Solicitud> <ExistenciaSucursal  Sucursal="'+ISNULL(CONVERT(varchar,@Sucursal),'')+'" eCommerceSucursal="'+ISNULL(@eCommerceSucursal,'')+'" />  </Solicitud> </Intelisis>'
EXEC spIntelisisService @Usuario, @Contrasena, @Solicitud, @Resultado OUTPUT, @Ok OUTPUT, @OkRef OUTPUT, 1, 0, @ID OUTPUT
IF @ID IS NOT NULL AND @Ok IS NULL
BEGIN
SELECT @Archivo = @Ruta+'\IE_'+CONVERT(varchar,@ID)+'.xml'
IF @Ok IS NULL
EXEC spRegenerarArchivo @Archivo, @Resultado, @Ok OUTPUT,@OkRef OUTPUT
END
END
FETCH NEXT FROM crSucursal INTO @Sucursal, @eCommerceSucursal
END
CLOSE crSucursal
DEALLOCATE crSucursal
END
IF @Ok IS NULL
DELETE   eCommerceSaldoU
END

