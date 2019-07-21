SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spIntelisisInterfazInforTransferenciaMotivoRechazo
@ID                        int,
@iSolicitud                           int,
@Version                              float,
@Resultado                         varchar(max) = NULL OUTPUT,
@Ok                                                      int = NULL OUTPUT,
@OkRef                                 varchar(255) = NULL OUTPUT

AS BEGIN
DECLARE
@Motivo                                       varchar(8),
@Datos                                                 varchar(max),
@Solicitud                                                                           varchar(max),
@ReferenciaIS                                                    varchar(100),
@SubReferencia                                                varchar(100),
@IDNuevo                                                                           int,
@Datos2                                                               varchar(max),
@Resultado2                                                                      varchar(max),
@Usuario                                                                             varchar(10),
@Contrasena                                                                     varchar(32)
DECLARE
@Tabla                                 table
(
Motivo       varchar(8),
Descripcion  varchar(40)
)
SELECT @Motivo = Motivo FROM openxml (@iSolicitud,'/Intelisis/Solicitud/MotivoRechazo')
WITH (Motivo varchar(255))
SELECT @ReferenciaIS = Referencia ,@Usuario = Usuario , @SubReferencia = SubReferencia
FROM IntelisisService
WHERE ID = @ID
SELECT @Contrasena = Contrasena
FROM Usuario
WHERE Usuario = @Usuario
IF @Ok IS NULL
BEGIN
SET @Resultado = '<?xml version="1.0" encoding="windows-1252"?><Intelisis Sistema="Intelisis" Contenido="Resultado" Referencia=' + ISNULL(@ReferenciaIS,'') + CHAR(34) + ' SubReferencia=' + CHAR(34) + ISNULL(@SubReferencia,'') + CHAR(34) + ' Version=' + CHAR(34) + ISNULL(CONVERT(varchar ,@Version),'') + CHAR(34) + '><Resultado IntelisisServiceID=' + CHAR(34) + ISNULL(CONVERT(varchar,ISNULL(@ID,'')),'') + CHAR(34) +  ' Ok=' + CHAR(34) + ISNULL(CONVERT(varchar,ISNULL(@Ok,'')),'') + CHAR(34) + ' OkRef=' + CHAR(34) + ISNULL(ISNULL(@OkRef,''),'') + CHAR(34) + '/></Intelisis>'
SET @Datos='<?xml version="1.0" encoding="windows-1252"?><Intelisis Sistema="Intelisis" Contenido="Solicitud" Referencia="Intelisis.Cuenta.MotivoRechazo.Listado" SubReferencia="'+@SubReferencia+'" Version="1.0"><Solicitud><Parametro Campo="Motivo" Valor="'+@Motivo+'"/></Solicitud></Intelisis>'
EXEC spIntelisisService @Usuario,@Contrasena,@Datos,@Resultado,@Ok Output,@OkRef Output,1,0,@IDnuevo Output
IF @Ok IS NULL
SELECT @Solicitud = Resultado
FROM IntelisisService
WHERE ID = @IDNuevo
EXEC sp_xml_preparedocument @iSolicitud OUTPUT, @Solicitud
IF @@ERROR <> 0 SET @Ok = 1
INSERT @Tabla (Motivo,Descripcion)
SELECT Motivo,Descripcion
FROM OPENXML (@iSolicitud, '/Intelisis/Resultado/MotivoRechazo',1)
WITH (Motivo varchar(100),Descripcion varchar(100))
IF @@ERROR <> 0 SET @Ok = 1
EXEC sp_xml_removedocument @iSolicitud
IF @@ERROR <> 0 SET @Ok = 1
END
SET @Resultado2 = CONVERT(varchar(max) ,(SELECT * FROM @Tabla oMotivoRechazo FOR XML AUTO))
SET @Datos2 = '<?xml version="1.0" encoding="windows-1252"?><Intelisis Sistema="Infor" Contenido="Solicitud" Referencia=' + CHAR(34) +'Infor.Cuenta.MotivoRechazo.Mantenimiento' + CHAR(34) + ' SubReferencia=' + CHAR(34) + ISNULL(@SubReferencia,'') + CHAR(34) + ' Version=' + CHAR(34) + ISNULL(CONVERT(varchar ,@Version),'') + CHAR(34) + '><Solicitud IntelisisServiceID=' + CHAR(34) + ISNULL(CONVERT(varchar,@ID),'')   + CHAR(34) + ' Ok=' + CHAR(34) + ISNULL(CONVERT(varchar,@Ok),'') + CHAR(34) + ' OkRef=' + CHAR(34) + ISNULL(@OkRef,'') + CHAR(34)+ ' >' + @Resultado2 + '</Solicitud></Intelisis>'
EXEC spIntelisisService @Usuario,@Contrasena,@Datos2,@Resultado2,@Ok Output,@OkRef Output,0,0,@IDNuevo Output
END

