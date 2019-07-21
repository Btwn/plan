SET DATEFIRST 7    
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1  
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROC spCFDIRetencionActualizar
@Estacion				int,
@ID						int,
@Proveedor				varchar(10),
@Empresa				varchar(5),
@Version				varchar(5),
@ConceptoSAT			varchar(50),
@Documento				varchar(max),
@CadenaOriginal			varchar(max),
@SelloSAT				varchar(max),
@SelloCFD				varchar(max),
@FechaTimbrado			datetime,
@UUID					varchar(50),
@TFDVersion				varchar(max),
@noCertificadoSAT		varchar(max),
@TFDCadenaOriginal		varchar(max),
@RFCEmisor				varchar(20),
@RFCReceptor			varchar(20),
@montoTotExent			float,
@montoTotGrav			float,
@montoTotOperacion		float,
@montoTotRet			float,
@ArchivoQRCode			varchar(255),
@Archivo				varchar(255),
@ArchivoPDF				varchar(255),
@Ejerc					int,
@MesIni					int,
@MesFin					int,
@Ok						int				OUTPUT,
@OkRef					varchar(255)	OUTPUT

AS
BEGIN
IF @FechaTimbrado IS NULL SELECT @FechaTimbrado = GETDATE()
DECLARE @ModuloPago		varchar(5),
@ModuloPagoAnt	varchar(5),
@IDPago			int,
@IDPagoAnt		int,
@ModuloAux		varchar(5),
@ModuloAuxAnt		varchar(5),
@ModuloID			int,
@ModuloIDAnt		int,
@Importe			float,
@Fecha			datetime,
@Ejercicio		int,
@Periodo			int,
@Mov				varchar(20),
@MovID			varchar(20),
@Moneda			varchar(10)
SELECT @Moneda = ContMoneda FROM EmpresaCfg WITH (NOLOCK) WHERE Empresa = @Empresa
IF NULLIF(RTRIM(@UUID), '') IS NOT NULL
BEGIN
SELECT @Fecha = FechaEmision, @Ejercicio = Ejercicio, @Periodo = Periodo, @Mov = Mov, @MovID = MovID, @Importe = Importe
FROM Cxp WITH (NOLOCK)
WHERE ID = @ID
UPDATE CFDRetencion
SET SelloSAT				= @SelloSAT,
Sello				= @SelloCFD,
FechaTimbrado		= @FechaTimbrado,
UUID					= @UUID,
TFDVersion			= @TFDVersion,
noCertificadoSAT		= @noCertificadoSAT,
TFDCadenaOriginal	= @TFDCadenaOriginal,
Documento			= @Documento,
RFCEmisor			= @RFCEmisor,
RFCReceptor			= @RFCReceptor,
Importe				= @Importe,
CadenaOriginal		= @CadenaOriginal,
ConceptoSAT			= @ConceptoSAT,
Proveedor			= @Proveedor,
EsPago				= 0,
montoTotExent		= @montoTotExent,
montoTotGrav			= @montoTotGrav,
montoTotOperacion	= @montoTotOperacion,
montoTotRet			= @montoTotRet,
ArchivoQRCode		= @ArchivoQRCode,
ArchivoXML			= @Archivo,
ArchivoPDF			= @ArchivoPDF,
Ejerc				= @Ejerc,
MesIni				= @MesIni,
MesFin				= @MesFin,
TimbradoCxpID		= @ID
FROM CFDRetencion WITH (NOLOCK)
WHERE Modulo = 'CXP'
AND ModuloID = @ID
AND Proveedor = @Proveedor
AND ConceptoSAT = @ConceptoSAT
IF @@ROWCOUNT = 0
INSERT INTO CFDRetencion(
Modulo, ModuloID,  Fecha,  Ejercicio,  Periodo,  Empresa,  Mov,  MovID,  RFCEmisor,  RFCReceptor,  Importe,  noCertificado,     Sello,     CadenaOriginal,  Documento, Timbrado,  UUID,  FechaTimbrado, TipoCambio,  SelloSAT,  TFDVersion,  noCertificadoSAT,  TFDCadenaOriginal,  VersionCFD, Moneda,  Proveedor,  ConceptoSAT, EsPago,  montoTotExent,  montoTotGrav,  montoTotOperacion,  montoTotRet,  ArchivoQRCode,  ArchivoXML,  ArchivoPDF,  Ejerc,  MesIni,  MesFin,  TimbradoCxpID)
SELECT 'CXP', @ID,       @Fecha, @Ejercicio, @Periodo, @Empresa, @Mov, @MovID, @RFCEmisor, @RFCReceptor, @Importe, @noCertificadoSAT, @SelloCFD, @CadenaOriginal, @Documento, 1,        @UUID, @FechaTimbrado, 1,          @SelloSAT, @TFDVersion, @noCertificadoSAT, @TFDCadenaOriginal, @Version,   @Moneda, @Proveedor, @ConceptoSAT, 0,      @montoTotExent, @montoTotGrav, @montoTotOperacion, @montoTotRet, @ArchivoQRCode, @Archivo,    @ArchivoPDF, @Ejerc, @MesIni, @MesFin, @ID
SELECT @ModuloPagoAnt = ''
WHILE(1=1)
BEGIN
SELECT @ModuloPago = MIN(ModuloPago)
FROM CFDIRetencionD WITH (NOLOCK)
WHERE EstacionTrabajo = @Estacion
AND Proveedor = @Proveedor
AND ConceptoSAT = @ConceptoSAT
AND Empresa = @Empresa
AND ModuloPago > @ModuloPagoAnt
IF @ModuloPago IS NULL BREAK
SELECT @ModuloPagoAnt = @ModuloPago
SELECT @IDPagoAnt = 0
WHILE(1=1)
BEGIN
SELECT @IDPago = MIN(IDPago)
FROM CFDIRetencionD WITH (NOLOCK)
WHERE EstacionTrabajo = @Estacion
AND Proveedor = @Proveedor
AND ConceptoSAT = @ConceptoSAT
AND Empresa = @Empresa
AND ModuloPago = @ModuloPago
AND IDPago > @IDPagoAnt
IF @IDPago IS NULL BREAK
SELECT @IDPagoAnt = @IDPago
SELECT @Fecha = NULL, @Ejercicio = NULL, @Periodo = NULL, @Mov = NULL, @MovID = NULL, @Importe = NULL
SELECT @Fecha = FechaPago, @Ejercicio = YEAR(FechaPago), @Periodo = MONTH(FechaPago), @Mov = Pago, @MovID = PagoID, @Importe = ImportePago
FROM CFDIRetencionD WITH (NOLOCK)
WHERE EstacionTrabajo = @Estacion
AND Proveedor = @Proveedor
AND ConceptoSAT = @ConceptoSAT
AND Empresa = @Empresa
AND ModuloPago = @ModuloPago
AND IDPago = @IDPago
UPDATE CFDRetencion
SET SelloSAT				= @SelloSAT,
Sello				= @SelloCFD,
FechaTimbrado		= @FechaTimbrado,
UUID					= @UUID,
TFDVersion			= @TFDVersion,
noCertificadoSAT		= @noCertificadoSAT,
TFDCadenaOriginal	= @TFDCadenaOriginal,
Documento			= @Documento,
RFCEmisor			= @RFCEmisor,
RFCReceptor			= @RFCReceptor,
Importe				= @Importe,
CadenaOriginal		= @CadenaOriginal,
ConceptoSAT			= @ConceptoSAT,
Proveedor			= @Proveedor,
EsPago				= 1,
montoTotExent		= @montoTotExent,
montoTotGrav			= @montoTotGrav,
montoTotOperacion	= @montoTotOperacion,
montoTotRet			= @montoTotRet,
ArchivoQRCode		= @ArchivoQRCode,
ArchivoXML			= @Archivo,
ArchivoPDF			= @ArchivoPDF,
Ejerc				= @Ejerc,
MesIni				= @MesIni,
MesFin				= @MesFin,
TimbradoCxpID		= @ID
FROM CFDRetencion WITH (NOLOCK)
WHERE Modulo = @ModuloPago
AND ModuloID = @IDPago
AND Proveedor = @Proveedor
AND ConceptoSAT = @ConceptoSAT
IF @@ROWCOUNT = 0
INSERT INTO CFDRetencion(
Modulo,      ModuloID,  Fecha,  Ejercicio,  Periodo,  Empresa,  Mov,  MovID,  RFCEmisor,  RFCReceptor,  Importe,  noCertificado,     Sello,     CadenaOriginal,  Documento, Timbrado,  UUID,  FechaTimbrado, TipoCambio,  SelloSAT,  TFDVersion,  noCertificadoSAT,  TFDCadenaOriginal,  VersionCFD, Moneda,  Proveedor,  ConceptoSAT, EsPago,  montoTotExent,   montoTotGrav,   montoTotOperacion,   montoTotRet,  ArchivoQRCode,  ArchivoXML,  ArchivoPDF,  Ejerc,  MesIni,  MesFin,  TimbradoCxpID)
SELECT @ModuloPago, @IDPago,   @Fecha, @Ejercicio, @Periodo, @Empresa, @Mov, @MovID, @RFCEmisor, @RFCReceptor, @Importe, @noCertificadoSAT, @SelloCFD, @CadenaOriginal, @Documento, 1,        @UUID, @FechaTimbrado, 1,          @SelloSAT, @TFDVersion, @noCertificadoSAT, @TFDCadenaOriginal, @Version,   @Moneda, @Proveedor, @ConceptoSAT, 1,      @montoTotExent,  @montoTotGrav,  @montoTotOperacion,  @montoTotRet, @ArchivoQRCode, @Archivo,    @ArchivoPDF, @Ejerc, @MesIni, @MesFin, @ID
SELECT @ModuloAuxAnt = ''
WHILE(1=1)
BEGIN
SELECT @ModuloAux = MIN(Modulo)
FROM CFDIRetencionD WITH (NOLOCK)
WHERE EstacionTrabajo = @Estacion
AND Proveedor = @Proveedor
AND ConceptoSAT = @ConceptoSAT
AND Empresa = @Empresa
AND ModuloPago = @ModuloPago
AND IDPago = @IDPago
AND Modulo > @ModuloAuxAnt
IF @ModuloAux IS NULL BREAK
SELECT @ModuloAuxAnt = @ModuloAux
SELECT @ModuloIDAnt = 0
WHILE(1=1)
BEGIN
SELECT @ModuloID = MIN(ModuloID)
FROM CFDIRetencionD WITH (NOLOCK)
WHERE EstacionTrabajo = @Estacion
AND Proveedor = @Proveedor
AND ConceptoSAT = @ConceptoSAT
AND Empresa = @Empresa
AND ModuloPago = @ModuloPago
AND IDPago = @IDPago
AND Modulo = @ModuloAux
AND ModuloID > @ModuloIDAnt
IF @ModuloID IS NULL BREAK
SELECT @ModuloIDAnt = @ModuloID
SELECT @Fecha = NULL, @Ejercicio = NULL, @Periodo = NULL, @Mov = NULL, @MovID = NULL, @Importe = NULL
SELECT @Fecha = FechaEmision, @Ejercicio = Ejercicio, @Periodo = Periodo, @Mov = Mov, @MovID = MovID, @Importe = Importe
FROM CFDIRetencionD WITH (NOLOCK)
WHERE EstacionTrabajo = @Estacion
AND Proveedor = @Proveedor
AND ConceptoSAT = @ConceptoSAT
AND Empresa = @Empresa
AND ModuloPago = @ModuloPago
AND IDPago = @IDPago
AND Modulo = @ModuloAux
AND ModuloID = @ModuloID
UPDATE CFDRetencion
SET SelloSAT				= @SelloSAT,
Sello				= @SelloCFD,
FechaTimbrado		= @FechaTimbrado,
UUID					= @UUID,
TFDVersion			= @TFDVersion,
noCertificadoSAT		= @noCertificadoSAT,
TFDCadenaOriginal	= @TFDCadenaOriginal,
Documento			= @Documento,
RFCEmisor			= @RFCEmisor,
RFCReceptor			= @RFCReceptor,
Importe				= @Importe,
CadenaOriginal		= @CadenaOriginal,
ConceptoSAT			= @ConceptoSAT,
Proveedor			= @Proveedor,
EsPago				= 0,
montoTotExent		= @montoTotExent,
montoTotGrav			= @montoTotGrav,
montoTotOperacion	= @montoTotOperacion,
montoTotRet			= @montoTotRet,
ArchivoQRCode		= @ArchivoQRCode,
ArchivoXML 			= @Archivo,
ArchivoPDF			= @ArchivoPDF,
Ejerc				= @Ejerc,
MesIni				= @MesIni,
MesFin				= @MesFin,
TimbradoCxpID		= @ID
FROM CFDRetencion WITH (NOLOCK)
WHERE Modulo = @ModuloAux
AND ModuloID = @ModuloID
AND Proveedor = @Proveedor
AND ConceptoSAT = @ConceptoSAT
IF @@ROWCOUNT = 0
INSERT INTO CFDRetencion(
Modulo, ModuloID, Fecha,        Ejercicio, Periodo, Empresa, Mov, MovID,  RFCEmisor,  RFCReceptor, Importe, Impuesto1, Impuesto2, Retencion1,      Retencion2,       noCertificado,     Sello,     CadenaOriginal,  Documento, Timbrado,  UUID,  FechaTimbrado, TipoCambio,  SelloSAT,  TFDVersion,  noCertificadoSAT,  TFDCadenaOriginal,  VersionCFD, Moneda,  Proveedor,  ConceptoSAT, EsPago,  montoTotExent,   montoTotGrav,   montoTotOperacion,   montoTotRet,  ArchivoQRCode,  ArchivoXML,  ArchivoPDF,  Ejerc,  MesIni,  MesFin,  TimbradoCxpID)
SELECT Modulo, ModuloID, FechaEmision, Ejercicio, Periodo, Empresa, Mov, MovID, @RFCEmisor, @RFCReceptor, SUM(Importe), SUM(IVA),  SUM(IEPS), SUM(Retencion1), SUM(Retencion2), @noCertificadoSAT, @SelloCFD, @CadenaOriginal, @Documento, 1,        @UUID, @FechaTimbrado, 1,          @SelloSAT, @TFDVersion, @noCertificadoSAT, @TFDCadenaOriginal, @Version,   @Moneda, @Proveedor, @ConceptoSAT, 0,      @montoTotExent,  @montoTotGrav,  @montoTotOperacion,  @montoTotRet, @ArchivoQRCode, @Archivo,    @ArchivoPDF, @Ejerc, @MesIni, @MesFin, @ID
FROM CFDIRetencion WITH (NOLOCK)
WHERE EstacionTrabajo = @Estacion
AND Proveedor = @Proveedor
AND ConceptoSAT = @ConceptoSAT
AND Empresa = @Empresa
AND Modulo = @ModuloAux
AND ModuloID = @ModuloID
GROUP BY Modulo, ModuloID, FechaEmision, Ejercicio, Periodo, Empresa, Mov, MovID, Importe
END
END
END
END
END
RETURN
END

