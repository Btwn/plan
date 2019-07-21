SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spPresupuestoCerrarDia
@Sucursal		int,
@Empresa		varchar(5),
@Usuario		varchar(10),
@FechaTrabajo	datetime,
@Fecha		datetime,
@Ok			int          OUTPUT,
@OkRef		varchar(255) OUTPUT

AS BEGIN
DECLARE
@EjercicioTrabajo	int,
@PeriodoTrabajo	int,
@Ejercicio  	int,
@Periodo		int,
@PresupuestoPeriodo	int,
@Moneda		varchar(10),
@Cuenta		varchar(20),
@SubCuenta		varchar(20),
@UEN		int,
@Importe		money,
@ID			int,
@Mov		varchar(20),
@AfectarPresupuesto	varchar(30),
@Renglon		float
IF @Sucursal <> 0 RETURN
SELECT @Moneda = ContMoneda FROM EmpresaCfg WHERE Empresa = @Empresa
SELECT @Mov = ContPresupuesto FROM EmpresaCfgMov WHERE Empresa = @Empresa
EXEC spPeriodoEjercicio @Empresa, 'CONT', @FechaTrabajo, @PeriodoTrabajo OUTPUT, @EjercicioTrabajo OUTPUT, @Ok OUTPUT
EXEC spPeriodoEjercicio @Empresa, 'CONT', @Fecha,        @Periodo OUTPUT,        @Ejercicio OUTPUT,        @Ok OUTPUT
IF @EjercicioTrabajo <> @Ejercicio RETURN
CREATE TABLE #Presupuesto (
UEN 		int NULL,
Periodo 	int NULL,
Cuenta 		varchar(20) COLLATE Database_Default NULL,
SubCuenta 	varchar(20) COLLATE Database_Default NULL,
Reservado 	money NULL,
Comprometido 	money NULL,
Devengado 	money NULL,
Disponible 	money NULL)
INSERT #Presupuesto (
UEN, Cuenta, SubCuenta, Periodo, Reservado,      Comprometido,      Devengado,      Disponible)
SELECT UEN, Cuenta, SubCuenta, Periodo, SUM(Reservado), SUM(Comprometido), SUM(Devengado), SUM(ISNULL(Presupuesto, 0.0)-ISNULL(Reservado, 0.0)-ISNULL(Comprometido, 0.0)-ISNULL(Devengado, 0.0))
FROM Presupuesto
WHERE Empresa = @Empresa AND Moneda = @Moneda AND UEN = @UEN AND Ejercicio = @EjercicioTrabajo AND Periodo < @Periodo
GROUP BY UEN, Cuenta, SubCuenta, Periodo
ORDER BY UEN, Cuenta, SubCuenta, Periodo
/* Reservado */
SELECT @AfectarPresupuesto = 'Reservar'
DECLARE crUEN CURSOR LOCAL FOR
SELECT UEN
FROM #Presupuesto
WHERE NULLIF(Reservado, 0.0) IS NOT NULL
GROUP BY UEN
ORDER BY UEN
OPEN crUEN
FETCH NEXT FROM crUEN INTO @UEN
WHILE @@FETCH_STATUS <> -1 AND @Ok IS NULL
BEGIN
IF @@FETCH_STATUS <> -2
BEGIN
INSERT Cont (
Empresa,  Usuario,  Mov,  Estatus,      Sucursal,  SucursalOrigen, FechaEmision,  FechaContable, UEN,  Moneda,  TipoCambio, AfectarPresupuesto)
VALUES (@Empresa, @Usuario, @Mov, 'SINAFECTAR', @Sucursal, @Sucursal,      @FechaTrabajo, @FechaTrabajo, @UEN, @Moneda, 1.0,        @AfectarPresupuesto)
SELECT @ID = SCOPE_IDENTITY()
SELECT @Renglon = 0.0
DECLARE crPresupuesto CURSOR LOCAL FOR
SELECT Cuenta, SubCuenta, Periodo, SUM(Reservado)
FROM #Presupuesto
GROUP BY Cuenta, SubCuenta, Periodo
ORDER BY Cuenta, SubCuenta, Periodo
OPEN crPresupuesto
FETCH NEXT FROM crPresupuesto INTO @Cuenta, @SubCuenta, @PresupuestoPeriodo, @Importe
WHILE @@FETCH_STATUS <> -1 AND @Ok IS NULL
BEGIN
IF @@FETCH_STATUS <> -2 AND NULLIF(@Importe, 0.0) IS NOT NULL
BEGIN
SELECT @Renglon = @Renglon + 2048.0
INSERT ContD (
ID,  Empresa,  Renglon,  RenglonSub, Sucursal,  Cuenta,  SubCuenta,  Haber,    Ejercicio,  Periodo,             SucursalContable)
SELECT @ID, @Empresa, @Renglon, 0,          @Sucursal, @Cuenta, @SubCuenta, @Importe, @Ejercicio, @PresupuestoPeriodo, @Sucursal
INSERT ContD (
ID,  Empresa,  Renglon,  RenglonSub, Sucursal,  Cuenta,  SubCuenta,  Debe,     Ejercicio,  Periodo,  SucursalContable)
SELECT @ID, @Empresa, @Renglon, 0,          @Sucursal, @Cuenta, @SubCuenta, @Importe, @Ejercicio, @Periodo, @Sucursal
END
FETCH NEXT FROM crPresupuesto INTO @Cuenta, @SubCuenta, @PresupuestoPeriodo, @Importe
END
CLOSE crPresupuesto
DEALLOCATE crPresupuesto
IF EXISTS(SELECT * FROM ContD WHERE ID = @ID)
EXEC spAfectar 'CONT', @ID, @EnSilencio = 1, @Conexion = 1, @Ok = @Ok OUTPUT, @OkRef = @OkRef OUTPUT
END
FETCH NEXT FROM crUEN INTO @UEN
END
CLOSE crUEN
DEALLOCATE crUEN
/* Comprometido */
SELECT @AfectarPresupuesto = 'Comprometer Directo'
DECLARE crUEN CURSOR LOCAL FOR
SELECT UEN
FROM #Presupuesto
WHERE NULLIF(Comprometido, 0.0) IS NOT NULL
GROUP BY UEN
ORDER BY UEN
OPEN crUEN
FETCH NEXT FROM crUEN INTO @UEN
WHILE @@FETCH_STATUS <> -1 AND @Ok IS NULL
BEGIN
IF @@FETCH_STATUS <> -2
BEGIN
INSERT Cont (
Empresa,  Usuario,  Mov,  Estatus,      Sucursal,  SucursalOrigen, FechaEmision,  FechaContable, UEN,  Moneda,  TipoCambio, AfectarPresupuesto)
VALUES (@Empresa, @Usuario, @Mov, 'SINAFECTAR', @Sucursal, @Sucursal,      @FechaTrabajo, @FechaTrabajo, @UEN, @Moneda, 1.0,        @AfectarPresupuesto)
SELECT @ID = SCOPE_IDENTITY()
SELECT @Renglon = 0.0
DECLARE crPresupuesto CURSOR LOCAL FOR
SELECT Cuenta, SubCuenta, Periodo, SUM(Comprometido)
FROM #Presupuesto
GROUP BY Cuenta, SubCuenta, Periodo
ORDER BY Cuenta, SubCuenta, Periodo
OPEN crPresupuesto
FETCH NEXT FROM crPresupuesto INTO @Cuenta, @SubCuenta, @PresupuestoPeriodo, @Importe
WHILE @@FETCH_STATUS <> -1 AND @Ok IS NULL
BEGIN
IF @@FETCH_STATUS <> -2 AND NULLIF(@Importe, 0.0) IS NOT NULL
BEGIN
SELECT @Renglon = @Renglon + 2048.0
INSERT ContD (
ID,  Empresa,  Renglon,  RenglonSub, Sucursal,  Cuenta,  SubCuenta,  Haber,    Ejercicio,  Periodo,             SucursalContable)
SELECT @ID, @Empresa, @Renglon, 0,          @Sucursal, @Cuenta, @SubCuenta, @Importe, @Ejercicio, @PresupuestoPeriodo, @Sucursal
INSERT ContD (
ID,  Empresa,  Renglon,  RenglonSub, Sucursal,  Cuenta,  SubCuenta,  Debe,     Ejercicio,  Periodo,  SucursalContable)
SELECT @ID, @Empresa, @Renglon, 0,          @Sucursal, @Cuenta, @SubCuenta, @Importe, @Ejercicio, @Periodo, @Sucursal
END
FETCH NEXT FROM crPresupuesto INTO @Cuenta, @SubCuenta, @PresupuestoPeriodo, @Importe
END
CLOSE crPresupuesto
DEALLOCATE crPresupuesto
IF EXISTS(SELECT * FROM ContD WHERE ID = @ID)
EXEC spAfectar 'CONT', @ID, @EnSilencio = 1, @Conexion = 1, @Ok = @Ok OUTPUT, @OkRef = @OkRef OUTPUT
END
FETCH NEXT FROM crUEN INTO @UEN
END
CLOSE crUEN
DEALLOCATE crUEN
/* Devengado */
SELECT @AfectarPresupuesto = 'Devengar Directo'
DECLARE crUEN CURSOR LOCAL FOR
SELECT UEN
FROM #Presupuesto
WHERE NULLIF(Devengado, 0.0) IS NOT NULL
GROUP BY UEN
ORDER BY UEN
OPEN crUEN
FETCH NEXT FROM crUEN INTO @UEN
WHILE @@FETCH_STATUS <> -1 AND @Ok IS NULL
BEGIN
IF @@FETCH_STATUS <> -2
BEGIN
INSERT Cont (
Empresa,  Usuario,  Mov,  Estatus,      Sucursal,  SucursalOrigen, FechaEmision,  FechaContable, UEN,  Moneda,  TipoCambio, AfectarPresupuesto)
VALUES (@Empresa, @Usuario, @Mov, 'SINAFECTAR', @Sucursal, @Sucursal,      @FechaTrabajo, @FechaTrabajo, @UEN, @Moneda, 1.0,        @AfectarPresupuesto)
SELECT @ID = SCOPE_IDENTITY()
SELECT @Renglon = 0.0
DECLARE crPresupuesto CURSOR LOCAL FOR
SELECT Cuenta, SubCuenta, Periodo, SUM(Devengado)
FROM #Presupuesto
GROUP BY Cuenta, SubCuenta, Periodo
ORDER BY Cuenta, SubCuenta, Periodo
OPEN crPresupuesto
FETCH NEXT FROM crPresupuesto INTO @Cuenta, @SubCuenta, @PresupuestoPeriodo, @Importe
WHILE @@FETCH_STATUS <> -1 AND @Ok IS NULL
BEGIN
IF @@FETCH_STATUS <> -2 AND NULLIF(@Importe, 0.0) IS NOT NULL
BEGIN
SELECT @Renglon = @Renglon + 2048.0
INSERT ContD (
ID,  Empresa,  Renglon,  RenglonSub, Sucursal,  Cuenta,  SubCuenta,  Haber,    Ejercicio,  Periodo,             SucursalContable)
SELECT @ID, @Empresa, @Renglon, 0,          @Sucursal, @Cuenta, @SubCuenta, @Importe, @Ejercicio, @PresupuestoPeriodo, @Sucursal
INSERT ContD (
ID,  Empresa,  Renglon,  RenglonSub, Sucursal,  Cuenta,  SubCuenta,  Debe,     Ejercicio,  Periodo,  SucursalContable)
SELECT @ID, @Empresa, @Renglon, 0,          @Sucursal, @Cuenta, @SubCuenta, @Importe, @Ejercicio, @Periodo, @Sucursal
END
FETCH NEXT FROM crPresupuesto INTO @Cuenta, @SubCuenta, @PresupuestoPeriodo, @Importe
END
CLOSE crPresupuesto
DEALLOCATE crPresupuesto
IF EXISTS(SELECT * FROM ContD WHERE ID = @ID)
EXEC spAfectar 'CONT', @ID, @EnSilencio = 1, @Conexion = 1, @Ok = @Ok OUTPUT, @OkRef = @OkRef OUTPUT
END
FETCH NEXT FROM crUEN INTO @UEN
END
CLOSE crUEN
DEALLOCATE crUEN
/* Disponible */
SELECT @AfectarPresupuesto = 'Asignar'
DECLARE crUEN CURSOR LOCAL FOR
SELECT UEN
FROM #Presupuesto
WHERE NULLIF(Disponible, 0.0) IS NOT NULL
GROUP BY UEN
ORDER BY UEN
OPEN crUEN
FETCH NEXT FROM crUEN INTO @UEN
WHILE @@FETCH_STATUS <> -1 AND @Ok IS NULL
BEGIN
IF @@FETCH_STATUS <> -2
BEGIN
INSERT Cont (
Empresa,  Usuario,  Mov,  Estatus,      Sucursal,  SucursalOrigen, FechaEmision,  FechaContable, UEN,  Moneda,  TipoCambio, AfectarPresupuesto)
VALUES (@Empresa, @Usuario, @Mov, 'SINAFECTAR', @Sucursal, @Sucursal,      @FechaTrabajo, @FechaTrabajo, @UEN, @Moneda, 1.0,        @AfectarPresupuesto)
SELECT @ID = SCOPE_IDENTITY()
SELECT @Renglon = 0.0
DECLARE crPresupuesto CURSOR LOCAL FOR
SELECT Cuenta, SubCuenta, Periodo, SUM(Disponible)
FROM #Presupuesto
GROUP BY Cuenta, SubCuenta, Periodo
ORDER BY Cuenta, SubCuenta, Periodo
OPEN crPresupuesto
FETCH NEXT FROM crPresupuesto INTO @Cuenta, @SubCuenta, @PresupuestoPeriodo, @Importe
WHILE @@FETCH_STATUS <> -1 AND @Ok IS NULL
BEGIN
IF @@FETCH_STATUS <> -2 AND NULLIF(@Importe, 0.0) IS NOT NULL
BEGIN
SELECT @Renglon = @Renglon + 2048.0
INSERT ContD (
ID,  Empresa,  Renglon,  RenglonSub, Sucursal,  Cuenta,  SubCuenta,  Haber,    Ejercicio,  Periodo,             SucursalContable)
SELECT @ID, @Empresa, @Renglon, 0,          @Sucursal, @Cuenta, @SubCuenta, @Importe, @Ejercicio, @PresupuestoPeriodo, @Sucursal
INSERT ContD (
ID,  Empresa,  Renglon,  RenglonSub, Sucursal,  Cuenta,  SubCuenta,  Debe,     Ejercicio,  Periodo,  SucursalContable)
SELECT @ID, @Empresa, @Renglon, 0,          @Sucursal, @Cuenta, @SubCuenta, @Importe, @Ejercicio, @Periodo, @Sucursal
END
FETCH NEXT FROM crPresupuesto INTO @Cuenta, @SubCuenta, @PresupuestoPeriodo, @Importe
END
CLOSE crPresupuesto
DEALLOCATE crPresupuesto
IF EXISTS(SELECT * FROM ContD WHERE ID = @ID)
EXEC spAfectar 'CONT', @ID, @EnSilencio = 1, @Conexion = 1, @Ok = @Ok OUTPUT, @OkRef = @OkRef OUTPUT
END
FETCH NEXT FROM crUEN INTO @UEN
END
CLOSE crUEN
DEALLOCATE crUEN
RETURN
END

