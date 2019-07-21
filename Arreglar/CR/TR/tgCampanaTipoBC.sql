SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER TRIGGER tgCampanaTipoBC ON CampanaTipo

FOR UPDATE, DELETE
AS BEGIN
DECLARE
@CampanaTipoN 	varchar(50),
@CampanaTipoA	varchar(50)
IF dbo.fnEstaSincronizando() = 1 RETURN
SELECT @CampanaTipoN = CampanaTipo FROM Inserted
SELECT @CampanaTipoA = CampanaTipo FROM Deleted
IF @CampanaTipoN = @CampanaTipoA RETURN
IF @CampanaTipoN IS NULL
BEGIN
DELETE CampanaTipoSituacionTarea WHERE CampanaTipo = @CampanaTipoA
DELETE CampanaTipoSituacion      WHERE CampanaTipo = @CampanaTipoA
DELETE CampanaTipoEncuesta       WHERE CampanaTipo = @CampanaTipoA
DELETE CampanaTipoEncuestaLista  WHERE CampanaTipo = @CampanaTipoA
DELETE CampanaTipoCalificacion   WHERE CampanaTipo = @CampanaTipoA
END ELSE
IF @CampanaTipoA IS NOT NULL
BEGIN
UPDATE CampanaTipoSituacionTarea SET CampanaTipo = @CampanaTipoN WHERE CampanaTipo = @CampanaTipoA
UPDATE CampanaTipoSituacion      SET CampanaTipo = @CampanaTipoN WHERE CampanaTipo = @CampanaTipoA
UPDATE CampanaTipoEncuesta       SET CampanaTipo = @CampanaTipoN WHERE CampanaTipo = @CampanaTipoA
UPDATE CampanaTipoEncuestaLista  SET CampanaTipo = @CampanaTipoN WHERE CampanaTipo = @CampanaTipoA
UPDATE CampanaTipoCalificacion   SET CampanaTipo = @CampanaTipoN WHERE CampanaTipo = @CampanaTipoA
END
END

