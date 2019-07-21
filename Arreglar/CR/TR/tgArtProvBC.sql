SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER TRIGGER tgArtProvBC ON ArtProv

FOR INSERT, UPDATE
AS BEGIN
IF dbo.fnEstaSincronizando() = 1 RETURN
IF UPDATE(UltimaCotizacion) OR UPDATE(FechaCotizacion)
INSERT ArtProvHist (Articulo, SubCuenta, Proveedor, Cotizacion,       FechaCotizacion)
SELECT Articulo, SubCuenta, Proveedor, UltimaCotizacion, FechaCotizacion
FROM Inserted
WHERE ISNULL(UltimaCotizacion, 0) <> 0
END

