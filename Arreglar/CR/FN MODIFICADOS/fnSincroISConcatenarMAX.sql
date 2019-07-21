SET DATEFIRST 7    
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1  
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER FUNCTION fnSincroISConcatenarMAX (@Valor varchar(max), @Agregar varchar(max), @Separador varchar(20))
RETURNS varchar(max)
AS BEGIN
DECLARE
@Resultado	varchar(max)
SELECT @Valor = ISNULL(@Valor, '')
IF @Valor <> '' SELECT @Valor = @Valor + @Separador
RETURN (@Valor + @Agregar)
END

