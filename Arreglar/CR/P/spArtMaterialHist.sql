SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spArtMaterialHist
@Articulo	varchar(20),
@FechaD		datetime,
@FechaA		datetime

AS BEGIN
DECLARE
@ID	int
INSERT ArtMaterialHist (Articulo, FechaD, FechaA) VALUES (@Articulo, @FechaD, @FechaA)
SELECT @ID = SCOPE_IDENTITY()
INSERT ArtMaterialHistD (
ID,  Articulo, OrdenID, SiOpcion, Material, SubCuenta, Cantidad, Unidad, Merma, Desperdicio, Almacen, CentroTipo, CostoAcumulado, Orden, Porcentaje, Volumen)
SELECT @ID, Articulo, OrdenID, SiOpcion, Material, SubCuenta, Cantidad, Unidad, Merma, Desperdicio, Almacen, CentroTipo, CostoAcumulado, Orden, Porcentaje, Volumen
FROM ArtMaterial
WHERE Articulo = @Articulo
RETURN
END

