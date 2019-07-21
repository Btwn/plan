SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER TRIGGER tgSerieLoteMovFinal ON SerieLoteMov

FOR UPDATE
AS BEGIN
IF dbo.fnEstaSincronizando() = 1 RETURN
IF UPDATE(Propiedades)
UPDATE SerieLote
SET Propiedades = i.Propiedades
FROM SerieLote sl, Inserted i
WHERE sl.Empresa = i.Empresa AND sl.Articulo = i.Articulo AND ISNULL(sl.SubCuenta, '') = ISNULL(i.SubCuenta, '') AND sl.SerieLote = i.SerieLote AND ISNULL(sl.Propiedades, '') <> ISNULL(i.Propiedades, '') AND NULLIF(RTRIM(i.Propiedades), '') IS NOT NULL
END

