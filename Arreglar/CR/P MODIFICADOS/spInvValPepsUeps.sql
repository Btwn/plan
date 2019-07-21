SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spInvValPepsUeps
@Estacion	int,
@ArticuloD	char(20),
@ArticuloA	char(20),
@Almacen	char(10),
@InvVal		varchar(20),
@FechaA		Datetime,
@Empresa	char(5)

AS BEGIN
DECLARE
@Articulo1	char(20),
@SubCuenta	varchar(20),
@Descripcion	varchar(100),
@Inventario	float,
@Articulox	char(20),
@ArtAnterior1	char(20),
@ArtAnterior	char(20),
@SubCuentax	varchar(50),
@Descripcionx	varchar(100),
@Movx		char(20),
@MovIDx		varchar(20),
@Monedax	char(10),
@Fechax		Datetime,
@Existenciax	float,
@Costox		money,
@Activox	bit,
@IDx		int,
@Art1		char(20),
@Subc1		varchar(50),
@Exist1		float,
@Mov1		char(20),
@MovID1		varchar(20),
@ID1		int,
@Artz		char(20),
@Subcz		varchar(50),
@Existz		float,
@Movz		char(20),
@MovIDz		varchar(20),
@IDz		int,
@ExistP		float,
@Inicio		float,
@ArticuloE	char(20),
@SubCuentaE	varchar(50),
@DescripcionE	varchar(100),
@InventarioE	float,
@Cantidad	float,
@Acum		float,
@Acum1		float,
@Fuera		int,
@SumaSal	float,
@DifEnt		float,
@ResEnt		float,
@Articuloz	char(20),
@SubCuentaz	varchar(50),
@Descripcionz	varchar(100)
IF @Almacen IN ('NULL', '(TODOS)', '') SELECT @Almacen = NULL
DELETE InvValPU       WHERE Estacion = @Estacion
DELETE InvValPepsUeps WHERE Estacion = @Estacion
CREATE TABLE #ExistenciaInv (
Articulo		char(20)	COLLATE Database_Default NULL,
SubCuenta		varchar(50)	COLLATE Database_Default NULL,
Descripcion1		varchar(100)	COLLATE Database_Default NULL,
Almacen			char(20)	COLLATE Database_Default NULL,
Disponible		float		NULL)
INSERT #ExistenciaInv
(Articulo,   SubCuenta,   Descripcion1,   Disponible)
SELECT a.Articulo, a.SubCuenta, b.Descripcion1, SUM(a.Disponible)
FROM ArtSubDisponible a WITH(NOLOCK)
JOIN Art b WITH(NOLOCK) ON a.Articulo = b.Articulo
WHERE a.Articulo BETWEEN @ArticuloD AND @ArticuloA
AND ISNULL(a.Almacen, '') = ISNULL(ISNULL(@Almacen, a.Almacen), '')
AND a.Empresa = @Empresa
GROUP BY a.Articulo, a.SubCuenta, b.Descripcion1
DECLARE CrExist CURSOR FOR
SELECT Articulo, SubCuenta, Descripcion1, Disponible
FROM #ExistenciaInv
OPEN CrExist
FETCH NEXT FROM CrExist INTO @ArticuloE, @SubCuentaE, @DescripcionE, @InventarioE
WHILE @@FETCH_STATUS <> -1
BEGIN
IF @@FETCH_STATUS <> -2
BEGIN
SELECT @Cantidad = SUM(ISNULL(a.CargoU, 0) - ISNULL(a.AbonoU, 0)) * -1
FROM InvAuxU a WITH(NOLOCK)
WHERE a.Articulo = @ArticuloE
AND ISNULL(a.SubCuenta, '') = ISNULL(ISNULL(@SubCuentaE, a.SubCuenta), '')
AND ISNULL(a.Grupo, '')     = ISNULL(ISNULL(@Almacen, a.Grupo), '')
AND a.Rama = 'INV'
AND a.Empresa = @Empresa
AND a.Fecha BETWEEN @FechaA+1 AND GETDATE()
UPDATE #ExistenciaInv SET Disponible = Disponible + @Cantidad WHERE Articulo = @ArticuloE AND SubCuenta = @SubCuentaE
END
FETCH NEXT FROM CrExist INTO @ArticuloE, @SubCuentaE, @DescripcionE, @InventarioE
END
CLOSE CrExist
DEALLOCATE CrExist
DECLARE CrValCost CURSOR FOR
SELECT Articulo, SubCuenta, Descripcion1, Disponible
FROM #ExistenciaInv
OPEN CrValCost
FETCH NEXT FROM CrValCost INTO @Articulo1, @SubCuenta, @Descripcion, @Inventario
WHILE @@FETCH_STATUS <> -1
BEGIN
IF @@FETCH_STATUS <> -2
BEGIN
INSERT InvValPepsUeps
(Estacion,  Articulo,   SubCuenta,  Descripcion,  Mov,   MovID,   Moneda,   Fecha,   Existencia, ID, ExistD, Costo)
SELECT @Estacion, @Articulo1, @SubCuenta, @Descripcion, a.Mov, a.MovID, a.Moneda, a.Fecha, Cantidad = ISNULL(a.CargoU, 0) - ISNULL(a.AbonoU, 0), a.ID, @Inventario,
Costo = CASE a.Modulo WHEN 'INV'  THEN (SELECT TOP 1 (ISNULL(y.CostoInv, y.Costo) * x.TipoCambio) FROM Inv x WITH(NOLOCK), InvD WITH(NOLOCK) y WHERE x.ID = y.ID AND x.Mov = a.Mov AND x.MovID = a.MovID AND y.Articulo = a.Articulo)
WHEN 'COMS' THEN (SELECT TOP 1 (ISNULL(y.CostoInv, y.Costo) * x.TipoCambio) FROM Compra x WITH(NOLOCK), CompraD WITH(NOLOCK) y WHERE x.ID = y.ID AND x.Mov = a.Mov AND x.MovID = a.MovID AND y.Articulo = a.Articulo)
WHEN 'VTAS' THEN (SELECT TOP 1 (y.Costo * x.TipoCambio) FROM Venta x WITH(NOLOCK), VentaD WITH(NOLOCK) y WHERE x.ID = y.ID AND x.Mov = a.Mov AND x.MovID = a.MovID AND y.Articulo = a.Articulo)
WHEN 'PROD' THEN (SELECT TOP 1 (y.Costo * x.TipoCambio) FROM Prod x WITH(NOLOCK), ProdD WITH(NOLOCK) y WHERE x.ID = y.ID AND x.Mov = a.Mov AND x.MovID = a.MovID AND y.Articulo = a.Articulo) END
FROM InvAuxU a WITH(NOLOCK)
WHERE a.Articulo = @Articulo1
AND a.Rama = 'INV'
AND ISNULL(a.SubCuenta, '') = ISNULL(ISNULL(@SubCuenta, a.SubCuenta), '')
AND ISNULL(a.Grupo, '')     = ISNULL(ISNULL(@Almacen, a.Grupo), '')
AND a.Fecha <= @FechaA
AND a.Empresa = @Empresa
ORDER BY a.Fecha
END
FETCH NEXT FROM CrValCost INTO @Articulo1, @SubCuenta, @Descripcion, @Inventario
END
CLOSE CrValCost
DEALLOCATE CrValCost
UPDATE InvValPepsUeps WITH(NOLOCK) SET Activo = CASE WHEN Existencia > 0 THEN 1 ELSE 0 END WHERE Estacion = @Estacion
IF RTRIM(@InvVal) = 'PEPS'
BEGIN
INSERT InvValPU
(Estacion,  Articulo, SubCuenta, Descripcion, Mov, MovID, Moneda, Fecha, Existencia, Costo, Activo, ID, ExistD)
SELECT @Estacion, Articulo, SubCuenta, Descripcion, Mov, MovID, Moneda, Fecha, Existencia, Costo, Activo, ID, ExistD
FROM InvValPepsUeps WITH(NOLOCK)
WHERE Activo = 1
AND Estacion = @Estacion
ORDER BY Moneda, Articulo, SubCuenta, Fecha
END
ELSE
BEGIN
INSERT InvValPU
(Estacion,  Articulo, SubCuenta, Descripcion, Mov, MovID, Moneda, Fecha, Existencia, Costo, Activo, ID, ExistD)
SELECT @Estacion, Articulo, SubCuenta, Descripcion, Mov, MovID, Moneda, Fecha, Existencia, Costo, Activo, ID, ExistD
FROM InvValPepsUeps WITH(NOLOCK)
WHERE Activo = 1
AND Estacion = @Estacion
ORDER BY Moneda, Articulo, SubCuenta, Fecha DESC
END
SELECT @Inicio = 0.0, @ExistP = 0.0, @ArtAnterior1 = ''
DECLARE CrInvValT CURSOR FOR
SELECT Articulo, SubCuenta, Descripcion1
FROM #ExistenciaInv
OPEN CrInvValT
FETCH NEXT FROM CrInvValT INTO @Articuloz, @SubCuentaz, @Descripcionz
WHILE @@FETCH_STATUS <> -1
BEGIN
IF @@FETCH_STATUS <> -2
BEGIN
IF EXISTS(SELECT ABS(SUM(Existencia)) FROM InvValPepsUeps WITH(NOLOCK) WHERE Activo = 0 AND Articulo = @Articuloz AND ISNULL(SubCuenta, '') = ISNULL(ISNULL(@SubCuentaz, SubCuenta), '') AND Estacion = @Estacion)
SELECT @SumaSal = ABS(SUM(Existencia)) FROM InvValPepsUeps WITH(NOLOCK) WHERE Activo = 0 AND Articulo = @Articuloz AND ISNULL(SubCuenta, '') = ISNULL(ISNULL(@SubCuentaz, SubCuenta), '') AND Estacion = @Estacion
ELSE
SELECT @SumaSal = 0
SELECT @Acum = 0, @Acum1 = 0, @Fuera = 0
IF RTRIM(@InvVal) = 'PEPS'
BEGIN
DECLARE CrInvValPU CURSOR LOCAL FOR
SELECT Articulo, SubCuenta, Descripcion, Mov, MovID, Moneda, Fecha, Existencia, Costo, Activo, ID
FROM InvValPU WITH(NOLOCK)
WHERE Articulo = @Articuloz
AND ISNULL(SubCuenta, '') = ISNULL(ISNULL(@SubCuentaz, SubCuenta), '')
AND Estacion = @Estacion
ORDER BY Moneda, Articulo, SubCuenta, Fecha
OPEN CrInvValPU
FETCH NEXT FROM CrInvValPU INTO @Articulox, @SubCuentax, @Descripcionx, @Movx, @MovIDx, @Monedax, @Fechax, @Existenciax, @Costox, @Activox, @IDx
END
ELSE
BEGIN
DECLARE CrInvValPU CURSOR LOCAL FOR
SELECT Articulo, SubCuenta, Descripcion, Mov, MovID, Moneda, Fecha, Existencia, Costo, Activo, ID
FROM InvValPU 
WHERE Articulo = @Articuloz
AND ISNULL(SubCuenta, '') = ISNULL(ISNULL(@SubCuentaz, SubCuenta), '')
AND Estacion = @Estacion
ORDER BY Moneda, Articulo, SubCuenta, Fecha DESC
OPEN CrInvValPU
FETCH NEXT FROM CrInvValPU INTO @Articulox, @SubCuentax, @Descripcionx, @Movx, @MovIDx, @Monedax, @Fechax, @Existenciax, @Costox, @Activox, @IDx
END
WHILE @@FETCH_STATUS <> -1
BEGIN
IF @@FETCH_STATUS <> -2
BEGIN
SELECT @Acum = @Acum + @Existenciax
SELECT @Acum1 = @Acum1 + @Existenciax
IF @Acum1 > ISNULL(@SumaSal, 0) AND @Fuera = 0
BEGIN
SELECT @Acum = @Acum - @Existenciax
SELECT @DifEnt = ISNULL(@SumaSal, 0) - @Acum
SELECT @ResEnt = @Existenciax - @DifEnt
UPDATE InvValPU WITH(ROWLOCK) SET Existencia = @ResEnt WHERE Articulo = @Articulox AND ISNULL(SubCuenta, '') = ISNULL(ISNULL(@SubCuentax, SubCuenta), '') AND Mov = @Movx AND MovID = @MovIDx AND ID = @IDx AND Estacion = @Estacion
SELECT @Fuera = 1
END
ELSE
BEGIN
IF @Fuera = 0
UPDATE InvValPU WITH(ROWLOCK) SET Activo = 2 WHERE Articulo = @Articulox AND ISNULL(SubCuenta, '') = ISNULL(ISNULL(@SubCuentax, SubCuenta), '') AND Mov = @Movx AND MovID = @MovIDx AND ID = @IDx AND Estacion = @Estacion
END
END
FETCH NEXT FROM CrInvValPU INTO @Articulox, @SubCuentax, @Descripcionx, @Movx, @MovIDx, @Monedax, @Fechax, @Existenciax, @Costox, @Activox, @IDx
END
CLOSE CrInvValPU
DEALLOCATE CrInvValPU
END
FETCH NEXT FROM CrInvValT INTO @Articuloz, @SubCuentaz, @Descripcionz
END
CLOSE CrInvValT
DEALLOCATE CrInvValT
SELECT Articulo, SubCuenta, CostoTPU = SUM(Costo * Existencia)
INTO #CostoPU
FROM InvValPU WITH(NOLOCK)
WHERE Activo = 1
AND Estacion = @Estacion
GROUP BY Articulo, SubCuenta
UPDATE InvValPU WITH(ROWLOCK) SET CostoT = a.CostoTPU FROM #CostoPU a, InvValPU b WHERE b.Articulo = a.Articulo AND ISNULL(a.SubCuenta, '') = ISNULL(ISNULL(b.SubCuenta, a.SubCuenta), '') AND b.Estacion = @Estacion
IF RTRIM(@InvVal) = 'UEPS'
SELECT * FROM InvValPU WITH(NOLOCK) WHERE Activo = 1 AND Estacion = @Estacion ORDER BY Moneda, Articulo, SubCuenta, Fecha DESC
ELSE
IF RTRIM(@InvVal) = 'PEPS'
SELECT * FROM InvValPU WITH(NOLOCK) WHERE Activo = 1 AND Estacion = @Estacion ORDER BY Moneda, Articulo, SubCuenta, Fecha
ELSE
SELECT * FROM InvValPU WITH(NOLOCK) WHERE Activo = 1 AND Estacion = @Estacion ORDER BY Moneda, Articulo, SubCuenta, Fecha
END

