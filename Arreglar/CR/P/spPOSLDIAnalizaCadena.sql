SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spPOSLDIAnalizaCadena
@Cadena		nvarchar(2048),
@NumeroCampo	varchar(10),
@Valor		nvarchar(2048) OUTPUT

AS
BEGIN
DECLARE
@CaracterInicial	int,
@CaracterFinal	int,
@Separador		varchar(1),
@CadenaTruncada	nvarchar(2048)
SELECT @NumeroCampo = @NumeroCampo + ':', @Separador = ';'
SELECT @Cadena = REPLACE(@Cadena, '}', '')
SELECT @CaracterInicial = CHARINDEX(@NumeroCampo, @Cadena) + LEN(@NumeroCampo)
IF @CaracterInicial < 0
SELECT @CaracterInicial = 2048
SELECT @CadenaTruncada = SUBSTRING(@Cadena, @CaracterInicial, 2048)
SELECT @CaracterFinal = CHARINDEX(@Separador, @CadenaTruncada) -  LEN(@Separador)
IF @CaracterFinal < 0
SELECT @CaracterFinal = 2048
SELECT @CadenaTruncada = SUBSTRING(@CadenaTruncada, 1, ISNULL(@CaracterFinal, 1))
SELECT @Valor = @CadenaTruncada
END

