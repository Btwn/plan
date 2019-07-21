SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spOfertaNormal
@Empresa				varchar(5),
@Sucursal				int,
@Moneda					varchar(10),
@TipoCambio				float,
@Articulo				varchar(20),
@SubCuenta				varchar(50),
@ArtCantidadTotal		float,
@ArtCostoBase			float,
@ArtPrecioSugerido		float,
@ArtPrecio				float	OUTPUT,
@ArtDescuento			float	OUTPUT,
@ArtDescuentoImporte    money	OUTPUT,
@ArtPuntos				float	OUTPUT,
@ArtPuntosPorcentaje	float	OUTPUT,
@ArtComision			float	OUTPUT,
@ArtComisionPorcentaje	float	OUTPUT,
@ArtOfertaID			int		OUTPUT,
@CfgOfertaNivelopcion	bit ,
@PuntosPrecio           bit= NULL,
@Prioridad				int= NULL,
@ArtUnidad				varchar(50)

AS BEGIN
DECLARE
@a			              int,
@b                        int,
@OfertaID		          int,
@OfertaTipoCambio	      float,
@Tipo		              varchar(50),
@Forma		              varchar(50),
@Usar		              varchar(50),
@TieneVolumen	          bit,
@Cantidad		          float,
@Porcentaje		          float,
@Precio		              float,
@Importe	              money,
@Obsequio		          varchar(20),
@UnidadObsequio		      varchar(50),
@Desde		              float,
@ModImporte               int,
@PrecioVenta              float,
@ImporteVenta             float,
@CantidadObsequio         float,
@CantidadOferta           float,
@ImporteOferta            float,
@CumpleTotal              int,
@ArtTipo                  varchar(20),
@TipoCosteo               varchar(20),
@Costo                    money,
@PrecioBaseCosto          money,
@Factor                   float,
@PrecioBaseLista          money,
@ListaPreciosEsp          varchar(20),
@CfgImpInc                int,
@CfgCosteoNivelSubCuenta  bit,
@ObsequiosTotales	      int,
@CantidadObsequiosVtaD    int,
@CantidadArt		      int,
@Contador			      int,
@ArticuloDesc		      varchar(20),
@DescuentoEnP1		      float,
@DescuentoEnP2		      float,
@CantidadTemporal	      int,
@ImporteTemporal	      float,
@PrecioTemporal		      float,
@DescImporteTemporal      money,
@PorcentajeImporte	      float,
@ArticuloImporte	      varchar(20),
@OfertaAplicaLog	      bit,
@RestaComponente	      int,		
@DescripcionOfertaLog     varchar(255),
@SubCuentaObsequio        varchar(50), 
@CantidadArticulo	      int,
@DescripcionArtObsequio   varchar(100),
@DescripcionArtOrigen     varchar(100),
@NombreListaEsp           varchar (100),
@ArtCantidadTotalObsequio int,
@TotalArticulosOferta     int,
@ImporteVentaPorcentaje   float,
@DesImporte               float,
@cantidadTotal            int,
@TotalArtOferta           int,
@ArtAplicados             int,
@ArtAplicadosDCI          int
DECLARE @TabDescuentos    TABLE (Articulo varchar(20), DescuentoP1 float, DescuentoP2 float, Precio float, Cantidad int, Impuesto float, DescuentoImporte money)
DECLARE @TabOferta        TABLE (Articulo varchar(20),SubCuenta varchar(20), Unidad varchar(20), Cantidad int)      
DECLARE @TabVenta         TABLE (Articulo varchar(20),SubCuenta varchar(20), Unidad varchar(20), Cantidad int)      
DECLARE @TabVentaImporte  TABLE (Articulo varchar(20),SubCuenta varchar(20), Unidad varchar(20), TotalImpote float) 
SELECT @TipoCosteo = TipoCosteo,
@CfgImpInc  = VentaPreciosImpuestoIncluido,
@CfgCosteoNivelSubCuenta    = CosteoNivelSubCuenta
FROM EmpresaCfg ec
WHERE ec.Empresa = @Empresa
SELECT @OfertaAplicaLog = CASE
WHEN (ISNULL(OfertaAplicaLog, 0) > 0) THEN OfertaAplicaLog
WHEN (ISNULL(OfertaAplicaLogPOS, 0) > 0) THEN OfertaAplicaLogPOS
ELSE 0
END
FROM EmpresaCfg2 ec
WHERE ec.Empresa = @Empresa
DECLARE @OfertaNormal TABLE(
Orden					int IDENTITY(1,1)PRIMARY KEY,
ID					int NOT NULL,
Prioridad             int NULL,
TipoCambio			float NULL,
Tipo					varchar(50) NULL,
Forma					varchar(50) NULL,
Usar					varchar(50) NULL,
TieneVolumen			bit NULL,
Cantidad				float NULL,
Porcentaje			float NULL,
Precio				float NULL,
Importe				money NULL,
Obsequio				varchar(20) NULL,
Factor				float NULL,
ListaPreciosEsp		varchar(20) NULL,
UnidadObsequio		varchar(50) NULL,
SubCuentaObsequio		varchar(50) NULL)
IF @CfgOfertaNivelopcion = 1
INSERT @OfertaNormal(ID, Prioridad, TipoCambio, Tipo, Forma, Usar, TieneVolumen, Cantidad, Porcentaje, Precio, Importe, Obsequio, Factor, ListaPreciosEsp, UnidadObsequio, SubCuentaObsequio)
SELECT o.ID, o.Prioridad, o.TipoCambio, o.Tipo, UPPER(o.Forma), UPPER(o.Usar), ISNULL(o.TieneVolumen, 0), NULLIF(d.Cantidad, 0.0), NULLIF(d.Porcentaje, 0.0), NULLIF(d.Precio, 0.0), NULLIF(d.Importe, 0.0), NULLIF(RTRIM(d.Obsequio), ''), ISNULL(d.Factor,0.00), o.ListaPreciosEsp,d.UnidadObsequio, d.SubCuentaObsequio
FROM OfertaD d
JOIN Oferta o ON o.ID = d.ID AND o.Prioridad = @Prioridad
JOIN Mon m ON m.Moneda = o.Moneda
JOIN MovTipo mt ON mt.Modulo = 'OFER' AND mt.Mov = o.Mov AND mt.Clave IN ('OFER.OF')
JOIN #OfertaActiva oa ON oa.ID = o.ID
JOIN OfertaTipo t ON o.Tipo = t.Tipo
WHERE d.Articulo = @Articulo AND ISNULL(d.SubCuenta, '') = ISNULL(@SubCuenta,'') AND ISNULL(NULLIF(d.Unidad,''), @ArtUnidad) = ISNULL(@ArtUnidad,'')
ORDER BY o.Prioridad,t.Orden,o.FechaEmision
ELSE
INSERT @OfertaNormal(ID, Prioridad, TipoCambio, Tipo, Forma, Usar, TieneVolumen, Cantidad, Porcentaje, Precio, Importe, Obsequio, Factor, ListaPreciosEsp, UnidadObsequio, SubCuentaObsequio)
SELECT o.ID, o.Prioridad, o.TipoCambio, o.Tipo, UPPER(o.Forma), UPPER(o.Usar), ISNULL(o.TieneVolumen, 0), NULLIF(d.Cantidad, 0.0), NULLIF(d.Porcentaje, 0.0), NULLIF(d.Precio, 0.0), NULLIF(d.Importe, 0.0), NULLIF(RTRIM(d.Obsequio), ''), ISNULL(d.Factor,0.00), o.ListaPreciosEsp,d.UnidadObsequio, d.SubCuentaObsequio
FROM OfertaD d
JOIN Oferta o ON o.ID = d.ID AND o.Prioridad = @Prioridad
JOIN Mon m ON m.Moneda = o.Moneda
JOIN MovTipo mt ON mt.Modulo = 'OFER' AND mt.Mov = o.Mov AND mt.Clave IN ('OFER.OF')
JOIN #OfertaActiva oa ON oa.ID = o.ID
JOIN OfertaTipo t ON o.Tipo = t.Tipo
WHERE d.Articulo = @Articulo AND ISNULL(NULLIF(d.Unidad,''), @ArtUnidad) = ISNULL(@ArtUnidad,'')
ORDER BY o.Prioridad,t.Orden,o.FechaEmision
IF @Prioridad = 1
BEGIN
DECLARE crOfertaNormal CURSOR LOCAL FAST_FORWARD READ_ONLY FOR
SELECT ID, TipoCambio, Tipo, Forma, Usar, TieneVolumen, Cantidad, Porcentaje, Precio, Importe, Obsequio, Factor, ListaPreciosEsp, UnidadObsequio, SubCuentaObsequio
FROM @OfertaNormal
WHERE Prioridad = 1
OPEN crOfertaNormal
FETCH NEXT FROM crOfertaNormal INTO @OfertaID, @OfertaTipoCambio, @Tipo, @Forma, @Usar, @TieneVolumen, @Cantidad, @Porcentaje, @Precio, @Importe, @Obsequio, @Factor, @ListaPreciosEsp, @UnidadObsequio, @SubCuentaObsequio
WHILE @@FETCH_STATUS <> -1
BEGIN
IF @@FETCH_STATUS <> -2
BEGIN
SELECT @ArtPrecio = NULL, @ArtDescuento  = NULL, @ArtDescuentoImporte = NULL,
@ArtPuntos = NULL, @ArtPuntosPorcentaje = NULL, @ArtComision = NULL, @ArtOfertaID = NULL,
@PrecioBaseCosto = NULL, @PrecioBaseLista = NULL
IF @TieneVolumen = 1
BEGIN
SELECT @Desde = NULL
SELECT @Desde = MAX(Desde)
FROM OfertaDVol
WHERE ID = @OfertaID AND Articulo = @Articulo AND (@ArtCantidadTotal >= Desde AND @ArtCantidadTotal <= Hasta)
IF @Desde IS NOT NULL
SELECT @Cantidad = Desde, @Porcentaje = Porcentaje, @Precio = Precio, @Importe = Importe
FROM OfertaDVol
WHERE ID = @OfertaID AND Articulo = @Articulo AND Desde = @Desde
END
SELECT @Precio = NULLIF(@Precio, 0.0)*@OfertaTipoCambio/@TipoCambio,
@Importe = NULLIF(@Importe, 0.0)*@OfertaTipoCambio/@TipoCambio
IF @Forma = 'Precio/Costo'
BEGIN
IF NULLIF(@SubCuenta,'') IS NOT NULL AND @CfgCosteoNivelSubCuenta = 1
BEGIN
SELECT @Costo = UltimoCosto
FROM ArtSubCosto
WHERE Articulo = @Articulo AND SubCuenta = @SubCuenta AND Empresa = @Empresa AND Sucursal = @Sucursal
END
ELSE
BEGIN
SELECT @Costo = UltimoCosto
FROM ArtCosto
WHERE Articulo = @Articulo AND Empresa = @Empresa AND Sucursal = @Sucursal
END
IF @Costo IS NULL
SET @Costo = 0.0
IF @Usar = 'PORCENTAJE' AND @Porcentaje IS NOT NULL AND @Costo IS NOT NULL
BEGIN
SET @PrecioBaseCosto = @Costo + (@Costo * (@Porcentaje/100))
IF @PrecioBaseCosto IS NOT NULL AND EXISTS(SELECT * FROM #VentaD WHERE Articulo = @Articulo AND RenglonTipo <> 'C')
BEGIN
SET @ArtOfertaID = @OfertaID
UPDATE #VentaD SET PrecioSugerido = @PrecioBaseCosto, Precio = @PrecioBaseCosto,OfertaID = @OfertaID
WHERE Articulo = @Articulo
AND ISNULL(SubCuenta,'') = ISNULL(@Subcuenta,ISNULL(SubCuenta,''))
AND Unidad = @ArtUnidad AND RenglonTipo <> 'C'
IF @OfertaAplicaLog = 1 AND @ArtOfertaID IS NOT NULL
BEGIN
SET @DescripcionOfertaLog = 'PRECIO = COSTO + ' + CAST(@Porcentaje as varchar(20))+' %'
SET @PrecioBaseCosto = CAST(ROUND(@PrecioBaseCosto,dbo.fnRedondeoDecimales(@Empresa)) AS FLOAT)
EXEC spOfertaLog @OfertaID,@Tipo, @Forma, @Usar, @Articulo, @SubCuenta, @ArtUnidad, @Precio = @PrecioBaseCosto, @Descripcion = @DescripcionOfertaLog 
END
END
END
IF @Usar = 'MONTO' AND @Importe IS NOT NULL AND @Costo IS NOT NULL
BEGIN
SET @PrecioBaseCosto = @Costo + @Importe
IF @PrecioBaseCosto IS NOT NULL AND EXISTS(SELECT * FROM #VentaD WHERE Articulo = @Articulo AND RenglonTipo <> 'C')
BEGIN
SET @ArtOfertaID = @OfertaID
UPDATE #VentaD SET PrecioSugerido = @PrecioBaseCosto, Precio = @PrecioBaseCosto,OfertaID = @OfertaID
WHERE Articulo = @Articulo
AND ISNULL(SubCuenta,'') = ISNULL(@Subcuenta,ISNULL(SubCuenta,''))
AND Unidad = @ArtUnidad AND RenglonTipo <> 'C'
IF @OfertaAplicaLog = 1 AND @ArtOfertaID IS NOT NULL
BEGIN
SET @DescripcionOfertaLog = 'PRECIO = COSTO + $' + CONVERT(varchar(20), @Importe)
SET @PrecioBaseCosto = CAST(ROUND(@PrecioBaseCosto,dbo.fnRedondeoDecimales(@Empresa)) AS FLOAT)
EXEC spOfertaLog @OfertaID,@Tipo, @Forma, @Usar, @Articulo, @SubCuenta, @ArtUnidad, @Precio = @PrecioBaseCosto, @Descripcion = @DescripcionOfertaLog
END
END
END
IF @Usar = 'FACTOR' AND @Costo IS NOT NULL AND @Factor IS NOT NULL
BEGIN
SET @PrecioBaseCosto = @Costo * @Factor
IF @PrecioBaseCosto IS NOT NULL
BEGIN
SET @ArtOfertaID = @OfertaID
SET @DescripcionOfertaLog = 'PRECIO = COSTO X ' + CAST(@Factor as varchar(20))
UPDATE #VentaD SET PrecioSugerido = @PrecioBaseCosto, Precio = @PrecioBaseCosto,OfertaID = @OfertaID
WHERE Articulo = @Articulo
AND ISNULL(SubCuenta,'') = ISNULL(@Subcuenta,ISNULL(SubCuenta,''))
AND Unidad = @ArtUnidad
IF @OfertaAplicaLog = 1 AND @ArtOfertaID IS NOT NULL
BEGIN
SET @PrecioBaseCosto = CAST(ROUND(@PrecioBaseCosto,dbo.fnRedondeoDecimales(@Empresa)) AS FLOAT)
EXEC spOfertaLog @OfertaID,@Tipo, @Forma, @Usar, @Articulo, @SubCuenta, @ArtUnidad, @Precio = @PrecioBaseCosto, @Descripcion = @DescripcionOfertaLog
END
END
END
END
IF @Forma = 'Precio/Lista'
BEGIN
EXEC spPCGet @Sucursal, @Empresa, @Articulo, @SubCuenta, @ArtUnidad, @Moneda, @TipoCambio, @ListaPreciosEsp, @PrecioBaseLista OUTPUT
IF @Usar = 'PORCENTAJE' AND @Porcentaje IS NOT NULL AND @PrecioBaseLista IS NOT NULL
BEGIN
SET @PrecioBaseLista = @PrecioBaseLista + (@PrecioBaseLista * (@Porcentaje/100))
IF @PrecioBaseLista IS NOT NULL
BEGIN
SET @ArtOfertaID = @OfertaID
UPDATE #VentaD SET PrecioSugerido = @PrecioBaseLista, Precio = @PrecioBaseLista,OfertaID = @OfertaID
WHERE Articulo = @Articulo
AND ISNULL(SubCuenta,'') = ISNULL(@Subcuenta,ISNULL(SubCuenta,''))
AND Unidad = @ArtUnidad
IF @OfertaAplicaLog = 1 AND @ArtOfertaID IS NOT NULL
BEGIN
IF @Subcuenta IS NOT NULL OR @Subcuenta <> ''
BEGIN
SELECT @NombreListaEsp = b.Lista
FROM ofertaD a
INNER JOIN ListaPreciosDUnidad  b
ON a.Articulo = b.Articulo
AND a.PrecioLista = b.Precio
WHERE a.Articulo = @Articulo
AND a.id = @OfertaID
AND a.Unidad = @ArtUnidad
END ELSE
BEGIN
SELECT @NombreListaEsp = a.Lista
FROM ListaPreciosSubUnidad a
INNER JOIN ofertaD b
ON a.Articulo = b.Articulo
WHERE b.Articulo = @Articulo
AND b.SubCuenta = @SubCuenta
AND b.Unidad = @ArtUnidad
END
IF @ListaPreciosEsp IS NOT NULL AND @ListaPreciosEsp = ''
SET @ListaPreciosEsp = LTRIM(RTRIM(@NombreListaEsp))
SET @DescripcionOfertaLog = 'PRECIO = '+ ISNULL(@ListaPreciosEsp,  LTRIM(RTRIM(@NombreListaEsp))) +' + ' + CAST(@Porcentaje as varchar(20))+' %'
SET @PrecioBaseLista = CAST(ROUND(@PrecioBaseLista,dbo.fnRedondeoDecimales(@Empresa)) AS FLOAT)
EXEC spOfertaLog @OfertaID,@Tipo, @Forma, @Usar, @Articulo, @SubCuenta, @ArtUnidad, @Precio = @PrecioBaseLista, @Descripcion = @DescripcionOfertaLog 
END
END
END
IF @Usar = 'MONTO' AND @Importe IS NOT NULL AND @PrecioBaseLista IS NOT NULL
BEGIN
SET @PrecioBaseLista = @PrecioBaseLista + @Importe
IF @PrecioBaseLista IS NOT NULL
BEGIN
SET @ArtOfertaID = @OfertaID
UPDATE #VentaD SET PrecioSugerido = @PrecioBaseLista, Precio = @PrecioBaseLista,OfertaID = @OfertaID
WHERE Articulo = @Articulo
AND ISNULL(SubCuenta,'') = ISNULL(@Subcuenta,ISNULL(SubCuenta,''))
AND Unidad = @ArtUnidad
IF @OfertaAplicaLog = 1 AND @ArtOfertaID IS NOT NULL
BEGIN
IF @Subcuenta IS NOT NULL OR @Subcuenta <> ''
BEGIN
SELECT @NombreListaEsp = b.Lista
FROM ofertaD a
INNER JOIN ListaPreciosDUnidad  b
ON a.Articulo = b.Articulo
AND a.PrecioLista = b.Precio
WHERE a.Articulo = @Articulo
AND a.id = @OfertaID
AND a.Unidad = @ArtUnidad
END ELSE
BEGIN
SELECT @NombreListaEsp = a.Lista
FROM ListaPreciosSubUnidad a
INNER JOIN ofertaD b
ON a.Articulo = b.Articulo
WHERE b.Articulo = @Articulo
AND b.SubCuenta = @SubCuenta
AND b.Unidad = @ArtUnidad
END
IF @ListaPreciosEsp IS NOT NULL AND @ListaPreciosEsp = ''
SET @ListaPreciosEsp = LTRIM(RTRIM(@NombreListaEsp))
SET @DescripcionOfertaLog = 'PRECIO = '+ ISNULL(@ListaPreciosEsp,  LTRIM(RTRIM(@NombreListaEsp)))  +' (+) $' + CAST(@Importe as varchar(20))
SET @PrecioBaseLista = CAST(ROUND(@PrecioBaseLista,dbo.fnRedondeoDecimales(@Empresa)) AS FLOAT)
EXEC spOfertaLog @OfertaID,@Tipo, @Forma, @Usar, @Articulo, @SubCuenta, @ArtUnidad, @Precio = @PrecioBaseLista, @Descripcion = @DescripcionOfertaLog
END
END
END
END
IF @Forma = 'PRECIO'
BEGIN
IF @Usar = 'PORCENTAJE' AND @Porcentaje IS NOT NULL
BEGIN
SELECT @Precio = dbo.fnDisminuyePorcentaje(@ArtPrecioSugerido, @Porcentaje)
IF @Precio IS NOT NULL
BEGIN
SET @ArtOfertaID = @OfertaID
UPDATE #VentaD SET PrecioSugerido = @Precio, OfertaID = @OfertaID WHERE Articulo = @Articulo AND Unidad = @ArtUnidad AND ISNULL(SubCuenta,'') = ISNULL(NULLIF(@SubCuenta,''),ISNULL(SubCuenta,''))
IF @OfertaAplicaLog = 1 AND @ArtOfertaID IS NOT NULL
BEGIN
SET @DescripcionOfertaLog = 'PRECIO = PRECIO (-) ' + CAST(@Porcentaje as varchar(20))+' %'
SET @Precio = CAST(ROUND(@Precio,dbo.fnRedondeoDecimales(@Empresa)) AS FLOAT)
EXEC spOfertaLog @OfertaID,@Tipo, @Forma, @Usar, @Articulo, @SubCuenta, @ArtUnidad, @Precio = @Precio, @Descripcion = @DescripcionOfertaLog 
END
END
END
IF @Usar = 'MARGEN' AND @Porcentaje IS NOT NULL AND (SELECT Tipo FROM Art WHERE Articulo = @Articulo) <> 'Juego'
BEGIN
IF NULLIF(@SubCuenta,'') IS NOT NULL AND @CfgCosteoNivelSubCuenta = 1
BEGIN
SELECT @ArtCostoBase = UltimoCosto
FROM ArtSubCosto
WHERE Articulo = @Articulo AND SubCuenta = @SubCuenta AND Empresa = @Empresa AND Sucursal = @Sucursal
END
ELSE IF NULLIF(@SubCuenta,'') IS NULL
BEGIN
SELECT @ArtCostoBase = UltimoCosto
FROM ArtCosto
WHERE Articulo = @Articulo AND Empresa = @Empresa AND Sucursal = @Sucursal
END
SELECT @Precio = dbo.fnPrecioMargen (@ArtCostoBase, @Porcentaje)
IF @Precio IS NOT NULL
BEGIN
SET @ArtOfertaID = @OfertaID
UPDATE #VentaD SET PrecioSugerido = @Precio, OfertaID = @OfertaID WHERE Articulo = @Articulo AND Unidad = @ArtUnidad AND ISNULL(SubCuenta,'') = ISNULL(NULLIF(@SubCuenta,''),ISNULL(SubCuenta,''))
IF @OfertaAplicaLog = 1 AND @ArtOfertaID IS NOT NULL
SET @DescripcionOfertaLog = 'PRECIO = (COSTO X 100 %)/(100% - ' + CAST(@Porcentaje as varchar(20))+'%)'
SET @Precio = CAST(ROUND(@Precio,dbo.fnRedondeoDecimales(@Empresa)) AS FLOAT)
EXEC spOfertaLog @OfertaID,@Tipo, @Forma, @Usar, @Articulo, @SubCuenta, @ArtUnidad, @Precio = @Precio, @Descripcion = @DescripcionOfertaLog 
END
END
IF  @Usar = 'PRECIO' AND @Precio IS NOT NULL AND (@ArtPrecio IS NULL OR @Precio < @ArtPrecio)
BEGIN
SELECT @ArtPrecio = @Precio, @ArtOfertaID = @OfertaID
IF @ArtPrecio IS NOT NULL
BEGIN
SET @ArtOfertaID = @OfertaID
UPDATE #VentaD SET PrecioSugerido = @Precio, OfertaID = @OfertaID WHERE Articulo = @Articulo AND Unidad = @ArtUnidad AND ISNULL(SubCuenta,'') = ISNULL(NULLIF(@SubCuenta,''),ISNULL(SubCuenta,''))
IF @OfertaAplicaLog = 1 AND @ArtOfertaID IS NOT NULL
EXEC spOfertaLog @OfertaID,@Tipo, @Forma, @Usar, @Articulo, @SubCuenta, @ArtUnidad, @Precio = @ArtPrecio
END
END
END
END
FETCH NEXT FROM crOfertaNormal INTO @OfertaID, @OfertaTipoCambio, @Tipo, @Forma, @Usar, @TieneVolumen, @Cantidad, @Porcentaje, @Precio, @Importe, @Obsequio, @Factor, @ListaPreciosEsp, @UnidadObsequio, @SubCuentaObsequio
END  
CLOSE crOfertaNormal
DEALLOCATE crOfertaNormal
RETURN
END
IF @Prioridad = 2
BEGIN
DECLARE crOfertaNormal CURSOR LOCAL FAST_FORWARD READ_ONLY FOR
SELECT ID, TipoCambio, Tipo, Forma, Usar, TieneVolumen, Cantidad, Porcentaje, Precio, Importe, Obsequio, UnidadObsequio, SubCuentaObsequio
FROM @OfertaNormal
WHERE Prioridad = 2
OPEN crOfertaNormal
FETCH NEXT FROM crOfertaNormal INTO @OfertaID, @OfertaTipoCambio, @Tipo, @Forma, @Usar, @TieneVolumen, @Cantidad, @Porcentaje, @Precio, @Importe, @Obsequio, @UnidadObsequio, @SubCuentaObsequio
WHILE @@FETCH_STATUS <> -1
BEGIN
IF @@FETCH_STATUS <> -2
BEGIN
IF (SELECT COUNT(DISTINCT ID) EXISTEN FROM OfertaD WHERE ID IN (SELECT ID FROM Oferta WHERE Estatus = 'VIGENTE' AND Prioridad = 2)) <= 1
SELECT @ArtPrecio = NULL, @ArtDescuento  = NULL, @ArtDescuentoImporte = NULL, @ArtPuntos = NULL, @ArtPuntosPorcentaje = NULL, @ArtComision = NULL, @ArtOfertaID = NULL
IF @TieneVolumen = 1
BEGIN
SELECT @Desde = NULL
SELECT @Desde = MIN(Desde)
FROM OfertaDVol
WHERE ID = @OfertaID AND Articulo = @Articulo AND @ArtCantidadTotal >= Desde AND @ArtCantidadTotal < Hasta
IF @Desde IS NOT NULL
SELECT @Cantidad = Cantidad, @Porcentaje = Porcentaje, @Precio = Precio, @Importe = Importe
FROM OfertaDVol
WHERE ID = @OfertaID AND Articulo = @Articulo AND Desde = @Desde
END
SELECT @Precio = NULLIF(@Precio, 0.0)*@OfertaTipoCambio/@TipoCambio,
@Importe = NULLIF(@Importe, 0.0)*@OfertaTipoCambio/@TipoCambio
IF @Forma = 'PUNTOS' /***** Se movieron las ofertas de Puntos a la Prioridad 2 para que puedan aplicar con otra oferta Normal *****/
BEGIN
IF @Usar = 'CANTIDAD' AND @Cantidad IS NOT NULL
BEGIN
IF (@ArtPuntos IS NULL OR @Cantidad > ISNULL(@ArtPuntos, 0)) AND EXISTS(SELECT * FROM #VentaD WHERE Articulo = @Articulo AND RenglonTipo <> 'C')
BEGIN
SET @CantidadArticulo = 0
SELECT @CantidadArticulo = Cantidad FROM #VentaD WHERE Articulo = @Articulo
IF (ISNULL(@TieneVolumen,0) > 0) AND EXISTS(SELECT Cantidad FROM OfertaDVol WHERE ID = @OfertaID AND @CantidadArticulo >= Desde AND @CantidadArticulo <= Hasta)
SELECT @Cantidad = Cantidad FROM OfertaDVol WHERE ID = @OfertaID AND @CantidadArticulo >= Desde AND @CantidadArticulo <= Hasta
SELECT @ArtPuntos = @Cantidad, @ArtOfertaID = @OfertaID
IF @ArtPuntos IS NOT NULL
BEGIN
IF @OfertaAplicaLog = 1 AND @ArtOfertaID IS NOT NULL
BEGIN
SET @DescripcionOfertaLog = 'PUNTOS = ' + CAST(@ArtPuntos as varchar(20)) + ' puntos X ' + CAST(@ArtUnidad as varchar(20))
SET @ArtPuntos =  @ArtPuntos * @CantidadArticulo
EXEC spOfertaLog @OfertaID,@Tipo, @Forma, @Usar, @Articulo, @SubCuenta, @ArtUnidad, @Puntos = @ArtPuntos, @Descripcion = @DescripcionOfertaLog
END
END
END
END ELSE
IF @Usar = 'PORCENTAJE' AND @Porcentaje IS NOT NULL
BEGIN
IF @ArtPuntosPorcentaje IS NULL OR @Porcentaje > @ArtPuntosPorcentaje
SELECT @ArtPuntosPorcentaje = @Porcentaje, @ArtOfertaID = @OfertaID
IF @ArtPuntosPorcentaje IS NOT NULL AND EXISTS(SELECT * FROM #VentaD WHERE Articulo = @Articulo AND RenglonTipo <> 'C')
BEGIN
IF @OfertaAplicaLog = 1 AND @ArtOfertaID IS NOT NULL
BEGIN
SELECT @ImporteVenta = SUM((ISNULL(ISNULL(Precio,PrecioSugerido),0))*ISNULL(Cantidad,0)) FROM #VentaD WHERE Articulo = @Articulo AND Unidad = @ArtUnidad AND ISNULL(SubCuenta,'') = ISNULL(ISNULL(@SubCuenta,SubCuenta),'')
SELECT @CantidadArticulo = Cantidad FROM #VentaD WHERE Articulo = @Articulo AND Unidad = @ArtUnidad AND ISNULL(SubCuenta,'') = ISNULL(NULLIF(@SubCuenta,''),ISNULL(SubCuenta,''))
SET @ArtPuntos = (@ArtPuntosPorcentaje/100) * @ImporteVenta
SET @DescripcionOfertaLog = 'PUNTOS = ' + CAST(@ArtPuntosPorcentaje as varchar(20)) + '% X $'+  CAST(@ImporteVenta as varchar(20))
EXEC spOfertaLog @OfertaID,@Tipo, @Forma, @Usar, @Articulo, @SubCuenta, @ArtUnidad, @Puntos = @ArtPuntos, @PuntosPorcentaje = @ArtPuntosPorcentaje, @Descripcion = @DescripcionOfertaLog
END
END
END
END ELSE
IF @Forma = 'PUNTOS/PRECIO' AND @PuntosPrecio = 1
BEGIN
IF ISNULL(@Precio,0.0) IS NOT NULL AND (@ArtPrecio IS NULL OR ISNULL(@Precio,0.0) < ISNULL(@ArtPrecio,0.0))
SELECT @ArtPrecio = ISNULL(@Precio,0.0), @ArtOfertaID = @OfertaID
IF @ArtPuntos IS NULL OR @Cantidad > @ArtPuntos
BEGIN
SELECT @ArtPuntos = @Cantidad *-1, @ArtOfertaID = @OfertaID
IF @OfertaAplicaLog = 1 AND @ArtOfertaID IS NOT NULL
EXEC spOfertaLog @OfertaID,@Tipo, @Forma, @Usar, @Articulo, @SubCuenta, @ArtUnidad, @Precio = @ArtPrecio, @Puntos = @ArtPuntos
END
END ELSE
IF @Forma = 'IMPORTE/PUNTOS' AND @PuntosPrecio = 1
BEGIN
IF @Precio IS NOT NULL AND (@ArtPrecio IS NULL OR @Precio < @ArtPrecio)
SELECT @ArtPrecio = @Precio, @ArtOfertaID = @OfertaID
IF @Usar = 'IMPORTE/CANTIDAD'
BEGIN
SELECT @ArtPuntos = 0.0,@ArtOfertaID = @OfertaID
IF @ArtPuntos IS NOT NULL 
BEGIN
IF @OfertaAplicaLog = 1 AND @ArtOfertaID IS NOT NULL
SET @DescripcionOfertaLog = 'PUNTOS = POR CADA $' + CAST(@ArtPrecio as varchar(20)) + ' TE REGALA '+  CAST(@ArtPuntos as varchar(20)) + ' PUNTOS'
IF EXISTS(SELECT * FROM #OfertaLog WHERE Articulo = @Articulo AND OfertaID = @OfertaID)
DELETE FROM #OfertaLog WHERE Articulo = @Articulo AND OfertaID = @OfertaID
EXEC spOfertaLog @OfertaID,@Tipo, @Forma, @Usar, @Articulo, @SubCuenta, @ArtUnidad, @Precio = @ArtPrecio, @Puntos = @ArtPuntos, @Descripcion = @DescripcionOfertaLog
END
END
IF @Usar =  'IMPORTE/PORCENTAJE'
BEGIN
SELECT @ArtPuntos = 0.0,@ArtOfertaID = @OfertaID
IF @ArtPuntos IS NOT NULL  
BEGIN
IF @OfertaAplicaLog = 1 AND @ArtOfertaID IS NOT NULL
SET @DescripcionOfertaLog = 'PUNTOS = POR CADA ' + CAST(@ArtPuntos as varchar(20)) + ' TE REGALA EL'+  CAST(@ArtPuntos as varchar(20)) + '% EN PUNTOS'
EXEC spOfertaLog @OfertaID,@Tipo, @Forma, @Usar, @Articulo, @SubCuenta, @ArtUnidad, @Precio = @ArtPrecio, @Puntos = @ArtPuntos, @Descripcion = @DescripcionOfertaLog
END
END
END ELSE
IF @Forma = 'DESCUENTO'
BEGIN
IF @Usar = 'PORCENTAJE' AND @Porcentaje IS NOT NULL AND ISNULL(@Cantidad,0) <= @ArtCantidadTotal
BEGIN
IF @ArtDescuento IS NULL OR @Porcentaje > @ArtDescuento
BEGIN
SELECT @ArtDescuento = @Porcentaje, @ArtOfertaID = @OfertaID
IF @OfertaAplicaLog = 1 AND @ArtOfertaID IS NOT NULL AND @ArtDescuento > 0 AND EXISTS (SELECT * FROM #VentaD WHERE Articulo = @Articulo AND ISNULL(NULLIF(Unidad,''), @ArtUnidad) = ISNULL(@ArtUnidad,'') AND ISNULL(NULLIF(SubCuenta,''), @SubCuenta) = ISNULL(@SubCuenta,'') AND RenglonTipo <> 'C')
BEGIN
SELECT @ImporteVenta = (SUM(CASE WHEN @CfgImpInc = 1 THEN ISNULL(Precio,ISNULL(PrecioSugerido,0)) / (1+(ISNULL(Impuesto1,0)/100))  ELSE ISNULL(Precio,ISNULL(PrecioSugerido,0)) END * ISNULL(Cantidad,0)))
FROM #VentaD
WHERE Articulo = @Articulo AND Unidad = @ArtUnidad AND ISNULL(SubCuenta,'') = ISNULL(ISNULL(@SubCuenta,SubCuenta),'') AND RenglonTipo NOT IN ('C')
SET @ImporteVenta = CAST(ROUND((@ImporteVenta * (@ArtDescuento / 100)),dbo.fnRedondeoDecimales(@Empresa)) AS FLOAT)
SET @DescripcionOfertaLog = 'Descuento = Importe (-) ' + CAST(@ArtDescuento as varchar(20))+' %'
EXEC spOfertaLog @OfertaID,@Tipo, @Forma, @Usar, @Articulo, @SubCuenta, @ArtUnidad, @Descuento = @ArtDescuento, @DescuentoImporte = @ImporteVenta, @Descripcion = @DescripcionOfertaLog
END
END
END ELSE
IF @Usar = 'IMPORTE' AND @Importe IS NOT NULL AND ISNULL(@Cantidad,0) <= ISNULL(@ArtCantidadTotal,0)
BEGIN
IF @ArtDescuentoImporte IS NULL OR @Importe > @ArtDescuentoImporte
BEGIN
SELECT @ArtDescuentoImporte = @Importe FROM #VentaD WHERE Articulo = @Articulo AND ISNULL(NULLIF(Unidad,''), @ArtUnidad) = ISNULL(@ArtUnidad,'') AND ISNULL(NULLIF(SubCuenta,''), @SubCuenta) = ISNULL(@SubCuenta,'') AND RenglonTipo <> 'C'
SELECT @ImporteVenta = (SUM(CASE WHEN @CfgImpInc = 1 THEN ISNULL(Precio,ISNULL(PrecioSugerido,0)) / (1+(ISNULL(Impuesto1,0)/100))  ELSE ISNULL(Precio,ISNULL(PrecioSugerido,0)) END * ISNULL(Cantidad,0)))
FROM #VentaD
WHERE Articulo = @Articulo AND Unidad = @ArtUnidad AND ISNULL(SubCuenta,'') = ISNULL(ISNULL(@SubCuenta,SubCuenta),'') AND RenglonTipo NOT IN ('C')
IF @ArtDescuentoImporte IS NOT NULL AND @ImporteVenta >= @ArtDescuentoImporte
BEGIN
SET @ArtOfertaID = @OfertaID
IF @OfertaAplicaLog = 1 AND @ArtOfertaID IS NOT NULL AND EXISTS (SELECT * FROM #VentaD WHERE Articulo = @Articulo AND ISNULL(NULLIF(Unidad,''), @ArtUnidad) = ISNULL(@ArtUnidad,'') AND ISNULL(NULLIF(SubCuenta,''), @SubCuenta) = ISNULL(@SubCuenta,'') AND RenglonTipo <> 'C')
BEGIN
SET @ArtDescuentoImporte = CAST(ROUND(@ArtDescuentoImporte,dbo.fnRedondeoDecimales(@Empresa)) AS FLOAT)
SET @DescripcionOfertaLog = 'Descuento = Importe (-) $' + CAST(@Importe as varchar(20))
SELECT @CantidadTemporal = Cantidad, @PrecioTemporal =  ISNULL(Precio,ISNULL(PrecioSugerido,0))
FROM #VentaD WHERE Articulo = @Articulo AND Unidad = @ArtUnidad AND ISNULL(SubCuenta,'') = ISNULL(ISNULL(@SubCuenta,SubCuenta),'') AND RenglonTipo NOT IN ('C')
SET @DesImporte = dbo.fnPorcentajeImporte(@CantidadTemporal*@PrecioTemporal, @ArtDescuentoImporte)
EXEC spOfertaLog @OfertaID,@Tipo, @Forma, @Usar, @Articulo, @SubCuenta, @ArtUnidad, @DescuentoImporte = @ArtDescuentoImporte, @Descuento = @DesImporte, @Descripcion = @DescripcionOfertaLog
SELECT @DesImporte = 0.0, @PrecioTemporal = 0.0, @CantidadTemporal = 0
END
END
ELSE
SET @ArtDescuentoImporte = NULL	 
END
END
END
END
FETCH NEXT FROM crOfertaNormal INTO @OfertaID, @OfertaTipoCambio, @Tipo, @Forma, @Usar, @TieneVolumen, @Cantidad, @Porcentaje, @Precio, @Importe, @Obsequio, @UnidadObsequio, @SubCuentaObsequio
END  
CLOSE crOfertaNormal
DEALLOCATE crOfertaNormal
RETURN
END
IF @Prioridad = 3
BEGIN
DECLARE crOfertaNormal CURSOR LOCAL FAST_FORWARD READ_ONLY FOR
SELECT ID, TipoCambio, Tipo, Forma, Usar, TieneVolumen, Cantidad, Porcentaje, Precio, Importe, Obsequio, UnidadObsequio, SubCuentaObsequio
FROM @OfertaNormal
WHERE Prioridad = 3
OPEN crOfertaNormal
FETCH NEXT FROM crOfertaNormal INTO @OfertaID, @OfertaTipoCambio, @Tipo, @Forma, @Usar, @TieneVolumen, @Cantidad, @Porcentaje, @Precio, @Importe, @Obsequio, @UnidadObsequio, @SubCuentaObsequio
WHILE @@FETCH_STATUS <> -1
BEGIN
IF @@FETCH_STATUS <> -2
BEGIN
IF (SELECT COUNT(DISTINCT ID) EXISTEN FROM OfertaD WHERE ID IN (SELECT ID FROM Oferta WHERE Estatus = 'VIGENTE' AND Prioridad = 3)) <= 1
SELECT @ArtPrecio = NULL, @ArtDescuento  = NULL, @ArtDescuentoImporte = NULL, @ArtPuntos = NULL, @ArtPuntosPorcentaje = NULL, @ArtComision = NULL, @ArtOfertaID = NULL
IF @TieneVolumen = 1
BEGIN
SELECT @Desde = NULL
SELECT @Desde = MIN(Desde)
FROM OfertaDVol
WHERE ID = @OfertaID AND Articulo = @Articulo AND @ArtCantidadTotal >= Desde AND @ArtCantidadTotal < Hasta
IF @Desde IS NOT NULL
SELECT @Cantidad = Cantidad, @Porcentaje = Porcentaje, @Precio = Precio, @Importe = Importe
FROM OfertaDVol
WHERE ID = @OfertaID AND Articulo = @Articulo AND Desde = @Desde
END
SELECT @Precio = NULLIF(@Precio, 0.0)*@OfertaTipoCambio/@TipoCambio,
@Importe = NULLIF(@Importe, 0.0)*@OfertaTipoCambio/@TipoCambio
IF @Forma = 'COMISION'
BEGIN
IF @Usar = 'IMPORTE' AND @Importe IS NOT NULL
BEGIN
IF @ArtComision IS NULL OR @Importe > @ArtComision
SELECT @ArtComision = @Importe, @ArtOfertaID = @OfertaID
IF @ArtComision IS NOT NULL
BEGIN
IF @OfertaAplicaLog = 1 AND @ArtOfertaID IS NOT NULL
EXEC spOfertaLog @OfertaID,@Tipo, @Forma, @Usar, @Articulo, @SubCuenta, @ArtUnidad, @Precio = @ArtPrecio, @Comision = @ArtComision
END
END ELSE
IF @Usar = 'PORCENTAJE' AND @Porcentaje IS NOT NULL
BEGIN
IF @ArtComisionPorcentaje IS NULL OR @Porcentaje > @ArtComisionPorcentaje
SELECT @ArtComisionPorcentaje = @Porcentaje, @ArtOfertaID = @OfertaID
IF @ArtComisionPorcentaje IS NOT NULL
BEGIN
IF @OfertaAplicaLog = 1 AND @ArtOfertaID IS NOT NULL
EXEC spOfertaLog @OfertaID,@Tipo, @Forma, @Usar, @Articulo, @SubCuenta, @ArtUnidad, @Precio = @ArtPrecio, @ComisionPorcentaje = @ArtComisionPorcentaje
END
END
END ELSE
IF @Forma = 'OBSEQUIO MISMO ARTICULO' AND ABS(@ArtCantidadTotal) >= @Cantidad
BEGIN
SELECT @a = 0
WHILE @a < CONVERT(int, ABS(@ArtCantidadTotal)) / CONVERT(int, @Cantidad)
BEGIN
DELETE #ArtObsequio WHERE Articulo = @Obsequio AND Unidad = @ArtUnidad AND ISNULL(SubCuenta,'') = ISNULL(NULLIF(@SubCuenta,''),ISNULL(SubCuenta,''))
DELETE #OfertaLog  WHERE OfertaId = @OfertaID AND ArticuloObsequio = @Obsequio AND UnidadObsequio = @ArtUnidad AND ISNULL(SubcuentaObsequio,ISNULL(@SubCuenta,'')) = ISNULL(@SubCuenta,'')
INSERT #ArtObsequio (Articulo, OfertaID, Unidad, SubCuenta) VALUES (@Articulo, @OfertaID, @ArtUnidad, @SubCuenta)
SELECT @a = @a + 1,@ArtOfertaID = @OfertaID
IF @OfertaAplicaLog = 1 AND @OfertaID IS NOT NULL
BEGIN
SELECT @DescripcionArtObsequio = a.Descripcion1
FROM art a
JOIN #ArtObsequio o ON a.Articulo = o.Articulo
WHERE a.articulo = @Articulo
IF @SubCuenta IS NULL OR @SubCuenta = ''
SET @DescripcionOfertaLog = 'OBSEQUIO MISMO ARTSCULO = ARTSCULO OBSEQUIO - ' + @DescripcionArtObsequio
ELSE
SET @DescripcionOfertaLog = 'OBSEQUIO MISMO ARTSCULO = ARTSCULO OBSEQUIO - ' + @DescripcionArtObsequio + ', OPCI將 OBSEQUIO - ' + @SubCuenta
EXEC spOfertaLog @OfertaID,@Tipo, @Forma, @Usar, @Articulo, @SubCuenta, @ArtUnidad, @ArtCantidadTotal = 1, @ArticuloObsequio = @Articulo, @UnidadObsequio = @ArtUnidad, @SubCuentaObsequio = @SubCuenta, @Descripcion = @DescripcionOfertaLog 
END
END
END ELSE
IF @Forma = 'OBSEQUIO OTRO ARTICULO' AND ABS(@ArtCantidadTotal) >= @Cantidad AND @Obsequio IS NOT NULL
BEGIN
SELECT @RestaComponente = Cantidad FROM #VentaD WHERE Articulo = @Articulo AND RenglonTipo = 'C'
IF @RestaComponente IS NOT NULL	SET @ArtCantidadTotal = @ArtCantidadTotal - @RestaComponente
SELECT @a = 0
WHILE @a < CONVERT(int, ABS(@ArtCantidadTotal)) / CONVERT(int, @Cantidad)
BEGIN
INSERT #ArtObsequio (Articulo, OfertaID, Unidad, SubCuenta) VALUES (@Obsequio, @OfertaID, @UnidadObsequio, @SubCuentaObsequio)
SELECT @ArtOfertaID = @OfertaID
SELECT @a = @a + 1
END
SELECT @ArtCantidadTotalObsequio = Cantidad
FROM #VentaD
WHERE articulo = @Obsequio AND Unidad = @UnidadObsequio AND ISNULL(Subcuenta,ISNULL(@SubCuentaObsequio,'')) = ISNULL(@SubCuentaObsequio,'')
IF @OfertaAplicaLog = 1 AND @ArtOfertaID IS NOT NULL AND @ArtCantidadTotalObsequio >= 1
BEGIN
IF @a < @ArtCantidadTotalObsequio
SET @ArtCantidadTotalObsequio = @a
ELSE
SET @ArtCantidadTotalObsequio = @ArtCantidadTotalObsequio
SELECT @DescripcionArtObsequio = Descripcion1 FROM ART WHERE articulo = @Obsequio
IF @SubCuentaObsequio IS NOT NULL AND @SubCuentaObsequio <> ''
SET @DescripcionOfertaLog = 'OBSEQUIO OTRO ARTSCULO = ' + @DescripcionArtObsequio + ', OPCI將 OBSEQUIO - ' + @SubCuentaObsequio
ELSE
SET @DescripcionOfertaLog = 'OBSEQUIO OTRO ARTSCULO = ' + @DescripcionArtObsequio
EXEC spOfertaLog @OfertaID,@Tipo, @Forma, @Usar, @Articulo, @SubCuenta, @ArtUnidad, @ArtCantidadTotal = @ArtCantidadTotalObsequio, @ArticuloObsequio = @Obsequio, @UnidadObsequio = @UnidadObsequio, @SubCuentaObsequio = @SubCuentaObsequio, @Descripcion = @DescripcionOfertaLog 
END
END ELSE
IF @Forma = 'PRECIO SIMILAR' 
BEGIN
SELECT @a = 0
SET @ObsequiosTotales = CONVERT(int, ABS(@ArtCantidadTotal)) / CONVERT(int, @Cantidad)
WHILE @a < ISNULL(@ObsequiosTotales,0)
BEGIN
SET @Obsequio = ''
SELECT @PrecioVenta = PrecioSugerido
FROM #VentaD
WHERE Articulo = @Articulo
AND ISNULL(SubCuenta, '') = ISNULL(@SubCuenta,'')
AND Unidad = @ArtUnidad
SELECT @CantidadObsequiosVtaD = COUNT(*) FROM #ArtObsequio
IF @CantidadObsequiosVtaD >= @ObsequiosTotales
BEGIN
SET @a = @ObsequiosTotales
END
IF @CantidadObsequiosVtaD <= @ObsequiosTotales
BEGIN
SELECT TOP 1 @Obsequio = d.Articulo, @SubCuentaObsequio = d.SubCuenta, @UnidadObsequio = d.Unidad, @CantidadArt = d.Cantidad
FROM #VentaD d
WHERE (ISNULL(d.Articulo,'')+ISNULL(d.SubCuenta,'')) <> (ISNULL(@Articulo,'')+ISNULL(@SubCuenta,'')) 
AND d.PrecioSugerido <= ISNULL(@PrecioVenta,0) AND d.Cantidad > ISNULL(d.CantidadObsequio,0) 
AND d.RenglonTipo <> 'C'
AND d.Cantidad >= ((SELECT COUNT(*) FROM #ArtObsequio WHERE Articulo = d.Articulo)+@ObsequiosTotales)
ORDER BY d.PrecioSugerido DESC
IF @CantidadArt >= @ObsequiosTotales AND ISNULL(@Obsequio,'') <> ''
BEGIN
SELECT @ArtOfertaID = @OfertaID 
SET @Contador = 0
IF (@CantidadArt >= @ObsequiosTotales) AND (@CantidadArt >= @CantidadObsequiosVtaD)
BEGIN
SET @ObsequiosTotales = @ObsequiosTotales - @CantidadObsequiosVtaD
IF (@ObsequiosTotales = 0) AND (@Obsequio IS NOT NULL) 
SET @ObsequiosTotales = @CantidadObsequiosVtaD
END
WHILE  @Contador < @ObsequiosTotales
BEGIN
IF (SELECT SUM(Cantidad) FROM #VentaD WHERE Articulo = @Obsequio AND Unidad = @UnidadObsequio AND SubCuenta = @SubCuentaObsequio) >= @ObsequiosTotales
BEGIN
INSERT #ArtObsequio (Articulo, OfertaID, Unidad, SubCuenta) VALUES (@Obsequio, @OfertaID, @UnidadObsequio, @SubCuentaObsequio) 
SET @Contador = @Contador + 1
END
END
SET @a = @ObsequiosTotales
IF @OfertaAplicaLog = 1 AND @ArtOfertaID IS NOT NULL AND @Obsequio <> ''
BEGIN
SELECT @DescripcionArtObsequio = Descripcion1 FROM ART WHERE articulo = @Obsequio
IF @SubCuentaObsequio IS NOT NULL OR @SubCuentaObsequio = ''
SET @DescripcionOfertaLog = 'PRECIO SIMILAR = ARTSCULO OBSEQUIO (' + @DescripcionArtObsequio + '), OPCI將 OBSEQUIO - ' + @SubCuentaObsequio
ELSE
SET @DescripcionOfertaLog = 'PRECIO SIMILAR = ARTSCULO OBSEQUIO (' + @DescripcionArtObsequio +')'
EXEC spOfertaLog @OfertaID,@Tipo, @Forma, @Usar, @Articulo, @SubCuenta, @ArtUnidad, @ArtCantidadTotal = @ObsequiosTotales, @ArticuloObsequio = @Obsequio, @UnidadObsequio = @UnidadObsequio, @SubCuentaObsequio = @SubCuentaObsequio, @Descripcion = @DescripcionOfertaLog 
END
END
ELSE
BEGIN
SET @a = @ObsequiosTotales
END
END
ELSE IF (@CantidadObsequiosVtaD > @ObsequiosTotales)
BEGIN
SELECT TOP 1 @Obsequio = d.Articulo, @SubCuentaObsequio = d.SubCuenta, @UnidadObsequio = d.Unidad, @CantidadArt = d.Cantidad
FROM #VentaD d
WHERE (ISNULL(d.Articulo,'')+ISNULL(d.SubCuenta,'')) <> (ISNULL(@Articulo,'')+ISNULL(@SubCuenta,'')) 
AND d.PrecioSugerido <= ISNULL(@PrecioVenta,0) AND d.Cantidad > ISNULL(d.CantidadObsequio,0) 
AND d.RenglonTipo <> 'C'
AND d.Cantidad >= ((SELECT COUNT(*) FROM #ArtObsequio WHERE Articulo = d.Articulo)+@ObsequiosTotales)
ORDER BY d.PrecioSugerido DESC
SELECT @CantidadObsequiosVtaD = COUNT(*) FROM #ArtObsequio
SELECT @ArtOfertaID = @OfertaID 
SET @Contador = 0
IF (@CantidadArt >= @ObsequiosTotales) AND (@CantidadArt >= @CantidadObsequiosVtaD)
BEGIN
SET @CantidadArt = @ObsequiosTotales - @CantidadObsequiosVtaD
IF (@CantidadArt < 0) AND (@Obsequio IS NOT NULL) 
SET @CantidadArt = @ObsequiosTotales
WHILE  @Contador < @CantidadArt
BEGIN
INSERT #ArtObsequio (Articulo, OfertaID, Unidad, SubCuenta) VALUES (@Obsequio, @OfertaID, @UnidadObsequio, @SubCuentaObsequio)
SET @Contador = @Contador + 1
END
SET @a = @CantidadArt
IF @OfertaAplicaLog = 1 AND @ArtOfertaID IS NOT NULL AND @Obsequio <> '' AND @CantidadArt > 0
BEGIN
SELECT @DescripcionArtObsequio = Descripcion1 FROM ART WHERE articulo = @Obsequio
IF @SubCuentaObsequio IS NOT NULL OR @SubCuentaObsequio = ''
SET @DescripcionOfertaLog = 'PRECIO SIMILAR = ARTSCULO OBSEQUIO (' + @DescripcionArtObsequio + '), OPCI將 OBSEQUIO - ' + @SubCuentaObsequio
ELSE
SET @DescripcionOfertaLog = 'PRECIO SIMILAR = ARTSCULO OBSEQUIO (' + @DescripcionArtObsequio +')'
EXEC spOfertaLog @OfertaID,@Tipo, @Forma, @Usar, @Articulo, @SubCuenta, @ArtUnidad, @ArtCantidadTotal = @CantidadArt, @ArticuloObsequio = @Obsequio, @UnidadObsequio = @UnidadObsequio, @SubCuentaObsequio = @SubCuentaObsequio, @Descripcion = @DescripcionOfertaLog 
END
END
END
END
UPDATE #VentaD SET CantidadObsequio = NULL
END ELSE
IF @Forma = 'DESCUENTO CASCADA' AND @ArtCantidadTotal >= ISNULL(@Cantidad,0)
BEGIN
SELECT @ArtDescuento = 0.00, @ArtOfertaID = NULL
IF @ArtCantidadTotal >= ISNULL(@Cantidad,0)
BEGIN
SELECT @ArtDescuento = MAX(Porcentaje),@ArtOfertaID = @OfertaID
FROM OfertaDVol
WHERE Articulo = @Articulo AND Desde <= @ArtCantidadTotal AND ID = @OfertaID
IF ISNULL(@ArtDescuento,0.00) <> 0.00 
SELECT @ArtOfertaID = @OfertaID
IF ISNULL(@ArtDescuento,0.00) = 0.00 
SELECT @ArtOfertaID=NULL,@ArtDescuento = 0.00
SELECT @ArtTipo = Tipo FROM Art WHERE Articulo = @Articulo
IF @ArtTipo = 'Juego'
BEGIN
IF EXISTS(SELECT * FROM ArtJuego WHERE Articulo = @Articulo AND PrecioIndependiente = 1)
SELECT @ArtDescuento = NULL,@ArtOfertaID = NULL
END
IF @OfertaAplicaLog = 1 AND @ArtOfertaID IS NOT NULL AND @ArtTipo <> 'Juego' AND @ArtDescuento IS NOT NULL
EXEC spOfertaLog @OfertaID,@Tipo, @Forma, @Usar, @Articulo, @SubCuenta, @ArtUnidad, @Descuento = @ArtDescuento
END
END ELSE
IF @Forma = 'MISMO ARTICULO POR MONTO' AND @ArtCantidadTotal >= @Cantidad
BEGIN
SELECT @ImporteVenta = SUM(CASE WHEN @CfgImpInc = 1 THEN ISNULL(PrecioSugerido,0) / (1+(ISNULL(Impuesto1,0)/100))  ELSE ISNULL(PrecioSugerido,0) END * ISNULL(Cantidad,0)) FROM #VentaD WHERE Articulo = @Articulo AND ISNULL(SubCuenta,'') = ISNULL(NULLIF(@SubCuenta,''),ISNULL(SubCuenta,'')) AND Unidad = @ArtUnidad
SELECT @a = 0
WHILE @a < Convert(int,@ArtCantidadTotal)/Convert(int,@Cantidad) AND @ImporteVenta >= @Importe
BEGIN
INSERT #ArtObsequio (Articulo, OfertaID, Unidad, SubCuenta) VALUES (@Articulo, @OfertaID, @ArtUnidad, @SubCuenta)
SELECT @ArtOfertaID = @OfertaID
IF @OfertaAplicaLog = 1 AND @ArtOfertaID IS NOT NULL
BEGIN
SELECT @DescripcionArtObsequio = Descripcion1 FROM ART WHERE articulo = @Articulo
IF @SubCuenta IS NULL OR @SubCuenta = ''
BEGIN
SET @DescripcionOfertaLog = 'MISMO ARTICULO POR MONTO = ARTSCULO OBSEQUIO - ' + @DescripcionArtObsequio
END
ELSE
BEGIN
SET @DescripcionOfertaLog = 'MISMO ARTICULO POR MONTO = ARTSCULO OBSEQUIO - ' + @DescripcionArtObsequio + ', OPCI將 OBSEQUIO - ' + @SubCuenta
END
EXEC spOfertaLog @OfertaID,@Tipo, @Forma, @Usar, @Articulo, @SubCuenta, @ArtUnidad, @ArtCantidadTotal = 1, @ArticuloObsequio = @Articulo, @SubCuentaObsequio = @SubCuenta, @UnidadObsequio = @ArtUnidad, @Descripcion = @DescripcionOfertaLog
END
SELECT @a = @a + 1
END
END ELSE
IF @Forma = 'OTRO ARTICULO POR MONTO' AND @ArtCantidadTotal >= @Cantidad AND @Obsequio IS NOT NULL
BEGIN
SELECT @ImporteVenta = SUM((ISNULL(CASE WHEN @CfgImpInc = 1 THEN ISNULL(PrecioSugerido,0) / (1+(ISNULL(Impuesto1,0)/100))  ELSE ISNULL(PrecioSugerido,0) END,0)- (ISNULL(CASE WHEN @CfgImpInc = 1 THEN ISNULL(PrecioSugerido,0) / (1+(ISNULL(Impuesto1,0)/100))  ELSE ISNULL(PrecioSugerido,0) END,0) * ISNULL(Descuento/100,0))) * ISNULL(Cantidad,0)) FROM #VentaD WHERE Articulo = @Articulo AND ISNULL(SubCuenta,'') = ISNULL(NULLIF(@SubCuenta,''),ISNULL(SubCuenta,'')) AND Unidad = @ArtUnidad
SET @a = 0
WHILE @a < CONVERT(INT, (@ArtCantidadTotal/@Cantidad)) AND @ImporteVenta >= @Importe
BEGIN
INSERT #ArtObsequio (Articulo, OfertaID, Unidad, SubCuenta) VALUES (@Obsequio, @OfertaID, @UnidadObsequio, @SubCuentaObsequio)
SELECT @a = @a + 1
END
DECLARE
@c_Articulo	          varchar(20),
@c_SubCuenta	        varchar(50),
@c_Unidad	            varchar(50),
@c_obsequio	          varchar(20),
@c_SubCuentaObsequio  varchar(50),
@c_UnidadObsequio     varchar(50)
DECLARE ofertaV_cursor CURSOR FOR
SELECT DISTINCT d.Articulo, d.SUBCUENTA, d.Unidad, o.obsequio, o.SubCuentaObsequio, o.UnidadObsequio
FROM OfertaD o
JOIN #VentaD d ON d.Articulo = o.Articulo AND ISNULL(d.SubCuenta, '') = ISNULL(o.SubCuenta, '') AND d.Unidad = o.Unidad
WHERE o.ID = @OfertaID
OPEN ofertaV_cursor
FETCH NEXT FROM ofertaV_cursor INTO @c_Articulo, @c_SubCuenta, @c_Unidad, @c_obsequio, @c_SubCuentaObsequio, @c_UnidadObsequio
WHILE @@FETCH_STATUS = 0
BEGIN
IF EXISTS(SELECT rid FROM #ventad WHERE articulo = @c_Articulo AND  ISNULL(SubCuenta, '') = ISNULL(@c_SubCuenta, '') AND unidad = @c_Unidad)
AND EXISTS(SELECT rid FROM #ventad WHERE articulo = @Obsequio AND  ISNULL(SubCuenta, '') = ISNULL(@c_SubCuentaObsequio, '') AND unidad = @c_UnidadObsequio)
AND @ImporteVenta >= @Importe
BEGIN
SELECT @ArtOfertaID = @OfertaID
IF @OfertaAplicaLog = 1 AND @ArtOfertaID IS NOT NULL
BEGIN
SELECT @DescripcionArtObsequio = Descripcion1 FROM ART WHERE articulo = @Obsequio
SELECT @cantidadTotal = SUM(cantidad) FROM #ventad WHERE articulo = @Obsequio AND ISNULL(SubCuenta, '') = ISNULL(@SubCuentaObsequio, '') AND unidad = @UnidadObsequio
IF  @cantidadTotal <= @a
SET @cantidadTotal = @cantidadTotal
ELSE
SET @cantidadTotal = @a
IF @SubCuentaObsequio IS NULL OR @SubCuentaObsequio = ''
BEGIN
SET @DescripcionOfertaLog = 'OTRO ARTSCULO POR MONTO = MONTO MSNIMO $'+  CAST(@Importe as varchar(20)) + ', ARTSCULO OBSEQUIO - ' + @DescripcionArtObsequio
END ELSE
BEGIN
SET @DescripcionOfertaLog = 'OTRO ARTSCULO POR MONTO = MONTO MSNIMO $'+  CAST(@Importe as varchar(20))  + ', ARTSCULO OBSEQUIO - ' + @DescripcionArtObsequio + ', OPCI將 OBSEQUIO - ' + @SubCuentaObsequio
END
EXEC spOfertaLog @OfertaID, @Tipo, @Forma, @Usar, @Articulo, @SubCuenta, @ArtUnidad, @ArtCantidadTotal = @cantidadTotal, @ArticuloObsequio = @Obsequio, @SubCuentaObsequio =  @SubCuentaObsequio, @UnidadObsequio = @UnidadObsequio, @Descripcion = @DescripcionOfertaLog
END
END
FETCH NEXT FROM ofertaV_cursor INTO @c_Articulo, @c_SubCuenta, @c_Unidad, @c_obsequio, @c_SubCuentaObsequio, @c_UnidadObsequio
END
CLOSE ofertaV_cursor
DEALLOCATE ofertaV_cursor
END ELSE
IF @Forma = 'DESCUENTO COMBINADO' 
BEGIN
INSERT @TabOferta
SELECT d.articulo, ISNULL(d.SubCuenta,''), d.Unidad, d.Cantidad FROM Oferta o JOIN OfertaD d ON(o.ID=d.ID) WHERE o.ID = @OfertaID ORDER BY d.articulo asc
SELECT @TotalArtOferta = COUNT(articulo) FROM @TabOferta
INSERT @TabVenta
SELECT articulo,ISNULL(SubCuenta,''), Unidad, SUM(Cantidad) FROM #VentaD GROUP BY articulo,SubCuenta,Unidad ORDER BY articulo ASC
SELECT @ArtAplicados = COUNT(*) FROM @TabOferta T1
INNER JOIN @TabVenta T2 ON T1.Articulo = T2.Articulo AND ISNULL(T1.SubCuenta,'') = ISNULL(T2.SubCuenta,'') AND T1.Unidad = T2.Unidad WHERE T1.Cantidad <= T2.Cantidad
IF (@TotalArtOferta = @ArtAplicados)
BEGIN
SELECT @ArtDescuento = Porcentaje FROM Oferta WHERE ID = @OfertaID
IF @ArtCantidadTotal >= @Cantidad AND @ArtDescuento > 0
BEGIN
SELECT @ArtDescuento = Porcentaje FROM Oferta WHERE ID = @OfertaID
SET @ArtOfertaID = @OfertaID
IF @OfertaAplicaLog = 1 AND @ArtOfertaID IS NOT NULL
BEGIN
SELECT @ImporteVenta = (SUM(CASE WHEN @CfgImpInc = 1 THEN ISNULL(Precio,ISNULL(PrecioSugerido,0)) / (1+(ISNULL(Impuesto1,0)/100)) ELSE ISNULL(Precio,ISNULL(PrecioSugerido,0)) END * ISNULL(Cantidad,0)))
FROM #VentaD WHERE Articulo = @Articulo AND Unidad = @ArtUnidad AND ISNULL(SubCuenta,'') = ISNULL(ISNULL(@SubCuenta,SubCuenta),'') AND RenglonTipo NOT IN ('C')
SET @ImporteVenta = CAST(ROUND((@ImporteVenta * (@ArtDescuento / 100)),dbo.fnRedondeoDecimales(@Empresa)) AS FLOAT)
SET @DescripcionOfertaLog = 'A partir de cantidad: ' + CAST(@Cantidad as varchar(20)) +', Descuento aplicado '+ CAST(@ArtDescuento as varchar(20)) + ' %.'
EXEC spOfertaLog @OfertaID,@Tipo, @Forma, @Usar, @Articulo, @SubCuenta, @ArtUnidad, @Descuento = @ArtDescuento, @DescuentoImporte = @ImporteVenta, @Descripcion = @DescripcionOfertaLog
END
END
END
ELSE
BEGIN
RETURN
END
END ELSE
IF @Forma = 'DESCUENTO COMBINADO IMPORTE'
BEGIN
INSERT @TabVentaImporte
SELECT v.articulo, v.subcuenta ,v.unidad, (SUM(CASE WHEN @CfgImpInc = 1 THEN ISNULL(v.Precio,ISNULL(v.PrecioSugerido,0)) / (1+(ISNULL(v.Impuesto1,0)/100)) ELSE ISNULL(v.Precio,ISNULL(v.PrecioSugerido,0)) END * ISNULL(v.Cantidad,0)))
FROM Oferta o
JOIN OfertaD d ON(o.ID=d.ID)
JOIN #VentaD v ON d.Articulo = v.Articulo AND d.Unidad = v.Unidad AND ISNULL(v.SubCuenta,ISNULL(d.SubCuenta,'')) = ISNULL(d.SubCuenta,'')
WHERE o.ID = @OfertaID AND v.RenglonTipo NOT IN ('C')
GROUP BY v.articulo, v.subcuenta ,v.unidad
SELECT @ArtAplicadosDCI = COUNT(*)
FROM Oferta o
INNER JOIN OfertaD T1 ON(o.ID=T1.ID)
INNER JOIN @TabVentaImporte T2 ON T1.Articulo = T2.Articulo AND ISNULL(T1.SubCuenta,'') = ISNULL(T2.SubCuenta,'') AND T1.Unidad = T2.Unidad
WHERE o.ID = @OfertaID AND T1.Importe <= T2.TotalImpote
SET @TotalArticulosOferta = (SELECT count(*) FROM OfertaD d JOIN Oferta o ON d.ID = o.ID WHERE o.ID = @OfertaID)
IF(@ArtAplicadosDCI = @TotalArticulosOferta)
BEGIN
INSERT @TabDescuentos
SELECT v.Articulo, v.DescuentoP1, v.DescuentoP2, ISNULL(ISNULL(v.Precio,v.PrecioSugerido),0), SUM(v.Cantidad), v.Impuesto1, v.DescuentoImporte
FROM #VentaD v
JOIN OfertaD d ON v.Articulo = d.Articulo AND v.Unidad = d.Unidad AND ISNULL(v.SubCuenta,ISNULL(d.SubCuenta,'')) = ISNULL(d.SubCuenta,'')
JOIN Oferta o ON d.ID = o.ID
WHERE o.ID = @OfertaID AND v.RenglonTipo NOT IN ('C')
GROUP BY v.Articulo, v.DescuentoP1, v.DescuentoP2, ISNULL(ISNULL(v.Precio,v.PrecioSugerido),0), v.Impuesto1, v.DescuentoImporte
IF EXISTS(SELECT DescuentoP2 FROM @TabDescuentos WHERE DescuentoP2 > 0.0) OR EXISTS(SELECT DescuentoImporte FROM @TabDescuentos WHERE DescuentoImporte > 0)
BEGIN
SELECT @DescImporteTemporal = DescuentoImporte, @CantidadTemporal = Cantidad, @PrecioTemporal =  CASE WHEN @CfgImpInc = 1 THEN ISNULL(Precio,0) / (1+(ISNULL(Impuesto,0)/100))  ELSE ISNULL(Precio,0) END FROM @TabDescuentos WHERE DescuentoImporte > 0
IF (ISNULL(@DescImporteTemporal,0)) >0
BEGIN
SET @PorcentajeImporte = CAST(dbo.fnPorcentajeImporte(@CantidadTemporal*@PrecioTemporal, @DescImporteTemporal) AS DECIMAL(4,2))
SELECT @ArticuloImporte = Articulo, @CantidadTemporal = Cantidad FROM @TabDescuentos WHERE DescuentoImporte > 0
IF EXISTS(SELECT DescuentoP2 FROM @TabDescuentos WHERE ISNULL(DescuentoP2,0) = 0 AND Articulo = @Articulo)
BEGIN
UPDATE #VentaD SET DescuentoP2 = @PorcentajeImporte, DescuentoImporte = NULL
WHERE Articulo = CASE
WHEN @ArticuloImporte = @Articulo THEN @Articulo
WHEN @ArticuloImporte <> @Articulo THEN @ArticuloImporte END
AND RenglonTipo NOT IN ('C')
IF @OfertaAplicaLog = 1
BEGIN
SET @ImporteOferta = CAST(ROUND(@ImporteOferta,dbo.fnRedondeoDecimales(@Empresa)) AS FLOAT)
EXEC spOfertaLog @OfertaID,@Tipo, @Forma, @Usar, @Articulo, @SubCuenta, @ArtUnidad, @Descuento = @ArtDescuento, @DescuentoImporte = @ImporteOferta, @DescuentoP2 = @PorcentajeImporte
END
END
SELECT @PrecioTemporal = CASE WHEN @CfgImpInc = 1 THEN ISNULL(Precio,ISNULL(PrecioSugerido,0)) / (1+(ISNULL(Impuesto1,0)/100))  ELSE ISNULL(Precio,ISNULL(PrecioSugerido,0)) END
FROM #VentaD WHERE Articulo = @Articulo	AND RenglonTipo NOT IN ('C')
SET @ImporteTemporal = dbo.fnDisminuyePorcentaje(@CantidadTemporal*@PrecioTemporal, @PorcentajeImporte)
SET @ImporteVenta = @ImporteTemporal
END ELSE
BEGIN
SELECT @ArticuloDesc = Articulo, @CantidadTemporal = Cantidad, @DescuentoEnP2 = DescuentoP2 FROM @TabDescuentos WHERE DescuentoP2 > 0
SELECT @PrecioTemporal = CASE WHEN @CfgImpInc = 1 THEN ISNULL(Precio,ISNULL(PrecioSugerido,0)) / (1+(ISNULL(Impuesto1,0)/100))  ELSE ISNULL(Precio,ISNULL(PrecioSugerido,0)) END
FROM #VentaD WHERE Articulo = CASE
WHEN @ArticuloDesc = @Articulo THEN @Articulo
WHEN @ArticuloDesc <> @Articulo THEN @ArticuloDesc END
AND RenglonTipo NOT IN ('C')
SET @ImporteTemporal = dbo.fnDisminuyePorcentaje(@CantidadTemporal*@PrecioTemporal, @DescuentoEnP2)
SELECT @ImporteVenta = @ImporteTemporal
END
END
IF (@ImporteTemporal IS NOT NULL AND @ArticuloDesc = @Articulo) OR (@ImporteTemporal IS NOT NULL AND @ArticuloDesc IS NULL)
BEGIN
SELECT @ImporteVenta = ISNULL(@ImporteTemporal,0) + (ISNULL(ISNULL(vd.Precio,vd.PrecioSugerido),0) / (1+(ISNULL(vd.Impuesto1,0)/100)))*ISNULL(vd.Cantidad,0)
FROM #VentaD vd
JOIN OfertaD od ON vd.Articulo = od.Articulo
WHERE od.ID = @OfertaID AND vd.Articulo = od.Articulo AND vd.Articulo <> @Articulo AND od.Articulo <> @Articulo AND ISNULL(vd.SubCuenta,'') = ISNULL(ISNULL(@SubCuenta,vd.SubCuenta),'') AND vd.RenglonTipo NOT IN ('C')
SELECT @ImporteOferta = SUM(ISNULL(d.Importe,0)), @Porcentaje = MAX(ISNULL(o.Porcentaje,0))
FROM Oferta o
JOIN OfertaD d ON o.ID = d.ID
LEFT JOIN #VentaD vd ON d.Articulo = vd.Articulo
WHERE o.ID = @OfertaID AND d.Unidad = vd.Unidad AND ISNULL(d.SubCuenta,'') = ISNULL(ISNULL(@SubCuenta,d.SubCuenta),'') AND vd.RenglonTipo NOT IN ('C')
END
ELSE IF (@ImporteTemporal IS NOT NULL) AND (@ArticuloDesc <> @Articulo)
BEGIN
SELECT @ImporteVenta = ISNULL(@ImporteTemporal,0) + (ISNULL(ISNULL(vd.Precio,vd.PrecioSugerido),0) / (1+(ISNULL(vd.Impuesto1,0)/100)))*ISNULL(vd.Cantidad,0)
FROM #VentaD vd
JOIN OfertaD od ON vd.Articulo = od.Articulo
WHERE od.ID = @OfertaID AND vd.Articulo = od.Articulo AND vd.Articulo = @Articulo AND od.Articulo = @Articulo
AND od.Unidad = vd.Unidad AND ISNULL(vd.SubCuenta,'') = ISNULL(ISNULL(@SubCuenta,vd.SubCuenta),'') AND vd.RenglonTipo NOT IN ('C')
SELECT @ImporteOferta = SUM(ISNULL(d.Importe,0)), @Porcentaje = MAX(ISNULL(o.Porcentaje,0))
FROM Oferta o
JOIN OfertaD d ON o.ID = d.ID
LEFT JOIN #VentaD vd ON d.Articulo = vd.Articulo
WHERE o.ID = @OfertaID AND d.Unidad = vd.Unidad AND ISNULL(d.SubCuenta,'') = ISNULL(ISNULL(@SubCuenta,d.SubCuenta),'') AND vd.RenglonTipo NOT IN ('C')
END
ELSE IF (@ImporteTemporal IS NULL)
BEGIN
SELECT @ImporteVenta = (SUM(CASE WHEN @CfgImpInc = 1 THEN ISNULL(Precio,ISNULL(PrecioSugerido,0)) / (1+(ISNULL(Impuesto1,0)/100))  ELSE ISNULL(Precio,ISNULL(PrecioSugerido,0)) END * ISNULL(Cantidad,0)))
FROM #VentaD WHERE Articulo = @Articulo AND Unidad = @ArtUnidad AND ISNULL(SubCuenta,'') = ISNULL(ISNULL(@SubCuenta,SubCuenta),'') AND RenglonTipo NOT IN ('C')
SELECT @ImporteOferta = SUM(ISNULL(d.Importe,0)), @Porcentaje = MAX(ISNULL(o.Porcentaje,0))
FROM Oferta o JOIN OfertaD d ON o.ID = d.ID
WHERE o.ID = @OfertaID AND d.Articulo = @Articulo
AND d.Unidad = @ArtUnidad
AND ISNULL(d.SubCuenta,'') = ISNULL(ISNULL(@SubCuenta,d.SubCuenta),'')
END
IF @ImporteVenta>=@ImporteOferta AND ISNULL(@Porcentaje,0)>0
BEGIN
IF @OfertaAplicaLog = 1
BEGIN
SELECT @ArtDescuento = @Porcentaje
SET @ImporteVenta = (@ImporteVenta * (@ArtDescuento / 100))
SET @ImporteVenta = CAST(ROUND(@ImporteVenta,dbo.fnRedondeoDecimales(@Empresa)) AS FLOAT)
SET @DescripcionOfertaLog = 'A partir del Importe: $' + CAST(@Importe as varchar(20)) +', Descuento aplicado: '+ CAST(@ArtDescuento as varchar(20)) + ' %.'
EXEC spOfertaLog @OfertaID,@Tipo, @Forma, @Usar, @Articulo, @SubCuenta, @ArtUnidad, @Descuento = @Porcentaje, @DescuentoImporte = @ImporteVenta, @DescuentoP2 = @Porcentaje, @Descripcion = @DescripcionOfertaLog
END
END
END
ELSE
BEGIN
RETURN
END
END ELSE
IF @Forma = 'OBSEQUIO COMBINADO' AND @ArtCantidadTotal >= @Cantidad 
BEGIN
SELECT  @Obsequio = o.Obsequio,
@CantidadObsequio = o.CantidadObsequio,
@CantidadOferta = SUM(CASE WHEN d.Cantidad <=ISNULL(v.Cantidad,0) THEN 1 ELSE -99999 END),
@UnidadObsequio = a.Unidad,
@SubCuentaObsequio = o.SubCuentaObsequio
FROM Oferta o
JOIN OfertaD d ON(o.ID=d.ID)
JOIN Art a ON (o.Obsequio = a.Articulo)
LEFT JOIN #VentaD v ON d.Articulo = v.Articulo
WHERE o.ID = @OfertaID
GROUP BY o.Obsequio,o.CantidadObsequio, a.Unidad, o.SubCuentaObsequio
SELECT @ArtCantidadTotal = SUM(Cantidad)
FROM #VentaD
WHERE Articulo = @Obsequio
AND Unidad = @UnidadObsequio
AND ISNULL(Subcuenta,ISNULL(@SubCuentaObsequio,'')) = ISNULL(@SubCuentaObsequio,'')
IF @CantidadOferta >= 0
BEGIN
DELETE #ArtObsequio WHERE Articulo = @Obsequio AND Unidad = @UnidadObsequio
DELETE #OfertaLog  WHERE OfertaId = @OfertaID AND ArticuloObsequio = @Obsequio AND UnidadObsequio = @UnidadObsequio AND ISNULL(SubcuentaObsequio,ISNULL(@SubCuentaObsequio,'')) = ISNULL(@SubCuentaObsequio,'')
SET @a = 0
WHILE @a < @CantidadObsequio
BEGIN
INSERT #ArtObsequio (Articulo, OfertaID, Unidad, SubCuenta) VALUES (@Obsequio, @OfertaID, @UnidadObsequio, @SubCuentaObsequio)
SET @a = @a + 1
SELECT @ArtOfertaID = @OfertaID 
IF @OfertaAplicaLog = 1 AND @ArtCantidadTotal >= @a
BEGIN
EXEC spOfertaLog @OfertaID,@Tipo, @Forma, @Usar, @Articulo, @SubCuenta, @ArtUnidad, @ArticuloObsequio = @Obsequio, @ArtCantidadTotal = 1, @UnidadObsequio = @UnidadObsequio, @SubCuentaObsequio = @SubCuentaObsequio 
END
END
END
END
END
FETCH NEXT FROM crOfertaNormal INTO @OfertaID, @OfertaTipoCambio, @Tipo, @Forma, @Usar, @TieneVolumen, @Cantidad, @Porcentaje, @Precio, @Importe, @Obsequio, @UnidadObsequio, @SubCuentaObsequio
END  
CLOSE crOfertaNormal
DEALLOCATE crOfertaNormal
END
RETURN
END

