SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spIntelisisCuentaCteTipoListado
@ID				int,
@iSolicitud		int,
@Version		float,
@Resultado		varchar(max) = NULL OUTPUT,
@Ok				int = NULL OUTPUT,
@OkRef			varchar(255) = NULL OUTPUT

AS BEGIN
DECLARE
@Orden				int,
@Tipo				varchar(20),
@INFORDescripcion		varchar(255),
@Texto				xml,
@ReferenciaIS			varchar(100),
@SubReferencia			varchar(100)
SELECT @Orden = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Orden'
SELECT @Tipo = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Tipo'
SELECT @INFORDescripcion = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'INFORDescripcion'
SELECT @Texto =(SELECT * FROM CteTipo
WITH(NOLOCK) WHERE  ISNULL(Tipo,'') = ISNULL(ISNULL(@Tipo,Tipo),'')
AND  ISNULL(Orden,'') = ISNULL(ISNULL(@Orden,Orden),'')
FOR XML AUTO)
IF @@ERROR <> 0 SET @Ok = 1
BEGIN
SELECT @ReferenciaIS = Referencia
FROM IntelisisService
WITH(NOLOCK) WHERE ID = @ID
IF @@ERROR <> 0 SET @Ok = 1
IF @Ok IS NULL
BEGIN
SELECT @Resultado = '<?xml version="1.0" encoding="windows-1252"?><Intelisis Sistema="Intelisis" Contenido="Resultado" Referencia=' + CHAR(34) + ISNULL(@ReferenciaIS,'') + CHAR(34) + ' SubReferencia=' + CHAR(34) + ISNULL(@SubReferencia,'') + CHAR(34) + ' Version=' + CHAR(34) + ISNULL(CONVERT(varchar ,@Version),'') + CHAR(34) + '><Resultado IntelisisServiceID=' + CHAR(34) + ISNULL(CONVERT(varchar,@ID),'')  + CHAR(34)  + ' Ok=' + CHAR(34) + ISNULL(CONVERT(varchar,@Ok),'') + CHAR(34) + ' OkRef=' + CHAR(34) + ISNULL(@OkRef,'') + CHAR(34) + '>' + CONVERT(varchar(max),@Texto) + '</Resultado></Intelisis>'
IF @@ERROR <> 0 SET @Ok = 1
END
END
END

