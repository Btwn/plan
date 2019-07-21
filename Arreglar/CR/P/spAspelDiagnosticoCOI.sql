SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE [dbo].[spAspelDiagnosticoCOI]

AS
DECLARE
@Cuenta		varchar(30),
@SaldoC		money,
@SaldoD		money,
@Temporal	money,
@Periodo	varchar(10),
@flag		bit,
@Registros	int,
@Digitos	int,
@Formato	varchar(24),
@Errorcoi6				varchar(100)
BEGIN
Create TABLE listaerrorcoi
(
Consecutivo int identity,
Error INT,
Registro varchar(100)
constraint PkListaerrorcoi Primary key  (Consecutivo)
)
CREATE TABLE #Diferencias
(
Cuenta	varchar(30),
Periodo	varchar(10),
SaldoC	decimal(20,7),
SaldoD	decimal(20,7)
)
SELECT @Formato = Valor FROM AspelCfgOpcion WHERE Descripcion = 'Formato Cuentas Contables'
SET @Digitos = LEN(REPLACE(REPLACE(RTRIM(LTRIM(@Formato)),'-',''),';2',''))
SET @Digitos = CASE WHEN @Digitos = 0 THEN 20 ELSE @Digitos END
DECLARE cur_Cuentas CURSOR FOR
SELECT dbo.fnAspelFormateaCuentas(LEFT(PASO_CTAS.Cuenta,@Digitos),@Formato), PASO_CTAS.periodo, PASO_CTAS.SaldoIni AS Cabecero,
SUM(PASO_CTASD.SaldoIni) AS Detalle
FROM PASO_CTAS INNER JOIN
PASO_CTASD ON PASO_CTAS.Cuenta = PASO_CTASD.Cuenta
WHERE PASO_CTAS.DEPTSINO = 'S'
GROUP BY PASO_CTAS.Cuenta, PASO_CTAS.periodo, PASO_CTAS.SaldoIni
OPEN cur_Cuentas
FETCH NEXT FROM cur_Cuentas INTO @Cuenta, @Periodo, @SaldoC, @SaldoD
WHILE @@FETCH_STATUS <> -1
BEGIN
IF @SaldoC <> @SaldoD
INSERT INTO #Diferencias(Cuenta, Periodo, SaldoC, SaldoD)
VALUES(@Cuenta, @Periodo, @SaldoC, @SaldoD)
FETCH NEXT FROM cur_Cuentas INTO @Cuenta, @Periodo, @SaldoC, @SaldoD
END
CLOSE cur_Cuentas
DEALLOCATE cur_Cuentas
SELECT @Registros = COUNT(*) FROM #Diferencias
INSERT INTO listaerrorcoi
SELECT 6, cuenta+ '|' + Periodo + '|' +Convert(varchar(25),SaldoC) + '|' +Convert(Varchar(25),SaldoD)
FROM #Diferencias
UPDATE AspelFlujo
SET	Estatus = 1
WHERE Proceso = 'Diagnostico Previo'
end

