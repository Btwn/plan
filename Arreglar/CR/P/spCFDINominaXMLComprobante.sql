SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROC spCFDINominaXMLComprobante
@Estacion					int,
@ID							int,
@Personal					varchar(10),
@Version					varchar(5),
@Vista						varchar(100),
@TotalPercepciones			float,
@TotalDeducciones			float,
@PercepcionesTotalGravado	float,
@PercepcionesTotalExcento	float,
@DeduccionesTotalGravado	float,
@DeduccionesTotalExcento	float,
@XMLComprobante				varchar(max) OUTPUT,
@Ok							int			 OUTPUT,
@OkRef						varchar(255) OUTPUT

AS
BEGIN
DECLARE @CampoXML		varchar(100),
@CampoXMLAnt	varchar(100),
@CampoVista	varchar(100),
@SQL			nvarchar(max),
@Parametros	nvarchar(max)
SELECT @Parametros = '@XMLComprobante	varchar(max)	OUTPUT,
@ID				int,
@Personal		varchar(10)'
SELECT @CampoXMLAnt = ''
WHILE(1=1)
BEGIN
SELECT @CampoXML = MIN(CampoXML)
FROM CFDINominaXMLCampo
WHERE Version = @Version
AND CampoXML > @CampoXMLAnt
IF @CampoXML IS NULL BREAK
SELECT @CampoXMLAnt = @CampoXML
SELECT @CampoVista = CampoVista FROM CFDINominaXMLCampo WHERE Version = @Version AND CampoXML = @CampoXML
IF ISNULL(RTRIM(@CampoXML), '') <> '' AND ISNULL(RTRIM(@CampoVista), '') <> '' AND ISNULL(RTRIM(@Vista), '') <> ''
BEGIN
SELECT @SQL = 'SELECT @XMLComprobante = REPLACE(@XMLComprobante, ''' + ISNULL(RTRIM(@CampoXML), '') + ''', ISNULL(dbo.fnXMLValor(' + ISNULL(RTRIM(@CampoVista), '') + '), '''')) FROM ' + ISNULL(RTRIM(@Vista), '') + ' WHERE ID = @ID AND Personal = @Personal'
EXEC sp_executesql @SQL, @Parametros, @XMLComprobante OUTPUT, @ID, @Personal
END
END
RETURN
END

