SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER FUNCTION fnFormatearNumero
(
@Numero				float,
@Enteros				int,
@Decimales				int
)
RETURNS varchar(100)

AS BEGIN
DECLARE
@Resultado	varchar(100),
@a			varchar(100)
SELECT @a = CONVERT(varchar,FLOOR(@Numero*POWER(10,@Decimales)))
SElECT @Resultado =dbo.fnRellenarCerosIzquierda(@a,@Enteros + @Decimales )
RETURN (@Resultado)
END

