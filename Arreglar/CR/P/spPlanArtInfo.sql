SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spPlanArtInfo(
@Empresa      varchar(5),
@Articulo     varchar(20)
)

AS BEGIN
SET NOCOUNT ON
DECLARE @Concepto               varchar(255),
@Valor                  varchar(255),
@CompraID               int,
@CompraDevID            int,
@VentaID                int,
@VentaDevID             int,
@CompraMov              varchar(20),
@CompraMovID            varchar(20),
@CompraDevMov           varchar(20),
@CompraDevMovID         varchar(20),
@VentaMov               varchar(20),
@VentaMovID             varchar(20),
@VentaDevMov            varchar(20),
@VentaDevMovID          varchar(20),
@Referencia             varchar(50),
@FechaCompra            datetime,
@FechaPrimerVenta       datetime,
@FechaUltimaVenta       datetime,
@Moneda                 varchar(20),
@TipoCambio             float,
@Proveedor              varchar(10),
@AlmacenCompra          varchar(10),
@Sucursal               int,
@Cantidad               float,
@Aplica                 varchar(20),
@AplicaID               varchar(20),
@Unidad                 varchar(50),
@Factor                 float,
@CostoPromedio          float,
@PrecioCosto            float,
@PrecioPublico          float,
@Margen                 float,
@AlmacenPrincipal       varchar(10),
@InventarioBodegas      float,
@InventarioTiendas      float,
@Estatus                varchar(15)
DECLARE	@Compra                 table (Clave varchar(20) NULL)
DECLARE	@CompraDev              table (Clave varchar(20) NULL)
DECLARE @Venta                  table (Clave varchar(20) NULL)
DECLARE @VentaDev               table (Clave varchar(20) NULL)
DECLARE @Tabla					table (ID		int IDENTITY (1, 1) NOT NULL,
Concepto varchar(255) NULL,
Valor    varchar(255) NULL)
INSERT INTO @Compra(Clave)      VALUES ('COMS.F')   
INSERT INTO @Compra(Clave)      VALUES ('COMS.CC')  
INSERT INTO @Compra(Clave)      VALUES ('COMS.FL')  
INSERT INTO @Compra(Clave)      VALUES ('COMS.OP')  
INSERT INTO @CompraDev(Clave)   VALUES ('COMS.D')   
INSERT INTO @Venta(Clave)       VALUES ('VTAS.F')   
INSERT INTO @Venta(Clave)       VALUES ('VTAS.FM')  
INSERT INTO @Venta(Clave)       VALUES ('VTAS.FR')  
INSERT INTO @Venta(Clave)       VALUES ('VTAS.VCR') 
INSERT INTO @Venta(Clave)       VALUES ('VTAS.VC')  
INSERT INTO @VentaDev(Clave)    VALUES ('VTAS.D')   
INSERT INTO @VentaDev(Clave)    VALUES ('VTAS.DC')  
INSERT INTO @VentaDev(Clave)    VALUES ('VTAS.DCR') 
SET @Estatus = 'CONCLUIDO'
SELECT @CompraID = MAX(c.ID)
FROM Compra c
JOIN CompraD d ON c.ID = d.id
JOIN MovTipo m ON c.Mov = m.Mov
JOIN @Compra t ON t.Clave = m.Clave
WHERE c.Empresa = @Empresa AND c.Estatus = @Estatus AND d.Articulo = @Articulo
SELECT @CompraMov = c.Mov,
@CompraMovID = c.MovID,
@Referencia = c.Referencia,
@FechaCompra = FechaEmision,
@Moneda = c.Moneda,
@TipoCambio = ISNULL(c.TipoCambio,1),
@Proveedor     = c.Proveedor,
@AlmacenCompra = c.Almacen,
@Sucursal = c.Sucursal
FROM Compra c
WHERE c.ID = @CompraID
SELECT @Aplica = Aplica, @AplicaID = AplicaID, @Unidad = Unidad, @Factor =  Factor
FROM CompraD
WHERE ID = @CompraID
SELECT @VentaID = MIN(d.ID)
FROM VentaD d
JOIN Venta v ON d.ID = v.ID
JOIN MovTipo m ON v.Mov = m.Mov
JOIN @Venta mv ON m.Clave = mv.Clave
WHERE v.Empresa  = @Empresa AND v.Estatus  = @Estatus AND d.Articulo = @Articulo
SELECT @FechaPrimerVenta = FechaEmision FROM Venta WHERE ID = @VentaID
SELECT @VentaID = MAX(d.ID)
FROM VentaD d
JOIN Venta v ON (d.ID = v.ID)
JOIN MovTipo m ON(v.Mov = m.Mov)
JOIN @Venta mv ON(m.Clave = mv.Clave)
WHERE v.Empresa  = @Empresa
AND v.Estatus  = @Estatus
AND d.Articulo = @Articulo
SELECT @FechaUltimaVenta = FechaEmision FROM Venta WHERE ID = @VentaID
SET @Concepto = 'Ultima compra'
SELECT @Valor =  @CompraMov + ' ' + @CompraMovID
INSERT INTO @Tabla(Concepto,Valor) VALUES (@Concepto,@Valor)
SET @Concepto = 'Aplica'
SET @Valor = ''
SELECT @Valor = @Aplica + ' ' + @AplicaID
SET @Valor = ISNULL(@Valor,'')
INSERT INTO @Tabla(Concepto,Valor) VALUES (@Concepto,@Valor)
SET @Concepto = 'Fecha'
SELECT @Valor = CONVERT(varchar(255),@FechaCompra,103)
INSERT INTO @Tabla(Concepto,Valor) VALUES (@Concepto,@Valor)
SET @Concepto = 'Referencia'
SELECT @Valor = @Referencia
INSERT INTO @Tabla(Concepto,Valor) VALUES (@Concepto,@Valor)
SET @Concepto = 'Proveedor'
SET @Valor = ''
SELECT @Valor = ISNULL(Proveedor,'') FROM Prov WHERE Proveedor = @Proveedor
SET @Valor = ISNULL(@Valor,'')
INSERT INTO @Tabla(Concepto,Valor) VALUES (@Concepto,@Valor)
SET @Concepto = 'Nombre Proveedor'
SET @Valor = ''
SELECT @Valor = ISNULL(Nombre,'') FROM Prov WHERE Proveedor = @Proveedor
SET @Valor = ISNULL(@Valor,'')
INSERT INTO @Tabla(Concepto,Valor) VALUES (@Concepto,@Valor)
SET @Concepto = 'Cantidad'
SELECT @Cantidad = SUM(d.Cantidad)
FROM CompraD d
JOIN Compra c ON d.ID = c.ID
JOIN MovTipo m ON(c.Mov = m.Mov)
WHERE c.Empresa = @Empresa
AND d.Articulo = @Articulo
AND c.Estatus = @Estatus
AND m.Clave IN (SELECT Clave FROM @Compra)
AND d.ID = @CompraID
SET @Cantidad = ISNULL(@Cantidad,0)
SELECT @Valor = CAST(@Cantidad AS varchar(255))
INSERT INTO @Tabla(Concepto,Valor) VALUES (@Concepto,@Valor)
SET @Concepto = 'Unidad'
SET @Valor = ''
SELECT @Valor = @Unidad
INSERT INTO @Tabla(Concepto,Valor) VALUES (@Concepto,@Valor)
SET @Concepto = 'Factor'
SET @Valor = ''
SELECT @Valor = @Factor
INSERT INTO @Tabla(Concepto,Valor) VALUES (@Concepto,@Valor)
SET @Concepto = 'Precio'
SELECT @PrecioCosto = @TipoCambio * ISNULL(d.Costo,0)
FROM CompraD d
JOIN Compra c ON d.ID = c.ID
WHERE d.ID       = @CompraID
AND d.Articulo = @Articulo
AND c.Empresa  = @Empresa
SET @Valor = CAST(@PrecioCosto AS varchar(255))
INSERT INTO @Tabla(Concepto,Valor) VALUES (@Concepto,@Valor)
SET @Concepto = 'Costo promedio'
SELECT @CostoPromedio = CostoPromedio FROM ArtCostoEmpresa WHERE Empresa = @Empresa AND Articulo = @Articulo
SET @CostoPromedio = ISNULL (@CostoPromedio,0)
SET @Valor = CAST(@CostoPromedio AS varchar(255))
INSERT INTO @Tabla(Concepto,Valor) VALUES (@Concepto,@Valor)
SET @Concepto = 'Precio público'
SELECT @PrecioPublico = ISNULL(PrecioLista,0) FROM Art WHERE Articulo = @Articulo
SET @PrecioPublico = ISNULL(@PrecioPublico,0)
SET @Valor = CAST(@PrecioPublico AS varchar(255))
INSERT INTO @Tabla(Concepto,Valor) VALUES (@Concepto,@Valor)
SET @Concepto = 'Margen'
IF @PrecioPublico > 0
SET @Margen = @CostoPromedio / @PrecioPublico
ELSE
SET @Margen = 0
SELECT @Valor = CAST(@Margen AS varchar(255))
INSERT INTO @Tabla(Concepto,Valor) VALUES (@Concepto,@Valor)
SET @Concepto = 'Inventario bodegas'
SELECT @InventarioBodegas = SUM(Disponible)
FROM ArtDisponible
WHERE Empresa = @Empresa
AND Articulo = @Articulo
AND Almacen IN (SELECT AlmacenOrigen
FROM RutaDistribucionMaxMin GROUP BY AlmacenOrigen)
SELECT @Valor = CAST(@InventarioBodegas AS VARCHAR(255))
INSERT INTO @Tabla(Concepto,Valor) VALUES (@Concepto,@Valor)
SET @Concepto = 'Inventario tiendas'
SELECT @InventarioTiendas = SUM(disponible)
FROM ArtDisponible
WHERE Empresa = @Empresa
AND Articulo = @Articulo
AND Almacen IN (SELECT AlmacenDestino
FROM RutaDistribucionMaxMin GROUP BY AlmacenDestino)
SELECT @Valor = ''
SELECT @Valor = CAST(@InventarioTiendas AS VARCHAR(255))
INSERT INTO @Tabla(Concepto,Valor) VALUES (@Concepto,@Valor)
SET @Concepto = 'Primer venta tienda'
SELECT @Valor = ''
SELECT @Valor = CONVERT(varchar(255),@FechaPrimerVenta,103)
INSERT INTO @Tabla(Concepto,Valor) VALUES (@Concepto,@Valor)
SET @Concepto = 'Ultima venta tienda'
SELECT @Valor = ''
SELECT @Valor = CONVERT(varchar(255),@FechaUltimaVenta,103)
INSERT INTO @Tabla(Concepto,Valor) VALUES (@Concepto,@Valor)
SELECT Concepto,Valor FROM @Tabla ORDER BY ID
END

