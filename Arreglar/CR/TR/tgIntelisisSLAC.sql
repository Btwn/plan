SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER TRIGGER tgIntelisisSLAC ON IntelisisSL

FOR INSERT, UPDATE
AS BEGIN
IF dbo.fnEstaSincronizando() = 1 RETURN
INSERT IntelisisSLHist (
Licencia, Nombre, Cliente, Firma, Dominio, Fabricacion, Vencimiento, Mantenimiento, Tipo, Observaciones, Alta, Estatus, UltimoCambio, UsuarioCambio, TieneMovimientos)
SELECT Licencia, Nombre, Cliente, Firma, Dominio, Fabricacion, Vencimiento, Mantenimiento, Tipo, Observaciones, Alta, Estatus, UltimoCambio, UsuarioCambio, TieneMovimientos
FROM Inserted
END

