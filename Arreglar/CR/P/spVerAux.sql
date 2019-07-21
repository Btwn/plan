SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spVerAux
@Empresa		char(5),
@Estacion		int,
@Rama		char(5),
@Moneda		char(10),
@Grupo		char(10),
@Cuenta		char(20),
@DelEjercicio	int,
@AlEjercicio	int,
@DelPeriodo		int,
@AlPeriodo		int,
@FechaD		datetime,
@FechaA		datetime,
@Nivel		char(20)

AS BEGIN
IF @Rama IN ('CEFE','PEFE','CVALE','CRND','PRND','CNO')
IF @Nivel = 'DIA'
INSERT VerAux (Estacion, Ejercicio, Periodo, Fecha, Cargo, Abono)
SELECT @Estacion, Ejercicio, Periodo, Fecha, Sum(Cargo), Sum(Abono)
FROM Auxiliar
WHERE Rama = @Rama
AND Empresa = @Empresa
AND Moneda = @Moneda
AND Grupo  = CASE @Grupo WHEN NULL THEN Grupo ELSE @Grupo END
AND Cuenta = @Cuenta
AND Ejercicio BETWEEN @DelEjercicio AND @AlEjercicio
AND Periodo BETWEEN @DelPeriodo AND @AlPeriodo
AND Fecha BETWEEN @FechaD AND @FechaA
GROUP BY Empresa, Ejercicio, Periodo, Fecha
HAVING Sum(Cargo) <> 0 OR Sum(Abono) <> 0
ORDER BY Empresa, Ejercicio, Periodo, Fecha
ELSE
INSERT VerAux (Estacion, Modulo, Orden, Ejercicio, Periodo, Fecha, ModuloID, Mov, MovID, Aplica, AplicaID, Concepto, Referencia,  Cargo, Abono)
SELECT @Estacion, a.Modulo, a.ModuloID, a.Ejercicio, a.Periodo, a.Fecha, a.ModuloID, a.Mov, a.MovID, a.Aplica, a.AplicaID, m.Concepto, m.Referencia, Sum(a.Cargo), Sum(a.Abono)
FROM Auxiliar a, Mov m
WHERE Rama = @Rama
AND a.Empresa = @Empresa
AND a.Moneda = @Moneda
AND a.Grupo  = CASE @Grupo WHEN NULL THEN Grupo  ELSE @Grupo END
AND a.Cuenta = @Cuenta
AND a.Ejercicio BETWEEN @DelEjercicio AND @AlEjercicio
AND a.Periodo BETWEEN @DelPeriodo AND @AlPeriodo
AND a.Fecha BETWEEN @FechaD AND @FechaA
AND m.Empresa = @Empresa
AND m.Modulo = a.Modulo
AND m.ID = a.ModuloID
GROUP BY a.Empresa, a.Ejercicio, a.Periodo, a.Fecha, a.Modulo, a.ModuloID, a.Mov, a.MovID, a.Aplica, a.AplicaID, m.Concepto, m.Referencia
HAVING Sum(Cargo) <> 0 OR Sum(Abono) <> 0
ORDER BY a.Empresa, a.Ejercicio, a.Periodo, a.Fecha, a.Modulo, a.ModuloID, a.Mov, a.MovID, a.Aplica, a.AplicaID, m.Concepto, m.Referencia
ELSE
IF @Nivel = 'DIA'
INSERT VerAux (Estacion, Ejercicio, Periodo, Fecha, Cargo, Abono)
SELECT @Estacion, Ejercicio, Periodo, Fecha, Sum(Cargo), Sum(Abono)
FROM Auxiliar, Rama
WHERE Auxiliar.Rama = Rama.Rama
AND Rama.Mayor = @Rama
AND Empresa = @Empresa
AND Moneda = @Moneda
AND Grupo  = CASE @Grupo  WHEN NULL THEN Grupo  ELSE @Grupo  END
AND Cuenta = @Cuenta
AND Ejercicio BETWEEN @DelEjercicio AND @AlEjercicio
AND Periodo BETWEEN @DelPeriodo AND @AlPeriodo
AND Fecha BETWEEN @FechaD AND @FechaA
GROUP BY Ejercicio, Periodo, Fecha
HAVING Sum(Cargo) <> 0 OR Sum(Abono) <> 0
ORDER BY Ejercicio, Periodo, Fecha
ELSE
IF @Nivel = 'MOVIMIENTO'
INSERT VerAux (Estacion, Modulo, Orden, Ejercicio, Periodo, Fecha, ModuloID, Mov, MovID, Aplica, AplicaID, Concepto, Referencia,  Cargo, Abono)
SELECT @Estacion, a.Modulo, MIN(a.ModuloID), a.Ejercicio, a.Periodo, a.Fecha, MIN(a.ModuloID), a.Mov, a.MovID, MIN(a.Aplica), MIN(a.AplicaID), MIN(m.Concepto), MIN(m.Referencia), Sum(a.Cargo), Sum(a.Abono)
FROM Auxiliar a, Rama r, Mov m
WHERE a.Rama = r.Rama
AND r.Mayor = @Rama
AND a.Empresa = @Empresa
AND a.Moneda = @Moneda
AND a.Grupo  = CASE @Grupo WHEN NULL THEN Grupo  ELSE @Grupo END
AND a.Cuenta = @Cuenta
AND a.Ejercicio BETWEEN @DelEjercicio AND @AlEjercicio
AND a.Periodo BETWEEN @DelPeriodo AND @AlPeriodo
AND a.Fecha BETWEEN @FechaD AND @FechaA
AND m.Empresa = @Empresa
AND m.Modulo = a.Modulo
AND m.ID = a.ModuloID
GROUP BY a.Empresa, a.Ejercicio, a.Periodo, a.Fecha, a.Modulo, a.Mov, a.MovID,a.ModuloID
HAVING Sum(Cargo) <> 0 OR Sum(Abono) <> 0
ORDER BY a.Empresa, a.Ejercicio, a.Periodo, a.Fecha, a.Modulo, a.Mov, a.MovID,a.ModuloID
ELSE
IF @Nivel = 'APLICACION'
INSERT VerAux (Estacion, Modulo, Ejercicio, Periodo, Fecha, ModuloID, Mov, MovID, Aplica, AplicaID, Concepto, Referencia,  Cargo, Abono, Saldo)
SELECT @Estacion, a.Modulo, a.Ejercicio, a.Periodo, a.Fecha, MIN(a.ModuloID), a.Mov, a.MovID, a.Aplica, a.AplicaID, MIN(m.Concepto), MIN(m.Referencia), Sum(a.Cargo), Sum(a.Abono), Sum(ISNULL(a.Cargo,0.0))-Sum(ISNULL(a.Abono,0.0))
FROM Auxiliar a, Rama r, Mov m
WHERE a.Rama = r.Rama
AND r.Mayor = @Rama
AND a.Empresa = @Empresa
AND a.Moneda = @Moneda
AND a.Grupo  = CASE @Grupo WHEN NULL THEN Grupo  ELSE @Grupo END
AND a.Cuenta = @Cuenta
AND a.Ejercicio BETWEEN @DelEjercicio AND @AlEjercicio
AND a.Periodo BETWEEN @DelPeriodo AND @AlPeriodo
AND a.Fecha BETWEEN @FechaD AND @FechaA
AND m.Empresa = @Empresa
AND m.Modulo = a.Modulo
AND m.ID = a.ModuloID
GROUP BY a.Empresa, a.Modulo, a.Aplica, a.AplicaID, a.Ejercicio, a.Periodo, a.Fecha, a.Mov, a.MovID
HAVING Sum(Cargo) <> 0 OR Sum(Abono) <> 0
ORDER BY a.Empresa, a.Modulo, a.Aplica, a.AplicaID, a.Ejercicio, a.Periodo, a.Fecha, a.Mov, a.MovID
END

