SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spSeriesLotesSurtidoAuto
@Sucursal			int,
@Empresa			char(5),
@Modulo                      char(5),
@EsSalida			bit,
@EsTransferencia		bit,
@ID  			int,
@RenglonID			int,
@Almacen			char(10),
@Articulo                    char(20),
@SubCuenta			varchar(50),
@CantidadMovimiento 		float,
@Factor			float,
@AlmacenTipo			char(20),
@CfgSeriesLotesAutoOrden	char(20),
@Ok 				int		OUTPUT,
@OkRef 			varchar(255)	OUTPUT,
@Temp			bit = 0,
@Tarima			varchar(20)	= NULL

AS BEGIN
DECLARE
@SubCuentaNull		varchar(50),
@SerieLote			varchar(50),
@CantidadTomada		float,
@Requiere	        float,
@Existencia 		float,
@Mov				varchar(20),
@MovTipo			varchar(20),
@CantidadSL         float,
@CantidadMov        float
IF @Modulo = 'VTAS' SELECT @Mov = Mov FROM Venta WHERE ID = @ID
SELECT @MovTipo = dbo.fnMovTipo(@Modulo, @Mov)
IF @Modulo = 'INV' SELECT @Mov = Mov FROM Inv WHERE ID = @ID
SELECT @MovTipo = dbo.fnMovTipo(@Modulo, @Mov)
SELECT @SubCuenta       = ISNULL(RTRIM(@SubCuenta), ''),
@SubCuentaNull   = NULLIF(RTRIM(@SubCuenta), ''),
@Tarima	  = ISNULL(dbo.fnAlmacenTarima(@Almacen, @Tarima), ''),
@Existencia      = 0.0
IF @EsSalida = 1 OR @EsTransferencia = 1 AND @CfgSeriesLotesAutoOrden <> 'NO'
IF @Temp = 1 OR NOT EXISTS (SELECT * FROM SerieLoteMov WHERE Empresa = @Empresa AND Modulo = @Modulo AND ID = @ID AND RenglonID = @RenglonID AND Articulo  = @Articulo AND SubCuenta = @SubCuenta)
BEGIN
IF @AlmacenTipo = 'ACTIVOS FIJOS'
BEGIN
IF @CfgSeriesLotesAutoOrden = 'FECHA 1'
DECLARE crSerieLoteMovAuto CURSOR FOR SELECT s.SerieLote, ISNULL(s.ExistenciaActivoFijo, 0.0) FROM SerieLote s LEFT OUTER JOIN SerieLoteProp p ON p.Propiedades = s.Propiedades WHERE s.Empresa = @Empresa AND s.Articulo = @Articulo AND s.SubCuenta = @SubCuenta AND s.Almacen = @Almacen AND s.Tarima = @Tarima AND s.ExistenciaActivoFijo > 0 ORDER BY p.Fecha1, s.SerieLote
ELSE IF @CfgSeriesLotesAutoOrden = 'DESCENDENTE'
DECLARE crSerieLoteMovAuto CURSOR FOR SELECT SerieLote, ISNULL(ExistenciaActivoFijo, 0.0) FROM SerieLote WHERE Empresa = @Empresa AND Articulo = @Articulo AND SubCuenta = @SubCuenta AND Almacen = @Almacen AND Tarima = @Tarima AND ExistenciaActivoFijo > 0 ORDER BY SerieLote DESC
ELSE
DECLARE crSerieLoteMovAuto CURSOR FOR SELECT SerieLote, ISNULL(ExistenciaActivoFijo, 0.0) FROM SerieLote WHERE Empresa = @Empresa AND Articulo = @Articulo AND SubCuenta = @SubCuenta AND Almacen = @Almacen AND Tarima = @Tarima AND ExistenciaActivoFijo > 0 ORDER BY SerieLote
END ELSE
BEGIN
IF @CfgSeriesLotesAutoOrden = 'FECHA 1'
DECLARE crSerieLoteMovAuto CURSOR FOR SELECT s.SerieLote, ISNULL(s.Existencia, 0.0) FROM SerieLote s LEFT OUTER JOIN SerieLoteProp p ON p.Propiedades = s.Propiedades WHERE s.Empresa = @Empresa AND s.Articulo = @Articulo AND s.SubCuenta = @SubCuenta AND s.Almacen = @Almacen AND s.Tarima = @Tarima AND s.Existencia > 0 ORDER BY p.Fecha1, s.SerieLote
ELSE IF @CfgSeriesLotesAutoOrden = 'DESCENDENTE'
DECLARE crSerieLoteMovAuto CURSOR FOR SELECT SerieLote, ISNULL(Existencia, 0.0) FROM SerieLote WHERE Empresa = @Empresa AND Articulo = @Articulo AND SubCuenta = @SubCuenta AND Almacen = @Almacen AND Tarima = @Tarima AND Existencia > 0 ORDER BY SerieLote DESC
ELSE
DECLARE crSerieLoteMovAuto CURSOR FOR SELECT SerieLote, ISNULL(Existencia, 0.0) FROM SerieLote WHERE Empresa = @Empresa AND Articulo = @Articulo AND SubCuenta = @SubCuenta AND Almacen = @Almacen AND Tarima = @Tarima AND Existencia > 0 ORDER BY SerieLote
END
SELECT @Requiere = @CantidadMovimiento * @Factor
OPEN crSerieLoteMovAuto
FETCH NEXT FROM crSerieLoteMovAuto INTO @SerieLote, @Existencia
IF @@ERROR <> 0 SELECT @Ok = 1
WHILE @@FETCH_STATUS <> -1 AND @Requiere > 0 AND @Ok IS NULL
BEGIN
IF @@FETCH_STATUS <> -2 AND @Existencia > 0
BEGIN
IF @Existencia > @Requiere SELECT @CantidadTomada = @Requiere ELSE SELECT @CantidadTomada = @Existencia
IF @Temp = 1
INSERT #SerieLoteMov (Sucursal, Empresa, Modulo, ID, RenglonID, Articulo, SubCuenta, SerieLote, Cantidad)
VALUES (@Sucursal, @Empresa, @Modulo, @ID, @RenglonID, @Articulo, @SubCuenta, @SerieLote, @CantidadTomada/* /@Factor*/)
ELSE
INSERT SerieLoteMov (Sucursal, Empresa, Modulo, ID, RenglonID, Articulo, SubCuenta, SerieLote, Cantidad)
VALUES (@Sucursal, @Empresa, @Modulo, @ID, @RenglonID, @Articulo, @SubCuenta, @SerieLote, @CantidadTomada/* /@Factor*/)
SELECT @Requiere = @Requiere - @CantidadTomada
END
FETCH NEXT FROM crSerieLoteMovAuto INTO @SerieLote, @Existencia
IF @@ERROR <> 0 SELECT @Ok = 1
END
CLOSE crSerieLoteMovAuto
DEALLOCATE crSerieLoteMovAuto
END
IF @MovTipo IN ('VTAS.N','VTAS.FM') AND (SELECT NotasBorrador FROM EmpresaCFG WHERE Empresa = @Empresa) = 1
AND NOT EXISTS (SELECT * FROM SerieLoteMov WHERE Empresa = @Empresa AND Modulo = @Modulo AND ID = @ID AND RenglonID = @RenglonID AND Articulo  = @Articulo AND SubCuenta = @SubCuenta)
SELECT @Ok = 20320
IF @Modulo = 'INV' AND @MovTipo IN ('INV.SI','INV.T')
BEGIN
SELECT @CantidadSL = SUM(Cantidad)
FROM SerieLoteMov
WHERE Modulo = @Modulo
AND ID = @ID
AND RenglonID = @RenglonID
AND Articulo = @Articulo
SELECT @CantidadMov = SUM(ISNULL(Cantidad,0)*ISNULL(Factor,1))
FROM InvD
WHERE ID = @ID
AND RenglonID = @RenglonID
AND Articulo = @Articulo
IF @CantidadSL <> @CantidadMov
SELECT @Ok = 20330, @OkRef = @Articulo + '. ' + ISNULL(@SubCuenta,'')
IF @MovTipo IN ('INV.T')
BEGIN
IF EXISTS(SELECT * FROM Art WHERE Articulo = @Articulo AND Tipo IN ('Serie','Lote'))
IF NOT EXISTS(SELECT * FROM SerieLoteMov WHERE Empresa = @Empresa AND @Modulo = @Modulo AND ID = @ID AND RenglonID = @RenglonID AND Articulo = @Articulo AND ISNULL(SubCuenta,'') = ISNULL(@SubCuenta,''))
BEGIN
SELECT @Ok = 20320, @OkRef = 'No Existen Números de Serie/Lote para el Artículo: '+@Articulo
END
END
END
RETURN
END

