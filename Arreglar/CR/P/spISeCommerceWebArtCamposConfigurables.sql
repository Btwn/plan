SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spISeCommerceWebArtCamposConfigurables
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
@Valor                varchar(max),
@Tabla                varchar(max),
@Resultado2		varchar(max)
SELECT @Empresa = Empresa,
@IDAtributo = IDAtributo,
@IDArt = IDArticulo,
@Sucursal = Sucursal,
@eCommerceSucursal = eCommerceSucursal,
@Estatus = Estatus
FROM OPENXML (@iSolicitud,'/Intelisis/Solicitud/WebArtCamposConfigurables')
WITH (Empresa varchar(5), IDArticulo int, Sucursal int, eCommerceSucursal  varchar(10), Estatus varchar(10), IDAtributo int)
SELECT @ReferenciaIS = Referencia
FROM IntelisisService
WHERE ID = @ID
IF EXISTS(SELECT * FROM WebArtCamposConfigurablesD  WHERE ID = @IDAtributo )
SELECT @Valor = ISNULL(@Valor,'') + ',' + Valor
FROM  WebArtCamposConfigurablesD
WHERE ID = @IDAtributo
ORDER by Orden
SELECT @Valor = STUFF(@Valor,1,1,'' )
IF @Estatus IN ('ALTA','CAMBIO')
SELECT @Tabla = (SELECT   ISNULL(CONVERT(varchar,ID),'')ID,ISNULL(CONVERT(varchar,IDArt),'')IDArt, ISNULL(CONVERT(varchar,Nombre),'')Nombre,ISNULL(CONVERT(varchar,TipoCampo),'')TipoCampo ,ISNULL(CONVERT(varchar,Requerido),'')Requerido, ISNULL(CONVERT(varchar,Orden),'')Orden, ISNULL(@Valor,'')ValorSelect FROM WebArtCamposConfigurables  WHERE ID = @IDAtributo FOR XML AUTO)
ELSE   SELECT @Tabla = ''
SELECT @Resultado2 = '<?xml version="1.0" encoding="windows-1252"?><Intelisis Sistema="Intelisis" Contenido="Resultado" Referencia=' + CHAR(34) + ISNULL(@ReferenciaIS,'') + CHAR(34) + ' SubReferencia="WebArtCamposConfigurables" Version=' + CHAR(34) + ISNULL(CONVERT(varchar ,@Version),'') + CHAR(34) + '><Resultado IntelisisServiceID=' + CHAR(34) + ISNULL(CONVERT(varchar,@ID),'')  + CHAR(34)  + ' Ok=' + CHAR(34) + ISNULL(CONVERT(varchar,@Ok),'') + CHAR(34) + ' OkRef=' + CHAR(34) + ISNULL(@OkRef,'') + CHAR(34) +' Empresa=' + CHAR(34) + ISNULL(@Empresa,'') + CHAR(34)+ ' Sucursal=' + CHAR(34) + ISNULL(CONVERT(varchar,@Sucursal),'') + CHAR(34)+' eCommerceSucursal=' + CHAR(34) + ISNULL(@eCommerceSucursal,'') + CHAR(34)+ ' Estatus=' + CHAR(34) + ISNULL(@Estatus,'') + CHAR(34) +' IDAtributo=' + CHAR(34) + CONVERT(varchar,ISNULL(@IDAtributo,'')) + CHAR(34) +' IDArticulo=' + CHAR(34) + CONVERT(varchar,ISNULL(@IDArt,'')) + CHAR(34) +' >'
SELECT @Resultado = @Resultado2+ISNULL(@Tabla,'')+'</Resultado></Intelisis>'
END

