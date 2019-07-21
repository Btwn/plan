SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER FUNCTION fnCFDFlexFormatearImporte
(
@Importe				float,
@Entero					int,
@Decimal				int
)
RETURNS varchar(255)

AS BEGIN
DECLARE
@Resultado			varchar(255),
@NumeroEntero		int,
@NumeroDecimal		float,
@TextoEntero		varchar(100),
@TextoDecimal		varchar(100),
@PosicionInicial	int,
@LongitudDecimal	int
SET @NumeroEntero = FLOOR(@Importe)
SET @NumeroDecimal = @Importe - @NumeroEntero
SET @TextoEntero  = RTRIM(LTRIM(CONVERT(varchar,@NumeroEntero)))
SET @TextoDecimal = RTRIM(LTRIM(CONVERT(varchar,@NumeroDecimal)))
IF @TextoDecimal NOT IN ('0')
BEGIN
SET @PosicionInicial = CHARINDEX('.',@TextoDecimal) + 1
SET @LongitudDecimal = LEN(@TextoDecimal) - 2
SET @TextoDecimal = SUBSTRING(@TextoDecimal,@PosicionInicial,@LongitudDecimal)
END
SET @TextoEntero = REPLICATE('0',10-LEN(@TextoEntero)) + @TextoEntero
SET @TextoDecimal = SUBSTRING(@TextoDecimal,1,6)
SET @TextoDecimal = @TextoDecimal + REPLICATE('0',6-LEN(@TextoDecimal))
SET @Resultado = RTRIM(@TextoEntero) + '.' + RTRIM(@TextoDecimal)
RETURN (@Resultado)
END

