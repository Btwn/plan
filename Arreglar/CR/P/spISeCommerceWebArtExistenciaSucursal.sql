SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spISeCommerceWebArtExistenciaSucursal
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
@ReferenciaIS         varchar(100),
@Tabla                varchar(max) ,
@Resultado2		varchar(max),
@Estacion             int
SELECT @ReferenciaIS = Referencia
FROM IntelisisService
WHERE ID = @ID
SELECT @Sucursal = Sucursal,
@eCommerceSucursal = eCommerceSucursal
FROM OPENXML (@iSolicitud,'/Intelisis/Solicitud/ExistenciaSucursal')
WITH ( Sucursal int, eCommerceSucursal varchar(20))
SELECT @Tabla = (SELECT ID, Articulo, SubCuenta, Inventario Cantidad, SKU, Situacion, Sucursal FROM eCommerceExistenciaSucursal  WebArtExistenciaSucursal FOR XML AUTO)
SELECT @Resultado = '<?xml version="1.0" encoding="windows-1252"?><Intelisis Sistema="Intelisis" Contenido="Resultado" Referencia=' + CHAR(34) + ISNULL(@ReferenciaIS,'') + CHAR(34) + ' SubReferencia="WebArtExistencia" Version=' + CHAR(34) + ISNULL(CONVERT(varchar ,@Version),'') + CHAR(34) + '><Resultado IntelisisServiceID=' + CHAR(34) + ISNULL(CONVERT(varchar,@ID),'')  + CHAR(34)  + ' Ok=' + CHAR(34) + ISNULL(CONVERT(varchar,@Ok),'') + CHAR(34) + ' OkRef=' + CHAR(34) + ISNULL(@OkRef,'') + CHAR(34)+ ' Sucursal=' + CHAR(34) + ISNULL(CONVERT(varchar,@Sucursal),'') + CHAR(34)+' eCommerceSucursal=' + CHAR(34) + ISNULL(@eCommerceSucursal,'') + CHAR(34)+' >' +ISNULL(@Tabla,'')+'</Resultado></Intelisis>'
END

