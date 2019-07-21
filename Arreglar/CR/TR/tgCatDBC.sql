SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER TRIGGER tgCatDBC ON CatD

FOR UPDATE, DELETE
AS BEGIN
DECLARE
@CatalogoN  varchar(20),
@CatalogoA    varchar(20),
@PaginaN      varchar(20),
@PaginaA      varchar(20)
IF dbo.fnEstaSincronizando() = 1 RETURN
SELECT @CatalogoN  = Catalogo, @PaginaN = Pagina FROM Inserted
SELECT @CatalogoA  = Catalogo, @PaginaA = Pagina FROM Deleted
IF @CatalogoA = @CatalogoN AND @PaginaA = @PaginaN RETURN
IF @PaginaN IS NULL
BEGIN
DELETE CatDBoton      WHERE Catalogo = @CatalogoA AND Pagina = @PaginaA
DELETE CatDBotonExtra WHERE Catalogo = @CatalogoA AND Pagina = @PaginaA
END ELSE
BEGIN
UPDATE CatDBoton      SET Catalogo = @CatalogoN, Pagina = @PaginaN WHERE Catalogo = @CatalogoA AND Pagina = @PaginaA
UPDATE CatDBotonExtra SET Catalogo = @CatalogoN, Pagina = @PaginaN WHERE Catalogo = @CatalogoA AND Pagina = @PaginaA
END
END

