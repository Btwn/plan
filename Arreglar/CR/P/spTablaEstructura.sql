SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spTablaEstructura
@Tabla			varchar(255),
@SELECT				varchar(max)	= NULL OUTPUT,
@TABLE				varchar(max)	= NULL OUTPUT,
@DECALRE			varchar(max)	= NULL OUTPUT,
@SET				varchar(max)	= NULL OUTPUT,
@PARAMS				varchar(max)	= NULL OUTPUT,
@WITH				varchar(max)	= NULL OUTPUT,
@JOIN				varchar(max)	= NULL OUTPUT,
@VALUES				varchar(max)	= NULL OUTPUT,
@CampoIdentity		varchar(100)	= NULL OUTPUT,
@ExcluirTimeStamp	bit = 0,
@ExcluirCalculados	bit = 0,
@ExcluirBLOBs		bit = 0,
@ExcluirImage		bit = 0,
@ExcluirIdentity	bit = 0,
@ASCampo			bit = 0,
@PK					bit = 0,
@Prefijo			varchar(100)	= NULL,
@Sufijo				varchar(100)	= NULL,
@JOIN_Tabla1		varchar(100)	= NULL,
@JOIN_Tabla2		varchar(100)	= NULL,
@ReemplazarCampo	varchar(100)	= NULL,
@ReemplazarValor	varchar(100)	= NULL,
@ReemplazarTipo		varchar(100)	= NULL

AS BEGIN
DECLARE
@Campo		varchar(265),
@TipoDatos		varchar(256),
@TipoDatosExt	varchar(256),
@AS			varchar(256),
@Valor		varchar(256),
@Ancho		smallint,
@AceptaNulos	bit,
@EsIdentity		bit,
@EsCalculado	bit,
@Continuar		bit
SELECT @SELECT = NULL, @VALUES = NULL, @TABLE = NULL, @DECALRE = NULL, @SET = NULL, @PARAMS = NULL, @WITH = NULL, @JOIN = NULL, @CampoIdentity = NULL
SELECT @Prefijo = ISNULL(@Prefijo, ''), @Sufijo = ISNULL(@Sufijo, ''), @JOIN_Tabla1 = ISNULL(@JOIN_Tabla1, ''), @JOIN_Tabla2 = ISNULL(@JOIN_Tabla2, '')
IF @JOIN_Tabla1 <> '' SELECT @JOIN_Tabla1 = @JOIN_Tabla1 + '.'
IF @JOIN_Tabla2 <> '' SELECT @JOIN_Tabla2 = @JOIN_Tabla2 + '.'
IF @PK = 1
DECLARE crSysCampo CURSOR LOCAL FOR
SELECT Campo, TipoDatos, Ancho, AceptaNulos, EsIdentity, EsCalculado
FROM SysCampoExt
WHERE Tabla = @Tabla AND Campo IN (SELECT Campo FROM dbo.fnTablaPK(@Tabla))
ORDER BY Orden
ELSE
DECLARE crSysCampo CURSOR LOCAL FOR
SELECT Campo, TipoDatos, Ancho, AceptaNulos, EsIdentity, EsCalculado
FROM SysCampoExt
WHERE Tabla = @Tabla
ORDER BY Orden
OPEN crSysCampo
FETCH NEXT FROM crSysCampo INTO @Campo, @TipoDatos, @Ancho, @AceptaNulos, @EsIdentity, @EsCalculado
WHILE @@FETCH_STATUS <> -1
BEGIN
IF @@FETCH_STATUS <> -2
BEGIN
SELECT @Continuar = 1
IF @EsIdentity = 1 SELECT @CampoIdentity = @Campo
IF @EsIdentity = 1 AND @ExcluirIdentity = 1 SELECT @Continuar = 0
IF @ExcluirTimeStamp = 1 AND LOWER(@TipoDatos) = 'timestamp' SELECT @Continuar = 0
IF @ExcluirCalculados = 1 AND @EsCalculado = 1 SELECT @Continuar = 0
IF @ExcluirBLOBs = 1 AND LOWER(@TipoDatos) IN ('text', 'ntext', 'image') SELECT @Continuar = 0
IF @ExcluirImage = 1 AND LOWER(@TipoDatos) = 'image' SELECT @Continuar = 0
IF @Continuar = 1
BEGIN
SELECT @TipoDatosExt = @TipoDatos
IF LOWER(@TipoDatos) IN ('char', 'varchar', 'nchar', 'nvarchar', 'binary')
SELECT @TipoDatosExt = @TipoDatosExt+'('+CASE WHEN @Ancho = -1 THEN 'max' ELSE CONVERT(varchar, @Ancho) END+')'
IF ISNULL(@ReemplazarTipo, '') <> ''
SELECT @TipoDatosExt = @ReemplazarTipo
IF @ASCampo = 1 SELECT @AS = ' AS '+@Campo ELSE SELECT @AS = ''
IF @Campo = @ReemplazarCampo SELECT @Valor = @ReemplazarValor ELSE SELECT @Valor = @Prefijo+@Campo+@Sufijo+@AS
SELECT @SELECT = dbo.fnConcatenarMAX(@SELECT, @Prefijo+@Campo+@Sufijo+@AS, ', '),
@VALUES = dbo.fnConcatenarMAX(@VALUES, @Valor, ', '),
@TABLE  = dbo.fnConcatenarMAX(@TABLE, @Campo + ' ' + @TipoDatosExt, ', '),
@WITH   = dbo.fnConcatenarMAX(@WITH, @Campo + ' ' + @TipoDatosExt, ', '),
@JOIN   = dbo.fnConcatenarMAX(@JOIN, @JOIN_Tabla1+@Campo+'='+@JOIN_Tabla2+@Campo, ' AND '),
@DECALRE= dbo.fnConcatenarMAX(@DECALRE, '@'+@Campo+' '+@TipoDatosExt, ', '),
@SET    = dbo.fnConcatenarMAX(@SET, @Prefijo+@Campo+@Sufijo+'=@'+@Campo, ', '),
@PARAMS = dbo.fnConcatenarMAX(@PARAMS, '@'+@Campo, ', ')/*,
@PIPES  = dbo.fnConcatenarMAX(@PIPES, 'CONVERT(varchar(max), '+@Campo+')', '+"|"+')*/
IF CHARINDEX('CHAR', UPPER(@TipoDatosExt)) > 0
SELECT @TABLE = @TABLE + ' COLLATE Database_Default NULL'
ELSE
SELECT @TABLE = @TABLE + ' NULL'
END
END
FETCH NEXT FROM crSysCampo INTO @Campo, @TipoDatos, @Ancho, @AceptaNulos, @EsIdentity, @EsCalculado
END
CLOSE crSysCampo
DEALLOCATE crSysCampo
RETURN
END

