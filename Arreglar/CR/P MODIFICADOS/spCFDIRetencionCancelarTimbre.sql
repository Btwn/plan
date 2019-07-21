SET DATEFIRST 7    
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1  
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROC spCFDIRetencionCancelarTimbre
@Modulo						varchar(5),
@ID							int,
@Proveedor					varchar(10),
@ConceptoSAT				varchar(5),
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
@EnviarPara				varchar(255),
@EnviarAsunto				varchar(255),
@EnviarMensaje			varchar(255),
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
@Version					varchar(5),
@UsarTimbrarRetencion		bit,
@Ejerc					int,
@MesIni					int,
@MesFin					int,
@CFDflex					bit,
@EsRetencion				bit
SELECT @Version = Version FROM CFDIRetencionCfg WITH (NOLOCK)
SELECT @Fechatimbrado = CONVERT(varchar(30),FechaTimbrado,127),
@UUID = CONVERT(varchar(50), UUID),
@Documento = Documento,
@SelloCancelacionSAT = SelloCancelacionSAT,
@Ejerc = Ejercicio,
@MesIni = Periodo,
@MesFin = Periodo
FROM CFDRetencion WITH (NOLOCK)
WHERE Modulo = @Modulo
AND ModuloID = @ID
AND Proveedor = @Proveedor
AND ConceptoSAT = @ConceptoSAT
SELECT @RFC = RFC FROM Empresa WITH (NOLOCK) WHERE Empresa = @Empresa
SELECT @UsarTimbrarRetencion= UsarTimbrarRetencion FROM EmpresaCFD WITH (NOLOCK) WHERE Empresa = @Empresa
SELECT @CFDflex=CFDFlex FROM EmpresaGral WITH (NOLOCK) WHERE Empresa = @Empresa
IF @UsarTimbrarRetencion =0
SELECT @RutaIntelisisCFDI = RutaIntelisisCFDI,
@ServidorPAC = TimbrarCFDIServidor,
@UsuarioPAC = CASE TimbrarCFDIServidor WHEN 'EKOMERCIO' THEN CancelarCFDIUsuario ELSE TimbrarCFDIUsuario END,
@PaswordPAC = CASE TimbrarCFDIServidor WHEN 'EKOMERCIO' THEN CancelarCFDIPassword ELSE TimbrarCFDIPassword END,
@RutaCer = RutaCertificado,
@RutaKey = Llave,
@passKey = CASE WHEN @CFDflex=1 THEN ContrasenaSello ELSE ContrasenakeyCSD END,
@TimeOutTimbrado = CONVERT(varchar(30),TimeOutTimbrado),
@ModoPruebas = ISNULL(ModoPruebas, 0)
FROM EmpresaCFD WITH (NOLOCK) WHERE Empresa = @Empresa
ELSE
SELECT @RutaIntelisisCFDI = RutaIntelisisCFDI,
@ServidorPAC = TimbrarCFDIServidor,
@UsuarioPAC = CASE TimbrarCFDIServidor WHEN 'EKOMERCIO' THEN CancelarCFDIUsuario ELSE TimbrarCFDIUsuario END,
@PaswordPAC = CASE TimbrarCFDIServidor WHEN 'EKOMERCIO' THEN CancelarCFDIPassword ELSE TimbrarCFDIPassword END,
@RutaCer = Certificado,
@RutaKey = Llave,
@passKey = ContrasenaLlave,
@TimeOutTimbrado = CONVERT(varchar(30),TimeOutTimbrado),
@ModoPruebas = ISNULL(ModoPruebas, 0)
FROM EmpresaCFDRetencion WITH (NOLOCK) WHERE Empresa = @Empresa
IF @SelloCancelacionSAT IS NOT NULL
SELECT @Ok = 71680, @OkRef = 'El Movimiento Ya Tiene Sello de Cancelacion CFDI'
SELECT @AccionCFDI = 'CANCELAR', @PswPFX = 'Intelisis1234567', @Cancelacion = 1
EXEC spCFDIRetencionAlmacenar @Empresa, @Usuario, @Proveedor, @ConceptoSAT, @Version,
@Ejerc, @MesIni, @MesFin,
@AlmacenarXML OUTPUT, @AlmacenarPDF OUTPUT,
@NomArch OUTPUT, @Reporte OUTPUT, @Ruta OUTPUT, @EnviarPara OUTPUT, @EnviarAsunto OUTPUT, @EnviarMensaje OUTPUT,
@Enviar OUTPUT, @EnviarXML OUTPUT, @EnviarPDF OUTPUT, 1
EXEC spCrearRuta @Ruta, @Ok OUTPUT, @OkRef OUTPUT
SELECT @AlmacenarRuta =   @Ruta + '\' + @NomArch +'.xml'
SELECT @EsRetencion=1
EXEC spIntelisisCFDICancelar @Modulo, @ID, @Estatus, @Empresa, @Sucursal, @RutaIntelisisCFDI, @Fechatimbrado, @ServidorPAC, @UsuarioPAC,
@PaswordPAC, @AccionCFDI, @RutaCer, @RutaKey, @passKey, @UUID, @RFC, @Documento,
@ModoPruebas, @AlmacenarRuta,@EsRetencion, @FirmaCancelacionSAT = @FirmaCancelacionSAT OUTPUT, @DatosXMl = @DatosXMl OUTPUT,
@Ok = @Ok OUTPUT, @OkRef = @OkRef OUTPUT
RETURN
END

