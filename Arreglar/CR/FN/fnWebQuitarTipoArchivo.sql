SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER FUNCTION fnWebQuitarTipoArchivo
(
@Expresion				varchar(255)
)
RETURNS varchar(255)

AS BEGIN
DECLARE
@Resultado			varchar(255),
@Posicion                   int
SELECT @Posicion = CHARINDEX('.',@Expresion)
SELECT @Resultado = SUBSTRING(@Expresion,1,@Posicion-1)
RETURN (@Resultado)
END

