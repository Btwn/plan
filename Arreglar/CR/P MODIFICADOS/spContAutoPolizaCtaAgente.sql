SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spContAutoPolizaCtaAgente
@Modulo			char(5),
@ID				int,
@Cta				varchar(20)	OUTPUT,
@Ok				int			= NULL OUTPUT,
@OkRef			varchar(255)= NULL OUTPUT

AS BEGIN
DECLARE
@SQL					nvarchar(max)
SET @SQL = N'SELECT @Cta = p.Cuenta FROM Prov p JOIN Agente a ON p.Proveedor = a.Acreedor WHERE a.Agente = (SELECT Agente FROM '+ @Modulo + ' WHERE ID = ' + CONVERT(varchar,@ID) + ' )'
EXEC sp_executesql @SQL, N'@Cta varchar(20) OUTPUT, @Modulo varchar(5), @ID varchar(20)', @Cta = @Cta OUTPUT, @Modulo = @Modulo, @ID = @ID
END

