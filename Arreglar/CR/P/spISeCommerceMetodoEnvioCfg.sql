SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spISeCommerceMetodoEnvioCfg
@ID			int,
@iSolicitud		int,
@Version		float,
@Resultado		varchar(max)  = NULL OUTPUT,
@Ok			int = NULL OUTPUT,
@OkRef			varchar(255) = NULL OUTPUT

AS BEGIN
SET nocount ON
DECLARE
@eCommerceSucursal    varchar(10),
@MetodoEnvio          varchar(50),
@Nombre               varchar(100),
@NombreAntes               varchar(100),
@Estatus		varchar(10),
@Empresa              varchar(5),
@Sucursal             int,
@ReferenciaIS         varchar(100),
@Tabla                varchar(max),
@Resultado2		varchar(max)
SELECT @Empresa = Empresa,
@MetodoEnvio= MetodoEnvio,
@Nombre = Nombre,
@NombreAntes = NombreAntes,
@Sucursal = Sucursal,
@eCommerceSucursal = eCommerceSucursal,
@Estatus = Estatus
FROM OPENXML (@iSolicitud,'/Intelisis/Solicitud/eCommerceMetodoEnvioCfg')
WITH (Empresa varchar(5), MetodoEnvio varchar(50), Sucursal int, eCommerceSucursal  varchar(10), Estatus varchar(10), Nombre varchar(100), NombreAntes varchar(100))
SELECT @ReferenciaIS = Referencia
FROM IntelisisService
WHERE ID = @ID
IF @Estatus IN ('ALTA','CAMBIO')
BEGIN
IF @MetodoEnvio IN('Porcentaje de Total','Por articulo' ,'Monto Fijo')
SELECT @Tabla = (SELECT SucursaleCommerce, MetodoEnvio, Nombre,
CASE WHEN MetodoEnvio ='Porcentaje de Total' THEN Precio1
WHEN MetodoEnvio ='Por articulo'    THEN Precio2
WHEN MetodoEnvio ='Monto Fijo'   THEN Precio3 END As Precio  ,Estatus EstatusMetodo
FROM eCommerceMetodoEnvioCfg WHERE SucursaleCommerce = @eCommerceSucursal AND  MetodoEnvio = @MetodoEnvio AND Nombre = @Nombre FOR XML AUTO)
ELSE
SELECT @Tabla = (SELECT eCommerceMetodoEnvioCfg.SucursaleCommerce, eCommerceMetodoEnvioCfg.MetodoEnvio, eCommerceMetodoEnvioCfg.Nombre,
CASE WHEN eCommerceMetodoEnvioCfg.MetodoEnvio ='Por Peso' THEN eCommerceMetodoEnvioCfg.Precio4
WHEN eCommerceMetodoEnvioCfg.MetodoEnvio ='Por Total de Pedido' THEN eCommerceMetodoEnvioCfg.Precio5  END As Precio   ,
eCommerceMetodoEnvioCfg.Estatus EstatusMetodo ,
eCommerceMetodoEnvioCfgD.NumeroD, eCommerceMetodoEnvioCfgD.NumeroA, eCommerceMetodoEnvioCfgD.Precio
FROM eCommerceMetodoEnvioCfg eCommerceMetodoEnvioCfg LEFT JOIN eCommerceMetodoEnvioCfgD eCommerceMetodoEnvioCfgD ON eCommerceMetodoEnvioCfg.SucursaleCommerce = eCommerceMetodoEnvioCfgD.SucursaleCommerce AND eCommerceMetodoEnvioCfg.MetodoEnvio = eCommerceMetodoEnvioCfgD.MetodoEnvio AND eCommerceMetodoEnvioCfg.Nombre = eCommerceMetodoEnvioCfgD.Nombre
WHERE eCommerceMetodoEnvioCfg.SucursaleCommerce = @eCommerceSucursal AND eCommerceMetodoEnvioCfg.MetodoEnvio = @MetodoEnvio AND eCommerceMetodoEnvioCfg.Nombre = @Nombre
FOR XML AUTO)
END
ELSE   SELECT @Tabla = ''
SELECT @Resultado2 = '<?xml version="1.0" encoding="windows-1252"?><Intelisis Sistema="Intelisis" Contenido="Resultado" Referencia=' + CHAR(34) + ISNULL(@ReferenciaIS,'') + CHAR(34) + ' SubReferencia="eCommerceMetodoEnvioCfg" Version=' + CHAR(34) + ISNULL(CONVERT(varchar ,@Version),'') + CHAR(34) + '><Resultado IntelisisServiceID=' + CHAR(34) + ISNULL(CONVERT(varchar,@ID),'')  + CHAR(34)  + ' Ok=' + CHAR(34) + ISNULL(CONVERT(varchar,@Ok),'') + CHAR(34) + ' OkRef=' + CHAR(34) + ISNULL(@OkRef,'') + CHAR(34) +' Empresa=' + CHAR(34) + ISNULL(@Empresa,'') + CHAR(34)+ ' Sucursal=' + CHAR(34) + ISNULL(CONVERT(varchar,@Sucursal),'') + CHAR(34)+' eCommerceSucursal=' + CHAR(34) + ISNULL(@eCommerceSucursal,'') + CHAR(34)+ ' Estatus=' + CHAR(34) + ISNULL(@Estatus,'') + CHAR(34) +' MetodoEnvio=' + CHAR(34) + ISNULL(@MetodoEnvio,'') + CHAR(34) +' Nombre=' + CHAR(34) +ISNULL(@Nombre,'') + CHAR(34) +' NombreAntes=' + CHAR(34) +ISNULL(@NombreAntes,'') + CHAR(34) +' >'
SELECT @Resultado = @Resultado2+ISNULL(@Tabla,'')+'</Resultado></Intelisis>'
END

