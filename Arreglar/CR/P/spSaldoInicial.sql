SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spSaldoInicial
@Empresa	char(5),
@Rama		char(5),
@MonedaBase	char(10),
@GrupoBase	char(10),
@CuentaBase	char(20),
@SubCuentaBase	varchar(50),
@FechaInicial	datetime,
@EsMonetario	bit,
@EsUnidades	bit,
@EsResultados	bit,
@CargoInicial 	money	OUTPUT,
@AbonoInicial 	money	OUTPUT,
@CargoInicialU 	float	OUTPUT,
@AbonoInicialU 	float	OUTPUT,
@Ok		int	OUTPUT,
@SubGrupoBase	varchar(20)	= NULL

AS BEGIN
DECLARE
@Ejercicio		  	int,
@Periodo		  	int,
@RamaAdicional  	  	char(5),
@CargoInicialAdicional 	money,
@AbonoInicialAdicional 	money
EXEC spExtraerFecha @FechaInicial OUTPUT
SELECT @CargoInicial  = 0.0, @AbonoInicial  = 0.0,
@CargoInicialU = 0.0, @AbonoInicialU = 0.0
IF @Rama='CONT'
BEGIN
EXEC spPeriodoEjercicio @Empresa, @Rama, @FechaInicial, @Periodo OUTPUT, @Ejercicio OUTPUT, @Ok OUTPUT
EXEC spSaldoInicialCont @Empresa, @CuentaBase, @Ejercicio, @Periodo, @FechaInicial, @CargoInicial OUTPUT, @AbonoInicial OUTPUT, @Ok OUTPUT, @Moneda = @MonedaBase
END ELSE
IF @EsMonetario = 1 AND @EsUnidades = 0
BEGIN
EXEC spSaldoInicialM @Empresa, @Rama, @MonedaBase, @GrupoBase, @CuentaBase, @SubCuentaBase, @EsResultados, @FechaInicial,
@CargoInicial OUTPUT, @AbonoInicial OUTPUT, @Ok OUTPUT
IF @Rama IN ('CXC', 'CXP') AND @Ok IS NULL
BEGIN
SELECT @CargoInicialAdicional = 0.0, @AbonoInicialAdicional = 0.0
IF @Rama = 'CXC' SELECT @RamaAdicional = 'CEFE' ELSE SELECT @RamaAdicional = 'PEFE'
EXEC spSaldoInicialM @Empresa, @RamaAdicional, @MonedaBase, @GrupoBase, @CuentaBase, @SubCuentaBase, @EsResultados, @FechaInicial,
@CargoInicialAdicional OUTPUT, @AbonoInicialAdicional OUTPUT, @Ok OUTPUT
SELECT @CargoInicial = @CargoInicial + @CargoInicialAdicional,
@AbonoInicial = @AbonoInicial + @AbonoInicialAdicional
IF @Rama = 'CXC' SELECT @RamaAdicional = 'CRND' ELSE SELECT @RamaAdicional = 'PRND'
EXEC spSaldoInicialM @Empresa, @RamaAdicional, @MonedaBase, @GrupoBase, @CuentaBase, @SubCuentaBase, @EsResultados, @FechaInicial,
@CargoInicialAdicional OUTPUT, @AbonoInicialAdicional OUTPUT, @Ok OUTPUT
SELECT @CargoInicial = @CargoInicial + @CargoInicialAdicional,
@AbonoInicial = @AbonoInicial + @AbonoInicialAdicional
IF @Rama = 'CXC'
BEGIN
SELECT @CargoInicialAdicional = 0.0, @AbonoInicialAdicional = 0.0
EXEC spSaldoInicialM @Empresa, 'CVALE', @MonedaBase, @GrupoBase, @CuentaBase, @SubCuentaBase, @EsResultados, @FechaInicial,
@CargoInicialAdicional OUTPUT, @AbonoInicialAdicional OUTPUT, @Ok OUTPUT
SELECT @CargoInicial = @CargoInicial + @CargoInicialAdicional,
@AbonoInicial = @AbonoInicial + @AbonoInicialAdicional
EXEC spSaldoInicialM @Empresa, 'CNO', @MonedaBase, @GrupoBase, @CuentaBase, @SubCuentaBase, @EsResultados, @FechaInicial,
@CargoInicialAdicional OUTPUT, @AbonoInicialAdicional OUTPUT, @Ok OUTPUT
SELECT @CargoInicial = @CargoInicial + @CargoInicialAdicional,
@AbonoInicial = @AbonoInicial + @AbonoInicialAdicional
END
END
END ELSE
EXEC spSaldoInicialU @Empresa, @Rama, @MonedaBase, @GrupoBase, @CuentaBase, @SubCuentaBase, @EsResultados, @FechaInicial,
@CargoInicial OUTPUT, @AbonoInicial OUTPUT, @CargoInicialU OUTPUT, @AbonoInicialU OUTPUT, @Ok OUTPUT, @SubGrupoBase = @SubGrupoBase
RETURN
END

