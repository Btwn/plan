SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROC spInforGenerarSolicitudObjetivoVentas
@FechaD                          DateTime,
@FechaA           DateTime,
@Empresa                    varchar(5),
@Sucursal          int

AS
BEGIN
DECLARE
@Usuario                                                             varchar(10),
@Ok                                                                   int,
@OkRef                                                             varchar(255),
@Contrasena                                                                 varchar(32),
@Resultado                                                                     varchar(max),
@Id                                                                    int,
@Datos                                                varchar (max)
SELECT @Datos = '<?xml version="1.0" encoding="windows-1252"?><Intelisis Sistema="Intelisis" Contenido="Solicitud" Referencia="Intelisis.Interfaz.Infor.Solicitud.ObjetivosVentas" SubReferencia="" Version="1.0">
<Solicitud> <Objetivo  FechaD="'+CONVERT(varchar,@FechaD)+'" FechaA="'+CONVERT(varchar,@FechaA)+'" Empresa="'+@Empresa+'" Sucursal="'+CONVERT(varchar,@Sucursal)+'"/>  </Solicitud> </Intelisis>'
SELECT  @Usuario =  dbo.fnAccesoUsuario(@@SPID)
SELECT @Contrasena = Contrasena
FROM Usuario
WHERE Usuario = @Usuario
EXEC spIntelisisService  @Usuario,@Contrasena,@Datos,@Resultado,@Ok Output,@OkRef Output,1,0,@Id Output
END

