SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER TRIGGER tgEvaluacionBC ON Evaluacion

FOR UPDATE, DELETE
AS BEGIN
DECLARE
@EvaluacionN	varchar(50),
@EvaluacionA	varchar(50)
IF dbo.fnEstaSincronizando() = 1 RETURN
SELECT @EvaluacionN = Evaluacion FROM Inserted
SELECT @EvaluacionA = Evaluacion FROM Deleted
IF @EvaluacionN = @EvaluacionA RETURN
IF @EvaluacionN IS NULL
BEGIN
DELETE EvaluacionFormato     WHERE Evaluacion = @EvaluacionA
DELETE EvaluacionCto         WHERE Evaluacion = @EvaluacionA
DELETE EvaluacionCtoHist     WHERE Evaluacion = @EvaluacionA
DELETE EvaluacionComentarios WHERE Evaluacion = @EvaluacionA
END ELSE
BEGIN
UPDATE EvaluacionFormato     SET Evaluacion = @EvaluacionN WHERE Evaluacion = @EvaluacionA
UPDATE EvaluacionCto         SET Evaluacion = @EvaluacionN WHERE Evaluacion = @EvaluacionA
UPDATE EvaluacionCtoHist     SET Evaluacion = @EvaluacionN WHERE Evaluacion = @EvaluacionA
UPDATE EvaluacionComentarios SET Evaluacion = @EvaluacionN WHERE Evaluacion = @EvaluacionA
END
END

