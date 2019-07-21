SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spPOSRepArtSinVentas
@Empresa            varchar(5),
@Sucursal           int,
@FechaD             datetime,
@FechaA             datetime

AS
BEGIN
DECLARE
@SucursalD int,
@Moneda        varchar(10),
@TipoCambio    float,
@ListaPrecios  varchar(20)
DECLARE @Tabla table (
Empresa       varchar(5),
NSucursal     int,
SucNombre     varchar(100),
Articulo      varchar(20),
SubCuenta     varchar(50),
ListaPrecios  varchar(20))
DECLARE crArticulo CURSOR LOCAL FOR
SELECT  Sucursal
FROM Sucursal
WHERE Sucursal = ISNULL(@Sucursal,Sucursal)
OPEN crArticulo
FETCH NEXT FROM crArticulo INTO @SucursalD
WHILE @@FETCH_STATUS = 0
BEGIN
SELECT @ListaPrecios = ListaPreciosEsp
FROM Sucursal
WHERE Sucursal = @SucursalD
SELECT @Moneda = Moneda
FROM ListaPrecios
WHERE Lista = ISNULL(@ListaPrecios,'(Precio Lista)')
SELECT @TipoCambio = TipoCambio
FROM Mon
WHERE Moneda = @Moneda
INSERT @Tabla(
Empresa, NSucursal, Articulo, SubCuenta, ListaPrecios)
SELECT
i.Empresa, i.Sucursal, i.Articulo, i.SubCuenta, @ListaPrecios
FROM ArtSubExistenciaInv i
JOIN Sucursal s ON i.Sucursal = s.Sucursal
JOIN Art a ON a.Articulo = i.Articulo
WHERE  i.Inventario > 0.0
AND i.Sucursal = ISNULL(@SucursalD,i.Sucursal)
GROUP BY i.Empresa, i.Sucursal, i.Articulo, i.SubCuenta
EXCEPT
SELECT  a.Empresa, a.Sucursal , a.Cuenta, a.SubCuenta, @ListaPrecios
FROM AuxiliarU a
JOIN Venta v ON a.ModuloID = v.ID AND a.Modulo = 'VTAS'
JOIN MovTipo mt ON v.Mov = mt.Mov AND  mt.Modulo = 'VTAS'
WHERE mt.Clave IN('VTAS.F','VTAS.N')
AND a.Fecha BETWEEN @FechaD AND @FechaA
AND a.Sucursal = ISNULL(@SucursalD,a.Sucursal)
AND a.Modulo = 'VTAS'
AND a.Rama = 'INV'
GROUP BY a.Empresa, a.Sucursal , a.Cuenta,a.SubCuenta
FETCH NEXT FROM crArticulo INTO @SucursalD
END
CLOSE crArticulo
DEALLOCATE crArticulo
SELECT a.Empresa, a.NSucursal, a.Articulo, a.SubCuenta, art.Descripcion1, i.Almacen,SUM(i.Inventario)Inventario,s.Nombre SucNombre, @Moneda Moneda,
ISNULL(@TipoCambio,1) TipoCambio, art.Unidad, a.ListaPrecios
FROM @Tabla a JOIN Sucursal s ON a.NSucursal = s.Sucursal
JOIN Art art ON a.Articulo = art.Articulo
JOIN ArtSubExistenciaInv i ON a.Articulo = i.Articulo AND a.SubCuenta = i.SubCuenta AND a.Empresa = i.Empresa AND a.NSucursal = i.Sucursal
GROUP BY  a.Empresa, a.NSucursal, a.Articulo, a.SubCuenta, art.Descripcion1, i.Almacen,s.Nombre, art.Unidad, a.ListaPrecios
END

