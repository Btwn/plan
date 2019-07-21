SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER TRIGGER tgAnuncioC ON Anuncio

FOR UPDATE, DELETE
AS BEGIN
DECLARE
@AnuncioN	varchar(50),
@AnuncioA	varchar(50)
IF dbo.fnEstaSincronizando() = 1 RETURN
SELECT @AnuncioN = Anuncio FROM Inserted
SELECT @AnuncioA = Anuncio FROM Deleted
IF @AnuncioN = @AnuncioA RETURN
IF @AnuncioN IS NULL
BEGIN
DELETE AnuncioD   WHERE Anuncio = @AnuncioA
DELETE AnuncioArt WHERE Anuncio = @AnuncioA
END ELSE
BEGIN
UPDATE AnuncioD   SET Anuncio =  @AnuncioN WHERE Anuncio = @AnuncioA
UPDATE AnuncioArt SET Anuncio =  @AnuncioN WHERE Anuncio = @AnuncioA
END
END

