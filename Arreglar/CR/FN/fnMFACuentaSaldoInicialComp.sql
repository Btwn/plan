SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER FUNCTION fnMFACuentaSaldoInicialComp (@Empresa varchar(5), @Ejercicio int, @Periodo int, @Cuenta varchar(20), @Moneda varchar(10), @Campo varchar(10))
RETURNS float

AS BEGIN
DECLARE
@Resultado					float,
@Resultado2					float,
@IFRS							bit,
@IncluirCuentasEspecificas	bit
SELECT @IFRS = ISNULL(IFRS, 0), @IncluirCuentasEspecificas = ISNULL(IncluirCuentasEspecificas, 0) FROM EmpresaMFA WHERE Empresa = @Empresa
IF @Campo = ''
SELECT @Periodo = 1
SET @Resultado2 = NULL
IF @IncluirCuentasEspecificas = 1
SELECT
@Resultado = CASE ISNULL(@Campo, '')
WHEN ''		THEN CASE ISNULL(C.Cuenta, '')  WHEN '' THEN ISNULL(SUM(ISNULL(Saldo,0.0)),0.0)  ELSE ISNULL(SUM(ISNULL(Saldo,0.0)),0.0) *-1 END 
WHEN 'Cargos'	THEN CASE ISNULL(C.Cuenta, '')  WHEN '' THEN ISNULL(SUM(ISNULL(Cargos,0.0)),0.0) ELSE ISNULL(SUM(ISNULL(Cargos,0.0)),0.0) *-1 END 
WHEN 'Abonos'	THEN CASE ISNULL(C.Cuenta, '')  WHEN '' THEN ISNULL(SUM(ISNULL(Abonos,0.0)),0.0) ELSE ISNULL(SUM(ISNULL(Abonos,0.0)),0.0) *-1 END 
END
FROM MFACtaSaldoEjercicioComp
LEFT OUTER JOIN MFACuentasEspeciales C ON C.Cuenta=MFACtaSaldoEjercicioComp.Cuenta 
WHERE MFACtaSaldoEjercicioComp.Empresa = @Empresa
AND MFACtaSaldoEjercicioComp.Ejercicio = @Ejercicio
AND MFACtaSaldoEjercicioComp.Periodo BETWEEN 0 AND @Periodo-1
AND MFACtaSaldoEjercicioComp.Cuenta = @Cuenta
AND MFACtaSaldoEjercicioComp.Moneda = @Moneda
GROUP BY ISNULL(C.Cuenta, '')
ELSE
BEGIN
SELECT
@Resultado = CASE ISNULL(@Campo, '')
WHEN ''		THEN ISNULL(SUM(ISNULL(Saldo,0.0)),0.0)
WHEN 'Cargos'	THEN ISNULL(SUM(ISNULL(Cargos,0.0)),0.0)
WHEN 'Abonos'	THEN ISNULL(SUM(ISNULL(Abonos,0.0)),0.0)
END
FROM MFACtaSaldoEjercicioComp
WHERE Empresa = @Empresa
AND Ejercicio = @Ejercicio
AND Periodo BETWEEN 0 AND @Periodo - 1
AND Cuenta = @Cuenta
AND Moneda = @Moneda
END
IF @Resultado = 0 AND @Resultado2 <> 0
SET @Resultado = @Resultado2
RETURN ISNULL(@Resultado, 0)
END

