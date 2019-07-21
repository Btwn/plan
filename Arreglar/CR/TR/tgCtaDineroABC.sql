SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER TRIGGER tgCtaDineroABC ON CtaDinero

FOR INSERT, UPDATE, DELETE
AS BEGIN
IF UPDATE(Descripcion) OR UPDATE(Tipo) OR UPDATE(NumeroCta) OR UPDATE(CuentaHabiente) OR UPDATE(Moneda) OR UPDATE(Estatus) OR UPDATE(Sucursal)
INSERT CtaDineroHist (CtaDinero, Fecha, Descripcion, Tipo, NumeroCta, CuentaHabiente, Moneda, Estatus, Sucursal)
SELECT CtaDinero, GETDATE(), Descripcion, Tipo, NumeroCta, CuentaHabiente, Moneda, Estatus, Sucursal
FROM Inserted
DECLARE
@ClaveNueva  	varchar(10),
@ClaveAnterior	varchar(10),
@Mensaje 		varchar(255)
IF dbo.fnEstaSincronizando() = 1 RETURN
SELECT @ClaveNueva    = CtaDinero FROM Inserted
SELECT @ClaveAnterior = CtaDinero FROM Deleted
IF @ClaveNueva=@ClaveAnterior RETURN
IF @ClaveNueva IS NULL
BEGIN
DELETE CtaDineroAcceso WHERE CtaDinero = @ClaveAnterior
DELETE CtaDineroHist   WHERE CtaDinero = @ClaveAnterior
DELETE Prop            WHERE Cuenta    = @ClaveAnterior AND Rama = 'DIN'
DELETE ListaD          WHERE Cuenta    = @ClaveAnterior AND Rama = 'DIN'
DELETE AnexoCta        WHERE Cuenta    = @ClaveAnterior AND Rama = 'DIN'
END ELSE
IF @ClaveNueva <> @ClaveAnterior AND @ClaveAnterior IS NOT NULL
BEGIN
UPDATE CtaDineroAcceso SET CtaDinero = @ClaveNueva WHERE CtaDinero = @ClaveAnterior
UPDATE CtaDineroHist   SET CtaDinero = @ClaveNueva WHERE CtaDinero = @ClaveAnterior
UPDATE Prop            SET Cuenta    = @ClaveNueva WHERE Cuenta    = @ClaveAnterior AND Rama='DIN'
UPDATE ListaD          SET Cuenta    = @ClaveNueva WHERE Cuenta    = @ClaveAnterior AND Rama='DIN'
UPDATE AnexoCta        SET Cuenta    = @ClaveNueva WHERE Cuenta    = @ClaveAnterior AND Rama='DIN'
END
END

