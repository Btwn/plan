SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER FUNCTION fneDocObtenerTipoColumna
(
@Campo		varchar(255),
@Objeto		varchar(100)
)
RETURNS varchar(50)
AS
BEGIN
DECLARE	@Resultado		varchar(50),
@ID				int,
@TipoCampo		int
SELECT @ID = ID FROM SysObjects WHERE ID = OBJECT_ID('dbo.' + RTRIM(LTRIM(@Objeto))) AND type IN ('V')
SELECT @TipoCampo = XType FROM SysColumns WHERE ID = @ID AND RTRIM(LTRIM([Name])) = RTRIM(LTRIM(@Campo))
IF @TipoCampo = 34  SET @Resultado = 'image' ELSE
IF @TipoCampo = 35  SET @Resultado = 'text' ELSE
IF @TipoCampo = 36  SET @Resultado = 'uniqueidentifier' ELSE
IF @TipoCampo = 48  SET @Resultado = 'tinyint' ELSE
IF @TipoCampo = 52  SET @Resultado = 'smallint' ELSE
IF @TipoCampo = 56  SET @Resultado = 'int' ELSE
IF @TipoCampo = 58  SET @Resultado = 'smalldatetime' ELSE
IF @TipoCampo = 59  SET @Resultado = 'real' ELSE
IF @TipoCampo = 60  SET @Resultado = 'money' ELSE
IF @TipoCampo = 61  SET @Resultado = 'datetime' ELSE
IF @TipoCampo = 62  SET @Resultado = 'float' ELSE
IF @TipoCampo = 98  SET @Resultado = 'sql_variant' ELSE
IF @TipoCampo = 99  SET @Resultado = 'ntext' ELSE
IF @TipoCampo = 104 SET @Resultado = 'bit' ELSE
IF @TipoCampo = 106 SET @Resultado = 'decimal' ELSE
IF @TipoCampo = 108 SET @Resultado = 'numeric' ELSE
IF @TipoCampo = 122 SET @Resultado = 'smallmoney' ELSE
IF @TipoCampo = 127 SET @Resultado = 'bigint' ELSE
IF @TipoCampo = 165 SET @Resultado = 'varbinary' ELSE
IF @TipoCampo = 167 SET @Resultado = 'varchar' ELSE
IF @TipoCampo = 173 SET @Resultado = 'binary' ELSE
IF @TipoCampo = 175 SET @Resultado = 'char' ELSE
IF @TipoCampo = 189 SET @Resultado = 'timestamp' ELSE
IF @TipoCampo = 231 SET @Resultado = 'nvarchar' ELSE
IF @TipoCampo = 239 SET @Resultado = 'nchar' ELSE
IF @TipoCampo = 241 SET @Resultado = 'xml'
RETURN RTRIM(LTRIM(@Resultado))
END

