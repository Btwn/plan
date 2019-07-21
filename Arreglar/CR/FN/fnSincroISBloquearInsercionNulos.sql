SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER FUNCTION fnSincroISBloquearInsercionNulos
(
@Campo				varchar(50),
@TipoDatos			varchar(50),
@AceptaNulos		bit
)
RETURNS varchar(50)

AS BEGIN
DECLARE
@Resultado	varchar(50)
IF ISNULL(@AceptaNulos,0) = 1 SET @Resultado = RTRIM(@Campo) ELSE
IF ISNULL(@AceptaNulos,0) = 0
BEGIN
IF @TipoDatos = 'int'              SET @Resultado = 'ISNULL(' + RTRIM(@Campo) + ',0)'                                                  ELSE
IF @TipoDatos = 'datetime'         SET @Resultado = 'ISNULL(' + RTRIM(@Campo) + ',CONVERT(datetime,''01/01/1900''))'                   ELSE
IF @TipoDatos = 'float'            SET @Resultado = 'ISNULL(' + RTRIM(@Campo) + ',0.0)'                                                ELSE
IF @TipoDatos = 'bit'              SET @Resultado = 'ISNULL(' + RTRIM(@Campo) + ',0)'                                                  ELSE
IF @TipoDatos = 'varchar'          SET @Resultado = 'ISNULL(' + RTRIM(@Campo) + ','''')'                                               ELSE
IF @TipoDatos = 'char'             SET @Resultado = 'ISNULL(' + RTRIM(@Campo) + ','''')'                                               ELSE
IF @TipoDatos = 'datetime'         SET @Resultado = 'ISNULL(' + RTRIM(@Campo) + ',CONVERT(timestamp,CONVERT(datetime,''01/01/1900''))' ELSE
IF @TipoDatos = 'uniqueidentifier' SET @Resultado = 'ISNULL(' + RTRIM(@Campo) + ',NEWID())'                                            ELSE
SET @Resultado = @Campo
END
RETURN (@Resultado)
END

