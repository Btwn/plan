SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER TRIGGER tgCtaABC ON Cta

FOR INSERT, UPDATE, DELETE
AS BEGIN
DECLARE
@ClaveNueva  	varchar(20),
@RamaNueva		varchar(20),
@ClaveAnterior	varchar(20),
@Mensaje 		varchar(255)
IF dbo.fnEstaSincronizando() = 1 RETURN
SELECT @ClaveNueva    = Cuenta, @RamaNueva = NULLIF(RTRIM(Rama), '') FROM Inserted
SELECT @ClaveAnterior = Cuenta FROM Deleted
IF @ClaveNueva = @ClaveAnterior RETURN
IF @ClaveNueva IS NULL
BEGIN
IF EXISTS (SELECT * FROM Cta WHERE Rama = @ClaveAnterior)
BEGIN
SELECT @Mensaje = '"'+LTRIM(RTRIM(@ClaveAnterior))+ '" ' + Descripcion FROM MensajeLista WHERE Mensaje = 30160
RAISERROR (@Mensaje,16,-1)
END ELSE
BEGIN
DELETE CtaSub      WHERE Cuenta = @ClaveAnterior
DELETE CtaMov      WHERE Cuenta = @ClaveAnterior
DELETE CtaIVA	 WHERE Cuenta = @ClaveAnterior
DELETE Prop        WHERE Cuenta = @ClaveAnterior AND Rama='CONT'
DELETE ListaD      WHERE Cuenta = @ClaveAnterior AND Rama='CONT'
DELETE AnexoCta    WHERE Cuenta = @ClaveAnterior AND Rama='CONT'
DELETE Presupuesto WHERE Cuenta = @ClaveAnterior AND Rama='CONT'
END
END ELSE
BEGIN
IF @ClaveNueva NOT IN ('A', 'X') AND @RamaNueva IS NULL
BEGIN
SELECT @Mensaje = '"'+LTRIM(RTRIM(@ClaveNueva))+ '" ' + Descripcion FROM MensajeLista WHERE Mensaje = 20920
RAISERROR (@Mensaje,16,-1)
END
END
IF @ClaveAnterior IS NOT NULL AND @ClaveNueva IS NOT NULL
BEGIN
UPDATE CtaSub      SET Cuenta = @ClaveNueva WHERE Cuenta = @ClaveAnterior
UPDATE CtaMov      SET Cuenta = @ClaveNueva WHERE Cuenta = @ClaveAnterior
UPDATE CtaIVA      SET Cuenta = @ClaveNueva WHERE Cuenta = @ClaveAnterior
UPDATE Prop        SET Cuenta = @ClaveNueva WHERE Cuenta = @ClaveAnterior AND Rama='CONT'
UPDATE ListaD      SET Cuenta = @ClaveNueva WHERE Cuenta = @ClaveAnterior AND Rama='CONT'
UPDATE AnexoCta    SET Cuenta = @ClaveNueva WHERE Cuenta = @ClaveAnterior AND Rama='CONT'
UPDATE Presupuesto SET Cuenta = @ClaveNueva WHERE Cuenta = @ClaveAnterior AND Rama='CONT'
END
IF @ClaveNueva IS NOT NULL AND UPDATE(Rama)
BEGIN
IF (SELECT Sincro FROM Version) = 1
EXEC sp_executesql N'UPDATE Cta SET Rama = NULL, SincroC = SincroC WHERE Cuenta = @ClaveNueva AND Rama = ""', N'@ClaveNueva varchar(20)', @ClaveNueva = @ClaveNueva
ELSE
UPDATE Cta SET Rama = NULL WHERE Cuenta = @ClaveNueva AND Rama = ''
END
END

