SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER TRIGGER tgAutoCorridaBC ON AutoCorrida

FOR UPDATE, DELETE
AS BEGIN
DECLARE
@CorridaN 	varchar(20),
@CorridaA	varchar(20)
IF dbo.fnEstaSincronizando() = 1 RETURN
SELECT @CorridaN = Corrida FROM Inserted
SELECT @CorridaA = Corrida FROM Deleted
IF @CorridaN = @CorridaA RETURN
IF @CorridaN IS NULL
BEGIN
DELETE AutoCorridaPlantilla   WHERE Corrida = @CorridaA
DELETE AutoCorridaComision    WHERE Corrida = @CorridaA
DELETE AutoCorridaRol         WHERE Corrida = @CorridaA
DELETE AutoCorridaRolComision WHERE Corrida = @CorridaA
END ELSE
BEGIN
UPDATE AutoCorridaPlantilla   SET Corrida = @CorridaN WHERE Corrida = @CorridaA
UPDATE AutoCorridaComision    SET Corrida = @CorridaN WHERE Corrida = @CorridaA
UPDATE AutoCorridaRol         SET Corrida = @CorridaN WHERE Corrida = @CorridaA
UPDATE AutoCorridaRolComision SET Corrida = @CorridaN WHERE Corrida = @CorridaA
END
END

