SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spISeCommerceWebArtExistenciaGlobal
@ID                     int,
@iSolicitud             int,
@Version                float,
@Resultado              varchar(MAX) = NULL OUTPUT,
@Ok                     int = NULL OUTPUT,
@OkRef                  varchar(max) = NULL OUTPUT

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
@Tabla2               varchar(max),
@Tabla                varchar(max),
@Resultado2           varchar(max)
SELECT @Estacion = @@SPID
SELECT @ReferenciaIS = Referencia
FROM IntelisisService
WHERE ID = @ID
SELECT @Tabla = ISNULL(@Tabla,'') +'<WebArtExistenciaGlobal  '+ 'Articulo='+CHAR(34)+RTRIM(LTRIM(Articulo))+CHAR(34)+' SKU='+CHAR(34)+RTRIM(LTRIM(SKU))+CHAR(34)+' Cantidad='+CHAR(34)+CONVERT(varchar,ISNULL(Inventario,0.0))+CHAR(34)+' SubCuenta='+CHAR(34)+ISNULL(SubCuenta,'')+CHAR(34)+' />'
FROM WebArtExistenciaGlobal
SELECT @Resultado2 = '<?xml version="1.0" encoding="windows-1252"?><Intelisis Sistema="Intelisis" Contenido="Resultado" Referencia=' + CHAR(34) + ISNULL(@ReferenciaIS,'') + CHAR(34) + ' SubReferencia="WebArtExistencia" Version=' + CHAR(34) + ISNULL(CONVERT(varchar ,@Version),'') + CHAR(34) + '><Resultado IntelisisServiceID=' + CHAR(34) + ISNULL(CONVERT(varchar,@ID),'')  + CHAR(34)  + ' Ok=' + CHAR(34) + ISNULL(CONVERT(varchar,@Ok),'') + CHAR(34) + ' OkRef=' + CHAR(34) + ISNULL(@OkRef,'') + CHAR(34)+ ' Sucursal=' + CHAR(34) + ISNULL(CONVERT(varchar,@Sucursal),'') + CHAR(34)+' eCommerceSucursal=' + CHAR(34) + ISNULL(@eCommerceSucursal,'') + CHAR(34)+' >'
SELECT @Resultado = @Resultado2+ISNULL(@Tabla,'')+ISNULL(@Tabla2,'')+'</Resultado></Intelisis>'
END

