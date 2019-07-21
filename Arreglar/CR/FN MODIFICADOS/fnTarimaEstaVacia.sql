SET DATEFIRST 7    
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1  
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER FUNCTION fnTarimaEstaVacia (@Empresa varchar(5), @Tarima varchar(20))
RETURNS bit

AS BEGIN
DECLARE
@Resultado	bit
SELECT @Resultado = 1
IF EXISTS(SELECT * FROM ArtExistenciaTarima WHERE Empresa = @Empresa AND Tarima = @Tarima AND NULLIF(Existencia, 0.0) IS NOT NULL)
SELECT @Resultado = 0
RETURN(@Resultado)
END

