SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spInvVal
@ArticuloD	char(20),
@ArticuloA	char(20),
@Almacen	char(10),
@InvVal		varchar(20),
@FechaA		Datetime,
@Empresa	char(5)

AS BEGIN
DECLARE
@ArticuloE	char(20),
@AlmacenE	char(10),
@InventarioE	float,
@Cantidad	float,
@Alm		char(10)
IF @Almacen IN ('NULL', '(TODOS)', '') SELECT @Almacen = NULL
CREATE TABLE #ExistenciaVal (
ID			int		IDENTITY(1,1) NOT NULL PRIMARY KEY,
Articulo		char(20)	COLLATE Database_Default NULL,
Descripcion		varchar(100)	COLLATE Database_Default NULL,
PrecioLista		money		NULL,
Precio2			money		NULL,
Precio3			money		NULL,
Precio4			money		NULL,
Precio5			money		NULL,
Precio6			money		NULL,
Precio7			money		NULL,
Precio8			money		NULL,
Precio9			money		NULL,
Precio10		money		NULL,
CostoEstandar		money		NULL,
CostoReposicion		money		NULL,
CostoPromedio		money		NULL,
UltimoCosto		money		NULL,
Moneda			char(10)	COLLATE Database_Default NULL,
Almacen			char(10)	COLLATE Database_Default NULL,
Nombre			varchar(100)	COLLATE Database_Default NULL,
Existencias		float		NULL)
CREATE INDEX Articulo ON #ExistenciaVal (Articulo, Almacen)
INSERT #ExistenciaVal
SELECT Art.Articulo,
Art.Descripcion1,
Art.PrecioLista,
Art.Precio2,
Art.Precio3,
Art.Precio4,
Art.Precio5,
Art.Precio6,
Art.Precio7,
Art.Precio8,
Art.Precio9,
Art.Precio10,
Art.CostoEstandar,
Art.CostoReposicion,
CostoPromedio = (SELECT TOP 1 a.CostoPromedio FROM ArtCostoHist a WHERE a.Empresa = @Empresa AND a.Sucursal = ac.Sucursal AND a.Articulo = Art.Articulo GROUP BY a.CostoPromedio, a.Fecha, a.Empresa, a.Sucursal, a.Articulo HAVING a.Fecha = (SELECT MAX(b.Fecha) FROM ArtCostoHist b WHERE b.Empresa = a.Empresa AND b.Sucursal = a.Sucursal AND b.Articulo = a.Articulo AND b.Fecha < @FechaA)),
UltimoCosto = (SELECT TOP 1 a.UltimoCostoActual FROM ArtCostoHist a WHERE a.Empresa = @Empresa AND a.Sucursal = ac.Sucursal AND a.Articulo = Art.Articulo GROUP BY a.UltimoCostoActual, a.Fecha, a.Empresa, a.Sucursal, a.Articulo HAVING a.Fecha = (SELECT MAX(b.Fecha) FROM ArtCostoHist b WHERE b.Empresa = a.Empresa AND b.Sucursal = a.Sucursal AND b.Articulo = a.Articulo AND b.Fecha < @FechaA)),
e.Moneda,
e.Almacen,
Alm.Nombre,
SUM(e.Existencia)
FROM Art
JOIN ArtCostoSucursal ac ON Art.Articulo = ac.Articulo
JOIN ArtExistenciaNeta e ON Art.Articulo = e.Articulo
JOIN Alm ON e.Almacen = Alm.Almacen AND Alm.Sucursal = ac.Sucursal
WHERE ac.Empresa = @Empresa
AND e.Empresa = @Empresa
AND Art.Articulo BETWEEN @ArticuloD AND @ArticuloA
AND ISNULL(e.Almacen, '') = ISNULL(ISNULL(@Almacen, e.Almacen), '')
GROUP BY e.Moneda, Art.Articulo, Art.Descripcion1,
Art.PrecioLista, Art.Precio2, Art.Precio3, Art.Precio4, Art.Precio5, Art.Precio6, Art.Precio7, Art.Precio8, Art.Precio9, Art.Precio10,
Art.CostoEstandar, Art.CostoReposicion, ac.CostoPromedio, ac.UltimoCosto,
e.Almacen, Alm.Nombre, ac.Sucursal
DECLARE CrExist CURSOR LOCAL FOR
SELECT Articulo, Almacen, Existencias
FROM #ExistenciaVal
OPEN CrExist
FETCH NEXT FROM CrExist INTO @ArticuloE, @AlmacenE, @InventarioE
WHILE @@FETCH_STATUS <> -1
BEGIN
IF @@FETCH_STATUS <> -2
BEGIN
SELECT @Cantidad = NULL, @Alm = NULL
SELECT @Cantidad = SUM(ISNULL(a.CargoU, 0) - ISNULL(a.AbonoU, 0)) * -1, @Alm = a.Grupo
FROM InvAuxU a
WHERE a.Articulo = @ArticuloE
AND ISNULL(a.Grupo, '') = ISNULL(ISNULL(@AlmacenE, a.Grupo), '')
AND a.Rama = 'INV'
AND a.Empresa = @Empresa
AND a.Fecha BETWEEN @FechaA+1 AND GETDATE()
GROUP BY a.Grupo
UPDATE #ExistenciaVal SET Existencias = Existencias + ISNULL(@Cantidad, 0) WHERE Articulo = @ArticuloE AND Almacen = @AlmacenE
END
FETCH NEXT FROM CrExist INTO @ArticuloE, @AlmacenE, @InventarioE
END
CLOSE CrExist
DEALLOCATE CrExist
SELECT * FROM #ExistenciaVal WHERE Existencias > 0 ORDER BY Moneda, Articulo, Almacen
END

