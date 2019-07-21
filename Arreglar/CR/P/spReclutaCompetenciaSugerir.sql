SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spReclutaCompetenciaSugerir
@ID		int

AS BEGIN
DECLARE
@Sucursal		int,
@Personal		varchar(10),
@PersonalEstatus	varchar(15),
@Puesto		varchar(50),
@MovTipo		varchar(20)
SELECT @Sucursal = e.Sucursal, @Personal = e.Personal, @Puesto = e.Puesto,
@MovTipo = mt.Clave
FROM Recluta e
LEFT OUTER JOIN MovTipo mt ON mt.Modulo = 'RE' AND mt.Mov = e.Mov
WHERE e.ID = @ID
DELETE ReclutaD		WHERE ID = @ID
DELETE ReclutaCompetenciaTipo	WHERE ID = @ID
IF @MovTipo = 'RE.SCO'
INSERT ReclutaCompetenciaTipo (
ID,  Sucursal,  Tipo, Peso)
SELECT @ID, @Sucursal, Tipo, Peso
FROM PuestoCompetenciaTipo
WHERE Puesto = @Puesto
IF @MovTipo IN ('RE.SCO', 'RE.AP', 'RE.ECO', 'RE.CO', 'RE.RCO')
INSERT ReclutaD (ID, Renglon, Sucursal, Competencia, Peso, ValorMinimo)
SELECT @ID, ROW_NUMBER() OVER(ORDER BY Competencia)*2048.0, @Sucursal, Competencia, Peso, ValorMinimo
FROM PuestoCompetencia
WHERE Puesto = @Puesto
IF @MovTipo IN ('RE.SEV', 'RE.EV')
INSERT ReclutaD (ID, Renglon, Sucursal, Competencia, Peso, Resultado, Valor, ValorMinimo)
SELECT @ID, ROW_NUMBER() OVER(ORDER BY Competencia)*2048.0, @Sucursal, Competencia, Peso, Resultado, Valor, ValorMinimo
FROM PersonalCompetencia
WHERE Personal = @Personal
END

