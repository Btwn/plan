SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spCFDFLexContratoAspelFirmar
@Estacion	int,
@Empresa	varchar(5)

AS BEGIN
DECLARE
@RutaFirmarContratoAspel	varchar(max),
@RutaTemporal				varchar(max),
@ArchivoTemporal			varchar(max),
@ArchivoObtener				varchar(max),
@Shell						varchar(8000),
@SQL						nvarchar(max),
@CertificadoEmisor			varchar(255),
@LlaveEmisor				varchar(255),
@ContrasenaFirma			varchar(50),
@UsuarioEmisor				varchar(50),
@RFCEmisor					varchar(50),
@Existe						bit,
@Ok							int,
@OkRef						varchar(255),
@CadenaConexion				varchar(max),
@Rfc						varchar(20),
@ModoPruebas				bit,
@ServidorPAC				varchar(100),
@UsuarioPAC					varchar(100),
@PaswordPAC					varchar(100),
@CFDFlex					bit
IF (OBJECT_ID('Tempdb..#CFDFlexLeerArchivo')) IS NOT NULL
DROP TABLE #CFDFlexLeerArchivo
CREATE TABLE #CFDFlexLeerArchivo
(
ArchivoXML varchar(max) COLLATE Modern_Spanish_CS_AS NOT NULL
)
SELECT @CFDFlex = CFDFlex FROM EmpresaGral WHERE Empresa = @Empresa
SELECT
@ServidorPAC       = TimbrarCFDIServidor,
@UsuarioPAC        = TimbrarCFDIUsuario,
@PaswordPAC        = TimbrarCFDIPassword,
@RutaFirmarContratoAspel = RutaIntelisisCFDI,
@CertificadoEmisor = RutaCertificado,
@LlaveEmisor = Llave,
@ContrasenaFirma = CASE WHEN @CFDFlex = 1 THEN ContrasenaSello ELSE ContrasenakeyCSD END,
@RutaTemporal = RutaTemporal,
@UsuarioEmisor = 'DEMO',
@ModoPruebas = ModoPruebas
FROM EmpresaCFD
WHERE Empresa = @Empresa
SELECT @RFC = RFC FROM Empresa WHERE Empresa = @Empresa
SELECT @RFCEmisor = RFC FROM Empresa WHERE Empresa = @Empresa
SELECT @ArchivoObtener = @RutaTemporal + CASE WHEN SUBSTRING(REVERSE(@RutaTemporal),1,1) <> '\' THEN '\' ELSE '' END + 'Contrato_CFDI_Obtener_Aspel.XML'
SELECT @ArchivoTemporal = @RutaTemporal + CASE WHEN SUBSTRING(REVERSE(@RutaTemporal),1,1) <> '\' THEN '\' ELSE '' END + 'Contrato_CFDI_Firmado_Aspel.XML'
SET @CadenaConexion = '<IntelisisCFDI>'+
'<IDSESION>'+convert(varchar,@@SPID)+'</IDSESION>'+
'<FECHA>'+ CONVERT (varchar, GETDATE())+'</FECHA>'+
'<SERVIDOR>ASPEL</SERVIDOR>'+
'<USUARIO>'+@UsuarioPAC+'</USUARIO>'+
'<PASSWORD>'+@PaswordPAC+'</PASSWORD>'+
'<CUENTA></CUENTA>'+
'<TOKEN></TOKEN>'+
'<ACCION>FIRMARCONTRATO</ACCION>'+
'<RUTACER>'+@CertificadoEmisor+'</RUTACER>'+
'<RUTAKEY>'+@LlaveEmisor+'</RUTAKEY>'+
'<PWDKEY>'+@ContrasenaFirma+'</PWDKEY>'+
'<PWDPFX></PWDPFX>'+
'<UUID></UUID>'+
'<RFC>'+@RFC+'</RFC>'+
'<TIMEOUT>15000</TIMEOUT>'+
'<RUTAARCHIVO>'+@ArchivoObtener+'</RUTAARCHIVO>'+
'<RUTAARCHIVOOUT>'+@ArchivoTemporal+'</RUTAARCHIVOOUT>'+
'<MODOPRUEBAS>'+CONVERT(varchar(1),@ModoPruebas)+'</MODOPRUEBAS>'+
'<USARFIRMASAT>1</USARFIRMASAT>'+
'</IntelisisCFDI>'
SELECT @Shell = CHAR(34)+CHAR(34)+@RutaFirmarContratoAspel+CHAR(34)+' '+CHAR(34)+@CadenaConexion+CHAR(34)+CHAR(34)
EXEC spEliminarArchivo @ArchivoTemporal, @Ok OUTPUT, @OkRef OUTPUT
IF @OK IS NULL
BEGIN
EXEC xp_cmdshell @Shell, no_output
EXEC spVerificarArchivo @ArchivoTemporal, @Existe OUTPUT, @Ok OUTPUT, @OkRef OUTPUT
END
IF @Existe = 0 AND @OK IS NULL
SELECT @OK = 71525, @OkRef = @ArchivoTemporal
SET @SQL = N'INSERT INTO #CFDFlexLeerArchivo
SELECT CONVERT(varchar(max),CONVERT(xml,BulkColumn)) FROM OPENROWSET(
BULK ''' +  @ArchivoTemporal + ''', SINGLE_BLOB)AS x'
IF @Existe = 1 AND @Ok IS NULL
BEGIN
EXEC (@SQL)
UPDATE EmpresaCFD SET ContatoFirmadoAspel = (SELECT ArchivoXML FROM #CFDFlexLeerArchivo) WHERE Empresa = @Empresa
END
ELSE
BEGIN
SELECT @OkRef = Descripcion + ' ' + @OkRef FROM MensajeLista WHERE Mensaje = @Ok
SELECT 'Error - ' + CONVERT(varchar,@Ok) + '<BR><BR>' + @OkRef
END
END

