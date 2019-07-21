SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spContExplotarPresupuesto
@ID                		int,
@Empresa			char(5),
@Sucursal			int,
@SucursalOrigen		int,
@SucursalContable		int,
@UEN				int,
@Moneda			char(10),
@FechaContable		datetime,
@Ejercicio			int,
@TipoPresupuesto		varchar(50),
@AfectarPresupuesto		varchar(30),
@Ok                		int          OUTPUT,
@OkRef             		varchar(255) OUTPUT

AS BEGIN
DECLARE
@Renglon	float,
@Cuenta	varchar(20),
@SubCuenta	varchar(50),
@SubCuenta2	varchar(50),
@SubCuenta3	varchar(50),
@Concepto	varchar(50),
@Debe	money,
@Haber	money,
@Positivo	money,
@Negativo	money,
@PeriodoD	int
DECLARE crContDPresupuesto CURSOR FOR
SELECT Renglon, NULLIF(RTRIM(Cuenta), ''), NULLIF(RTRIM(d.SubCuenta), ''), Concepto, ISNULL(Debe, 0.0), ISNULL(Haber, 0.0), NULLIF(Periodo, 0), NULLIF(RTRIM(d.SubCuenta2), ''), NULLIF(RTRIM(d.SubCuenta3), ''), SucursalContable 
FROM ContD d
WHERE ID = @ID AND Presupuesto = 1 AND RenglonSub = 0
OPEN crContDPresupuesto
FETCH NEXT FROM crContDPresupuesto INTO @Renglon, @Cuenta, @SubCuenta, @Concepto, @Debe, @Haber, @PeriodoD, @SubCuenta2, @SubCuenta3, @SucursalContable 
WHILE @@FETCH_STATUS <> -1 AND @Ok IS NULL
BEGIN
SELECT @Positivo = 0.0, @Negativo = 0.0
IF @Debe  > 0.0 SELECT @Positivo = @Debe   ELSE
IF @Debe  < 0.0 SELECT @Negativo = -@Debe  ELSE
IF @Haber < 0.0 SELECT @Positivo = -@Haber ELSE
IF @Haber > 0.0 SELECT @Negativo = @Haber
IF @@FETCH_STATUS <> -2 AND @Cuenta IS NOT NULL AND (@Positivo>0.0 OR @Negativo>0.0) AND @Ok IS NULL
BEGIN
DELETE ContD WHERE CURRENT OF crContDPresupuesto
IF @Positivo > 0.0
INSERT ContD (
ID,  Renglon,  RenglonSub, Cuenta,  SubCuenta,  SubCuenta2,  SubCuenta3, Concepto,  Debe,    Empresa,  Ejercicio,  Periodo, FechaContable,  Sucursal,  Presupuesto, SucursalContable,  SucursalOrigen)
SELECT @ID, @Renglon, Periodo,    @Cuenta, @SubCuenta, @SubCuenta2, @SubCuenta3, @Concepto, Importe, @Empresa, @Ejercicio, Periodo, @FechaContable, @Sucursal, 1,           @SucursalContable, @SucursalOrigen
FROM dbo.fnDistribuirPresupuesto (@Empresa, @SucursalContable, @UEN, 'CONT', @Moneda, @TipoPresupuesto, @Cuenta, @SubCuenta, @Ejercicio, @PeriodoD, @AfectarPresupuesto, 1, @Positivo)
IF @Negativo > 0.0
INSERT ContD (
ID,  Renglon,  RenglonSub, Cuenta,  SubCuenta,  SubCuenta2,  SubCuenta3, Concepto,  Haber,   Empresa,  Ejercicio,  Periodo, FechaContable,  Sucursal,  Presupuesto, SucursalContable,  SucursalOrigen)
SELECT @ID, @Renglon, Periodo,    @Cuenta, @SubCuenta, @SubCuenta2, @SubCuenta3, @Concepto, Importe, @Empresa, @Ejercicio, Periodo, @FechaContable, @Sucursal, 1,           @SucursalContable, @SucursalOrigen
FROM dbo.fnDistribuirPresupuesto (@Empresa, @SucursalContable, @UEN, 'CONT', @Moneda, @TipoPresupuesto, @Cuenta, @SubCuenta, @Ejercicio, @PeriodoD, @AfectarPresupuesto, 0, @Negativo)
END
FETCH NEXT FROM crContDPresupuesto INTO @Renglon, @Cuenta, @SubCuenta, @Concepto, @Debe, @Haber, @PeriodoD, @SubCuenta2, @SubCuenta3, @SucursalContable 
END  
CLOSE crContDPresupuesto
DEALLOCATE crContDPresupuesto
RETURN
END

