SET DATEFIRST 7    
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1  
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER FUNCTION fnRellenarConCaracter
(
@Texto				varchar(100),
@Longitud				int,
@Direccion				varchar(1),
@Caracter				varchar(1)
)
RETURNS varchar(100)

AS BEGIN
DECLARE
@Resultado   varchar(100)
IF @Direccion IN ('I','i') SELECT @Resultado = RIGHT(REPLICATE(@Caracter,(CASE WHEN @Longitud -LEN (@Texto) > 0 THEN @Longitud -LEN(@Texto) ELSE 0 END))+@Texto,@Longitud) ELSE
IF @Direccion IN ('D','d') SELECT @Resultado = RIGHT(@Texto + REPLICATE(@Caracter,(@Longitud -LEN (@Texto))),@Longitud)
RETURN (@Resultado)
END

