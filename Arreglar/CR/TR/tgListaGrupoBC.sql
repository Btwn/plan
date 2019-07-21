SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER TRIGGER tgListaGrupoBC ON ListaGrupo

FOR UPDATE, DELETE
AS BEGIN
DECLARE
@RamaA    	varchar(5),
@GrupoN 	varchar(50),
@GrupoA	varchar(50),
@Mensaje	varchar(255)
IF dbo.fnEstaSincronizando() = 1 RETURN
SELECT @GrupoN = Grupo FROM Inserted
SELECT @GrupoA = Grupo, @RamaA = Rama FROM Deleted
IF @GrupoN = @GrupoA RETURN
IF @GrupoN IS NULL
BEGIN
DELETE ListaSubSubSubGrupo WHERE Grupo = @GrupoA AND Rama = @RamaA
DELETE ListaSubSubGrupo    WHERE Grupo = @GrupoA AND Rama = @RamaA
DELETE ListaSubGrupo       WHERE Grupo = @GrupoA AND Rama = @RamaA
END ELSE
BEGIN
UPDATE ListaSubSubSubGrupo SET Grupo = @GrupoN WHERE Grupo = @GrupoA AND Rama = @RamaA
UPDATE ListaSubSubGrupo    SET Grupo = @GrupoN WHERE Grupo = @GrupoA AND Rama = @RamaA
UPDATE ListaSubGrupo       SET Grupo = @GrupoN WHERE Grupo = @GrupoA AND Rama = @RamaA
END
END

