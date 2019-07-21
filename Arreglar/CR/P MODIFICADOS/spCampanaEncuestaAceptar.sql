SET DATEFIRST 7    
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1  
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spCampanaEncuestaAceptar
@ID		int,
@RID		int,
@Calificacion	float		= NULL	OUTPUT,
@Situacion	varchar(50)	= NULL	OUTPUT

AS BEGIN
DECLARE
@CampanaTipo	varchar(50),
@CalificacionMax	float,
@CalificaSituacion	varchar(50)
SELECT @CampanaTipo = CampanaTipo
FROM Campana WITH (NOLOCK)
WHERE ID = @ID
UPDATE CampanaEncuesta WITH (ROWLOCK)
SET Calificacion = tabla.Valor
FROM CampanaEncuesta e
JOIN CampanaTipoEncuesta tipo WITH (NOLOCK) ON tipo.CampanaTipo = @CampanaTipo AND tipo.Campo = e.Campo
JOIN TablaEvaluacionD tabla WITH (NOLOCK) ON tabla.TablaEvaluacion = tipo.TablaEvaluacion AND tabla.nombre = e.Respuesta
WHERE e.ID = @ID AND e.RID = @RID
EXEC spCampanaEncuestaCalificacion @ID, @RID, @Calificacion OUTPUT
SELECT @Situacion = Situacion FROM CampanaD WITH (NOLOCK) WHERE ID = @ID AND RID = @RID
SELECT @CalificacionMax = MAX(Calificacion)
FROM CampanaTipoCalificacion WITH (NOLOCK)
WHERE CampanaTipo = @CampanaTipo AND @Calificacion>=Calificacion
SELECT @CalificaSituacion = NULL
SELECT @CalificaSituacion = NULLIF(RTRIM(Situacion), '')
FROM CampanaTipoCalificacion WITH (NOLOCK)
WHERE CampanaTipo = @CampanaTipo AND Calificacion = @CalificacionMax
IF @CalificacionMax IS NOT NULL AND @CalificaSituacion IS NOT NULL AND @CalificaSituacion <> @Situacion
BEGIN
SELECT @Situacion = @CalificaSituacion
INSERT CampanaEvento (ID, RID, Tipo, Situacion) VALUES (@ID, @RID, 'Encuesta', @Situacion)
UPDATE CampanaD WITH (ROWLOCK) SET Situacion = @CalificaSituacion
WHERE ID = @ID AND RID = @RID
END
RETURN
END

