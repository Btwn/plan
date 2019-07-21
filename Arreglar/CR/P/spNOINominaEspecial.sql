SET DATEFIRST 7
SET ANSI_NULLS ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET ANSI_WARNINGS ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spNOINominaEspecial
@Estacion      int

AS BEGIN
IF EXISTS (SELECT * FROM NOINominaEspecial WHERE Estacion = @Estacion)
DELETE NOINominaEspecial WHERE Estacion = @Estacion
RETURN
END

