SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROC spOportunidadeMailSeleccionar
@EstacionTrabajo	int,
@Base				varchar(20)

AS
BEGIN
IF @Base = 'Todo'
UPDATE OportunidadeMailEnviar SET Enviar = 1 WHERE EstacionTrabajo = @EstacionTrabajo
IF @Base = 'Nada'
UPDATE OportunidadeMailEnviar SET Enviar = 0 WHERE EstacionTrabajo = @EstacionTrabajo
RETURN
END

