SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROC spInforGenerarSolicitudProveedor
@Proveedor         varchar (10),
@Estatus		  varchar (10),
@ReferenciaIntelisisService			varchar(50),
@Datos			  varchar (max) OUTPUT

AS
BEGIN
DECLARE
@AccesoID							int,
@Usuario						    varchar(10),
@Ok									int,
@OkRef								varchar(255),
@Contrasena							varchar(32),
@Resultado							varchar(max),
@Id									int
IF @Estatus IN ('ALTA','CAMBIO')
SELECT @Datos = '<?xml version="1.0" encoding="windows-1252"?><Intelisis Sistema="Intelisis" Contenido="Solicitud" Referencia="Intelisis.Interfaz.Infor.Transferencia.Prov" SubReferencia="'+@Estatus+'" Version="1.0">
<Solicitud> <Prov  Proveedor="'+@Proveedor+'"/>  </Solicitud> </Intelisis>'
IF @Estatus = 'BAJA'
SELECT @Datos = '<?xml version="1.0" encoding="windows-1252"?><Intelisis Sistema="Infor" Contenido="Solicitud" Referencia="Intelisis.Interfaz.Infor.Baja.Prov" SubReferencia="'+@Estatus+'" Version="1.0">
<Solicitud><Prov  Proveedor="'+@Proveedor+'"/> </Solicitud> </Intelisis>'
SELECT  @Usuario =  dbo.fnAccesoUsuario(@@SPID)
SELECT @Contrasena = Contrasena
FROM Usuario
WHERE Usuario = @Usuario
EXEC spIntelisisService  @Usuario,@Contrasena,@Datos,@Resultado,@Ok Output,@OkRef Output,0,0,@Id Output
IF @ID IS NOT NULL
INSERT ProcesarIntelisisService (ID, Solicitud) VALUES (@ID, 'Proveedor')
END

