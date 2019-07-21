SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spPOSOfertaAplicar
@ID					varchar(50),
@OfertaFechaHora	varchar(20)	= NULL,
@PuntosPrecio		bit = 0

AS
BEGIN
DECLARE
@Empresa		              varchar(5),
@Mov		                  varchar(20),
@Sucursal		              int,
@Usuario		              varchar(10),
@ListaPrecios	              varchar(50),
@FechaHora		              datetime,
@Estatus		              varchar(15),
@FechaEmision	              datetime,
@FechaRequerida	              datetime,
@HoraRequerida	              varchar(5),
@Moneda		                  varchar(10),
@TipoCambio		              float,
@DescuentoGlobal	          float,
@ImporteTotalMN	              float,
@Aplica		                  bit,
@SucursalDetalle	          int,
@VentaMultiAlmacen	          bit,
@Monedero                     varchar(20),
@CodigoRedondeo               varchar(30),
@ArticuloRedondeo             varchar(20),
@ArtOfertaImporte             varchar(20),
@ArtOfertaFP                  varchar(20),
@CfgAnticipoArticuloServicio  varchar(20),
@ContMoneda		              varchar(10),
@ContMonedaTC	              float,
@RedondeoMonetarios           int,
@Usar                         varchar(20),
@Forma                        varchar(20),
@OfertaID                     int
SELECT @Empresa = Empresa, @Sucursal = Sucursal
FROM POSL WITH (NOLOCK)
WHERE ID = @ID
SELECT @CodigoRedondeo = RedondeoVentaCodigo , @ArtOfertaFP = ArtOfertaFP, @ArtOfertaImporte = ArtOfertaImporte
FROM POSCfg WITH (NOLOCK)
WHERE Empresa = @Empresa
SELECT @RedondeoMonetarios = dbo.fnPOSRedondeoMonetarios(@Empresa) 
SELECT @ContMoneda = ec.ContMoneda
FROM EmpresaCfg ec WITH (NOLOCK)
WHERE ec.Empresa = @Empresa
SELECT @ContMonedaTC = TipoCambio
FROM POSLTipoCambioRef WITH (NOLOCK)
WHERE Sucursal = @Sucursal AND Moneda = @ContMoneda
SELECT @ArticuloRedondeo = Cuenta
FROM CB WITH (NOLOCK)
WHERE Codigo = @CodigoRedondeo AND TipoCuenta = 'Articulos'
SELECT @ArticuloRedondeo = cb.Cuenta
FROM CB WITH (NOLOCK)
WHERE CB.Cuenta = @CodigoRedondeo AND CB.TipoCuenta = 'Articulos'
SELECT @CfgAnticipoArticuloServicio = NULLIF(CxcAnticipoArticuloServicio,'')
FROM EmpresaCfg2 WITH (NOLOCK)
WHERE Empresa = @Empresa
SELECT @Mov = Mov, @Empresa = Empresa, @Sucursal = Sucursal, @Usuario = Usuario, @Moneda = Moneda, @TipoCambio = CASE WHEN Moneda <> @ContMoneda THEN  (ISNULL(TipoCambio,1)/@ContMonedaTC) ELSE ISNULL(TipoCambio,1) END, @Estatus = Estatus, @ListaPrecios = ListaPreciosEsp,
@FechaEmision = FechaEmision, @FechaRequerida = FechaEmision, @HoraRequerida = '00:00', @DescuentoGlobal = DescuentoGlobal,@Monedero = Monedero
FROM POSL WITH (NOLOCK)
WHERE ID = @ID
SET @PuntosPrecio = 0
IF NULLIF(@Monedero,'') IS NOT NULL AND @PuntosPrecio = 1
SET @PuntosPrecio = 1
ELSE
SET @PuntosPrecio = 0
SELECT @VentaMultiAlmacen = ISNULL(VentaMultiAlmacen,0) FROM EmpresaCfg2 WITH (NOLOCK) WHERE Empresa = @Empresa
SET @Aplica = 1
EXEC xpPOSOfertaAplicar @ID, @Aplica OUTPUT
IF @Aplica = 1
BEGIN
IF @OfertaFechaHora IS NULL
SELECT @OfertaFechaHora = OfertaFechaHora FROM EmpresaCfg2 WITH (NOLOCK) WHERE Empresa = @Empresa
IF UPPER(@OfertaFechaHora) = 'FECHA SERVIDOR'  SELECT @FechaHora = GETDATE() ELSE
IF UPPER(@OfertaFechaHora) = 'FECHA EMISION'   SELECT @FechaHora = @FechaEmision ELSE
IF UPPER(@OfertaFechaHora) = 'FECHA REQUERIDA' SELECT @FechaHora = dbo.FechaConHora(@FechaRequerida, @HoraRequerida)
CREATE TABLE #Venta (Campo varchar(50) COLLATE Database_Default NOT NULL, Valor varchar(100) COLLATE Database_Default NULL)
CREATE TABLE #VentaDetalle (Renglon float, Campo varchar(50) COLLATE Database_Default NOT NULL, Valor varchar(100) COLLATE Database_Default NULL)
EXEC spPOSOfertaVenta @ID
CREATE INDEX Campo ON #Venta (Campo, Valor)
CREATE TABLE #VentaD (
RID					    int NOT NULL IDENTITY(1,1) PRIMARY KEY,
Renglon				    float NOT NULL,
RenglonSub			    int NOT NULL,
RenglonTipo			    varchar(1)	COLLATE Database_Default NULL,
Articulo				varchar(20) COLLATE Database_Default NOT NULL,
SubCuenta				varchar(50) COLLATE Database_Default NULL,
Rama					varchar(20) COLLATE Database_Default NULL,
Categoria				varchar(50) COLLATE Database_Default NULL,
Grupo					varchar(50) COLLATE Database_Default NULL,
Familia				    varchar(50) COLLATE Database_Default NULL,
Linea					varchar(50) COLLATE Database_Default NULL,
Fabricante			    varchar(50) COLLATE Database_Default NULL,
Proveedor				varchar(10) COLLATE Database_Default NULL,
ABC						varchar(50) COLLATE Database_Default NULL,
Cantidad				float NULL,
Unidad				    varchar(50) COLLATE Database_Default NULL,
CantidadInventario		float NULL,
PrecioSugerido			float NULL,
Precio				    float NULL,
Impuesto1				float NULL,
Descuento				float NULL,
DescuentoP1			    float NULL,
DescuentoP2			    float NULL,
DescuentoP3			    float NULL,
DescuentoG1			    float NULL,
DescuentoG2			    float NULL,
DescuentoG3			    float NULL,
DescuentoImporte		money NULL,
Puntos				    float NULL,
PuntosPorcentaje		float NULL,
Comision				float NULL,
ComisionPorcentaje		float NULL,
CantidadObsequio		float NULL,
SucursalDetalle			int	 NULL,
Almacen				    varchar(20) COLLATE Database_Default NOT NULL,
OfertaIDP1			    int NULL,
OfertaIDP2			    int NULL,
OfertaIDP3			    int NULL,
OfertaIDG1			    int NULL,
OfertaIDG2			    int NULL,
OfertaIDG3			    int NULL,
OfertaID				int NULL,
DescuentoAd				float NULL)
CREATE TABLE #OfertaLog (
RID					    int NOT NULL IDENTITY(1,1) PRIMARY KEY,
OfertaID				int NOT NULL,
Mov						varchar(20)NULL,
MovID					varchar(20)NULL,
Prioridad				int NULL,
PrioridadG			    int NULL,
Tipo					varchar(50)NULL,
Forma					varchar(50)NULL,
Usar					varchar(50)NULL,
Articulo				varchar(20) COLLATE Database_Default NOT NULL,
SubCuenta				varchar(50) COLLATE Database_Default NULL,
Unidad				    varchar(50) COLLATE Database_Default NULL,
Descuento				float NULL,
DescuentoImporte		money NULL,
Puntos				    float NULL,
PuntosPorcentaje		float NULL,
Comision				float NULL,
ComisionPorcentaje		float NULL,
CantidadObsequio		float NULL,
Costo					float NULL,
PrecioBaseCosto			float NULL,
PrecioBaseLista			float NULL,
Precio				    float NULL,
ArticuloObsequio		varchar(20)NULL,
UnidadObsequio			varchar(5) NULL,
SubCuentaObsequio		varchar(50) NULL,
ArtTipo				    varchar(20)NULL,
CantidadOferta			float NULL,
DescuentoP1			    float NULL,
DescuentoP2			    float NULL,
DescuentoP3			    float NULL,
DescuentoG1			    float NULL,
DescuentoG2			    float NULL,
DescuentoG3			    float NULL,
SucursalDetalle			int	 NULL,
OfertaIDP1			    int NULL,
OfertaIDP2			    int NULL,
OfertaIDP3			    int NULL,
OfertaIDG1			    int NULL,
OfertaIDG2			    int NULL,
OfertaIDG3			    int NULL,
Descripcion			    varchar(255) NULL)
CREATE TABLE #ArtObsequio (Articulo varchar(20) COLLATE Database_Default NOT NULL, OfertaID INT NULL, Unidad varchar(50) NULL, SubCuenta varchar(50) NULL)
INSERT #VentaD (
Renglon,   RenglonSub,   RenglonTipo,   Articulo,   SubCuenta,   Rama,   Categoria,   Grupo,   Familia,   Linea,   Fabricante,   Proveedor,
Cantidad,   Unidad,   PrecioSugerido, CantidadInventario, Almacen,SucursalDetalle, Impuesto1, Descuento, DescuentoAd)
SELECT
d.Renglon, d.RenglonSub, d.RenglonTipo,d.Articulo, d.SubCuenta, a.Rama, a.Categoria, a.Grupo, a.Familia, a.Linea, a.Fabricante, a.Proveedor,
d.Cantidad, d.Unidad, PrecioSugerido, ISNULL(ISNULL(d.CantidadInventario, d.Cantidad*dbo.fnArtUnidadFactor(@Empresa, d.Articulo, d.Unidad)), 0.0),
p.Almacen,@Sucursal,d.Impuesto1, NULL, d.DescuentoAd
FROM POSLVenta d WITH (NOLOCK)
JOIN POSL p WITH (NOLOCK) ON p.ID = d.ID
JOIN Art a WITH (NOLOCK) ON a.Articulo = d.Articulo
WHERE d.ID = @ID AND ISNULL(d.Aplicado,0) = 0 AND d.Articulo NOT IN(@ArticuloRedondeo,@CfgAnticipoArticuloServicio,@ArtOfertaFP) AND d.RenglonTipo <> 'K'
CREATE INDEX Renglon    ON #VentaD (Renglon, RenglonSub)
CREATE INDEX Articulo   ON #VentaD (Articulo)
CREATE INDEX Rama       ON #VentaD (Rama)
CREATE INDEX Categoria  ON #VentaD (Categoria)
CREATE INDEX Grupo      ON #VentaD (Grupo)
CREATE INDEX Familia    ON #VentaD (Familia)
CREATE INDEX Linea      ON #VentaD (Linea)
CREATE INDEX Fabricante ON #VentaD (Fabricante)
CREATE INDEX RenglonTipo ON #VentaD (Renglon, RenglonSub, RenglonTipo)
CREATE TABLE #OfertaActiva (ID int NOT NULL, Sucursal int NOT NULL, MovTipo varchar(20) COLLATE Database_Default NULL PRIMARY KEY (ID, Sucursal))
EXEC spOfertaPrecioSugerido @Empresa, @Sucursal, @Moneda, @TipoCambio, @ListaPrecios
SELECT @ImporteTotalMN = SUM(Cantidad*PrecioSugerido)*@TipoCambio FROM #VentaD
EXEC spOfertaActiva @Empresa, @Sucursal, @FechaHora, @ImporteTotalMN
EXEC spOfertaProcesar @Empresa, @Sucursal, @Moneda, @TipoCambio, @ListaPrecios, @ID = NULL, @PuntosPrecio=@PuntosPrecio
UPDATE #VentaD
SET OfertaID = ISNULL(OfertaIDP1,ISNULL(OfertaIDP2,ISNULL(OfertaIDP3,ISNULL(OfertaIDG1,ISNULL(OfertaIDG2,ISNULL(OfertaIDG2,0))))))
WHERE ISNULL(OfertaID,0) = 0
UPDATE #VentaD
SET Descuento = dbo.fnPorcentajeImporte(Cantidad*Precio, DescuentoImporte)
WHERE NULLIF(DescuentoImporte, 0.0) IS NOT NULL
UPDATE #VentaD
SET Puntos = CASE WHEN EXISTS(SELECT ID FROM Oferta WITH (NOLOCK) WHERE Estatus = 'VIGENTE' AND (FORMA LIKE '%PUNTOS%' AND FORMA LIKE '%CANTIDAD%'))
THEN Puntos
ELSE
dbo.fnPorcentaje(dbo.fnDisminuyePorcentaje(Cantidad*Precio, Descuento), PuntosPorcentaje)
END
WHERE NULLIF(PuntosPorcentaje, 0.0) IS NOT NULL
UPDATE #VentaD
SET Puntos =  CASE WHEN EXISTS(SELECT ID FROM Oferta WITH (NOLOCK) WHERE Estatus = 'VIGENTE' AND (FORMA LIKE '%PUNTOS%' AND FORMA LIKE '%CANTIDAD%'))
THEN Puntos
ELSE
Puntos*Cantidad
END
WHERE Puntos IS NOT NULL AND NULLIF(PuntosPorcentaje, 0.0) IS NULL
UPDATE #VentaD
SET Comision = dbo.fnPorcentaje(dbo.fnDisminuyePorcentaje(Cantidad*Precio, Descuento), ComisionPorcentaje)
WHERE NULLIF(ComisionPorcentaje, 0.0) IS NOT NULL
UPDATE #VentaD
SET PrecioSugerido = ROUND(PrecioSugerido,@RedondeoMonetarios), Precio = ROUND(Precio,@RedondeoMonetarios)
UPDATE POSLVenta WITH (ROWLOCK)
SET PrecioSugerido = ISNULL(d.PrecioSugerido, t.PrecioSugerido),
Precio = dbo.fnPOSPrecio(@Empresa,ISNULL(t.Precio, t.PrecioSugerido),d.Impuesto1, d.Impuesto2, d.Impuesto3),
DescuentoLinea = ISNULL(t.Descuento,DescuentoLinea),
DescuentoImporte = NULL,
Comision = t.Comision,
CantidadObsequio = t.CantidadObsequio,
OfertaID = t.OfertaID,
Puntos = CASE WHEN EXISTS(SELECT ID FROM Oferta WITH (NOLOCK) WHERE Estatus = 'VIGENTE' AND (FORMA LIKE '%IMPORTE%' AND FORMA LIKE '%PUNTOS%')
AND (USAR LIKE '%CANTIDAD%' OR USAR LIKE '%PORCENTAJE%') AND ID = t.OfertaID)
THEN t.Puntos
WHEN EXISTS(SELECT ID FROM Oferta WITH (NOLOCK) WHERE Estatus = 'VIGENTE' AND FORMA LIKE '%PUNTOS%' AND USAR LIKE '%CANTIDAD%')
THEN t.Puntos
WHEN EXISTS(SELECT ID FROM Oferta WITH (NOLOCK) WHERE Estatus = 'VIGENTE' AND FORMA LIKE '%PUNTOS%' AND ID = t.OfertaID)
THEN dbo.fnImporteMonTarjeta2(t.Precio*t.Cantidad,@Monedero,t.OfertaID,@Sucursal)
END
FROM POSLVenta d
JOIN #VentaD t ON t.Renglon = d.Renglon AND t.RenglonSub = d.RenglonSub AND t.RenglonTipo = d.RenglonTipo
WHERE d.ID = @ID AND d.RenglonTipo <>'C'
AND ISNULL(d.Aplicado,0) = 0
UPDATE POSLVenta WITH (ROWLOCK) SET PrecioImpuestoInc = dbo.fnPOSPrecioConImpuestos(Precio,Impuesto1, Impuesto2, Impuesto3, @Empresa)
WHERE ID = @ID AND RenglonTipo <>'C'
AND ISNULL(Aplicado,0) = 0
SELECT @Usar =NULLIF(o.Usar,''), @Forma = NULLIF(o.Forma,''), @OfertaID = o.id
FROM POSLVenta d WITH (NOLOCK)
JOIN #VentaD t ON t.Renglon = d.Renglon AND t.RenglonSub = d.RenglonSub AND t.RenglonTipo = d.RenglonTipo
JOIN oferta o WITH (NOLOCK) ON O.Id = t.OfertaID
WHERE d.ID = @ID AND d.RenglonTipo <>'C' AND ISNULL(d.Aplicado,0) = 0
IF (@Usar <> 'PORCENTAJE' and @Forma <> 'PUNTOS'  and  NULLIF(@Usar,'') IS NOT NULL AND NULLIF(@Forma,'') IS NOT NULL)
BEGIN
IF (SELECT COUNT(*) FROM #OfertaLog) > 0
BEGIN
DELETE OfertaLogPos WHERE ID = @ID AND Articulo IN (SELECT Articulo FROM #OfertaLog)
INSERT OfertaLogPos (ID, OfertaID, RID, Prioridad, PrioridadG, Mov,MovID, Tipo, Forma, Usar, Articulo,
SubCuenta, Unidad, Descuento, DescuentoImporte, Costo, PrecioBaseCosto, PrecioBaseLista,
Precio, Puntos, PuntosPorcentaje, Comision, ArticuloObsequio, CantidadObsequio,
ComisionPorcentaje, UnidadObsequio, DescuentoP1,DescuentoP2, DescuentoP3, DescuentoG1,
DescuentoG2, DescuentoG3, OfertaIDP1, OfertaIDP2, OfertaIDP3, OfertaIDG1, OfertaIDG2,
OfertaIDG3,EsPuntos, Descripcion, SubCuentaObsequio)
SELECT @ID,OfertaID, RID, Prioridad, PrioridadG, Mov, MovID, Tipo, Forma, Usar, Articulo,
SubCuenta, Unidad, Descuento, DescuentoImporte, Costo, PrecioBaseCosto, PrecioBaseLista,
Precio, Puntos, PuntosPorcentaje, Comision, ArticuloObsequio, CantidadObsequio,
ComisionPorcentaje, UnidadObsequio, DescuentoP1,DescuentoP2, DescuentoP3, DescuentoG1,
DescuentoG2, DescuentoG3, OfertaIDP1, OfertaIDP2, OfertaIDP3, OfertaIDG1,
OfertaIDG2, OfertaIDG3,1, Descripcion, SubCuentaObsequio
FROM #OfertaLog
END
ELSE
RETURN
END
ELSE
BEGIN
IF (SELECT COUNT(*) FROM #OfertaLog) > 0
BEGIN
DELETE OfertaLogPos WHERE ID = @ID AND Articulo IN (SELECT Articulo FROM #OfertaLog)
INSERT OfertaLogPos (ID, OfertaID, RID, Prioridad, PrioridadG, Mov,MovID, Tipo, Forma, Usar, Articulo,
SubCuenta, Unidad, Descuento, DescuentoImporte, Costo, PrecioBaseCosto, PrecioBaseLista,
Precio, Puntos, PuntosPorcentaje, Comision, ArticuloObsequio, CantidadObsequio,
ComisionPorcentaje, UnidadObsequio, DescuentoP1,DescuentoP2, DescuentoP3, DescuentoG1,
DescuentoG2, DescuentoG3, OfertaIDP1, OfertaIDP2, OfertaIDP3, OfertaIDG1, OfertaIDG2,
OfertaIDG3,EsPuntos, Descripcion, SubCuentaObsequio)
SELECT @ID,OfertaID, RID, Prioridad, PrioridadG, Mov, MovID, Tipo, Forma, Usar, Articulo,
SubCuenta, Unidad, Descuento, DescuentoImporte, Costo, PrecioBaseCosto, PrecioBaseLista,
Precio, Puntos, PuntosPorcentaje, Comision, ArticuloObsequio, CantidadObsequio,
ComisionPorcentaje, UnidadObsequio, DescuentoP1,DescuentoP2, DescuentoP3, DescuentoG1,
DescuentoG2, DescuentoG3, OfertaIDP1, OfertaIDP2, OfertaIDP3, OfertaIDG1,
OfertaIDG2, OfertaIDG3,1, Descripcion, SubCuentaObsequio
FROM #OfertaLog
END
ELSE
RETURN
END
END
RETURN
END

