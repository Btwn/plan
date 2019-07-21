SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spPOSGenerarCFDFlexLote
@Estacion           int,
@Empresa            varchar(5)

AS
BEGIN
DECLARE
@Modulo					varchar(5),
@ID						int,
@Estatus				varchar(15) ,
@Ok						int,
@OkRef					varchar(255),
@MovIDCFD				varchar(20),
@UUID					varchar(50),
@FechaTimbrado			datetime,
@SelloSat				varchar(255),
@TFDVersion				varchar(10),
@NoCertificadoSAT		varchar(20),
@TFDCadenaOriginal		varchar(max),
@CadenaOriginal			varchar(max),
@Sello					varchar(255),
@Certificado			varchar(20),
@DocumentoXML			varchar(max),
@FechaSello				datetime,
@IDPOS					varchar(50)
DECLARE crCFDTemp CURSOR LOCAL FOR
SELECT Empresa, Modulo, ID, Estatus, IDPOS
FROM POSCFDFlexPendiente
WHERE ID IN(SELECT ID FROM LISTAID WHERE Estacion = @Estacion)
OPEN crCFDTemp
FETCH NEXT FROM crCFDTemp INTO @Empresa, @Modulo, @ID, @Estatus,@IDPOS
WHILE @@FETCH_STATUS <> -1 AND @Ok IS NULL
BEGIN
EXEC spCFDFlex @Estacion, @Empresa, @Modulo, @ID, @Estatus, @Ok OUTPUT, @OkRef OUTPUT
IF @Ok IS NULL
BEGIN
SELECT
@CadenaOriginal = cfd.CadenaOriginal,
@Certificado = cfd.noCertificado,
@Sello = cfd.Sello,
@DocumentoXML = cfd.Documento,
@MovIDCFD = cfd.MovID,
@UUID = cfd.UUID ,
@FechaTimbrado = cfd.FechaTimbrado,
@SelloSat = cfd.SelloSat,
@TFDVersion = cfd.TFDVersion  ,
@NoCertificadoSAT = cfd.NoCertificadoSAT,
@TFDCadenaOriginal = cfd.TFDCadenaOriginal
FROM CFD cfd
WHERE cfd.Modulo = 'VTAS' AND cfd.ModuloID = @ID
UPDATE POSL SET
Estatus = 'CONCLUIDO',
CadenaOriginal = @CadenaOriginal,
Sello = @Sello,
Certificado = @Certificado,
DocumentoXML = @DocumentoXML,
FechaSello = @FechaSello,
UUID = @UUID,
FechaTimbrado = @FechaTimbrado,
SelloSat = @SelloSat,
TFDVersion = @TFDVersion,
NoCertificadoSAT = @NoCertificadoSAT,
TFDCadenaOriginal = @TFDCadenaOriginal
WHERE ID = @IDPOS
END
FETCH NEXT FROM crCFDTemp INTO @Empresa, @Modulo, @ID, @Estatus, @IDPOS
END
CLOSE crCFDTemp
DEALLOCATE crCFDTemp
IF @Ok IS NOT NULL
SELECT @OkRef
ELSE
SELECT 'PROCESO CONCLUIDO EXISTOSAMENTE'
RETURN
END

