SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER TRIGGER tgTasaABC ON Tasa

FOR INSERT, UPDATE, DELETE
AS BEGIN
DECLARE
@TasaN  	varchar(50),
@TasaA	varchar(50),
@Porcentaje float,
@Fecha      datetime
IF dbo.fnEstaSincronizando() = 1 RETURN
EXEC spExtraerFecha @Fecha OUTPUT
SELECT @TasaN = Tasa, @Porcentaje = Porcentaje, @Fecha = Fecha FROM Inserted
SELECT @TasaA = Tasa FROM Deleted
IF @TasaN IS NULL
DELETE TasaD WHERE Tasa = @TasaA
ELSE BEGIN
IF @TasaA <> @TasaN UPDATE TasaD SET Tasa = @TasaN WHERE Tasa = @TasaA
UPDATE TasaD SET Porcentaje = @Porcentaje WHERE Tasa = @TasaN AND Fecha = @Fecha
IF @@ROWCOUNT = 0
INSERT TasaD (Tasa, Fecha, Porcentaje) VALUES (@TasaN, @Fecha, @Porcentaje)
END
END

