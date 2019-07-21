SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spPeriodoEjercicio
@Empresa	char(5),
@Modulo	char(5),
@Fecha	datetime,
@Periodo	int		OUTPUT,
@Ejercicio	int		OUTPUT,
@Ok		int		OUTPUT

AS BEGIN
DECLARE
@CfgPeriodosEspeciales char(2)
IF @Modulo = 'CEFE' SET @Modulo = 'CXC'
IF @Modulo = 'PEFE' SET @Modulo = 'CXP'
SELECT @CfgPeriodosEspeciales = UPPER(PeriodosEspeciales) FROM EmpresaCfgModulo WHERE Empresa = @Empresa AND Modulo = @Modulo
IF @CfgPeriodosEspeciales = 'SI'
BEGIN
EXEC spExtraerFecha @Fecha OUTPUT
SELECT @Periodo = NULL, @Ejercicio = NULL
SELECT @Periodo = Periodo, @Ejercicio = Ejercicio
FROM EjercicioEspecial
WHERE Empresa = @Empresa AND Modulo = @Modulo AND @Fecha BETWEEN FechaD AND FechaA
IF @Periodo IS NULL OR @Ejercicio IS NULL SELECT @Ok = 70060 
END ELSE SELECT @Periodo = DATEPART(month, @Fecha), @Ejercicio = DATEPART(year, @Fecha)
END

