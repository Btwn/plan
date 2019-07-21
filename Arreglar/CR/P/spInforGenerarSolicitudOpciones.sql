SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROC spInforGenerarSolicitudOpciones
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
@Id                                                                    int,
@Datos2                             varchar(max)
SELECT @Datos = '<?xml version="1.0" encoding="windows-1252"?><Intelisis Sistema="Intelisis" Contenido="Solicitud" Referencia="Intelisis.Interfaz.Infor.Transferencia.Opcion" SubReferencia="" Version="1.0" ><Solicitud></Solicitud> </Intelisis>'
SELECT  @Usuario =  dbo.fnAccesoUsuario(@@SPID)
SELECT @Contrasena = Contrasena
FROM Usuario
WHERE Usuario = @Usuario
EXEC spIntelisisService  @Usuario,@Contrasena,@Datos,@Resultado,@Ok Output,@OkRef Output,1,0,@Id Output
EXEC spInforGenerarSolicitudOpcionesDetalle   @Datos2
SELECT 'Operacion Completada'
END

