SET DATEFIRST 7    
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1  
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER FUNCTION fnProyectarFecha (@FechaD datetime, @FechaA datetime, @RecorrerVencimiento int, @TipoVencimiento varchar(20), @Dias int, @MinimoDias int, @TipoAmortizacion varchar(20))
RETURNS @Resultado TABLE (Periodo int, FechaD datetime, FechaA datetime)

AS BEGIN
DECLARE
@a		int,
@Periodo    int,
@UltFecha   datetime,
@Fecha      datetime,
@FechaHabil datetime,
@Dia        int,
@DiasMes    int,
@Mes        int,
@Ano        int,
@UFechaD    datetime,
@UFechaA    datetime,
@UPeriodo   int,
@FinMes		bit,
@PagoQ1		int,
@PagoQ2		int,
@FechaPago1 datetime,
@FechaPAgo2 datetime,
@FechaHabilF datetime,
@DiasIncluirUltima	bit
SELECT @Periodo = 1, @Fecha = @FechaD, @TipoVencimiento = UPPER(@TipoVencimiento)
SELECT @UltFecha = @Fecha
WHILE @Fecha <= @FechaA
BEGIN
IF @TipoVencimiento = 'DIAS'
BEGIN
SELECT @DiasIncluirUltima = DiasIncluirUltima FROM TipoAmortizacion WITH(NOLOCK) WHERE TipoAmortizacion = @TipoAmortizacion
SELECT @Fecha = DATEADD(day, @Dias, @Fecha)
IF @DiasIncluirUltima = 1
BEGIN
IF @UltFecha BETWEEN @FechaD AND @FechaA AND DATEADD(day, FLOOR(@Dias/2), @FechaA) >  @Fecha
BEGIN
SELECT @Fecha = dbo.fnChecarDiaHabil(@Fecha, @RecorrerVencimiento)
INSERT @Resultado VALUES (@Periodo, @UltFecha, @Fecha)
SELECT @UltFecha = @Fecha
END
END ELSE
IF @Fecha BETWEEN @FechaD AND @FechaA
BEGIN
SELECT @Fecha = dbo.fnChecarDiaHabil(@Fecha, @RecorrerVencimiento)
INSERT @Resultado VALUES (@Periodo, @UltFecha, @Fecha)
SELECT @UltFecha = @Fecha
END
END ELSE
IF @TipoVencimiento = 'DIA ESPECIFICO'
BEGIN
SELECT @Mes = MONTH(@Fecha), @Ano = YEAR(@Fecha)
SELECT @DiasMes = dbo.fnDiasMes(@Mes, @Ano)
IF @Dias>@DiasMes
SELECT @Fecha = dbo.fnIntToDateTime(@DiasMes, @Mes, @Ano)
ELSE
SELECT @Fecha = dbo.fnIntToDateTime(@Dias, @Mes, @Ano)
IF @Fecha BETWEEN @FechaD AND @FechaA
BEGIN
SELECT @FechaHabil = dbo.fnChecarDiaHabil(@Fecha, @RecorrerVencimiento)
INSERT @Resultado VALUES (@Periodo, @UltFecha, @FechaHabil)
SELECT @UltFecha = @FechaHabil
END
SELECT @Fecha = DATEADD(month, 1, @Fecha)
END ELSE
IF @TipoVencimiento = 'FIN DE MES'
BEGIN
SELECT @Dia = DAY(@Fecha), @Mes = MONTH(@Fecha), @Ano = YEAR(@Fecha)
SELECT @DiasMes = dbo.fnDiasMes(@Mes, @Ano)
SELECT @Fecha = dbo.fnIntToDateTime(@DiasMes, @Mes, @Ano)
IF @Fecha BETWEEN @FechaD AND @FechaA
BEGIN
SELECT @FechaHabil = dbo.fnChecarDiaHabil(@Fecha, @RecorrerVencimiento)
INSERT @Resultado VALUES (@Periodo, @UltFecha, @FechaHabil)
SELECT @UltFecha = @FechaHabil
END
SELECT @Fecha = DATEADD(month, 1, @Fecha)
END ELSE
IF @TipoVencimiento = 'QUINCENAL'
BEGIN
SELECT	@FinMes = FinMes,
@PagoQ1 = ISNULL(PagoDiasQ1,0),
@PagoQ2 = ISNULL(PagoDiasQ2,0)
FROM TipoAmortizacion WITH(NOLOCK)
WHERE TipoAmortizacion = @TipoAmortizacion
SELECT @Mes = MONTH(@Fecha), @Ano = YEAR(@Fecha)
IF @FinMes = 1
BEGIN
SELECT @DiasMes = dbo.fnDiasMes(@Mes, @Ano)
SELECT @FechaPago1 = dbo.fnIntToDateTime(15, @Mes, @Ano),
@FechaPago2 = dbo.fnIntToDateTime(@DiasMes, @Mes, @Ano)
IF @Fecha BETWEEN @FechaD AND @FechaA
BEGIN
SELECT @FechaHabil = dbo.fnChecarDiaHabil(@FechaPago1, @RecorrerVencimiento)
SELECT @FechaHabilF = dbo.fnChecarDiaHabil(@FechaPago2, @RecorrerVencimiento)
INSERT @Resultado VALUES(@Periodo, @FechaHabil, @FechaHabilF)
END
END
ELSE
BEGIN
SELECT	@FechaPago1 = dbo.fnIntToDateTime(@PagoQ1, @Mes, @Ano),
@FechaPago2 = CASE WHEN @PagoQ2 <= dbo.fnDiasMes(@Mes, @Ano)
THEN dbo.fnIntToDateTime(@PagoQ2, @Mes, @Ano)
ELSE dbo.fnIntToDateTime(dbo.fnDiasMes(@Mes, @Ano), @Mes, @Ano)
END
IF @Fecha BETWEEN @FechaD AND @FechaA
BEGIN
SELECT @FechaHabil = dbo.fnChecarDiaHabil(@FechaPago1, @RecorrerVencimiento)
SELECT @FechaHabilF = dbo.fnChecarDiaHabil(@FechaPago2, @RecorrerVencimiento)
INSERT @Resultado VALUES(@Periodo, @FechaHabil, @FechaHabilF)
END
END
SELECT @Fecha = DATEADD(month, 1, @Fecha)
END
SELECT @Periodo = @Periodo + 1
END
IF ISNULL(@MinimoDias, 0)>0
BEGIN
SELECT @Periodo = MIN(Periodo) FROM @Resultado
SELECT @FechaD = FechaD, @FechaA = FechaA FROM @Resultado WHERE Periodo = @Periodo
IF DATEDIFF(day, @FechaD, @FechaA) < @MinimoDias
BEGIN
DELETE @Resultado WHERE Periodo = @Periodo
SELECT @Periodo = MIN(Periodo) FROM @Resultado
UPDATE @Resultado SET FechaD = @FechaD WHERE Periodo = @Periodo
SELECT @a = 0
UPDATE @Resultado SET @a = Periodo = @a + 1
SELECT @UPeriodo = MAX(Periodo) FROM @Resultado
SELECT @UFechaD = FechaD, @UFechaA = FechaA FROM @Resultado WHERE Periodo = @UPeriodo
SELECT @UFechaD = DATEADD(month, 1, @UFechaD), @UFechaA = DATEADD(month, 1, @UFechaA)
INSERT @Resultado VALUES (@UPeriodo+1, @UFechaD, @UFechaA)
END
END
RETURN
END

