SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER FUNCTION fnSincroISTablaFiltroEspecial
(
@Tabla					varchar(50)
)
RETURNS varchar(255)

AS BEGIN
DECLARE
@Resultado	varchar(255),
@Expresion	varchar(255),
@Operador	varchar(50)
DECLARE crSincroISTablaFiltroEspecial CURSOR FOR
SELECT ISNULL(Expresion,''), ISNULL(Operador,'')
FROM SincroISTablaFiltroEspecial
WHERE Tabla = @Tabla
ORDER BY Orden
SET @Resultado = ''
OPEN crSincroISTablaFiltroEspecial
FETCH NEXT FROM crSincroISTablaFiltroEspecial INTO @Expresion, @Operador
WHILE @@FETCH_STATUS = 0
BEGIN
SET @Resultado = LTRIM(@Resultado) + @Operador + CASE WHEN NULLIF(@Operador,'') IS NOT NULL THEN ' ' + @Expresion ELSE @Expresion END + ' '
FETCH NEXT FROM crSincroISTablaFiltroEspecial INTO @Expresion, @Operador
END
CLOSE crSincroISTablaFiltroEspecial
DEALLOCATE crSincroISTablaFiltroEspecial
IF NULLIF(@Resultado,'') IS NOT NULL
SET @Resultado = '(' + RTRIM(@Resultado) + ')'
SET @Resultado = ISNULL(@Resultado,'')
RETURN (@Resultado)
END

