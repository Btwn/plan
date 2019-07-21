SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER TRIGGER tgCompetenciaBC ON Competencia
FOR UPDATE, DELETE
AS BEGIN
DECLARE
@CompetenciaN  varchar(20),
@CompetenciaA	varchar(20)
IF dbo.fnEstaSincronizando() = 1 RETURN
SELECT @CompetenciaN = Competencia FROM Inserted
SELECT @CompetenciaA = Competencia FROM Deleted
IF @CompetenciaN = @CompetenciaA RETURN
IF @CompetenciaN IS NULL
BEGIN
DELETE CompetenciaResultado WHERE Competencia = @CompetenciaA
END ELSE
IF @CompetenciaA IS NOT NULL
BEGIN
UPDATE CompetenciaResultado SET Competencia = @CompetenciaN WHERE Competencia = @CompetenciaA
END
END

