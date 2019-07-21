SET DATEFIRST 7    
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1  
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROC spCFDIRetencionQRCode
@Estacion			int,
@Proveedor			varchar(10),
@ConceptoSAT		varchar(2),
@Empresa			varchar(5),
@Sucursal			int,
@Version			varchar(5),
@XML				varchar(max),
@Usuario			varchar(10),
@ArchivoQRCode		varchar(255),
@RFCEmisor			varchar(30),
@RFCReceptor		varchar(30),
@montoTotExent		float,
@montoTotGrav		float,
@montoTotOperacion	float,
@montoTotRet		float,
@UUID				varchar(50),
@Ok					int			OUTPUT,
@OkRef				varchar(255)OUTPUT

AS
BEGIN
DECLARE @Cadena				varchar(max),
@Shell				varchar(8000),
@RutaGenerarQRCode	varchar(max),
@UsarTimbrarRetencion	bit
SELECT @UsarTimbrarRetencion = UsarTimbrarRetencion FROM EmpresaCFD WITH (NOLOCK) WHERE Empresa = @Empresa
IF @UsarTimbrarRetencion = 0
SELECT @RutaGenerarQRCode = RTRIM(LTRIM(ISNULL(RutaGenerarQRCode,'')))
FROM EmpresaCFD WITH (NOLOCK)
WHERE Empresa = @Empresa
ELSE
SELECT @RutaGenerarQRCode = RTRIM(LTRIM(ISNULL(RutaGenerarQRCode,'')))
FROM EmpresaCFDRetencion WITH (NOLOCK)
WHERE Empresa = @Empresa
SELECT @Cadena = '?re='+ISNULL(@RFCEmisor,'')+'&rr='+ISNULL(@RFCReceptor,'')+'&tt='+dbo.fnCFDFlexFormatearImporte(@montoTotRet,10,6)+'&id='+@UUID
SELECT @Shell = CHAR(34) + CHAR(34) + @RutaGenerarQRCode + CHAR(34) + ' ' + CHAR(34) + @ArchivoQRCode + CHAR(34) + ' ' + CHAR(34) + @Cadena + CHAR(34) + CHAR(34)
EXEC xp_cmdshell @Shell, no_output
RETURN
END

