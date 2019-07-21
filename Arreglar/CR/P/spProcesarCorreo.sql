SET DATEFIRST 7    
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1  
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spProcesarCorreo
(
@UsuarioProceso					varchar(10)
)

AS BEGIN
DECLARE
@Archivo					varchar(max),
@Ok						int,
@OkRef					varchar(255),
@ID						int,
@Cuenta					varchar(50),
@Fecha					varchar(50),
@CantidadMensajes			int,
@Servidor					varchar(50),
@BaseDatos				varchar(50),
@Empresa					varchar(5),
@De						varchar(255),
@Para						varchar(max),
@CC						varchar(max),
@Asunto					varchar(max),
@Mensaje					varchar(max),
@Enviado					varchar(50),
@Tipo						varchar(50),
@EmpresaMov				varchar(5),
@Sucursal					int,
@Modulo					varchar(5),
@IDMov					int,
@Mov						varchar(20),
@MovID					varchar(20),
@Estatus					varchar(15),
@Situacion				varchar(50),
@Usuario					varchar(10),
@CheckSum					int,
@CadenaAutorizacionValida	bit,
@Solicitud				varchar(max),
@Resultado				varchar(max),
@Contrasena				varchar(32),
@IntelisisServiceID		int,
@Movimiento				varchar(50)
SELECT @Contrasena = Contrasena FROM Usuario WHERE Usuario = @UsuarioProceso
EXEC spLeerCorreo @Archivo OUTPUT, @Ok OUTPUT, @OkRef OUTPUT
DECLARE crCorreoRecibido CURSOR FOR
SELECT ID, Cuenta, Fecha, CantidadMensajes, Servidor, BaseDatos, Empresa, De, Para, CC, Asunto, Mensaje, Enviado
FROM CorreoRecibido
WHERE SPID = @@SPID
OPEN crCorreoRecibido
FETCH NEXT FROM crCorreoRecibido INTO @IDMov, @Cuenta, @Fecha, @CantidadMensajes, @Servidor, @BaseDatos, @Empresa, @De, @Para, @CC, @Asunto, @Mensaje, @Enviado
WHILE @@FETCH_STATUS = 0
BEGIN
SELECT @Tipo = NULL, @EmpresaMov = NULL, @Sucursal = NULL, @Modulo = NULL, @IDMov = NULL, @Estatus = NULL, @Situacion = NULL, @Usuario = NULL, @CheckSum = NULL, @CadenaAutorizacionValida = 0
EXEC spValidarCadenaAutorizacion @Mensaje, @Tipo OUTPUT, @EmpresaMov OUTPUT, @Sucursal OUTPUT, @Modulo OUTPUT, @IDMov OUTPUT, @Estatus OUTPUT, @Situacion OUTPUT, @Usuario OUTPUT, @CheckSum OUTPUT, @CadenaAutorizacionValida OUTPUT
IF @Tipo = 'AUTORIZACION'
BEGIN
EXEC spMovInfo @IDMov, @Modulo, @Mov = @Mov OUTPUT, @MovID = @MovID OUTPUT 
SELECT @Movimiento = LTRIM(RTRIM(ISNULL(@Mov,''))) + ' ' + LTRIM(RTRIM(ISNULL(@MovID,'')))
SET @Solicitud = '<Intelisis Sistema="Intelisis" Contenido="Solicitud" Referencia="Intelisis.Autorizacion" SubReferencia="' + ISNULL(@Modulo,'') + '" Version="1.0">' +
'  <Solicitud>' +
'    <Autorizacion Empresa = "' + dbo.fneDocXMLAUTF8(@EmpresaMov,0,1) + '" Sucursal="' + CONVERT(varchar,ISNULL(@Sucursal,-1))  + '" Modulo="' + LTRIM(RTRIM(dbo.fneDocXMLAUTF8(ISNULL(@Modulo,''),0,1))) + '" ID="' + LTRIM(RTRIM(CONVERT(varchar,ISNULL(@IDMov,0)))) + '" Mov="' + dbo.fneDocXMLAUTF8(LTRIM(RTRIM(ISNULL(@Mov,''))),0,1) + '" Movimiento="' + dbo.fneDocXMLAUTF8(LTRIM(RTRIM(ISNULL(@Movimiento,''))),0,1) + '" Estatus="' + LTRIM(RTRIM(dbo.fneDocXMLAUTF8(ISNULL(@Estatus,''),0,1))) + '" Situacion="' + LTRIM(RTRIM(dbo.fneDocXMLAUTF8(ISNULL(@Situacion,''),0,1))) + '" CadenaAutorizacionValida="' + LTRIM(RTRIM(CONVERT(varchar,ISNULL(@CadenaAutorizacionValida,0)))) + '" De="' + LTRIM(RTRIM(dbo.fneDocXMLAUTF8(ISNULL(@De,''),0,1))) + '" Asunto="' + LTRIM(RTRIM(dbo.fneDocXMLAUTF8(ISNULL(@Asunto,''),0,1))) + '" Mensaje="' + REPLACE(REPLACE(LTRIM(RTRIM(dbo.fneDocXMLAUTF8(ISNULL(@Mensaje,''),0,1))),'<','&#060;'),'>','&#062;') + '"/>' +
'  </Solicitud>' +
'</Intelisis>'
EXEC spIntelisisService @Usuario, @Contrasena, @Solicitud, @Resultado OUTPUT, @Ok OUTPUT, @OkRef OUTPUT, 1, 0, @IntelisisServiceID OUTPUT
END
FETCH NEXT FROM crCorreoRecibido INTO @ID, @Cuenta, @Fecha, @CantidadMensajes, @Servidor, @BaseDatos, @Empresa, @De, @Para, @CC, @Asunto, @Mensaje, @Enviado
END
CLOSE crCorreoRecibido
DEALLOCATE crCorreoRecibido
END

