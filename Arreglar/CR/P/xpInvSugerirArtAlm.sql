SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE xpInvSugerirArtAlm
@ID		int,
@Empresa	char(5),
@Sucursal	int,
@Almacen	char(10),
@Referencia	varchar(50)
AS BEGIN
DECLARE
@TipoCosteo		varchar(50),
@Articulo		char(20),
@SubCuenta		varchar(50),
@Renglon		float,
@Unidad		varchar(50),
@Cantidad		float,
@CantidadInventario	float,
@Factor		float,
@Decimales		int,
@Costo		money,
@Moneda		char(10),
@TipoCambio		float,
@Proveedor		char(10),
@RenglonID		int
SELECT @TipoCosteo = ISNULL(NULLIF(RTRIM(UPPER(TipoCosteo)), ''), 'PROMEDIO')
FROM EmpresaCfg
WHERE Empresa = @Empresa  SELECT @Moneda = Moneda, @TipoCambio = TipoCambio FROM Inv WHERE ID = @ID
DELETE InvD WHERE ID = @ID
DELETE SerieLoteMov WHERE Empresa = @Empresa AND Modulo = 'INV' AND ID = @ID
SELECT @Renglon = 0.0, @RenglonID = 0
DECLARE crArtAlm CURSOR FOR
SELECT Articulo, SubCuenta
FROM ArtAlm
WHERE Empresa = @Empresa AND Almacen = @Almacen
OPEN crArtAlm
FETCH NEXT FROM crArtAlm INTO @Articulo, @SubCuenta
WHILE @@FETCH_STATUS <> -1
BEGIN
IF @@FETCH_STATUS <> -2
BEGIN
SELECT @Cantidad = NULL, @Costo = NULL
SELECT @Unidad = Unidad, @Proveedor = Proveedor FROM Art WHERE Articulo = @Articulo
/*EXEC xpUnidadFactor @Articulo, @SubCuenta, @Unidad, @Factor OUTPUT, @Decimales OUTPUT
SELECT @CantidadInventario = SUM(Inventario) FROM ArtSubExistenciaInv WHERE Empresa = @Empresa AND Articulo = @Articulo AND SubCuenta = ISNULL(@SubCuenta, '') AND Almacen = @Almacen
SELECT @Cantidad = @CantidadInventario / @Factor*/
/*IF NULLIF(@Cantidad, 0.0) IS NOT NULL
BEGIN
EXEC spVerCosto @Sucursal, @Empresa, @Proveedor, @Articulo, @SubCuenta, @Unidad, @TipoCosteo, @Moneda, @TipoCambio, @Costo OUTPUT, 0*/
SELECT @Renglon = @Renglon + 2048.0, @RenglonID = @RenglonID + 1
INSERT InvD (ID, Sucursal, Renglon, RenglonID, Articulo, SubCuenta, Cantidad, Unidad, CantidadInventario, Almacen, Costo) VALUES (@ID, @Sucursal, @Renglon, @RenglonID, @Articulo, NULLIF(@SubCuenta, ''), @Cantidad, @Unidad, @CantidadInventario, @Almacen, @Costo)
/*END*/
END
FETCH NEXT FROM crArtAlm INTO @Articulo, @SubCuenta
END
CLOSE crArtAlm
DEALLOCATE crArtAlm
UPDATE Inv SET RenglonID = @RenglonID WHERE ID = @ID 
RETURN
END

