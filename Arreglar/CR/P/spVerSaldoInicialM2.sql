SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spVerSaldoInicialM2
@Empresa	char(5),
@Rama		char(5),
@Moneda		char(10),
@Cuenta		char(20),
@FechaInicial	datetime,
@SubCuenta	varchar(50) = NULL,
@Resultado      float = NULL OUTPUT

AS BEGIN
DECLARE
@Ejercicio	  	int,
@Periodo	  	int,
@EsMonetario	bit,
@EsUnidades		bit,
@EsResultados	bit,
@CargoInicial 	money,
@AbonoInicial 	money,
@CargoInicialU 	float,
@AbonoInicialU 	float,
@Ok		  	money
SELECT @SubCuenta = NULLIF(RTRIM(@SubCuenta), '')
SELECT @SubCuenta = NULLIF(@SubCuenta, '0')
SELECT @EsMonetario  = EsMonetario,
@EsUnidades   = EsUnidades,
@EsResultados = EsResultados
FROM Rama
WHERE Rama = @Rama
EXEC spPeriodoEjercicio @Empresa, @Rama, @FechaInicial, @Periodo OUTPUT, @Ejercicio OUTPUT, @Ok OUTPUT
EXEC spSaldoInicial @Empresa, @Rama, @Moneda, NULL, @Cuenta, @SubCuenta, @FechaInicial, @EsMonetario, @EsUnidades, @EsResultados,
@CargoInicial OUTPUT, @AbonoInicial OUTPUT, @CargoInicialU OUTPUT, @AbonoInicialU OUTPUT,
@Ok OUTPUT
SELECT @Resultado =  CONVERT(money, ISNULL(@CargoInicial, 0.0) - ISNULL(@AbonoInicial, 0.0))
END

