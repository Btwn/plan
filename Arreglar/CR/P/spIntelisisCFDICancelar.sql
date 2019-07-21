SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROC spIntelisisCFDICancelar
@Modulo					varchar(10),
@ID						int,
@Estatus				varchar(20),
@Empresa				varchar(10),
@Sucursal				int,
@RutaTimbrarCFD			varchar(255),
@Fechatimbrado			varchar(20),
@ServidorPAC			varchar(100),
@UsuarioPAC				varchar(100),
@PaswordPAC				varchar(100),
@AccionCFDI				varchar(50),
@RutaCer				varchar(200),
@RutaKey				varchar(200),
@passKey				varchar(100),
@UUID					varchar(50),
@RFC					varchar(20),
@Documento				varchar(max),
@ModoPruebas			bit,
@AlmacenarRuta			varchar(200),
@EsRetencion			bit,
@FirmaCancelacionSAT	varchar(max)	OUTPUT,
@DatosXMl				varchar(max)	OUTPUT,
@Ok						int				OUTPUT,
@OkRef					varchar(255)	OUTPUT

AS
BEGIN
DECLARE
@CadenaConexion			varchar(max),
@PswPFX					varchar(30),
@RenglonDatos			varchar(255),
@Error					bit,
@xml					xml,
@RID					int,
@iDatos					int,
@DocumentoXML			xml,
@PrefijoCFDI			varchar(255),
@Shell					varchar(8000),
@r						varchar(max),
@FechaCancelacionSAT	varchar(30),
@Cancelacion			bit,
@TimeOutTimbrado		int,
@MensajeSF				varchar(max),
@Dato1					varchar(max),
@SelloCancelacionSAT	varchar(max),
@EstatusCancelacion		varchar(10),
@LeeXML					varchar(max),
@TokenCanPAC				varchar(max),
@CuentaCanPAC				varchar(max),
@RutaProvPac			varchar(max),
@UsarTimbrarNomina      bit
DECLARE @Datos TABLE (ID int identity(1,1), Datos varchar(255))
SELECT @PswPFX = 'Intelisis1234567', @Cancelacion = 1
IF @RutaTimbrarCFD IS NULL SELECT @Ok = 10060, @OkRef = 'Dato Ruta IntelisisCFDI.exe no Puede Estar Vacio' ELSE
IF @Fechatimbrado IS NULL SELECT @Ok = 10060, @OkRef = 'Dato Fecha de Timbrado no Puede Estar Vacio' ELSE
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
IF @UsarTimbrarNomina=1
SELECT @UsuarioPAC=TimbrarCFDIUsuario,@PaswordPAC=TimbrarCFDIPassword,@CuentaCanPAC=CancelarCFDICuenta,@TokenCanPAC=CancelarCFDIToken  FROM EmpresaCFDNomina WHERE Empresa = @Empresa
ELSE
SELECT @UsuarioPAC=CancelarCFDIUsuario,@PaswordPAC=CancelarCFDIPassword,@CuentaCanPAC=CancelarCFDICuenta,@TokenCanPAC=CancelarCFDIToken  FROM EmpresaCFD WHERE Empresa = @Empresa
IF @CuentaCanPAC IS NULL SELECT @Ok = 10060, @OkRef = 'Dato Cuenta PAC No puede Estar Vacio' ELSE
IF @TokenCanPAC IS NULL SELECT @Ok = 10060, @OkRef = 'Dato Token PAC No puede Estar Vacio'
END
IF @UsuarioPAC IS NULL SELECT @Ok = 10060, @OkRef = 'Dato Usuario PAC No puede Estar Vacio' ELSE
IF @PaswordPAC IS NULL SELECT @Ok = 10060, @OkRef = 'Dato Pasword PAC No puede Estar Vacio'
IF @Ok IS NULL
BEGIN
SELECT @CadenaConexion = '<IntelisisCFDI>'+
'<IDSESION>'+convert(varchar,@@SPID)+'</IDSESION>'+
'<FECHA>'+@Fechatimbrado+'</FECHA>'+
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
'<TIMEOUT>'+convert(varchar(30),ISNULL(@TimeOutTimbrado, 15000))+'</TIMEOUT>'+
'<RUTAARCHIVO>'+@AlmacenarRuta+'</RUTAARCHIVO>'+
'<MODOPRUEBAS>'+CONVERT(varchar(1),@ModoPruebas)+'</MODOPRUEBAS>'
IF @EsRetencion=1
SELECT  @CadenaConexion=@CadenaConexion+'<USARFIRMASAT>0</USARFIRMASAT></IntelisisCFDI>'
ELSE
SELECT  @CadenaConexion=@CadenaConexion+'</IntelisisCFDI>'
SELECT @Shell = CHAR(34)+CHAR(34)+@RutaTimbrarCFD+CHAR(34)+' '+CHAR(34)+@CadenaConexion+CHAR(34)+CHAR(34)
INSERT @Datos
EXEC @r =  xp_cmdshell @Shell
END
IF @Ok IS NULL
BEGIN
SELECT @DatosXMl = ''
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
/*JARL*/
SELECT @DatosXML = REPLACE(@DatosXML,'<?xml vErsIOn="1.0"?>', '')
IF @Error = 1 SELECT @Ok = 71650,  @OkRef = @DatosXml
IF @r <> 0
BEGIN
IF CHARINDEX('programa o archivo por lotes ejecutable.',@RenglonDatos) >= 1
SELECT @Ok = 71650, @OkRef = 'Falta configurar la ruta de IntelisisCFDI.exe'
ELSE
SELECT @OK = 71650, @OkREf = 'Error al Ejecutar IntelisisCFDI.exe '+ISNULL(@DatosXml,'')
END
IF NULLIF(@DatosXMl,'') IS NULL SELECT @Ok = 71650, @OkRef = 'Se Esperaba Respuesta de IntelisisCFDI.exe'
SELECT @DatosXMl = REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(@DatosXMl, 'á', 'a'), 'é', 'e'), 'í', 'i'), 'ó', 'o'), 'ú', 'u'), 'ü', 'u'), 'ñ', 'n'), 'a', 'A'), 'É', 'E'), 'S', 'I'), '±', 'O'), '˜', 'U'), 'Ü', 'U'), 'Ñ', 'N'),'''','''''')
IF @Ok is NULL
BEGIN
BEGIN TRY
SELECT @xml = CONVERT(XML,@DatosXml)
END TRY
BEGIN CATCH
SELECT @Ok = 71600, @OkRef = dbo.fnOkRefSQL(ERROR_NUMBER(), ERROR_MESSAGE())
END CATCH
IF @OK IS NULL
BEGIN
SET @PrefijoCFDI = '<ns xmlns'+CHAR(58)+'es="http'+ CHAR(58) +'//cancelacfd.sat.gob.mx"  xmlns'+CHAR(58)+'sg="http'+ CHAR(58) +'//www.w3.org/2000/09/xmldsig#"/>'
EXEC sp_xml_preparedocument @iDatos OUTPUT, @XML, @PrefijoCFDI
IF @ServidorPAC ='MASTEREDI'
BEGIN
SELECT @FirmaCancelacionSAT = Firma
FROM OPENXML (@idatos, 'MasTimbrado')
WITH (Firma	varchar(max) 'Mensaje')
IF @FirmaCancelacionSAT='El archivo se proceso con exito.'
SET @FirmaCancelacionSAT=@FirmaCancelacionSAT+'Para obtener el acuse consulte a su PAC'
END
ELSE  IF @ServidorPAC ='KONESH'
BEGIN
SELECT @FirmaCancelacionSAT = Firma
FROM OPENXML (@idatos, 'Cancelacion')
WITH (Firma	varchar(max) '.')
SET @FirmaCancelacionSAT=@FirmaCancelacionSAT+'Para obtener el acuse consulte a su PAC'
END
ELSE IF @ServidorPAC = 'SOLUCIONFACTIBLE'
BEGIN
SELECT @MensajeSF = mensaje
FROM OPENXML (@idatos, '//EnviarSolicitudCancelacionResponse/CFDIResultadoCancelacion',2)
WITH (mensaje	varchar(max) 'mensaje')
EXEC spExtraerDato @MensajeSF OUTPUT, @Dato1 OUTPUT, ':'
EXEC spExtraerDato @MensajeSF OUTPUT, @FirmaCancelacionSAT OUTPUT, ';'
SELECT @FirmaCancelacionSAT = RTRIM(LTRIM(@FirmaCancelacionSAT))
SELECT @EstatusCancelacion = EstatusUUID
FROM   OPENXML (@idatos,'//EnviarSolicitudCancelacionResponse/CFDIResultadoCancelacion' )
WITH (EstatusUUID       varchar(max) 'statusUUID')
END
ELSE IF @ServidorPAC = 'FORMASDIGITALES'
BEGIN
SET @PrefijoCFDI = '<ns xmlns' + CHAR(58) + 's="http' + CHAR(58) + '//schemas.xmlsoap.org/soap/envelope/" xmlns' + CHAR(58) + 'cr="http' + CHAR(58) + '//cancelacfd.sat.gob.mx" xmlns' + CHAR(58) + 'sg="http' + CHAR(58) + '//www.w3.org/2000/09/xmldsig'+CHAR(35)+'" />'
EXEC sp_xml_preparedocument @iDatos OUTPUT, @XML, @PrefijoCFDI
SELECT @FechaCancelacionSAT = Fecha, @EstatusCancelacion = EstatusUUID
FROM   OPENXML (@idatos, '//cr:CancelaCFDResponse/cr:CancelaCFDResult/cr:Folios',2)
WITH (Fecha    varchar(50)         '../@Fecha',
UUID    varchar(50) 'cr:UUID',
EstatusUUID  varchar(10) 'cr:EstatusUUID',
RFC    varchar(10) '../@RfcEmisor')
SELECT @FirmaCancelacionSAT = Firma
FROM   OPENXML (@idatos, '//cr:CancelaCFDResponse/cr:CancelaCFDResult/sg:Signature',2)
WITH (Firma       varchar(max) 'sg:SignatureValue')
EXEC sp_xml_removedocument @iDatos
END
ELSE  IF @ServidorPAC ='G4S'
BEGIN
SET @FirmaCancelacionSAT='Para obtener el acuse consulte a su PAC'
END
ELSE
BEGIN
SELECT @EstatusCancelacion = EstatusUUID
FROM OPENXML (@idatos,'//es:Folios' )
WITH (EstatusUUID       varchar(max) 'es:EstatusUUID')
SELECT @FirmaCancelacionSAT = Firma
FROM OPENXML (@idatos, '//sg:Signature')
WITH (Firma	 varchar(max) 'sg:SignatureValue')
END
EXEC sp_xml_removedocument @iDatos
IF @EstatusCancelacion IN('201', '202') SELECT @EstatusCancelacion = NULL
IF @EstatusCancelacion IS NOT NULL
BEGIN
SELECT @OK = 71651
SELECT @OkRef = Descripcion FROM MensajeCFDI WHERE Mensaje = @EstatusCancelacion
END
END
END
END
END

