SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spRecorrerVencimiento
@DiaSemana		varchar(20),
@Vencimiento	datetime	OUTPUT

AS BEGIN
SET DATEFIRST 7
DECLARE
@Dia		int,
@DiaEspecifico	int,
@DiasMes		int,
@Mes		int,
@Ano		int,
@DiaVence		int
SELECT @Dia = 0
SELECT @DiaSemana = RTRIM(UPPER(@DiaSemana))
IF @DiaSemana = '(ESPECIAL)'
EXEC xpRecorrerVencimiento @Vencimiento OUTPUT
ELSE
IF @DiaSemana IN ('QUINCENA', 'FIN DE MES') OR dbo.fnEsNumerico(@DiaSemana) = 1
BEGIN
SELECT @Ano = YEAR(@Vencimiento),
@Mes = MONTH(@Vencimiento),
@Dia = DAY(@Vencimiento)
EXEC spDiasMes @Mes, @Ano, @DiasMes OUTPUT
IF dbo.fnEsNumerico(@DiaSemana) = 1
BEGIN
SELECT @DiaEspecifico = CONVERT(int, @DiaSemana)
IF @Dia > @DiaEspecifico
BEGIN
SELECT @Mes = @Mes + 1
IF @Mes > 12 SELECT @Mes = 1, @Ano = @Ano + 1
END
SELECT @Dia = @DiaEspecifico
IF @Dia > @DiasMes SELECT @Dia = @DiasMes
END ELSE
BEGIN
IF @DiaSemana = 'QUINCENA' AND @Dia <= 15
SELECT @Dia = 15
ELSE SELECT @Dia = @DiasMes
END
EXEC spIntToDateTime @Dia, @Mes, @Ano, @Vencimiento OUTPUT
END ELSE
BEGIN
IF @DiaSemana = 'DOMINGO'   SELECT @Dia = 1 ELSE
IF @DiaSemana = 'LUNES'     SELECT @Dia = 2 ELSE
IF @DiaSemana = 'MARTES'    SELECT @Dia = 3 ELSE
IF @DiaSemana = 'MIERCOLES' SELECT @Dia = 4 ELSE
IF @DiaSemana = 'JUEVES'    SELECT @Dia = 5 ELSE
IF @DiaSemana = 'VIERNES'   SELECT @Dia = 6 ELSE
IF @DiaSemana = 'SABADO'    SELECT @Dia = 7
ELSE RETURN
SELECT @DiaVence = DATEPART(weekday, @Vencimiento)
IF @Dia > 0 AND @Dia <> @DiaVence
BEGIN
IF @DiaVence < @Dia
SELECT @Vencimiento = DATEADD(day, @Dia - @DiaVence, @Vencimiento)
ELSE
SELECT @Vencimiento = DATEADD(day, 7 - @DiaVence + @Dia, @Vencimiento)
END
END
RETURN
END

