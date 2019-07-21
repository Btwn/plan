SET DATEFIRST 7    
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1  
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROC spCFDINominaCancelarTimbre
@Modulo						varchar(10),
@ID							int,
@Personal					varchar(10),
@Estatus					varchar(20),
@Empresa					varchar(10),
@Sucursal					int,
@FirmaCancelacionSAT		varchar(max)	OUTPUT,
@DatosXMl					varchar(max)	OUTPUT,
@AlmacenarRuta				varchar(200)	OUTPUT,
@Archivo					varchar(255)	OUTPUT,
@Ok							int				OUTPUT,
@OkRef						varchar(255)	OUTPUT

AS
BEGIN
DECLARE @Fechatimbrado			varchar(20),
@ServidorPAC				varchar(100),
@UsuarioPAC				varchar(100),
@PaswordPAC				varchar(100),
@AccionCFDI				varchar(50),
@RutaCer					varchar(200),
@RutaKey					varchar(200),
@passKey					varchar(100),
@UUID						varchar(50),
@RFC						varchar(20),
@Documento				varchar(max),
@RutaIntelisisCFDI		varchar(255),
@CadenaConexion			varchar(max),
@PswPFX					varchar(30),
@RenglonDatos				varchar(255),
@Error					bit,
@xml						xml,
@RID						int,
@iDatos					int,
@DocumentoXML				xml,
@PrefijoCFDI				varchar(255),
@Shell					varchar(8000),
@r						varchar(max),
@FechaCancelacionSAT		varchar(30),
@Mov						varchar(20),
@Usuario					varchar(10),
@Adicional				bit,
@AlmacenarXML				bit,
@AlmacenarPDF				bit,
@EnviarXML				bit,
@EnviarPDF				bit,
@NomArch					varchar(255),
@Ruta						varchar(255),
@PDFExiste				int,
@ArchivoPDF				varchar(255),
@Enviar					bit,
@Reporte					varchar(100),
@Contacto					varchar(10),
@eMail					varchar(255),
@Para						varchar(255),
@Asunto					varchar(max),
@Mensaje					varchar(max),
@Cancelacion				bit,
@TimeOutTimbrado			int,
@MensajeSF				varchar(max),
@Dato1					varchar(max),
@SelloCancelacionSAT		varchar(max),
@EstatusCancelacion		varchar(10),
@ModoPruebas				bit,
@NoTimbrado				int,
@TokenCanPAC				varchar(max),
@CuentaCanPAC				varchar(max),
@UsuarioCanPAC			varchar(50),
@PaswordCanPAC			varchar(50),
@RutaProvPac				varchar(max),
@UsarTimbrarNomina		bit
SELECT @Fechatimbrado = CONVERT(varchar(20),FechaTimbrado,127),
@UUID = CONVERT(varchar(50), UUID),
@Documento = Documento,
@SelloCancelacionSAT = SelloCancelacionSAT,
@NoTimbrado = ISNULL(NoTimbrado, 1)
FROM CFDNomina WITH (NOLOCK)
WHERE Modulo = @Modulo
AND ModuloID = @ID
AND Personal = @Personal
SELECT @RFC = RFC FROM Empresa WITH (NOLOCK) WHERE Empresa = @Empresa
/***/
SELECT @UsarTimbrarNomina=ISNULL(UsarTimbrarNomina,0),@RutaIntelisisCFDI = RutaIntelisisCFDI FROM EmpresaCFD WITH (NOLOCK) WHERE Empresa = @Empresa
IF @UsarTimbrarNomina =0
SELECT
@ServidorPAC = TimbrarCFDIServidor,
@UsuarioPAC = CASE TimbrarCFDIServidor WHEN 'EKOMERCIO' THEN CancelarCFDIUsuario ELSE TimbrarCFDIUsuario END,
@PaswordPAC = CASE TimbrarCFDIServidor WHEN 'EKOMERCIO' THEN CancelarCFDIPassword ELSE TimbrarCFDIPassword END,
@RutaCer = ISNULL(Certificado, RutaCertificado),
@RutaKey = Llave,
@passKey = ContrasenaLlave,
@TimeOutTimbrado = CONVERT(varchar(30),TimeOutTimbrado),
@ModoPruebas = ModoPruebas,
@TokenCanPAC	=ISNULL(CancelarCFDIToken,''),
@CuentaCanPAC=ISNULL(CancelarCFDICuenta,''),
@UsuarioCanPAC=ISNULL(CancelarCFDIUsuario ,''),
@PaswordCanPAC=ISNULL(CancelarCFDIPassword  ,'')
FROM EmpresaCFD WITH (NOLOCK) WHERE Empresa = @Empresa
ELSE
SELECT
@ServidorPAC = TimbrarCFDIServidor,
@UsuarioPAC = CASE TimbrarCFDIServidor WHEN 'EKOMERCIO' THEN CancelarCFDIUsuario ELSE TimbrarCFDIUsuario END,
@PaswordPAC = CASE TimbrarCFDIServidor WHEN 'EKOMERCIO' THEN CancelarCFDIPassword ELSE TimbrarCFDIPassword END,
@RutaCer = Certificado,
@RutaKey = Llave,
@passKey = ContrasenaLlave,
@ModoPruebas = ModoPruebas,
@TokenCanPAC	=ISNULL(CancelarCFDIToken,''),
@CuentaCanPAC=ISNULL(CancelarCFDICuenta,''),
@UsuarioCanPAC=ISNULL(CancelarCFDIUsuario ,''),
@PaswordCanPAC=ISNULL(CancelarCFDIPassword  ,'')
FROM EmpresaCFDNomina WITH (NOLOCK) WHERE Empresa = @Empresa
/***/
IF @SelloCancelacionSAT IS NOT NULL
SELECT @Ok = 71680, @OkRef = 'El Movimiento Ya Tiene Sello de Cancelacion CFDI'
SELECT @AccionCFDI = 'CANCELAR', @PswPFX = 'Intelisis1234567', @Cancelacion = 1
EXEC spCFDNominaAlmacenar 'NOM', @ID, @AlmacenarXML OUTPUT, @AlmacenarPDF OUTPUT, @NomArch OUTPUT, @Reporte OUTPUT, @Ruta OUTPUT, @Para OUTPUT,
@Asunto OUTPUT, @Mensaje OUTPUT, @Personal OUTPUT, @Sucursal OUTPUT, @Enviar OUTPUT, @EnviarXML OUTPUT, @EnviarPDF OUTPUT,
@Cancelacion, @NoTimbrado
EXEC spCrearRuta @Ruta, @Ok OUTPUT, @OkRef OUTPUT
SELECT @AlmacenarRuta =   @Ruta + '\' + @NomArch +'.xml'
EXEC spIntelisisCFDICancelar @Modulo, @ID, @Estatus, @Empresa, @Sucursal, @RutaIntelisisCFDI, @Fechatimbrado, @ServidorPAC, @UsuarioPAC,
@PaswordPAC, @AccionCFDI, @RutaCer, @RutaKey, @passKey, @UUID, @RFC, @Documento,
@ModoPruebas, @AlmacenarRuta,0, @FirmaCancelacionSAT = @FirmaCancelacionSAT OUTPUT, @DatosXMl = @DatosXMl OUTPUT,
@Ok = @Ok OUTPUT, @OkRef = @OkRef OUTPUT
END

