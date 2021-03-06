SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER TRIGGER tgArtCatABC
ON ArtCat

FOR  UPDATE, DELETE, INSERT
AS
BEGIN
DELETE FROM TipoArtMES WHERE TipoArticulo IN (SELECT Categoria FROM DELETED)
INSERT TipoArtMES (TipoArticulo, Descripcion, EstatusIntelIMES)
SELECT Categoria, Categoria, 0
FROM INSERTED
END

