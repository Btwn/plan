SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER TRIGGER tgListaSubGrupoBC ON ListaSubGrupo

FOR UPDATE, DELETE
AS BEGIN
DECLARE
@RamaA    	varchar(5),
@GrupoN 	varchar(50),
@SubGrupoN 	varchar(50),
@GrupoA	varchar(50),
@SubGrupoA	varchar(50),
@Mensaje	varchar(255)
IF dbo.fnEstaSincronizando() = 1 RETURN
SELECT @GrupoN = Grupo, @SubGrupoN = SubGrupo FROM Inserted
SELECT @GrupoA = Grupo, @SubGrupoA = SubGrupo, @RamaA = Rama FROM Deleted
IF @SubGrupoN = @SubGrupoA RETURN
IF @SubGrupoN IS NULL
BEGIN
DELETE ListaSubSubGrupo    WHERE Grupo = @GrupoA AND SubGrupo = @SubGrupoA AND Rama = @RamaA
DELETE ListaSubSubSubGrupo WHERE Grupo = @GrupoA AND SubGrupo = @SubGrupoA AND Rama = @RamaA
END ELSE
BEGIN
UPDATE ListaSubSubGrupo    SET SubGrupo = @SubGrupoN WHERE Grupo = @GrupoA AND SubGrupo = @SubGrupoA AND Rama = @RamaA
UPDATE ListaSubSubSubGrupo SET SubGrupo = @SubGrupoN WHERE Grupo = @GrupoA AND SubGrupo = @SubGrupoA AND Rama = @RamaA
END
END

