SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spReporteKardexPEPS
@Estacion	int,
@Empresa varchar(10),
@Sucursal int,
@FechaD datetime,
@FechaA datetime,
@ArticuloD varchar(20),
@ArticuloA varchar(20),
@ArtOpcion varchar(20),
@Almacen  varchar(20),
@ArtCategoria varchar(50),
@ArtGrupo varchar(50),
@ArtFamilia varchar(50),
@ArtFabricante varchar(50),
@ArtLinea varchar(20)

AS BEGIN
DECLARE
@ID				int,
@Mov				varchar(20),
@Articulo			varchar(20),
@FechaSistema datetime,
@Subcuenta varchar(20),
@ArtSubcuenta		varchar(20),
@IDCapa			int,
@CapaModulo		varchar(20),
@CapaMov			varchar(20),
@CapaMovID		varchar(20),
@CapaArticulo		varchar(20),
@CapaSubcuenta	varchar(20),
@CapaExistencia	float,
@CapaCosto		float,
@CapaValor		money,
@CapaSaldoU		float,
@CapaSaldoM		money,
@IDSaldoCapa		int,
@IdReporteK		int,
@SaldoREgistroU	float,
@SaldoRegistroM	float,
@CostoPEPS		float,
@CapaExistenciaNueva float,
@CapaValorNueva	money,
@UltimoIdReporteK int,
@UltimoID			int
IF @ArtOpcion = '(TODAS)'		SELECT @ArtOpcion  = NULL
IF @ArtCategoria = '(Todos)'	SELECT @ArtCategoria = NULL
IF @ArtGrupo = '(Todos)'		SELECT @ArtGrupo = NULL
IF @ArtFamilia = '(Todos)'	SELECT @ArtFamilia = NULL
IF @ArtFabricante = '(Todos)' SELECT @ArtFabricante = NULL
IF @ArtLinea = '(Todos)'		SELECT @ArtLinea = NULL
IF @Almacen = '(TODOS)'		SELECT @Almacen = NULL
SELECT @Subcuenta = @ArtOpcion
CREATE TABLE #ReporteKardex (
IDR			int			Identity(1,1),
ID			Int			NULL,
Empresa		varchar(10) COLLATE DATABASE_DEFAULT NULL,
Sucursal		int			NULL,
Modulo		varchar(10) COLLATE DATABASE_DEFAULT NULL,
ModuloID		int			NULL,
Mov			varchar(20) COLLATE DATABASE_DEFAULT NULL,
MovID			varchar(20) COLLATE DATABASE_DEFAULT NULL,
Almacen		varchar(20) COLLATE DATABASE_DEFAULT NULL,
Subgrupo		varchar(20) COLLATE DATABASE_DEFAULT NULL,
FechaSistema	datetime	NULL,
FechaEmision	datetime	NULL,
Articulo		varchar(20) COLLATE DATABASE_DEFAULT NULL,
Subcuenta		varchar(20) COLLATE DATABASE_DEFAULT NULL,
CostoUnitario float		NULL,
CargoU		float		NULL,
AbonoU		float		NULL,
Cargo			money		NULL,
Abono			money		NULL,
SaldoU		float		NULL,
SaldoM		money		NULL,
CostoPromedio float		NULL,
CostoPEPS		float		NULL,
CapaModulo	varchar(10) COLLATE DATABASE_DEFAULT NULL,
CapaMov		varchar(20) COLLATE DATABASE_DEFAULT NULL,
CapaMovID		varchar(20) COLLATE DATABASE_DEFAULT NULL
)
CREATE TABLE #SaldoCapa
(IDR			int Identity(1,1),
ID			int NULL,
modulo		varchar(10) COLLATE DATABASE_DEFAULT NULL,
Mov			varchar(20) COLLATE DATABASE_DEFAULT NULL,
MovID			varchar(20) COLLATE DATABASE_DEFAULT NULL,
Articulo		varchar(20) COLLATE DATABASE_DEFAULT NULL,
Subcuenta		varchar(20) COLLATE DATABASE_DEFAULT NULL,
Existencia	float NULL,
Costo			float NULL,
Valor			float NULL)
TRUNCATE TABLE #ReporteKardex
CREATE TABLE #TempArt(
Articulo          varchar(20))
CREATE TABLE #TempArtSub(
Articulo          varchar(20),
SubCuenta         varchar(50)   NULL,)
IF ISNULL(RTRIM(@Almacen), '') in ('', 'NULL', 'NULO', 'TODOS', 'TODAS', '(TODOS)', '(TODAS)') SELECT @Almacen = NULL
IF ISNULL(RTRIM(@ArtCategoria), '') in ('', 'NULL', 'NULO', 'TODOS', 'TODAS', '(TODOS)', '(TODAS)') SELECT @ArtCategoria = NULL
IF ISNULL(RTRIM(@ArtGrupo), '') in ('', 'NULL', 'NULO', 'TODOS', 'TODAS', '(TODOS)', '(TODAS)') SELECT @ArtGrupo = NULL
IF ISNULL(RTRIM(@ArtFamilia), '') in ('', 'NULL', 'NULO', 'TODOS', 'TODAS', '(TODOS)', '(TODAS)') SELECT @ArtFamilia = NULL
IF ISNULL(RTRIM(@ArtLinea), '') in ('', 'NULL', 'NULO', 'TODOS', 'TODAS', '(TODOS)', '(TODAS)') SELECT @ArtLinea = NULL
IF ISNULL(RTRIM(@ArtFabricante), '') in ('', 'NULL', 'NULO', 'TODOS', 'TODAS', '(TODOS)', '(TODAS)') SELECT @ArtFabricante = NULL
INSERT INTO #TempArt(Articulo)
SELECT Articulo
FROM Art
WHERE Estatus = 'ALTA'
AND Articulo BETWEEN @ArticuloD AND @ArticuloA
AND ISNULL(Categoria, '') = CASE @ArtCategoria WHEN NULL THEN ISNULL(Categoria, '') ELSE @ArtCategoria END
AND ISNULL(Grupo, '') = CASE @ArtGrupo WHEN NULL THEN ISNULL(Grupo, '') ELSE @ArtGrupo END
AND ISNULL(Familia, '') = CASE @ArtFamilia WHEN NULL THEN ISNULL(Familia, '') ELSE @ArtFamilia END
AND ISNULL(Linea, '') = CASE @ArtLinea WHEN NULL THEN ISNULL(Linea, '') ELSE @ArtLinea END
AND ISNULL(Fabricante, '') = CASE @ArtFabricante WHEN NULL THEN ISNULL(Fabricante, '') ELSE @ArtFabricante END
INSERT #ReporteKardex (ID, Empresa, Sucursal, Modulo, ModuloID, Mov, MovID, Almacen, Subgrupo,
FechaSistema, FechaEmision, Articulo, Subcuenta,
CostoUnitario, CargoU, AbonoU, 
CapaModulo, CapaMov, CapaMovID, SaldoU, SaldoM, CostoPEPS)
SELECT 1/*MAX(u.ID)*/, u.Empresa, u.Sucursal, NULL, NULL, 'REP SALDO INICIAL', NULL, /*Moneda,*/ NULL, NULL,
@FechaD,  @FechaD, u.Cuenta,  NULLIF(u.Subcuenta,''),
MAX(i.costo), NULL, NULL, i.Modulo, i.Mov, i.MovID,
convert(decimal(20,4),(SUM(ISNULL(c.CargoU,0)) - SUM(ISNULL(c.AbonoU,0)))),
(ISNULL(SUM(i.Costo*c.CargoU),0)-ISNULL(SUM(i.costo*c.AbonoU),0)) ,  (ISNULL(SUM(i.Costo*c.CargoU),0)-ISNULL(SUM(i.costo*c.AbonoU),0)) / (SUM(ISNULL(c.CargoU,0)) - SUM(ISNULL(c.AbonoU,0)))
FROM Auxiliaru u
JOIN InvCapaAux c ON u.Modulo = c.Modulo AND u.ModuloID = c.ModuloID AND c.Renglon= u.renglon AND c.RenglonSub = u.RenglonSub
JOIN InvCapa i ON c.ID = i.ID AND i.Sistema = 'G' AND u.Cuenta = i.Articulo AND u.subcuenta = i.Subcuenta
JOIN #TempArt a ON a.Articulo = u.Cuenta
WHERE  u.cuenta BETWEEN @ArticuloD AND @ArticuloA
AND u.Rama = 'INV'
AND u.Subcuenta IN (ISNULL(@Subcuenta,u.Subcuenta))
AND u.FEcha < @FechaD
AND u.Grupo IN (ISNULL(@Almacen, u.Grupo))
and u.Escancelacion = 0
GROUP BY i.Id, u.Empresa, u.Sucursal, u.Cuenta, u.Subcuenta, i.Modulo, i.Mov, i.MovID
Having  convert(decimal(20,4),(SUM(ISNULL(c.CargoU,0)) - SUM(ISNULL(c.AbonoU,0)))) <> 0
INSERT #ReporteKardex (ID, Empresa, Sucursal, Modulo, ModuloID, Mov, MovID, Almacen, Subgrupo,
FechaSistema, FechaEmision, Articulo, Subcuenta,
CostoUnitario, CargoU, AbonoU, Cargo, Abono,
CapaModulo, CapaMov, CapaMovID, CostoPEPS)
SELECT u.ID, u.Empresa, u.Sucursal, u.Modulo, u.ModuloID, u.Mov, u.MovID, /*Moneda,*/ u.Grupo, u.SubGrupo,
u.Fecha,
u.Fecha,
u.Cuenta,  NULLIF(u.Subcuenta,''),
i.costo, MAX(c.CargoU), MAX(c.AbonoU), i.Costo*(MAX(ISNULL(c.CargoU,0))), i.Costo*(MAX(ISNULL(c.AbonoU,0))),
i.Modulo, i.Mov, i.MovID, i.costo
FROM Auxiliaru u
JOIN  InvCapaAux c ON u.Modulo = c.Modulo AND u.ModuloID = c.ModuloID AND c.Renglon= u.renglon AND c.RenglonSub = u.RenglonSub
JOIN InvCapa i ON c.ID = i.ID AND i.Sistema = 'G' AND u.Cuenta = i.Articulo
JOIN #TempArt a ON a.Articulo = u.Cuenta
WHERE u.Empresa = @Empresa AND u.Sucursal = @Sucursal
AND u.Rama = 'INV'
AND u.cuenta >= @ArticuloD AND u.Cuenta <= @ArticuloA
AND u.Subcuenta IN (ISNULL(@Subcuenta,u.Subcuenta))
AND u.FEcha BETWEEN @FechaD AND @FechaA
AND u.Grupo IN (ISNULL(@Almacen, u.Grupo))
and u.Escancelacion = 0
GROUP BY u.ID, u.Empresa, u.Sucursal, u.Modulo, u.ModuloID, u.Mov, u.MovID, /*Moneda,*/ u.Grupo, u.SubGrupo,
u.Fecha,
u.Fecha,
u.Cuenta, u.Subcuenta, i.Modulo, i.Mov, i.MovID,
i.costo
ORDER BY u.Cuenta, u.Subcuenta, u.ID
INSERT INTO #SaldoCapa (ID, Modulo, Mov, MovID, Articulo, Subcuenta, Existencia, Costo, Valor)
SELECT 1, CapaModulo, CapaMov, CapaMovID, Articulo, Subcuenta, SaldoU, CostoPEPS, SaldoM
FROM #ReporteKardex
WHERE Mov = 'REP SALDO INICIAL' AND SaldoU > 0
DECLARE crReporteKardex CURSOR FOR
SELECT IDR, ID, Articulo, Subcuenta, FechaSistema, CapaModulo, CapaMov, CapaMovID, (ISNULL(CargoU,0) - ISNULL(AbonoU,0)), (ISNULL(Cargo,0) - ISNULL(Abono,0)), CostoPEPS
FROM #ReporteKardex WHERE mov != 'REP SALDO INICIAL'
ORDER BY ID, Articulo, Subcuenta
OPEN crReporteKardex
FETCH NEXT FROM crReporteKardex INTO @IDReporteK, @ID, @Articulo, @ArtSubcuenta, @FEchaSistema, @Capamodulo, @CapaMov, @CapaMovID, @SaldoRegistroU, @SaldoREgistroM, @CostoPEPS
WHILE @@FETCH_STATUS = 0
BEGIN
IF @Mov != 'REP SALDO INICIAL'
BEGIN
SELECT @IDSaldoCapa = NULL
IF @UltimoID = @ID
DELETE #ReporteKardex WHERE ID = @ultimoID AND Modulo IS NULL
SELECT @IDSaldoCapa = IDR FROM #SaldoCapa WHERE Modulo = @CapaModulo AND Mov = @CapaMov AND MovID = @CapaMovID AND Articulo = @Articulo AND ISNULL(Subcuenta,'') = ISNULL(@ArtSubcuenta,'')
INSERT #ReporteKardex (ID, Empresa, Sucursal, Modulo, ModuloID, Mov, MovID, /*Moneda,*/ Almacen, Subgrupo,
FechaSistema, FechaEmision, Articulo, Subcuenta,
CostoUnitario, CargoU, AbonoU, 
CapaModulo, CapaMov, CapaMovID, SaldoU, CostoPEPS, SaldoM)
SELECT @ID, @Empresa, @Sucursal, NULL, NULL, NULL, NULL, /*Moneda,*/ NULL, NULL,
@Fechasistema, @Fechasistema, Articulo,  Subcuenta,
NULL, NULL, NULL,
Modulo, Mov, MovID, Existencia, Costo, Valor
FROM #SaldoCapa
WHERE IDR NOT IN (@IDSaldoCapa) AND Articulo = @Articulo AND ISNULL(Subcuenta,'') = ISNULL(@ArtSubcuenta,'')
AND Existencia > 0
AND IDR NOT IN (SELECT c.IDR
FROM #ReporteKardex r
JOIN #SaldoCapa c ON r.CapaModulo = c.Modulo AND r.CapaMov = c.Mov AND c.MovID = r.CapaMovID AND c.Articulo = r.Articulo AND ISNULL(c.Subcuenta,'') = ISNULL(r.Subcuenta,'')
WHERE r.ID = @ID AND ModuloID IS NOT NULL )
IF @IDSaldoCapa IS NULL
BEGIN
INSERT INTO #SaldoCapa (ID, Modulo, Mov, MovID, Articulo, Subcuenta, Existencia, Costo, Valor)
SELECT @Id, @CapaModulo, @CapaMov, @CapaMovID, @Articulo, @ArtSubcuenta, @SaldoREgistroU, @CostoPEPS, @SaldoRegistroM
UPDATE #ReporteKardex SET SaldoU = convert(decimal(20,4),@SaldoRegistroU), SaldoM = @SaldoREgistroM WHERE IDR = @IDReporteK
END ELSE
BEGIN
SELECT @CapaExistencia = Existencia, @CapaValor = Valor FROM #SaldoCapa WHERE IDR = @IDSaldoCapa
UPDATE #ReporteKardex SET @CapaExistenciaNueva = SaldoU = Convert(decimal(20,4),ISNULL(@CapaExistencia,0) + ISNULL(@SaldoRegistroU,0)), @CapaValorNueva = SaldoM = ISNULL(@CapaValor,0) + ISNULL(@SaldoREgistroM,0) WHERE IDR = @IDReporteK
UPDATE #SaldoCapa SET Existencia = @CapaExistenciaNueva, Valor = @CapaValorNueva WHERE IDR = @IDSaldoCapa
END
SELECT @UltimoIDReporteK = @IDReporteK, @UltimoID = @ID
END
FETCH NEXT FROM crReporteKardex INTO @IDReporteK, @ID, @Articulo, @ArtSubcuenta, @FEchaSistema, @Capamodulo, @CapaMov, @CapaMovID, @SaldoRegistroU, @SaldoREgistroM, @CostoPEPS
END
CLOSE crReporteKardex
DEALLOCATE crReporteKardex
SELECT r.*, a.Descripcion1 FROM #REporteKardex r
JOIN Art a ON r.Articulo = a.Articulo
WHERE r.Almacen IN (ISNULL(@Almacen,r.Almacen), NULL)
ORDER BY r.Articulo, r.Subcuenta, r.ID, r.IDR
RETURN
END

