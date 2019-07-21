SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spOfertaAplicar
@ID               	int,
@OfertaFechaHora	varchar(20)	= NULL

AS BEGIN
DECLARE
@Empresa		varchar(5),
@Mov		varchar(20),
@Sucursal		int,
@Usuario		varchar(10),
@ListaPrecios	varchar(50),
@FechaHora		datetime,
@Estatus		varchar(15),
@FechaEmision	datetime,
@FechaRequerida	datetime,
@HoraRequerida	varchar(5),
@Moneda		varchar(10),
@TipoCambio		float,
@DescuentoGlobal	float,
@ImporteTotalMN	money,
@Aplica				bit, 
@SucursalDetalle	int,
@VentaMultiAlmacen	bit,
@Monedero           varchar(20),
@PuntosPrecio       bit,
@OfertaAplicaLog	bit
SET @PuntosPrecio = 0
UPDATE VentaD
SET DescuentoLinea = CASE WHEN OfertaID IS NOT NULL THEN NULL ELSE DescuentoLinea END, 
OfertaID	= NULL,
OfertaIDG1 = NULL,
OfertaIDG2 = NULL,
OfertaIDG3 = NULL,
OfertaIDP1 = NULL,
OfertaIDP2 = NULL,
OfertaIDP3 = NULL,
DescuentoG1 = NULL,
DescuentoG2 = NULL,
DescuentoG3 = NULL
WHERE ID = @ID
SELECT @Mov = v.Mov, @Empresa = v.Empresa, @Sucursal = v.Sucursal, @Usuario = v.Usuario, @Moneda = v.Moneda, @TipoCambio = v.TipoCambio, @Estatus = v.Estatus, @ListaPrecios = v.ListaPreciosEsp,
@FechaEmision = v.FechaEmision, @FechaRequerida = v.FechaRequerida, @HoraRequerida = v.HoraRequerida, @DescuentoGlobal = v.DescuentoGlobal, @Monedero = NULLIF(v.Monedero,'')
FROM Venta v
JOIN MovTipo mt ON mt.Mov = v.Mov
WHERE ID = @ID AND mt.Modulo = 'VTAS'
SELECT @OfertaAplicaLog = CASE
WHEN (ISNULL(OfertaAplicaLog, 0) > 0) THEN OfertaAplicaLog
WHEN (ISNULL(OfertaAplicaLogPOS, 0) > 0) THEN OfertaAplicaLogPOS
ELSE 0
END
FROM EmpresaCfg2 ec
WHERE ec.Empresa = @Empresa
IF EXISTS(SELECT *  FROM TarjetaSerieMov v JOIN ValeSerie s ON  v.Serie = s.Serie  WHERE v.Empresa = @Empresa AND v.Modulo = 'VTAS' AND v.ID = @ID AND s.TipoTarjeta = 1)
SELECT TOP 1 @Monedero = Serie
FROM TarjetaSerieMov
WHERE Empresa = @Empresa AND Modulo = 'VTAS' AND ID = @ID
IF NULLIF(@Monedero,'') IS NOT NULL
SET @PuntosPrecio = 1
SELECT @VentaMultiAlmacen = ISNULL(VentaMultiAlmacen,0) FROM EmpresaCfg2 WHERE Empresa = @Empresa
SET @Aplica = 1
EXEC xpOfertaAplicar @ID, @Aplica OUTPUT 
IF @Estatus IN ('SINAFECTAR', 'BORRADOR', 'CONFIRMAR') AND (SELECT AplicarOfertas FROM MovTipo WHERE Modulo = 'VTAS' AND Mov = @Mov) = 1 AND @Aplica = 1 
BEGIN
IF @OfertaFechaHora IS NULL
SELECT @OfertaFechaHora = OfertaFechaHora
FROM EmpresaCfg2
WHERE Empresa = @Empresa
IF UPPER(@OfertaFechaHora) = 'FECHA SERVIDOR'  SELECT @FechaHora = GETDATE() ELSE
IF UPPER(@OfertaFechaHora) = 'FECHA EMISION'   SELECT @FechaHora = @FechaEmision ELSE
IF UPPER(@OfertaFechaHora) = 'FECHA REQUERIDA' SELECT @FechaHora = dbo.FechaConHora(@FechaRequerida, @HoraRequerida)
CREATE TABLE #Venta (Campo varchar(50) COLLATE Database_Default NOT NULL, Valor varchar(100) COLLATE Database_Default NULL)
CREATE TABLE #VentaDetalle (Renglon float, Campo varchar(50) COLLATE Database_Default NOT NULL, Valor varchar(100) COLLATE Database_Default NULL)
EXEC spOfertaVenta @ID
CREATE INDEX Campo ON #Venta (Campo, Valor)
CREATE INDEX Campo ON #VentaDetalle (Renglon, Campo, Valor)
CREATE TABLE #VentaD (
RID					int NOT NULL IDENTITY(1,1) PRIMARY KEY,
Renglon				float NOT NULL,
RenglonSub			int NOT NULL,
RenglonTipo			varchar(1)  COLLATE Database_Default NULL,  
Articulo				varchar(20) COLLATE Database_Default NOT NULL,
SubCuenta				varchar(50) COLLATE Database_Default NULL,
Rama					varchar(20) COLLATE Database_Default NULL,
Categoria				varchar(50) COLLATE Database_Default NULL,
Grupo					varchar(50) COLLATE Database_Default NULL,
Familia				varchar(50) COLLATE Database_Default NULL,
Linea					varchar(50) COLLATE Database_Default NULL,
Fabricante			varchar(50) COLLATE Database_Default NULL,
Proveedor				varchar(10) COLLATE Database_Default NULL,
ABC                   varchar(50) COLLATE Database_Default NULL,
Cantidad				float NULL,
Unidad				varchar(50) COLLATE Database_Default NULL,
CantidadInventario	float NULL,
PrecioSugerido		float NULL,
Precio				float NULL,
Impuesto1             float NULL,
Descuento				float NULL,
DescuentoP1			float NULL,
DescuentoP2			float NULL,
DescuentoP3			float NULL,
DescuentoG1			float NULL,
DescuentoG2			float NULL,
DescuentoG3			float NULL,
DescuentoImporte		money NULL,
Puntos				float NULL,
PuntosPorcentaje		float NULL,
Comision				float NULL,
ComisionPorcentaje	float NULL,
CantidadObsequio		float NULL,
SucursalDetalle	    int	 NULL,
Almacen		        varchar(20) COLLATE Database_Default NOT NULL,
OfertaID				int NULL,
OfertaIDP1			int NULL,
OfertaIDP2			int NULL,
OfertaIDP3			int NULL,
OfertaIDG1			int NULL,
OfertaIDG2			int NULL,
OfertaIDG3			int NULL,
DescuentoAd			float NULL)
CREATE TABLE #ArtObsequio (Articulo varchar(20) COLLATE Database_Default NOT NULL, OfertaID INT NULL, Unidad varchar(50) NULL, SubCuenta varchar(50) NULL)
CREATE TABLE #OfertaLog (
RID					        int NOT NULL IDENTITY(1,1) PRIMARY KEY,
OfertaID            int NOT NULL,
Mov                 varchar(20)NULL,
MovID               varchar(20)NULL,
Prioridad				    int NULL,
PrioridadG			    int NULL,
Tipo                varchar(50)NULL,
Forma               varchar(50)NULL,
Usar                varchar(50)NULL,
Articulo				    varchar(20) COLLATE Database_Default NOT NULL,
SubCuenta				    varchar(50) COLLATE Database_Default NULL,
Unidad				      varchar(50) COLLATE Database_Default NULL,
Descuento				    float NULL,
DescuentoImporte		money NULL,
Puntos				      float NULL,
PuntosPorcentaje		float NULL,
Comision				    float NULL,
ComisionPorcentaje	float NULL,
CantidadObsequio		float NULL,
Costo					      float NULL,
PrecioBaseCosto		  float NULL,
PrecioBaseLista		  float NULL,
Precio				      float NULL,
ArticuloObsequio		varchar(20)NULL,
UnidadObsequio		  varchar(50) NULL,
SubCuentaObsequio varchar(50) NULL,
ArtTipo				      varchar(20)NULL,
CantidadOferta		  float NULL,
DescuentoP1			    float NULL,
DescuentoP2			    float NULL,
DescuentoP3			    float NULL,
DescuentoG1			    float NULL,
DescuentoG2			    float NULL,
DescuentoG3			    float NULL,
SucursalDetalle	    int	 NULL,
OfertaIDP1			    int NULL,
OfertaIDP2			    int NULL,
OfertaIDP3			    int NULL,
OfertaIDG1			    int NULL,
OfertaIDG2			    int NULL,
OfertaIDG3			    int NULL,
Descripcion			    varchar(255) NULL)
INSERT #VentaD (
Renglon,   RenglonSub,   RenglonTipo,   Articulo,   SubCuenta,   Rama,   Categoria,   Grupo,   Familia,   Linea,   Fabricante,   Proveedor,   ABC, Cantidad,   Unidad,   PrecioSugerido, Impuesto1, CantidadInventario, Almacen, OfertaID, OfertaIDP1, OfertaIDP2, OfertaIDP3, OfertaIDG1, OfertaIDG2, OfertaIDG3, DescuentoP1, DescuentoP2, DescuentoP3, DescuentoG1, DescuentoG2, DescuentoG3, Descuento, SucursalDetalle)
SELECT d.Renglon, d.RenglonSub, d.RenglonTipo, d.Articulo, d.SubCuenta, a.Rama, a.Categoria, a.Grupo, a.Familia, a.Linea, a.Fabricante, a.Proveedor, a.ABC, d.Cantidad, d.Unidad, PrecioSugerido, d.Impuesto1, ISNULL(ISNULL(d.CantidadInventario, d.Cantidad*dbo.fnArtUnidadFactor(@Empresa, d.Articulo, d.Unidad)), 0.0), ISNULL(d.Almacen,v.Almacen), d.OfertaID, d.OfertaIDP1, d.OfertaIDP2, d.OfertaIDP3, d.OfertaIDG1, d.OfertaIDG2, d.OfertaIDG3, d.DescuentoP1, d.DescuentoP2, d.DescuentoP3, d.DescuentoG1, d.DescuentoG2, d.DescuentoG3, d.DescuentoLinea, ISNULL(d.Sucursal,v.Sucursal)
FROM VentaD d
JOIN Venta v ON d.ID = v.ID
JOIN Art a ON a.Articulo = d.Articulo
WHERE d.ID = @ID AND ISNULL(d.AnticipoFacturado,0) = 0
CREATE INDEX Renglon     ON #VentaD (Renglon, RenglonSub)
CREATE INDEX Articulo    ON #VentaD (Articulo)
CREATE INDEX Rama        ON #VentaD (Rama)
CREATE INDEX Categoria   ON #VentaD (Categoria)
CREATE INDEX Grupo       ON #VentaD (Grupo)
CREATE INDEX Familia     ON #VentaD (Familia)
CREATE INDEX Linea       ON #VentaD (Linea)
CREATE INDEX Fabricante  ON #VentaD (Fabricante)
CREATE INDEX RenglonTipo ON #VentaD (Renglon, RenglonSub, RenglonTipo)
CREATE TABLE #OfertaActiva (ID int NOT NULL, Sucursal int NOT NULL, MovTipo varchar(20) COLLATE Database_Default NULL PRIMARY KEY (ID, Sucursal))
IF @VentaMultiAlmacen = 0
BEGIN
EXEC spOfertaPrecioSugerido @Empresa, @Sucursal, @Moneda, @TipoCambio, @ListaPrecios
SELECT @ImporteTotalMN = SUM(Cantidad*PrecioSugerido)*@TipoCambio FROM #VentaD
EXEC spOfertaActiva @Empresa, @Sucursal, @FechaHora, @ImporteTotalMN
EXEC spOfertaProcesar @Empresa, @Sucursal, @Moneda, @TipoCambio, @ListaPrecios, @ID, @PuntosPrecio
END
ELSE
BEGIN
DECLARE crSucursalDetalleOferta CURSOR FOR
SELECT SucursalDetalle
FROM #VentaD
GROUP BY SucursalDetalle
OPEN crSucursalDetalleOferta
FETCH NEXT FROM crSucursalDetalleOferta INTO @SucursalDetalle
WHILE @@FETCH_STATUS <> -1
BEGIN
EXEC spOfertaPrecioSugerido @Empresa, @SucursalDetalle, @Moneda, @TipoCambio, @ListaPrecios
SELECT @ImporteTotalMN = SUM(Cantidad*PrecioSugerido)*@TipoCambio FROM #VentaD
EXEC spOfertaActiva @Empresa, @SucursalDetalle, @FechaHora, @ImporteTotalMN
EXEC spOfertaProcesar @Empresa, @SucursalDetalle, @Moneda, @TipoCambio, @ListaPrecios, @ID, @PuntosPrecio
FETCH NEXT FROM crSucursalDetalleOferta INTO @SucursalDetalle
END  
CLOSE crSucursalDetalleOferta
DEALLOCATE crSucursalDetalleOferta
END
UPDATE #VentaD
SET Precio = 0.00, PrecioSugerido = 0.00
WHERE Articulo IN(SELECT d.Opcion FROM ArtJuego j JOIN ArtJuegoD d ON j.Articulo = d.Articulo AND j.Juego = d.Juego WHERE ISNULL(j.PrecioIndependiente,0) = 0)
AND RenglonTipo <> 'N' AND RenglonTipo <> 'S' AND RenglonTipo <> 'L'
UPDATE #VentaD
SET Descuento = dbo.fnPorcentajeImporte(Cantidad*Precio, DescuentoImporte)
WHERE NULLIF(DescuentoImporte, 0.0) IS NOT NULL
UPDATE #VentaD
SET Puntos = CASE
WHEN EXISTS(SELECT ID FROM Oferta WHERE Estatus = 'VIGENTE' AND (TIPO LIKE '%PUNTOS%' OR FORMA LIKE '%CANTIDAD%'))
THEN Puntos
ELSE
dbo.fnPorcentaje(dbo.fnDisminuyePorcentaje(Cantidad*Precio, Descuento), PuntosPorcentaje)
END
WHERE NULLIF(PuntosPorcentaje, 0.0) IS NOT NULL
UPDATE #VentaD
SET Puntos = CASE
WHEN EXISTS(SELECT ID FROM Oferta WHERE Estatus = 'VIGENTE' AND (TIPO LIKE '%PUNTOS%' OR FORMA LIKE '%CANTIDAD%'))
THEN Puntos
ELSE
Puntos*Cantidad
END
WHERE Puntos IS NOT NULL AND NULLIF(PuntosPorcentaje, 0.0) IS NULL
UPDATE #VentaD
SET Comision = dbo.fnPorcentaje(dbo.fnDisminuyePorcentaje(Cantidad*Precio, Descuento), ComisionPorcentaje)
WHERE NULLIF(ComisionPorcentaje, 0.0) IS NOT NULL
UPDATE VentaD
SET /*Factor = t.CantidadInventario/NULLIF(t.Cantidad, 0.0),
CantidadInventario = t.CantidadInventario,*/
PrecioSugerido = ISNULL(d.PrecioSugerido, t.PrecioSugerido),
Precio = ISNULL(t.Precio, t.PrecioSugerido),
DescuentoLinea = t.Descuento,
DescuentoP1 = t.DescuentoP1,
DescuentoP2 = t.DescuentoP2,
DescuentoP3 = t.DescuentoP3,
DescuentoG1 = t.DescuentoG1,
DescuentoG2 = t.DescuentoG2,
DescuentoG3 = t.DescuentoG3,
DescuentoImporte = NULL,
Puntos = CASE WHEN @Monedero IS NOT NULL THEN  t.Puntos ELSE NULL END,
Comision = t.Comision,
CantidadObsequio = t.CantidadObsequio,
OfertaID = t.OfertaID,
OfertaIDP1 = t.OfertaIDP1,
OfertaIDP2 = t.OfertaIDP2,
OfertaIDP3 = t.OfertaIDP3,
OfertaIDG1 = t.OfertaIDG1,
OfertaIDG2 = t.OfertaIDG2,
OfertaIDG3 = t.OfertaIDG3
FROM VentaD d
JOIN #VentaD t ON t.Renglon = d.Renglon AND t.RenglonSub = d.RenglonSub
WHERE d.ID = @ID
IF @OfertaAplicaLog = 1
BEGIN
DELETE OfertaLog WHERE ID = @ID
INSERT OfertaLog (ID, OfertaID, RID, Prioridad, PrioridadG, Mov,
MovID, Tipo, Forma, Usar, Articulo,
SubCuenta, Unidad, Descuento, DescuentoImporte, Costo,
PrecioBaseCosto, PrecioBaseLista, Precio, Puntos, PuntosPorcentaje,
Comision, ArticuloObsequio, CantidadObsequio, ComisionPorcentaje, UnidadObsequio,
DescuentoP1,DescuentoP2, DescuentoP3, DescuentoG1, DescuentoG2,
DescuentoG3, OfertaIDP1, OfertaIDP2, OfertaIDP3, OfertaIDG1,
OfertaIDG2, OfertaIDG3, Descripcion, SubCuentaObsequio)
SELECT @ID, OfertaID, RID, Prioridad, PrioridadG, Mov,
MovID, Tipo, Forma, Usar, Articulo,
SubCuenta, Unidad, Descuento, DescuentoImporte, Costo,
PrecioBaseCosto, PrecioBaseLista, Precio, Puntos, PuntosPorcentaje,
Comision, ArticuloObsequio, CantidadObsequio, ComisionPorcentaje, UnidadObsequio,
DescuentoP1,DescuentoP2, DescuentoP3, DescuentoG1, DescuentoG2,
DescuentoG3, OfertaIDP1, OfertaIDP2, OfertaIDP3, OfertaIDG1,
OfertaIDG2, OfertaIDG3, Descripcion, SubCuentaObsequio
FROM #OfertaLog
END
EXEC spInvReCalcEncabezadoSimple @Empresa, @ID, 'VTAS'
END
RETURN
END

