SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER TRIGGER tgCatBC ON Cat

FOR UPDATE, DELETE
AS BEGIN
DECLARE
@CatalogoN  varchar(50),
@CatalogoA    varchar(50)
IF dbo.fnEstaSincronizando() = 1 RETURN
SELECT @CatalogoN  = Catalogo FROM Inserted
SELECT @CatalogoA  = Catalogo FROM Deleted
IF @CatalogoA = @CatalogoN RETURN
IF @CatalogoN IS NULL
BEGIN
DELETE CatD           WHERE Catalogo = @CatalogoA
DELETE CatDBoton      WHERE Catalogo = @CatalogoA
DELETE CatDBotonExtra WHERE Catalogo = @CatalogoA
END ELSE
BEGIN
UPDATE CatD           SET Catalogo = @CatalogoN WHERE Catalogo = @CatalogoA
UPDATE CatDBoton      SET Catalogo = @CatalogoN WHERE Catalogo = @CatalogoA
UPDATE CatDBotonExtra SET Catalogo = @CatalogoN WHERE Catalogo = @CatalogoA
END
END

