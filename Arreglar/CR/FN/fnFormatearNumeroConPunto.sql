SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER FUNCTION fnFormatearNumeroConPunto
(
@Numero					float,
@Enteros				int,
@Decimales				int
)
RETURNS varchar (100)

AS BEGIN
DECLARE
@Resultado			varchar(100),
@TextoNumero		varchar(100),
@TextoEnteros		varchar(100),
@TextoDecimal		varchar(100)
SELECT @TextoNumero = dbo.fnFormatearNumero(@numero,@Enteros,@Decimales)
SELECT @TextoEnteros = ISNULL(LEFT(@TextoNumero,@Enteros),'')
SELECT @TextoDecimal = ISNULL(RIGHT(@TextoNumero,@Decimales),'')
SELECT @Resultado = @TextoEnteros + '.' + @TextoDecimal
RETURN (@Resultado)
END

