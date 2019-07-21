SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spIntelisisWMSVaidaArticuloCB
@ID				int,
@iSolicitud		int,
@Version		float,
@Resultado		varchar(max) = NULL OUTPUT,
@Ok				int = NULL OUTPUT,
@OkRef			varchar(255) = NULL OUTPUT

AS BEGIN
DECLARE
@Texto				varchar(200),
@ReferenciaIS		varchar(100),
@SubReferencia		varchar(100),
@CB1				varchar(30),
@CB2 				varchar(30),
@Art1				varchar(30),
@Art2				varchar(30),
@MismoArticulo      varchar(1)
SELECT  @CB1 = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Codigo1'
SELECT  @CB2 = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Codigo2'
SELECT @art1 = Cuenta FROM CB WHERE Codigo = @CB1
SELECT @art2 = Cuenta FROM CB WHERE Codigo = @CB2
SELECT @Art1 = rtrim(ltrim(@Art1))
SELECT  @Art2 = rtrim(ltrim(@Art2))
IF @Art1 = @Art2
SELECT @MismoArticulo = 1
ELSE
SELECT @MismoArticulo = 0
SELECT @Texto = '<MismoArticulo='  + CHAR(34) + isnull(@MismoArticulo,'') + CHAR(34) +'/>'
IF @@ERROR <> 0 SET @Ok = 1
BEGIN
SELECT @ReferenciaIS = Referencia
FROM IntelisisService
WHERE ID = @ID
IF @@ERROR <> 0 SET @Ok = 1
IF @Ok IS NOT NULL SELECT @OkRef = Descripcion FROM MensajeLista WHERE Mensaje = @Ok
SELECT @Resultado = '<?xml version="1.0" encoding="windows-1252"?><Intelisis Sistema="Intelisis" Contenido="Resultado" Referencia=' + CHAR(34) + ISNULL(@ReferenciaIS,'') + CHAR(34) + ' SubReferencia=' + CHAR(34) + ISNULL(@SubReferencia,'') + CHAR(34) + ' Version=' + CHAR(34) + ISNULL(CONVERT(varchar ,@Version),'') + CHAR(34) + '><Resultado IntelisisServiceID=' + CHAR(34) + ISNULL(CONVERT(varchar,@ID),'')  + CHAR(34)  + ' Ok=' + CHAR(34) + ISNULL(CONVERT(varchar,@Ok),'') + CHAR(34) + ' OkRef=' + CHAR(34) + ISNULL(@OkRef,'') + CHAR(34) + '><Articulo Igual='  + CHAR(34) + isnull(@MismoArticulo,'') + CHAR(34) +' /></Resultado></Intelisis>'
IF @@ERROR <> 0 SET @Ok = 1
END
END

