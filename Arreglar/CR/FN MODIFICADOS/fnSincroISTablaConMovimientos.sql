SET DATEFIRST 7    
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1  
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER FUNCTION dbo.fnSincroISTablaConMovimientos
(
@Tabla				varchar(50)
)
RETURNS nvarchar(100)

AS BEGIN
DECLARE
@Resultado				nvarchar(100),
@ID						int,
@TipoCampo				int,
@Campo					varchar(50)
SET @Campo = 'TIENEMOVIMIENTOS'
SELECT @ID = ID FROM SysObjects WHERE ID = OBJECT_ID('dbo.' + RTRIM(LTRIM(@Tabla))) AND type IN ('U')
SELECT @TipoCampo = XType FROM SysColumns WHERE ID = @ID AND RTRIM(LTRIM(UPPER([Name]))) = RTRIM(LTRIM(@Campo))
IF @TipoCampo = 104
SET @Resultado = N' AND ISNULL(' + RTRIM(LTRIM(@Tabla)) + N'.TieneMovimientos,0) = 0'
ELSE
SET @Resultado = ''
RETURN (@Resultado)
END

