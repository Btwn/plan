SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER TRIGGER tgAlmABC ON Alm

FOR INSERT, UPDATE, DELETE
AS BEGIN
DECLARE
@ClaveNueva  	varchar(10),
@ClaveAnterior	varchar(10),
@Mensaje 		varchar(255)
IF dbo.fnEstaSincronizando() = 1 RETURN
SELECT @ClaveNueva    = Almacen FROM Inserted
SELECT @ClaveAnterior = Almacen FROM Deleted
IF @ClaveNueva=@ClaveAnterior RETURN
IF @ClaveNueva IS NULL
BEGIN
DELETE Prop     WHERE Cuenta  = @ClaveAnterior AND Rama='ALM'
DELETE AnexoCta WHERE Cuenta  = @ClaveAnterior AND Rama='ALM'
DELETE AlmABC   WHERE Almacen = @ClaveAnterior
DELETE AlmPos   WHERE Almacen = @ClaveAnterior
DELETE AlmOrdenEntarimadoMov     WHERE Almacen = @ClaveAnterior
DELETE AlmOrdenAcomodoReciboMov  WHERE Almacen = @ClaveAnterior
DELETE AlmOrdenAcomodoSurtidoMov WHERE Almacen = @ClaveAnterior
DELETE AlmSugerirSurtidoTarima   WHERE Almacen = @ClaveAnterior
END ELSE
IF @ClaveNueva <> @ClaveAnterior AND @ClaveAnterior IS NOT NULL
BEGIN
UPDATE Prop     SET Cuenta  = @ClaveNueva  WHERE Cuenta  = @ClaveAnterior AND Rama='ALM'
UPDATE AnexoCta SET Cuenta  = @ClaveNueva  WHERE Cuenta  = @ClaveAnterior AND Rama='ALM'
UPDATE AlmABC   SET Almacen = @ClaveNueva  WHERE Almacen = @ClaveAnterior
UPDATE AlmPos   SET Almacen = @ClaveNueva  WHERE Almacen = @ClaveAnterior
UPDATE AlmOrdenEntarimadoMov     SET Almacen = @ClaveNueva  WHERE Almacen = @ClaveAnterior
UPDATE AlmOrdenAcomodoReciboMov  SET Almacen = @ClaveNueva  WHERE Almacen = @ClaveAnterior
UPDATE AlmOrdenAcomodoSurtidoMov SET Almacen = @ClaveNueva  WHERE Almacen = @ClaveAnterior
UPDATE AlmSugerirSurtidoTarima   SET Almacen = @ClaveNueva  WHERE Almacen = @ClaveAnterior
END
END

