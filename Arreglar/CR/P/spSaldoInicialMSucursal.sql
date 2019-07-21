SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spSaldoInicialMSucursal
@Empresa	char(5),
@Rama		char(5),
@MonedaBase	char(10),
@GrupoBase	char(10),
@CuentaBase	char(20),
@SubCuentaBase	varchar(50),
@EsResultados	bit,
@FechaInicial	datetime,
@Sucursal       int,
@CargoInicial 	money	OUTPUT,
@AbonoInicial 	money	OUTPUT,
@Ok		int	OUTPUT

AS BEGIN
DECLARE
@Ejercicio	int,
@Periodo	int
SELECT @CargoInicial = 0.0, @AbonoInicial = 0.0
EXEC spPeriodoEjercicio @Empresa, @Rama, @FechaInicial, @Periodo OUTPUT, @Ejercicio OUTPUT, @Ok OUTPUT
IF @EsResultados = 0
BEGIN
SELECT @CargoInicial = ISNULL(Sum(Cargos), 0.0), @AbonoInicial = ISNULL(Sum(Abonos), 0.0)
FROM Acum
WHERE Empresa   = @Empresa
AND Rama      = @Rama
AND Moneda    = CASE @MonedaBase    WHEN NULL THEN Moneda    ELSE @MonedaBase    END
AND Grupo     = CASE @GrupoBase     WHEN NULL THEN Grupo     ELSE @GrupoBase     END
AND Cuenta    = @CuentaBase 
AND SubCuenta = CASE @SubCuentaBase WHEN NULL THEN SubCuenta ELSE @SubCuentaBase END
AND Ejercicio = @Ejercicio
AND Periodo < @Periodo
AND Sucursal = ISNULL(@Sucursal,Sucursal)
IF @@ERROR <> 0 SELECT @Ok = 1
IF DATEPART(dd, @FechaInicial) > 1
BEGIN
SELECT @CargoInicial = ISNULL(@CargoInicial, 0.0) + ISNULL(Sum(Cargo), 0.0),
@AbonoInicial = ISNULL(@AbonoInicial, 0.0) + ISNULL(Sum(Abono), 0.0)
FROM Auxiliar
WHERE Empresa   = @Empresa
AND Rama      = @Rama
AND Moneda    = CASE @MonedaBase    WHEN NULL THEN Moneda    ELSE @MonedaBase    END
AND Grupo     = CASE @GrupoBase     WHEN NULL THEN Grupo     ELSE @GrupoBase     END
AND Cuenta    = @CuentaBase 
AND SubCuenta = CASE @SubCuentaBase WHEN NULL THEN SubCuenta ELSE @SubCuentaBase END
AND Ejercicio = @Ejercicio
AND Periodo   = @Periodo
AND Fecha < @FechaInicial
AND Sucursal = ISNULL(@Sucursal,Sucursal)
IF @@ERROR <> 0 SELECT @Ok = 1
END
END ELSE
BEGIN
SELECT @CargoInicial = ISNULL(Sum(Cargos), 0.0), @AbonoInicial = ISNULL(Sum(Abonos), 0.0)
FROM AcumR
WHERE Empresa   = @Empresa
AND Rama      = @Rama
AND Moneda    = CASE @MonedaBase    WHEN NULL THEN Moneda    ELSE @MonedaBase    END
AND Grupo     = CASE @GrupoBase     WHEN NULL THEN Grupo     ELSE @GrupoBase     END
AND Cuenta    = @CuentaBase 
AND SubCuenta = CASE @SubCuentaBase WHEN NULL THEN SubCuenta ELSE @SubCuentaBase END
AND Ejercicio = @Ejercicio
AND Periodo < @Periodo
AND Sucursal = ISNULL(@Sucursal,Sucursal)
IF @@ERROR <> 0 SELECT @Ok = 1
IF DATEPART(dd, @FechaInicial) > 1
BEGIN
SELECT @CargoInicial = ISNULL(@CargoInicial, 0.0) + ISNULL(Sum(Cargo), 0.0),
@AbonoInicial = ISNULL(@AbonoInicial, 0.0) + ISNULL(Sum(Abono), 0.0)
FROM AuxiliarR
WHERE Empresa   = @Empresa
AND Rama      = @Rama
AND Moneda    = CASE @MonedaBase    WHEN NULL THEN Moneda    ELSE @MonedaBase    END
AND Grupo     = CASE @GrupoBase     WHEN NULL THEN Grupo     ELSE @GrupoBase     END
AND Cuenta    = @CuentaBase  
AND SubCuenta = CASE @SubCuentaBase WHEN NULL THEN SubCuenta ELSE @SubCuentaBase END
AND Ejercicio = @Ejercicio
AND Periodo   = @Periodo
AND Fecha < @FechaInicial
AND Sucursal = ISNULL(@Sucursal,Sucursal)
IF @@ERROR <> 0 SELECT @Ok = 1
END
END
SELECT @CargoInicial = ISNULL(@CargoInicial, 0.0), @AbonoInicial = ISNULL(@AbonoInicial, 0.0)
RETURN
END

