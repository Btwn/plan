SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spCompraProratear
@ID				int,
@BaseProrrateo		char(20),
@BaseImporte		        float,
@GastoMoneda			char(10),
@GastoTipoCambio		float,
@PedimentoEspecifico 	char(20) = NULL,
@MovTipo			varchar(20) = NULL,
@Concepto        varchar(50) = NULL, 
@RenglonID       float = NULL,
@ProrrateoNivel  varchar(20) = NULL

AS BEGIN
DECLARE
@Empresa			char(5),
@CfgMultiUnidades		bit,
@Ok				int,
@OkRef			varchar(255),
@Renglon			float,
@RenglonSub			int,
@Articulo			char(20),
@Cantidad			float,
@CantidadF			float,
@CostoLinea			float,
@Peso			float,
@PesoLinea			float,
@Volumen			float,
@VolumenLinea		float,
@PesoVolumenLinea		float,
@FactorCosto		float,
@Arancel			varchar(50),
@ArancelPorcentaje		float,
@MovMoneda			char(10),
@MovTipoCambio		float,
@ImporteTotal		money,
@CantidadTotal 		float,
@PesoTotal			float,
@VolumenTotal		float,
@PesoVolumenTotal		float,
@CostoArancel		float,
@ArancelTotal		money,
@NuevoCosto			float,
@IncCosto			float,
@MovUnidad			varchar(50),
@ValorAduana        bit,
@SubTotalSD         money,
@NuevoCostoSD       float,
@IncCostoSD         float,
@ImporteTotalSD     money,
@MovMonedaD         char(10),
@MovTipoCambioD     float
SELECT @Ok = NULL, @BaseProrrateo = UPPER(@BaseProrrateo), @ProrrateoNivel = UPPER(NULLIF(@ProrrateoNivel, ''))
EXEC spInvCalcFactor 'COMS', @ID
SELECT @Empresa = Empresa FROM Compra WHERE ID = @ID
SELECT @CfgMultiUnidades = MultiUnidades FROM EmpresaCfg2 WHERE Empresa = @Empresa
SELECT @ValorAduana = ValorAduana FROM Concepto WHERE Modulo = 'COMSG' AND Concepto = @Concepto
IF @PedimentoEspecifico IS NULL
BEGIN
IF @ProrrateoNivel IS NULL
SELECT @ImporteTotal = SUM(SubTotal)
FROM CompraTCalc
WHERE ID = @ID
ELSE IF @ProrrateoNivel = 'PROVEEDOR'
SELECT @ImporteTotal = SUM(SubTotal)
FROM CompraTCalc
WHERE ID = @ID
AND ImportacionProveedor IN (SELECT Proveedor FROM CompraGastoDiversoProv WHERE ID = @ID AND Concepto = @Concepto)
ELSE IF @ProrrateoNivel = 'REFERENCIA'
SELECT @ImporteTotal = SUM(SubTotal)
FROM CompraTCalc
WHERE ID = @ID
AND ImportacionReferencia IN (SELECT Referencia FROM CompraGastoDiversoRef WHERE ID = @ID AND Concepto = @Concepto)
ELSE IF @ProrrateoNivel = 'ARTICULO'
SELECT @ImporteTotal = SUM(SubTotal)
FROM CompraTCalc
WHERE ID = @ID
AND Articulo IN (SELECT Articulo FROM CompraGastoDiversoArt WHERE ID = @ID AND Concepto = @Concepto)
END ELSE
SELECT @ImporteTotal = SUM(d.SubTotal)
FROM CompraTCalc d, SerieLoteMov s
WHERE d.ID = @ID
AND s.Empresa = @Empresa AND s.Modulo = 'COMS' AND s.ID = d.ID AND s.RenglonID = d.RenglonID AND s.Articulo = d.Articulo AND s.SerieLote = @PedimentoEspecifico
IF @PedimentoEspecifico IS NULL
BEGIN
IF @ProrrateoNivel IS NULL
SELECT @ImporteTotalSD = SUM(CantidadNeta * Costo)
FROM CompraTCalc
WHERE ID = @ID
ELSE IF @ProrrateoNivel = 'PROVEEDOR'
SELECT @ImporteTotalSD = SUM(CantidadNeta * Costo)
FROM CompraTCalc
WHERE ID = @ID
AND ImportacionProveedor IN (SELECT Proveedor FROM CompraGastoDiversoProv WHERE ID = @ID AND Concepto = @Concepto)
ELSE IF @ProrrateoNivel = 'REFERENCIA'
SELECT @ImporteTotalSD = SUM(CantidadNeta * Costo)
FROM CompraTCalc
WHERE ID = @ID
AND ImportacionReferencia IN (SELECT Referencia FROM CompraGastoDiversoRef WHERE ID = @ID AND Concepto = @Concepto)
ELSE IF @ProrrateoNivel = 'ARTICULO'
SELECT @ImporteTotalSD = SUM(CantidadNeta * Costo)
FROM CompraTCalc
WHERE ID = @ID
AND Articulo IN (SELECT Articulo FROM CompraGastoDiversoArt WHERE ID = @ID AND Concepto = @Concepto)
END
ELSE
SELECT @ImporteTotalSD = SUM(d.CantidadNeta * d.Costo)
FROM CompraTCalc d, SerieLoteMov s
WHERE d.ID = @ID
AND s.Empresa = @Empresa AND s.Modulo = 'COMS' AND s.ID = d.ID AND s.RenglonID = d.RenglonID AND s.Articulo = d.Articulo AND s.SerieLote = @PedimentoEspecifico
IF @BaseProrrateo = 'CANTIDAD'
BEGIN
IF @PedimentoEspecifico IS NULL
BEGIN
IF @ProrrateoNivel IS NULL
SELECT @CantidadTotal = SUM(Cantidad*Factor)
FROM CompraD
WHERE ID = @ID
ELSE IF @ProrrateoNivel = 'PROVEEDOR'
SELECT @CantidadTotal = SUM(Cantidad*Factor)
FROM CompraD
WHERE ID = @ID
AND ImportacionProveedor IN (SELECT Proveedor FROM CompraGastoDiversoProv WHERE ID = @ID AND Concepto = @Concepto)
ELSE IF @ProrrateoNivel = 'REFERENCIA'
SELECT @CantidadTotal = SUM(Cantidad*Factor)
FROM CompraD
WHERE ID = @ID
AND ImportacionReferencia IN (SELECT Referencia FROM CompraGastoDiversoRef WHERE ID = @ID AND Concepto = @Concepto)
ELSE IF @ProrrateoNivel = 'ARTICULO'
SELECT @CantidadTotal = SUM(Cantidad*Factor)
FROM CompraD
WHERE ID = @ID
AND Articulo IN (SELECT Articulo FROM CompraGastoDiversoArt WHERE ID = @ID AND Concepto = @Concepto)
END
ELSE
SELECT @CantidadTotal = SUM(d.Cantidad*d.Factor)
FROM CompraD d, SerieLoteMov s
WHERE d.ID = @ID
AND s.Empresa = @Empresa AND s.Modulo = 'COMS' AND s.ID = d.ID AND s.RenglonID = d.RenglonID AND s.Articulo = d.Articulo AND s.SerieLote = @PedimentoEspecifico
END
IF @BaseProrrateo = 'ARANCEL'
BEGIN
IF @PedimentoEspecifico IS NULL
BEGIN
IF @ProrrateoNivel IS NULL
SELECT @ArancelTotal = SUM(d.SubTotal*(aa.Porcentaje/100.0))
FROM CompraTCalc d, Art a, ArtArancel aa
WHERE d.ID = @ID AND d.Articulo =a.Articulo AND a.Arancel = aa.Arancel
ELSE IF @ProrrateoNivel = 'PROVEEDOR'
SELECT @ArancelTotal = SUM(d.SubTotal*(aa.Porcentaje/100.0))
FROM CompraTCalc d, Art a, ArtArancel aa
WHERE d.ID = @ID AND d.Articulo =a.Articulo AND a.Arancel = aa.Arancel
AND ImportacionProveedor IN (SELECT Proveedor FROM CompraGastoDiversoProv WHERE ID = @ID AND Concepto = @Concepto)
ELSE IF @ProrrateoNivel = 'REFERENCIA'
SELECT @ArancelTotal = SUM(d.SubTotal*(aa.Porcentaje/100.0))
FROM CompraTCalc d, Art a, ArtArancel aa
WHERE d.ID = @ID AND d.Articulo =a.Articulo AND a.Arancel = aa.Arancel
AND ImportacionReferencia IN (SELECT Referencia FROM CompraGastoDiversoRef WHERE ID = @ID AND Concepto = @Concepto)
ELSE IF @ProrrateoNivel = 'ARTICULO'
SELECT @ArancelTotal = SUM(d.SubTotal*(aa.Porcentaje/100.0))
FROM CompraTCalc d, Art a, ArtArancel aa
WHERE d.ID = @ID AND d.Articulo =a.Articulo AND a.Arancel = aa.Arancel
AND d.Articulo IN (SELECT Articulo FROM CompraGastoDiversoArt WHERE ID = @ID AND Concepto = @Concepto)
END ELSE
SELECT @ArancelTotal = SUM(d.SubTotal*(aa.Porcentaje/100.0))
FROM CompraTCalc d, Art a, ArtArancel aa, SerieLoteMov s
WHERE d.ID = @ID AND d.Articulo =a.Articulo AND a.Arancel = aa.Arancel
AND s.Empresa = @Empresa AND s.Modulo = 'COMS' AND s.ID = d.ID AND s.RenglonID = d.RenglonID AND s.Articulo = d.Articulo AND s.SerieLote = @PedimentoEspecifico
END
IF @BaseProrrateo IN ('PESO/VOLUMEN', 'PESO', 'VOLUMEN')
EXEC spCompraCalcPesoVolumen @Empresa, @ID, @CfgMultiUnidades, @PesoTotal OUTPUT, @VolumenTotal OUTPUT, @PesoVolumenTotal OUTPUT, @PedimentoEspecifico, @ProrrateoNivel
SELECT @MovMoneda = Moneda, @MovTipoCambio = TipoCambio FROM Compra WHERE ID = @ID
IF (@MovMoneda <> @GastoMoneda) OR (@GastoTipoCambio <> @MovTipoCambio)
SELECT @FactorCosto = @GastoTipoCambio / @MovTipoCambio
ELSE SELECT @FactorCosto = 1.0
BEGIN TRANSACTION
IF @PedimentoEspecifico IS NULL
BEGIN
IF @ProrrateoNivel IS NULL
DECLARE crCompraD CURSOR FOR
SELECT d.Renglon, d.RenglonSub, d.Articulo, d.Unidad, d.Cantidad, d.Cantidad*d.Factor, d.SubTotal, ISNULL(a.Peso, 0.0), ISNULL(a.Volumen, 0.0), a.Arancel, ISNULL(aa.Porcentaje, 0.0), d.CantidadNeta*d.Costo, d.MonedaD, d.TipoCambioD
FROM CompraTCalc d
JOIN Art a ON d.Articulo = a.Articulo
LEFT OUTER JOIN ArtArancel aa ON a.Arancel = aa.Arancel
WHERE d.ID = @ID
ELSE IF @ProrrateoNivel = 'PROVEEDOR'
DECLARE crCompraD CURSOR FOR
SELECT d.Renglon, d.RenglonSub, d.Articulo, d.Unidad, d.Cantidad, d.Cantidad*d.Factor, d.SubTotal, ISNULL(a.Peso, 0.0), ISNULL(a.Volumen, 0.0), a.Arancel, ISNULL(aa.Porcentaje, 0.0), d.CantidadNeta*d.Costo, d.MonedaD, d.TipoCambioD
FROM CompraTCalc d
JOIN Art a ON d.Articulo = a.Articulo
LEFT OUTER JOIN ArtArancel aa ON a.Arancel = aa.Arancel
WHERE d.ID = @ID
AND ImportacionProveedor IN (SELECT Proveedor FROM CompraGastoDiversoProv WHERE ID = @ID AND Concepto = @Concepto)
ELSE IF @ProrrateoNivel = 'REFERENCIA'
DECLARE crCompraD CURSOR FOR
SELECT d.Renglon, d.RenglonSub, d.Articulo, d.Unidad, d.Cantidad, d.Cantidad*d.Factor, d.SubTotal, ISNULL(a.Peso, 0.0), ISNULL(a.Volumen, 0.0), a.Arancel, ISNULL(aa.Porcentaje, 0.0), d.CantidadNeta*d.Costo, d.MonedaD, d.TipoCambioD
FROM CompraTCalc d
JOIN Art a ON d.Articulo = a.Articulo
LEFT OUTER JOIN ArtArancel aa ON a.Arancel = aa.Arancel
WHERE d.ID = @ID
AND ImportacionReferencia IN (SELECT Referencia FROM CompraGastoDiversoRef WHERE ID = @ID AND Concepto = @Concepto)
ELSE IF @ProrrateoNivel = 'ARTICULO'
DECLARE crCompraD CURSOR FOR
SELECT d.Renglon, d.RenglonSub, d.Articulo, d.Unidad, d.Cantidad, d.Cantidad*d.Factor, d.SubTotal, ISNULL(a.Peso, 0.0), ISNULL(a.Volumen, 0.0), a.Arancel, ISNULL(aa.Porcentaje, 0.0), d.CantidadNeta*d.Costo, d.MonedaD, d.TipoCambioD
FROM CompraTCalc d
JOIN Art a ON d.Articulo = a.Articulo
LEFT OUTER JOIN ArtArancel aa ON a.Arancel = aa.Arancel
WHERE d.ID = @ID
AND d.Articulo IN (SELECT Articulo FROM CompraGastoDiversoArt WHERE ID = @ID AND Concepto = @Concepto)
END
ELSE
DECLARE crCompraD CURSOR FOR
SELECT d.Renglon, d.RenglonSub, d.Articulo, d.Unidad, d.Cantidad, d.Cantidad*d.Factor, d.SubTotal, ISNULL(a.Peso, 0.0), ISNULL(a.Volumen, 0.0), a.Arancel, ISNULL(aa.Porcentaje, 0.0), d.CantidadNeta*d.Costo, d.MonedaD, d.TipoCambioD
FROM CompraTCalc d
JOIN Art a ON d.Articulo = a.Articulo
LEFT OUTER JOIN ArtArancel aa ON a.Arancel = aa.Arancel
JOIN SerieLoteMov s ON d.ID = s.ID AND d.RenglonID = s.RenglonID AND d.Articulo = s.Articulo
WHERE d.ID = @ID AND s.Empresa = @Empresa AND s.Modulo = 'COMS' AND s.SerieLote = @PedimentoEspecifico
OPEN crCompraD
FETCH NEXT FROM crCompraD INTO @Renglon, @RenglonSub, @Articulo, @MovUnidad, @Cantidad, @CantidadF, @CostoLinea, @Peso, @Volumen, @Arancel, @ArancelPorcentaje, @SubTotalSD, @MovMonedaD, @MovTipoCambioD
WHILE @@FETCH_STATUS <> -1
BEGIN
IF @@FETCH_STATUS <> -2 AND @Cantidad > 0.0 AND @CostoLinea > 0.0
BEGIN
SELECT @MovMoneda = ISNULL(@MovMonedaD, @MovMoneda), @MovTipoCambio = ISNULL(@MovTipoCambioD, @MovTipoCambio)
IF (@MovMoneda <> @GastoMoneda) OR (@GastoTipoCambio <> @MovTipoCambio)
SELECT @FactorCosto = @GastoTipoCambio / @MovTipoCambio
ELSE SELECT @FactorCosto = 1.0
SELECT @PesoLinea = @Peso * @CantidadF,
@VolumenLinea = @Volumen * @CantidadF,
@PesoVolumenLinea = @Peso * @Volumen * @CantidadF
SELECT @CostoArancel = @CostoLinea * (@ArancelPorcentaje/100.0)
SELECT @NuevoCosto = 0.0, @NuevoCostoSD = 0.0
IF @BaseProrrateo IN ('COSTO', 'CONTRIBUCION') 	SELECT @NuevoCosto = (@CostoLinea * @BaseImporte) / @ImporteTotal      		ELSE
IF @BaseProrrateo = 'CANTIDAD'                 	SELECT @NuevoCosto = (@CantidadF * @BaseImporte)  / @CantidadTotal      	ELSE
IF @BaseProrrateo = 'PESO'         		SELECT @NuevoCosto = (@PesoLinea * @BaseImporte)     / @PesoTotal           	ELSE
IF @BaseProrrateo = 'VOLUMEN'      		SELECT @NuevoCosto = (@VolumenLinea * @BaseImporte) / @VolumenTotal         	ELSE
IF @BaseProrrateo = 'PESO/VOLUMEN' 		SELECT @NuevoCosto = (@PesoVolumenLinea * @BaseImporte) / @PesoVolumenTotal 	ELSE
IF @BaseProrrateo = 'ARANCEL'
BEGIN
SELECT @NuevoCosto = ISNULL((@CostoArancel * @BaseImporte) / @ArancelTotal,0.0)
END
IF @BaseProrrateo IN ('COSTO', 'CONTRIBUCION') 	SELECT @NuevoCostoSD = (@SubTotalSD * @BaseImporte) / @ImporteTotalSD      		ELSE
IF @BaseProrrateo = 'CANTIDAD'                 	SELECT @NuevoCostoSD = (@CantidadF * @BaseImporte)  / @CantidadTotal      	ELSE
IF @BaseProrrateo = 'PESO'         		SELECT @NuevoCostoSD = (@PesoLinea * @BaseImporte)     / @PesoTotal           	ELSE
IF @BaseProrrateo = 'VOLUMEN'      		SELECT @NuevoCostoSD = (@VolumenLinea * @BaseImporte) / @VolumenTotal         	ELSE
IF @BaseProrrateo = 'PESO/VOLUMEN' 		SELECT @NuevoCostoSD = (@PesoVolumenLinea * @BaseImporte) / @PesoVolumenTotal 	ELSE
IF @BaseProrrateo = 'ARANCEL'
BEGIN
SELECT @NuevoCosto = ISNULL((@CostoArancel * @BaseImporte) / @ArancelTotal,0.0)
END
SELECT @IncCosto = ISNULL(((@NuevoCosto*@FactorCosto)/@Cantidad),0.0)
SELECT @IncCostoSD = ISNULL(((@NuevoCostoSD*@FactorCosto)/@Cantidad),0.0)
IF @MovTipo NOT IN ('COMS.EI', 'COMS.O') OR @BaseProrrateo = 'CONTRIBUCION'
UPDATE CompraD SET CostoInv = CostoInv + @IncCosto WHERE ID = @ID AND Renglon = @Renglon AND RenglonSub = @RenglonSub
ELSE
BEGIN
IF @ValorAduana = 1
BEGIN
UPDATE CompraD SET CostoInv = CostoInv + @IncCosto, ValorAduana = ValorAduana + @IncCostoSD WHERE ID = @ID AND Renglon = @Renglon AND RenglonSub = @RenglonSub
INSERT CompraGastoProrrateo(ID,  Renglon,  RenglonSub,  Articulo,  IDRenglon,  Concepto, ValorAlmacen, ValorAduana)
VALUES (@ID, @Renglon, @RenglonSub, @Articulo, @RenglonID, @Concepto, @IncCosto, @IncCosto)
END
ELSE
BEGIN
UPDATE CompraD SET CostoInv = CostoInv + @IncCosto WHERE ID = @ID AND Renglon = @Renglon AND RenglonSub = @RenglonSub
INSERT CompraGastoProrrateo(ID,  Renglon,  RenglonSub,  Articulo,  IDRenglon,  Concepto, ValorAlmacen, ValorAduana)
VALUES (@ID, @Renglon, @RenglonSub, @Articulo, @RenglonID, @Concepto, @IncCosto, 0)
END
END
END
FETCH NEXT FROM crCompraD INTO @Renglon, @RenglonSub, @Articulo, @MovUnidad, @Cantidad, @CantidadF, @CostoLinea, @Peso, @Volumen, @Arancel, @ArancelPorcentaje, @SubTotalSD, @MovMonedaD, @MovTipoCambioD
END
CLOSE crCompraD
DEALLOCATE crCompraD
IF @Ok IS NULL
COMMIT TRANSACTION
ELSE BEGIN
ROLLBACK TRANSACTION
RAISERROR(@OkRef,16,-1)
END
RETURN
END

