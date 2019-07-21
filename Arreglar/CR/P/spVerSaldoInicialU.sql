SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spVerSaldoInicialU
@Empresa	char(5),
@Rama		char(5),
@Moneda		char(10),
@Cuenta		char(20),
@Grupo		char(10),
@FechaInicial	datetime,
@SubCuenta	varchar(50) = NULL,
@SubGrupo	varchar(20) = NULL

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
@Ok		  	int
SELECT @SubCuenta = NULLIF(RTRIM(@SubCuenta), ''), @Grupo = NULLIF(RTRIM(@Grupo), ''), @SubGrupo = NULLIF(RTRIM(@SubGrupo), '')
SELECT @SubCuenta = NULLIF(@SubCuenta, '0'),       @Grupo = NULLIF(@Grupo, '0'),       @SubGrupo = NULLIF(@SubGrupo, '0')
SELECT @EsMonetario  = EsMonetario,
@EsUnidades   = EsUnidades,
@EsResultados = EsResultados
FROM Rama
WHERE Rama = @Rama
EXEC spPeriodoEjercicio @Empresa, @Rama, @FechaInicial, @Periodo OUTPUT, @Ejercicio OUTPUT, @Ok OUTPUT
EXEC spSaldoInicial @Empresa, @Rama, @Moneda, @Grupo, @Cuenta, @SubCuenta, @FechaInicial, @EsMonetario, @EsUnidades, @EsResultados,
@CargoInicial OUTPUT, @AbonoInicial OUTPUT, @CargoInicialU OUTPUT, @AbonoInicialU OUTPUT,
@Ok OUTPUT, @SubGrupoBase = @SubGrupo
SELECT "SaldoInicial" = CONVERT(float, ISNULL(@CargoInicialU, 0.0) - ISNULL(@AbonoInicialU, 0.0))
END

