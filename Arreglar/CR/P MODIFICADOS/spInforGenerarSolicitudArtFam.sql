SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROC spInforGenerarSolicitudArtFam
@Familia         varchar (50),
@Estatus                                 varchar (10),
@ReferenciaIntelisisService                                           varchar(50)          ,
@Datos                                   varchar (max) OUTPUT

AS
BEGIN
DECLARE
@AccesoID                                                                      int,
@Usuario                                                             varchar(10),
@Ok                                                                   int,
@OkRef                                                             varchar(255),
@Contrasena                                                                 varchar(32),
@Resultado                                                                     varchar(max),
@Id                                                                    int
IF @Estatus IN ('ALTA','CAMBIO')
SELECT @Datos = '<?xml version="1.0" encoding="windows-1252"?><Intelisis Sistema="Intelisis" Contenido="Solicitud" Referencia="Intelisis.Interfaz.Infor.Transferencia.ArtFam" SubReferencia="'+@Estatus+'" Version="1.0"><Solicitud> <ArtFam  Familia="'+@Familia+'"/>  </Solicitud> </Intelisis>'
IF @Estatus = 'BAJA'
SELECT @Datos = '<?xml version="1.0" encoding="windows-1252"?><Intelisis Sistema="Infor" Contenido="Solicitud" Referencia="Infor.Cuenta.ArtFam.Mantenimiento" SubReferencia="'+@Estatus+'" Version="1.0" ReferenciaIntelisisService='+ CHAR(34)+ ISNULL(@ReferenciaIntelisisService,'')+CHAR(34)+' ><Solicitud><ArtFam  Familia="'+@Familia+'"/> </Solicitud> </Intelisis>'
SELECT  @Usuario =  dbo.fnAccesoUsuario(@@SPID)
SELECT @Contrasena = Contrasena
FROM Usuario
WITH(NOLOCK) WHERE Usuario = @Usuario
EXEC spIntelisisService  @Usuario,@Contrasena,@Datos,@Resultado,@Ok Output,@OkRef Output,1,0,@Id Output
END

