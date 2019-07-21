SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER TRIGGER tgAutoMantBC ON AutoMant

FOR UPDATE, DELETE
AS BEGIN
DECLARE
@MantenimientoN 	varchar(50),
@MantenimientoA	varchar(50)
IF dbo.fnEstaSincronizando() = 1 RETURN
SELECT @MantenimientoN = Mantenimiento FROM Inserted
SELECT @MantenimientoA = Mantenimiento FROM Deleted
IF @MantenimientoN = @MantenimientoA RETURN
IF @MantenimientoN IS NULL
BEGIN
DELETE AutoMantServ  WHERE Mantenimiento = @MantenimientoA
DELETE AutoMantServD WHERE Mantenimiento = @MantenimientoA
END ELSE
BEGIN
UPDATE AutoMantServ  SET Mantenimiento = @MantenimientoN WHERE Mantenimiento = @MantenimientoA
UPDATE AutoMantServD SET Mantenimiento = @MantenimientoN WHERE Mantenimiento = @MantenimientoA
END
END

