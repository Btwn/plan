SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER FUNCTION fnQueCodigo (@Cual varchar(20), @Articulo varchar(20), @SubCuenta varchar(50), @Codigo varchar(50), @Contacto varchar(10))
RETURNS varchar(50)

AS BEGIN
DECLARE
@Resultado	varchar(50)
SELECT @Resultado = NULL
SELECT @Cual = UPPER(@Cual)
IF @Cual = 'CLAVE ARTICULO' 		SELECT @Resultado = @Articulo ELSE
IF @Cual = 'CODIGO BARRAS (MOV)' 	SELECT @Resultado = @Codigo ELSE
IF @Cual = 'CODIGO BARRAS (CB)' 	SELECT @Resultado = MIN(Codigo) FROM CB WHERE TipoCuenta = 'Articulos' AND Cuenta = @Articulo AND ISNULL(SubCuenta, '') = ISNULL(@SubCuenta, '') ELSE
IF @Cual = 'CLAVE FABRICANTE' 	SELECT @Resultado = ClaveFabricante FROM Art WHERE Articulo = @Articulo ELSE
IF @Cual = 'NOMBRE CORTO' 		SELECT @Resultado = NombreCorto FROM Art WHERE Articulo = @Articulo ELSE
IF @Cual = 'NOM' 			SELECT @Resultado = Registro1 FROM Art WHERE Articulo = @Articulo ELSE
IF @Cual = 'CODIGO ALTERNO' 		SELECT @Resultado = CodigoAlterno FROM Art WHERE Articulo = @Articulo ELSE
IF @Cual = 'IDIOMA CLIENTE' 		SELECT @Resultado = Codigo FROM ArtIdioma WHERE Articulo = @Articulo AND Idioma = @Contacto ELSE
IF @Cual = 'OPCION FABRICANTE' 	SELECT @Resultado = ClaveFabricante FROM ArtSub WHERE Articulo = @Articulo AND SubCuenta = @SubCuenta ELSE
IF @Cual = 'ISBN'           	    SELECT @Resultado = ISBN FROM Art WHERE Articulo = @Articulo
RETURN(@Resultado)
END

