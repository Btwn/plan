SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spPeriodoDA
@PeriodoTipo	varchar(50),
@Fecha		datetime,
@FechaD		datetime	OUTPUT,
@FechaA		datetime	OUTPUT,
@Empresa	varchar(5)	= NULL

AS BEGIN
DECLARE
@Dia		int,
@Mes		int,
@Ano		int,
@Dias		int,
@UltimoDiaPagado	datetime
SELECT @FechaD = NULL,
@FechaA = NULL,
@PeriodoTipo = UPPER(NULLIF(RTRIM(@PeriodoTipo), ''))
IF @Fecha IS NULL OR @PeriodoTipo IS NULL RETURN
SELECT @FechaD = @Fecha
IF @PeriodoTipo = 'SEMANAL'
BEGIN
SELECT @Dias=7
SELECT @FechaA = DATEADD(day, @Dias, @Fecha)
SELECT @UltimoDiaPagado = ISNULL(UltimoDiaPagado, @FechaD)
FROM PeriodoTipo
WHERE PeriodoTipo=@PeriodoTipo
SELECT @UltimoDiaPagado=DATEADD(day, @Dias+1, @UltimoDiaPagado)
IF @FechaA>@UltimoDiaPagado AND @FechaD<@UltimoDiaPagado
BEGIN
SELECT @FechaA=@UltimoDiaPagado
SELECT @Dias=DATEDIFF(day,@FechaA,@Fecha)
END
END ELSE
IF @PeriodoTipo = 'CATORCENAL' SELECT @FechaA = DATEADD(day, 14, @Fecha) ELSE
IF @PeriodoTipo = 'ANUAL'      SELECT @FechaA = DATEADD(year, 1, @Fecha)
ELSE
BEGIN
SELECT @Dia = DATEPART(day, @Fecha),
@Mes = DATEPART(month, @Fecha),
@Ano = DATEPART(year, @Fecha)
EXEC spDiasMes @Mes, @Ano, @Dias OUTPUT
IF @PeriodoTipo = 'MENSUAL'
BEGIN
IF @Dia = 1
EXEC spIntToDateTime @Dias, @Mes, @Ano, @FechaA OUTPUT
ELSE SELECT @FechaA = DATEADD(month, 1, @Fecha)
END
IF @PeriodoTipo IN ('DECENAL', 'QUINCENAL', 'QUINCENAL 5-20')
BEGIN
IF @PeriodoTipo = 'DECENAL'
BEGIN
IF @Dia BETWEEN  1 AND 10 SELECT @Dia = 1  ELSE
IF @Dia BETWEEN 11 AND 20 SELECT @Dia = 11
ELSE SELECT @Dia = 21
END ELSE
IF @PeriodoTipo = 'QUINCENAL'
BEGIN
IF @Dia BETWEEN 1 AND 15 SELECT @Dia = 1
ELSE SELECT @Dia = 16
END
IF @PeriodoTipo = 'QUINCENAL 5-20'
BEGIN
IF @Dia BETWEEN 1 AND 4
BEGIN
IF @Mes > 1 SELECT @Mes = @Mes - 1 ELSE SELECT @Mes = 12, @Ano = @Ano - 1
SELECT @Dia = 20
END ELSE
IF @Dia BETWEEN 5 AND 19 SELECT @Dia = 5
ELSE SELECT @Dia = 20
END
EXEC spIntToDateTime @Dia, @Mes, @Ano, @FechaD OUTPUT
IF @PeriodoTipo = 'DECENAL'
BEGIN
IF @Dia = 1  SELECT @Dia = 10 ELSE
IF @Dia = 11 SELECT @Dia = 20 ELSE
IF @Dia = 21 SELECT @Dia = @Dias
END
IF @PeriodoTipo = 'QUINCENAL'
BEGIN
IF @Dia = 1  SELECT @Dia = 15 ELSE
IF @Dia = 16 SELECT @Dia = @Dias
END
IF @PeriodoTipo = 'QUINCENAL 5-20'
BEGIN
IF @Dia = 5  SELECT @Dia = 20
ELSE BEGIN
SELECT @Dia = 5
IF @Mes < 12 SELECT @Mes = @Mes + 1 ELSE SELECT @Mes = 1, @Ano = @Ano + 1
END
END
EXEC spIntToDateTime @Dia, @Mes, @Ano, @FechaA OUTPUT
END
END
IF @PeriodoTipo NOT IN ('SEMANAL','MENSUAL','CATORCENAL','ANUAL','DECENAL', 'QUINCENAL', 'QUINCENAL 5-20')
EXEC spPeriodoDAOtro @PeriodoTipo, @Fecha, @FechaD OUTPUT, @FechaA OUTPUT, @Empresa
RETURN
END

