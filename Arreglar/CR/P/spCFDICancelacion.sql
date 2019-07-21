SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spCFDICancelacion
@Modulo varchar(10),
@ID int,
@Estatus varchar(20),
@Empresa varchar(10),
@Sucursal int,
@ok int = null OUTPUT,
@okref varchar(255) = null OUTPUT

AS BEGIN
DECLARE
@Fechatimbrado			varchar(20),
@ServidorPAC			varchar(100),
@UsuarioPAC				varchar(100),
@PaswordPAC				varchar(100),
@AccionCFDI				varchar(50),
@RutaCer				varchar(200),
@RutaKey				varchar(200),
@passKey				varchar(100),
@UUID					varchar(40),
@RFC					varchar(20),
@AlmacenarRuta			varchar(200),
@Documento				varchar(max),
@RutaTimbrarCFD			varchar(200),
@CadenaConexion			varchar(max),
@PswPFX					varchar(30),
@DatosXMl				varchar(max),
@RenglonDatos			varchar(255),
@Error					bit,
@xml					xml,
@RID					int,
@iDatos					int,
@DocumentoXML			xml,
@PrefijoCFDI			varchar(255),
@Shell					varchar(8000),
@r						varchar(max),
@FirmaCancelacionSAT varchar(max),
@FechaCancelacionSAT varchar(30),
@Mov					varchar(20),
@Usuario				varchar(10),
@Adicional				bit,
@AlmacenarXML			bit,
@AlmacenarPDF			bit,
@EnviarXML				bit,
@EnviarPDF				bit,
@Archivo				varchar(255),
@NomArch				varchar(255),
@Ruta					varchar(255),
@PDFExiste				int,
@ArchivoPDF				varchar(255),
@Enviar					bit,
@Reporte				varchar(100),
@Contacto				varchar(10),
@eMail					varchar(255),
@Para					varchar(255),
@Asunto					varchar(max),
@Mensaje				varchar(max),
@Cancelacion			bit,
@EsCFD				    bit,
@EsCFDFlex				bit,
@TimeOutTimbrado		int,
@MensajeSF				varchar(max),
@Dato1					varchar(max),
@SelloCancelacionSAT	varchar(max),
@EstatusCancelacion		varchar(10),
@ModoPruebas			bit
DECLARE @Datos TABLE (ID int identity(1,1), Datos varchar(255))
IF (SELECT ISNULL(CFD, 0) FROM Empresa WHERE Empresa = @Empresa) = 1
SELECT @EsCFD = 1
ELSE
IF (SELECT ISNULL(CFDFlex, 0) FROM EmpresaGral WHERE Empresa = @Empresa) = 1
SELECT @EsCFDFlex = 1
SELECT @Fechatimbrado = convert(varchar(20),FechaTimbrado,127), @UUID = UUID, @Documento = Documento, @SelloCancelacionSAT = SelloCancelacionSAT FROM CFD WHERE Modulo = @Modulo AND ModuloID = @ID
SELECT @RFC = RFC FROM Empresa WHERE Empresa = @Empresa
SELECT @RutaTimbrarCFD = RutaTimbrarCFDI, @ServidorPAC = UPPER(TimbrarCFDIServidor), @UsuarioPAC = CASE TimbrarCFDIServidor WHEN 'EKOMERCIO' THEN CancelarCFDIUsuario ELSE TimbrarCFDIUsuario END, @PaswordPAC = CASE TimbrarCFDIServidor WHEN 'EKOMERCIO' THEN  CancelarCFDIPassword ELSE TimbrarCFDIPassword END,
@RutaCer = CASE WHEN @EsCFDFlex = 1 THEN RutaCertificado ELSE Certificado END, @RutaKey = Llave, @passKey = ContrasenaSello, @TimeOutTimbrado = CONVERT(varchar(30),TimeOutTimbrado),
@ModoPruebas = ModoPruebas
FROM EmpresaCFD WHERE Empresa = @Empresa
IF @SelloCancelacionSAT IS NOT NULL
SELECT @Ok = 71680, @OkRef = 'El Movimiento Ya Tiene Sello de Cancelacion CFDI'
IF @Estatus = 'CANCELADO'
SELECT @AccionCFDI = 'CANCELAR', @PswPFX = 'Intelisis1234567', @Cancelacion = 1
ELSE
SELECT @Ok = 30110, @OkREf = 'CFDI - El Movimiento no esta Cancelado'
SELECT @RutaTimbrarCFD = REPLACE(@RutaTimbrarCFD, 'TimbrarCFDI.EXE', 'IntelisisCFDI.exe')
IF @EsCFD = 1
SELECT @passKey = ContrasenakeyCSD FROM EmpresaCFD WHERE Empresa = @Empresa
EXEC spCFDFlexAlmacenar @Modulo, @ID, @Usuario, 0, @AlmacenarXML OUTPUT, @AlmacenarPDF OUTPUT, @Archivo OUTPUT, @Reporte OUTPUT, @Ruta OUTPUT, @Para OUTPUT, @Asunto OUTPUT, @Mensaje OUTPUT, @Contacto OUTPUT, @Sucursal OUTPUT , @Enviar OUTPUT, @EnviarXML OUTPUT, @EnviarPDF OUTPUT, @Cancelacion
SELECT @AlmacenarRuta =   @Ruta + '\' + @Archivo +'.xml'
EXEC spIntelisisCFDICancelar @Modulo, @ID, @Estatus, @Empresa, @Sucursal, @RutaTimbrarCFD, @Fechatimbrado, @ServidorPAC, @UsuarioPAC, @PaswordPAC, @AccionCFDI, @RutaCer, @RutaKey, @passKey, @UUID, @RFC, @Documento, @ModoPruebas, @AlmacenarRuta, 0, @FirmaCancelacionSAT OUTPUT, @DatosXMl OUTPUT, @Ok OUTPUT, @OkRef OUTPUT
IF @FirmaCancelacionSAT IS NOT NULL AND @OK IS NULL
BEGIN
UPDATE CFD SET Cancelado = 1, AcuseCancelado = @DatosXml, RutaAcuse = @AlmacenarRuta, SelloCancelacionSAT = @FirmaCancelacionSAT WHERE Modulo = @Modulo AND ModuloID = @ID
IF NOT EXISTS(SELECT * FROM AnexoMov WHERE Rama = @Modulo AND ID = @ID AND CFD = 1 AND Direccion =@AlmacenarRuta)
INSERT AnexoMov (Sucursal,  Rama,    ID,        Nombre,          Direccion,   Tipo,      Icono, CFD)
VALUES (@Sucursal, @Modulo, @ID, @Archivo +'.xml', @AlmacenarRuta, 'Archivo', 17,   1)
END
END

