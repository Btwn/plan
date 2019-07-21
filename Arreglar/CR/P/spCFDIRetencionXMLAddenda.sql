SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROC spCFDIRetencionXMLAddenda
@Estacion			int,
@Empresa			varchar(5),
@Sucursal			int,
@Usuario			varchar(10),
@Proveedor			varchar(10),
@ConceptoSAT		varchar(2),
@Version			varchar(5),
@Vista				varchar(100),
@XML				varchar(max)	OUTPUT,
@XMLAddenda			varchar(max)	OUTPUT,
@Ok					int				OUTPUT,
@OkRef				varchar(255)	OUTPUT

AS
BEGIN
SELECT @XML = REPLACE(@XML, '@Addenda', ISNULL(@XMLAddenda, ''))
RETURN
END

