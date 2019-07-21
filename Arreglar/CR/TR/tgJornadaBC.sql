SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER TRIGGER tgJornadaBC ON Jornada

FOR UPDATE, DELETE
AS BEGIN
DECLARE
@JornadaD  	varchar(50),
@JornadaI	varchar(50)
IF dbo.fnEstaSincronizando() = 1 RETURN
SELECT @JornadaI = Jornada FROM Inserted
SELECT @JornadaD = Jornada FROM Deleted
IF @JornadaI IS NULL
BEGIN
DELETE JornadaD          WHERE Jornada = @JornadaD
DELETE JornadaTiempo     WHERE Jornada = @JornadaD
DELETE JornadaDiaFestivo WHERE Jornada = @JornadaD
END ELSE
BEGIN
UPDATE JornadaD          SET Jornada = @JornadaI WHERE Jornada = @JornadaD
UPDATE JornadaTiempo     SET Jornada = @JornadaI WHERE Jornada = @JornadaD
UPDATE JornadaDiaFestivo SET Jornada = @JornadaI WHERE Jornada = @JornadaD
END
END

