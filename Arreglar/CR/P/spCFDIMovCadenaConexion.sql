SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROC spCFDIMovCadenaConexion
@Estacion      int,
@Empresa       varchar(5),
@Modulo        varchar(5),
@ID            int,
@Accion        varchar(20)  = NULL,
@RutaArchivo   varchar(max) = NULL

AS
BEGIN
DECLARE
@CadenaConexion   varchar(max),
@ServidorPAC			varchar(100),
@UsuarioPAC			varchar(100),
@PaswordPAC			varchar(100),
@AccionCFDI			varchar(50),
@RutaCer				varchar(200),
@RutaKey				varchar(200),
@passKey				varchar(100),
@RFC					varchar(20),
@Documento			varchar(max),
@RutaIntelisisCFDI	varchar(255),
@PswPFX				varchar(30),
@DatosXMl				varchar(max),
@RenglonDatos			varchar(255),
@Error				bit,
@xml					varchar(max),
@RID					int,
@iDatos				int,
@DocumentoXML			xml,
@PrefijoCFDI			varchar(255),
@Shell				varchar(8000),
@r					varchar(max),
@FirmaCancelacionSAT  varchar(max),
@FechaCancelacionSAT  varchar(30),
@FechaTimbrado		varchar(max),
@UUID				    varchar(50),
@SelloCancelacionSAT	varchar(max),
@EsCadenaOriginal		bit,
@ModoPruebas			bit,
@Existe				int,
@TokenCanPAC			varchar(max),
@CuentaCanPAC			varchar(max),
@UsuarioCanPAC		varchar(50),
@PaswordCanPAC		varchar(50),
@RutaProvPac			varchar(max),
@AlmacenarRuta		varchar(200),
@TimeOutTimbrado		int,
@Timbrar              Bit,
@RegistrarLog         bit,
@UsarTimbrarNomina	bit,
@Mov                  varchar(20),
@MovID                varchar(20)
SELECT @RFC = RFC FROM Empresa WHERE Empresa = @Empresa
EXEC spMovInfo @ID, @Modulo, @Mov = @Mov OUTPUT, @MovID = @MovID OUTPUT
SELECT
@ServidorPAC    = TimbrarCFDIServidor,
@UsuarioPAC    = TimbrarCFDIUsuario,
@PaswordPAC    = TimbrarCFDIPassword,
@TimeOutTimbrado   = ISNULL(CONVERT(varchar(30),TimeOutTimbrado),'15000'),
@ModoPruebas    = ModoPruebas,
@RegistrarLog    = RegistrarLog,
@TokenCanPAC    = ISNULL(CancelarCFDIToken,''),
@CuentaCanPAC    = ISNULL(CancelarCFDICuenta,''),
@UsuarioCanPAC =ISNULL(CancelarCFDIUsuario,''),
@PaswordCanPAC =ISNULL(CancelarCFDIPassword,''),
@RutaCer     = Certificado,
@RutaKey     = Llave,
@passKey     = ContrasenakeyCSD,
@RutaIntelisisCFDI = RutaTimbrarCFDI
FROM EmpresaCFD
WHERE Empresa = @Empresa
SELECT @RutaIntelisisCFDI = REPLACE(@RutaIntelisisCFDI,'TimbrarCFDI.EXE', 'IntelisisCFDI.exe')
IF ISNULL(@Accion,'') = ''
SELECT @AccionCFDI = 'TIMBRAR', @PswPFX = 'Intelisis1234567', @Timbrar = 1
ELSE IF ISNULL(UPPER(@Accion),'') = 'CADENAORIGINAL'
SELECT @ServidorPAC = 'INTELISIS', @AccionCFDI = UPPER(@Accion), @PswPFX = 'Intelisis1234567', @Timbrar = 1
SELECT @AlmacenarRuta = @RutaArchivo 
DECLARE @Hoy datetime
SELECT @Hoy = GETDATE()
SELECT @FechaTimbrado = CONVERT(varchar(20), @Hoy,127), @UUID = '0'
SELECT @UsarTimbrarNomina= UsarTimbrarNomina FROM EmpresaCFD WHERE Empresa = @Empresa
SELECT @CadenaConexion = '<IntelisisCFDI>'+
'<IDSESION>'+CONVERT(varchar,@@SPID)+'</IDSESION>'+
'<FECHA>'+ISNULL(@FechaTimbrado,'')+'</FECHA>'+
'<SERVIDOR>'+ISNULL(@ServidorPAC,'')+'</SERVIDOR>'+
'<USUARIO>'+ISNULL(@UsuarioPAC,'')+'</USUARIO>'+
'<PASSWORD>'+ISNULL(@PaswordPAC,'')+'</PASSWORD>'+
'<CUENTA>'+ISNULL(@CuentaCanPAC,'')+'</CUENTA>'+
'<TOKEN>'+ISNULL(@TokenCanPAC,'')+'</TOKEN>'+
'<ACCION>'+ISNULL(@AccionCFDI,'')+'</ACCION>'+
'<RUTACER>'+ISNULL(@RutaCer,'')+'</RUTACER>'+
'<RUTAKEY>'+ISNULL(@RutaKey,'')+'</RUTAKEY>'+
'<PWDKEY>'+ISNULL(@passKey,'')+'</PWDKEY>'+
'<PWDPFX>'+ISNULL(@PswPFX,'')+'</PWDPFX>'+
'<UUID>'+ISNULL(@UUID,'')+'</UUID>'+
'<RFC>'+ISNULL(@RFC,'')+'</RFC>'+
'<TIMEOUT>'+CONVERT(varchar(30),@TimeOutTimbrado)+'</TIMEOUT>'+
'<RUTAARCHIVO>'+ISNULL(@AlmacenarRuta,'')+'</RUTAARCHIVO>'+
'<GUARDARLOG>'+convert(varchar(1),@RegistrarLog)+'</GUARDARLOG>'+
'<MODOPRUEBAS>'+CONVERT(varchar(1),@ModoPruebas)+'</MODOPRUEBAS>'+
'<USARFIRMASAT>1</USARFIRMASAT>'+
'<CFDSDK>1</CFDSDK>'+
'</IntelisisCFDI>'
SELECT @CadenaConexion
RETURN
END

