SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spHistSugerirEstructura
@Tabla 				varchar(100),
@ConTipoDatos 		bit = 0,
@ConNulos 			bit = 0,
@ConvertirVarchar 	bit = 0,
@AsCalcSinDatos 	bit = 0,
@EnSilencio			bit = 0,
@HistCampo			bit = 0,
@Resultado			varchar(max) = NULL OUTPUT

AS BEGIN
DECLARE
@Campo				varchar(100),
@TipoDatos			varchar(100),
@TipoDatosTamano	varchar(100),
@Tamano				int,
@Nulos				bit,
@Calculado			bit,
@Estructura			varchar(255),
@ID					int,
@EsPK				bit,
@ChecarTieneDatos	bit,
@ConDatos			bit,
@SQL				nvarchar(4000)
DECLARE crSysTipoDatos CURSOR FOR
SELECT Campo, TipoDatos, Tamano, Nulos, Calculado
FROM SysTipoDatos WITH(NOLOCK)
WHERE Tabla = @Tabla
OPEN crSysTipoDatos
FETCH NEXT FROM crSysTipoDatos  INTO @Campo, @TipoDatos, @Tamano, @Nulos, @Calculado
WHILE @@FETCH_STATUS = 0
BEGIN
IF @Campo IN (NULL, 'SincroID', 'SincroC')
FETCH NEXT FROM crSysTipoDatos  INTO @Campo, @TipoDatos, @Tamano, @Nulos, @Calculado
IF @Campo NOT IN (NULL, 'SincroID', 'SincroC')
BEGIN
SELECT @Estructura = ''
IF @Calculado = 0
SELECT @Resultado  = ISNULL(@Resultado,'') + @Campo + ', '
SELECT @Estructura = ISNULL(@Estructura,'') + @Campo
IF @ConvertirVarchar = 1
BEGIN
IF @TipoDatos = 'char'  AND @Tamano > 5 SELECT @TipoDatos = 'varchar'
IF @TipoDatos = 'nchar' AND @Tamano > 5 SELECT @TipoDatos = 'nvarchar'
END
IF @TipoDatos IN ('char', 'nchar', 'varchar', 'nvarchar')
SELECT @TipoDatosTamano = @TipoDatos + '('+CASE WHEN CAST(@Tamano as varchar(10)) = '-1' THEN 'max' ELSE CAST(@Tamano as varchar(10)) END+')'
ELSE
SELECT @TipoDatosTamano = @TipoDatos
IF @ConTipoDatos = 1
SELECT @Estructura = ISNULL(@Estructura,'') +' '+ @TipoDatosTamano
IF @ConNulos = 1
SELECT @Estructura = ISNULL(@Estructura,'') +' '+CASE WHEN @Nulos = 1 THEN 'NULL' ELSE 'NOT NULL' END
IF EXISTS(SELECT * FROM dbo.fnTablaPK(@Tabla) WHERE Campo = @Campo) SELECT @EsPK = 1
IF @AsCalcSinDatos = 1 AND @EsPK = 0
BEGIN
SELECT @ChecarTieneDatos = 1
IF @EnSilencio = 1
BEGIN
IF EXISTS(SELECT * FROM HistCampo WHERE Tabla = @Tabla AND Campo = @Campo)
SELECT @ChecarTieneDatos = 0, @ConDatos = ConDatos FROM HistCampo WHERE Tabla = @Tabla AND Campo = @Campo
END
IF @ChecarTieneDatos = 1
BEGIN
IF @TipoDatos = 'bit'
BEGIN
SELECT @SQL = N'IF EXISTS(SELECT * FROM '+@Tabla+' WHERE '+@Campo+' <> 0) SELECT @ConDatos = 1 ELSE SELECT @ConDatos = 0'
EXEC sp_ExecuteSQL @SQL, N'@ConDatos bit OUTPUT', @ConDatos OUTPUT
END
ELSE
BEGIN
SELECT @SQL = N'IF EXISTS(SELECT * FROM '+@Tabla+' WHERE '+@Campo+' IS NOT NULL) SELECT @ConDatos = 1 ELSE SELECT @ConDatos = 0'
EXEC sp_ExecuteSQL @SQL, N'@ConDatos bit OUTPUT', @ConDatos OUTPUT
SELECT @ConDatos ConDatos
END
END
END
IF @HistCampo = 1
INSERT HistCampo (Tabla, Campo, ConDatos) VALUES (@Tabla, @Campo, @ConDatos)
SELECT @Estructura = @Estructura + ','
IF @EnSilencio <> 1
BEGIN
INSERT HistResultado ([SQL], Ejecutable) VALUES (@Estructura, 1)
SELECT @ID = SCOPE_IDENTITY()
END
FETCH NEXT FROM crSysTipoDatos  INTO @Campo, @TipoDatos, @Tamano, @Nulos, @Calculado
END
END
CLOSE crSysTipoDatos
DEALLOCATE crSysTipoDatos
IF @EnSilencio <> 1
BEGIN
UPDATE HistResultado  WITH(ROWLOCK) SET [SQL] = REPLACE([SQL],',','')
WHERE ID = @ID
END
IF(SELECT SUBSTRING(@Resultado, LEN(@Resultado), 1)) = ','
SELECT @Resultado = SUBSTRING(@Resultado, 1, LEN(@Resultado) - 1)
RETURN
END

