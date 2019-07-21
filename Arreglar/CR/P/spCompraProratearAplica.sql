SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spCompraProratearAplica
@ID			int,
@BaseProrrateo	char(20),
@BaseImporte		float,
@PorcentajeImpuesto	float,
@AplicaID		int

AS BEGIN
DECLARE
@Sucursal		int,
@Empresa		char(5),
@CfgMultiUnidades	bit,
@Ok			int,
@OkRef		varchar(255),
@Renglon		float,
@RenglonSub		int,
@RenglonID		int,
@RenglonTipo	char(1),
@Articulo		char(20),
@ArtTipo		varchar(20),
@Cantidad		float,
@CantidadF		float,
@CantidadInventario	float,
@CostoArancel	float,
@ArancelTotal	float,
@Costo		float,
@CostoLinea		float,
@DescuentoTipo	char(1),
@DescuentoLinea	float,
@Peso		float,
@PesoLinea		float,
@Volumen		float,
@VolumenLinea	float,
@PesoVolumenLinea	float,
@Arancel		varchar(50),
@ArancelPorcentaje	float,
@Moneda		char(10),
@TipoCambio		float,
@Almacen		char(10),
@AplicaMoneda	char(10),
@AplicaTipoCambio	float,
@AplicaFactor	float,
@ImporteTotal	float,
@CantidadTotal 	float,
@PesoTotal		float,
@VolumenTotal	float,
@PesoVolumenTotal	float,
@NuevoCosto		float,
@NuevoCostoUnitario float,
@CostoTotal		float,
@MovUnidad		varchar(50),
@Mov		char(20),
@MovID		varchar(20),
@AplicaMov		char(20),
@AplicaMovID	varchar(20),
@RedondeoMonetarios	int,
@MovTipo		varchar(20),
@Codigo		varchar(30),
@SubCuenta		varchar(50),
@AlmacenSucursal	int,
@Factor		float,
@Existencia		float
SELECT @RedondeoMonetarios = RedondeoMonetarios FROM Version
SELECT @Ok = NULL, @OkRef = NULL, @BaseProrrateo = UPPER(@BaseProrrateo)
SELECT @Mov = Mov, @MovID = MovID, @Sucursal = Sucursal FROM Compra WHERE ID = @ID
SELECT @AplicaMov = Mov, @AplicaMovID = MovID, @Empresa = Empresa, @AplicaMoneda = Moneda, @ImporteTotal = ISNULL(Importe, 0.0)
FROM Compra
WHERE ID = @AplicaID
SELECT @MovTipo = Clave FROM MovTipo WHERE Modulo = 'COMS' AND Mov = @Mov
SELECT @CfgMultiUnidades = MultiUnidades FROM EmpresaCfg2 WHERE Empresa = @Empresa
IF @BaseProrrateo = 'CANTIDAD'
SELECT @CantidadTotal = SUM(Cantidad*Factor) FROM CompraD WHERE ID = @AplicaID
ELSE
IF @BaseProrrateo IN ('PESO/VOLUMEN', 'PESO', 'VOLUMEN')
EXEC spCompraCalcPesoVolumen @Empresa, @AplicaID, @CfgMultiUnidades, @PesoTotal OUTPUT, @VolumenTotal	OUTPUT, @PesoVolumenTotal OUTPUT
ELSE
IF @BaseProrrateo = 'ARANCEL'
SELECT @ArancelTotal = SUM(t.SubTotal*(aa.Porcentaje/100.0)) FROM CompraTCalc t, Art a, ArtArancel aa WHERE t.ID = @AplicaID AND t.Articulo =a.Articulo AND a.Arancel = aa.Arancel
SELECT @CostoTotal = 0.0
SELECT @Moneda = Moneda, @TipoCambio = TipoCambio FROM Compra WHERE ID = @ID
EXEC spMoneda NULL, @Moneda, @TipoCambio, @AplicaMoneda, @AplicaFactor OUTPUT, @AplicaTipoCambio OUTPUT, @Ok OUTPUT
IF @Ok IS NOT NULL SELECT @OkRef = 'Error - Tipo Cambio'
BEGIN TRANSACTION
DELETE CompraD WHERE ID = @ID
DECLARE crAplica CURSOR FOR
SELECT d.Renglon, d.RenglonSub, d.RenglonID, d.RenglonTipo, d.Almacen, d.Codigo, d.Articulo, NULLIF(RTRIM(d.SubCuenta), ''), d.Cantidad, d.Cantidad*d.Factor, d.Unidad, ISNULL(NULLIF(d.Factor, 0.0), 1.0), ISNULL(d.CantidadInventario, d.Cantidad), d.Costo, d.DescuentoTipo, d.DescuentoLinea, a.Peso, a.Volumen, a.Arancel, aa.Porcentaje, a.Tipo
FROM CompraD d
JOIN Art a ON d.Articulo = a.Articulo
LEFT OUTER JOIN ArtArancel aa ON a.Arancel = aa.Arancel
WHERE d.ID = @AplicaID
OPEN crAplica
FETCH NEXT FROM crAplica INTO @Renglon, @RenglonSub, @RenglonID, @RenglonTipo, @Almacen, @Codigo, @Articulo, @SubCuenta, @Cantidad, @CantidadF, @MovUnidad, @Factor, @CantidadInventario, @Costo, @DescuentoTipo, @DescuentoLinea, @Peso, @Volumen, @Arancel, @ArancelPorcentaje, @ArtTipo
WHILE @@FETCH_STATUS <> -1 AND @Ok IS NULL
BEGIN
IF @@FETCH_STATUS <> -2 AND @Cantidad > 0.0 AND @Costo > 0.0 AND @Ok IS NULL
BEGIN
SELECT @AlmacenSucursal = Sucursal FROM Alm WHERE Almacen = @Almacen
SELECT @CostoLinea = @Costo * @Cantidad,
@PesoLinea = @Peso * @CantidadF,
@VolumenLinea = @Volumen * @CantidadF,
@PesoVolumenLinea = @Peso * @Volumen * @CantidadF
SELECT @CostoArancel = @CostoLinea * (@ArancelPorcentaje/100.0)
IF @DescuentoLinea > 0.0
BEGIN
IF @DescuentoTipo <> '$'
SELECT @CostoLinea = @CostoLinea - (@CostoLinea * (@DescuentoLinea/100.0))
ELSE SELECT @CostoLinea = @CostoLinea - (@DescuentoLinea * @Cantidad)
END
SELECT @NuevoCosto = 0.0
IF @BaseProrrateo = 'COSTO'        SELECT @NuevoCosto = (@CostoLinea * @BaseImporte) / @ImporteTotal ELSE
IF @BaseProrrateo = 'CANTIDAD'     SELECT @NuevoCosto = (@CantidadF * @BaseImporte)  / @CantidadTotal ELSE
IF @BaseProrrateo = 'PESO'         SELECT @NuevoCosto = (@PesoLinea * @BaseImporte) / @PesoTotal ELSE
IF @BaseProrrateo = 'VOLUMEN'      SELECT @NuevoCosto = (@VolumenLinea * @BaseImporte) / @VolumenTotal ELSE
IF @BaseProrrateo = 'PESO/VOLUMEN' SELECT @NuevoCosto = (@PesoVolumenLinea * @BaseImporte) / @PesoVolumenTotal ELSE
IF @BaseProrrateo = 'ARANCEL'
BEGIN
SELECT @NuevoCosto = (@CostoArancel * @BaseImporte) / @ArancelTotal
END
IF @NuevoCosto > 0.0
BEGIN
SELECT @NuevoCostoUnitario = @NuevoCosto/@Cantidad
SELECT @CostoTotal = @CostoTotal + ROUND(@NuevoCosto, @RedondeoMonetarios)
IF @MovTipo = 'COMS.GX'
BEGIN
IF UPPER(@ArtTipo) IN ('SERIE', 'LOTE', 'VIN', 'PARTIDA')
BEGIN
SELECT @Existencia = SUM(s.Existencia)
FROM SerieLoteMov m
JOIN SerieLote s ON s.Sucursal = m.Sucursal AND s.Empresa = m.Empresa AND s.Articulo = m.Articulo AND ISNULL(s.SubCuenta, '') = ISNULL(m.SubCuenta, '') AND s.Almacen = @Almacen AND s.SerieLote = m.SerieLote
WHERE m.Empresa = @Empresa AND m.Modulo = 'COMS' AND m.ID = @AplicaID AND m.RenglonID = @RenglonID AND m.Articulo = @Articulo AND ISNULL(m.SubCuenta, '') = ISNULL(@SubCuenta, '')
END ELSE
BEGIN
IF @SubCuenta IS NULL
SELECT @Existencia = ISNULL(SUM(Inventario), 0.0) FROM ArtExistenciaInv WHERE Sucursal = @AlmacenSucursal AND Empresa = @Empresa AND Articulo = @Articulo
ELSE
SELECT @Existencia = ISNULL(SUM(Inventario), 0.0) FROM ArtSubExistenciaInv WHERE Sucursal = @AlmacenSucursal AND Empresa = @Empresa AND Articulo = @Articulo AND SubCuenta = @SubCuenta
END
SELECT @Existencia = ISNULL(@Existencia, 0.0)
IF @Existencia < @CantidadInventario
BEGIN
SELECT @CantidadInventario = @CantidadInventario - @Existencia
INSERT CompraD (
Sucursal,  ID,  Renglon,  RenglonSub,    RenglonID,  RenglonTipo,  Codigo,  Articulo,  SubCuenta,  Almacen,  Cantidad,                    Unidad,     Factor,  CantidadInventario,  Costo,               Impuesto1,           DescuentoTipo, EsEstadistica)
SELECT @Sucursal, @ID, @Renglon, @RenglonSub+1, 0,          @RenglonTipo, @Codigo, @Articulo, @SubCuenta, @Almacen, @CantidadInventario/@Factor, @MovUnidad, @Factor, @CantidadInventario, @NuevoCostoUnitario, @PorcentajeImpuesto, NULL,          1
SELECT @CantidadInventario = @Existencia
END
END
IF @CantidadInventario > 0.0
BEGIN
INSERT CompraD (
Sucursal,  ID,  Renglon,  RenglonSub,  RenglonID,  RenglonTipo,  Codigo,  Articulo,  SubCuenta,  Almacen,  Cantidad,                    Unidad,     Factor,  CantidadInventario,  Costo,               Impuesto1,           DescuentoTipo)
SELECT @Sucursal, @ID, @Renglon, @RenglonSub, @RenglonID, @RenglonTipo, @Codigo, @Articulo, @SubCuenta, @Almacen, @CantidadInventario/@Factor, @MovUnidad, @Factor, @CantidadInventario, @NuevoCostoUnitario, @PorcentajeImpuesto, NULL
IF UPPER(@ArtTipo) IN ('SERIE', 'LOTE', 'VIN', 'PARTIDA')
BEGIN
DELETE SerieLoteMov WHERE Empresa = @Empresa AND Modulo = 'COMS' AND ID = @ID AND RenglonID = @RenglonID AND Articulo = @Articulo AND ISNULL(SubCuenta, '') = ISNULL(@SubCuenta, '')
INSERT SerieLoteMov (Empresa, Sucursal, Modulo, ID, RenglonID, Articulo, SubCuenta,    SerieLote, Cantidad)
SELECT @Empresa, @Sucursal, 'COMS', @ID, @RenglonID, @Articulo, ISNULL(@SubCuenta, ''), s.SerieLote, s.Existencia
FROM SerieLoteMov m
JOIN SerieLote s ON s.Sucursal = m.Sucursal AND s.Empresa = m.Empresa AND s.Articulo = m.Articulo AND ISNULL(s.SubCuenta, '') = ISNULL(m.SubCuenta, '') AND s.Almacen = @Almacen AND s.SerieLote = m.SerieLote AND ISNULL(s.Existencia, 0.0) > 0.0
WHERE m.Empresa = @Empresa AND m.Modulo = 'COMS' AND m.ID = @AplicaID AND m.RenglonID = @RenglonID AND m.Articulo = @Articulo AND ISNULL(m.SubCuenta, '') = ISNULL(@SubCuenta, '')
END
END
END
END
FETCH NEXT FROM crAplica INTO @Renglon, @RenglonSub, @RenglonID, @RenglonTipo, @Almacen, @Codigo, @Articulo, @SubCuenta, @Cantidad, @CantidadF, @MovUnidad, @Factor, @CantidadInventario, @Costo, @DescuentoTipo, @DescuentoLinea, @Peso, @Volumen, @Arancel, @ArancelPorcentaje, @ArtTipo
END
IF @BaseImporte <> @CostoTotal
UPDATE CompraD SET Costo = Costo + (@BaseImporte - @CostoTotal) / (Cantidad*Factor) WHERE ID = @ID AND Renglon = @Renglon
CLOSE crAplica
DEALLOCATE crAplica
UPDATE Compra SET RenglonID = @RenglonID + 1, ProrrateoAplicaID = @AplicaID WHERE ID = @ID
EXEC spMovFlujo @Sucursal, 'AFECTAR', @Empresa, 'COMS', @ID, @Mov, @MovID, 'COMS', @AplicaID, @AplicaMov, @AplicaMovID, @Ok OUTPUT
IF @Ok IS NULL
BEGIN
COMMIT TRANSACTION
SELECT "Prorrateo Concluido"
END ELSE
BEGIN
ROLLBACK TRANSACTION
SELECT @OkRef
END
RETURN
END

