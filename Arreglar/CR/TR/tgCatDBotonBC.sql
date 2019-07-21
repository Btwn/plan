SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER TRIGGER tgCatDBotonBC ON CatDBoton

FOR UPDATE, DELETE
AS BEGIN
DECLARE
@CatalogoN  varchar(20),
@CatalogoA    varchar(20),
@PaginaN      varchar(20),
@PaginaA      varchar(20),
@BotonN varchar(5),
@BotonA varchar(5)
IF dbo.fnEstaSincronizando() = 1 RETURN
SELECT @CatalogoN  = Catalogo, @PaginaN = Pagina, @BotonN = Boton FROM Inserted
SELECT @CatalogoA  = Catalogo, @PaginaA = Pagina, @BotonA = Boton FROM Deleted
IF @CatalogoA = @CatalogoN AND @PaginaA = @PaginaN AND @BotonA = @BotonN RETURN
IF @BotonN IS NULL
BEGIN
DELETE CatDBotonExtra WHERE Catalogo = @CatalogoA AND Pagina = @PaginaA AND Boton = @BotonA
END ELSE
BEGIN
UPDATE CatDBotonExtra SET Catalogo = @CatalogoN, Pagina = @PaginaN, Boton = @BotonN WHERE Catalogo = @CatalogoA AND Pagina = @PaginaA AND Boton = @BotonA
END
END

