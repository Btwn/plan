SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER TRIGGER tgArtSubCostoAC ON ArtSubCosto

FOR INSERT, UPDATE
AS BEGIN
DECLARE
@Fecha		datetime,
@Sucursal		int,
@Empresa		varchar(5),
@Articulo  		varchar(20),
@SubCuenta		varchar(50),
@UltimoCostoN	float,
@UltimoCostoA	float,
@CostoPromedioN	float,
@CostoPromedioA	float
IF dbo.fnEstaSincronizando() = 1 RETURN
SELECT @Fecha = GETDATE()
SELECT @Sucursal = Sucursal, @Empresa = Empresa, @Articulo = Articulo, @SubCuenta = SubCuenta,
@UltimoCostoN = UltimoCosto, @CostoPromedioN = CostoPromedio
FROM Inserted
SELECT @UltimoCostoA = UltimoCosto, @CostoPromedioA = CostoPromedio
FROM Deleted
IF @UltimoCostoN <> @UltimoCostoA OR @CostoPromedioN <> @CostoPromedioA
INSERT ArtSubCostoHist (Sucursal,  Empresa,  Articulo,  SubCuenta, Fecha, UltimoCostoActual, UltimoCostoAnterior, CostoPromedio)
VALUES (@Sucursal, @Empresa, @Articulo, @SubCuenta, @Fecha, @UltimoCostoN, @UltimoCostoA, @CostoPromedioN)
END

