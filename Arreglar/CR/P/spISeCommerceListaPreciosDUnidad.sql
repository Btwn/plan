SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spISeCommerceListaPreciosDUnidad
@ID			int,
@iSolicitud		int,
@Version		float,
@Resultado		varchar(max) = NULL OUTPUT,
@Ok			int = NULL OUTPUT,
@OkRef			varchar(255) = NULL OUTPUT

AS BEGIN
DECLARE
@Lista				varchar(20),
@Moneda				varchar(10),
@Articulo			varchar(20),
@Unidad				varchar(50),
@Estatus		varchar(10),
@Empresa              varchar(5),
@Sucursal             int,
@eCommerceSucursal     varchar(10),
@ReferenciaIS         varchar(100),
@Tabla                varchar(max) ,
@Resultado2		varchar(max)
SELECT @Empresa = Empresa,
@Lista = Lista,
@Moneda = Moneda,
@Articulo = Articulo,
@Unidad = Unidad,
@Sucursal = Sucursal,
@eCommerceSucursal = eCommerceSucursal,
@Estatus = Estatus
FROM OPENXML (@iSolicitud,'/Intelisis/Solicitud/ListaPreciosDUnidad')
WITH (Empresa varchar(5),  Sucursal int, eCommerceSucursal  varchar(10), Estatus varchar(10),  Lista varchar(20), Moneda varchar(10), Articulo varchar(20), Unidad varchar(50))
SELECT @ReferenciaIS = Referencia
FROM IntelisisService
WHERE ID = @ID
IF @Estatus IN ('ALTA','CAMBIO')
SELECT @Tabla = '<ListaPreciosDUnidad '+(SELECT
' Lista="'+ISNULL(dbo.fneWebConvertirDescripcionHTML(CONVERT(varchar(1000),ListaPreciosDUnidad.Lista)),'')+'"'+
' Moneda="'+ISNULL(dbo.fneWebConvertirDescripcionHTML(CONVERT(varchar(1000),ListaPreciosDUnidad.Moneda)),'')+'"'+
' Articulo="'+ISNULL(dbo.fneWebConvertirDescripcionHTML(CONVERT(varchar(1000),ListaPreciosDUnidad.Articulo)),'')+'"'+
' Unidad="'+ISNULL(dbo.fneWebConvertirDescripcionHTML(CONVERT(varchar(1000),ListaPreciosDUnidad.Unidad)),'')+'"'+
' Precio="'+ISNULL(dbo.fneWebConvertirDescripcionHTML(CONVERT(varchar(1000),ListaPreciosDUnidad.Precio)),'')+'"'+
' Region="'+ISNULL(dbo.fneWebConvertirDescripcionHTML(CONVERT(varchar(1000),ListaPreciosDUnidad.Region)),'')+'"'+
' />' FROM ListaPreciosDUnidad ListaPreciosDUnidad WHERE  Lista = @Lista AND Moneda = @Moneda AND Articulo = @Articulo AND Unidad = @Unidad)
ELSE   SELECT @Tabla = ''
SELECT @Resultado2 = '<?xml version="1.0" encoding="windows-1252"?><Intelisis Sistema="Intelisis" Contenido="Resultado" Referencia=' + CHAR(34) + ISNULL(@ReferenciaIS,'') + CHAR(34) + ' SubReferencia="ListaPreciosDUnidad" Version=' + CHAR(34) + ISNULL(CONVERT(varchar ,@Version),'') + CHAR(34) + '><Resultado IntelisisServiceID=' + CHAR(34) + ISNULL(CONVERT(varchar,@ID),'')  + CHAR(34)  + ' Ok=' + CHAR(34) + ISNULL(CONVERT(varchar,@Ok),'') + CHAR(34) + ' OkRef=' + CHAR(34) + ISNULL(@OkRef,'') + CHAR(34) +' Empresa=' + CHAR(34) + ISNULL(@Empresa,'') + CHAR(34)+ ' Sucursal=' + CHAR(34) + ISNULL(CONVERT(varchar,@Sucursal),'') + CHAR(34)+' eCommerceSucursal=' + CHAR(34) + ISNULL(@eCommerceSucursal,'') + CHAR(34)+ ' Estatus=' + CHAR(34) + ISNULL(@Estatus,'') + CHAR(34) +' Lista=' + CHAR(34) + ISNULL(CONVERT(varchar,@Lista),'') + CHAR(34) +' Moneda=' + CHAR(34) + ISNULL(CONVERT(varchar,@Moneda),'') + CHAR(34) +' Articulo=' + CHAR(34) + ISNULL(CONVERT(varchar,@Articulo),'') + CHAR(34) +' Unidad=' + CHAR(34) + ISNULL(CONVERT(varchar,@Unidad),'') + CHAR(34) +' >'
SELECT @Resultado = @Resultado2+ISNULL(@Tabla,'')+'</Resultado></Intelisis>'
END

