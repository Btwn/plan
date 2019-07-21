SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER TRIGGER tgCampanaTipoSituacionBC ON CampanaTipoSituacion

FOR UPDATE, DELETE
AS BEGIN
DECLARE
@CampanaTipoN 	varchar(50),
@CampanaTipoA	varchar(50),
@SituacionN		varchar(50),
@SituacionA		varchar(50)
IF dbo.fnEstaSincronizando() = 1 RETURN
SELECT @CampanaTipoN = CampanaTipo, @SituacionN = Situacion FROM Inserted
SELECT @CampanaTipoA = CampanaTipo, @SituacionA = Situacion FROM Deleted
IF @SituacionN = @SituacionA RETURN
IF @SituacionN IS NULL
BEGIN
DELETE CampanaTipoSituacionTarea WHERE CampanaTipo = @CampanaTipoA AND Situacion = @SituacionA
END ELSE
IF @CampanaTipoA IS NOT NULL
BEGIN
UPDATE CampanaTipoSituacionTarea SET Situacion = @SituacionN WHERE CampanaTipo = @CampanaTipoA AND Situacion = @SituacionA
END
END

