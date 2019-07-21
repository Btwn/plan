SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spVerContBalanzaTotal
@Empresa		varchar(5),
@Ejercicio		int,
@PeriodoD		int,
@PeriodoA		int,
@CuentaD		varchar(20) = NULL,
@CuentaA		varchar(20) = NULL,
@CentroCostos		varchar(50) = NULL,
@Categoria		varchar(50) = NULL,
@Grupo			varchar(50) = NULL,
@Familia		varchar(50) = NULL,
@Sucursal		int         = NULL,
@Moneda			varchar(10) = NULL,
@Controladora		varchar(5)  = NULL,
@UEN			int	    = NULL,
@Proyecto		varchar(50) = NULL,
@CentroCostos2		varchar(50) = NULL,
@CentroCostos3		varchar(50) = NULL

AS BEGIN
DECLARE
@SaldoInicial 	money,
@Cargos		money,
@Abonos		money
IF UPPER(@CentroCostos)  IN ('0', 'NULL', '(TODOS)','', '(ALL)') SELECT @CentroCostos = NULL
IF UPPER(@Categoria)     IN ('0', 'NULL', '(TODOS)','', '(ALL)') SELECT @Categoria = NULL
IF UPPER(@Grupo) 	 IN ('0', 'NULL', '(TODOS)','', '(ALL)') SELECT @Grupo = NULL
IF UPPER(@Familia) 	 IN ('0', 'NULL', '(TODOS)','', '(ALL)') SELECT @Familia = NULL
IF UPPER(@Empresa) 	 IN ('0', 'NULL', '(TODOS)','', '(ALL)') SELECT @Empresa = NULL
IF UPPER(@Proyecto)  	 IN ('0', 'NULL', '(TODOS)','', '(ALL)') SELECT @Proyecto = NULL
IF UPPER(@CentroCostos2) IN ('0', 'NULL', '(TODOS)','', '(ALL)') SELECT @CentroCostos2 = NULL
IF UPPER(@CentroCostos3) IN ('0', 'NULL', '(TODOS)','', '(ALL)') SELECT @CentroCostos3 = NULL
IF @UEN = 0 SELECT @UEN = NULL
IF @Sucursal<0 SELECT @Sucursal = NULL
SELECT @SaldoInicial = SUM(a.Cargos)-SUM(a.Abonos)
FROM Acum a, Cta c
WHERE a.Cuenta = c.Cuenta
AND a.Rama = 'CONT'
AND a.Ejercicio = @Ejercicio
AND a.Periodo BETWEEN 0 AND @PeriodoD-1
AND c.Tipo = 'Mayor'
AND a.Cuenta BETWEEN @CuentaD AND @CuentaA
AND a.Moneda = @Moneda
AND a.Empresa = @Empresa
AND ISNULL(a.Sucursal, 0)   = ISNULL(ISNULL(@Sucursal, a.Sucursal), 0)
AND ISNULL(c.Categoria, '') = ISNULL(ISNULL(@Categoria, c.Categoria) , '')
AND ISNULL(c.Grupo, '')     = ISNULL(ISNULL(@Grupo, c.Grupo) , '')
AND ISNULL(c.Familia, '')   = ISNULL(ISNULL(@Familia, c.Familia) , '')
AND ISNULL(a.UEN, 0)        = ISNULL(ISNULL(@UEN, a.UEN), 0)
AND ISNULL(a.Proyecto, '')  = ISNULL(ISNULL(@Proyecto, a.Proyecto), '')
AND ISNULL(a.SubCuenta, '') = ISNULL(ISNULL(@CentroCostos, a.SubCuenta), '')
AND ISNULL(a.SubCuenta2, '')= ISNULL(ISNULL(@CentroCostos2, a.SubCuenta2), '')
AND ISNULL(a.SubCuenta3, '')= ISNULL(ISNULL(@CentroCostos3, a.SubCuenta3), '')
SELECT @Cargos = SUM(a.Cargos),
@Abonos = SUM(a.Abonos)
FROM Acum a, Cta c
WHERE a.Cuenta = c.Cuenta
AND a.Rama = 'CONT'
AND a.Ejercicio = @Ejercicio
AND a.Periodo BETWEEN @PeriodoD AND @PeriodoA
AND c.Tipo = 'Mayor'
AND a.Cuenta BETWEEN @CuentaD AND @CuentaA
AND a.Moneda = @Moneda
AND a.Empresa = @Empresa
AND ISNULL(a.Sucursal, 0)   = ISNULL(ISNULL(@Sucursal, a.Sucursal), 0)
AND ISNULL(c.Categoria, '') = ISNULL(ISNULL(@Categoria, c.Categoria) , '')
AND ISNULL(c.Grupo, '')     = ISNULL(ISNULL(@Grupo, c.Grupo) , '')
AND ISNULL(c.Familia, '')   = ISNULL(ISNULL(@Familia, c.Familia) , '')
AND ISNULL(a.UEN, 0)        = ISNULL(ISNULL(@UEN, a.UEN), 0)
AND ISNULL(a.Proyecto, '')  = ISNULL(ISNULL(@Proyecto, a.Proyecto), '')
AND ISNULL(a.SubCuenta, '') = ISNULL(ISNULL(@CentroCostos, a.SubCuenta), '')
AND ISNULL(a.SubCuenta2, '')= ISNULL(ISNULL(@CentroCostos2, a.SubCuenta2), '')
AND ISNULL(a.SubCuenta3, '')= ISNULL(ISNULL(@CentroCostos3, a.SubCuenta3), '')
SELECT "SaldoInicial" = @SaldoInicial, "Cargos" = @Cargos, "Abonos" = @Abonos
RETURN
END

