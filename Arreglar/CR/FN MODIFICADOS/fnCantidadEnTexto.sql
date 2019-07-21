SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER FUNCTION dbo.fnCantidadEnTexto(@Importe money)
RETURNS char(30)
AS
BEGIN
DECLARE
@Coma                 varchar(1),
@Punto                varchar(1),
@Largo                int,
@LargoPunto           int,
@Cadena               varchar(30),
@CadenaPunto          varchar(5),
@CadenaEntero         varchar(30),
@Negativo             bit,
@Texto                varchar(30)
SELECT @Negativo = 0
IF @Importe < 0
SELECT @Negativo = 1
SELECT @Importe = ABS(@Importe)
SELECT @Coma = ',', @Punto = '.'
SELECT @Cadena = @Importe
SELECT @LargoPunto = CHARINDEX(@Punto, @Cadena, 1)
SELECT @CadenaPunto = SUBSTRING(@Cadena, @LargoPunto+1, 20)
SELECT @CadenaEntero = SUBSTRING(@Cadena, 1, @LargoPunto-1)
SELECT @CadenaEntero = LTRIM(@CadenaEntero)
SELECT @Largo = LEN(@CadenaEntero)
WHILE @Largo > 3
BEGIN
SELECT @Cadena = RIGHT(@CadenaEntero, 3)
SELECT @Texto = @Coma + LTRIM(@Cadena) + ISNULL(@Texto, '')
SELECT @CadenaEntero = SUBSTRING(@CadenaEntero, 1, @Largo - 3)
SELECT @Largo = LEN(@CadenaEntero)
END
IF @Largo > 0
SELECT @Texto = LTRIM(@CadenaEntero) + ISNULL(@Texto, '')
IF @LargoPunto > 0
SELECT @Texto = ISNULL(@Texto, '') + @Punto + @CadenaPunto
IF @Negativo = 1
SELECT @Texto = '-' + @Texto
RETURN @Texto
END

