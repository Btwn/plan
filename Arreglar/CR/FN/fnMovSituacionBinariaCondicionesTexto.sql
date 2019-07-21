SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER FUNCTION fnMovSituacionBinariaCondicionesTexto(
@ID				int,
@Operador		varchar(10),
@Condicional	bit
)
RETURNS varchar(max)
AS
BEGIN
DECLARE @Resultado			varchar(max), 
@RID					int,
@RIDAnt				int,
@Expresion1			varchar(255),
@Expresion2			varchar(255),
@Expresion3			varchar(255),
@OperadorCondicion	varchar(20)
SELECT @Resultado = 'Si'
IF ISNULL(@Condicional, 0) = 0
SELECT @Resultado = ''
ELSE
BEGIN
IF @Operador = 'Todas'
SELECT @Operador = '<Y>'
ELSE IF @Operador = 'Alguna'
SELECT @Operador = '<O>'
SELECT @RIDAnt = 0
WHILE(1=1)
BEGIN
SELECT @RID = MIN(RID)
FROM MovSituacionBinariaCondicion
WHERE ID = @ID
AND RID > @RIDAnt
IF @RID IS NULL BREAK
SELECT @RIDAnt = @RID
SELECT @Expresion1 = REPLACE(REPLACE(ISNULL(Expresion1, ''), '<', ''), '>', ''), @Expresion2 = ISNULL(Expresion2, ''), @Expresion3 = ISNULL(Expresion3, ''), @OperadorCondicion = ISNULL(Operador, '')
FROM MovSituacionBinariaCondicion
WHERE ID = @ID
AND RID = @RID
IF @OperadorCondicion = 'Entre'
SELECT @Resultado = @Resultado + ' (' + @Expresion1 + ' Entre ''' + @Expresion2 + ''' y ''' + @Expresion3 + ''') ' + @Operador
ELSE IF @OperadorCondicion = 'Igual que'
SELECT @Resultado = @Resultado + ' (' + @Expresion1 + ' = ''' + @Expresion2 + ''') ' + @Operador
ELSE IF @OperadorCondicion = 'Mayor o igual que'
SELECT @Resultado = @Resultado + ' (' + @Expresion1 + ' >= ''' + @Expresion2 + ''') ' + @Operador
ELSE IF @OperadorCondicion = 'Menor o igual que'
SELECT @Resultado = @Resultado + ' (' + @Expresion1 + ' <= ''' + @Expresion2 + ''') ' + @Operador
ELSE IF @OperadorCondicion = 'Mayor que'
SELECT @Resultado = @Resultado + ' (' + @Expresion1 + ' > ''' + @Expresion2 + ''') ' + @Operador
ELSE IF @OperadorCondicion = 'Menor que'
SELECT @Resultado = @Resultado + ' (' + @Expresion1 + ' < ''' + @Expresion2 + ''') ' + @Operador
ELSE IF @OperadorCondicion = 'Distinto que'
SELECT @Resultado = @Resultado + ' (' + @Expresion1 + ' <> ''' + @Expresion2 + ''') '  + @Operador
ELSE IF @OperadorCondicion = 'Contiene'
SELECT @Resultado = @Resultado + ' (' + @Expresion1 + ' Contiene ''%' + @Expresion2 + '%'') ' + @Operador
END
SELECT @Resultado = NULLIF(@Resultado, 'Si')
SELECT @Resultado = REPLACE(LEFT(@Resultado, LEN(@Resultado) - 3), @Operador, REPLACE(REPLACE(@Operador, '<', ''), '>', ''))
END
RETURN @Resultado
END

