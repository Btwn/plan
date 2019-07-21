SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spLayoutRegistro
@ArchivoID			int,
@Layout				varchar(50),
@LayoutFormato			varchar(20),
@LayoutSeparador		varchar(10),
@LayoutTextosEntreComillas	bit,
@LayoutInsertarVacios		bit,
@Lista				varchar(50),
@Datos				varchar(8000),
@Registro			int,
@Ok				int		OUTPUT,
@OkRef				varchar(255)	OUTPUT

AS BEGIN
DECLARE
@Campo		varchar(50),
@PosicionSt		varchar(20),
@Posicion		int,
@uPosicion		int,
@TamanoSt		varchar(20),
@Tamano		int,
@TipoDatos		varchar(20),
@Orden		int,
@Mayusculas		bit,
@Minusculas		bit,
@DividirEntre100	bit,
@TieneSubCampos	bit,
@Valor		varchar(8000),
@Etiqueta		varchar(20),
@p			int,
@up			int,
@Salir		bit
SELECT @uPosicion = NULL, @up = 1
DECLARE crLayoutCampo CURSOR LOCAL FOR
SELECT Campo, NULLIF(RTRIM(Posicion), ''), NULLIF(RTRIM(Tamano), ''), TipoDatos, Orden, ISNULL(Mayusculas, 0), ISNULL(Minusculas, 0), ISNULL(DividirEntre100, 0), ISNULL(TieneSubCampos, 0)
FROM LayoutCampo WITH(NOLOCK)
WHERE Layout = @Layout AND Lista = @Lista
ORDER BY Orden
OPEN crLayoutCampo
FETCH NEXT FROM crLayoutCampo INTO @Campo, @PosicionSt, @TamanoSt, @TipoDatos, @Orden, @Mayusculas, @Minusculas, @DividirEntre100, @TieneSubCampos
WHILE @@FETCH_STATUS <> -1
BEGIN
IF @@FETCH_STATUS <> -2
BEGIN
SELECT @Valor = NULL, @Posicion = NULL
IF @PosicionSt IS NULL
SELECT @Posicion = @up
ELSE BEGIN
IF dbo.fnEsNumerico(@PosicionSt) = 1
SELECT @Posicion = CONVERT(int, @PosicionSt)
ELSE BEGIN
SELECT @Etiqueta = dbo.fnCaracterEspecial(@PosicionSt)
IF @Etiqueta IS NULL
SELECT @Etiqueta = dbo.fnQuitarComillas(@PosicionSt)
IF @Etiqueta IS NOT NULL
SELECT @Posicion = NULLIF(CHARINDEX(@Etiqueta, @Datos, 1), 0) + LEN(@Etiqueta)
END
END
IF @LayoutFormato = 'SEPARADOR'
BEGIN
EXEC spExtraerDato @Datos OUTPUT, @Valor OUTPUT, @LayoutSeparador
IF @LayoutTextosEntreComillas = 1
SELECT @Valor = dbo.fnQuitarComillas(@Valor)
END ELSE
IF @LayoutFormato = 'ANCHO FIJO'
BEGIN
IF @Posicion = 1 AND @uPosicion IS NOT NULL
FETCH NEXT FROM crArchivoD INTO @Datos
SELECT @Tamano = NULL
IF dbo.fnEsNumerico(@TamanoSt) = 1
BEGIN
SELECT @Tamano = CONVERT(int, @TamanoSt)
SELECT @Valor = SUBSTRING(@Datos, @Posicion, @Tamano)
SELECT @up = @Posicion + @Tamano
END ELSE
IF @TamanoSt IN ('(FIN LINEA)', '<CR>')
SELECT @Valor = SUBSTRING(@Datos, @Posicion, LEN(@Datos))
ELSE BEGIN
SELECT @Etiqueta = NULL, @p = 0
IF @TamanoSt NOT IN ('(LINEA VACIA)', '(FIN ARCHIVO)')
BEGIN
SELECT @Etiqueta = dbo.fnCaracterEspecial(@TamanoSt)
IF @Etiqueta IS NULL
SELECT @Etiqueta = dbo.fnQuitarComillas(@TamanoSt)
IF @Etiqueta IS NOT NULL
BEGIN
SELECT @p = CHARINDEX(@Etiqueta, @Datos, @Posicion)
IF @p > 0
BEGIN
SELECT @Valor = SUBSTRING(@Datos, @Posicion, @p - @Posicion)
SELECT @up = @p + LEN(@Etiqueta)
END ELSE
SELECT @Valor = SUBSTRING(@Datos, @Posicion, LEN(@Datos)), @p = LEN(@Datos)
END
END
IF @TamanoSt IN ('(LINEA VACIA)', '(FIN ARCHIVO)') OR (@Etiqueta IS NOT NULL AND @p = 0)
BEGIN
SELECT @Salir = 0
WHILE @Salir = 0
BEGIN
SELECT @p = 0
IF @Etiqueta IS NOT NULL
BEGIN
SELECT @p = CHARINDEX(@Etiqueta, @Datos, @Posicion)
SELECT @Salir = 1
END
IF @p = 0
SELECT @p = LEN(@Datos)
SELECT @Valor = ISNULL(@Valor, '') + SUBSTRING(@Datos, @Posicion, @p)
IF @TamanoSt = '(LINEA VACIA)' AND NULLIF(RTRIM(@Datos), '') IS NULL
SELECT @Salir = 1
IF @Salir = 0
BEGIN
FETCH NEXT FROM crArchivoD INTO @Datos
IF @@FETCH_STATUS <> 0
SELECT @Salir = 1
ELSE
SELECT @Valor = @Valor + CHAR(13), @Posicion = 1
END
END
END
END
END
EXEC spLayoutDatos @ArchivoID, @Layout, @LayoutInsertarVacios, @Lista, @Registro, @Campo, NULL, @Valor, @Mayusculas, @Minusculas, @DividirEntre100
IF @TieneSubCampos = 1
EXEC spLayoutSubRegistro @ArchivoID, @Layout, @LayoutFormato, @LayoutSeparador, @LayoutTextosEntreComillas, @LayoutInsertarVacios, @Lista, @Valor, @Registro, @Campo, @Ok OUTPUT, @OkRef OUTPUT
SELECT @uPosicion = @Posicion, @up = @p
END
FETCH NEXT FROM crLayoutCampo INTO @Campo, @PosicionSt, @TamanoSt, @TipoDatos, @Orden, @Mayusculas, @Minusculas, @DividirEntre100, @TieneSubCampos
END
CLOSE crLayoutCampo
DEALLOCATE crLayoutCampo
RETURN
END

