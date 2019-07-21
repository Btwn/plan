SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spInvProratear
@ID				int,
@BaseProrrateo		char(20),
@BaseImporte		        float,
@GastoMoneda			char(10),
@GastoTipoCambio		float,
@PedimentoEspecifico 	char(20) = NULL

AS BEGIN
DECLARE
@Empresa		char(5),
@CfgMultiUnidades	bit,
@Ok			int,
@OkRef		varchar(255),
@Renglon		float,
@RenglonSub		int,
@Articulo		char(20),
@Cantidad		float,
@CantidadF		float,
@CostoLinea		float,
@Peso		float,
@PesoLinea		float,
@Volumen		float,
@VolumenLinea	float,
@PesoVolumenLinea	float,
@FactorCosto	float,
@Arancel		varchar(50),
@ArancelPorcentaje	float,
@MovMoneda		char(10),
@MovTipoCambio	float,
@ImporteTotal	money,
@CantidadTotal 	float,
@PesoTotal		float,
@VolumenTotal	float,
@PesoVolumenTotal	float,
@CostoArancel	float,
@ArancelTotal	money,
@NuevoCosto		float,
@MovUnidad		varchar(50)
SELECT @Ok = NULL, @BaseProrrateo = UPPER(@BaseProrrateo)
EXEC spInvCalcFactor 'INV', @ID
SELECT @Empresa = Empresa FROM Inv WITH(NOLOCK) WHERE ID = @ID
SELECT @CfgMultiUnidades = MultiUnidades FROM EmpresaCfg2 WITH(NOLOCK) WHERE Empresa = @Empresa
IF @PedimentoEspecifico IS NULL
SELECT @ImporteTotal = SUM(Costo*Cantidad)
FROM InvD WITH(NOLOCK)
WHERE ID = @ID
ELSE
SELECT @ImporteTotal = SUM(d.Costo*d.Cantidad)
FROM InvD d WITH(NOLOCK), SerieLoteMov s WITH(NOLOCK)
WHERE d.ID = @ID
AND s.Empresa = @Empresa AND s.Modulo = 'INV' AND s.ID = d.ID AND s.RenglonID = d.RenglonID AND s.Articulo = d.Articulo AND s.SerieLote = @PedimentoEspecifico
IF @BaseProrrateo = 'CANTIDAD'
BEGIN
IF @PedimentoEspecifico IS NULL
SELECT @CantidadTotal = SUM(Cantidad*Factor)
FROM InvD WITH(NOLOCK)
WHERE ID = @ID
ELSE
SELECT @CantidadTotal = SUM(d.Cantidad*d.Factor)
FROM InvD d WITH(NOLOCK), SerieLoteMov s WITH(NOLOCK)
WHERE d.ID = @ID
AND s.Empresa = @Empresa AND s.Modulo = 'INV' AND s.ID = d.ID AND s.RenglonID = d.RenglonID AND s.Articulo = d.Articulo AND s.SerieLote = @PedimentoEspecifico
END
IF @BaseProrrateo = 'ARANCEL'
BEGIN
IF @PedimentoEspecifico IS NULL
SELECT @ArancelTotal = SUM(d.Costo*d.Cantidad*(aa.Porcentaje/100.0))
FROM InvD d WITH(NOLOCK), Art a WITH(NOLOCK), ArtArancel aa WITH(NOLOCK)
WHERE d.ID = @ID AND d.Articulo =a.Articulo AND a.Arancel = aa.Arancel
ELSE
SELECT @ArancelTotal = SUM(d.Costo*d.Cantidad*(aa.Porcentaje/100.0))
FROM InvD d WITH(NOLOCK), Art a WITH(NOLOCK), ArtArancel aa WITH(NOLOCK), SerieLoteMov s WITH(NOLOCK)
WHERE d.ID = @ID AND d.Articulo =a.Articulo AND a.Arancel = aa.Arancel
AND s.Empresa = @Empresa AND s.Modulo = 'INV' AND s.ID = d.ID AND s.RenglonID = d.RenglonID AND s.Articulo = d.Articulo AND s.SerieLote = @PedimentoEspecifico
END
IF @BaseProrrateo IN ('PESO/VOLUMEN', 'PESO', 'VOLUMEN')
EXEC spInvCalcPesoVolumen @Empresa, @ID, @CfgMultiUnidades, @PesoTotal OUTPUT, @VolumenTotal OUTPUT, @PesoVolumenTotal OUTPUT, @PedimentoEspecifico
SELECT @MovMoneda = Moneda, @MovTipoCambio = TipoCambio FROM Inv WITH(NOLOCK) WHERE ID = @ID
IF @MovMoneda <> @GastoMoneda
SELECT @FactorCosto = @GastoTipoCambio / @MovTipoCambio
ELSE SELECT @FactorCosto = 1.0
BEGIN TRANSACTION
IF @PedimentoEspecifico IS NULL
DECLARE crInvD CURSOR FOR
SELECT d.Renglon, d.RenglonSub, d.Articulo, d.Unidad, d.Cantidad, d.Cantidad*d.Factor, d.Cantidad*d.Costo, a.Peso, a.Volumen, a.Arancel, aa.Porcentaje
FROM InvD d WITH(NOLOCK)
JOIN Art a WITH(NOLOCK) ON d.Articulo = a.Articulo
LEFT OUTER JOIN ArtArancel aa WITH(NOLOCK) ON a.Arancel = aa.Arancel
WHERE d.ID = @ID
ELSE
DECLARE crInvD CURSOR FOR
SELECT d.Renglon, d.RenglonSub, d.Articulo, d.Unidad, d.Cantidad, d.Cantidad*d.Factor, d.Cantidad*d.Costo, a.Peso, a.Volumen, a.Arancel, aa.Porcentaje
FROM InvD d WITH(NOLOCK)
JOIN Art a WITH(NOLOCK) ON d.Articulo = a.Articulo
LEFT OUTER JOIN ArtArancel aa WITH(NOLOCK) ON a.Arancel = aa.Arancel
JOIN SerieLoteMov s WITH(NOLOCK) ON d.ID = s.ID AND d.RenglonID = s.RenglonID AND d.Articulo = s.Articulo
WHERE d.ID = @ID AND s.Empresa = @Empresa AND s.Modulo = 'INV' AND s.SerieLote = @PedimentoEspecifico
OPEN crInvD
FETCH NEXT FROM crInvD INTO @Renglon, @RenglonSub, @Articulo, @MovUnidad, @Cantidad, @CantidadF, @CostoLinea, @Peso, @Volumen, @Arancel, @ArancelPorcentaje
WHILE @@FETCH_STATUS <> -1
BEGIN
IF @@FETCH_STATUS <> -2 AND @Cantidad > 0.0 AND @CostoLinea > 0.0
BEGIN
SELECT @PesoLinea = @Peso * @CantidadF,
@VolumenLinea = @Volumen * @CantidadF,
@PesoVolumenLinea = @Peso * @Volumen * @CantidadF
SELECT @CostoArancel = @CostoLinea * (@ArancelPorcentaje/100.0)
SELECT @NuevoCosto = 0.0
IF @BaseProrrateo = 'COSTO'        SELECT @NuevoCosto = (@CostoLinea * @BaseImporte) / @ImporteTotal      	ELSE
IF @BaseProrrateo = 'CANTIDAD'     SELECT @NuevoCosto = (@CantidadF * @BaseImporte)  / @CantidadTotal      	ELSE
IF @BaseProrrateo = 'PESO'         SELECT @NuevoCosto = (@PesoLinea * @BaseImporte)     / @PesoTotal           	ELSE
IF @BaseProrrateo = 'VOLUMEN'      SELECT @NuevoCosto = (@VolumenLinea * @BaseImporte) / @VolumenTotal         	ELSE
IF @BaseProrrateo = 'PESO/VOLUMEN' SELECT @NuevoCosto = (@PesoVolumenLinea * @BaseImporte) / @PesoVolumenTotal 	ELSE
IF @BaseProrrateo = 'ARANCEL'
BEGIN
SELECT @NuevoCosto = (@CostoArancel * @BaseImporte) / @ArancelTotal
END
UPDATE InvD WITH(ROWLOCK) SET CostoInv = CostoInv + ((@NuevoCosto*@FactorCosto)/@Cantidad) WHERE ID = @ID AND Renglon = @Renglon AND RenglonSub = @RenglonSub
END
FETCH NEXT FROM crInvD INTO @Renglon, @RenglonSub, @Articulo, @MovUnidad, @Cantidad, @CantidadF, @CostoLinea, @Peso, @Volumen, @Arancel, @ArancelPorcentaje
END
CLOSE crInvD
DEALLOCATE crInvD
IF @Ok IS NULL
COMMIT TRANSACTION
ELSE BEGIN
ROLLBACK TRANSACTION
RAISERROR(@OkRef,16,-1)
END
RETURN
END

