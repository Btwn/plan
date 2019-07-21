SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spVerPresupuesto
@Empresa		char(5),
@Rama		char(5),
@Cuenta		char(20),
@SubCuenta		varchar(50),
@Moneda		char(10),
@Ejercicio		int,
@Periodo		int,
@PeriodoDe		int,
@PeriodoA		int,
@SaldoActual	bit,
@Acumulado		bit,
@Presupuesto	money	OUTPUT

AS BEGIN
DECLARE
@Del	int,
@Al		int
SELECT @Presupuesto = 0.0
IF @SaldoActual = 1
SELECT @Del = 1, @Al = @Periodo
ELSE
BEGIN
SELECT @Al = @PeriodoA
IF @Acumulado = 1 SELECT @Del = 1 ELSE SELECT @Del = @PeriodoDe
END
IF @SubCuenta IS NULL
SELECT @Presupuesto = ISNULL(SUM(Presupuesto), 0.0)
FROM Presupuesto
WHERE Empresa   = @Empresa
AND Rama      = @Rama
AND Cuenta    = @Cuenta
AND Ejercicio = @Ejercicio
AND Periodo BETWEEN @Del AND @Al AND Moneda = @Moneda
ELSE
SELECT @Presupuesto = ISNULL(SUM(Presupuesto), 0.0)
FROM Presupuesto
WHERE Empresa   = @Empresa
AND Rama      = @Rama
AND Cuenta    = @Cuenta
AND ISNULL(SubCuenta, '') = ISNULL(@SubCuenta, '')
AND Ejercicio = @Ejercicio
AND Periodo BETWEEN @Del AND @Al AND Moneda = @Moneda
RETURN
END

