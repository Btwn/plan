SET DATEFIRST 7    
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1  
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spISeCommerceWebEnvolturaRegalo
@ID			int,
@iSolicitud		int,
@Version		float,
@Resultado		varchar(max) = NULL OUTPUT,
@Ok			int = NULL OUTPUT,
@OkRef			varchar(255) = NULL OUTPUT

AS BEGIN
DECLARE
@IDEnvoltura			int,
@Estatus				varchar(10),
@Empresa              varchar(5),
@Sucursal             int,
@eCommerceSucursal    varchar(10),
@ReferenciaIS         varchar(100),
@Tabla                varchar(max) ,
@Resultado2			varchar(max) ,
@CostoEstandar float,
@CostoReposicion float,
@Usuario				varchar(10),
@Impuesto1    float,
@Impuesto2    float,
@Impuesto3    float
SELECT @Usuario = WebUsuario
FROM WebVersion
SELECT @Empresa = Empresa,
@IDEnvoltura = ID,
@Sucursal = Sucursal,
@eCommerceSucursal = eCommerceSucursal,
@Estatus = Estatus
FROM OPENXML (@iSolicitud,'/Intelisis/Solicitud/WebEnvolturaRegalo')
WITH (Empresa varchar(5),  Sucursal int, eCommerceSucursal  varchar(10), Estatus varchar(10), ID int)
SELECT @ReferenciaIS = Referencia
FROM IntelisisService
WHERE ID = @ID
IF @Estatus IN ('ALTA','CAMBIO')
SELECT @Tabla = '<WebEnvolturaRegalo '+(SELECT
' ID="'+ISNULL(dbo.fneWebConvertirDescripcionHTML(CONVERT(varchar(1000),WebEnvolturaRegalo.ID)),'')+'"'+
' SucursaleCommerce="'+ISNULL(dbo.fneWebConvertirDescripcionHTML(CONVERT(varchar(1000),WebEnvolturaRegalo.SucursaleCommerce)),'')+'"'+
' Nombre="'+ISNULL(dbo.fneWebConvertirDescripcionHTML(CONVERT(varchar(1000),WebEnvolturaRegalo.Nombre)),'')+'"'+
' Precio="'+ISNULL(dbo.fneWebConvertirDescripcionHTML(CONVERT(varchar(1000),WebEnvolturaRegalo.Precio)),'')+'"'+
' Visible="'+ISNULL(dbo.fneWebConvertirDescripcionHTML(CONVERT(varchar(1000),WebEnvolturaRegalo.Visible)),'')+'"'+
' PermiteMensaje="'+ISNULL(dbo.fneWebConvertirDescripcionHTML(CONVERT(varchar(1000),WebEnvolturaRegalo.PermiteMensaje)),'')+'"'+
' Imagen="'+ISNULL(dbo.fneWebConvertirDescripcionHTML(CONVERT(varchar(1000),WebEnvolturaRegalo.Imagen)),'')+'"'+
' Articulo="'+ISNULL(dbo.fneWebConvertirDescripcionHTML(CONVERT(varchar(1000),WebEnvolturaRegalo.Articulo)),'')+'"'+
' SubCuenta="'+ISNULL(dbo.fneWebConvertirDescripcionHTML(CONVERT(varchar(1000),WebEnvolturaRegalo.SubCuenta)),'')+'"'+
' />' FROM WebEnvolturaRegalo WebEnvolturaRegalo WHERE  ID = @IDEnvoltura)
ELSE   SELECT @Tabla = ''
SELECT @Resultado2 = '<?xml version="1.0" encoding="windows-1252"?><Intelisis Sistema="Intelisis" Contenido="Resultado" Referencia=' + CHAR(34) + ISNULL(@ReferenciaIS,'') + CHAR(34) + ' SubReferencia="WebEnvolturaRegalo" Version=' + CHAR(34) + ISNULL(CONVERT(varchar ,@Version),'') + CHAR(34) + '><Resultado IntelisisServiceID=' + CHAR(34) + ISNULL(CONVERT(varchar,@ID),'')  + CHAR(34)  + ' Ok=' + CHAR(34) + ISNULL(CONVERT(varchar,@Ok),'') + CHAR(34) + ' OkRef=' + CHAR(34) + ISNULL(@OkRef,'') + CHAR(34) +' Empresa=' + CHAR(34) + ISNULL(@Empresa,'') + CHAR(34)+ ' Sucursal=' + CHAR(34) + ISNULL(CONVERT(varchar,@Sucursal),'') + CHAR(34)+' eCommerceSucursal=' + CHAR(34) + ISNULL(@eCommerceSucursal,'') + CHAR(34)+ ' Estatus=' + CHAR(34) + ISNULL(@Estatus,'') + CHAR(34) +' ID=' + CHAR(34) + ISNULL(CONVERT(varchar,@IDEnvoltura),'') + CHAR(34) +' >'
SELECT @Resultado = @Resultado2+ISNULL(@Tabla,'')+'</Resultado></Intelisis>'
END

