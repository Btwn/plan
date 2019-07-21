SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER FUNCTION fnValidarIndicadoresID
(@ID int)
RETURNS bit

AS BEGIN
DECLARE
@Resultado	bit,
@Indicador	varchar(20),
@Valor		varchar(255),
@Tipo			varchar(30)
SET @Resultado = 0
DECLARE crVerificar CURSOR FOR
SELECT s.Indicador, i.Tipo, RTRIM(ISNULL(s.Valor, ''))
FROM SAUXDIndicador s
JOIN SAUXIndicador i ON s.Indicador = i.Indicador
WHERE ID = @ID
OPEN crVerificar
FETCH NEXT FROM crVerificar INTO @Indicador, @Tipo, @Valor
WHILE @@FETCH_STATUS = 0
BEGIN
IF @Tipo = 'Numérico' AND @Resultado = 0
IF @Valor IS NULL
SET @Resultado = 1
ELSE
IF @Tipo = 'Lista Fija' AND @Resultado = 0
IF @Valor = ''
SET @Resultado = 1
ELSE
IF @Tipo = 'Alfanumérico Variable' AND @Resultado = 0
IF @Valor = ''
SET @Resultado = 1
ELSE
IF @Tipo = 'Lista Opcional' AND @Resultado = 0
IF @Valor = ''
SET @Resultado = 1
FETCH NEXT FROM crVerificar INTO @Indicador, @Tipo, @Valor
END
CLOSE crVerificar
DEALLOCATE crVerificar
RETURN (@Resultado)
END

