SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spOfertaArmadaAplicar
@OfertaID	int,
@Empresa	char(5)

AS BEGIN
DECLARE
@Articulo             varchar(20),
@SubCuenta            varchar(50),
@Unidad               varchar(50),
@Cantidad             float,
@Precio               float,
@ArmadaOk             bit,
@CfgOfertaNivelOpcion	bit,
@TotalPreciosVenta		int,
@TotalPreciosOferta		int,
@TotalImporteVenta		float,
@CfgImpInc            int,
@MontoMinimo          float,
@Tipo                 varchar(50),
@Forma                varchar(50),
@Usar                 varchar(50),
@OfertaAplicaLog      bit
SELECT @CfgImpInc  = VentaPreciosImpuestoIncluido FROM EmpresaCfg ec WHERE ec.Empresa = @Empresa
SELECT @CfgOfertaNivelOpcion = ISNULL(OfertaNivelOpcion, 0),
@OfertaAplicaLog = ISNULL(OfertaAplicaLog, 0)
FROM EmpresaCfg2 ec
WHERE ec.Empresa = @Empresa
SELECT @ArmadaOk = 1
IF @CfgOfertaNivelOpcion = 1
DECLARE crOfertaD CURSOR LOCAL FOR
SELECT Articulo, ISNULL(SubCuenta, ''),ISNULL(Unidad,''), Cantidad
FROM OfertaD
WHERE ID = @OfertaID
ELSE
DECLARE crOfertaD CURSOR LOCAL FOR
SELECT Articulo, ISNULL(SubCuenta, ''),ISNULL(Unidad,''), Cantidad
FROM OfertaD
WHERE ID = @OfertaID
OPEN crOfertaD
FETCH NEXT FROM crOfertaD INTO @Articulo, @SubCuenta, @Unidad, @Cantidad
WHILE @@FETCH_STATUS <> -1
BEGIN
IF @@FETCH_STATUS <> -2 AND @ArmadaOk = 1
BEGIN
IF @CfgOfertaNivelOpcion = 1
BEGIN
IF NOT EXISTS(SELECT * FROM #VentaD WHERE NULLIF(OfertaID, 0) IS NULL AND Articulo = @Articulo AND ISNULL(SubCuenta, '') = @SubCuenta AND Unidad = @Unidad AND CantidadInventario >= @Cantidad AND Cantidad>=@Cantidad)
SELECT @ArmadaOk = 0
END
ELSE
IF NOT EXISTS(SELECT * FROM #VentaD WHERE NULLIF(OfertaID, 0) IS NULL AND Articulo = @Articulo AND Unidad = @Unidad AND CantidadInventario >= @Cantidad AND Cantidad>=@Cantidad)
SELECT @ArmadaOk = 0
END
FETCH NEXT FROM crOfertaD INTO @Articulo, @SubCuenta, @Unidad, @Cantidad
END  
CLOSE crOfertaD
DEALLOCATE crOfertaD
IF @ArmadaOk = 1
BEGIN
SELECT @TotalPreciosVenta = COUNT(*) FROM #VentaD v JOIN OfertaD od ON v.PrecioSugerido >= od.Precio AND od.ID = @OfertaID AND v.Articulo = od.Articulo AND ISNULL(v.SubCuenta, '') = ISNULL(od.SubCuenta,'') AND ISNULL(v.Unidad,'') = ISNULL(od.Unidad,'')
SELECT @TotalPreciosOferta = COUNT(*) FROM OfertaD WHERE ID = @OfertaID
SELECT @TotalImporteVenta = SUM(CASE WHEN @CfgImpInc = 1 THEN ISNULL(v.PrecioSugerido,0) / (1+(ISNULL(v.Impuesto1,0)/100)) ELSE ISNULL(v.PrecioSugerido,0) END * ISNULL(v.Cantidad,0))
FROM #VentaD v JOIN OfertaD od ON v.PrecioSugerido >= od.Precio AND od.ID = @OfertaID AND v.Articulo = od.Articulo AND ISNULL(v.SubCuenta, '') = ISNULL(od.SubCuenta,'') AND ISNULL(v.Unidad,'') = ISNULL(od.Unidad,'')
SELECT @MontoMinimo = MontoMinimo,@Tipo = Tipo, @Forma = Forma, @Usar = Usar FROM Oferta WHERE ID = @OfertaID
IF @CfgOfertaNivelOpcion = 1
DECLARE crOfertaD CURSOR LOCAL FOR
SELECT Articulo, ISNULL(SubCuenta, ''), ISNULL(Unidad,''), Cantidad, Precio
FROM OfertaD
WHERE ID = @OfertaID
ELSE
DECLARE crOfertaD CURSOR LOCAL FOR
SELECT Articulo, CONVERT(char(50), ''), ISNULL(Unidad,''), Cantidad, Precio
FROM OfertaD
WHERE ID = @OfertaID
OPEN crOfertaD
FETCH NEXT FROM crOfertaD INTO @Articulo, @SubCuenta, @Unidad, @Cantidad, @Precio
WHILE @@FETCH_STATUS <> -1
BEGIN
IF @@FETCH_STATUS <> -2 AND @TotalPreciosVenta = @TotalPreciosOferta AND @TotalImporteVenta >= ISNULL(@MontoMinimo, 0.0)
BEGIN
IF @CfgOfertaNivelOpcion = 1
UPDATE #VentaD
SET Precio = @Precio,
PrecioSugerido = @Precio,
OfertaID = @OfertaID
WHERE NULLIF(OfertaID, 0) IS NULL
AND Articulo = @Articulo
AND ISNULL(SubCuenta, '') = @SubCuenta
AND Unidad = @Unidad
AND CantidadInventario >= @Cantidad
AND PrecioSugerido >= @Precio
ELSE
UPDATE #VentaD
SET Precio = @Precio,
PrecioSugerido = @Precio,
OfertaID = @OfertaID
WHERE NULLIF(OfertaID, 0) IS NULL
AND Articulo = @Articulo
AND Unidad = @Unidad
AND CantidadInventario >= @Cantidad
AND PrecioSugerido >= @Precio
IF @OfertaAplicaLog = 1 AND @Precio IS NOT NULL
BEGIN
SET @Precio = CAST(ROUND(@Precio,dbo.fnRedondeoDecimales(@Empresa)) AS FLOAT)
EXEC spOfertaLog @OfertaID,@Tipo, @Forma, @Usar, @Articulo, @SubCuenta, @Unidad, @Precio = @Precio
END
END
FETCH NEXT FROM crOfertaD INTO @Articulo, @SubCuenta, @Unidad, @Cantidad, @Precio
END  
CLOSE crOfertaD
DEALLOCATE crOfertaD
END
RETURN
END

