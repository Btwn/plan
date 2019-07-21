SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spContPolizaCierre
@Estacion		int,
@Empresa		char(5),
@MovCierre		char(20),
@Moneda		char(10),
@CtaResultados	char(20),
@Usuario		char(10),
@FechaTrabajo	datetime

AS BEGIN
DECLARE
@Sucursal		int,
@ID			int,
@Renglon		float,
@TipoCambio		float,
@Cuenta		char(20),
@CuentaCierre	char(20),
@Rama  		char(20),
@EsAcreedora	bit,
@Periodo 		int,
@Ejercicio		int,
@EjercicioInicio	datetime,
@EjercicioFinal 	datetime,
@Ok			int,
@Importe		money
SELECT @Ok = NULL
SELECT @EjercicioInicio = EjercicioInicio, @EjercicioFinal = EjercicioFinal
FROM EmpresaGral
WHERE Empresa = @Empresa
SELECT @CuentaCierre = NULLIF(RTRIM(ContCuentaCierre), '') FROM EmpresaCfg WHERE Empresa = @Empresa
EXEC spPeriodoEjercicio @Empresa, 'CONT', @FechaTrabajo, @Periodo OUTPUT, @Ejercicio OUTPUT, @Ok OUTPUT
DELETE VerContListaCta  WHERE Estacion = @Estacion
DELETE VerContListaRama WHERE Estacion = @Estacion
INSERT VerContListaRama (Estacion, Cuenta) VALUES (@Estacion, @CtaResultados)
SELECT @Sucursal = Sucursal FROM UsuarioSucursal WHERE Usuario = @Usuario
DECLARE crRecorrerRama CURSOR FOR
SELECT Cuenta
FROM VerContListaRama
WHERE Estacion = @Estacion
OPEN crRecorrerRama
FETCH NEXT FROM crRecorrerRama INTO @Rama
WHILE @@FETCH_STATUS <> -1
BEGIN
IF @@FETCH_STATUS <> -2
EXEC spContRecorrerRama @Estacion, @Rama
FETCH NEXT FROM crRecorrerRama INTO @Rama
END
CLOSE crRecorrerRama
DEALLOCATE crRecorrerRama
BEGIN TRANSACTION
EXEC spExtraerFecha @FechaTrabajo OUTPUT
SELECT @TipoCambio = TipoCambio FROM Mon WHERE Moneda = @Moneda
INSERT Cont (Sucursal, Empresa,  Mov,        FechaEmision,  FechaContable, Moneda, TipoCambio,   Usuario,  Estatus)
VALUES (@Sucursal, @Empresa, @MovCierre, @FechaTrabajo, @FechaTrabajo, @Moneda, @TipoCambio, @Usuario, 'SINAFECTAR')
SELECT @ID = SCOPE_IDENTITY()
SELECT @Renglon = 0
DECLARE crListaCta CURSOR FOR
SELECT l.Cuenta, c.EsAcreedora
FROM VerContListaCta l, Cta c
WHERE l.Estacion = @Estacion
AND l.Cuenta = c.Cuenta
OPEN crListaCta
FETCH NEXT FROM crListaCta INTO @Cuenta, @EsAcreedora
WHILE @@FETCH_STATUS <> -1
BEGIN
IF @@FETCH_STATUS <> -2
EXEC spContPolizaDCierre @Sucursal, @ID, @Empresa, @Moneda, @Cuenta, @EsAcreedora, @Ejercicio, /*@EjercicioInicio, @EjercicioFinal, */@Renglon OUTPUT
FETCH NEXT FROM crListaCta INTO @Cuenta, @EsAcreedora
END
CLOSE crListaCta
DEALLOCATE crListaCta
IF @CuentaCierre IS NOT NULL
BEGIN
SELECT @EsAcreedora = EsAcreedora FROM Cta WHERE Cuenta = @CuentaCierre
EXEC spContPolizaCuentaCierre @Sucursal, @ID, @Empresa, @Moneda, @CuentaCierre, @EsAcreedora, @Ejercicio, @Renglon OUTPUT
END
COMMIT TRANSACTION
SELECT "Se Creo el Movimiento: "+RTRIM(@MovCierre)
RETURN
END

