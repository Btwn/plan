SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spISeCommerceWebArtExistencia
@ID			int,
@iSolicitud		int,
@Version		float,
@Resultado		varchar(max) = NULL OUTPUT,
@Ok			int = NULL OUTPUT,
@OkRef			varchar(255) = NULL OUTPUT

AS BEGIN
SET NOCOUNT ON
DECLARE
@Sucursal             int,
@eCommerceSucursal    varchar(10),
@SKU                  varchar(255),
@ReferenciaIS         varchar(100),
@Articulo             varchar(20),
@SubCuenta            varchar(50),
@Tipo                 varchar(50),
@Estacion             int,
@Tabla                varchar(max)
SELECT @Estacion = @@SPID
SELECT @Sucursal = Sucursal,
@eCommerceSucursal = eCommerceSucursal,
@SKU = SKU
FROM OPENXML (@iSolicitud,'/Intelisis/Solicitud/WebArtExistencia')
WITH (Sucursal int, eCommerceSucursal  varchar(10), SKU varchar(255))
IF @SKU LIKE 'IDCO#%'
SELECT   @Tipo = 'Combinacion'
IF @SKU LIKE 'ID#%'
SELECT   @Tipo = 'WebArt'
IF @Tipo = 'Combinacion'
SELECT @Articulo = Articulo, @SubCuenta = ISNULL(SubCuenta,'')
FROM WebArtVariacionCombinacion WHERE ID = dbo.fnWebArtSKU (@SKU)
IF @Tipo = 'WebArt'
SELECT @Articulo = Articulo, @SubCuenta = ISNULL(SubCuenta,'')
FROM WebArt WHERE ID = dbo.fnWebArtSKU (@SKU)
IF @Tipo IS NULL
SELECT @Articulo = Cuenta, @SubCuenta = ISNULL(SubCuenta,'')
FROM CB WHERE Codigo= @SKU
SELECT @Tabla = ISNULL(@Tabla,'') + (SELECT '<WebArtExistencia  '+ 'Articulo='+CHAR(34)+RTRIM(LTRIM(Articulo))+CHAR(34)+' SKU='+CHAR(34)+@SKU+CHAR(34)+' Cantidad='+CHAR(34)+CONVERT(varchar,ISNULL(SUM(Inventario),0.0))+CHAR(34)++' Sucursal='+CHAR(34)+CONVERT(varchar,Sucursal)+CHAR(34)+' />'
FROM ArtSubExistenciaInv
WHERE Articulo = @Articulo AND ISNULL(SubCuenta,'') = ISNULL(@SubCuenta,'') GROUP BY Sucursal,Articulo,SubCuenta  )
EXEC spContactoDireccionHorizontal @Estacion,'Sucursal',@Sucursal,@Sucursal,0,0,0,0
SELECT @ReferenciaIS = Referencia
FROM IntelisisService
WHERE ID = @ID
SELECT @Resultado = '<?xml version="1.0" encoding="windows-1252"?><Intelisis Sistema="Intelisis" Contenido="Resultado" Referencia=' + CHAR(34) + ISNULL(@ReferenciaIS,'') + CHAR(34) + ' SubReferencia="WebArtExistencia" Version=' + CHAR(34) + ISNULL(CONVERT(varchar ,@Version),'') + CHAR(34) + '><Resultado IntelisisServiceID=' + CHAR(34) + ISNULL(CONVERT(varchar,@ID),'')  + CHAR(34)  + ' Ok=' + CHAR(34) + ISNULL(CONVERT(varchar,@Ok),'') + CHAR(34) + ' OkRef=' + CHAR(34) + ISNULL(@OkRef,'') + CHAR(34)+ ' Sucursal=' + CHAR(34) + ISNULL(CONVERT(varchar,@Sucursal),'') + CHAR(34)+' eCommerceSucursal=' + CHAR(34) + ISNULL(@eCommerceSucursal,'') + CHAR(34)+' >' +ISNULL(@Tabla ,'')+'</Resultado></Intelisis>'
END

