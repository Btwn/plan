SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spPOSOfertaImportePuntosAplicar
@ID               	varchar(50),
@OfertaFechaHora	varchar(20)	= NULL,
@PuntosPrecio       bit      =       1

AS
BEGIN
DECLARE
@Empresa						varchar(5),
@Mov							varchar(20),
@Sucursal						int,
@Usuario						varchar(10),
@ListaPrecios					varchar(50),
@FechaHora						datetime,
@Estatus						varchar(15),
@FechaEmision					datetime,
@FechaRequerida					datetime,
@HoraRequerida					varchar(5),
@Moneda							varchar(10),
@TipoCambio						float,
@DescuentoGlobal				float,
@ImporteTotalMN					float,
@Aplica							bit,
@Monedero						varchar(20),
@ArticuloOferta					varchar(20),
@CodigoRedondeo					varchar(30),
@ArticuloRedondeo				varchar(20),
@ArtOfertaImporte				varchar(20),
@ArtOfertaFP					varchar(20),
@CfgAnticipoArticuloServicio	varchar(20)
SELECT @CodigoRedondeo = RedondeoVentaCodigo , @ArtOfertaFP = ArtOfertaFP, @ArtOfertaImporte = ArtOfertaImporte
FROM POSCfg WITH (NOLOCK)
WHERE Empresa = @Empresa
SELECT @ArticuloRedondeo = Cuenta
FROM CB WITH (NOLOCK)
WHERE Codigo = @CodigoRedondeo
AND TipoCuenta = 'Articulos'
SELECT @ArticuloRedondeo = cb.Cuenta
FROM CB WITH (NOLOCK)
WHERE CB.Cuenta = @CodigoRedondeo AND CB.TipoCuenta = 'Articulos'
SELECT @CfgAnticipoArticuloServicio = NULLIF(CxcAnticipoArticuloServicio,'')
FROM EmpresaCfg2 WITH (NOLOCK)
WHERE Empresa = @Empresa
SELECT @Mov = Mov, @Empresa = Empresa, @Sucursal = Sucursal, @Usuario = Usuario, @Moneda = Moneda, @TipoCambio = TipoCambio, @Estatus = Estatus,
@ListaPrecios = ListaPreciosEsp, @FechaEmision = FechaEmision, @FechaRequerida = FechaEmision, @HoraRequerida = '00:00',
@DescuentoGlobal = DescuentoGlobal,@Monedero = Monedero
FROM POSL WITH (NOLOCK)
WHERE ID = @ID
SELECT @ArticuloOferta = ArtOfertaImporte
FROM POSCfg WITH (NOLOCK)
WHERE Empresa = @Empresa
IF NULLIF(@Monedero,'') IS NOT NULL AND @PuntosPrecio = 1
SET @PuntosPrecio = 1
ELSE
SET @PuntosPrecio = 0
SET @Aplica = 1
EXEC xpPOSOfertaAplicar @ID, @Aplica OUTPUT
IF @Aplica = 1
BEGIN
IF @OfertaFechaHora IS NULL
SELECT @OfertaFechaHora = OfertaFechaHora FROM EmpresaCfg2 WITH (NOLOCK) WHERE Empresa = @Empresa
IF UPPER(@OfertaFechaHora) = 'FECHA SERVIDOR'
SELECT @FechaHora = GETDATE()
ELSE
IF UPPER(@OfertaFechaHora) = 'FECHA EMISION'
SELECT @FechaHora = @FechaEmision
ELSE
IF UPPER(@OfertaFechaHora) = 'FECHA REQUERIDA'
SELECT @FechaHora = dbo.FechaConHora(@FechaRequerida, @HoraRequerida)
CREATE TABLE #Venta (Campo varchar(50) COLLATE Database_Default NOT NULL, Valor varchar(100) COLLATE Database_Default NULL)
EXEC spPOSOfertaVenta @ID
CREATE INDEX Campo ON #Venta (Campo, Valor)
CREATE TABLE #VentaD (
RID						int NOT NULL IDENTITY(1,1) PRIMARY KEY,
Renglon					float NOT NULL,
RenglonSub				int NOT NULL,
RenglonTipo             varchar(1) NOT NULL,
Articulo				varchar(20) COLLATE Database_Default NOT NULL,
SubCuenta				varchar(50) COLLATE Database_Default NULL,
Rama					varchar(20) COLLATE Database_Default NULL,
Categoria				varchar(50) COLLATE Database_Default NULL,
Grupo					varchar(50) COLLATE Database_Default NULL,
Familia					varchar(50) COLLATE Database_Default NULL,
Linea					varchar(50) COLLATE Database_Default NULL,
Fabricante				varchar(50) COLLATE Database_Default NULL,
Proveedor				varchar(10) COLLATE Database_Default NULL,
ABC						varchar(50) COLLATE Database_Default NULL,
Cantidad				float NULL,
Unidad					varchar(50) COLLATE Database_Default NULL,
CantidadInventario		float NULL,
PrecioSugerido			float NULL,
Precio					float NULL,
Impuesto1				float NULL,
Descuento				float NULL,
DescuentoP1				float NULL,
DescuentoP2				float NULL,
DescuentoP3				float NULL,
DescuentoG1				float NULL,
DescuentoG2				float NULL,
DescuentoG3				float NULL,
DescuentoImporte		float NULL,
Puntos					float NULL,
PuntosPorcentaje		float NULL,
Comision				float NULL,
ComisionPorcentaje		float NULL,
CantidadObsequio		float NULL,
OfertaID				int NULL,
OfertaIDP1				int NULL,
OfertaIDP2				int NULL,
OfertaIDP3				int NULL,
OfertaIDG1				int NULL,
OfertaIDG2				int NULL,
OfertaIDG3				int NULL,
DescuentoAd				int	NULL)
CREATE TABLE #ArtObsequio (Articulo varchar(20) COLLATE Database_Default NOT NULL, OfertaID INT NULL, Unidad varchar(50) NULL, SubCuenta varchar(50) NULL)
CREATE TABLE #OfertaLog (
RID						int NOT NULL IDENTITY(1,1) PRIMARY KEY,
OfertaID				int NOT NULL,
Mov						varchar(20)NULL,
MovID					varchar(20)NULL,
Prioridad				int NULL,
PrioridadG				int NULL,
Tipo					varchar(50)NULL,
Forma					varchar(50)NULL,
Usar					varchar(50)NULL,
Articulo				varchar(20) COLLATE Database_Default NOT NULL,
SubCuenta				varchar(50) COLLATE Database_Default NULL,
Unidad					varchar(50) COLLATE Database_Default NULL,
Descuento				float NULL,
DescuentoImporte		money NULL,
Puntos					float NULL,
PuntosPorcentaje		float NULL,
Comision				float NULL,
ComisionPorcentaje		float NULL,
CantidadObsequio		float NULL,
Costo					float NULL,
PrecioBaseCosto			float NULL,
PrecioBaseLista			float NULL,
Precio					float NULL,
ArticuloObsequio		varchar(20)NULL,
UnidadObsequio			varchar(5) NULL,
SubCuentaObsequio		varchar(50) NULL,
ArtTipo					varchar(20)NULL,
CantidadOferta			float NULL,
DescuentoP1				float NULL,
DescuentoP2				float NULL,
DescuentoP3				float NULL,
DescuentoG1				float NULL,
DescuentoG2				float NULL,
DescuentoG3				float NULL,
SucursalDetalle			int	 NULL,
OfertaIDP1				int NULL,
OfertaIDP2				int NULL,
OfertaIDP3				int NULL,
OfertaIDG1				int NULL,
OfertaIDG2				int NULL,
OfertaIDG3				int NULL,
Descripcion				varchar(255) NULL)
INSERT #VentaD (
Renglon, RenglonSub, RenglonTipo, Articulo, SubCuenta, Rama, Categoria, Grupo, Familia, Linea, Fabricante, Proveedor,
Cantidad, Unidad, PrecioSugerido, CantidadInventario,
OfertaID, OfertaIDP1, OfertaIDP2, OfertaIDP3, OfertaIDG1, OfertaIDG2, OfertaIDG3, DescuentoP1, DescuentoP2,
DescuentoP3, DescuentoG1, DescuentoG2, DescuentoG3, Descuento, DescuentoAd)
SELECT
d.Renglon, d.RenglonSub, d.RenglonTipo,d.Articulo, d.SubCuenta, a.Rama, a.Categoria, a.Grupo, a.Familia, a.Linea, a.Fabricante, a.Proveedor,
d.Cantidad, d.Unidad, d.PrecioSugerido, ISNULL(ISNULL(d.CantidadInventario, d.Cantidad*dbo.fnArtUnidadFactor(@Empresa, d.Articulo, d.Unidad)), 0.0),
d.OfertaID, d.OfertaIDP1, d.OfertaIDP2, d.OfertaIDP3, d.OfertaIDG1, d.OfertaIDG2, d.OfertaIDG3, d.DescuentoP1, d.DescuentoP2,
d.DescuentoP3, d.DescuentoG1, d.DescuentoG2, d.DescuentoG3, d.DescuentoLinea, d.DescuentoAd
FROM POSLVenta d WITH (NOLOCK)
JOIN Art a WITH (NOLOCK) ON a.Articulo = d.Articulo
WHERE d.ID = @ID
AND ISNULL(d.Aplicado,0) = 0
AND d.Articulo NOT IN(@ArticuloRedondeo,@CfgAnticipoArticuloServicio,@ArtOfertaFP,@ArtOfertaImporte)
AND d.RenglonTipo <> 'K'
CREATE INDEX Renglon    ON #VentaD (Renglon, RenglonSub)
CREATE INDEX Articulo   ON #VentaD (Articulo)
CREATE INDEX Rama       ON #VentaD (Rama)
CREATE INDEX Categoria  ON #VentaD (Categoria)
CREATE INDEX Grupo      ON #VentaD (Grupo)
CREATE INDEX Familia    ON #VentaD (Familia)
CREATE INDEX Linea      ON #VentaD (Linea)
CREATE INDEX Fabricante ON #VentaD (Fabricante)
CREATE TABLE #OfertaActiva (ID int NOT NULL PRIMARY KEY, Sucursal int NULL, MovTipo varchar(20) COLLATE Database_Default NULL)
EXEC spOfertaPrecioSugerido @Empresa, @Sucursal, @Moneda, @TipoCambio, @ListaPrecios
IF (SELECT NULLIF(IDDevolucion,'') FROM POSL WITH (NOLOCK) WHERE ID = @ID) IS NOT NULL
RETURN
IF (SELECT NULLIF(IDDevolucionP,'') FROM POSL WITH (NOLOCK) WHERE ID = @ID) IS NOT NULL
RETURN
SELECT @ImporteTotalMN = SUM(Cantidad*PrecioSugerido)*@TipoCambio FROM #VentaD
EXEC spOfertaActiva @Empresa, @Sucursal, @FechaHora, @ImporteTotalMN
EXEC spOfertaProcesar @Empresa, @Sucursal, @Moneda, @TipoCambio, @ListaPrecios, @ID = NULL, @PuntosPrecio=@PuntosPrecio
UPDATE #VentaD
SET Descuento = dbo.fnPorcentajeImporte(t.Cantidad*d.PrecioImpuestoInc, t.DescuentoImporte)
FROM POSLVenta d WITH (NOLOCK)
JOIN #VentaD t ON t.Renglon = d.Renglon AND t.RenglonSub = d.RenglonSub AND t.RenglonTipo = d.RenglonTipo
WHERE d.ID = @ID AND d.RenglonTipo <>'C' AND NULLIF(t.DescuentoImporte, 0.0) IS NOT NULL
AND ISNULL(d.Aplicado,0) = 0
UPDATE #VentaD
SET Puntos = dbo.fnPorcentaje(dbo.fnDisminuyePorcentaje(Cantidad*Precio, Descuento), PuntosPorcentaje)
WHERE NULLIF(PuntosPorcentaje, 0.0) IS NOT NULL
UPDATE #VentaD
SET Puntos = Puntos
WHERE Puntos IS NOT NULL AND NULLIF(PuntosPorcentaje, 0.0) IS NULL
UPDATE #VentaD
SET Comision = dbo.fnPorcentaje(dbo.fnDisminuyePorcentaje(Cantidad*Precio, Descuento), ComisionPorcentaje)
WHERE NULLIF(ComisionPorcentaje, 0.0) IS NOT NULL
IF (SELECT SUM(ISNULL(CantidadObsequio,0)) FROM POSLVenta WITH (NOLOCK) WHERE ID = @ID) > = 0
BEGIN
UPDATE POSLVenta WITH (ROWLOCK)
SET PrecioSugerido		= ISNULL(d.PrecioSugerido, t.PrecioSugerido),
Precio				= dbo.fnPOSPrecio(@Empresa,ISNULL(t.Precio, t.PrecioSugerido),d.Impuesto1, d.Impuesto2, d.Impuesto3),
DescuentoImporte		= ISNULL(d.DescuentoImporte, t.DescuentoImporte),
Puntos				= t.Puntos, 
Comision				= t.Comision,
CantidadObsequio		= t.CantidadObsequio,
DescuentoLinea		= CASE WHEN
CASE WHEN ISNULL(t.DescuentoImporte, d.DescuentoImporte) = 0 THEN d.DescuentoImporte ELSE 0 END
> 0 THEN ISNULL(t.Descuento,DescuentoLinea)
ELSE ISNULL(DescuentoLinea, ISNULL(t.DescuentoG1, (ISNULL(t.DescuentoG2, t.DescuentoG3 )))) END,
DescuentoP1			= ISNULL(t.DescuentoP1,d.DescuentoP1),
DescuentoP2			= ISNULL(t.DescuentoP2,d.DescuentoP2),
DescuentoP3			= ISNULL(t.DescuentoP3,d.DescuentoP3),
DescuentoG1			= ISNULL(t.DescuentoG1,d.DescuentoG1),
DescuentoG2			= ISNULL(t.DescuentoG2,d.DescuentoG2),
DescuentoG3			= ISNULL(t.DescuentoG3,d.DescuentoG3),
OfertaID				= t.OfertaID,
OfertaIDP1			= t.OfertaIDP1,
OfertaIDP2			= t.OfertaIDP2,
OfertaIDP3			= t.OfertaIDP3,
OfertaIDG1			= t.OfertaIDG1,
OfertaIDG2			= t.OfertaIDG2,
OfertaIDG3			= t.OfertaIDG3
FROM POSLVenta d
JOIN #VentaD t ON t.Renglon = d.Renglon AND t.RenglonSub = d.RenglonSub AND t.RenglonTipo = d.RenglonTipo
WHERE d.ID = @ID AND d.RenglonTipo <>'C'
AND ISNULL(d.Aplicado,0) = 0
UPDATE POSLVenta WITH (ROWLOCK)
SET DescuentoLinea = dbo.fnPorcentajeImporte(t.Cantidad*d.PrecioImpuestoInc, d.DescuentoImporte)
FROM POSLVenta d 
JOIN #VentaD t ON t.Renglon = d.Renglon AND t.RenglonSub = d.RenglonSub AND t.RenglonTipo = d.RenglonTipo
WHERE d.ID = @ID AND d.RenglonTipo <>'C'
AND ISNULL(d.Aplicado,0) = 0 AND d.DescuentoImporte > 0
UPDATE POSLVenta
SET PrecioImpuestoInc = dbo.fnPOSPrecioConImpuestos(Precio,Impuesto1, Impuesto2, Impuesto3, @Empresa)
WHERE ID = @ID AND RenglonTipo <>'C'
AND ISNULL(Aplicado,0) = 0
END
END
RETURN
END

