SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER FUNCTION fnEdifactDivisor
(
@Texto     varchar(255),
@LongitudMaxima   int
)
RETURNS varchar(255)

AS BEGIN
DECLARE
@Resultado   varchar(255),
@Continuar   bit,
@TextoLongitud  int,
@Sobrante    varchar(255),
@SobranteLongitud  int
SET @Resultado = ''
SET @SobranteLongitud = LEN(@Texto)
IF  @SobranteLongitud > @LongitudMaxima
BEGIN
SET @Sobrante = @Texto
SET @Continuar = 1
WHILE @Continuar = 1
BEGIN
SET @Resultado = @Resultado + LEFT(@Sobrante,@LongitudMaxima) + ':'
SET @Sobrante = SUBSTRING(@Sobrante,@LongitudMaxima+1,@SobranteLongitud-@LongitudMaxima)
SET @SobranteLongitud = LEN(@Sobrante)
IF @SobranteLongitud <= @LongitudMaxima
BEGIN
SET @Continuar = 0
END
END
SET @Resultado = @Resultado + @Sobrante
END ELSE
BEGIN
SET @Resultado = @Texto
END
RETURN (@Resultado)
END

