SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spProdCostearEntrada
@Empresa		char(5),
@ID			int,
@MovMoneda		char(10),
@MovTipoCambio	float,
@Ok                	int          OUTPUT,
@OkRef             	varchar(255) OUTPUT

AS BEGIN
DECLARE
@ProdSerieLote      varchar(50),
@Articulo		char(20),
@SubCuenta		varchar(50),
@Cantidad		float,
@CantidadTotal	float,
@CantidadPendiente	float,
@CostoLote		float,
@CostoUnitario	float
DECLARE crProdD CURSOR FOR
SELECT ProdSerieLote, Articulo, ISNULL(RTRIM(SubCuenta), ''), SUM(ISNULL(Cantidad, 0.0)), SUM(ISNULL(Cantidad, 0.0)+ISNULL(Merma, 0.0)+ISNULL(Desperdicio, 0.0))
FROM ProdD
WHERE ID = @ID
GROUP BY ProdSerieLote, Articulo, SubCuenta
ORDER BY ProdSerieLote, Articulo, SubCuenta
OPEN crProdD
FETCH NEXT FROM crProdD INTO @ProdSerieLote, @Articulo, @SubCuenta, @Cantidad, @CantidadTotal
WHILE @@FETCH_STATUS <> -1 AND @CantidadTotal > 0.0 AND @Ok IS NULL
BEGIN
IF @@FETCH_STATUS <> -2 AND @Ok IS NULL
BEGIN
SELECT @CostoLote = 0.0
SELECT @CostoLote = SUM((ISNULL(l.Cargo, 0.0)-ISNULL(l.Abono, 0.0))*m.TipoCambio) / @MovTipoCambio
FROM ProdSerieLoteCosto l, Mon m
WHERE Empresa = @Empresa AND ProdSerieLote = @ProdSerieLote AND Articulo = @Articulo AND SubCuenta = @SubCuenta AND m.Moneda = l.Moneda
SELECT @CantidadPendiente = ISNULL(CantidadOrdenada, 0.0) - ISNULL(CantidadCancelada, 0.0) - ISNULL(CantidadEntrada, 0.0) - ISNULL(CantidadMerma, 0.0) - ISNULL(CantidadDesperdicio, 0.0)
FROM ProdSerieLote
WHERE Empresa = @Empresa AND ProdSerieLote = @ProdSerieLote AND Articulo = @Articulo AND SubCuenta = @SubCuenta
SELECT @CostoUnitario = (@CostoLote /** (@CantidadTotal/@CantidadPendiente)*/) / @Cantidad
UPDATE ProdD SET Costo = @CostoUnitario WHERE ID = @ID AND ProdSerieLote = @ProdSerieLote AND Articulo = @Articulo AND ISNULL(SubCuenta, '') = ISNULL(@SubCuenta, '') AND UPPER(Tipo) NOT IN ('MERMA', 'DESPERDICIO')
END
FETCH NEXT FROM crProdD INTO @ProdSerieLote, @Articulo, @SubCuenta, @Cantidad, @CantidadTotal
END
CLOSE crProdD
DEALLOCATE crProdD
RETURN
END

