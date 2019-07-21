SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROC spInforGenerarSolicitudUsuario
@Usuario					varchar (10),
@Estatus					varchar (10),
@ReferenciaIntelisisService	varchar(50),
@Nombre						varchar (10),
@Alta						datetime,
@Datos						varchar (max) OUTPUT

AS
BEGIN
DECLARE
@AccesoID		int,
@Usuario1		varchar(10),
@Ok				int,
@OkRef			varchar(255),
@Contrasena		varchar(32),
@Resultado		varchar(max),
@Id				int
IF @Estatus IN ('ALTA','CAMBIO')
BEGIN
SELECT	@Datos = '<?xml version="1.0" encoding="windows-1252"?><Intelisis Sistema="Intelisis" Contenido="Solicitud" Referencia="Intelisis.Interfaz.Infor.Transferencia.Usuario" SubReferencia="'+@Estatus+'" Version="1.0"><Solicitud IntelisisServiceID="" Ok="" OkRef="" ReferenciaIntelisisService="" ><Usuario  Usuario="'+@Usuario+'"	Nombre="'+@Nombre+'"/>  </Solicitud> </Intelisis>'
END
IF @Estatus = 'BAJA'
BEGIN
SELECT	@Datos = '<?xml version="1.0" encoding="windows-1252"?><Intelisis Sistema="Infor" Contenido="Solicitud" Referencia="Infor.Cuenta.Usuario.Mantenimiento" SubReferencia="'+@Estatus+'" Version="1.0" ReferenciaIntelisisService='+ CHAR(34)+ ISNULL(@ReferenciaIntelisisService,'')+CHAR(34)+' ><Solicitud IntelisisServiceID="" Ok="" OkRef="" ReferenciaIntelisisService="" ><Usuario Usuario="'+@Usuario+'"	Nombre="'+@Nombre+'" FechaDeAlta="'+isnull(convert(varchar(19), @Alta, 121),'')+'"/> </Solicitud> </Intelisis>'
END
SELECT  @Usuario1 =  dbo.fnAccesoUsuario(@@SPID)
SELECT	@Contrasena = Contrasena
FROM	Usuario
WHERE	Usuario = @Usuario1
IF NOT EXISTS (SELECT ID FROM IntelisisService WHERE Solicitud =  @Datos AND Usuario = @Usuario1 AND ESTATUS = 'SINPROCESAR')
BEGIN
EXEC spIntelisisService  @Usuario1,@Contrasena,@Datos,@Resultado,@Ok Output,@OkRef Output,0,0,@Id Output
IF @ID IS NOT NULL
INSERT ProcesarIntelisisService (ID, Solicitud) VALUES (@ID, 'Usuario')
END
END

