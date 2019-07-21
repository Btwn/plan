SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spIntelisisInterfazInforTransferenciaArtOpcionDetalle
@ID                        int,
@iSolicitud                           int,
@Version                              float,
@Resultado                         varchar(max) = NULL OUTPUT,
@Ok                                                      int = NULL OUTPUT,
@OkRef                                 varchar(255) = NULL OUTPUT

AS BEGIN
DECLARE
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
InforVariante       varchar(1),
InforValor          int,
InforDescripcion    varchar(100)
)
SELECT @ReferenciaIS = Referencia ,@Usuario = Usuario , @SubReferencia = SubReferencia
FROM IntelisisService
WHERE ID = @ID
SELECT @Contrasena = Contrasena
FROM Usuario
WHERE Usuario = @Usuario
SET @Resultado = '<?xml version="1.0" encoding="windows-1252"?><Intelisis Sistema="Intelisis" Contenido="Resultado" Referencia=' + ISNULL(@ReferenciaIS,'') + CHAR(34) + ' SubReferencia=' + CHAR(34) + ISNULL(@SubReferencia,'') + CHAR(34) + ' Version=' + CHAR(34) + ISNULL(CONVERT(varchar ,@Version),'') + CHAR(34) + '><Resultado IntelisisServiceID=' + CHAR(34) + ISNULL(CONVERT(varchar,ISNULL(@ID,'')),'') + CHAR(34) +  ' Ok=' + CHAR(34) + ISNULL(CONVERT(varchar,ISNULL(@Ok,'')),'') + CHAR(34) + ' OkRef=' + CHAR(34) + ISNULL(ISNULL(@OkRef,''),'') + CHAR(34) + '/></Intelisis>'
IF @Ok IS NULL
SELECT @Solicitud = Resultado
FROM IntelisisService
WHERE ID = @IDNuevo
INSERT @Tabla (InforVariante,InforValor,InforDescripcion)
SELECT Opcion,Numero,Nombre
FROM OpcionD
SET @Resultado2 = CONVERT(varchar(max) ,(SELECT * FROM @Tabla oVariantes FOR XML AUTO))
SET @Datos2 = '<?xml version="1.0" encoding="windows-1252"?><Intelisis Sistema="Infor" Contenido="Solicitud" Referencia=' + CHAR(34) +'Infor.Cuenta.OpcionDetalle.Mantenimiento' + CHAR(34) + ' SubReferencia=' + CHAR(34) + ISNULL(@SubReferencia,'') + CHAR(34) + ' Version=' + CHAR(34) + ISNULL(CONVERT(varchar ,@Version),'') + CHAR(34) + '><Solicitud IntelisisServiceID=' + CHAR(34) + ISNULL(CONVERT(varchar,@ID),'')   + CHAR(34) + ' Ok=' + CHAR(34) + ISNULL(CONVERT(varchar,@Ok),'') + CHAR(34) + ' OkRef=' + CHAR(34) + ISNULL(@OkRef,'') + CHAR(34)+ ' >' + @Resultado2 + '</Solicitud></Intelisis>'
EXEC spIntelisisService @Usuario,@Contrasena,@Datos2,@Resultado2,@Ok Output,@OkRef Output,0,0,@IDNuevo Output
END

