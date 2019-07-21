SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER TRIGGER tgListaSubSubGrupoBC ON ListaSubSubGrupo

FOR UPDATE, DELETE
AS BEGIN
DECLARE
@RamaA    		varchar(5),
@GrupoN 		varchar(50),
@SubGrupoN 		varchar(50),
@SubSubGrupoN 	varchar(50),
@GrupoA		varchar(50),
@SubGrupoA		varchar(50),
@SubSubGrupoA	varchar(50),
@Mensaje		varchar(255)
IF dbo.fnEstaSincronizando() = 1 RETURN
SELECT @GrupoN = Grupo, @SubGrupoN = SubGrupo, @SubSubGrupoN = SubSubGrupo FROM Inserted
SELECT @GrupoA = Grupo, @SubGrupoA = SubGrupo, @SubSubGrupoA = SubSubGrupo, @RamaA = Rama FROM Deleted
IF @SubSubGrupoN = @SubSubGrupoA RETURN
IF @SubSubGrupoN IS NULL
BEGIN
DELETE ListaSubSubSubGrupo WHERE Grupo = @GrupoA AND SubGrupo = @SubGrupoA AND SubSubGrupo = @SubSubGrupoA AND Rama = @RamaA
END ELSE
BEGIN
UPDATE ListaSubSubSubGrupo SET SubGrupo = @SubGrupoN WHERE Grupo = @GrupoA AND SubGrupo = @SubGrupoA AND SubSubGrupo = @SubSubGrupoA AND Rama = @RamaA
END
END

