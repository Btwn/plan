SET DATEFIRST 7    
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1  
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROC spCFDINominaQRCode
@Estacion		int,
@ID				int,
@Personal		varchar(10),
@Empresa		varchar(5),
@Sucursal		int,
@Mov			varchar(20),
@MovID			varchar(20),
@Version		varchar(5),
@XML			varchar(max),
@Usuario		varchar(10),
@ArchivoQRCode		varchar(255),
@Ok				int			OUTPUT,
@OkRef			varchar(255)OUTPUT

AS
BEGIN
DECLARE @RFCEmisor			varchar(30),
@RFCReceptor			varchar(30),
@Importe				float,
@UUID					varchar(50),
@Cadena				varchar(max),
@Shell				varchar(8000),
@RutaGenerarQRCode	varchar(max)
SELECT @RutaGenerarQRCode = RTRIM(LTRIM(ISNULL(RutaGenerarQRCode,'')))
FROM EmpresaCFD WITH (NOLOCK)
WHERE Empresa = @Empresa
SELECT @RFCEmisor		= ISNULL(nr.RFCEmisor, ''),
@RFCReceptor	= ISNULL(nr.RFC, ''),
@Importe		= ISNULL(nr.TotalPercepciones, 0) - ISNULL(nr.TotalDeducciones, 0),
@UUID			= ISNULL(CONVERT(varchar(50), n.UUID), '')
FROM CFDINominaRecibo nr WITH (NOLOCK)
JOIN CFDNomina n WITH (NOLOCK) ON nr.ID = n.ModuloID AND n.Modulo = 'NOM' AND nr.Personal = n.Personal
WHERE nr.ID = @ID
AND nr.Personal = @Personal
SELECT @Cadena = '?re='+ISNULL(@RFCEmisor,'')+'&rr='+ISNULL(@RFCReceptor,'')+'&tt='+dbo.fnCFDFlexFormatearImporte(@Importe,10,6)+'&id='+@UUID
SELECT @Shell = CHAR(34) + CHAR(34) + @RutaGenerarQRCode + CHAR(34) + ' ' + CHAR(34) + @ArchivoQRCode + CHAR(34) + ' ' + CHAR(34) + @Cadena + CHAR(34) + CHAR(34)
EXEC xp_cmdshell @Shell, no_output
RETURN
END

