SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spISeCommerceWebArtAtributos
@ID			int,
@iSolicitud		int,
@Version		float,
@Resultado		varchar(max)  = NULL OUTPUT,
@Ok			int = NULL OUTPUT,
@OkRef			varchar(255) = NULL OUTPUT

AS BEGIN
SET nocount ON
DECLARE
@IDAtributo		int,
@IDArt		int,
@Estatus		varchar(10),
@Empresa              varchar(5),
@Sucursal             int,
@eCommerceSucursal    varchar(10),
@ReferenciaIS         varchar(100),
@Tabla                varchar(max),
@Resultado2		varchar(max)
SELECT @Empresa = Empresa,
@IDAtributo = IDAtributo,
@IDArt = IDArticulo,
@Sucursal = Sucursal,
@eCommerceSucursal = eCommerceSucursal,
@Estatus = Estatus
FROM OPENXML (@iSolicitud,'/Intelisis/Solicitud/WebArtAtributos')
WITH (Empresa varchar(5), IDArticulo int, Sucursal int, eCommerceSucursal  varchar(10), Estatus varchar(10), IDAtributo int)
SELECT @ReferenciaIS = Referencia
FROM IntelisisService
WHERE ID = @ID
IF @Estatus IN ('ALTA','CAMBIO')
SELECT @Tabla = (SELECT *  FROM WebArtAtributos WHERE ID = @IDAtributo FOR XML AUTO)
ELSE   SELECT @Tabla = ''
SELECT @Resultado2 = '<?xml version="1.0" encoding="windows-1252"?><Intelisis Sistema="Intelisis" Contenido="Resultado" Referencia=' + CHAR(34) + ISNULL(@ReferenciaIS,'') + CHAR(34) + ' SubReferencia="WebArtAtributos" Version=' + CHAR(34) + ISNULL(CONVERT(varchar ,@Version),'') + CHAR(34) + '><Resultado IntelisisServiceID=' + CHAR(34) + ISNULL(CONVERT(varchar,@ID),'')  + CHAR(34)  + ' Ok=' + CHAR(34) + ISNULL(CONVERT(varchar,@Ok),'') + CHAR(34) + ' OkRef=' + CHAR(34) + ISNULL(@OkRef,'') + CHAR(34) +' Empresa=' + CHAR(34) + ISNULL(@Empresa,'') + CHAR(34)+ ' Sucursal=' + CHAR(34) + ISNULL(CONVERT(varchar,@Sucursal),'') + CHAR(34)+' eCommerceSucursal=' + CHAR(34) + ISNULL(@eCommerceSucursal,'') + CHAR(34)+ ' Estatus=' + CHAR(34) + ISNULL(@Estatus,'') + CHAR(34) +' IDAtributo=' + CHAR(34) + CONVERT(varchar,ISNULL(@IDAtributo,'')) + CHAR(34) +' IDArticulo=' + CHAR(34) + CONVERT(varchar,ISNULL(@IDArt,'')) + CHAR(34) +' >'
SELECT @Resultado = @Resultado2+ISNULL(@Tabla,'')+'</Resultado></Intelisis>'
END

