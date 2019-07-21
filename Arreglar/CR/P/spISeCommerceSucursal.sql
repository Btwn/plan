SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spISeCommerceSucursal
@ID			int,
@iSolicitud		int,
@Version		float,
@Resultado		varchar(max)  = NULL OUTPUT,
@Ok			int = NULL OUTPUT,
@OkRef			varchar(255) = NULL OUTPUT

AS BEGIN
DECLARE
@Sucursal             varchar(10),
@SucursalCambio       varchar(10),
@Estatus              varchar(10),
@eCommerceSucursal    varchar(10),
@ReferenciaIS         varchar(100),
@Empresa              varchar(5),
@Estacion             int,
@Tabla                varchar(max),
@Resultado2		varchar(max)
SELECT @Estacion = @@SPID
SELECT @Empresa = Empresa,
@Sucursal = Sucursal,
@SucursalCambio = SucursalCambio,
@Estatus = Estatus,
@eCommerceSucursal = eCommerceSucursal
FROM OPENXML (@iSolicitud,'/Intelisis/Solicitud/Sucursal')
WITH (Empresa varchar(5),  Sucursal int, Estatus varchar(10), eCommerceSucursal varchar(10),SucursalCambio int)
SELECT @ReferenciaIS = Referencia
FROM IntelisisService
WHERE ID = @ID
EXEC spContactoDireccionHorizontal @Estacion,'Sucursal',@SucursalCambio,@SucursalCambio,0,0,0,0
IF @Estatus IN ('ALTA','CAMBIO')
SELECT @Tabla = '<Sucursal'+(SELECT   ' Sucursal="'+ISNULL(dbo.fneWebConvertirDescripcionHTML(CONVERT(varchar(1000),Sucursal)),'')+'"'+
' Nombre="'+ISNULL(dbo.fneWebConvertirDescripcionHTML(Nombre),'')+'"'+
' Prefijo="'+ISNULL(dbo.fneWebConvertirDescripcionHTML(Prefijo),'')+'"'+
' Telefonos="'+ISNULL(dbo.fneWebConvertirDescripcionHTML(Telefonos),'')+'"'+
' eCommerce="'+ISNULL(dbo.fneWebConvertirDescripcionHTML(CONVERT(varchar(1000),eCommerce)),'')+'"'+
' eCommerceSucursal="'+ISNULL(dbo.fneWebConvertirDescripcionHTML(eCommerceSucursal),'')+'"'+
' eCommerceAlmacen="'+ISNULL(dbo.fneWebConvertirDescripcionHTML(eCommerceAlmacen),'')+'"'+
' eCommerceListaPrecios="'+ISNULL(dbo.fneWebConvertirDescripcionHTML(CONVERT(varchar(1000),eCommerceListaPrecios)),'')+'"'+
' eCommercePedido="'+ISNULL(dbo.fneWebConvertirDescripcionHTML(eCommercePedido),'')+'"'+
' eCommerceEstrategiaDescuento="'+ISNULL(dbo.fneWebConvertirDescripcionHTML(CONVERT(varchar(1000),eCommerceEstrategiaDescuento)),'')+'"'+
' eCommerceArticuloFlete="'+ISNULL(dbo.fneWebConvertirDescripcionHTML(CONVERT(varchar(1000),eCommerceArticuloFlete)),'')+'"'+
' eCommerceImpuestoIncluido="'+ISNULL(dbo.fneWebConvertirDescripcionHTML(CONVERT(varchar(1000),eCommerceImpuestoIncluido)),'')+'"'+
' eCommerceTipoConsecutivo="'+ISNULL(dbo.fneWebConvertirDescripcionHTML(CONVERT(varchar(1000),eCommerceTipoConsecutivo)),'')+'"'+
' eCommerceOffLine="'+ISNULL(dbo.fneWebConvertirDescripcionHTML(CONVERT(varchar(1000),eCommerceOffLine)),'')+'"'+
' eCommerceSincroniza="'+ISNULL(dbo.fneWebConvertirDescripcionHTML(CONVERT(varchar(1000),ISNULL(eCommerceSincroniza,1))),'')+'"'+
' eCommerceConsultaExistencias="'+ISNULL(dbo.fneWebConvertirDescripcionHTML(CONVERT(varchar(1000),eCommerceConsultaExistencias)),'')+'"'+
' eCommerceURL="'+ISNULL(dbo.fneWebConvertirDescripcionHTML(CONVERT(varchar(1000),ISNULL(eCommerceURL,1))),'')+'"'+
' eCommerceCRModo="'+ISNULL(dbo.fneWebConvertirDescripcionHTML(CONVERT(varchar(1000),ISNULL(eCommerceCRModo,1))),'')+'"'+
' eCommerceCRMinimo="'+ISNULL(dbo.fneWebConvertirDescripcionHTML(CONVERT(varchar(1000),ISNULL(eCommerceCRMinimo,1))),'')+'"'+
' eCommerceCRMaximo="'+ISNULL(dbo.fneWebConvertirDescripcionHTML(CONVERT(varchar(1000),ISNULL(eCommerceCRMaximo,1))),'')+'"'+
' Encargado="'+ISNULL(dbo.fneWebConvertirDescripcionHTML(CONVERT(varchar(1000),ISNULL(Encargado,1))),'')+'"'
FROM Sucursal WHERE Sucursal =  @SucursalCambio )+
ISNULL((SELECT ' Direccion1='+CHAR(34)+ ISNULL(Direccion1,'')+CHAR(34)+
' Direccion2='+CHAR(34)+ ISNULL(Direccion2,'')+CHAR(34)+
' Direccion3='+CHAR(34)+ ISNULL(Direccion3,'')+CHAR(34)+
' Direccion4='+CHAR(34)+ ISNULL(Direccion4,'')+CHAR(34)+
' Direccion5='+CHAR(34)+ ISNULL(Direccion5,'')+CHAR(34)+
' Direccion6='+CHAR(34)+ ISNULL(Direccion6,'')+CHAR(34)+
' Direccion7='+CHAR(34)+ ISNULL(Direccion7,'')+CHAR(34)+
' Direccion8='+CHAR(34)+ ISNULL(Direccion8,'')+CHAR(34)
FROM ContactoDireccionHorizontal
WHERE Estacion = @Estacion AND ContactoTipo = 'Sucursal'),'')+'/>'
ELSE   SELECT @Tabla = ''
SELECT @Resultado = '<?xml version="1.0" encoding="windows-1252"?><Intelisis Sistema="Intelisis" Contenido="Resultado" Referencia=' + CHAR(34) + ISNULL(@ReferenciaIS,'') + CHAR(34) + ' SubReferencia="Sucursal" Version=' + CHAR(34) + ISNULL(CONVERT(varchar ,@Version),'') + CHAR(34) + '><Resultado IntelisisServiceID=' + CHAR(34) + ISNULL(CONVERT(varchar,@ID),'')  + CHAR(34)  + ' Ok=' + CHAR(34) + ISNULL(CONVERT(varchar,@Ok),'') + CHAR(34) + ' OkRef=' + CHAR(34) + ISNULL(@OkRef,'') + CHAR(34) +' Empresa=' + CHAR(34) + ISNULL(@Empresa,'') + CHAR(34)+ ' Sucursal=' + CHAR(34) + ISNULL(CONVERT(varchar,@SucursalCambio),'') + CHAR(34)+' eCommerceSucursal=' + CHAR(34) + ISNULL(@eCommerceSucursal,'') + CHAR(34)+ ' Estatus=' + CHAR(34) + ISNULL(@Estatus,'') + CHAR(34) +' >'+ISNULL(@Tabla,'')+'</Resultado></Intelisis>'
END

