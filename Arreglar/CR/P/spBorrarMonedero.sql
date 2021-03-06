SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spBorrarMonedero
AS
BEGIN
DELETE FROM AuxiliarPMon
DELETE FROM SaldoPMon
DELETE FROM AcumPMon
DELETE FROM MonederoD
DELETE FROM Monedero
DELETE FROM TarjetaMonedero
DELETE FROM SerieTarjetaMovM
DELETE FROM POSSaldoPMon
DELETE FROM POSAuxiliarPMon
DELETE FROM POSTarjetaMonedero
DELETE FROM POSSerieTarjetaMovMTemp
DELETE FROM POSSerieTarjetaMovM
UPDATE MonederoC SET Consecutivo = 0
END

