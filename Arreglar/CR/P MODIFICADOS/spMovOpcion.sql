SET DATEFIRST 7    
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1  
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spMovOpcion
@Modulo			char(5),
@ID				int,
@Renglon		float,
@RenglonSub		int,
@Subcuenta		varchar(50),
@Ok             int          OUTPUT,
@OkRef          varchar(255) OUTPUT

AS BEGIN
DECLARE
@SQL			nvarchar(max),
@Insert			varchar(max),
@Values			varchar(max)
IF NULLIF(@Subcuenta,'') IS NULL RETURN
SELECT @Insert = dbo.fnMovOpcionListaSeleccion(@Subcuenta,0)
SELECT @Values = dbo.fnMovOpcionValores(@Subcuenta)
SELECT @SQL = 'IF NOT EXISTS(SELECT * FROM MovOpcion WITH(NOLOCK) WHERE Modulo = ''' + @Modulo + ''' AND ModuloID = ' + CONVERT(varchar,@ID) + ' AND Renglon = ' + CONVERT(varchar,@Renglon) + ' AND RenglonSub = ' + CONVERT(varchar,@RenglonSub) + ')
BEGIN
INSERT MovOpcion (Modulo, ModuloID, Renglon, RenglonSub, ' + @Insert + ')
VALUES (''' + @Modulo + ''', '+ CONVERT(varchar,@ID) + ', ' + CONVERT(varchar,@Renglon) + ', ' + CONVERT(varchar,@Renglonsub) + ', ' + @Values + ')
END'
BEGIN TRY
EXEC sp_executesql @SQL
END TRY
BEGIN CATCH
SELECT @Ok = 1
END CATCH
END

