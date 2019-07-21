SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROC spCFDINominaActualizar
@ID						int,
@Personal				varchar(10),
@Empresa				varchar(5),
@Mov					varchar(20),
@MovID					varchar(20),
@Version				varchar(5),
@Fecha					datetime			= NULL,
@Ejercicio				int					= NULL,
@Periodo				int					= NULL,
@RFCEmisor				varchar(15)			= NULL,
@RFCReceptor			varchar(15)			= NULL,
@Moneda					varchar(15)			= NULL,
@Importe				money				= NULL,
@noCertificado			varchar(20)			= NULL,
@Sello					varchar(max)		= NULL,
@CadenaOriginal			varchar(max)		= NULL,
@Documento				varchar(max)		= NULL,
@Timbrado				bit					= NULL,
@UUID					uniqueidentifier	= NULL,
@FechaTimbrado			datetime			= NULL,
@TipoCambio				float				= NULL,
@SelloSAT				varchar(max)		= NULL,
@SelloCFD				varchar(max)		= NULL,
@TFDVersion				varchar(10)			= NULL,
@noCertificadoSAT		varchar(20)			= NULL,
@TFDCadenaOriginal		varchar(max)		= NULL,
@VersionCFD				varchar(5)			= NULL,
@NoTimbrado				int					= NULL,
@Ok						int					= NULL OUTPUT,
@OkRef					varchar(255)		= NULL OUTPUT

AS
BEGIN
IF @FechaTimbrado IS NULL SELECT @FechaTimbrado = GETDATE()
UPDATE CFDNomina
SET SelloSAT				= @SelloSAT,
Sello					= @SelloCFD,
FechaTimbrado			= @FechaTimbrado,
UUID					= @UUID,
TFDVersion				= @TFDVersion,
noCertificadoSAT		= @noCertificadoSAT,
TFDCadenaOriginal		= @TFDCadenaOriginal,
Documento				= @Documento,
RFCEmisor				= @RFCEmisor,
RFCReceptor			= @RFCReceptor,
Importe				= @Importe,
NoTimbrado				= @NoTimbrado,
CadenaOriginal			= @CadenaOriginal
FROM CFDNomina
WHERE Modulo = 'NOM'
AND ModuloID = @ID
AND Personal = @Personal
IF @@ROWCOUNT =0
INSERT INTO CFDNomina(
Modulo, ModuloID, Personal,  Fecha,  Ejercicio,  Periodo,  Empresa,  MovID,  RFCEmisor,  RFCReceptor,  Importe,  noCertificado,  Sello,  CadenaOriginal,  Documento,  Timbrado,  UUID,  FechaTimbrado,  TipoCambio,  SelloSAT,  TFDVersion,  noCertificadoSAT,  TFDCadenaOriginal,  VersionCFD, Moneda,  NoTimbrado)
SELECT 'NOM', @ID,      @Personal, @Fecha, @Ejercicio, @Periodo, @Empresa, @MovID, @RFCEmisor, @RFCReceptor, @Importe, @noCertificado, @SelloCFD, @CadenaOriginal, @Documento, @Timbrado, @UUID, @FechaTimbrado, @TipoCambio, @SelloSAT, @TFDVersion, @noCertificadoSAT, @TFDCadenaOriginal, @Version,   @Moneda, @NoTimbrado
RETURN
END

