SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER TRIGGER tgArtJuegoBC ON ArtJuego

FOR UPDATE, DELETE
AS BEGIN
DECLARE
@ArticuloN  varchar(20),
@ArticuloA  varchar(20),
@JuegoN	varchar(10),
@JuegoA	varchar(10)
IF dbo.fnEstaSincronizando() = 1 RETURN
SELECT @ArticuloN = Articulo, @JuegoN = Juego FROM Inserted
SELECT @ArticuloA = Articulo, @JuegoA = Juego FROM Deleted
IF @ArticuloN <> @ArticuloA OR @JuegoN <> @JuegoA
BEGIN
IF @ArticuloN IS NULL
DELETE ArtJuegoD WHERE Articulo = @ArticuloA AND Juego = @JuegoA
ELSE
UPDATE ArtJuegoD SET Articulo = @ArticuloN, Juego = @JuegoN WHERE Articulo = @ArticuloA AND Juego = @JuegoA
END
END

