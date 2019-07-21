SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER TRIGGER tgProvCuotaBC ON ProvCuota

FOR UPDATE, DELETE
AS BEGIN
DECLARE
@ProveedorN  	varchar(10),
@ProveedorA  	varchar(10),
@FamiliaN  		varchar(50),
@FamiliaA  		varchar(50),
@FechaDN  		datetime,
@FechaDA  		datetime,
@FechaAN  		datetime,
@FechaAA  		datetime
IF dbo.fnEstaSincronizando() = 1 RETURN
SELECT @ProveedorN = Proveedor, @FamiliaN = Familia, @FechaDN = FechaD, @FechaAN = FechaA  FROM Inserted
SELECT @ProveedorA = Proveedor, @FamiliaA = Familia, @FechaDA = FechaD, @FechaAA = FechaA  FROM Deleted
IF @ProveedorN = @ProveedorA AND @FamiliaN = @FamiliaA AND @FechaDN = @FechaDA AND @FechaAN = @FechaAA RETURN
IF @ProveedorN IS NULL
BEGIN
DELETE ProvCuotaDesc
WHERE Proveedor = @ProveedorA AND Familia = @FamiliaA AND FechaD = @FechaDA AND FechaA = @FechaAA
END ELSE
BEGIN
UPDATE ProvCuotaDesc
SET Proveedor = @ProveedorN,
Familia = @FamiliaN,
FechaD = @FechaDN,
FechaA = @FechaAN
WHERE Proveedor = @ProveedorA AND Familia = @FamiliaA AND FechaD = @FechaDA AND FechaA = @FechaAA
END
END

