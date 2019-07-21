SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spSaldoInicialU
@Empresa	char(5),
@Rama		char(5),
@MonedaBase	char(10),
@GrupoBase	char(10),
@CuentaBase	char(20),
@SubCuentaBase	varchar(50),
@EsResultados	bit,
@FechaInicial	datetime,
@CargoInicial 	money	OUTPUT,
@AbonoInicial 	money	OUTPUT,
@CargoInicialU 	float	OUTPUT,
@AbonoInicialU 	float	OUTPUT,
@Ok		int	OUTPUT,
@SubGrupoBase	varchar(20)	= ''

AS BEGIN
DECLARE
@Ejercicio	int,
@Periodo	int
IF @Rama = 'INV'
SELECT @SubGrupoBase = ISNULL(dbo.fnAlmacenTarima(@GrupoBase, @SubGrupoBase), '')
ELSE SELECT @SubGrupoBase = ''
SELECT @CargoInicial = 0.0, @AbonoInicial = 0.0
EXEC spPeriodoEjercicio @Empresa, @Rama, @FechaInicial, @Periodo OUTPUT, @Ejercicio OUTPUT, @Ok OUTPUT
IF @EsResultados = 0
BEGIN
SELECT @CargoInicial = ISNULL(Sum(Cargos), 0.0), @CargoInicialU = ISNULL(Sum(CargosU), 0.0),
@AbonoInicial = ISNULL(Sum(Abonos), 0.0), @AbonoInicialU = ISNULL(Sum(AbonosU), 0.0)
FROM
(
SELECT Cargos, CargosU, Abonos, AbonosU
FROM AcumU
WHERE Empresa   = @Empresa
AND Rama      = @Rama
AND Moneda    = CASE @MonedaBase    WHEN NULL THEN Moneda    ELSE @MonedaBase    END
AND Grupo     = CASE @GrupoBase     WHEN NULL THEN Grupo     ELSE @GrupoBase     END
AND SubGrupo  = CASE @SubGrupoBase  WHEN NULL THEN SubGrupo  ELSE @SubGrupoBase  END
AND Cuenta    = @CuentaBase 
AND SubCuenta = CASE @SubCuentaBase WHEN NULL THEN SubCuenta ELSE @SubCuentaBase END
AND Ejercicio = @Ejercicio
AND Periodo < @Periodo
UNION ALL
SELECT Cargos, CargosU, Abonos, AbonosU
FROM AcumUWMS
WHERE Empresa   = @Empresa
AND Rama      = @Rama
AND Moneda    = CASE @MonedaBase    WHEN NULL THEN Moneda    ELSE @MonedaBase    END
AND Cuenta    = @CuentaBase 
AND SubCuenta = CASE @SubCuentaBase WHEN NULL THEN SubCuenta ELSE @SubCuentaBase END
AND Ejercicio = @Ejercicio
AND Periodo < @Periodo
) A
IF @@ERROR <> 0 SELECT @Ok = 1
IF DATEPART(dd, @FechaInicial) > 1
BEGIN
SELECT @CargoInicial = ISNULL(@CargoInicial, 0.0) + ISNULL(Sum(Cargo), 0.0), @CargoInicialU = ISNULL(@CargoInicialU, 0.0) + ISNULL(Sum(CargoU), 0.0),
@AbonoInicial = ISNULL(@AbonoInicial, 0.0) + ISNULL(Sum(Abono), 0.0), @AbonoInicialU = ISNULL(@AbonoInicialU, 0.0) + ISNULL(Sum(AbonoU), 0.0)
FROM
(
SELECT Cargo, CargoU, Abono, AbonoU
FROM AuxiliarU
WHERE Empresa   = @Empresa
AND Rama      = @Rama
AND Moneda    = CASE @MonedaBase    WHEN NULL THEN Moneda    ELSE @MonedaBase    END
AND Grupo     = CASE @GrupoBase     WHEN NULL THEN Grupo     ELSE @GrupoBase     END
AND SubGrupo  = CASE @SubGrupoBase  WHEN NULL THEN SubGrupo  ELSE @SubGrupoBase  END
AND Cuenta    = @CuentaBase 
AND SubCuenta = CASE @SubCuentaBase WHEN NULL THEN SubCuenta ELSE @SubCuentaBase END
AND Ejercicio = @Ejercicio
AND Periodo   = @Periodo
AND Fecha < @FechaInicial
UNION ALL
SELECT Cargo, CargoU, Abono, AbonoU
FROM AuxiliarUWMS
WHERE Empresa   = @Empresa
AND Rama      = @Rama
AND Moneda    = CASE @MonedaBase    WHEN NULL THEN Moneda    ELSE @MonedaBase    END
AND Grupo     = CASE @GrupoBase     WHEN NULL THEN Grupo     ELSE @GrupoBase     END
AND Cuenta    = @CuentaBase 
AND SubCuenta = CASE @SubCuentaBase WHEN NULL THEN SubCuenta ELSE @SubCuentaBase END
AND Ejercicio = @Ejercicio
AND Periodo   = @Periodo
AND Fecha < @FechaInicial
) A
IF @@ERROR <> 0 SELECT @Ok = 1
END
END ELSE
BEGIN
SELECT @CargoInicial = ISNULL(Sum(Cargos), 0.0), @CargoInicialU = ISNULL(Sum(CargosU), 0.0),
@AbonoInicial = ISNULL(Sum(Abonos), 0.0), @AbonoInicialU = ISNULL(Sum(AbonosU), 0.0)
FROM AcumRU
WHERE Empresa   = @Empresa
AND Rama      = @Rama
AND Moneda    = CASE @MonedaBase    WHEN NULL THEN Moneda    ELSE @MonedaBase    END
AND Grupo     = CASE @GrupoBase     WHEN NULL THEN Grupo     ELSE @GrupoBase     END
AND Cuenta    = @CuentaBase 
AND SubCuenta = CASE @SubCuentaBase WHEN NULL THEN SubCuenta ELSE @SubCuentaBase END
AND Ejercicio = @Ejercicio
AND Periodo < @Periodo
IF @@ERROR <> 0 SELECT @Ok = 1
IF DATEPART(dd, @FechaInicial) > 1
BEGIN
SELECT @CargoInicial = ISNULL(@CargoInicial, 0.0) + ISNULL(Sum(Cargo), 0.0), @CargoInicialU = ISNULL(@CargoInicialU, 0.0) + ISNULL(Sum(CargoU), 0.0),
@AbonoInicial = ISNULL(@AbonoInicial, 0.0) + ISNULL(Sum(Abono), 0.0), @AbonoInicialU = ISNULL(@AbonoInicialU, 0.0) + ISNULL(Sum(AbonoU), 0.0)
FROM AuxiliarRU
WHERE Empresa   = @Empresa
AND Rama      = @Rama
AND Moneda    = CASE @MonedaBase    WHEN NULL THEN Moneda    ELSE @MonedaBase    END
AND Grupo     = CASE @GrupoBase     WHEN NULL THEN Grupo     ELSE @GrupoBase     END
AND Cuenta    = @CuentaBase 
AND SubCuenta = CASE @SubCuentaBase WHEN NULL THEN SubCuenta ELSE @SubCuentaBase END
AND Ejercicio = @Ejercicio
AND Periodo   = @Periodo
AND Fecha < @FechaInicial
IF @@ERROR <> 0 SELECT @Ok = 1
END
END
SELECT @CargoInicial = ISNULL(@CargoInicial, 0.0), @CargoInicialU = ISNULL(@CargoInicialU, 0.0),
@AbonoInicial = ISNULL(@AbonoInicial, 0.0), @AbonoInicialU = ISNULL(@AbonoInicialU, 0.0)
RETURN
END

