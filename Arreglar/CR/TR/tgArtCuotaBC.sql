SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER TRIGGER tgArtCuotaBC ON ArtCuota

FOR UPDATE, DELETE
AS BEGIN
DECLARE
@ArticuloN 		varchar(50),
@ArticuloA 		varchar(50),
@ProveedorN  	varchar(10),
@ProveedorA  	varchar(10),
@FechaDN  		datetime,
@FechaDA  		datetime,
@FechaAN  		datetime,
@FechaAA  		datetime
IF dbo.fnEstaSincronizando() = 1 RETURN
SELECT @ArticuloN = Articulo, @ProveedorN = Proveedor, @FechaDN = FechaD, @FechaAN = FechaA  FROM Inserted
SELECT @ArticuloA = Articulo, @ProveedorA = Proveedor, @FechaDA = FechaD, @FechaAA = FechaA  FROM Deleted
IF @ProveedorN = @ProveedorA AND @ArticuloN = @ArticuloA AND @FechaDN = @FechaDA AND @FechaAN = @FechaAA RETURN
IF @ArticuloN IS NULL
BEGIN
DELETE ArtCuotaDesc
WHERE Articulo = @ArticuloA AND Proveedor = @ProveedorA AND FechaD = @FechaDA AND FechaA = @FechaAA
END ELSE
BEGIN
UPDATE ArtCuotaDesc
SET Articulo = @ArticuloN,
Proveedor = @ProveedorN,
FechaD = @FechaDN,
FechaA = @FechaAN
WHERE Articulo = @ArticuloA AND Proveedor = @ProveedorA AND FechaD = @FechaDA AND FechaA = @FechaAA
END
END

