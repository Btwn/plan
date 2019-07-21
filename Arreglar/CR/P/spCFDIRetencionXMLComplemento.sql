SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROC spCFDIRetencionXMLComplemento
@Estacion			int,
@Empresa			varchar(5),
@Sucursal			int,
@Usuario			varchar(10),
@Proveedor			varchar(10),
@ConceptoSAT		varchar(2),
@Version			varchar(5),
@Vista				varchar(100),
@XML				varchar(max)	OUTPUT,
@XMLComplemento		varchar(max)	OUTPUT,
@Ok					int				OUTPUT,
@OkRef				varchar(255)	OUTPUT

AS
BEGIN
DECLARE @Complemento	varchar(20),
@CampoXML		varchar(100),
@CampoXMLAnt	varchar(100),
@CampoVista	varchar(100),
@SQL			nvarchar(max),
@Parametros	nvarchar(max)
SELECT @Complemento = Complemento FROM CFDIRetSATRetencion WHERE Clave = @ConceptoSAT
IF ISNULL(RTRIM(@Complemento), '') = ''
SELECT @XMLComplemento = ''
ELSE
BEGIN
SELECT @Vista = Vista, @XMLComplemento = Plantilla FROM CFDIRetencionCompXMLPlantilla WHERE Complemento = @Complemento
SELECT @Parametros = '@XMLComplemento	varchar(max)	OUTPUT,
@Proveedor		varchar(10),
@Estacion			int,
@ConceptoSAT		varchar(2),
@Empresa			varchar(5)
'
SELECT @CampoXMLAnt = ''
WHILE(1=1)
BEGIN
SELECT @CampoXML = MIN(CampoXML)
FROM CFDIRetencionCompXMLCampo
WHERE Complemento = @Complemento
AND CampoXML > @CampoXMLAnt
IF @CampoXML IS NULL BREAK
SELECT @CampoXMLAnt = @CampoXML
SELECT @CampoVista = CampoVista FROM CFDIRetencionCompXMLCampo WHERE Complemento = @Complemento AND CampoXML = @CampoXML
IF ISNULL(RTRIM(@CampoXML), '') <> '' AND ISNULL(RTRIM(@CampoVista), '') <> '' AND ISNULL(RTRIM(@Vista), '') <> ''
BEGIN
SELECT @SQL = 'SELECT @XMLComplemento = REPLACE(@XMLComplemento, ''' + ISNULL(RTRIM(@CampoXML), '') + ''', ISNULL(dbo.fnXMLValor(' + ISNULL(RTRIM(@CampoVista), '') + '), '''')) FROM ' + ISNULL(RTRIM(@Vista), '') + ' WHERE Proveedor = @Proveedor AND EstacionTrabajo = @Estacion AND ConceptoSAT = @ConceptoSAT AND Empresa = @Empresa'
EXEC sp_executesql @SQL, @Parametros, @XMLComplemento OUTPUT, @Proveedor, @Estacion, @ConceptoSAT, @Empresa
END
END
END
SELECT @XML = REPLACE(@XML, '@Complemento', ISNULL(@XMLComplemento, ''))
RETURN
END

