SET DATEFIRST 7    
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1  
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spCompetenciaFormatoCalificacionEliminar
@Personal	char(10),
@Evalua		char(10),
@Fecha		datetime

AS BEGIN
/*
DELETE CompetenciaFormatoCalificacion
WHERE Personal = @Personal AND EvaluaPersonal = @Evalua AND Fecha = @Fecha*/
RETURN
END

