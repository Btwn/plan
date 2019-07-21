SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spCFDICadenaConexion
@Empresa  varchar(5),
@Usuario  varchar(10)

AS BEGIN
DECLARE
@Conexion   varchar(max),
@ServidorPAC  varchar(100),
@UsuarioPAC   varchar(100),
@PaswordPAC   varchar(100),
@ModoPruebas  bit,
@TimeOutTimbrado int,
@FechaTimbrado  varchar(max),
@AccionCFDI   varchar(50),
@PswPFX    varchar(30),
@Timbrar            bit,
@RFC                varchar(20),
@RegistrarLog       bit,
@TokenCanPAC        varchar(max),
@CuentaCanPAC       varchar(max),
@UsarIntelisisCFDI  bit,
@RutaCer            varchar(8000),
@RutaKey            varchar(8000),
@passKey            varchar(50)
SELECT
@ServidorPAC    = TimbrarCFDIServidor,
@UsuarioPAC    = TimbrarCFDIUsuario,
@PaswordPAC    = TimbrarCFDIPassword,
@TimeOutTimbrado   = ISNULL(CONVERT(varchar(30),TimeOutTimbrado),'15000'),
@ModoPruebas    = ModoPruebas,
@RegistrarLog    = RegistrarLog,
@TokenCanPAC    = ISNULL(CancelarCFDIToken,''),
@CuentaCanPAC    = ISNULL(CancelarCFDICuenta,''),
@UsarIntelisisCFDI  = UsarIntelisisCFDI,
@RutaCer     = Certificado,
@RutaKey     = Llave,
@passKey     = ContrasenakeyCSD
FROM EmpresaCFD
WHERE Empresa = @Empresa
SELECT @RFC = RFC FROM Empresa WHERE Empresa = @Empresa
SELECT @FechaTimbrado = CONVERT(varchar(20),getdate(),127)
SELECT @AccionCFDI = 'SOLOTIMBRAR', @PswPFX = 'Intelisis1234567', @Timbrar = 1, @RegistrarLog = 0
SELECT @Conexion = '<IntelisisCFDI>'+
'<FECHA>'+@FechaTimbrado+'</FECHA>'+
'<IDSESION>'+CONVERT(varchar,@@SPID)+'</IDSESION>'+
'<FECHA>'+@FechaTimbrado+'</FECHA>'+
'<SERVIDOR>'+@ServidorPAC+'</SERVIDOR>'+
'<USUARIO>'+@UsuarioPAC+'</USUARIO>'+
'<PASSWORD>'+@PaswordPAC+'</PASSWORD>'+
'<CUENTA>'+ISNULL(@CuentaCanPAC,'')+'</CUENTA>'+
'<TOKEN>'+ISNULL(@TokenCanPAC,'')+'</TOKEN>'+
'<ACCION>'+@AccionCFDI+'</ACCION>'+
'<RUTACER>'+@RutaCer+'</RUTACER>'+
'<RUTAKEY>'+@RutaKey+'</RUTAKEY>'+
'<PWDKEY>'+@passKey+'</PWDKEY>'+
'<PWDPFX>'+@PswPFX+'</PWDPFX>'+
'<UUID>'+'0'+'</UUID>'+
'<RFC>'+@RFC+'</RFC>'+
'<TIMEOUT>'+CONVERT(varchar(30),@TimeOutTimbrado)+'</TIMEOUT>'+
'<RUTAARCHIVO>'+'</RUTAARCHIVO>'+
'<RUTAARCHIVOOUT>'+'</RUTAARCHIVOOUT>'+
'<GUARDARARCHIVO>'+'1'+'</GUARDARARCHIVO>'+
'<GUARDARLOG>'+convert(varchar(1),@RegistrarLog)+'</GUARDARLOG>'+
'<MODOPRUEBAS>'+CONVERT(varchar(1),@ModoPruebas)+'</MODOPRUEBAS>'+
'<Aplicacion>IntelisisCFDI</Aplicacion>'+
'</IntelisisCFDI>'
SELECT @Conexion
RETURN
END

