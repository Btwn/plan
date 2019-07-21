SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spVerCompetenciaFormatoCalificacion
@Personal	char(10),
@FechaD		datetime,
@FechaA		datetime

AS
BEGIN
/*
DECLARE
@Puesto		char(50),
@Auto		int,
@Externo	int,
@Grupo		int
SELECT @Auto = COUNT(DISTINCT Personal)
FROM CompetenciaFormatoCalificacion
WHERE Personal = @Personal AND Personal = EvaluaPersonal AND Fecha BETWEEN @FechaD AND @FechaA
SELECT @Externo = COUNT(DISTINCT EvaluaPersonal)
FROM CompetenciaFormatoCalificacion
WHERE Personal = @Personal AND Personal <> EvaluaPersonal AND Fecha BETWEEN @FechaD AND @FechaA
SELECT @Grupo = COUNT(DISTINCT EvaluaPersonal)
FROM CompetenciaFormatoCalificacion
WHERE Personal <> @Personal /*AND Personal <> EvaluaPersonal */AND Fecha BETWEEN @FechaD AND @FechaA
SELECT @Puesto = Puesto FROM Personal WHERE Personal = @Personal
SELECT 'Orden' = 1, 'Tipo' = 'AutoEvaluación', f.Clave, c.Competencia, f.Nivel, 'Calificacion' = SUM(p.Calificacion*(f.Peso/100))/@Auto
FROM CompetenciaFormatoCalificacion p, CompetenciaFormato f, Competencia c, PuestoCompetencia t
WHERE p.Punto = f.Punto
AND f.Clave = c.Clave
AND c.Clave = t.Clave AND f.Nivel = t.Nivel
AND p.Personal = @Personal
AND p.Personal = p.EvaluaPersonal
AND p.Fecha BETWEEN @FechaD AND @FechaA
GROUP BY f.Clave, c.Competencia, f.Nivel
UNION
SELECT 'Orden' = 2, 'Tipo' = 'Externo', f.Clave, c.Competencia, f.Nivel, 'Calificacion' = SUM(p.Calificacion*(f.Peso/100))/@Externo
FROM CompetenciaFormatoCalificacion p, CompetenciaFormato f, Competencia c, PuestoCompetencia t
WHERE p.Punto = f.Punto
AND f.Clave = c.Clave
AND c.Clave = t.Clave AND f.Nivel = t.Nivel
AND p.Personal = @Personal
AND p.Personal <> p.EvaluaPersonal
AND p.Fecha BETWEEN @FechaD AND @FechaA
GROUP BY f.Clave, c.Competencia, f.Nivel
UNION
SELECT 'Orden' = 3, 'Tipo' = 'Grupo', f.Clave, c.Competencia, f.Nivel, 'Calificacion' = SUM(p.Calificacion*(f.Peso/100))/@Grupo
FROM CompetenciaFormatoCalificacion p, CompetenciaFormato f, Competencia c, PuestoCompetencia t
WHERE p.Punto = f.Punto
AND f.Clave = c.Clave
AND c.Clave = t.Clave AND f.Nivel = t.Nivel
AND p.Personal <> @Personal
AND p.Fecha BETWEEN @FechaD AND @FechaA
GROUP BY f.Clave, c.Competencia, f.Nivel
UNION
SELECT 'Orden' = 4, 'Tipo' = 'Puesto ' + p.Puesto, p.Clave, c.Competencia, 'Nivel' = ISNULL(p.Nivel,''), p.Grado
FROM PuestoCompetencia p, Competencia c
WHERE p.Clave = c.Clave
AND p.Puesto = @Puesto
ORDER BY Orden, f.Clave, f.Nivel
*/
RETURN
END

