SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spSaldoInicialContSucursal
@Empresa		char(5),
@CuentaBase		char(20),
@Ejercicio		int,
@Periodo		int,
@FechaInicial	datetime,
@Sucursal            int,
@CargoInicial	money	OUTPUT,
@AbonoInicial	money	OUTPUT,
@Ok			int	OUTPUT,
@Moneda		char(10) = NULL,
@Controladora	char(5)  = NULL

AS BEGIN
SELECT @CargoInicial = 0.0, @AbonoInicial = 0.0
IF UPPER(@Empresa) 	   IN ('0', 'NULL', '(TODOS)','') SELECT @Empresa = NULL
IF UPPER(@Controladora)  IN ('0', 'NULL', '(TODOS)','') SELECT @Controladora = NULL
EXEC spContEmpresaGrupo @Empresa OUTPUT, @Controladora OUTPUT
SELECT @CargoInicial = ISNULL(Sum(a.Cargos), 0.0), @AbonoInicial = ISNULL(Sum(a.Abonos), 0.0)
FROM Acum a
JOIN Empresa e ON e.Empresa = a.Empresa AND e.Empresa = ISNULL(@Empresa, e.Empresa) AND ISNULL(e.Controladora,'') = ISNULL(ISNULL(@Controladora, e.Controladora),'')
WHERE a.Moneda  = ISNULL(@Moneda, Moneda)
AND a.Rama    = 'CONT'
AND a.Cuenta  = @CuentaBase
AND a.Ejercicio = @Ejercicio
AND a.Periodo < @Periodo
AND a.Sucursal = ISNULL(@Sucursal,a.Sucursal)
IF @@ERROR <> 0 SELECT @Ok = 1
IF @FechaInicial IS NOT NULL AND DATEPART(dd, @FechaInicial) > 1
BEGIN
SELECT @CargoInicial = ISNULL(@CargoInicial, 0.0) + ISNULL(Sum(Debe), 0.0),
@AbonoInicial = ISNULL(@AbonoInicial, 0.0) + ISNULL(Sum(Haber), 0.0)
FROM ContD
JOIN Cont ON ContD.ID = Cont.ID
JOIN Empresa e ON e.Empresa = ContD.Empresa AND e.Empresa = ISNULL(@Empresa, e.Empresa) AND ISNULL(e.Controladora,'') = ISNULL(ISNULL(@Controladora, e.Controladora),'')
WHERE Cont.Estatus = 'CONCLUIDO'
AND ContD.Cuenta  = @CuentaBase
AND ContD.Ejercicio = @Ejercicio
AND ContD.Periodo   = @Periodo
AND ContD.FechaContable < @FechaInicial
AND Cont.Moneda = ISNULL(@Moneda, Cont.Moneda)
AND SucursalContable = ISNULL(@Sucursal,SucursalContable)
IF @@ERROR <> 0 SELECT @Ok = 1
END
SELECT @CargoInicial = ISNULL(@CargoInicial, 0.0), @AbonoInicial = ISNULL(@AbonoInicial, 0.0)
RETURN
END

