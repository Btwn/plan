SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spCFDFlexTimbrarCFDI
@Estacion				int,
@Empresa				varchar(5),
@Modulo					varchar(5),
@Mov					varchar(20),
@MovID					varchar(20),
@Archivo				varchar(255),
@XML					varchar(max) OUTPUT,
@Ok						int = NULL OUTPUT,
@OkRef					varchar(255) = NULL OUTPUT

AS BEGIN
DECLARE
@RutaTimbrarCFDI			varchar(255),
@RutaUTFToAnsi				varchar(255),
@Shell						varchar(8000),
@ArchivoTimbreOUT			varchar(255),
@ArchivoTimbreOUTAnsi		varchar(255),
@ArchivoTimbreIN			varchar(255),
@Timbre						varchar(max),
@Conexion					varchar(max),
@TimbrarCFDIServidor		varchar(100),
@TimbrarCFDIUsuario			varchar(100),
@TimbrarCFDIPassword		varchar(100),
@XMLComprobante				varchar(max),
@XMLAddenda					varchar(max),
@TimbreConAddenda			varchar(max),
@ArchivoTimbreOUTUUID		varchar(max),
@UUID						varchar(max),
@Error						bit,
@ArchivoXML					varchar(max),
@Resultado					int,
@CadenaOriginal             varchar(max),
@UsarIntelisisCFDI          bit,
@Existe                     int
SELECT
@RutaTimbrarCFDI     = RutaTimbrarCFDI,
@RutaUTFToAnsi		 = RutaAnsiToUTF,
@TimbrarCFDIServidor = TimbrarCFDIServidor,
@TimbrarCFDIUsuario  = TimbrarCFDIUsuario,
@TimbrarCFDIPassword = TimbrarCFDIPassword,
@UsarIntelisisCFDI = UsarIntelisisCFDI
FROM EmpresaCFD
WHERE Empresa = @Empresa
SET @Conexion = '<Funciones50><IDSESION>' + CONVERT(varchar,@@SPID) + '</IDSESION><SERVIDOR>' + ISNULL(@TimbrarCFDIServidor,'') + '</SERVIDOR><USUARIO>' + ISNULL(@TimbrarCFDIUsuario,'') + '</USUARIO><PASSWORD>' + ISNULL(@TimbrarCFDIPassword,'') + '</PASSWORD><SISTEMA></SISTEMA><RFC></RFC><RAZONSOCIAL></RAZONSOCIAL><NUMSERIE></NUMSERIE></Funciones50>'
SET @ArchivoTimbreOUT = REPLACE(@Archivo,'.XML','TimbreOut.XML')
SET @ArchivoTimbreOUTAnsi = REPLACE(@Archivo,'.XML','TimbreOutAnsi.XML')
SET @ArchivoTimbreIN = REPLACE(@Archivo,'.XML','TimbreIN.XML')
IF @Ok IS NULL
EXEC spEliminarArchivo @ArchivoTimbreIN ,@Ok OUTPUT, @OkRef OUTPUT
IF @Ok IS NULL
EXEC spEliminarArchivo @ArchivoTimbreOUT ,@Ok OUTPUT, @OkRef OUTPUT
IF @Ok IS NULL
EXEC spEliminarArchivo @ArchivoTimbreOUTAnsi ,@Ok OUTPUT, @OkRef OUTPUT
EXEC spCFDFlexSepararAddendaCFDI @XML, @XMLComprobante OUTPUT, @XMLAddenda OUTPUT
EXEC spCFDFlexRegenerarArchivo @Empresa, @ArchivoTimbreIN, @XMLComprobante, @Ok OUTPUT, @OkRef OUTPUT
EXEC xpCFDIRegistrarlog 'ANTES DE TIMBRAR', @Empresa, @Modulo, NULL, @Mov, @MovID, @XMLComprobante, 0, @Ok, @OkRef, NULL
IF @Ok IS NULL
BEGIN
EXEC spCFDFlexIntelisisCFDI @Estacion,	@Empresa, @Modulo, @Mov, @MovID, @ArchivoTimbreOUT, @XMLComprobante, @ArchivoXML OUTPUT, @CadenaOriginal OUTPUT, @Ok OUTPUT, @OkRef	OUTPUT
SELECT @ArchivoXML = REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(@ArchivoXML,'&amp;amp;','&amp;'),'&amp;quot;','&quot;'),'&amp;apos;','&apos;'),'&amp;gt;','&gt;'),'&amp;lt;','&lt;')
IF @Ok IS NULL AND @TimbrarCFDIServidor<>'G4S'
BEGIN
SET @Error = 1
IF @ArchivoXML LIKE '%<cfdi' + CHAR(58) + 'Comprobante%' OR @ArchivoXML LIKE '%<gs1' + CHAR(58) + 'invoice%'
SET @Error = 0
SET @Timbre = ISNULL(@ArchivoXML,'')
IF @Error = 1 SELECT @Ok = 71650, @OkRef = SUBSTRING(@Timbre,1,255)
END
ELSE  IF @Ok IS NULL AND @TimbrarCFDIServidor='G4S'
SET @Timbre = ISNULL(@ArchivoXML,'')
IF @TimbrarCFDIServidor<>'G4S'
SET @UUID = dbo.fnCFDFlexExtraerGUUID(@Timbre)
ELSE
SET @UUID =  SUBSTRING(@Timbre, CHARINDEX('<DocumentGUID>', @Timbre)+14, CHARINDEX('</DocumentGUID>', @Timbre)-15)
IF NULLIF(@UUID,'') IS NULL
BEGIN
SET @UUID = CONVERT(varchar(max),NEWID())
IF NULLIF(@Modulo,'') IS NULL
SET @ArchivoTimbreOUTUUID = REPLACE(@Archivo,'Temporal' + CONVERT(varchar,@Estacion) + '.XML', RTRIM(ISNULL(@Mov,'')) + '_' + RTRIM(ISNULL(@MovID,'')) + '_' + RTRIM(ISNULL(@UUID,'')) + '.XML')
ELSE
SET @ArchivoTimbreOUTUUID = REPLACE(@Archivo,'Temporal' + CONVERT(varchar,@Estacion) + '.XML', RTRIM(ISNULL(@Modulo,'')) + '_' + RTRIM(ISNULL(@Mov,'')) + '_' + RTRIM(ISNULL(@MovID,'')) + '_' + RTRIM(ISNULL(@UUID,'')) + '.XML')
END
ELSE
IF NULLIF(@Modulo,'') IS NULL
SET @ArchivoTimbreOUTUUID = REPLACE(@Archivo,'Temporal' + CONVERT(varchar,@Estacion) + '.XML', RTRIM(ISNULL(@Mov,'')) + '_' + RTRIM(ISNULL(@MovID,'')) + '_UUID_' + RTRIM(ISNULL(@UUID,'')) + '.XML')
ELSE
SET @ArchivoTimbreOUTUUID = REPLACE(@Archivo,'Temporal' + CONVERT(varchar,@Estacion) + '.XML', RTRIM(ISNULL(@Modulo,'')) + '_' + RTRIM(ISNULL(@Mov,'')) + '_' + RTRIM(ISNULL(@MovID,'')) + '_UUID_' + RTRIM(ISNULL(@UUID,'')) + '.XML')
SELECT @Timbre = REPLACE(@Timbre, '<?xml version="1.0" encoding="UTF-8"?>', '')
IF @Ok IS NULL
EXEC spVerificarArchivo @ArchivoTimbreOUTUUID, @Existe OUTPUT, @Ok OUTPUT, @OkRef OUTPUT
IF ISNULL(@Existe,0) = 1 AND @Ok IS NULL
EXEC spCFDFlexRegenerarArchivo @Empresa, @ArchivoTimbreOUTUUID, @Timbre, @Ok OUTPUT, @OkRef OUTPUT
EXEC spCFDFlexInsertarAddendaCFDI @Timbre, @XMLAddenda, @TimbreConAddenda OUTPUT
END
EXEC xpCFDIRegistrarlog 'DESPUES DE TIMBRAR', @Empresa, @Modulo, NULL, @Mov, @MovID, @ArchivoXML, 0, @Ok, @OkRef, @UUID
IF @Ok IS NULL
BEGIN
SET @XML = @TimbreConAddenda
EXEC spVerificarArchivo @ArchivoTimbreOUT, @Existe OUTPUT, @Ok OUTPUT, @OkRef OUTPUT
IF ISNULL(@Existe,0) = 1 AND @Ok IS NULL
EXEC spEliminarArchivo @ArchivoTimbreOUT, @Ok OUTPUT, @OkRef OUTPUT
IF @Ok IS NULL
EXEC spVerificarArchivo @ArchivoTimbreOUTAnsi, @Existe OUTPUT, @Ok OUTPUT, @OkRef OUTPUT
IF ISNULL(@Existe,0) = 1 AND @Ok IS NULL
EXEC spEliminarArchivo @ArchivoTimbreOUTAnsi, @Ok OUTPUT, @OkRef OUTPUT
IF @Ok IS NULL
EXEC spVerificarArchivo @ArchivoTimbreIN, @Existe OUTPUT, @Ok OUTPUT, @OkRef OUTPUT
IF ISNULL(@Existe,0) = 1 AND @Ok IS NULL
EXEC spEliminarArchivo @ArchivoTimbreIN, @Ok OUTPUT, @OkRef OUTPUT
IF @Ok IS NULL
EXEC spVerificarArchivo @ArchivoTimbreOUTUUID, @Existe OUTPUT, @Ok OUTPUT, @OkRef OUTPUT
IF ISNULL(@Existe,0) = 1 AND @Ok IS NULL
EXEC spEliminarArchivo @ArchivoTimbreOUTUUID, @Ok OUTPUT, @OkRef OUTPUT
END
END

