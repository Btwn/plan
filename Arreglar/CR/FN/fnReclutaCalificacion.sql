SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER FUNCTION fnReclutaCalificacion (@ID int)
RETURNS float

AS BEGIN
DECLARE
@Resultado	float,
@Puesto	varchar(50)
SELECT @Puesto = Puesto FROM Recluta WHERE ID = @ID
SELECT @Resultado = SUM(d.Valor*(d.Peso/100.0)*(t.Peso/100.0))
FROM ReclutaD d
JOIN Recluta e ON e.ID = d.ID
JOIN Competencia c ON c.Competencia = d.Competencia
JOIN ReclutaCompetenciaTipo t ON t.ID = e.IDOrigen AND t.Tipo = c.Tipo
WHERE d.ID = @ID
RETURN(@Resultado)
END

