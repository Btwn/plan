SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spGastoConcluirPresupuestos
@Empresa	char(5)

AS BEGIN
DECLARE
@ID			int,
@Concepto		varchar(50),
@Moneda		varchar(10),
@FechaEmision	datetime,
@FechaRequerida	datetime,
@ContUso		varchar(20),
@ContUso2		varchar(20),
@ContUso3		varchar(20),
@Importe		money,
@GastoEjercido	money,
@GastoPendiente	money,
@TienePendientes	bit
IF (SELECT ISNULL(GastoPresupuestoPendiente, 0) FROM EmpresaCfg2 WHERE Empresa = @Empresa) = 0 RETURN
DECLARE crGasto CURSOR LOCAL FOR
SELECT e.ID, e.Moneda, e.FechaEmision, e.FechaRequerida
FROM Gasto e
JOIN MovTipo mt ON mt.Modulo = 'GAS' AND mt.Mov = e.Mov AND mt.Clave = 'GAS.PR'
WHERE e.Empresa = @Empresa AND e.Estatus = 'PENDIENTE'
OPEN crGasto
FETCH NEXT FROM crGasto INTO @ID, @Moneda, @FechaEmision, @FechaRequerida
WHILE @@FETCH_STATUS <> -1
BEGIN
IF @@FETCH_STATUS <> -2
BEGIN
SELECT @TienePendientes = 0
DECLARE crGastoD CURSOR LOCAL FOR
SELECT d.Concepto, d.Importe, d.ContUso, d.ContUso2, d.ContUso3
FROM GastoD d
WHERE d.ID = @ID
OPEN crGastoD
FETCH NEXT FROM crGastoD INTO @Concepto, @Importe, @ContUso, @ContUso2, @ContUso3
WHILE @@FETCH_STATUS <> -1 AND @TienePendientes = 0
BEGIN
IF @@FETCH_STATUS <> -2
BEGIN
EXEC spVerGastoPendiente @Empresa, @FechaEmision, @FechaRequerida, @Concepto, @Moneda, @ContUso, @EnSilencio = 1, @GastoPendiente = @GastoPendiente OUTPUT, @ContUso2 = @ContUso2, @ContUso3 = @ContUso3
IF @GastoPendiente = 0.0
BEGIN
EXEC spVerGastoEjercido  @Empresa, @FechaEmision, @FechaRequerida, @Concepto, @Moneda, @ContUso, @EnSilencio = 1, @GastoEjercido = @GastoEjercido OUTPUT, @ContUso2 = @ContUso2, @ContUso3 = @ContUso3
IF @GastoEjercido < @Importe
SELECT @TienePendientes = 1
END ELSE
SELECT @TienePendientes = 1
END
FETCH NEXT FROM crGastoD INTO @Concepto, @Importe, @ContUso, @ContUso2, @ContUso3
END
CLOSE crGastoD
DEALLOCATE crGastoD
END
FETCH NEXT FROM crGasto INTO @ID, @Moneda, @FechaEmision, @FechaRequerida
END
CLOSE crGasto
DEALLOCATE crGasto
RETURN
END

