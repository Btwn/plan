SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER TRIGGER tgListaBC ON Lista

FOR UPDATE, DELETE
AS BEGIN
DECLARE
@ClaveNueva  	varchar(50),
@ClaveAnterior	varchar(50),
@VisibleNuevo	varchar(10),
@VisibleAnterior	varchar(10)
IF dbo.fnEstaSincronizando() = 1 RETURN
SELECT @ClaveNueva    = Lista, @VisibleNuevo    = Visible FROM Inserted
SELECT @ClaveAnterior = Lista, @VisibleAnterior = Visible FROM Deleted
IF @ClaveNueva = @ClaveAnterior AND @VisibleNuevo = @VisibleAnterior RETURN
IF @ClaveNueva IS NULL
DELETE ListaD WHERE Lista = @ClaveAnterior AND Visible = @VisibleAnterior
ELSE
UPDATE ListaD SET Lista = @ClaveNueva, Visible = @VisibleNuevo WHERE Lista = @ClaveAnterior AND Visible = @VisibleAnterior
END

