SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER FUNCTION fnListaDescuentos (@Lista varchar(255), @Separador char(1))
RETURNS float

AS BEGIN
DECLARE
@Cascada		float,
@DescuentoSt	varchar(20),
@Descuento		float,
@p			int
SELECT @Cascada = 100.0, @Lista = ISNULL(RTRIM(@Lista), '')
WHILE LEN(@Lista) > 0
BEGIN
SELECT @p = CHARINDEX(@Separador, @Lista)
IF @p>0
BEGIN
SELECT @DescuentoSt = LTRIM(RTRIM(SUBSTRING(@Lista, 1, @p-1)))
SELECT @Lista = SUBSTRING(@Lista, @p + 1, LEN(@Lista))
END ELSE
BEGIN
SELECT @DescuentoSt = LTRIM(RTRIM(@Lista))
SELECT @Lista = ''
END
IF dbo.fnEsNumerico(@DescuentoSt) = 1
SELECT @Descuento = CONVERT(float, @DescuentoSt)
ELSE
SELECT @Descuento = 0.0
IF @Descuento > 0.0
SELECT @Cascada = @Cascada - (@Cascada * (@Descuento/100))
END
RETURN (100.0-@Cascada)
END

