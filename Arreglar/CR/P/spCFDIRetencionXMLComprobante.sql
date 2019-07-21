SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROC spCFDIRetencionXMLComprobante
@Estacion			int,
@Empresa			varchar(5),
@Sucursal			int,
@Usuario			varchar(10),
@Proveedor			varchar(10),
@ConceptoSAT		varchar(2),
@Version			varchar(5),
@Vista				varchar(100),
@XMLComprobante		varchar(max)	OUTPUT,
@Ok					int				OUTPUT,
@OkRef				varchar(255)	OUTPUT

AS
BEGIN
DECLARE @CampoXML		varchar(100),
@CampoXMLAnt	varchar(100),
@CampoVista	varchar(100),
@SQL			nvarchar(max),
@Parametros	nvarchar(max)
SELECT @Parametros = '@XMLComprobante	varchar(max)	OUTPUT,
@Proveedor		varchar(10),
@Estacion		int,
@ConceptoSAT	varchar(2),
@Empresa		varchar(5)
'
SELECT @CampoXMLAnt = ''
WHILE(1=1)
BEGIN
SELECT @CampoXML = MIN(CampoXML)
FROM CFDIRetencionXMLCampo
WHERE Version = @Version
AND CampoXML > @CampoXMLAnt
IF @CampoXML IS NULL BREAK
SELECT @CampoXMLAnt = @CampoXML
SELECT @CampoVista = CampoVista FROM CFDIRetencionXMLCampo WHERE Version = @Version AND CampoXML = @CampoXML
IF ISNULL(RTRIM(@CampoXML), '') <> '' AND ISNULL(RTRIM(@CampoVista), '') <> '' AND ISNULL(RTRIM(@Vista), '') <> ''
BEGIN
SELECT @SQL = 'SELECT @XMLComprobante = REPLACE(@XMLComprobante, ''' + ISNULL(RTRIM(@CampoXML), '') + ''', ISNULL(dbo.fnXMLValor(' + ISNULL(RTRIM(@CampoVista), '') + '), '''')) FROM ' + ISNULL(RTRIM(@Vista), '') + ' WHERE Proveedor = @Proveedor AND EstacionTrabajo = @Estacion AND ConceptoSAT = @ConceptoSAT AND Empresa = @Empresa'
EXEC sp_executesql @SQL, @Parametros, @XMLComprobante OUTPUT, @Proveedor, @Estacion, @ConceptoSAT, @Empresa
END
END
RETURN
END

