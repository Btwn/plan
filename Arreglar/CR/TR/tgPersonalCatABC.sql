SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER TRIGGER tgPersonalCatABC ON PersonalCat

FOR INSERT, UPDATE, DELETE
AS BEGIN
DECLARE
@CategoriaI  varchar(50),
@CategoriaD  varchar(50)
IF dbo.fnEstaSincronizando() = 1 RETURN
SELECT @CategoriaI = Categoria FROM Inserted
SELECT @CategoriaD = Categoria FROM Deleted
IF @CategoriaD IS NULL
BEGIN
DELETE PersonalPropValor WHERE Rama = 'CAT' AND Cuenta = @CategoriaI
INSERT PersonalPropValor (Propiedad, Rama, Cuenta, Valor) SELECT Propiedad, 'CAT', @CategoriaI, porOmision FROM PersonalProp WHERE NivelCategoria = 1
END ELSE
IF @CategoriaI IS NULL
DELETE PersonalPropValor WHERE Rama = 'CAT' AND Cuenta = @CategoriaD
ELSE
IF @CategoriaI <> @CategoriaD
UPDATE PersonalPropValor SET Cuenta = @CategoriaI WHERE Rama = 'CAT' AND Cuenta = @CategoriaD
END

