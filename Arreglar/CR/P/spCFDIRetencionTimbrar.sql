SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROC spCFDIRetencionTimbrar
@Estacion						int,
@ID								int,
@Proveedor						varchar(10),
@ConceptoSAT					varchar(50),
@RIDAnt                         varchar(20),
@Empresa						varchar(5),
@Version						varchar(5),
@Usuario						varchar(10),
@RFCEmisor						varchar(20),
@RFCReceptor					varchar(20),
@ArchivoQRCode					varchar(255),
@Archivo						varchar(255),
@ArchivoPDF						varchar(255),
@montoTotExent					float,
@montoTotGrav					float,
@montoTotOperacion				float,
@montoTotRet					float,
@Ejerc							int,
@MesIni							int,
@MesFin							int,
@UUID							varchar(50)     OUTPUT,
@XML							varchar(max)	OUTPUT,
@Ok								int				OUTPUT,
@OkRef							varchar(255)	OUTPUT

AS
BEGIN
DECLARE @CFDITimbrado			varchar(max),
@CadenaOriginal		varchar(max),
@SelloSAT				varchar(max),
@SelloCFD				varchar(max),
@FechaTimbrado		varchar(max),
@TFDVersion			varchar(max),
@noCertificadoSAT		varchar(max),
@TFDCadenaOriginal	varchar(max)
IF @Ok IS NULL
EXEC spCFDITimbrarRetencion @Estacion, @ID, @Proveedor, @ConceptoSAT, @RIDAnt, @Empresa, @XML, @Version, @Ejerc, @MesIni, @MesFin, @CFDITimbrado OUTPUT, @CadenaOriginal OUTPUT, @SelloSAT OUTPUT, @SelloCFD OUTPUT,  @FechaTimbrado OUTPUT, @UUID OUTPUT, @TFDVersion OUTPUT, @noCertificadoSAT OUTPUT, @TFDCadenaOriginal OUTPUT, @Ok OUTPUT, @OkRef OUTPUT
IF @Ok IS NULL
BEGIN
EXEC spCFDIRetencionActualizar @Estacion, @ID, @Proveedor, @Empresa, @Version, @ConceptoSAT, @Documento = @CFDITimbrado, @CadenaOriginal = @CadenaOriginal,
@SelloSAT = @SelloSAT, @SelloCFD = @SelloCFD, @FechaTimbrado = @FechaTimbrado, @UUID = @UUID, @TFDVersion = @TFDVersion, @noCertificadoSAT = @noCertificadoSAT,
@TFDCadenaOriginal = @TFDCadenaOriginal, @RFCEmisor = @RFCEmisor, @RFCReceptor = @RFCReceptor,
@montoTotExent = @montoTotExent, @montoTotGrav = @montoTotGrav, @montoTotOperacion = @montoTotOperacion, @montoTotRet = @montoTotRet,
@ArchivoQRCode = @ArchivoQRCode, @Archivo = @Archivo, @ArchivoPDF = @ArchivoPDF, @Ejerc = @Ejerc, @MesIni = @MesIni, @MesFin = @MesFin,
@Ok = @Ok OUTPUT, @OkRef = @OkRef OUTPUT
SELECT @XML = @CFDITimbrado
END
RETURN
END

