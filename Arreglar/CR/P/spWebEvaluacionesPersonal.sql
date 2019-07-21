SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spWebEvaluacionesPersonal
@Personal            Varchar(20)
AS BEGIN
SELECT Evaluacion.Evaluacion,
PromedioEval = ROUND(EvaluacionCalificacion.Calificacion, 2),
EvaluacionCalificacion.Fecha
FROM Evaluacion
JOIN EvaluacionCalificacion ON Evaluacion.Evaluacion=EvaluacionCalificacion.Evaluacion
WHERE Evaluacion.Aplica = 'Personal'
AND EvaluacionCalificacion.Contacto = @Personal
ORDER BY EvaluacionCalificacion.Fecha DESC
RETURN
END

