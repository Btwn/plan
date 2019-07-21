SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spPOSSeriesLotesSurtidoAuto
@Sucursal					int,
@Empresa					varchar(5),
@Modulo						varchar(5),
@EsSalida					bit,
@EsTransferencia			bit,
@ID  						int,
@RenglonID					int,
@Almacen					varchar(10),
@Articulo					varchar(20),
@SubCuenta					varchar(50),
@CantidadMovimiento			float,
@Factor						float,
@CfgSeriesLotesAutoOrden	varchar(20),
@Ok 						int				OUTPUT,
@OkRef 						varchar(255)	OUTPUT

AS
BEGIN
DECLARE
@SubCuentaNull		varchar(50),
@SerieLote			varchar(50),
@CantidadTomada		float,
@Requiere	        float,
@Existencia 		float,
@Mov				varchar(20),
@MovTipo			varchar(20)
IF @Modulo = 'VTAS' SELECT @Mov = Mov FROM Venta WHERE ID = @ID
SELECT @MovTipo = dbo.fnMovTipo(@Modulo, @Mov)
SELECT @SubCuenta       = ISNULL(RTRIM(@SubCuenta), ''),
@SubCuentaNull   = NULLIF(RTRIM(@SubCuenta), ''),
@Existencia      = 0.0
IF @EsSalida = 1 OR @EsTransferencia = 1 AND @CfgSeriesLotesAutoOrden <> 'NO'
IF NOT EXISTS (SELECT * FROM SerieLoteMov WHERE Empresa = @Empresa AND Modulo = @Modulo AND ID = @ID
AND RenglonID = @RenglonID AND Articulo  = @Articulo AND SubCuenta = @SubCuenta)
BEGIN
IF @CfgSeriesLotesAutoOrden = 'FECHA 1'
DECLARE crSerieLoteMovAuto CURSOR FOR
SELECT s.SerieLote, ISNULL(s.Existencia, 0.0)
FROM SerieLote s LEFT OUTER JOIN SerieLoteProp p ON p.Propiedades = s.Propiedades
WHERE s.Empresa = @Empresa AND s.Articulo = @Articulo AND s.SubCuenta = @SubCuenta
AND s.Almacen = @Almacen AND s.Existencia > 0 ORDER BY p.Fecha1, s.SerieLote
ELSE IF @CfgSeriesLotesAutoOrden = 'DESCENDENTE'
DECLARE crSerieLoteMovAuto CURSOR FOR
SELECT SerieLote, ISNULL(Existencia, 0.0)
FROM SerieLote
WHERE Empresa = @Empresa AND Articulo = @Articulo AND SubCuenta = @SubCuenta
AND Almacen = @Almacen AND Existencia > 0 ORDER BY SerieLote DESC
ELSE
DECLARE crSerieLoteMovAuto CURSOR FOR
SELECT SerieLote, ISNULL(Existencia, 0.0)
FROM SerieLote
WHERE Empresa = @Empresa AND Articulo = @Articulo AND SubCuenta = @SubCuenta
AND Almacen = @Almacen AND Existencia > 0 ORDER BY SerieLote
SELECT @Requiere = @CantidadMovimiento * @Factor
OPEN crSerieLoteMovAuto
FETCH NEXT FROM crSerieLoteMovAuto INTO @SerieLote, @Existencia
IF @@ERROR <> 0
SELECT @Ok = 1
WHILE @@FETCH_STATUS <> -1 AND @Requiere > 0 AND @Ok IS NULL
BEGIN
IF @@FETCH_STATUS <> -2 AND @Existencia > 0
BEGIN
IF @Existencia > @Requiere
SELECT @CantidadTomada = @Requiere
ELSE
SELECT @CantidadTomada = @Existencia
INSERT SerieLoteMov (
Sucursal, Empresa, Modulo, ID, RenglonID, Articulo, SubCuenta, SerieLote, Cantidad)
VALUES (
@Sucursal, @Empresa, @Modulo, @ID, @RenglonID, @Articulo, @SubCuenta, @SerieLote, @CantidadTomada)
SELECT @Requiere = @Requiere - @CantidadTomada
END
FETCH NEXT FROM crSerieLoteMovAuto INTO @SerieLote, @Existencia
IF @@ERROR <> 0
SELECT @Ok = 1
END
CLOSE crSerieLoteMovAuto
DEALLOCATE crSerieLoteMovAuto
END
RETURN
END

