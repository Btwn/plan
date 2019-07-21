SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER TRIGGER tg_aroRiesgoBC ON aroRiesgo

FOR UPDATE, DELETE
AS BEGIN
DECLARE
@RiesgoN  	varchar(20),
@RiesgoA	varchar(20)
IF dbo.fnEstaSincronizando() = 1 RETURN
SELECT @RiesgoN = Riesgo FROM Inserted
SELECT @RiesgoA = Riesgo FROM Deleted
IF @RiesgoN = @RiesgoA RETURN
IF @RiesgoN IS NULL
BEGIN
DELETE aroRiesgoArt 		WHERE Riesgo = @RiesgoA
DELETE aroRiesgoFactor 		WHERE Riesgo = @RiesgoA
DELETE aroRiesgoControlInterno 	WHERE Riesgo = @RiesgoA
DELETE aroRiesgoEvaluacion 		WHERE Riesgo = @RiesgoA
END ELSE
IF @RiesgoA IS NOT NULL
BEGIN
UPDATE aroRiesgoArt 		SET Riesgo = @RiesgoN WHERE Riesgo = @RiesgoA
UPDATE aroRiesgoFactor  		SET Riesgo = @RiesgoN WHERE Riesgo = @RiesgoA
UPDATE aroRiesgoControlInterno 	SET Riesgo = @RiesgoN WHERE Riesgo = @RiesgoA
UPDATE aroRiesgoEvaluacion		SET Riesgo = @RiesgoN WHERE Riesgo = @RiesgoA
END
END

