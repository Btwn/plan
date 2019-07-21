SET DATEFIRST 7    
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1  
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROC spCFDINominaTimbrar
@Estacion						int,
@ID								int,
@Personal						varchar(10),
@Empresa						varchar(5),
@Sucursal						int,
@Mov							varchar(20),
@MovID							varchar(20),
@Version						varchar(5),
@Usuario						varchar(10),
@Estatus						varchar(15),
@RFCEmisor						varchar(20),
@RFCReceptor					varchar(20),
@Importe						float,
@Archivo						varchar(255),
@NoTimbrado						int,
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
@UUID					varchar(50),
@TFDVersion			varchar(max),
@noCertificadoSAT		varchar(max),
@TFDCadenaOriginal	varchar(max)
EXEC spCFDINominaInsertar @ID, @Empresa, @Sucursal, @Mov, @MovID, @Version, @XML, @Usuario, @RFCEmisor, @Importe, @NoTimbrado, @Ok OUTPUT, @OkRef OUTPUT
IF @Ok IS NULL
EXEC spCFDITimbrarNomina 'NOM', @ID, @Personal, @Estatus, @Empresa, @Sucursal, @XML, @CFDITimbrado OUTPUT, @CadenaOriginal OUTPUT, @SelloSAT OUTPUT, @SelloCFD OUTPUT,  @FechaTimbrado OUTPUT, @UUID OUTPUT, @TFDVersion OUTPUT, @noCertificadoSAT OUTPUT, @TFDCadenaOriginal OUTPUT, @Ok OUTPUT, @OkRef OUTPUT
IF @Ok IS NULL
BEGIN
EXEC spCFDINominaActualizar @ID, @Personal, @Empresa, @Mov, @MovID, @Version, @Documento = @CFDITimbrado, @CadenaOriginal = @CadenaOriginal,
@SelloSAT = @SelloSAT, @SelloCFD = @SelloCFD, @FechaTimbrado = @FechaTimbrado, @UUID = @UUID, @TFDVersion = @TFDVersion, @noCertificadoSAT = @noCertificadoSAT,
@TFDCadenaOriginal = @TFDCadenaOriginal, @RFCEmisor = @RFCEmisor, @RFCReceptor = @RFCReceptor, @Importe = @Importe,
@NoTimbrado = @NoTimbrado,
@Ok = @Ok OUTPUT, @OkRef = @OkRef OUTPUT
SELECT @XML = @CFDITimbrado
END
RETURN
END

