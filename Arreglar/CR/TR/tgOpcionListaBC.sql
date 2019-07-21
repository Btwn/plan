SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER TRIGGER tgOpcionListaBC ON OpcionLista

FOR UPDATE, DELETE
AS BEGIN
DECLARE
@OpcionN 	char(1),
@OpcionA	char(1),
@ListaN	varchar(50),
@ListaA	varchar(50),
@Mensaje	varchar(255)
IF dbo.fnEstaSincronizando() = 1 RETURN
SELECT @OpcionN = Opcion, @ListaN = Lista FROM Inserted
SELECT @OpcionA = Opcion, @ListaA = Lista  FROM Deleted
IF @OpcionN = @OpcionA AND @ListaN = @ListaA RETURN
IF @OpcionN IS NULL
BEGIN
DELETE OpcionListaD    WHERE Opcion = @OpcionA AND Lista = @ListaA
END ELSE
BEGIN
UPDATE OpcionListaD SET Opcion = @OpcionN, Lista = @ListaN WHERE Opcion = @OpcionA AND Lista = @ListaA
END
END

