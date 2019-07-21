SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER VIEW EvaluacionCalificacion

AS
SELECT ec.Evaluacion,
ec.Contacto,
ec.Fecha,
ec.Modulo,
ec.ModuloID,
"Calificacion" = SUM(ec.Calificacion*(ef.Peso/100)),
"Estatus" = (CASE WHEN (SELECT COUNT(*) FROM EvaluacionCto e WITH (NOLOCK) WHERE e.Evaluacion=ec.Evaluacion AND e.Fecha = ec.Fecha AND e.Contacto = ec.Contacto AND Calificacion IS NULL) = 0 AND ISNULL(dbo.fnMovEstatus(ec.Modulo, ec.ModuloID), '') <> 'CANCELADO' THEN 'CONCLUIDO'
WHEN ISNULL(dbo.fnMovEstatus(ec.Modulo, ec.ModuloID), '') = 'CANCELADO' THEN 'CANCELADO'
ELSE  'BORRADOR' END)
FROM EvaluacionFormato ef WITH (NOLOCK)
JOIN EvaluacionCto ec WITH (NOLOCK) ON ef.Evaluacion = ec.Evaluacion AND ef.Punto = ec.Punto
GROUP BY ec.Evaluacion, ec.Contacto, ec.Fecha, ec.Modulo, ec.ModuloID

