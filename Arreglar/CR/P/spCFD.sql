SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spCFD
@Empresa		char(5),
@Modulo			char(5),
@ModuloID		int,
@Sello			varchar(max),
@CadenaOriginal		text,
@Documento		text,
@noCertificado		varchar(20),
@CadenaOriginal1	text = NULL,
@CadenaOriginal2	text = NULL,
@CadenaOriginal3	text = NULL,
@CadenaOriginal4	text = NULL,
@CadenaOriginal5	text = NULL

AS BEGIN
DECLARE
@Resultado				varchar(255),
@EmisorRFC				varchar(50),
@ReceptorRFC			varchar(50),
@Importe				float,
@XML					varchar(max),
@DocumentoXML			xml,
@PrefijoCFDI			varchar(255),
@RutaCFDI				varchar(255),
@iDatos					int
UPDATE CFD
SET Sello = @Sello, CadenaOriginal = @CadenaOriginal, Documento = @Documento, noCertificado = @noCertificado,
CadenaOriginal1 = CASE WHEN cfg.CadenaOriginal8000 = 1 THEN @CadenaOriginal1 ELSE NULL END,
CadenaOriginal2 = CASE WHEN cfg.CadenaOriginal8000 = 1 THEN @CadenaOriginal2 ELSE NULL END,
CadenaOriginal3 = CASE WHEN cfg.CadenaOriginal8000 = 1 THEN @CadenaOriginal3 ELSE NULL END,
CadenaOriginal4 = CASE WHEN cfg.CadenaOriginal8000 = 1 THEN @CadenaOriginal4 ELSE NULL END,
CadenaOriginal5 = CASE WHEN cfg.CadenaOriginal8000 = 1 THEN @CadenaOriginal5 ELSE NULL END
FROM CFD
JOIN EmpresaCFD cfg ON cfg.Empresa=@Empresa
WHERE cfd.Modulo = @Modulo AND cfd.ModuloID = @ModuloID
UPDATE CFD SET Documento = REPLACE(REPLACE(CONVERT(varchar(MAX), Documento),'&#39;',''''),'?<?xml','<?xml') WHERE Modulo = @Modulo AND ModuloID = @ModuloID
END

