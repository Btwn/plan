SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER TRIGGER tgOpcionBC ON Opcion

FOR UPDATE, DELETE
AS BEGIN
DECLARE
@OpcionN 	char(1),
@OpcionA	char(1),
@Mensaje	varchar(255)
IF dbo.fnEstaSincronizando() = 1 RETURN
SELECT @OpcionN = Opcion FROM Inserted
SELECT @OpcionA = Opcion FROM Deleted
IF @OpcionN = @OpcionA RETURN
IF @OpcionN IS NULL
BEGIN
DELETE OpcionD     WHERE Opcion = @OpcionA
DELETE OpcionLista WHERE Opcion = @OpcionA
DELETE ArtOpcion   WHERE Opcion = @OpcionA
DELETE ArtOpcionD  WHERE Opcion = @OpcionA
END ELSE
BEGIN
UPDATE OpcionD     SET Opcion = @OpcionN WHERE Opcion = @OpcionA
UPDATE OpcionLista SET Opcion = @OpcionN WHERE Opcion = @OpcionA
UPDATE ArtOpcion   SET Opcion = @OpcionN WHERE Opcion = @OpcionA
UPDATE ArtOpcionD  SET Opcion = @OpcionN WHERE Opcion = @OpcionA
END
END

