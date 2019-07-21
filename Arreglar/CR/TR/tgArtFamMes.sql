SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER TRIGGER tgArtFamMes
ON ArtFam

FOR  INSERT, UPDATE, DELETE
AS
BEGIN
DELETE FROM ArtFamMes WHERE Clave = (SELECT ClaveMES FROM DELETED)
INSERT ArtFamMes (Clave, Descripcion, EstatusIntelIMES)
SELECT ClaveMES, Familia, 0
FROM INSERTED
RETURN
END

