SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE vic_spEliminaAccionPlano
@Plano    varchar(15),
@Renglon  float

AS BEGIN
DECLARE
@Nombre      varchar(15)
SELECT @Nombre = Nombre FROM vic_PlanoAcciones WHERE Plano = @Plano AND Renglon = @Renglon
DELETE FROM vic_planoacciones WHERE Plano = @Plano AND Renglon = @Renglon
DELETE FROM vic_PlanoAccionesDef WHERE Plano = @Plano AND Nombre = @Nombre
RETURN
END

