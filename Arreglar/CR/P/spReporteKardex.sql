SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spReporteKardex
@Estacion	int,
@Empresa varchar(10),
@Sucursal int,
@Costeo varchar(20),
@FechaD datetime,
@FechaA datetime,
@ArticuloD varchar(20),
@ArticuloA varchar(20),
@ArtOpcion varchar(20),
@ArtSerieLote varchar(50),
@Almacen  varchar(20),
@ArtCategoria varchar(50),
@ArtGrupo varchar(50),
@ArtFamilia varchar(50),
@ArtFabricante varchar(50),
@ArtLinea varchar(20)

AS BEGIN
DECLARE
@ID int, @Mov varchar(20), @Articulo varchar(20),
@Subcuenta varchar(20), @CargoU float, @AbonoU float, @Cargo money, @Abono money,
@AnteriorID int,
@AnteriorSaldoU float,
@AnteriorSaldoM money,
@SaldoU float,
@SaldoM money,
@CostoPromedio float,
@CosteoOpcion bit,
@CosteoSeries bit,
@CosteoLotes bit,
@SerieLote varchar(50),
@ArtTipo varchar(20),
@ArtSubcuenta varchar(20),
@CostoEstandar float,
@CostoReposicion float,
@FormaCosteo varchar(20),
@TipoCosteo varchar(20),
@Continuar bit,
@IDR Int
SET ANSI_DEFAULTS OFF
SET ARITHABORT OFF
SELECT @Continuar = 1
IF @ArtOpcion = '(TODAS)' SELECT @ArtOpcion  = NULL
IF @ArtCategoria = '(Todos)' SELECT @ArtCategoria = NULL
IF @ArtGrupo = '(Todos)' SELECT @ArtGrupo = NULL
IF @ArtFamilia = '(Todos)' SELECT @ArtFamilia = NULL
IF @ArtFabricante = '(Todos)' SELECT @ArtFabricante = NULL
IF @ArtLinea = '(Todos)' SELECT @ArtLinea = NULL
IF @Almacen = '(TODOS)' SELECT @Almacen = NULL
IF @ArtSerieLote = '(TODOS)' SELECT @ArtSerieLote  = NULL
CREATE TABLE #ReporteKardex (
IDR			    int			Identity(1,1),
ID				Int			NULL,
Empresa			varchar(10) COLLATE DATABASE_DEFAULT NULL,
Sucursal			int			NULL,
Modulo			varchar(10) COLLATE DATABASE_DEFAULT NULL,
ModuloID			int			NULL,
Mov				varchar(20) COLLATE DATABASE_DEFAULT NULL,
MovID				varchar(20) COLLATE DATABASE_DEFAULT NULL,
Almacen			varchar(20) COLLATE DATABASE_DEFAULT NULL,
Subgrupo			varchar(20) COLLATE DATABASE_DEFAULT NULL,
FechaSistema		datetime	NULL,
FechaEmision		datetime	NULL,
Articulo			varchar(20) COLLATE DATABASE_DEFAULT NULL,
Subcuenta			varchar(20) COLLATE DATABASE_DEFAULT NULL,
SerieLote			varchar(50) COLLATE DATABASE_DEFAULT NULL,
ArtTipo			varchar(20) COLLATE DATABASE_DEFAULT NULL,
CostoUnitario		float		NULL,
CargoU			float		NULL,
AbonoU			float		NULL,
Cargo				money		NULL,
Abono				money		NULL,
SaldoU			float		NULL,
SaldoM			money		NULL,
CostoPromedio		float		NULL,
CostoEstandar		float		NULL,
CostoReposicion	float		NULL
)
SELECT @Subcuenta = @ArtOpcion
TRUNCATE TABLE #ReporteKardex
SELECT
@FormaCosteo = FormaCosteo,
@TipoCosteo = TipoCosteo,
@CosteoOpcion = CosteoNivelSubCuenta,
@CosteoSeries = CosteoSeries,
@CosteoLotes = CosteoLotes
FROM EmpresaCfg WHERE Empresa = @Empresa
IF @FormaCosteo = 'Empresa' AND @Costeo != @TipoCosteo
SELECT @Continuar = 0
IF @Continuar = 1
BEGIN
IF @CosteoSeries = 1 OR @CosteoLotes = 1
INSERT #ReporteKardex (ID, Empresa, Sucursal, Modulo, ModuloID, Mov, MovID, Almacen, Subgrupo, FechaSistema, FechaEmision, Articulo, Subcuenta, SerieLote, ArtTipo, CostoUnitario, CargoU, AbonoU, Cargo, Abono, SaldoU, SaldoM, CostoPromedio)
SELECT 'ID' = MAX(u.ID), 'Empresa' = MAX(u.Empresa), 'Sucursal' = MAX(u.Sucursal), 'Modulo'=NULL, 'ModuloID'=NULL, 'Mov' = 'SALDO INICIAL', 'MOVID'=NULL,  /*Moneda,*/ 'Almacen'=NULL, 'SubGrupo'=NULL,
'Fechasistema'= @FechaD,
'FechaEmision' =@FechaD,
u.Cuenta, NULLIF(u.Subcuenta,''), s.SerieLote, MAX(a.Tipo),
'CostoUnitario' = NULL,
'CargoU'= NULL,
'AbonoU'= NULL,
'Cargo'= NULL,
'Abono'= NULL,
'SaldoU'=ISNULL(SUM(CASE WHEN u.CargoU > 0 THEN s.Cantidad ELSE 0 END),0) - ISNULL(SUM(CASE WHEN u.AbonoU > 0 THEN s.Cantidad ELSE 0 END),0),
'SaldoM' = ISNULL(SUM(CASE WHEN u.CargoU > 0 THEN s.Cantidad*(u.Cargo/u.CargoU) ELSE 0 END),0) - ISNULL(SUM(CASE WHEN u.AbonoU > 0 THEN s.Cantidad*(u.Abono/u.AbonoU) ELSE 0 END),0),
'CostoPromedio'= ROUND(( (ISNULL(SUM(CASE WHEN u.CargoU > 0 THEN s.Cantidad*(u.Cargo/u.CargoU) ELSE 0 END),0) - ISNULL(SUM(CASE WHEN u.AbonoU > 0 THEN s.Cantidad*(u.Abono/u.AbonoU) ELSE 0 END),0)) / (ISNULL(SUM(CASE WHEN u.CargoU > 0 THEN s.Cantidad ELSE 0 END),0) - ISNULL(SUM(CASE WHEN u.AbonoU > 0 THEN s.Cantidad ELSE 0 END),0)) ), 2)
FROM Art a
JOIN Auxiliaru u ON a.Articulo = u.Cuenta
JOIN SerieloteMov s ON u.modulo = s.modulo AND u.ModuloID = s.ID AND u.Cuenta = s.Articulo AND ISNULL(u.SubCuenta, '') = ISNULL(s.SubCuenta, '') AND s.RenglonID = dbo.fnRenglonID(u.modulo, u.ModuloID, u.REnglon, u.RenglonSub)
WHERE u.Empresa = @Empresa AND u.Sucursal = @Sucursal
AND u.Rama = 'INV'
AND u.cuenta >= @ArticuloD AND u.Cuenta <= @ArticuloA
AND u.Subcuenta IN (ISNULL(@Subcuenta,u.Subcuenta))
AND s.SerieLote IN (ISNULL(@ArtSerieLote,s.SerieLote))
AND dbo.fnFechaREgistro(u.Modulo, u.ModuloID) < @FechaD
AND a.Estatus = 'ALTA'
AND a.Familia IN (ISNULL(@ArtFamilia, a.Familia))
AND a.Grupo IN (ISNULL(@ArtGrupo, a.Grupo))
AND a.Categoria IN (ISNULL(@ArtCategoria, a.Categoria))
AND a.Fabricante IN (ISNULL(@ArtFabricante, a.Fabricante))
AND a.Linea IN (ISNULL(@ArtLinea, a.Linea))
AND a.Tipo IN (CASE WHEN @CosteoLotes=1 AND a.Tipo = 'LOTE' THEN 'LOTE' ELSE (CASE WHEN @CosteoSeries=1 AND a.Tipo = 'SERIE' THEN 'SERIE' ELSE '' END) END)
AND a.TipoCosteo IN (CASE WHEN @FormaCosteo = 'Articulo' THEN @Costeo ELSE a.TipoCosteo END)
GROUP BY u.Cuenta, u.Subcuenta, s.SerieLote
ORDER BY u.Cuenta, CASE WHEN @CosteoOpcion = 1 THEN u.Subcuenta ELSE NULL END, s.SerieLote
INSERT #ReporteKardex (ID, Empresa, Sucursal, Modulo, ModuloID, Mov, MovID, Almacen, Subgrupo, FechaSistema, FechaEmision, Articulo, Subcuenta, SerieLote, ArtTipo, CostoUnitario, CargoU, AbonoU, Cargo, Abono, SaldoU, SaldoM, CostoPromedio)
SELECT 'ID' = MAX(ID), 'Empresa' = MAX(u.Empresa), 'Sucursal' = MAX(u.Sucursal), 'Modulo'=NULL, 'ModuloID'=NULL, 'Mov' = 'SALDO INICIAL', 'MOVID'=NULL,  /*Moneda,*/ 'Almacen'=NULL, 'SubGrupo'=NULL,
'Fechasistema'= @FechaD,
'FechaEmision' =@FechaD,
u.Cuenta, NULLIF(u.Subcuenta,''), 'SerieLote'=NULL, MAX(a.Tipo),
'CostoUnitario' = NULL,
'CargoU'= NULL,
'AbonoU'= NULL,
'Cargo'= NULL,
'Abono'= NULL,
'SaldoU'=ISNULL(SUM(u.CargoU),0) - ISNULL(SUM(u.AbonoU),0),
'SaldoM' = ISNULL(SUM(u.Cargo),0) - ISNULL(SUM(u.Abono),0),
'CostoPromedio'= ROUND( (ISNULL(SUM(u.Cargo),0) - ISNULL(SUM(u.Abono),0))  / ( ISNULL(SUM(u.CargoU),0) - ISNULL(SUM(u.AbonoU),0)) , 2)
FROM Art a
JOIN Auxiliaru u ON a.Articulo = u.Cuenta
WHERE u.Empresa = @Empresa AND u.Sucursal = @Sucursal
AND u.Rama = 'INV'
AND u.cuenta >= @ArticuloD AND u.Cuenta <= @ArticuloA
AND u.Subcuenta IN (ISNULL(@Subcuenta,u.Subcuenta))
AND dbo.fnFechaREgistro(u.Modulo, u.ModuloID) < @FechaD
AND a.Estatus = 'ALTA'
AND a.Familia IN (ISNULL(@ArtFamilia, a.Familia))
AND a.Grupo IN (ISNULL(@ArtGrupo, a.Grupo))
AND a.Categoria IN (ISNULL(@ArtCategoria, a.Categoria))
AND a.Fabricante IN (ISNULL(@ArtFabricante, a.Fabricante))
AND a.Linea IN (ISNULL(@ArtLinea, a.Linea))
AND a.Tipo NOT IN (CASE WHEN @CosteoLotes=1 THEN 'LOTE'  ELSE '' END)
AND a.Tipo NOT IN (CASE WHEN @CosteoSeries=1 THEN 'SERIE' ELSE '' END)
AND a.TipoCosteo IN (CASE WHEN @FormaCosteo = 'Articulo' THEN @Costeo ELSE a.TipoCosteo END)
GROUP BY u.Cuenta, u.Subcuenta
ORDER BY u.Cuenta, CASE WHEN @CosteoOpcion = 1 THEN u.Subcuenta ELSE NULL END
IF @CosteoSeries = 1 OR @CosteoLotes = 1
INSERT #ReporteKardex (ID, Empresa, Sucursal, Modulo, ModuloID, Mov, MovID, Almacen, Subgrupo, FechaSistema, FechaEmision, Articulo, Subcuenta, SerieLote, ArtTipo, CostoUnitario, CargoU, AbonoU, Cargo, Abono, SaldoU, SaldoM, CostoPromedio)
SELECT u.ID, u.Empresa, u.Sucursal, u.Modulo, u.ModuloID, u.Mov, u.MovID, /*Moneda,*/ u.Grupo, u.SubGrupo,
dbo.fnFechaREgistro(u.Modulo, u.ModuloID),
u.Fecha,
u.Cuenta, NULLIF(u.Subcuenta,''), s.SerieLote, a.Tipo,
'CostoUnitario'=ISNULL(u.Cargo/u.CargoU, u.Abono/u.AbonoU) ,
'CargoU'=ISNULL((CASE WHEN u.CargoU > 0 THEN s.Cantidad ELSE 0 END),0),
'AbonoU'= ISNULL((CASE WHEN u.AbonoU > 0 THEN s.Cantidad ELSE 0 END),0),
'Cargo' = ISNULL((CASE WHEN u.CargoU > 0 THEN s.Cantidad*(u.Cargo/u.CargoU) ELSE 0 END),0),
'Abono' = ISNULL((CASE WHEN u.AbonoU > 0 THEN s.Cantidad*(u.Abono/u.AbonoU) ELSE 0 END),0),
'SaldoU' = NULL,
'SaldoM' = NULL,
'CostoPromedio' = NULL
FROM Art a
JOIN Auxiliaru u ON a.Articulo = u.Cuenta
JOIN SerieloteMov s ON u.modulo = s.modulo AND u.ModuloID = s.ID AND u.Cuenta = s.Articulo AND ISNULL(u.SubCuenta, '') = ISNULL(s.SubCuenta, '') AND s.RenglonID = dbo.fnRenglonID(u.modulo, u.ModuloID, u.REnglon, u.RenglonSub)
AND a.TipoCosteo IN (CASE WHEN @FormaCosteo = 'Articulo' THEN @Costeo ELSE a.TipoCosteo END)
WHERE
u.Empresa = @Empresa AND u.Sucursal = @Sucursal
AND u.Rama = 'INV'
AND u.cuenta >= @ArticuloD AND u.Cuenta <= @ArticuloA
AND u.Subcuenta IN (ISNULL(@Subcuenta,u.Subcuenta))
AND s.SerieLote IN (ISNULL(@ArtSerieLote,s.SerieLote))
AND dbo.fnFechaREgistro(u.Modulo, u.ModuloID) BETWEEN @FechaD AND @FechaA
AND a.Familia IN (ISNULL(@ArtFamilia, a.Familia))
AND a.Grupo IN (ISNULL(@ArtGrupo, a.Grupo))
AND a.Categoria IN (ISNULL(@ArtCategoria, a.Categoria))
AND a.Fabricante IN (ISNULL(@ArtFabricante, a.Fabricante))
AND a.Linea IN (ISNULL(@ArtLinea, a.Linea))
AND a.Estatus = 'ALTA'
AND a.Tipo IN (CASE WHEN @CosteoLotes=1 AND a.Tipo = 'LOTE' THEN 'LOTE' ELSE (CASE WHEN @CosteoSeries=1 AND a.Tipo = 'SERIE' THEN 'SERIE' ELSE '' END) END)
ORDER BY u.Cuenta, CASE WHEN @CosteoOpcion = 1 THEN u.Subcuenta ELSE NULL END, u.ID
INSERT #ReporteKardex (ID, Empresa, Sucursal, Modulo, ModuloID, Mov, MovID, Almacen, Subgrupo, FechaSistema, FechaEmision, Articulo, Subcuenta, SerieLote, ArtTipo, CostoUnitario, CargoU, AbonoU, Cargo, Abono, SaldoU, SaldoM, CostoPromedio)
SELECT u.ID, u.Empresa, u.Sucursal, u.Modulo, u.ModuloID, u.Mov, u.MovID, /*Moneda,*/ u.Grupo, u.SubGrupo,
dbo.fnFechaREgistro(u.Modulo, u.ModuloID),
u.Fecha,
u.Cuenta, NULLIF(u.Subcuenta,''), 'SerieLote'= NULL, a.Tipo,
'CostoUnitario'=ISNULL(u.Cargo/u.CargoU, u.Abono/u.AbonoU) ,
u.CargoU, u.AbonoU, u.Cargo, u.Abono,
'SaldoU' = NULL,
'SaldoM' = NULL,
'CostoPromedio' = NULL
FROM Art a
JOIN Auxiliaru u ON a.Articulo = u.Cuenta
WHERE
u.Empresa = @Empresa AND u.Sucursal = @Sucursal
AND u.Rama = 'INV'
AND u.cuenta >= @ArticuloD AND u.Cuenta <= @ArticuloA
AND u.Subcuenta IN (ISNULL(@Subcuenta,u.Subcuenta))
AND dbo.fnFechaREgistro(u.Modulo, u.ModuloID) BETWEEN @FechaD AND @FechaA
AND a.Familia IN (ISNULL(@ArtFamilia, a.Familia))
AND a.Grupo IN (ISNULL(@ArtGrupo, a.Grupo))
AND a.Categoria IN (ISNULL(@ArtCategoria, a.Categoria))
AND a.Fabricante IN (ISNULL(@ArtFabricante, a.Fabricante))
AND a.Linea IN (ISNULL(@ArtLinea, a.Linea))
AND a.Estatus = 'ALTA'
AND a.Tipo NOT IN (CASE WHEN @CosteoLotes=1 THEN 'LOTE'  ELSE '' END)
AND a.Tipo NOT IN (CASE WHEN @CosteoSeries=1 THEN 'SERIE' ELSE '' END)
AND a.TipoCosteo IN (CASE WHEN @FormaCosteo = 'Articulo' THEN @Costeo ELSE a.TipoCosteo END)
ORDER BY u.Cuenta, CASE WHEN @CosteoOpcion = 1 THEN u.Subcuenta ELSE NULL END, u.ID
DECLARE crReporteKardex CURSOR FOR
SELECT IDR, ID, Mov, Articulo, Subcuenta, SerieLote, ArtTipo, CargoU, AbonoU, Cargo, Abono
FROM #ReporteKardex ORDER BY ID
OPEN crReporteKardex
FETCH NEXT FROM crReporteKardex INTO @IDR, @ID, @Mov, @Articulo, @ArtSubcuenta, @SerieLote, @ArtTipo, @CargoU, @AbonoU, @Cargo, @Abono
WHILE @@FETCH_STATUS = 0
BEGIN
IF @Mov != 'SALDO INICIAL'
BEGIN
SELECT @AnteriorID = NULL, @AnteriorSaldoU = 0, @AnteriorSaldoM = 0, @SaldoU = 0, @SaldoM = 0
IF ((@ArtTipo = 'SERIE' AND @CosteoSeries=1) OR (@ArtTipo = 'LOTE' AND @CosteoLotes = 1)) AND @CosteoOpcion = 1
SELECT @AnteriorID = MAX(IDR) FROM #ReporteKardex WHERE ID < @ID AND Articulo = @Articulo  AND Subcuenta IN (ISNULL(@ArtSubcuenta,Subcuenta)) AND SerieLote = @SerieLote
ELSE  IF ((@ArtTipo = 'SERIE' AND @CosteoSeries=1) OR (@ArtTipo = 'LOTE' AND @CosteoLotes = 1))
SELECT @AnteriorID = MAX(IDR) FROM #ReporteKardex WHERE ID < @ID AND Articulo = @Articulo AND SerieLote = @SerieLote
ELSE IF @CosteoOpcion = 1
SELECT @AnteriorID = MAX(IDR) FROM #ReporteKardex WHERE ID < @ID AND Articulo = @Articulo  AND Subcuenta IN (ISNULL(@ArtSubcuenta,Subcuenta))
ELSE
SELECT @AnteriorID = MAX(IDR) FROM #ReporteKardex WHERE ID < @ID AND Articulo = @Articulo
SELECT @AnteriorSaldoU = SaldoU, @AnteriorSaldoM = SaldoM FROM #ReporteKardex WHERE IDR = @AnteriorID
SELECT @SaldoU = ISNULL(@AnteriorSaldoU,0.0) + ISNULL(@CargoU,0.0) - ISNULL(@AbonoU, 0.0)
SELECT @SaldoM = ISNULL(@AnteriorSaldoM,0.0) + ISNULL(@Cargo,0.0) - ISNULL(@Abono, 0.0)
SELECT @CostoPromedio = @SaldoM / @SaldoU
IF @Costeo = 'Promedio'   UPDATE #ReporteKardex SET SaldoU = @SaldoU, SaldoM = @SaldoM, CostoPromedio = @CostoPromedio WHERE IDR = @IDR
ELSE
IF @Costeo = 'Estandar'   UPDATE #ReporteKardex SET SaldoU = @SaldoU, SaldoM = @SaldoM, CostoEstandar = CostoUnitario WHERE IDR = @IDR
ELSE
IF @Costeo = 'Reposicion' UPDATE #ReporteKardex SET SaldoU = @SaldoU, SaldoM = @SaldoM, CostoReposicion = CostoUnitario WHERE IDR = @IDR
END
FETCH NEXT FROM crReporteKardex INTO @IDR, @ID, @Mov, @Articulo, @ArtSubcuenta, @SerieLote, @ArtTipo, @CargoU, @AbonoU, @Cargo, @Abono
END
CLOSE crReporteKardex
DEALLOCATE crReporteKardex
END
SELECT r.*, a.Descripcion1 FROM #REporteKardex r
JOIN Art a ON r.Articulo = a.Articulo
WHERE r.Almacen IN (ISNULL(@Almacen,r.Almacen))
ORDER BY r.Articulo, CASE WHEN @CosteoOpcion = 1 THEN r.Subcuenta ELSE NULL END, r.ID
END

