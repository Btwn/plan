SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spRecArtInfo
@Empresa      varchar(5),
@Articulo     varchar(20)

AS BEGIN
SET NOCOUNT ON
IF EXISTS (SELECT TOP 1 Empresa FROM Empresa WHERE Empresa = @Empresa)
BEGIN
DECLARE @Concepto               varchar(255)
DECLARE @Valor                  varchar(255)
DECLARE @CompraID               int
DECLARE @CompraDevID            int
DECLARE @CompraCantidad		  float
DECLARE @VentaID                int
DECLARE @VentaDevID             int
DECLARE @CompraMov              varchar(20)
DECLARE @CompraMovID            varchar(20)
DECLARE @CompraDevMov           varchar(20)
DECLARE @CompraDevMovID         varchar(20)
DECLARE @VentaMov               varchar(20)
DECLARE @VentaMovID             varchar(20)
DECLARE @VentaDevMov            varchar(20)
DECLARE @VentaDevMovID          varchar(20)
DECLARE @FechaCompra            datetime
DECLARE @FechaPrimerVenta       datetime
DECLARE @FechaUltimaVenta       datetime
DECLARE @Moneda                 varchar(20)
DECLARE @TipoCambio             float
DECLARE @Proveedor              varchar(10)
DECLARE @Almacen                varchar(10)
DECLARE @Sucursal               int
DECLARE @Cantidad               float
DECLARE @CostoPromedio          float
DECLARE @PrecioCosto            float
DECLARE @PrecioPublico          float
DECLARE @Margen                 float
DECLARE @AlmacenPrincipal       varchar(10)
DECLARE @InventarioBodegas      float
DECLARE @InventarioTiendas      float
DECLARE @Estatus                varchar(15)
DECLARE @Compra                 table (Clave varchar(20) NULL)
DECLARE @CompraDev              table (Clave varchar(20) NULL)
DECLARE @Venta                  table (Clave varchar(20) NULL)
DECLARE @VentaDev               table (Clave varchar(20) NULL)
DECLARE @OrdenFecha			  datetime
DECLARE @CompraEntrada		  bit
DECLARE @TablaArticulo table (
ID                            int IDENTITY (1, 1) NOT NULL,
Concepto                      varchar(255) NULL,
Valor                         varchar(255) NULL
)
INSERT INTO @Compra(Clave)      VALUES ('COMS.F')   
INSERT INTO @Compra(Clave)      VALUES ('COMS.O')   
INSERT INTO @Compra(Clave)      VALUES ('COMS.EI')  
INSERT INTO @Compra(Clave)      VALUES ('COMS.EG')  
INSERT INTO @CompraDev(Clave)   VALUES ('COMS.D')   
INSERT INTO @Venta(Clave)       VALUES ('VTAS.F')   
INSERT INTO @Venta(Clave)       VALUES ('VTAS.FM')  
INSERT INTO @Venta(Clave)       VALUES ('VTAS.FR')  
INSERT INTO @VentaDev(Clave)    VALUES ('VTAS.D')   
SET @Estatus = 'CONCLUIDO'
SELECT TOP 1
@CompraID = c.ID,
@OrdenFecha = c.FechaEmision,
@CompraCantidad = SUM(d.Cantidad),
@PrecioCosto = SUM(c.TipoCambio * (ISNULL(d.Costo,0)))/COUNT(*)
FROM Compra c
JOIN CompraD d ON(c.ID = d.id)
JOIN MovTipo m ON(c.Mov = m.Mov)
WHERE c.Empresa  = @Empresa
AND c.Estatus  = @Estatus
AND d.Articulo = @Articulo
AND m.Clave IN (SELECT Clave FROM @Compra)
GROUP BY C.ID, c.FechaEmision
ORDER BY c.FechaEmision ASC
IF ISNULL(@CompraID,'') <> ''
BEGIN
SET @CompraEntrada = 1
SELECT @CompraMov = c.Mov,
@CompraMovID = c.MovID,
@FechaCompra = FechaEmision,
@Moneda = c.Moneda,
@TipoCambio = ISNULL(c.TipoCambio,1),
@Proveedor = c.Proveedor,
@Almacen = c.Almacen,
@Sucursal = c.Sucursal
FROM Compra c
WHERE c.ID = @CompraID
END
ELSE
BEGIN
SELECT TOP 1
@CompraID = A.ID,
@OrdenFecha = A.FechaEmision,
@CompraCantidad = SUM(B.Cantidad),
@PrecioCosto = SUM(A.TipoCambio * ISNULL(B.Costo,0))/COUNT(*)
FROM INV A
JOIN INVD B ON A.ID = B.ID
JOIN MOVTIPO C ON A.Mov = c.Mov AND C.Modulo = 'INV'
WHERE A.Empresa  = @Empresa
AND A.Estatus  = @Estatus
AND B.ARTICULO = @Articulo
AND C.CLAVE = 'INV.E'
GROUP BY A.ID, A.FechaEmision
ORDER BY A.FechaEmision ASC
SELECT @CompraMov = c.Mov,
@CompraMovID = c.MovID,
@FechaCompra = FechaEmision,
@Moneda = c.Moneda,
@TipoCambio = ISNULL(c.TipoCambio,1),
@Proveedor = '',
@Almacen = c.Almacen,
@Sucursal = c.Sucursal
FROM Inv c
WHERE c.ID = @CompraID
END
SELECT @VentaID = MIN(d.ID)
FROM VentaD d
JOIN Venta v ON (d.ID = v.ID)
JOIN MovTipo m ON(v.Mov = m.Mov)
WHERE v.Empresa  = @Empresa
AND v.Estatus  = @Estatus
AND d.Articulo = @Articulo
AND m.Clave IN (SELECT Clave FROM @Venta)
SELECT @FechaPrimerVenta = FechaEmision FROM Venta WHERE ID = @VentaID
SELECT @VentaID = MAX(d.ID)
FROM VentaD d
JOIN Venta v ON (d.ID = v.ID)
JOIN MovTipo m ON(v.Mov = m.Mov)
WHERE v.Empresa  = @Empresa
AND v.Estatus  = @Estatus
AND d.Articulo = @Articulo
AND m.Clave IN (SELECT Clave FROM @Venta)
SELECT @FechaUltimaVenta = FechaEmision FROM Venta WHERE ID = @VentaID
SET @Concepto = 'Descripción'
SELECT @Valor = ISNULL(Descripcion1,'') FROM Art WHERE Articulo = @Articulo
SET @Valor = ISNULL(@Valor,'')
INSERT INTO @TablaArticulo(Concepto,Valor) VALUES (@Concepto,@Valor)
SET @Concepto = 'Proveedor'
IF ISNULL(@Proveedor,'') <> ''
BEGIN
SELECT @Valor = ISNULL(Nombre,'') FROM Prov WHERE Proveedor = @Proveedor
SET @Valor = ISNULL(@Valor,'(Sin Valor)')
INSERT INTO @TablaArticulo(Concepto,Valor) VALUES (@Concepto,@Valor)
END
ELSE
BEGIN
SET @Valor = '(Sin Valor)'
INSERT INTO @TablaArticulo(Concepto,Valor) VALUES (@Concepto,@Valor)
END
IF @CompraEntrada = 1
SET @Concepto = 'Primer compra'
ELSE
SET @Concepto = 'Primer entrada'
SELECT @Valor = CONVERT(varchar(255),@FechaCompra,103)
INSERT INTO @TablaArticulo(Concepto,Valor) VALUES (@Concepto,@Valor)
SET @Concepto = 'Primer Movimiento'
SELECT @Valor = @CompraMovID
INSERT INTO @TablaArticulo(Concepto,Valor) VALUES (@Concepto,@Valor)
SET @Concepto = 'Primer Cantidad'
/*
SELECT @Cantidad = SUM(d.Cantidad)
FROM CompraD d
JOIN Compra c ON d.ID = c.ID
JOIN MovTipo m ON(c.Mov = m.Mov)
WHERE c.Empresa = @Empresa
AND d.Articulo = @Articulo
AND c.Estatus = @Estatus
AND m.Clave IN (SELECT Clave FROM @Compra)*/
SET @Cantidad = ISNULL(@CompraCantidad,0)
SELECT @Valor = CONVERT(varchar(255), CONVERT(money, @Cantidad), 1)
SET @Valor = SUBSTRING(@Valor, 1, LEN(@Valor)-3)
INSERT INTO @TablaArticulo(Concepto,Valor) VALUES (@Concepto,@Valor)
SET @Concepto = 'Primer Costo'
/*
SELECT @PrecioCosto = @TipoCambio * ISNULL(d.Costo,0)
FROM CompraD d
JOIN Compra c ON d.ID = c.ID
WHERE d.ID       = @CompraID
AND d.Articulo = @Articulo
AND c.Empresa  = @Empresa
*/
SET @Valor = "$ " + CAST(@PrecioCosto AS varchar(255))
INSERT INTO @TablaArticulo(Concepto,Valor) VALUES (@Concepto,@Valor)
SET @Concepto = 'Costo promedio'
SELECT @CostoPromedio = CostoPromedio FROM ArtCostoEmpresa WHERE Empresa = @Empresa AND Articulo = @Articulo
SET @CostoPromedio = ISNULL (@CostoPromedio,0)
SET @Valor =  "$ " + CAST(@CostoPromedio AS varchar(255))
INSERT INTO @TablaArticulo(Concepto,Valor) VALUES (@Concepto,@Valor)
SET @Concepto = 'Precio público'
SELECT @PrecioPublico = ISNULL(PrecioLista,0) FROM Art WHERE Articulo = @Articulo
SET @PrecioPublico = ISNULL(@PrecioPublico,0)
SET @Valor =  "$ " + CAST(@PrecioPublico AS varchar(255))
INSERT INTO @TablaArticulo(Concepto,Valor) VALUES (@Concepto,@Valor)
SET @Concepto = 'Margen'
IF @PrecioPublico > 0
SET @Margen = @CostoPromedio / @PrecioPublico
ELSE
SET @Margen = 0
SELECT @Valor =  CAST(@Margen AS varchar(255))
INSERT INTO @TablaArticulo(Concepto,Valor) VALUES (@Concepto,@Valor)
SET @Concepto = 'Departamento'
SELECT @Valor = '(Sin Valor)'
IF @Valor <> '(Sin Valor)'
INSERT INTO @TablaArticulo(Concepto,Valor) VALUES (@Concepto,@Valor)
SET @Concepto = 'Línea'
SELECT @Valor = ISNULL(Linea,'(Sin Valor)')
FROM Art
WHERE Articulo = @Articulo
INSERT INTO @TablaArticulo(Concepto,Valor) VALUES (@Concepto,@Valor)
SET @Concepto = 'Inventario bodegas'
SELECT @AlmacenPrincipal = LTRIM(RTRIM(ISNULL(AlmacenPrincipal,''))) FROM Sucursal WHERE Sucursal = 0
SELECT @InventarioBodegas = SUM(Disponible)
FROM ArtDisponible
WHERE Empresa = @Empresa
AND Articulo = @Articulo
AND Almacen = @AlmacenPrincipal
SELECT @Valor = CONVERT(varchar(255), CONVERT(money, @InventarioBodegas), 1)
SET @Valor = SUBSTRING(@Valor, 1, LEN(@Valor)-3)
IF ISNULL(@Valor,'') = '' SET @VALOR = '0'
INSERT INTO @TablaArticulo(Concepto,Valor) VALUES (@Concepto,@Valor)
SET @Concepto = 'Inventario tiendas'
SELECT @InventarioTiendas = SUM(disponible)
FROM ArtDisponible
WHERE Empresa = @Empresa
AND Articulo = @Articulo
AND Almacen <> @AlmacenPrincipal
SELECT @Valor = CONVERT(varchar(255), CONVERT(money, @InventarioTiendas), 1)
SET @Valor = SUBSTRING(@Valor, 1, LEN(@Valor)-3)
INSERT INTO @TablaArticulo(Concepto,Valor) VALUES (@Concepto,@Valor)
SET @Concepto = 'Primer venta tienda'
SELECT @Valor = CONVERT(varchar(255),@FechaPrimerVenta,103)
INSERT INTO @TablaArticulo(Concepto,Valor) VALUES (@Concepto,@Valor)
SET @Concepto = 'Ultima venta tienda'
SELECT @Valor = CONVERT(varchar(255),@FechaUltimaVenta,103)
INSERT INTO @TablaArticulo(Concepto,Valor) VALUES (@Concepto,@Valor)
SELECT Concepto,Valor FROM @TablaArticulo ORDER BY ID
END
END

