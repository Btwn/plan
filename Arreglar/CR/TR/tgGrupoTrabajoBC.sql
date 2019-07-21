SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER TRIGGER tgGrupoTrabajoBC ON GrupoTrabajo

FOR UPDATE, DELETE
AS BEGIN
DECLARE
@GrupoTrabajoN  	varchar(50),
@GrupoTrabajoA	varchar(50)
IF dbo.fnEstaSincronizando() = 1 RETURN
SELECT @GrupoTrabajoN = GrupoTrabajo FROM Inserted
SELECT @GrupoTrabajoA = GrupoTrabajo FROM Deleted
IF @GrupoTrabajoN = @GrupoTrabajoA RETURN
IF @GrupoTrabajoN IS NULL
DELETE GrupoTrabajoD WHERE GrupoTrabajo = @GrupoTrabajoA
ELSE BEGIN
UPDATE GrupoTrabajoD SET GrupoTrabajo = @GrupoTrabajoN WHERE GrupoTrabajo = @GrupoTrabajoA
END
END

