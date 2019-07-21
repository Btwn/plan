SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spISeCommerceWebMovSituacion
@ID			int,
@iSolicitud		int,
@Version		float,
@Resultado		varchar(max) = NULL OUTPUT,
@Ok			int = NULL OUTPUT,
@OkRef			varchar(255) = NULL OUTPUT

AS BEGIN
SET nocount ON
DECLARE
@IDMarca		int,
@Estatus		varchar(10),
@Empresa              varchar(5),
@Sucursal             int,
@eCommerceSucursal    varchar(10),
@ReferenciaIS         varchar(100),
@Mov                  varchar(20),
@MovID                varchar(20),
@OrigenMov            varchar(20),
@OrigenMovID          varchar(20),
@Modulo               varchar(20),
@Situacion            varchar(50),
@SituacioneCommerce   varchar(50),
@IDOrigen             int,
@IDSituacion          int,
@Tabla                varchar(max) ,
@Resultado2		varchar(max)
SELECT @Empresa = Empresa,
@IDOrigen = IDOrigen,
@OrigenMov = OrigenMov,
@OrigenMovID = OrigenMovID,
@Modulo = Modulo,
@Mov = Mov,
@MovID = MovID,
@Sucursal = Sucursal,
@eCommerceSucursal = eCommerceSucursal,
@Estatus = Estatus,
@Situacion = Situacion,
@SituacioneCommerce = SituacioneCommerce,
@IDSituacion = SituacionID
FROM OPENXML (@iSolicitud,'/Intelisis/Solicitud/WebMovSituacion')
WITH (Empresa varchar(5), SituacioneCommerce  varchar(50),SituacionID int, IDOrigen int, Sucursal int, eCommerceSucursal  varchar(10), Estatus varchar(10), OrigenMov varchar(20), OrigenMovID varchar(20), Modulo varchar(5), Mov varchar(20), MovID varchar(20), Situacion varchar(50))
SELECT @ReferenciaIS = Referencia
FROM IntelisisService
WHERE ID = @ID
SELECT @Tabla = '<WebMovSituacion IDOrigen="'+ISNULL(CONVERT(varchar,@IDOrigen),'')+'" OrigenMov="'+ISNULL(@OrigenMov,'')+'" OrigenMovID="'+ISNULL(@OrigenMovID,'')+'" Modulo="'+ISNULL(@Modulo,'')+'" Mov="'+ISNULL(@Mov,'')+'" MovID="'+ISNULL(@MovID,'')+'" Sucursal="'+ISNULL(CONVERT(varchar,@Sucursal),'')+'" eCommerceSucursal="'+ISNULL(@eCommerceSucursal,'')+'" Estatus="'+ISNULL(@Estatus,'')+'" Situacion="'+ISNULL(@Situacion,'')+'"  SituacionID="'+ISNULL(CONVERT(varchar,@IDSituacion),'') +'" SituacioneCommerce="'+ISNULL(@SituacioneCommerce,'')+' " Empresa="'+ISNULL(@Empresa,'')+'" />'
SELECT @Resultado2 = '<?xml version="1.0" encoding="windows-1252"?><Intelisis Sistema="Intelisis" Contenido="Resultado" Referencia=' + CHAR(34) + ISNULL(@ReferenciaIS,'') + CHAR(34) + ' SubReferencia="WebMovSituacion" Version=' + CHAR(34) + ISNULL(CONVERT(varchar ,@Version),'') + CHAR(34) + '><Resultado IntelisisServiceID=' + CHAR(34) + ISNULL(CONVERT(varchar,@ID),'')  + CHAR(34)  + ' Ok=' + CHAR(34) + ISNULL(CONVERT(varchar,@Ok),'') + CHAR(34) + ' OkRef=' + CHAR(34) + ISNULL(@OkRef,'') + CHAR(34) +' Empresa=' + CHAR(34) + ISNULL(@Empresa,'') + CHAR(34)+ ' Sucursal=' + CHAR(34) + ISNULL(CONVERT(varchar,@Sucursal),'') + CHAR(34)+' eCommerceSucursal=' + CHAR(34) + ISNULL(@eCommerceSucursal,'') + CHAR(34) +' Estatus = "CAMBIO" >'
SELECT @Resultado = @Resultado2+ISNULL(@Tabla,'')+'</Resultado></Intelisis>'
END

