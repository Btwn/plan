SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spIntelisisINVINV_IFListado
@ID				int,
@iSolicitud		int,
@Version		float,
@Resultado		varchar(max) = NULL OUTPUT,
@Ok				int = NULL OUTPUT,
@OkRef			varchar(255) = NULL OUTPUT

AS BEGIN
DECLARE
@Texto				xml,
@ReferenciaIS		varchar(100),
@SubReferencia		varchar(100) ,
@Agente              varchar(20),
@Descripcion        varchar(100)
SELECT  @Agente   = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'AgenteA'
SELECT @Agente = DefAgente FROM Usuario WHERE Usuario = @Agente
IF NOT EXISTS(SELECT * FROM Agente WHERE Agente = @Agente) SELECT @Ok = 26090, @OkRef=@Agente 
SELECT @Texto =(SELECT Inv.* FROM Inv JOIN MovTipo mt ON Inv.Mov=mt.Mov AND mt.Modulo='INV'
WHERE Inv.Agente = @Agente AND
mt.Clave = 'INV.IF' AND Estatus = 'SINAFECTAR'
FOR XML AUTO)
IF @Texto IS NULL 
SELECT @Ok = 14055, @OkRef=@Agente 
IF @@ERROR <> 0 SET @Ok = 1
BEGIN
SELECT @ReferenciaIS = Referencia
FROM IntelisisService
WHERE ID = @ID
IF @@ERROR <> 0 SET @Ok = 1
IF @Ok IS NOT NULL SELECT @Descripcion = Descripcion FROM MensajeLista WHERE Mensaje = @Ok
SELECT @Resultado = '<?xml version="1.0" encoding="windows-1252"?><Intelisis Sistema="Intelisis" Contenido="Resultado" Referencia=' + CHAR(34) + ISNULL(@ReferenciaIS,'') + CHAR(34) + ' SubReferencia=' + CHAR(34) + ISNULL(@SubReferencia,'') + CHAR(34) + ' Version=' + CHAR(34) + ISNULL(CONVERT(varchar ,@Version),'') + CHAR(34) + '><Resultado IntelisisServiceID=' + CHAR(34) + ISNULL(CONVERT(varchar,@ID),'')  + CHAR(34)  + ' Ok=' + CHAR(34) + ISNULL(CONVERT(varchar,@Ok),'') + CHAR(34) + ' OkRef=' + CHAR(34) + ISNULL(@OkRef,'') + CHAR(34) + ' Descripcion="' + ISNULL(@Descripcion,'') +'">' + CONVERT(varchar(max),ISNULL(@Texto,'')) + '</Resultado></Intelisis>'
IF @@ERROR <> 0 SET @Ok = 1
END
END

