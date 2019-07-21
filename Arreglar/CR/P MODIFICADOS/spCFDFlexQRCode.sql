SET DATEFIRST 7    
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1  
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spCFDFlexQRCode
@Empresa	varchar(5),
@Modulo		varchar(5),
@ID			int,
@Imagen		varchar(255)

AS BEGIN
DECLARE
@TextoQRCode			varchar(max),
@Shell					varchar(8000),
@RutaGenerarQRCode		varchar(max)
SELECT @RutaGenerarQRCode = RTRIM(LTRIM(ISNULL(RutaGenerarQRCode,'')))
FROM EmpresaCFD WITH (NOLOCK)
WHERE Empresa = @Empresa
DECLARE @Tabla TABLE (
TextoQRCode		varchar(max)
)
DELETE @Tabla
INSERT INTO @Tabla
EXEC spCFDFlexTextoQRCode @Modulo, @ID
SELECT TOP 1 @TextoQRCode = RTRIM(LTRIM(ISNULL(TextoQRCode,''))) FROM @Tabla
SELECT @Shell = CHAR(34) + CHAR(34) + @RutaGenerarQRCode + CHAR(34) + ' ' + CHAR(34) + @Imagen + CHAR(34) + ' ' + CHAR(34) + @TextoQRCode + CHAR(34) + CHAR(34)
EXEC xp_cmdshell @Shell, no_output
END

