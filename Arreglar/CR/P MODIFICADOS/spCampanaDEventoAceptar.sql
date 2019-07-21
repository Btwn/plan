SET DATEFIRST 7    
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1  
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spCampanaDEventoAceptar
@ID		int,
@RID		int

AS BEGIN
DECLARE
@EventoID		int,
@Calificacion	float,
@Situacion		varchar(50),
@SituacionFecha	datetime,
@Observaciones	varchar(225)
SELECT @EventoID = MAX(EventoID)
FROM CampanaEvento WITH (NOLOCK)
WHERE ID = @ID AND RID = @RID
SELECT @Situacion = Situacion,
@SituacionFecha = SituacionFecha,
@Observaciones = Observaciones
FROM CampanaEvento WITH (NOLOCK)
WHERE ID = @ID AND RID = @RID AND EventoID = @EventoID
EXEC spCampanaEncuestaCalificacion @ID, @RID, @Calificacion OUTPUT
UPDATE CampanaD WITH (ROWLOCK)
SET Situacion = @Situacion,
SituacionFecha = @SituacionFecha,
Observaciones = @Observaciones,
Calificacion = @Calificacion
WHERE ID = @ID AND RID = @RID
RETURN
END

