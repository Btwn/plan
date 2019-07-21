SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER FUNCTION fnSincroISSincroIDTablaSinonimo
(
@Tabla					varchar(50),
@SincroID				int
)
RETURNS int

AS BEGIN
DECLARE
@Resultado			int,
@TablaSinonimo		varchar(50)
SELECT @Resultado = NULL, @TablaSinonimo = NULL
SELECT @TablaSinonimo = SinonimoTabla FROM SincroISTablaSinonimo WHERE Tabla = @Tabla
IF @TablaSinonimo IS NOT NULL
SELECT @Resultado = CONVERT(int,SincroID) FROM SysTabla WHERE SysTabla = @TablaSinonimo
SET @Resultado = ISNULL(@Resultado,CONVERT(int,@SincroID))
RETURN (@Resultado)
END

