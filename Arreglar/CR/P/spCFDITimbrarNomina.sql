SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROC spCFDITimbrarNomina
@Modulo				varchar(10),
@ID					int,
@Personal			varchar(10),
@Estatus			varchar(20),
@Empresa			varchar(10),
@Sucursal			int,
@CFDI				varchar(max),
@CFDITimbrado		varchar(max) OUTPUT,
@CadenaOriginal		varchar(max) OUTPUT,
@SelloSAT			varchar(max) OUTPUT,
@SelloCFD			varchar(max) OUTPUT,
@FechaTimbrado		varchar(max) OUTPUT,
@UUID				varchar(50)	 OUTPUT,
@TFDVersion			varchar(max) OUTPUT,
@noCertificadoSAT	varchar(max) OUTPUT,
@TFDCadenaOriginal	varchar(max) OUTPUT,
@Ok					int			 OUTPUT,
@OkRef				varchar(255) OUTPUT

AS
BEGIN
DECLARE @ServidorPAC			varchar(100),
@UsuarioPAC			varchar(100),
@PaswordPAC			varchar(100),
@AccionCFDI			varchar(50),
@RutaCer				varchar(200),
@RutaKey				varchar(200),
@passKey				varchar(100),
@RFC					varchar(20),
@AlmacenarRuta		varchar(200),
@Documento			varchar(max),
@RutaIntelisisCFDI	varchar(255),
@CadenaConexion		varchar(max),
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
@Mov					varchar(20),
@Usuario				varchar(10),
@Adicional			bit,
@AlmacenarXML			bit,
@AlmacenarPDF			bit,
@EnviarXML			bit,
@EnviarPDF			bit,
@Archivo				varchar(255),
@NomArch				varchar(255),
@Ruta					varchar(255),
@PDFExiste			int,
@ArchivoPDF			varchar(255),
@Enviar				bit,
@Reporte				varchar(100),
@Contacto				varchar(10),
@eMail				varchar(255),
@Para					varchar(255),
@Asunto				varchar(max),
@Mensaje				varchar(max),
@Cancelacion			bit,
@TimeOutTimbrado		int,
@MensajeSF			varchar(max),
@Dato1				varchar(max),
@SelloCancelacionSAT	varchar(max),
@Timbrar				bit,
@EsCadenaOriginal		bit,
@ModoPruebas			bit,
@Existe				int,
@NoTimbrado			int,
@TokenCanPAC			varchar(max),
@CuentaCanPAC			varchar(max),
@UsuarioCanPAC		varchar(50),
@PaswordCanPAC		varchar(50),
@RutaProvPac			varchar(max),
@UsarTimbrarNomina    bit,
@CFDflex				bit
DECLARE @Datos TABLE (ID int IDENTITY(1,1), Datos varchar(255))
SELECT @FechaTimbrado = CONVERT(varchar(20),FechaTimbrado,127), @UUID = UUID, @Documento = Documento, @SelloCancelacionSAT = SelloCancelacionSAT FROM CFDNomina WHERE Modulo = @Modulo AND ModuloID = @ID AND Personal = @Personal
SELECT @RFC = RFC FROM Empresa WHERE Empresa = @Empresa
SELECT @RutaIntelisisCFDI = RutaIntelisisCFDI,
@TimeOutTimbrado = CONVERT(varchar(30),TimeOutTimbrado)
FROM EmpresaCFD WHERE Empresa = @Empresa
SELECT @CFDflex = CFDFlex FROM EmpresaGral WHERE Empresa = @Empresa
SELECT @UsarTimbrarNomina=ISNULL(UsarTimbrarNomina,0) FROM EmpresaCFD WHERE Empresa = @Empresa
IF @UsarTimbrarNomina =0
SELECT
@ServidorPAC = TimbrarCFDIServidor,
@UsuarioPAC = TimbrarCFDIUsuario,
@PaswordPAC = TimbrarCFDIPassword,
@RutaCer = ISNULL(Certificado,RutaCertificado),
@RutaKey = Llave,
@passKey = CASE WHEN @CFDflex = 1 THEN ContrasenaSello ELSE ContrasenakeyCSD END,
@ModoPruebas = ModoPruebas,
@TokenCanPAC	=ISNULL(CancelarCFDIToken,''),
@CuentaCanPAC=ISNULL(CancelarCFDICuenta,''),
@UsuarioCanPAC=ISNULL(CancelarCFDIUsuario ,''),
@PaswordCanPAC=ISNULL(CancelarCFDIPassword  ,'')
FROM EmpresaCFD WHERE Empresa = @Empresa
ELSE
SELECT
@ServidorPAC = TimbrarCFDIServidor,
@UsuarioPAC = TimbrarCFDIUsuario,
@PaswordPAC = TimbrarCFDIPassword,
@RutaCer = Certificado,
@RutaKey = Llave,
@passKey = ContrasenaLlave,
@ModoPruebas = ModoPruebas,
@TokenCanPAC	=ISNULL(CancelarCFDIToken,''),
@CuentaCanPAC=ISNULL(CancelarCFDICuenta,''),
@UsuarioCanPAC=ISNULL(CancelarCFDIUsuario ,''),
@PaswordCanPAC=ISNULL(CancelarCFDIPassword  ,'')
FROM EmpresaCFDNomina WHERE Empresa = @Empresa
IF @UUID IS NOT NULL
SELECT @Ok = 71680, @OkRef = 'El Movimiento Ya Fue Timbrado'
IF @Estatus = 'CONCLUIDO'
SELECT @AccionCFDI = 'TIMBRAR', @PswPFX = 'Intelisis1234567', @Timbrar = 1
ELSE
SELECT @Ok = 30110, @OkREf = 'CFDI - El Movimiento no esta CONCLUIDO'
SELECT @NoTimbrado = MAX(NoTimbrado) FROM CFDNominaCancelado WHERE Modulo = 'NOM' AND ModuloID = @ID AND Personal = @Personal
SELECT @NoTimbrado = ISNULL(@NoTimbrado, 0) + 1
EXEC spCFDNominaAlmacenar @Modulo, @ID, @AlmacenarXML OUTPUT, @AlmacenarPDF OUTPUT, @Archivo OUTPUT, @Reporte OUTPUT, @Ruta OUTPUT, @Para OUTPUT, @Asunto OUTPUT, @Mensaje OUTPUT, @Personal OUTPUT, @Sucursal OUTPUT , @Enviar OUTPUT, @EnviarXML OUTPUT, @EnviarPDF OUTPUT, 0, @NoTimbrado
SELECT @AlmacenarRuta =   @Ruta + '\' + @Archivo +'.tmp'
DECLARE @Hoy datetime
SELECT @Hoy = GETDATE()
SELECT @FechaTimbrado = CONVERT(varchar(20), @Hoy,127), @UUID = '0'
IF @RutaIntelisisCFDI IS NULL SELECT @Ok = 10060, @OkRef = 'Dato Ruta Intelisis CFDI no Puede Estar Vacio' ELSE
IF @FechaTimbrado IS NULL SELECT @Ok = 10060, @OkRef = 'Dato Fecha de Timbrado no Puede Estar Vacio' ELSE
IF @ServidorPAC IS NULL SELECT @Ok = 10060, @OkRef = 'Dato Servidor PAC No puede Estar Vacio' ELSE
IF @RutaCer IS NULL SELECT @Ok = 10060, @OkRef = 'Dato Ruta Certificado CSD No puede Estar Vacio' ELSE
IF @RutaKey IS NULL SELECT @Ok = 10060, @OkRef = 'Dato Ruta Archivo Key No puede Estar Vacio' ELSE
IF @passKey IS NULL SELECT @Ok = 10060, @OkRef = 'Dato Password Key No puede Estar Vacio' ELSE
IF @UUID IS NULL SELECT @Ok = 10060, @OkRef = 'Dato Folio Fiscal UUID No puede Estar Vacio' ELSE
IF @RFC IS NULL SELECT @Ok = 10060, @OkRef = 'Dato RFC Empresa No puede Estar Vacio' ELSE
IF @AlmacenarRuta IS NULL SELECT @Ok = 10060, @OkRef = 'Dato Almacenar Ruta No puede Estar Vacio'
IF @ServidorPAC='KONESH' AND @UsarTimbrarNomina=1
BEGIN
SET @UsuarioPAC=@UsuarioPAC
SET @PaswordPAC=@PaswordPAC
IF @CuentaCanPAC IS NULL SELECT @Ok = 10060, @OkRef = 'Dato Cuenta PAC No puede Estar Vacio' ELSE
IF @TokencanPAC IS NULL SELECT @Ok = 10060, @OkRef = 'Dato Token PAC No puede Estar Vacio'
END
ELSE IF @ServidorPAC='KONESH' AND @UsarTimbrarNomina=0
BEGIN
SET @UsuarioPAC=@UsuarioCanPAC
SET @PaswordPAC=@PaswordCanPAC
IF @CuentaCanPAC IS NULL SELECT @Ok = 10060, @OkRef = 'Dato Cuenta PAC No puede Estar Vacio' ELSE
IF @TokencanPAC IS NULL SELECT @Ok = 10060, @OkRef = 'Dato Token PAC No puede Estar Vacio'
END
IF @UsuarioPAC IS NULL SELECT @Ok = 10060, @OkRef = 'Dato Usuario PAC No puede Estar Vacio' ELSE
IF @PaswordPAC IS NULL SELECT @Ok = 10060, @OkRef = 'Dato Pasword PAC No puede Estar Vacio'
IF @Ok IS NULL
EXEC spCFDNominaGenerarArchivo @Empresa, @AlmacenarRuta, @CFDI,@ServidorPAC, @Ok OUTPUT, @OkRef OUTPUT
IF @Ok IS NULL
BEGIN
SELECT @CadenaConexion = '<IntelisisCFDI>'+
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
'<UUID>'+@UUID+'</UUID>'+
'<RFC>'+@RFC+'</RFC>'+
'<TIMEOUT>'+CONVERT(varchar(30),@TimeOutTimbrado)+'</TIMEOUT>'+
'<RUTAARCHIVO>'+@AlmacenarRuta+'</RUTAARCHIVO>'+
'<MODOPRUEBAS>'+CONVERT(varchar(1),@ModoPruebas)+'</MODOPRUEBAS>'+
'</IntelisisCFDI>'
SELECT @Shell = CHAR(34)+CHAR(34)+@RutaIntelisisCFDI+CHAR(34)+' '+CHAR(34)+@CadenaConexion+CHAR(34)+CHAR(34)
INSERT @Datos
EXEC @r =  xp_cmdshell @Shell
EXEC spVerificarArchivo @AlmacenarRuta, @Existe OUTPUT, @Ok OUTPUT, @OkRef OUTPUT
END
IF @Ok IS NULL
BEGIN
SELECT @DatosXMl = '', @CadenaOriginal = '', @EsCadenaOriginal = 0
DECLARE crResultadoXMl CURSOR FOR
SELECT Id, Datos FROM @Datos WHERE Datos IS NOT NULL ORDER BY ID Asc
OPEN crResultadoXMl
FETCH NEXT FROM crResultadoXMl INTO @RID, @RenglonDatos
WHILE @@FETCH_STATUS <> -1
BEGIN
IF @@FETCH_STATUS <> -2
BEGIN
IF @RID = 1 AND CHARINDEX('<IntelisisCFDI><Error>',@RenglonDatos) >= 1
SELECT @Error = 1
IF @RID = 1 AND CHARINDEX('<',@RenglonDatos) = 0
SELECT @Error = 1
SELECT @DatosXMl = @DatosXML + @RenglonDatos
END
FETCH NEXT FROM crResultadoXMl INTO @RID, @RenglonDatos
END
CLOSE crResultadoXMl
DEALLOCATE crResultadoXMl
IF @Error = 1 SELECT @Ok = 71650,  @OkRef = @DatosXml
IF @r <> 0
SELECT @OK = 71650, @OkREf = 'Error al Ejecutar IntelisisCFDI.exe '+ISNULL(@DatosXml,'')
IF NULLIF(@DatosXMl,'') IS NULL SELECT @Ok = 71650, @OkRef = 'Se Esperaba Respuesta de IntelisisCFDI.exe'
IF @Ok is NULL
BEGIN
IF CHARINDEX('<CADENAORIGINAL>', @DatosXML, 0) <> 0
BEGIN
SELECT @CadenaOriginal = SUBSTRING(@DatosXML, CHARINDEX('<CADENAORIGINAL>', @DatosXML, 0), LEN(@DatosXML) - CHARINDEX('<CADENAORIGINAL>', @DatosXML, 0) + 1)
SELECT @DatosXML = SUBSTRING(@DatosXML, 1, CHARINDEX('<CADENAORIGINAL>', @DatosXML, 0) - 1)
END
ELSE
SELECT @CadenaOriginal = ''
SELECT @CadenaOriginal = REPLACE(REPLACE(@CadenaOriginal,'<CADENAORIGINAL>',''),'</CADENAORIGINAL>','')
/*
BEGIN TRY
SELECT @XML = CONVERT(xml,@DatosXml)
END TRY
BEGIN CATCH
SELECT @Ok = 71600, @OkRef = dbo.fnOkRefSQL(ERROR_NUMBER(), ERROR_MESSAGE())
END CATCH
*/
SELECT @XML = @DatosXml
IF @OK IS NULL
BEGIN
EXEC spCFDINominaObtenerTimbre @Modulo, @Id, @Personal, @DatosXML, @CadenaOriginal OUTPUT, @SelloSAT OUTPUT, @SelloCFD OUTPUT, @FechaTimbrado OUTPUT, @UUID OUTPUT, @TFDVersion OUTPUT, @noCertificadoSAT OUTPUT, @TFDCadenaOriginal OUTPUT, @Ok OUTPUT, @OkRef OUTPUT
SELECT @CFDITimbrado = @DatosXML
END
END
END
END

