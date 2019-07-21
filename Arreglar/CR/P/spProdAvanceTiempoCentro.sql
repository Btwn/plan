SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spProdAvanceTiempoCentro
@ID			int,
@MovTipo		char(20),
@MovMoneda		char(10),
@MovTipoCambio	float

AS BEGIN
DECLARE
@Ruta		char(20),
@Orden		int,
@OrdenDestino	int,
@Centro		char(10),
@CentroDestino	char(10),
@Estacion		char(10),
@EstacionDestino	char(10),
@Empresa		char(5),
@ProdSerieLote	varchar(50),
@Articulo		char(20),
@SubCuenta		varchar(50),
@Cantidad		float,
@Tiempo		float,
@TiempoFijo		float,
@TiempoVariable	float,
@TiempoUnidad	varchar(10),
@CostoMO	 	float,
@CostoIndirectos 	float,
@CostoMaquila	float
DECLARE crProdD CURSOR FOR
SELECT p.Empresa, d.ProdSerieLote, d.Articulo, d.SubCuenta, d.Cantidad, d.Ruta, d.Orden, d.Centro
FROM Prod p, ProdD d
WHERE p.ID = @ID AND d.ID = p.ID
OPEN crProdD
FETCH NEXT FROM crProdD INTO @Empresa, @ProdSerieLote, @Articulo, @SubCuenta, @Cantidad, @Ruta, @Orden, @Centro
WHILE @@FETCH_STATUS <> -1
BEGIN
IF @@FETCH_STATUS <> -2
BEGIN
EXEC spProdAvanceAlCentro @Empresa, @MovTipo, @Articulo, @SubCuenta, @ProdSerieLote, @Ruta, @Orden, @OrdenDestino OUTPUT, @Centro, @CentroDestino OUTPUT, @Estacion, @EstacionDestino OUTPUT, @Verificar = 1
IF @Movtipo = 'PROD.R'
SELECT @Orden = @OrdenDestino, @Centro=@CentroDestino
SELECT @TiempoFijo = ISNULL(TiempoFijo, 0), @TiempoVariable = ISNULL(TiempoVariable, 0), @TiempoUnidad = UnidadT
FROM ProdRutaD
WHERE Ruta = @Ruta AND Orden = @Orden AND Centro = @Centro
SELECT @Tiempo = NULLIF(ROUND(@TiempoFijo + (@TiempoVariable * @Cantidad), 6), 0)
EXEC spProdAvanceCalcCosto @Empresa, @ProdSerieLote, @Articulo, @SubCuenta, @Ruta, @Orden, @Centro, 'AMBOS', @Cantidad, @Tiempo, @TiempoUnidad, @MovMoneda, @MovTipoCambio, 1, @CostoMO OUTPUT, @CostoIndirectos OUTPUT, @CostoMaquila OUTPUT
UPDATE ProdD
SET OrdenDestino    = @OrdenDestino,
CentroDestino   = @CentroDestino,
EstacionDestino = @EstacionDestino,
Tiempo          = @Tiempo,
TiempoUnidad    = @TiempoUnidad,
ManoObra	     = @CostoMO,
Indirectos      = @CostoIndirectos,
Maquila	     = @CostoMaquila
WHERE CURRENT OF crProdD
END
FETCH NEXT FROM crProdD INTO @Empresa, @ProdSerieLote, @Articulo, @SubCuenta, @Cantidad, @Ruta, @Orden, @Centro
END
CLOSE crProdD
DEALLOCATE crProdD
RETURN
END

