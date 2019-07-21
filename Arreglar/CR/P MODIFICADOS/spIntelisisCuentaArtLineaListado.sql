SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spIntelisisCuentaArtLineaListado
@ID				int,
@iSolicitud		int,
@Version		float,
@Resultado		varchar(max) = NULL OUTPUT,
@Ok				int = NULL OUTPUT,
@OkRef			varchar(255) = NULL OUTPUT

AS BEGIN
DECLARE
@Linea              Varchar(50),
@LineaMaestra       varchar(50),
@Icono              int,
@Clave				varchar(20),
@Texto				xml,
@ReferenciaIS		varchar(100),
@SubReferencia		varchar(100)
SELECT  @Linea = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Linea'
SELECT  @LineaMaestra= Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'LineaMaestra'
SELECT  @Icono = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Icono'
SELECT  @Clave = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Clave'
SELECT @Texto =(SELECT * FROM ArtLinea
WITH(NOLOCK) WHERE           ISNULL(Linea,'') = ISNULL(ISNULL(@Linea,Linea),'')
AND ISNULL(LineaMaestra,'') = ISNULL(ISNULL(@LineaMaestra,LineaMaestra),'')
AND ISNULL(Icono,'') = ISNULL(ISNULL(@Icono,Icono),'')
AND ISNULL(Clave,'') = ISNULL(ISNULL(@Clave,Clave),'')
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

