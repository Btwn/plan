SET DATEFIRST 7    
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1  
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER FUNCTION fnOportunidadAvance(
@ID			int
)
RETURNS float
AS
BEGIN
DECLARE @Avance				float,
@PorcentajePonderado	float
DECLARE @Actividades TABLE(
Tipo				varchar(20) COLLATE DATABASE_DEFAULT NULL,
Clave				varchar(50) COLLATE DATABASE_DEFAULT NULL,
PorcentajePonderado	float		NULL,
PorcentajeAvance	float		NULL,
Avance				float		NULL
)
INSERT INTO @Actividades(
Tipo, Clave,   PorcentajePonderado,               PorcentajeAvance)
SELECT d.Tipo, d.Clave, ISNULL(pd.PorcentajePonderado, 0), ISNULL(d.PorcentajeAvance, 0)
FROM OportunidadD d WITH(NOLOCK)
JOIN Oportunidad c WITH(NOLOCK) ON d.ID = c.ID
JOIN OportunidadPlantilla p WITH(NOLOCK) ON p.Plantilla = c.Plantilla
JOIN OportunidadPlantillaD pd WITH(NOLOCK) ON p.ID = pd.ID AND pd.Tipo = d.Tipo AND pd.Clave = d.Clave
WHERE c.ID = @ID
SELECT @PorcentajePonderado = SUM(PorcentajePonderado) FROM @Actividades
SELECT @PorcentajePonderado = 100.0 - ISNULL(@PorcentajePonderado, 0)
UPDATE @Actividades
SET Avance = PorcentajeAvance*(PorcentajePonderado/100.0)
SELECT @Avance = SUM(Avance) + ISNULL(@PorcentajePonderado, 0) FROM @Actividades
RETURN @Avance
END

