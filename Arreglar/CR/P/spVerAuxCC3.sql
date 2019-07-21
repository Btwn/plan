SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spVerAuxCC3
@Empresa		char(5),
@Estacion		int,
@Cuenta		char(20),
@DelEjercicio	int,
@AlEjercicio	int,
@DelPeriodo		int,
@AlPeriodo		int,
@FechaD		datetime,
@FechaA		datetime,
@Nivel		char(20)

AS BEGIN
IF @Nivel = 'DIA'
INSERT VerAux (Estacion, Ejercicio, Periodo, Fecha, Cargo, Abono)
SELECT @Estacion, d.Ejercicio, d.Periodo, d.FechaContable, Sum(d.Debe), Sum(d.Haber)
FROM Cont f, ContD d
WHERE f.ID = d.ID
AND f.Estatus = 'CONCLUIDO'
AND d.Empresa = @Empresa
AND d.Ejercicio BETWEEN @DelEjercicio AND @AlEjercicio
AND d.Periodo BETWEEN @DelPeriodo AND @AlPeriodo
AND d.FechaContable BETWEEN @FechaD AND @FechaA
AND d.SubCuenta3 = @Cuenta
AND d.Presupuesto = 0
GROUP BY d.Ejercicio, d.Periodo, d.FechaContable
ORDER BY d.Ejercicio, d.Periodo, d.FechaContable
ELSE
INSERT VerAux (Estacion, Modulo, Orden, SubCuenta, Ejercicio, Periodo, Fecha, ModuloID, Mov, MovID, Aplica, AplicaID, Concepto, Referencia,  Cargo, Abono)
SELECT @Estacion, 'CONT', d.ID, d.SubCuenta3, d.Ejercicio, d.Periodo, d.FechaContable, d.ID, f.Mov, f.MovID, f.Mov, f.MovID, f.Concepto, f.Referencia, d.Debe, d.Haber
FROM Cont f, ContD d
WHERE f.ID = d.ID
AND f.Estatus = 'CONCLUIDO'
AND d.Empresa = @Empresa
AND d.Ejercicio BETWEEN @DelEjercicio AND @AlEjercicio
AND d.Periodo BETWEEN @DelPeriodo AND @AlPeriodo
AND d.FechaContable BETWEEN @FechaD AND @FechaA
AND d.SubCuenta3 = @Cuenta
AND d.Presupuesto = 0
END

