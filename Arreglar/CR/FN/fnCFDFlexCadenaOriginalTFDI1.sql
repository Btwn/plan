SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER FUNCTION fnCFDFlexCadenaOriginalTFDI1
(
@Modulo				varchar(5),
@ModuloID			int
)
RETURNS varchar(max)

AS BEGIN
DECLARE
@Resultado				varchar(max),
@Version				varchar(10),
@UUID					varchar(50),
@FechaTimbrado			datetime,
@SelloCFD				varchar(max),
@NoCertificadoSAT		varchar(50)
SELECT
@Version = '1.0',
@UUID = CONVERT(varchar(100),UUID),
@FechaTimbrado = FechaTimbrado,
@SelloCFD = Sello,
@NoCertificadoSAT = noCertificado
FROM CFD
WHERE Modulo = @Modulo
AND ModuloID = @ModuloID
SET @Resultado = '||' + RTRIM(LTRIM(@Version)) + '|' + RTRIM(LTRIM(@UUID)) + '|' + RTRIM(LTRIM(dbo.fneDocFormatoFecha(@FechaTimbrado,'AAAA-MM-DDTHH:NN:SSZ'))) + '|' + RTRIM(LTRIM(@SelloCFD)) + '|' + RTRIM(LTRIM(@NoCertificadoSAT)) + '||'
RETURN (@Resultado)
END

