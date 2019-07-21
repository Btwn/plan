SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spVerAuxiliar
@Empresa  char(5),
@Estacion  int,
@Rama  char(5),
@Moneda  char(10),
@GrupoBase  char(10)  = NULL,
@CuentaBase  char(20)  = NULL,
@FechaD  datetime  = NULL,
@FechaA  datetime  = NULL,
@Nivel  char(20)  = 'DIA',      
@Vista  char(20)  = 'NORMAL',   
@VerGrupo  bit   = 0,  
@Totalizar  bit   = 0

AS BEGIN
DECLARE
@EsMonetario bit,
@EsUnidades bit,
@EsResultados bit,
@DelEjercicio  int,
@AlEjercicio  int,
@DelPeriodo    int,
@AlPeriodo    int,
@CargoInicial  money,
@Cargos  money,
@AbonoInicial  money,
@Abonos  money,
@Saldo  money,
@Total  money,
@CargoInicialU  float,
@CargosU  float,
@AbonoInicialU float,
@AbonosU  float,
@TotalU  float,
@Ok  int
SELECT @Nivel = UPPER(@Nivel), @Vista = UPPER(@Vista), @VerGrupo = ISNULL(@VerGrupo, 0),
@CuentaBase = NULLIF(RTRIM(@CuentaBase), ''), @GrupoBase = NULLIF(RTRIM(@GrupoBase), ''),
@FechaA = DATEADD(millisecond, -2, DATEADD(day, 1, @FechaA))
SELECT @EsMonetario  = EsMonetario,
@EsUnidades   = EsUnidades,
@EsResultados = EsResultados
FROM Rama
WHERE Rama = @Rama
DELETE VerAux WHERE Estacion = @Estacion
SELECT @CargoInicial  = 0, @AbonoInicial  = 0.0,
@CargoInicialU = 0, @AbonoInicialU = 0
EXEC spPeriodoEjercicio @Empresa, @Rama, @FechaD, @DelPeriodo OUTPUT, @DelEjercicio OUTPUT, @Ok OUTPUT
EXEC spPeriodoEjercicio @Empresa, @Rama, @FechaA, @AlPeriodo  OUTPUT, @AlEjercicio  OUTPUT, @Ok OUTPUT
IF @DelEjercicio <> @AlEjercicio SELECT @DelPeriodo = 0, @AlPeriodo = 9999
EXEC spSaldoInicial  @Empresa, @Rama, @Moneda, @GrupoBase, @CuentaBase, NULL, @FechaD, @EsMonetario, @EsUnidades, @EsResultados,
@CargoInicial OUTPUT, @AbonoInicial OUTPUT, @CargoInicialU OUTPUT, @AbonoInicialU OUTPUT, @Ok OUTPUT
IF @CargoInicial <> 0 OR @AbonoInicial <> 0
INSERT VerAux (Estacion, Fecha, Mov, Cargo, Abono, Saldo, CargoU, AbonoU)
VALUES (@Estacion, DATEADD(day, -1, @FechaD), 'Saldo Inicial', @CargoInicial, @AbonoInicial, (@CargoInicial-@AbonoInicial), @CargoInicialU, @AbonoInicialU)
IF @Rama = 'CONT'
EXEC spVerAuxCont @Empresa, @Estacion, @CuentaBase, @DelEjercicio, @AlEjercicio, @DelPeriodo, @AlPeriodo, @FechaD, @FechaA, @Nivel, @Moneda
ELSE
IF @Rama = 'CC'
EXEC spVerAuxCC @Empresa, @Estacion, @CuentaBase, @DelEjercicio, @AlEjercicio, @DelPeriodo, @AlPeriodo, @FechaD, @FechaA, @Nivel
IF @Rama = 'CC2'
EXEC spVerAuxCC2 @Empresa, @Estacion, @CuentaBase, @DelEjercicio, @AlEjercicio, @DelPeriodo, @AlPeriodo, @FechaD, @FechaA, @Nivel
IF @Rama = 'CC3'
EXEC spVerAuxCC3 @Empresa, @Estacion, @CuentaBase, @DelEjercicio, @AlEjercicio, @DelPeriodo, @AlPeriodo, @FechaD, @FechaA, @Nivel
IF @EsUnidades = 0 AND @EsResultados = 0
EXEC spVerAux @Empresa, @Estacion, @Rama, @Moneda, @GrupoBase, @CuentaBase, @DelEjercicio, @AlEjercicio, @DelPeriodo, @AlPeriodo, @FechaD, @FechaA, @Nivel
ELSE
IF @EsUnidades = 0 AND @EsResultados = 1
EXEC spVerAuxR @Empresa, @Estacion, @Rama, @Moneda, @GrupoBase, @CuentaBase, @DelEjercicio, @AlEjercicio, @DelPeriodo, @AlPeriodo, @FechaD, @FechaA, @Nivel
ELSE
IF @EsUnidades = 1 AND @EsResultados = 0
EXEC spVerAuxU @Empresa, @Estacion, @Rama, @Moneda, @GrupoBase, @CuentaBase, @DelEjercicio, @AlEjercicio, @DelPeriodo, @AlPeriodo, @FechaD, @FechaA, @Nivel
ELSE
IF @EsUnidades = 1 AND @EsResultados = 1
EXEC spVerAuxRU @Empresa, @Estacion, @Rama, @Moneda, @GrupoBase, @CuentaBase, @DelEjercicio, @AlEjercicio, @DelPeriodo, @AlPeriodo, @FechaD, @FechaA, @Nivel
IF @Nivel = 'APLICACION'
BEGIN
IF @Rama IN ('CXC','CXP')
BEGIN
IF @Rama = 'CXC'
UPDATE VerAux
SET VerAux.Saldo = CASE
WHEN VerAux.Abono IS NOT NULL THEN -Cxc.Saldo
ELSE Cxc.Saldo
END
FROM VerAux, Cxc
WHERE Cxc.ID = VerAux.ModuloID
AND Cxc.Estatus = 'PENDIENTE'
AND VerAux.Mov = VerAux.Aplica
AND VerAux.MovID = VerAux.AplicaID
ELSE
IF @Rama = 'CXP'
UPDATE VerAux
SET VerAux.Saldo = CASE
WHEN VerAux.Abono IS NOT NULL THEN -Cxp.Saldo
ELSE Cxp.Saldo
END
FROM VerAux, Cxp
WHERE Cxp.ID = VerAux.ModuloID
AND Cxp.Estatus = 'PENDIENTE'
AND VerAux.Mov = VerAux.Aplica
AND VerAux.MovID = VerAux.AplicaID
SELECT @Cargos  = SUM(Cargo),
@Abonos  = SUM(Abono),
@Saldo   = SUM(Saldo),
@CargosU = SUM(CargoU),
@AbonosU = SUM(AbonoU)
FROM VerAux
WHERE Estacion = @Estacion
END
SELECT ID,
Fecha,
Orden,
Estacion,
Grupo,
SubCuenta,
Ejercicio,
Periodo,
Modulo,
ModuloID,
Mov,
MovID,
(RTrim(Mov) + ' ' + RTrim(MovID)) as Movimiento,
Aplica,
AplicaID,
Concepto,
Referencia,
Cargo,
Abono,
Saldo,
Total,
CargoU,
AbonoU,
TotalU
FROM VerAux WHERE Estacion = @Estacion
UNION
SELECT "ID"  = NULL,
"Fecha" = @FechaA,
"Orden"      = 2147483647,
"Estacion" = @Estacion,
"Grupo" = NULL,
"SubCuenta" = NULL,
"Ejercicio" = NULL,
"Periodo" = 999,
"Modulo" = NULL,
"ModuloID" = NULL,
"Mov" = NULL,
"MovID" = NULL,
"Movimiento"=NULL,
"Aplica" = 'zz',
"AplicaID" = NULL,
"Concepto" = NULL,
"Referencia" = NULL,
"Cargo" = ISNULL(@Cargos, 0.0),
"Abono" = ISNULL(@Abonos, 0.0),
"Saldo" = ISNULL(@Cargos, 0.0) - ISNULL(@Abonos, 0.0),
"Total" = NULL,
"CargoU" = NULL,
"AbonoU" = NULL,
"TotalU" = NULL
ORDER BY Estacion, Aplica, AplicaID, Fecha, ModuloID
END ELSE
BEGIN
SELECT @Total  = 0.0, @Cargos  = 0.0, @Abonos  = 0.0,
@TotalU = 0,   @CargosU = 0.0, @AbonosU = 0.0
UPDATE VerAux
SET @Cargos  = @Cargos  + ISNULL(Cargo, 0.0),
@Abonos  = @Abonos  + ISNULL(Abono, 0.0),
@Total   = Total    = @Total  + ISNULL(Cargo, 0.0) - ISNULL(Abono, 0.0),
@CargosU = @CargosU + ISNULL(CargoU, 0.0),
@AbonosU = @AbonosU + ISNULL(AbonoU, 0.0),
@TotalU  = TotalU   = @TotalU + ISNULL(CargoU, 0.0) - ISNULL(AbonoU, 0.0)
WHERE Estacion = @Estacion
INSERT VerAux (Estacion, Orden, Periodo, Fecha, Cargo, Abono, Total, CargoU, AbonoU, TotalU) VALUES (@Estacion, 2147483647, 999, @FechaA, @Cargos, @Abonos, @Total, @CargosU, @AbonosU, @TotalU)
SELECT * FROM VerAux WHERE Estacion = @Estacion ORDER BY Estacion, Fecha, Orden, ID
END
RETURN
END

