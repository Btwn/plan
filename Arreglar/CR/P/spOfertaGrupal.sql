SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spOfertaGrupal
@Empresa		varchar(5),
@Sucursal		int,
@Moneda			varchar(10),
@TipoCambio		float,
@Prioridad		int= NULL

AS BEGIN
DECLARE
@OfertaID		      int,
@Categoria	          varchar(50),
@Grupo			      varchar(50),
@Familia		      varchar(50),
@Linea			      varchar(50),
@Fabricante           varchar(50),
@Proveedor	          varchar(10),
@Porcentaje	          float,
@Almacen	          varchar(20),
@Tipo                 varchar(10),
@Articulo		      char(20),
@Cantidad		      int,
@CantidadTotal        int,
@ImporteVenta	      int,
@MontoMinimo	      float,
@CategoriaD		      varchar(50),
@GrupoD			      varchar(50),
@FamiliaD		      varchar(50),
@LineaD			      varchar(50),
@FabricanteD	      varchar(50),
@ProveedorD		      varchar(10),
@ABC                  varchar(50),
@Unidad			      varchar(50),
@CfgImpInc		      int,
@bOfertaGrupalActiva  bit,
@TipoN                varchar(10),
@Forma                varchar(50),
@Usar                 varchar(50),
@OfertaAplicaLog      bit,
@DescripcionOfertaLog varchar (255),
@SubCuenta            varchar(50),
@ContadorTotalCascada int,
@Precio               float,
@PorcentajeImporte	  float,
@DescuentoCascada     float
SELECT @CfgImpInc  = VentaPreciosImpuestoIncluido FROM EmpresaCfg ec WHERE ec.Empresa = @Empresa
SELECT @OfertaAplicaLog = CASE
WHEN (ISNULL(OfertaAplicaLog, 0) > 0) THEN OfertaAplicaLog
WHEN (ISNULL(OfertaAplicaLogPOS, 0) > 0) THEN OfertaAplicaLogPOS
ELSE 0
END
FROM EmpresaCfg2 ec
WHERE ec.Empresa = @Empresa
IF @Prioridad = 1
BEGIN
DECLARE crOfertaGrupal CURSOR LOCAL FOR
SELECT o.ID,
NULLIF(RTRIM(o.Categoria), ''),
NULLIF(RTRIM(o.Grupo), ''),
NULLIF(RTRIM(o.Familia), ''),
NULLIF(RTRIM(o.Linea), ''),
NULLIF(RTRIM(o.Fabricante), ''),
NULLIF(RTRIM(o.Proveedor), ''),
NULLIF(o.Porcentaje, 0.0),
ISNULL(o.GrupoTipo,'NORMAL'),
ISNULL(o.MontoMinimo, 0.0),
NULLIF(RTRIM(o.CategoriaD), ''),
NULLIF(RTRIM(o.GrupoD), ''),
NULLIF(RTRIM(o.FamiliaD), ''),
NULLIF(RTRIM(o.LineaD), ''),
NULLIF(RTRIM(o.FabricanteD), ''),
NULLIF(RTRIM(o.ProveedorD), ''),
ISNULL(CantidadObsequio, 0),
NULLIF(RTRIM(o.ABC), ''),
NULLIF(RTRIM(o.Unidad),''),
NULLIF(RTRIM(o.Tipo),''),
NULLIF(RTRIM(o.Forma),''),
NULLIF(RTRIM(o.Usar),'')
FROM Oferta o
JOIN MovTipo mt ON mt.Modulo = 'OFER' AND mt.Mov = o.Mov AND mt.Clave = 'OFER.OG'
JOIN #OfertaActiva oa ON oa.ID = o.ID AND oa.Sucursal = @Sucursal
WHERE o.PrioridadG = @Prioridad
ORDER BY o.FechaEmision
OPEN crOfertaGrupal
FETCH NEXT FROM crOfertaGrupal INTO @OfertaID, @Categoria, @Grupo, @Familia, @Linea, @Fabricante, @Proveedor, @Porcentaje, @Tipo, @MontoMinimo, @CategoriaD, @GrupoD, @FamiliaD, @LineaD, @FabricanteD, @ProveedorD, @Cantidad, @ABC, @Unidad, @TipoN, @Forma, @Usar
WHILE @@FETCH_STATUS <> -1
BEGIN
IF @@FETCH_STATUS <> -2
BEGIN
SET @bOfertaGrupalActiva = 1
SELECT @CantidadTotal = SUM(ISNULL(Cantidad,0)), @ImporteVenta = SUM(CASE WHEN @CfgImpInc = 1
THEN ISNULL(v.PrecioSugerido,0) / (1+(ISNULL(v.Impuesto1,0)/100)) ELSE ISNULL(v.PrecioSugerido,0) END * ISNULL(v.Cantidad,0))
FROM #VentaD v
JOIN Art a ON v.Articulo = a.Articulo
WHERE (NULLIF(v.OfertaIDG3, 0) IS NULL OR NULLIF(v.OfertaIDG3, 0) = @OfertaID)
AND ISNULL(a.Categoria, '') = ISNULL(ISNULL(@Categoria, a.Categoria), '')
AND ISNULL(a.Grupo,'')      = ISNULL(ISNULL(@Grupo, a.Grupo),'')
AND ISNULL(a.Familia,'')    = ISNULL(ISNULL(@Familia, a.Familia),'')
AND ISNULL(a.Linea,'')      = ISNULL(ISNULL(@Linea, a.Linea),'')
AND ISNULL(a.Fabricante,'') = ISNULL(ISNULL(@Fabricante, a.Fabricante),'')
AND ISNULL(a.Proveedor,'')  = ISNULL(ISNULL(@Proveedor, a.Proveedor),'')
AND ISNULL(a.ABC,'')  = ISNULL(ISNULL(@ABC, a.ABC),'')
AND ISNULL(v.Unidad,'')  = ISNULL(ISNULL(@Unidad, v.Unidad),'')
IF @Tipo = 'NORMAL' AND @Porcentaje IS NOT NULL AND @ImporteVenta >= @MontoMinimo
BEGIN
UPDATE #VentaD
SET DescuentoG1 = @Porcentaje,
OfertaIDG1 = @OfertaID
WHERE (NULLIF(OfertaIDG1, 0) IS NULL OR NULLIF(OfertaIDG1, 0) = @OfertaID)
AND ISNULL(Categoria, '')  = ISNULL(ISNULL(@Categoria, Categoria), '')
AND ISNULL(Grupo,'')       = ISNULL(ISNULL(@Grupo, Grupo),'')
AND ISNULL(Familia,'')     = ISNULL(ISNULL(@Familia, Familia),'')
AND ISNULL(Linea,'')       = ISNULL(ISNULL(@Linea, Linea),'')
AND ISNULL(Fabricante,'')  = ISNULL(ISNULL(@Fabricante, Fabricante),'')
AND ISNULL(Proveedor,'')   = ISNULL(ISNULL(@Proveedor, Proveedor),'')
AND ISNULL(ABC,'')         = ISNULL(ISNULL(@ABC, ABC),'')
AND ISNULL(Unidad,'')      = ISNULL(ISNULL(@Unidad, Unidad),'')
IF @OfertaAplicaLog = 1 AND @OfertaID IS NOT NULL
DECLARE logOfertaP1Normal CURSOR LOCAL FOR
SELECT d.Articulo, d.unidad
FROM #VentaD d
WHERE DescuentoG1 = @Porcentaje
AND   OfertaIDG1 = @OfertaID
AND (NULLIF(OfertaIDG1, 0) IS NULL OR NULLIF(OfertaIDG1, 0) = @OfertaID)
AND ISNULL(Categoria, '')  = ISNULL(ISNULL(@Categoria, Categoria), '')
AND ISNULL(Grupo,'')       = ISNULL(ISNULL(@Grupo, Grupo),'')
AND ISNULL(Familia,'')     = ISNULL(ISNULL(@Familia, Familia),'')
AND ISNULL(Linea,'')       = ISNULL(ISNULL(@Linea, Linea),'')
AND ISNULL(Fabricante,'')  = ISNULL(ISNULL(@Fabricante, Fabricante),'')
AND ISNULL(Proveedor,'')   = ISNULL(ISNULL(@Proveedor, Proveedor),'')
AND ISNULL(ABC,'')         = ISNULL(ISNULL(@ABC, ABC),'')
AND ISNULL(Unidad,'')      = ISNULL(ISNULL(@Unidad, Unidad),'')
OPEN logOfertaP1Normal
FETCH NEXT FROM logOfertaP1Normal INTO @Articulo, @Unidad
WHILE @@FETCH_STATUS <> -1
BEGIN
IF @@FETCH_STATUS <> -2
BEGIN
EXEC spOfertaLog @OfertaID, @Tipo, @Forma, @Usar, @Articulo, NULL, @Unidad, @Descuento = @Porcentaje, @DescuentoG3 = @Porcentaje, @OfertaIDG3 = @OfertaID
END
FETCH NEXT FROM logOfertaP1Normal INTO @Articulo, @Unidad
END
CLOSE logOfertaP1Normal
DEALLOCATE logOfertaP1Normal
END
ELSE
BEGIN
UPDATE #VentaD SET Descuento = 0, DescuentoG1 = 0 WHERE OfertaID IS NOT NULL
END
END
FETCH NEXT FROM crOfertaGrupal INTO @OfertaID, @Categoria, @Grupo, @Familia, @Linea, @Fabricante, @Proveedor, @Porcentaje, @Tipo, @MontoMinimo, @CategoriaD, @GrupoD, @FamiliaD, @LineaD, @FabricanteD, @ProveedorD, @Cantidad, @ABC, @Unidad, @TipoN, @Forma, @Usar
END  
CLOSE crOfertaGrupal
DEALLOCATE crOfertaGrupal
IF EXISTS (SELECT * FROM #VentaD WHERE Descuento > 0 OR DescuentoG1 > 0) AND @bOfertaGrupalActiva = 0
UPDATE #VentaD SET Descuento = 0, DescuentoG1 = 0 WHERE OfertaID IS NOT NULL
RETURN
END
IF @Prioridad = 2
BEGIN
DECLARE crOfertaGrupal CURSOR LOCAL FOR
SELECT o.ID,
NULLIF(RTRIM(o.Categoria), ''),
NULLIF(RTRIM(o.Grupo), ''),
NULLIF(RTRIM(o.Familia), ''),
NULLIF(RTRIM(o.Linea), ''),
NULLIF(RTRIM(o.Fabricante), ''),
NULLIF(RTRIM(o.Proveedor), ''),
NULLIF(o.Porcentaje, 0.0),
ISNULL(o.GrupoTipo,'NORMAL'),
ISNULL(o.MontoMinimo, 0.0),
NULLIF(RTRIM(o.CategoriaD), ''),
NULLIF(RTRIM(o.GrupoD), ''),
NULLIF(RTRIM(o.FamiliaD), ''),
NULLIF(RTRIM(o.LineaD), ''),
NULLIF(RTRIM(o.FabricanteD), ''),
NULLIF(RTRIM(o.ProveedorD), ''),
NULLIF(RTRIM(o.ABC), ''),
NULLIF(RTRIM(o.Unidad), ''),
o.Tipo,
o.Forma,
o.Usar
FROM Oferta o
JOIN MovTipo mt ON mt.Modulo = 'OFER' AND mt.Mov = o.Mov AND mt.Clave = 'OFER.OG'
JOIN #OfertaActiva oa ON oa.ID = o.ID
WHERE o.PrioridadG = @Prioridad
ORDER BY o.FechaEmision
OPEN crOfertaGrupal
FETCH NEXT FROM crOfertaGrupal INTO @OfertaID, @Categoria, @Grupo, @Familia, @Linea, @Fabricante, @Proveedor, @Porcentaje, @Tipo, @MontoMinimo, @CategoriaD, @GrupoD, @FamiliaD, @LineaD, @FabricanteD, @ProveedorD, @ABC, @Unidad, @TipoN, @Forma, @Usar
WHILE @@FETCH_STATUS <> -1
BEGIN
IF @@FETCH_STATUS <> -2
BEGIN
IF @Tipo = 'NORMAL' AND @Porcentaje IS NOT NULL
BEGIN
UPDATE #VentaD
SET DescuentoG2 = @Porcentaje,
OfertaIDG2 = @OfertaID
WHERE (NULLIF(OfertaIDG2, 0) IS NULL OR NULLIF(OfertaIDG2, 0) = @OfertaID)
AND ISNULL(Categoria, '') = ISNULL(ISNULL(@Categoria, Categoria), '')
AND ISNULL(Grupo,'')      = ISNULL(ISNULL(@Grupo, Grupo),'')
AND ISNULL(Familia,'')    = ISNULL(ISNULL(@Familia, Familia),'')
AND ISNULL(Linea,'')      = ISNULL(ISNULL(@Linea, Linea),'')
AND ISNULL(Fabricante,'') = ISNULL(ISNULL(@Fabricante, Fabricante),'')
AND ISNULL(Proveedor,'')  = ISNULL(ISNULL(@Proveedor, Proveedor),'')
AND ISNULL(ABC,'')  = ISNULL(ISNULL(@ABC, ABC),'')
AND ISNULL(Unidad,'')  = ISNULL(ISNULL(@Unidad, Unidad),'')
IF @OfertaAplicaLog = 1 AND @OfertaID IS NOT NULL
DECLARE logOfertaP2Normal CURSOR LOCAL FOR
SELECT d.Articulo, d.unidad
FROM #VentaD d
OPEN logOfertaP2Normal
FETCH NEXT FROM logOfertaP2Normal INTO @Articulo, @Unidad
WHILE @@FETCH_STATUS <> -1
BEGIN
IF @@FETCH_STATUS <> -2
BEGIN
EXEC spOfertaLog @OfertaID, @Tipo, @Forma, @Usar, @Articulo, NULL, @Unidad, @Descuento = @Porcentaje, @DescuentoG2 = @Porcentaje, @OfertaIDG3 = @OfertaID
END
FETCH NEXT FROM logOfertaP2Normal INTO @Articulo, @Unidad
END
CLOSE logOfertaP2Normal
DEALLOCATE logOfertaP2Normal
END
IF @Tipo = 'CASCADA'
BEGIN
DECLARE crOfertaCascada CURSOR LOCAL FOR
SELECT ISNULL(d.Cantidad,0), ISNULL(d.Articulo,''), ISNULL(d.SubCuenta,''), Descuento
FROM #VentaD d
JOIN Art a ON d.Articulo=a.Articulo
WHERE (NULLIF(d.OfertaIDG3, 0) IS NULL OR NULLIF(d.OfertaIDG3, 0) = @OfertaID)
AND ISNULL(a.Categoria, '') = ISNULL(ISNULL(@Categoria, a.Categoria), '')
AND ISNULL(a.Grupo,'')      = ISNULL(ISNULL(@Grupo, a.Grupo),'')
AND ISNULL(a.Familia,'')    = ISNULL(ISNULL(@Familia, a.Familia),'')
AND ISNULL(a.Linea,'')      = ISNULL(ISNULL(@Linea, a.Linea),'')
AND ISNULL(a.Fabricante,'') = ISNULL(ISNULL(@Fabricante, a.Fabricante),'')
AND ISNULL(a.Proveedor,'')  = ISNULL(ISNULL(@Proveedor, a.Proveedor),'')
AND ISNULL(a.ABC,'')        = ISNULL(ISNULL(@ABC, a.ABC),'')
AND ISNULL(d.Unidad,'')        = ISNULL(ISNULL(@Unidad, d.Unidad),'')
OPEN crOfertaCascada
FETCH NEXT FROM crOfertaCascada INTO @Cantidad, @Articulo, @SubCuenta, @DescuentoCascada
WHILE @@FETCH_STATUS <> -1
BEGIN
IF @@FETCH_STATUS <> -2
BEGIN
SET @Porcentaje = 0
SELECT @Porcentaje = Porcentaje FROM OfertaCascadaGrupo WHERE ID=@OfertaID AND @Cantidad BETWEEN Desde AND Hasta
IF ISNULL(@Porcentaje,0) = 0 AND @Cantidad > (SELECT MAX(Hasta) FROM OfertaCascadaGrupo WHERE ID=@OfertaID) OR @Cantidad < (SELECT MIN(Desde) FROM OfertaCascadaGrupo WHERE ID=@OfertaID)
SELECT @Porcentaje = Porcentaje FROM Oferta WHERE ID=@OfertaID
IF ISNULL(@Porcentaje,0) <> 0
UPDATE #VentaD SET DescuentoG3 = @Porcentaje, OfertaIDG3 = @OfertaID
FROM #VentaD d
JOIN Art a ON d.Articulo=a.Articulo
WHERE (NULLIF(d.OfertaIDG3, 0) IS NULL OR NULLIF(d.OfertaIDG3, 0) = @OfertaID)
AND ISNULL(a.Categoria, '') = ISNULL(ISNULL(@Categoria, a.Categoria), '')
AND ISNULL(a.Grupo,'')      = ISNULL(ISNULL(@Grupo, a.Grupo),'')
AND ISNULL(a.Familia,'')    = ISNULL(ISNULL(@Familia, a.Familia),'')
AND ISNULL(a.Linea,'')      = ISNULL(ISNULL(@Linea, a.Linea),'')
AND ISNULL(a.Fabricante,'') = ISNULL(ISNULL(@Fabricante, a.Fabricante),'')
AND ISNULL(a.Proveedor,'')  = ISNULL(ISNULL(@Proveedor, a.Proveedor),'')
AND ISNULL(a.ABC,'')        = ISNULL(ISNULL(@ABC, a.ABC),'')
AND ISNULL(d.Unidad,'')     = ISNULL(ISNULL(@Unidad, d.Unidad),'')
AND ISNULL(d.Articulo,'')   = @Articulo
AND ISNULL(d.SubCuenta,'')  = @SubCuenta
IF @OfertaAplicaLog = 1 AND @OfertaID IS NOT NULL AND @Porcentaje <> 0 AND @DescuentoCascada > 0 
BEGIN
EXEC spOfertaLog @OfertaID, @Tipo, @Forma, @Usar, @Articulo, @SubCuenta, @Unidad, @Descuento = @Porcentaje, @DescuentoG3 = @Porcentaje, @OfertaIDG3 = @OfertaID
END
END
FETCH NEXT FROM crOfertaCascada INTO @Cantidad, @Articulo, @SubCuenta, @DescuentoCascada
END  
CLOSE crOfertaCascada
DEALLOCATE crOfertaCascada
END
END
FETCH NEXT FROM crOfertaGrupal INTO @OfertaID, @Categoria, @Grupo, @Familia, @Linea, @Fabricante, @Proveedor, @Porcentaje, @Tipo, @MontoMinimo, @CategoriaD, @GrupoD, @FamiliaD, @LineaD, @FabricanteD, @ProveedorD, @ABC, @Unidad, @TipoN, @Forma, @Usar
END  
CLOSE crOfertaGrupal
DEALLOCATE crOfertaGrupal
RETURN
END
IF @Prioridad >= 3
BEGIN
DECLARE crOfertaGrupal CURSOR LOCAL FOR
SELECT o.ID,
NULLIF(RTRIM(o.Categoria), ''),
NULLIF(RTRIM(o.Grupo), ''),
NULLIF(RTRIM(o.Familia), ''),
NULLIF(RTRIM(o.Linea), ''),
NULLIF(RTRIM(o.Fabricante), ''),
NULLIF(RTRIM(o.Proveedor), ''),
NULLIF(o.Porcentaje, 0.0),
ISNULL(o.GrupoTipo,'NORMAL'),
ISNULL(o.MontoMinimo, 0.0),
NULLIF(RTRIM(o.CategoriaD), ''),
NULLIF(RTRIM(o.GrupoD), ''),
NULLIF(RTRIM(o.FamiliaD), ''),
NULLIF(RTRIM(o.LineaD), ''),
NULLIF(RTRIM(o.FabricanteD), ''),
NULLIF(RTRIM(o.ProveedorD), ''),
NULLIF(RTRIM(o.ABC), ''),
NULLIF(RTRIM(o.Unidad), ''),
o.Tipo,
o.Forma,
o.Usar
FROM Oferta o
JOIN MovTipo mt ON mt.Modulo = 'OFER' AND mt.Mov = o.Mov AND mt.Clave = 'OFER.OG'
JOIN #OfertaActiva oa ON oa.ID = o.ID
WHERE o.PrioridadG >= @Prioridad
ORDER BY o.FechaEmision
OPEN crOfertaGrupal
FETCH NEXT FROM crOfertaGrupal INTO @OfertaID, @Categoria, @Grupo, @Familia, @Linea, @Fabricante, @Proveedor, @Porcentaje, @Tipo, @MontoMinimo, @CategoriaD, @GrupoD, @FamiliaD, @LineaD, @FabricanteD, @ProveedorD, @ABC, @Unidad, @TipoN, @Forma, @Usar
WHILE @@FETCH_STATUS <> -1
BEGIN
IF @@FETCH_STATUS <> -2
BEGIN
IF @Tipo = 'NORMAL' AND @Porcentaje IS NOT NULL
BEGIN
UPDATE #VentaD
SET DescuentoG3 = @Porcentaje,
OfertaIDG3 = @OfertaID
WHERE (NULLIF(OfertaIDG3, 0) IS NULL OR NULLIF(OfertaIDG3, 0) = @OfertaID)
AND ISNULL(Categoria, '') = ISNULL(ISNULL(@Categoria, Categoria), '')
AND ISNULL(Grupo,'')      = ISNULL(ISNULL(@Grupo, Grupo),'')
AND ISNULL(Familia,'')    = ISNULL(ISNULL(@Familia, Familia),'')
AND ISNULL(Linea,'')      = ISNULL(ISNULL(@Linea, Linea),'')
AND ISNULL(Fabricante,'') = ISNULL(ISNULL(@Fabricante, Fabricante),'')
AND ISNULL(Proveedor,'')  = ISNULL(ISNULL(@Proveedor, Proveedor),'')
AND ISNULL(ABC,'')        = ISNULL(ISNULL(@ABC, ABC),'')
AND ISNULL(Unidad,'')        = ISNULL(ISNULL(@Unidad, Unidad),'')
IF @OfertaAplicaLog = 1 AND @OfertaID IS NOT NULL
DECLARE logOfertaP3Normal CURSOR LOCAL FOR
SELECT d.Articulo, d.unidad
FROM #VentaD d
OPEN logOfertaP3Normal
FETCH NEXT FROM logOfertaP3Normal INTO @Articulo, @Unidad
WHILE @@FETCH_STATUS <> -1
BEGIN
IF @@FETCH_STATUS <> -2
BEGIN
EXEC spOfertaLog @OfertaID, @Tipo, @Forma, @Usar, @Articulo, NULL, @Unidad, @Descuento = @Porcentaje, @DescuentoG3 = @Porcentaje, @OfertaIDG3 = @OfertaID
END
FETCH NEXT FROM logOfertaP3Normal INTO @Articulo, @Unidad
END
CLOSE logOfertaP3Normal
DEALLOCATE logOfertaP3Normal
END
IF @@FETCH_STATUS <> -2 AND @Porcentaje IS NOT NULL AND @Tipo = 'CRUZADA'
BEGIN
SELECT @ImporteVenta = SUM(CASE WHEN @CfgImpInc = 1 THEN ISNULL(v.PrecioSugerido,0) / (1+(ISNULL(v.Impuesto1,0)/100))  ELSE ISNULL(v.PrecioSugerido,0) END * ISNULL(v.Cantidad,0))
FROM #VentaD v
JOIN Art a ON v.Articulo = a.Articulo
WHERE (NULLIF(v.OfertaIDG3, 0) IS NULL OR NULLIF(v.OfertaIDG3, 0) = @OfertaID)
AND ISNULL(a.Categoria, '') = ISNULL(ISNULL(@Categoria, a.Categoria), '')
AND ISNULL(a.Grupo,'')      = ISNULL(ISNULL(@Grupo, a.Grupo),'')
AND ISNULL(a.Familia,'')    = ISNULL(ISNULL(@Familia, a.Familia),'')
AND ISNULL(a.Linea,'')      = ISNULL(ISNULL(@Linea, a.Linea),'')
AND ISNULL(a.Fabricante,'') = ISNULL(ISNULL(@Fabricante, a.Fabricante),'')
AND ISNULL(a.Proveedor,'')  = ISNULL(ISNULL(@Proveedor, a.Proveedor),'')
AND ISNULL(a.ABC,'')        = ISNULL(ISNULL(@ABC, a.ABC),'')
AND ISNULL(v.Unidad,'')     = ISNULL(ISNULL(@Unidad, v.Unidad),'')
IF @ImporteVenta >= @MontoMinimo
UPDATE #VentaD
SET DescuentoG3 = @Porcentaje,
OfertaIDG3 = @OfertaID
WHERE (NULLIF(OfertaIDG3, 0) IS NULL OR NULLIF(OfertaIDG3, 0) = @OfertaID)
AND ISNULL(Categoria, '') = ISNULL(ISNULL(@CategoriaD, Categoria), '')
AND ISNULL(Grupo,'')      = ISNULL(ISNULL(@GrupoD, Grupo),'')
AND ISNULL(Familia,'')    = ISNULL(ISNULL(@FamiliaD, Familia),'')
AND ISNULL(Linea,'')      = ISNULL(ISNULL(@LineaD, Linea),'')
AND ISNULL(Fabricante,'') = ISNULL(ISNULL(@FabricanteD, Fabricante),'')
AND ISNULL(Proveedor,'')  = ISNULL(ISNULL(@ProveedorD, Proveedor),'')
AND ISNULL(ABC,'')        = ISNULL(ISNULL(@ABC, ABC),'')
AND ISNULL(Unidad,'')     = ISNULL(ISNULL(@Unidad, Unidad),'')
IF @OfertaAplicaLog = 1 AND @OfertaID IS NOT NULL AND @ImporteVenta IS NOT NULL
BEGIN
DECLARE logOfertaP3Cruzada CURSOR LOCAL FOR
SELECT d.Articulo, d.unidad, d.SubCuenta,CASE WHEN @CfgImpInc = 1 THEN ISNULL(d.PrecioSugerido,0) / (1+(ISNULL(d.Impuesto1,0)/100))  ELSE ISNULL(d.PrecioSugerido,0) END * ISNULL(d.Cantidad,0)
FROM #VentaD d
WHERE (NULLIF(OfertaIDG3, 0) IS NULL OR NULLIF(OfertaIDG3, 0) = @OfertaID)
AND ISNULL(Categoria, '') = ISNULL(ISNULL(@CategoriaD, Categoria), '')
AND ISNULL(Grupo,'')      = ISNULL(ISNULL(@GrupoD, Grupo),'')
AND ISNULL(Familia,'')    = ISNULL(ISNULL(@FamiliaD, Familia),'')
AND ISNULL(Linea,'')      = ISNULL(ISNULL(@LineaD, Linea),'')
AND ISNULL(Fabricante,'') = ISNULL(ISNULL(@FabricanteD, Fabricante),'')
AND ISNULL(Proveedor,'')  = ISNULL(ISNULL(@ProveedorD, Proveedor),'')
AND ISNULL(ABC,'')        = ISNULL(ISNULL(@ABC, ABC),'')
AND ISNULL(Unidad,'')     = ISNULL(ISNULL(@Unidad, Unidad),'')
OPEN logOfertaP3Cruzada
FETCH NEXT FROM logOfertaP3Cruzada INTO @Articulo, @Unidad, @SubCuenta, @Precio
WHILE @@FETCH_STATUS <> -1
BEGIN
IF @@FETCH_STATUS <> -2
BEGIN
SET @PorcentajeImporte = dbo.fnDisminuyePorcentaje(@Precio, @Porcentaje)
SET @PorcentajeImporte = CAST(ROUND((@PorcentajeImporte),dbo.fnRedondeoDecimales(@Empresa)) AS FLOAT)
EXEC spOfertaLog @OfertaID, @Tipo, @Forma, @Usar, @Articulo, @SubCuenta, @Unidad, @Descuento = @Porcentaje, @DescuentoImporte = @PorcentajeImporte, @DescuentoG3 = @Porcentaje, @OfertaIDG3 = @OfertaID
END
FETCH NEXT FROM logOfertaP3Cruzada INTO @Articulo, @Unidad, @SubCuenta, @Precio
END
CLOSE logOfertaP3Cruzada
DEALLOCATE logOfertaP3Cruzada
END
END
END
FETCH NEXT FROM crOfertaGrupal INTO @OfertaID, @Categoria, @Grupo, @Familia, @Linea, @Fabricante, @Proveedor, @Porcentaje, @Tipo, @MontoMinimo, @CategoriaD, @GrupoD, @FamiliaD, @LineaD, @FabricanteD, @ProveedorD, @ABC, @Unidad, @TipoN, @Forma, @Usar
END  
CLOSE crOfertaGrupal
DEALLOCATE crOfertaGrupal
RETURN
END
END

