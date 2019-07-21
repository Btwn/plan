SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spPOSCFDFlex
@Estacion				int,
@Empresa				varchar(5),
@Modulo					varchar(5),
@ID						int,
@IDPOS					varchar(36),
@Estatus				varchar(15),
@Ok						int				OUTPUT,
@OkRef					varchar(255)	OUTPUT,
@LlamadaExterna			bit = 0,
@Mov					varchar(20)		= NULL,
@MovID					varchar(20)		= NULL,
@Contacto				varchar(10)		= NULL,
@CrearArchivo			bit = 0,
@Debug					bit = 0,
@XMLFinal				varchar(max)	= NULL OUTPUT,
@Encripcion				varchar(20)		= NULL,
@EstatusAnterior		varchar(15)		= NULL

AS BEGIN
DECLARE
@XMLSAT						varchar(max),
@XMLADENDA					varchar(max),
@XML						varchar(max),
@Temporal					varchar(255),
@RutaTemporal				varchar(255),
@Comprobante				varchar(50),
@Adenda						varchar(50),
@FechaRegistro				datetime,
@OkError					int,
@OkRefError					varchar(255),
@RutaError					varchar(255),
@DocumentoXML				varchar(max),
@iDatos						int,
@CFDFecha					datetime,
@CFDSerie					varchar(10),
@CFDFolio					int,
@CFDRFC						varchar(15),
@CFDAprobacion				varchar(15),
@CFDImporte					money,
@CFDImpuesto1				money,
@CFDImpuesto2				money,
@CFDRetencion1				money,
@CFDRetencion2				money,
@CFDnoCertificado			varchar(20),
@CFDSello					varchar(max),
@CFDCadenaOriginal			varchar(max),
@MovTipoCFDFlexEstatus		varchar(15),
@Archivo					varchar(255),
@Usuario					varchar(10),
@EnviarAlAfectar			bit,
@AlmacenarTipo				varchar(20),
@TipoCambio					float,
@CFDI						bit,
@TipoCFDI					bit,
@TimbrarEnTransaccion		bit,
@RutaTimbrarCFDI			varchar(255),
@Timbrado					bit,
@PrefijoCFDI				varchar(255),
@RutaCFDI					varchar(255),
@CFDUUID					uniqueidentifier,
@CFDFechaTimbrado			datetime,
@TFDVersion					varchar(10),
@SelloSAT					varchar(max),
@noCertificadoSAT			varchar(20),
@BloquearMovOtraFecha		bit,
@FechaEmision				datetime,
@FechaServidor				datetime,
@Sucursal					int,
@MovTipo					varchar(20),
@OrigenModulo				varchar(5),
@OrigenMovimiento			varchar(20),
@MovOrigen					varchar(20),
@CFDEsParcialidad			bit,
@OrigenUUID					uniqueidentifier,
@OrigenMovID				varchar(20),
@OrigenSerie				varchar(10),
@OrigenFolio				varchar(4),
@Caracter					char(1),
@ParcialidadNumero			int,
@SerieFolioFiscalOrig		varchar(50),
@NoValidarOrigenDocumento	bit,
@FolioFiscalOrig			varchar(50),
@Sellar						bit,
@CFDFlexEstatus				varchar(15),
@Continuar					bit,
@Adenda2					varchar(50),
@XMLADENDA2					varchar(max),
@RutaFirmaSAT				varchar(255),
@ExisteFirmaSAT				int,
@Existe						int,
@MovIDTemp					varchar(50)
SELECT @Comprobante = NULL, @Adenda = NULL, @Timbrado = 0, @FechaServidor = dbo.fnFechaSinHora(GETDATE())
SELECT @FechaEmision = FechaEmision, @FechaRegistro = FechaRegistro, @Usuario = Usuario, @TipoCambio = TipoCambio, @Sucursal = Sucursal FROM Venta    WHERE ID = @ID
SELECT @Mov = MovFactura FROM POSCfg WHERE Empresa = @Empresa
SELECT @Contacto = @Contacto FROM MovTipoCFDFlex WHERE Modulo = @Modulo AND Mov = @Mov
SELECT @MovIDTemp = NombreArchivo, @XML = DocumentoXML FROM POSL WHERE ID = @IDPOS
SELECT @MovIDTemp = REPLACE(@MovIDTemp, @Mov,'')
SELECT @MovID = LTRIM(@MovIDTemp)
IF @Ok IS NULL
BEGIN
SELECT @CFDI = ISNULL(CFDI,0)
FROM EmpresaGral
WHERE Empresa = @Empresa
SELECT @NoValidarOrigenDocumento = ISNULL(NoValidarOrigenDocumento,0)
FROM EmpresaCFD
WHERE Empresa = @Empresa
SELECT @MovTipo = Clave FROM MovTipo WHERE Modulo = @Modulo AND Mov = @Mov
SELECT @Comprobante = Comprobante,
@Adenda = Adenda,
@MovTipoCFDFlexEstatus = NULLIF(Estatus,''),
@OrigenModulo = NULLIF(OrigenModulo,''),
@OrigenMovimiento = NULLIF(OrigenMov,'')
FROM MovTipoCFDFlex
WHERE Modulo = @Modulo
AND Mov = @Mov
AND Contacto = @Contacto
IF @Comprobante IS NULL AND @Adenda IS NULL
SELECT @Comprobante = Comprobante,
@Adenda = Adenda,
@MovTipoCFDFlexEstatus = NULLIF(Estatus,''),
@OrigenModulo = NULLIF(OrigenModulo,''),
@OrigenMovimiento = NULLIF(OrigenMov,'')
FROM MovTipoCFDFlex
WHERE Modulo = @Modulo
AND Mov = @Mov
AND ISNULL(NULLIF(ISNULL(NULLIF(Contacto,''),'(Todos)'),'(Todos)'),@Contacto) = @Contacto
IF @MovOrigen IS NULL
SELECT @MovOrigen = dbo.fnCFDFlexOrigenDetalle(@ID)
IF @OK IS NULL
EXEC spCFDFlexValidarPlantillaConfiguracion @Comprobante, @Modulo, @CFDI, @Ok OUTPUT, @OkRef OUTPUT
SELECT @RutaTemporal = RutaTemporal, @EnviarAlAfectar = EnviarAlAfectar, @RutaTimbrarCFDI = RutaTimbrarCFDI FROM EmpresaCFD WHERE Empresa = @Empresa
SELECT @Temporal = @RutaTemporal + CASE WHEN SUBSTRING(REVERSE(@RutaTemporal),1,1) <> '\' THEN '\' ELSE '' END + 'Temporal' + CONVERT(varchar,@Estacion) + '.XML'
SET @RutaError = REPLACE(@Temporal,'Temporal' + CONVERT(varchar,@Estacion) + '.XML','Error' + CONVERT(varchar,@Estacion) + '.XML')
SELECT @TipoCFDI = ISNULL(TipoCFDI,0),
@TimbrarEnTransaccion = ISNULL(TimbrarEnTransaccion,0),
@Sellar = ISNULL(Sellar,0)
FROM eDoc
WHERE Modulo = @Modulo AND eDoc = @Comprobante
EXEC spEliminarArchivo @RutaError, @Ok OUTPUT, @OkRef OUTPUT
IF @Ok IS NULL
BEGIN
SELECT @Archivo = @RutaTemporal + CASE WHEN SUBSTRING(REVERSE(@RutaTemporal),1,1) <> '\' THEN '\' ELSE '' END + @Modulo + '_' + CONVERT(varchar,@ID) + '.XML'
EXEC spCFDFlexRegenerarArchivo @Empresa, @Archivo, @XML, @Ok OUTPUT, @OkRef OUTPUT
END
IF @Ok IS NULL
BEGIN
SELECT @AlmacenarTipo = NULL
SELECT @AlmacenarTipo = NULLIF(AlmacenarTipo,'') FROM CteCFD WHERE Cliente = @Contacto
EXEC spCFDFlexGenerarPDF @Empresa, @Modulo, @Mov, @ID, @Usuario, 0, @Ok = @Ok OUTPUT, @OkRef = @OkRef OUTPUT
IF @AlmacenarTipo = 'Adicional'
EXEC spCFDFlexGenerarPDF @Empresa, @Modulo, @Mov, @ID, @Usuario, 1, @Ok = @Ok OUTPUT, @OkRef = @OkRef OUTPUT
IF @Ok IS NULL
BEGIN
UPDATE CFD SET GenerarPDF = 1 WHERE Modulo = @Modulo AND ModuloID = @ID
IF @@ERROR <> 0 SET @Ok = 1
END
END
END
IF EXISTS(SELECT * FROM CFDFlexTemp WHERE ID = @ID AND Modulo = @Modulo)
DELETE CFDFlexTemp WHERE ID = @ID AND Modulo = @Modulo
IF @Debug = 1
SELECT CONVERT(xml,@XML)
SELECT @XMLFinal = @XML
IF @Ok IS NULL
EXEC spVerificarArchivo @Temporal, @Existe OUTPUT, @Ok OUTPUT, @OkRef OUTPUT
IF ISNULL(@Existe,0) = 1 AND @Ok IS NULL
EXEC spEliminarArchivo @Temporal, @Ok OUTPUT, @OkRef OUTPUT
END

