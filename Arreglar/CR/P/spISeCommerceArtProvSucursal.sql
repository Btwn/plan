SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spISeCommerceArtProvSucursal
@ID			int,
@iSolicitud		int,
@Version		float,
@Resultado		varchar(max) = NULL OUTPUT,
@Ok			int = NULL OUTPUT,
@OkRef			varchar(255) = NULL OUTPUT

AS BEGIN
DECLARE
@Articulo			varchar(20),
@SubCuenta			varchar(50),
@Proveedor			varchar(10),
@SucursalDestino		int,
@Estatus				varchar(10),
@Empresa              varchar(5),
@Sucursal             int,
@eCommerceSucursal    varchar(10),
@ReferenciaIS         varchar(100),
@Tabla                varchar(max) ,
@Resultado2			varchar(max)
SELECT @Empresa = Empresa,
@Articulo = Articulo,
@SubCuenta = SubCuenta,
@Proveedor = Proveedor,
@SucursalDestino = SucursalDestino,
@Sucursal = Sucursal,
@eCommerceSucursal = eCommerceSucursal,
@Estatus = Estatus
FROM OPENXML (@iSolicitud,'/Intelisis/Solicitud/ArtProvSucursal')
WITH (Empresa varchar(5),  Sucursal int, eCommerceSucursal  varchar(10), Estatus varchar(10), Articulo varchar(20), SubCuenta varchar(50), Proveedor varchar(10), SucursalDestino int)
SELECT @ReferenciaIS = Referencia
FROM IntelisisService
WHERE ID = @ID
IF @Estatus IN ('ALTA','CAMBIO')
SELECT @Tabla = '<ArtProvSucursal '+(SELECT
' Articulo="'+ISNULL(dbo.fneWebConvertirDescripcionHTML(CONVERT(varchar(1000),ArtProvSucursal.Articulo)),'')+'"'+
' SubCuenta="'+ISNULL(dbo.fneWebConvertirDescripcionHTML(CONVERT(varchar(1000),ArtProvSucursal.SubCuenta)),'')+'"'+
' Proveedor="'+ISNULL(dbo.fneWebConvertirDescripcionHTML(CONVERT(varchar(1000),ArtProvSucursal.Proveedor)),'')+'"'+
' Sucursal="'+ISNULL(dbo.fneWebConvertirDescripcionHTML(CONVERT(varchar(1000),ArtProvSucursal.Sucursal)),'')+'"'+
' CostoAutorizado="'+ISNULL(dbo.fneWebConvertirDescripcionHTML(CONVERT(varchar(1000),ArtProvSucursal.CostoAutorizado)),'')+'"'+
' UltimoCosto="'+ISNULL(dbo.fneWebConvertirDescripcionHTML(CONVERT(varchar(1000),ArtProvSucursal.UltimoCosto)),'')+'"'+
' UltimaCompra="'+ISNULL(dbo.fneWebConvertirDescripcionHTML(CONVERT(varchar(1000),ArtProvSucursal.UltimaCompra)),'')+'"'+
' CompraMinimaCantidad="'+ISNULL(dbo.fneWebConvertirDescripcionHTML(CONVERT(varchar(1000),ArtProvSucursal.CompraMinimaCantidad)),'')+'"'+
' CompraMinimaImporte="'+ISNULL(dbo.fneWebConvertirDescripcionHTML(CONVERT(varchar(1000),ArtProvSucursal.CompraMinimaImporte)),'')+'"'+
' Multiplos="'+ISNULL(dbo.fneWebConvertirDescripcionHTML(CONVERT(varchar(1000),ArtProvSucursal.Multiplos)),'')+'"'+
' DiasRespuesta="'+ISNULL(dbo.fneWebConvertirDescripcionHTML(CONVERT(varchar(1000),ArtProvSucursal.DiasRespuesta)),'')+'"'+
' UltimaCotizacion="'+ISNULL(dbo.fneWebConvertirDescripcionHTML(CONVERT(varchar(1000),ArtProvSucursal.UltimaCotizacion)),'')+'"'+
' FechaCotizacion="'+ISNULL(dbo.fneWebConvertirDescripcionHTML(CONVERT(varchar(1000),ArtProvSucursal.FechaCotizacion)),'')+'"'+
' />' FROM ArtProvSucursal ArtProvSucursal WHERE  Articulo = @Articulo AND SubCuenta = @SubCuenta AND Proveedor = @Proveedor AND Sucursal = @SucursalDestino)
ELSE   SELECT @Tabla = ''
SELECT @Resultado2 = '<?xml version="1.0" encoding="windows-1252"?><Intelisis Sistema="Intelisis" Contenido="Resultado" Referencia=' + CHAR(34) + ISNULL(@ReferenciaIS,'') + CHAR(34) + ' SubReferencia="ArtProvSucursal" Version=' + CHAR(34) + ISNULL(CONVERT(varchar ,@Version),'') + CHAR(34) + '><Resultado IntelisisServiceID=' + CHAR(34) + ISNULL(CONVERT(varchar,@ID),'')  + CHAR(34)  + ' Ok=' + CHAR(34) + ISNULL(CONVERT(varchar,@Ok),'') + CHAR(34) + ' OkRef=' + CHAR(34) + ISNULL(@OkRef,'') + CHAR(34) +' Empresa=' + CHAR(34) + ISNULL(@Empresa,'') + CHAR(34)+ ' Sucursal=' + CHAR(34) + ISNULL(CONVERT(varchar,@Sucursal),'') + CHAR(34)+' eCommerceSucursal=' + CHAR(34) + ISNULL(@eCommerceSucursal,'') + CHAR(34)+ ' Estatus=' + CHAR(34) + ISNULL(@Estatus,'') + CHAR(34) +' Articulo=' + CHAR(34) + ISNULL(CONVERT(varchar,@Articulo),'') + CHAR(34) +' SubCuenta=' + CHAR(34) + ISNULL(CONVERT(varchar,@SubCuenta),'') + CHAR(34) +' Proveedor=' + CHAR(34) + ISNULL(CONVERT(varchar,@Proveedor),'') + CHAR(34) +' SucursalDestino=' + CHAR(34) + ISNULL(CONVERT(varchar,@SucursalDestino),'') + CHAR(34) +' >'
SELECT @Resultado = @Resultado2+ISNULL(@Tabla,'')+'</Resultado></Intelisis>'
END

