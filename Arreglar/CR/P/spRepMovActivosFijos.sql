SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spRepMovActivosFijos
@Estacion		int

AS BEGIN
DECLARE @PeriodoD	int,
@PeriodoA	int,
@Ejercicio	int,
@Empresa	char(5),
@FechaD	DateTime,
@FechaA	DateTime
SELECT @FechaD = rp.InfoFechaD,
@FechaA = rp.InfoFechaA,
@Ejercicio = rp.InfoEjercicio,
@Empresa = rp.InfoEmpresa
FROM RepParam rp
WHERE rp.Estacion = @Estacion
SELECT Modulo = 'Compras',
ID = Compra.ID,
Empresa = Compra.Empresa,
NombreEmpresa = e.Nombre,
Mov = Compra.Mov,
MovID = Compra.MovID,
FechaEmision = Compra.FechaEmision,
Moneda = Compra.Moneda,
Estatus = Compra.Estatus,
Proveedor = Compra.Proveedor,
Almacen = Compra.Almacen,
NombreAlmacen = a.Nombre,
Importe = Compra.Importe * MovTipo.Factor,
Impuestos = Compra.Impuestos * MovTipo.Factor,
DescuentoGlobal = Compra.DescuentoGlobal,
Sucursal = Compra.Sucursal,
NombreSucursal = s.Nombre,
UEN = Compra.UEN,
SubCuenta = CompraD.Subcuenta,
Impuesto1 = CompraD.Impuesto1,
Costo = CompraD.Costo * MovTipo.Factor,
Cantidad = slm.Cantidad * MovTipo.Factor,
NombreProv = Prov.Nombre,
Renglon = CompraD.Renglon,
Articulo = CompraD.Articulo,
Descripcion = Art.Descripcion1,
Serie = slm.SerieLote,
Periodo = Compra.Periodo,
Ejercicio = Compra.Ejercicio
FROM Compra
INNER JOIN CompraD ON Compra.ID = CompraD.ID
INNER JOIN SerieLoteMov slm ON slm.ID = Compra.ID AND slm.RenglonID = CompraD.RenglonID
INNER JOIN ActivoF af ON Compra.Empresa = af.Empresa AND af.Articulo = CompraD.Articulo AND af.Serie = slm.SerieLote
INNER JOIN Alm a ON CompraD.Almacen = a.Almacen AND a.Tipo IN ('Activos Fijos')
INNER JOIN Sucursal s ON Compra.Sucursal = s.Sucursal
INNER JOIN Empresa e ON Compra.Empresa = e.Empresa
INNER JOIN Prov ON Compra.Proveedor = Prov.Proveedor
INNER JOIN Art ON CompraD.Articulo = Art.Articulo
INNER JOIN MovTipo ON Compra.Mov = MovTipo.Mov  AND MovTipo.Modulo = 'COMS' AND MovTipo.Clave IN ('COMS.EG','COMS.F','COMS.FL','COMS.OP', 'COMS.D')
WHERE Compra.Empresa = @Empresa AND Compra.Estatus = 'CONCLUIDO' AND Compra.FechaEmision BETWEEN @FechaD AND @FechaA
UNION
SELECT Modulo = 'Inventarios',
Inv.ID,
Inv.Empresa,
NombreEmpresa = e.Nombre,
InvMov = Inv.Mov,
InvMovID = Inv.MovID,
Inv.FechaEmision,
InvMoneda = Inv.Moneda,
Inv.Estatus,
NULL,
Inv.Almacen,
NombreAlmacen = a.Nombre,
Inv.Importe * MovTipo.Factor,
NULL,
NULL,
Inv.Sucursal,
NombreSucursal = s.Nombre,
Inv.UEN,
InvD.Subcuenta,
NULL,
InvD.Costo * MovTipo.Factor,
slm.Cantidad * MovTipo.Factor,
NULL,
InvD.Renglon,
InvD.Articulo,
Art.Descripcion1,
slm.SerieLote,
Inv.Periodo,
Inv.Ejercicio
FROM Inv
INNER JOIN InvD ON Inv.ID = InvD.ID
INNER JOIN SerieLoteMov slm ON Inv.ID = slm.ID AND InvD.RenglonID = slm.RenglonID
INNER JOIN Empresa e ON Inv.Empresa = e.Empresa
INNER JOIN Sucursal s ON Inv.Sucursal = s.Sucursal
INNER JOIN Alm a ON InvD.Almacen = a.Almacen AND a.Tipo = 'Activos Fijos'
INNER JOIN Art ON InvD.Articulo = Art.Articulo
INNER JOIN ActivoF af ON af.Empresa = Inv.Empresa AND af.Articulo = InvD.Articulo AND af.Serie = slm.SerieLote
INNER JOIN MovTipo ON Inv.Mov = MovTipo.Mov AND MovTipo.Modulo = 'INV' AND MovTipo.Clave IN('INV.EP','INV.E')
WHERE Inv.Empresa = @Empresa
AND Inv.Estatus = 'CONCLUIDO'
AND Inv.FechaEmision BETWEEN @FechaD AND @FechaA
END

