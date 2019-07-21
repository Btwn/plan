SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spNominaFactorIntegracion
@Empresa	char(5),
@Sucursal	int,
@Categoria	varchar(50),
@Puesto		varchar(50),
@Personal	char(10),
@AnosCumplidos	int,
@Factor		float OUTPUT

AS BEGIN
DECLARE
@Numero		int,
@TablaVacaciones	varchar(50),
@Valor		varchar(50),
@DiasVacacionesIMSS	int,
@PrimaVacacional	float,
@DiasAguinaldo	float,
@DiasAno		float
SELECT @PrimaVacacional = NULL, @DiasAguinaldo = NULL, @DiasAno = NULL, @Factor = NULL
SELECT @TablaVacaciones = TablaVacaciones FROM EmpresaCfg WHERE Empresa = @Empresa
/* IF ((@AnosCumplidos+1) < 5)
SELECT @DiasVacacionesIMSS = 6 + ((@AnosCumplidos)*2)
ELSE
SELECT @DiasVacacionesIMSS = 10 + (CONVERT(int, (@AnosCumplidos+1)/5)*2)
*/
SELECT @Numero = @AnosCumplidos
IF NOT EXISTS(SELECT * FROM TablaNumD WHERE TablaNum = @TablaVacaciones AND Numero = @Numero)
SELECT @Numero = MAX(Numero) FROM TablaNumD WHERE TablaNum = @TablaVacaciones
SELECT @DiasVacacionesIMSS = ISNULL(Valor,0)
FROM TablaNumD
WHERE TablaNum = @TablaVacaciones AND Numero = @Numero
EXEC spPersonalPropValor @Empresa, @Sucursal, @Categoria, @Puesto, @Personal, '% Prima Vacacional', @Valor OUTPUT
IF (SELECT dbo.fnEsNumerico(@Valor)) = 1
SELECT @PrimaVacacional = CONVERT(float, @Valor)
ELSE  SELECT @PrimaVacacional = Valor FROM TablaNumD WHERE TablaNum=@Valor AND Numero = @AnosCumplidos
EXEC spPersonalPropValor @Empresa, @Sucursal, @Categoria, @Puesto, @Personal, '# Dias Aguinaldo', @Valor OUTPUT
IF (SELECT dbo.fnEsNumerico(@Valor)) = 1
SELECT @DiasAguinaldo = CONVERT(float, @Valor)
ELSE
SELECT @DiasAguinaldo = Valor FROM TablaNumD WHERE TablaNum=@Valor AND Numero = @AnosCumplidos
EXEC spPersonalPropValor @Empresa, @Sucursal, @Categoria, @Puesto, @Personal, '# Dias Ano', @Valor OUTPUT
SELECT @DiasAno = CONVERT(float, @Valor)
SELECT @Factor = ((((@DiasVacacionesIMSS * @PrimaVacacional / 100) + @DiasAguinaldo) / @DiasAno) + 1)
RETURN
END

