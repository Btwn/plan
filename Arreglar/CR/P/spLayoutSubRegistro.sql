SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spLayoutSubRegistro
@ArchivoID			int,
@Layout				varchar(50),
@LayoutFormato			varchar(20),
@LayoutSeparador		varchar(10),
@LayoutTextosEntreComillas	bit,
@LayoutInsertarVacios		bit,
@Lista				varchar(50),
@Datos				varchar(8000),
@Registro			int,
@Campo				varchar(50),
@Ok				int		OUTPUT,
@OkRef				varchar(255)	OUTPUT

AS BEGIN
DECLARE
@SubCampo		varchar(50),
@PosicionSt		varchar(20),
@Posicion		int,
@TamanoSt		varchar(20),
@Tamano		int,
@TipoDatos		varchar(20),
@Orden		int,
@Mayusculas		bit,
@Minusculas		bit,
@DividirEntre100	bit,
@Valor		varchar(8000),
@Etiqueta		varchar(20),
@p			int,
@up			int,
@Salir		bit
SELECT @up = 1
DECLARE crLayoutSubCampo CURSOR LOCAL FOR
SELECT SubCampo, NULLIF(RTRIM(Posicion), ''), NULLIF(RTRIM(Tamano), ''), TipoDatos, Orden, ISNULL(Mayusculas, 0), ISNULL(Minusculas, 0), ISNULL(DividirEntre100, 0)
FROM LayoutSubCampo
WHERE Layout = @Layout AND Lista = @Lista AND Campo = @Campo
ORDER BY Orden
OPEN crLayoutSubCampo
FETCH NEXT FROM crLayoutSubCampo INTO @SubCampo, @PosicionSt, @TamanoSt, @TipoDatos, @Orden, @Mayusculas, @Minusculas, @DividirEntre100
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
SELECT @Tamano = NULL
IF dbo.fnEsNumerico(@TamanoSt) = 1
BEGIN
SELECT @Tamano = CONVERT(int, @TamanoSt)
SELECT @Valor = SUBSTRING(@Datos, @Posicion, @Tamano)
SELECT @up = @Posicion + @Tamano
END ELSE
IF @TamanoSt IN ('(FIN LINEA)', '<CR>')
BEGIN
SELECT @Valor = SUBSTRING(@Datos, @Posicion, LEN(@Datos))
END ELSE BEGIN
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
END
EXEC spLayoutDatos @ArchivoID, @Layout, @LayoutInsertarVacios, @Lista, @Registro, @Campo, @SubCampo, @Valor, @Mayusculas, @Minusculas, @DividirEntre100
END
FETCH NEXT FROM crLayoutSubCampo INTO @SubCampo, @PosicionSt, @TamanoSt, @TipoDatos, @Orden, @Mayusculas, @Minusculas, @DividirEntre100
END
CLOSE crLayoutSubCampo
DEALLOCATE crLayoutSubCampo
RETURN
END

