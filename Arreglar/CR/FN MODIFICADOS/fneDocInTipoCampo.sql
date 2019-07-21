SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER FUNCTION fneDocInTipoCampo (@Campo varchar(50))
RETURNS varchar(50)

AS BEGIN
DECLARE
@Resultado varchar(50)
SELECT @Resultado = CASE WHEN @Campo IN ('numeric', 'int', 'money', 'decimal', 'float', 'bigint', 'smallint', 'tinyint') THEN 'NUMERICO'
WHEN @Campo IN ('bit') THEN 'LOGICO'
WHEN @Campo IN ('smalldatetime', 'datetime') THEN 'FECHA'
WHEN @Campo IN ('char', 'nchar', 'nvarchar', 'binary', 'uniqueidentifier', 'varbinary', 'varchar', 'xml', 'timestamp', 'text') THEN 'TEXTO'
ELSE 'TEXTO'
END
RETURN (@Resultado)
END

