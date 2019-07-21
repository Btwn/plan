SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spPOSSeriesLotesAutoOrden
@ID							varchar(36),
@Sucursal					int,
@Empresa					varchar(5),
@IDNuevo					int,
@CfgSeriesLotesAutoOrden	varchar(20)

AS
BEGIN
DECLARE
@Articulo		varchar(20),
@SubCuenta		varchar(50),
@Cantidad		float,
@RenglonID		int,
@Almacen		varchar(10),
@Ok				int,
@OkRef			varchar(255)
SELECT @Ok = NULL, @OkRef = NULL
SELECT @Almacen = RTRIM(Almacen)
FROM POSL WITH (NOLOCK)
WHERE ID = @ID
DECLARE crST1 CURSOR LOCAL FOR
SELECT Articulo, NULLIF(SubCuenta,''), RenglonID, COUNT (1)
FROM POSLSerieLote
WHERE ID = @ID
GROUP BY Articulo, NULLIF(SubCuenta,''), RenglonID
OPEN crST1
FETCH NEXT FROM crST1 INTO @Articulo, @SubCuenta, @RenglonID, @Cantidad
WHILE @@FETCH_STATUS <> -1  AND @Ok IS NULL
BEGIN
IF @@FETCH_STATUS <> -2
BEGIN
EXEC spPOSSeriesLotesSurtidoAuto @Sucursal, @Empresa, 'VTAS', 1, 0, @IDNuevo, @RenglonID, @Almacen, @Articulo,
@SubCuenta, @Cantidad, 1, @CfgSeriesLotesAutoOrden, @Ok OUTPUT, @OkRef OUTPUT
END
FETCH NEXT FROM crST1 INTO @Articulo, @SubCuenta, @RenglonID, @Cantidad
END
CLOSE crST1
DEALLOCATE crST1
IF @Ok IS NOT NULL
BEGIN
DELETE FROM SerieLoteMov WHERE ID = @IDNuevo
INSERT SerieLoteMov (
Empresa, Modulo, ID, RenglonID, Articulo, SubCuenta, SerieLote, Cantidad, Sucursal)
SELECT
@Empresa, 'VTAS', @IDNuevo, pls.RenglonID, pls.Articulo, ISNULL(pls.SubCuenta,''), pls.SerieLote, COUNT(*), @Sucursal
FROM POSLSerieLote pls
WHERE pls.ID = @ID
GROUP BY Articulo, ISNULL(SubCuenta,''), SerieLote, RenglonID
END
END

