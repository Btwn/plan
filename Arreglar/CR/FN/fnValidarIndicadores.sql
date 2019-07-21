SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER FUNCTION fnValidarIndicadores
(@ID int, @Indicador varchar(20), @Valor	varchar(255))
RETURNS bit

AS BEGIN
DECLARE
@Resultado	bit,
@Tipo			varchar(30)
SET @Resultado = 0
IF NOT EXISTS(SELECT * FROM SAUXDIndicador WHERE ID = @ID) AND ISNULL(@ID,0) <> 0
SET @Resultado = 1
IF ISNULL(@ID,0) <> 0
DECLARE crVerificar CURSOR FOR
SELECT s.Indicador, i.Tipo
FROM SAUXDIndicador s
JOIN SAUXIndicador i ON s.Indicador = i.Indicador
JOIN SAUXIndicadorD d ON i.Indicador = d.Indicador
WHERE ID = @ID
AND s.Indicador = @Indicador
ELSE
DECLARE crVerificar CURSOR FOR
SELECT i.Indicador, i.Tipo
FROM SAUXIndicador i
WHERE i.Indicador = @Indicador
OPEN crVerificar
FETCH NEXT FROM crVerificar INTO @Indicador, @Tipo
WHILE @@FETCH_STATUS = 0
BEGIN
IF @Tipo = 'Numérico' AND @Resultado = 0 AND ISNUMERIC(@Valor) = 0
SET @Resultado = 1
ELSE
IF @Tipo = 'Alfanumérico Variable' AND @Resultado = 0
IF @Valor = '' OR ISNUMERIC(@Valor) = 1
SET @Resultado = 1
ELSE
IF @Tipo = 'Lista Opcional' AND @Resultado = 0
IF @Valor = ''
SET @Resultado = 1
IF @Tipo <> 'Lista Opcional' AND @Resultado = 0 AND ISNULL(@ID,0) <> 0
IF @Valor NOT IN (SELECT Parametro FROM SAUXIndicadorD WHERE Indicador = @Indicador)
SET @Resultado = 1
FETCH NEXT FROM crVerificar INTO @Indicador, @Tipo
END
CLOSE crVerificar
DEALLOCATE crVerificar
RETURN (@Resultado)
END

