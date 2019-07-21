SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spMovilOfertaAplicar
@ID		varchar(50)

AS BEGIN
DECLARE
@RID          int,
@Empresa      varchar(5),
@Sucursal     int,
@Almacen      varchar(10),
@Agente       varchar(10),
@Movimiento   varchar(20),
@Moneda       varchar(10),
@ListaPrecios varchar(20),
@Region       varchar(50),
@AlmGrupo     varchar(50),
@AgenteCategoria varchar(50),
@AgenteGrupo  varchar(50),
@AgenteFamilia varchar(50),
@TipoCambio    float,
@FechaHora     datetime,
@ImporteTotalMN float
CREATE TABLE #Venta (Campo varchar(50) COLLATE Database_Default NOT NULL, Valor varchar(100) COLLATE Database_Default NULL)
CREATE INDEX Campo ON #Venta (Campo, Valor)
CREATE TABLE #VentaDetalle (Renglon float, Campo varchar(50) COLLATE Database_Default NOT NULL, Valor varchar(100) COLLATE Database_Default NULL)
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
OfertaIDG3			int NULL)
CREATE INDEX Renglon    ON #VentaD (Renglon, RenglonSub)
CREATE INDEX Articulo   ON #VentaD (Articulo)
CREATE INDEX Rama       ON #VentaD (Rama)
CREATE INDEX Categoria  ON #VentaD (Categoria)
CREATE INDEX Grupo      ON #VentaD (Grupo)
CREATE INDEX Familia    ON #VentaD (Familia)
CREATE INDEX Linea      ON #VentaD (Linea)
CREATE INDEX Fabricante ON #VentaD (Fabricante)
CREATE TABLE #ArtObsequio (Articulo varchar(20) COLLATE Database_Default NOT NULL, OfertaID INT NULL, Unidad varchar(50) NULL, SubCuenta varchar(50) NULL)
CREATE TABLE #OfertaActiva (ID int NOT NULL PRIMARY KEY,Sucursal int NULL, MovTipo varchar(20) COLLATE Database_Default NULL)
SELECT @FechaHora = GETDATE()
DECLARE crOfertaMovil CURSOR LOCAL FOR
SELECT Empresa, Sucursal, Almacen, Agente, Movimiento, Moneda, ListaPrecios
FROM OfertaMovilTemp
WHERE GUID = @ID
GROUP BY  Empresa, Sucursal, Almacen, Agente, Movimiento, Moneda, ListaPrecios
OPEN crOfertaMovil
FETCH NEXT FROM crOfertaMovil INTO @Empresa, @Sucursal, @Almacen, @Agente, @Movimiento, @Moneda, @ListaPrecios
WHILE @@FETCH_STATUS <> -1
BEGIN
DELETE #Venta
DELETE #VentaD
DELETE #ArtObsequio
DELETE #OfertaActiva
SELECT @TipoCambio = TipoCambio FROM Mon WHERE Moneda = @Moneda
SELECT @Region = Region
FROM Sucursal
WHERE Sucursal = @Sucursal
SELECT @AlmGrupo = Grupo
FROM Alm
WHERE Almacen = @Almacen
SELECT @AgenteCategoria = Categoria, @AgenteGrupo = Grupo, @AgenteFamilia = Familia
FROM  Agente
WHERE Agente = @Agente
INSERT #Venta (Campo, Valor) VALUES ('Region', 		@Region)
INSERT #Venta (Campo, Valor) VALUES ('Almacen', 		@Almacen)
INSERT #Venta (Campo, Valor) VALUES ('Grupo Almacen', 	@AlmGrupo)
INSERT #Venta (Campo, Valor) VALUES ('Agente', 		@Agente)
INSERT #Venta (Campo, Valor) VALUES ('Categoria Agente', 	@AgenteCategoria)
INSERT #Venta (Campo, Valor) VALUES ('Grupo Agente', 	@AgenteGrupo)
INSERT #Venta (Campo, Valor) VALUES ('Familia Agente', 	@AgenteFamilia)
INSERT #Venta (Campo, Valor) VALUES ('Movimiento', 	@Movimiento)
INSERT #Venta (Campo, Valor) VALUES ('Moneda', 		@Moneda)
INSERT #Venta (Campo, Valor) VALUES ('Lista Precios', 	@ListaPrecios)
UPDATE #Venta SET Valor = '' WHERE Valor IS NULL
INSERT #VentaD (Renglon,   RenglonSub,   RenglonTipo,               Articulo,   SubCuenta,   Rama,   Categoria,   Grupo,   Familia,   Linea,   Fabricante,   Proveedor,   Cantidad,   Unidad,   PrecioSugerido,   CantidadInventario, SucursalDetalle, Almacen)
SELECT          o.RID,       0,          dbo.fnRenglonTipo(a.Tipo), o.Articulo, o.SubCuenta, a.Rama, a.Categoria, a.Grupo, a.Familia, a.Linea, a.Fabricante, a.Proveedor, 1,          o.Unidad, o.PrecioSugerido, 1, 0, @Almacen
FROM OfertaMovilTemp o   JOIN Art a ON  o.Articulo = a.Articulo
WHERE GUID = @ID AND Empresa = @Empresa AND Sucursal = @Sucursal AND  Almacen = @Almacen AND  Agente = @Agente AND  Movimiento = @Movimiento AND  Moneda = @Moneda AND  ListaPrecios = @ListaPrecios
EXEC spOfertaPrecioSugerido @Empresa, @Sucursal, @Moneda, @TipoCambio, @ListaPrecios
SELECT @ImporteTotalMN = SUM(Cantidad*PrecioSugerido)*@TipoCambio FROM #VentaD
EXEC spOfertaActiva @Empresa, @Sucursal, @FechaHora, @ImporteTotalMN
EXEC spOfertaProcesar @Empresa, @Sucursal, @Moneda, @TipoCambio, @ListaPrecios, @ID = NULL
UPDATE #VentaD SET OfertaID = ISNULL(OfertaID,ISNULL(OfertaIDP1,ISNULL(OfertaIDP2,ISNULL(OfertaIDP3,OfertaID))))
UPDATE #VentaD
SET Descuento = dbo.fnPorcentajeImporte(Cantidad*Precio, DescuentoImporte)
WHERE NULLIF(DescuentoImporte, 0.0) IS NOT NULL
UPDATE #VentaD
SET Comision = dbo.fnPorcentaje(dbo.fnDisminuyePorcentaje(Cantidad*Precio, Descuento), ComisionPorcentaje)
WHERE NULLIF(ComisionPorcentaje, 0.0) IS NOT NULL
UPDATE OfertaMovilTemp
SET PrecioSugerido = ISNULL(d.PrecioSugerido, t.PrecioSugerido),
Precio = ISNULL(t.Precio, t.PrecioSugerido)- CASE WHEN ISNULL(t.DescuentoImporte,0) >0 THEN ISNULL(t.DescuentoImporte,0) ELSE ISNULL(t.Precio, t.PrecioSugerido)*(ISNULL(t.Descuento,0)/100) END,
Descuento = NULL,
DescuentoImporte = NULL,
Comision = t.Comision,
OfertaID = t.OfertaID
FROM OfertaMovilTemp d
JOIN #VentaD t ON t.Renglon = d.RID
JOIN Oferta o ON o.ID = t.OfertaID
JOIN OfertaTipo ot ON o.Tipo = ot.Tipo AND o.Forma = ot.Forma AND o.Usar = ot.Usar
WHERE d.GUID = @ID AND d.Empresa = @Empresa AND d.Sucursal = @Sucursal AND  d.Almacen = @Almacen AND  d.Agente = @Agente AND  d.Movimiento = @Movimiento AND  d.Moneda = @Moneda AND  d.ListaPrecios = @ListaPrecios
AND ot.Forma IN('Precio','Descuento')
FETCH NEXT FROM crOfertaMovil INTO @Empresa, @Sucursal, @Almacen, @Agente, @Movimiento, @Moneda, @ListaPrecios
END
CLOSE crOfertaMovil
DEALLOCATE crOfertaMovil
RETURN
END

