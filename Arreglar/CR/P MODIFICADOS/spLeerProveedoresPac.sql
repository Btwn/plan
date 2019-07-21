SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spLeerProveedoresPac
@RutaArchivo		varchar(max),
@UsuarioPAC		varchar(50)=NULL  OUTPUT,
@PaswordPAC		varchar(50)=NULL OUTPUT,
@TokenPac			varchar(50)=NULL OUTPUT,
@Ok				int = NULL OUTPUT,
@OkRef			varchar(255) = NULL OUTPUT

AS BEGIN
DECLARE
@posIni int,
@pos int,
@SQL varchar(max),
@campo varchar(50)
IF exists(SELECT name FROM tempdb.dbo.sysobjects WHERE name like '#ProvPac%')
DROP TABLE #ProvPac
CREATE TABLE #ProvPac(Valor varchar(max))
SET @SQL = N'BULK INSERT #ProvPac
FROM ''' + @RutaArchivo +'''
WITH (CODEPAGE = ' + CONVERT(varchar, 1252) + ')'
EXEC (@SQL)
IF NOT EXISTS(SELECT * FROM #ProvPac)
BEGIN
SELECT @OK = 71525
SELECT @OkRef = (SELECT Descripcion FROM MensajeLista WITH (NOLOCK) WHERE Mensaje = @Ok)
SELECT @OkRef = @OkRef + ' ' + @RutaArchivo
END
ALTER TABLE #ProvPac ADD ID INT IDENTITY
SELECT @posIni= ID FROM #ProvPac WHERE Valor like  '%KONESH]%'
SELECT @campo= valor FROM #ProvPac WHERE ID= (@posIni+1)
SELECT @pos=CHARINDEX('USUARIO=', @campo)-LEN(@campo)
SELECT @pos=LEN(@campo)-8
SELECT @UsuarioPAC = right(@campo,@pos)
SELECT @campo= Valor FROM #ProvPac WHERE ID= (@posIni+2)
SELECT @pos=CHARINDEX('CONTRASENA=', @campo)-LEN(@campo)
SELECT @pos=LEN(@campo)-11
SELECT @PaswordPAC=right(@campo,@pos)
SELECT @campo= Valor FROM #ProvPac WHERE ID= (@posIni+3)
SELECT @pos=CHARINDEX('TOKEN=', @campo)-LEN(@campo)
SELECT @pos=LEN(@campo)-6
SELECT @TokenPAC=right(@campo,@pos)
END

