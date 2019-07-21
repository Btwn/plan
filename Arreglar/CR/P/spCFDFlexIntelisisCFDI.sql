SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROC spCFDFlexIntelisisCFDI
@Estacion				int,
@Empresa				varchar(5),
@Modulo					varchar(5),
@Mov					varchar(20),
@MovID					varchar(20),
@RutaArchivo			varchar(200),
@CFDI					varchar(max),
@CFDITimbrado			varchar(max) OUTPUT,
@CadenaOriginal			varchar(max) OUTPUT,
@Ok						int = NULL OUTPUT,
@OkRef					varchar(255) = NULL OUTPUT

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
@Documento			varchar(max),
@RutaIntelisisCFDI	varchar(255),
@CadenaConexion		varchar(max),
@PswPFX				varchar(30),
@DatosXMl				varchar(max),
@RenglonDatos			varchar(255),
@Error				bit,
@Sucursal				int,
@SucursalCFDFlex		bit,
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
@UUID				varchar(50),
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
@UsarTimbrarNomina	bit
DECLARE @Datos TABLE (ID int IDENTITY(1,1), Datos varchar(255))
SELECT @RFC = RFC FROM Empresa WHERE Empresa = @Empresa
SELECT @RutaIntelisisCFDI = RutaTimbrarCFDI,
@ServidorPAC = TimbrarCFDIServidor,
@UsuarioPAC  = TimbrarCFDIUsuario,
@PaswordPAC = TimbrarCFDIPassword,
@RutaCer = RutaCertificado,
@RutaKey = Llave,
@passKey = ContrasenaSello,
@TimeOutTimbrado = CONVERT(varchar(30),ISNULL(TimeOutTimbrado,15000)),
@ModoPruebas = ModoPruebas,
@TokenCanPAC	=ISNULL(CancelarCFDIToken,''),
@CuentaCanPAC=ISNULL(CancelarCFDICuenta,''),
@UsuarioCanPAC=ISNULL(CancelarCFDIUsuario ,''),
@PaswordCanPAC=ISNULL(CancelarCFDIPassword  ,''),
@RegistrarLog		= RegistrarLog
FROM EmpresaCFD WHERE Empresa = @Empresa
SELECT @Sucursal = CASE @Modulo
WHEN 'VTAS' THEN (SELECT Sucursal FROM Venta WHERE Mov = @Mov AND MovID = @MovID AND Empresa = @Empresa)
WHEN 'CXC' THEN (SELECT Sucursal FROM Cxc WHERE Mov = @Mov AND MovID = @MovID  AND Empresa = @Empresa)
END
SELECT @SucursalCFDFlex = ISNULL(CFDFlex, 0) FROM Sucursal WHERE Sucursal = @Sucursal
IF ISNULL(@SucursalCFDFlex, 0) = 1 
SELECT @passKey = ContrasenaSello,
@RutaKey = Llave,
@RutaCer = RutaCertificado
FROM Sucursal
WHERE Sucursal = @Sucursal
SELECT @RutaIntelisisCFDI = REPLACE(@RutaIntelisisCFDI,'TimbrarCFDI.EXE', 'IntelisisCFDI.exe')
IF @UUID IS NOT NULL
SELECT @Ok = 71680, @OkRef = 'El Movimiento Ya Fue Timbrado'
SELECT @AccionCFDI = 'TIMBRAR', @PswPFX = 'Intelisis1234567', @Timbrar = 1
SELECT @AlmacenarRuta =   REPLACE(@RutaArchivo,'.XML','.tmp')
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
SELECT @UsarTimbrarNomina= UsarTimbrarNomina FROM EmpresaCFD WHERE Empresa = @Empresa
IF @ServidorPAC='KONESH'
BEGIN
/*
IF @UsarTimbrarNomina=0
BEGIN
SET @UsuarioPAC=@UsuarioCanPAC
SET @PaswordPAC=@PaswordCanPAC
END
*/
IF @CuentaCanPAC IS NULL SELECT @Ok = 10060, @OkRef = 'Dato Cuenta PAC No puede Estar Vacio' ELSE
IF @TokencanPAC IS NULL SELECT @Ok = 10060, @OkRef = 'Dato Token PAC No puede Estar Vacio'
END
IF @UsuarioPAC IS NULL SELECT @Ok = 10060, @OkRef = 'Dato Usuario PAC No puede Estar Vacio' ELSE
IF @PaswordPAC IS NULL SELECT @Ok = 10060, @OkRef = 'Dato Pasword PAC No puede Estar Vacio'
IF @Ok IS NULL
EXEC spCFDFlexRegenerarArchivo @Empresa, @AlmacenarRuta, @CFDI, @Ok OUTPUT, @OkRef OUTPUT
IF @Ok IS NULL
BEGIN
/*SELECT                  '<IntelisisCFDI>',
'<IDSESION>'+CONVERT(varchar,@@SPID)+'</IDSESION>',
'<FECHA>'+@FechaTimbrado+'</FECHA>',
'<SERVIDOR>'+@ServidorPAC+'</SERVIDOR>',
'<USUARIO>'+@UsuarioPAC+'</USUARIO>',
'<PASSWORD>'+@PaswordPAC+'</PASSWORD>',
'<CUENTA>'+ISNULL(@CuentaCanPAC,'')+'</CUENTA>',
'<TOKEN>'+ISNULL(@TokenCanPAC,'')+'</TOKEN>',
'<ACCION>'+@AccionCFDI+'</ACCION>',
'<RUTACER>'+@RutaCer+'</RUTACER>',
'<RUTAKEY>'+@RutaKey+'</RUTAKEY>',
'<PWDKEY>'+@passKey+'</PWDKEY>',
'<PWDPFX>'+@PswPFX+'</PWDPFX>',
'<UUID>'+@UUID+'</UUID>',
'<RFC>'+@RFC+'</RFC>',
'<TIMEOUT>'+CONVERT(varchar(30),@TimeOutTimbrado)+'</TIMEOUT>',
'<RUTAARCHIVO>'+@AlmacenarRuta+'</RUTAARCHIVO>',
'<MODOPRUEBAS>'+CONVERT(varchar(1),@ModoPruebas)+'</MODOPRUEBAS>',
'</IntelisisCFDI>' */
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
'<GUARDARLOG>'+convert(varchar(1),@RegistrarLog)+'</GUARDARLOG>'+
'<MODOPRUEBAS>'+CONVERT(varchar(1),@ModoPruebas)+'</MODOPRUEBAS>'+
'<USARFIRMASAT>1</USARFIRMASAT>'+
'</IntelisisCFDI>'
SELECT @Shell = CHAR(34)+CHAR(34)+@RutaIntelisisCFDI+CHAR(34)+' '+CHAR(34)+@CadenaConexion+CHAR(34)+CHAR(34)
INSERT @Datos
EXEC @r =  xp_cmdshell @Shell
EXEC spVerificarArchivo @AlmacenarRuta, @Existe OUTPUT, @Ok OUTPUT, @OkRef OUTPUT
IF @Existe = 1
EXEC spEliminarArchivo @AlmacenarRuta, @Ok OUTPUT, @OkRef OUTPUT
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
SELECT @CFDITimbrado = @DatosXml
END
END
END

