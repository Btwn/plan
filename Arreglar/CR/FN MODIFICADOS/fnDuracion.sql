SET DATEFIRST 7    
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1  
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER FUNCTION fnDuracion(@Fecha datetime, @CantidadSt varchar(20), @Unidad varchar(20))
RETURNS datetime

AS BEGIN
DECLARE
@Resultado	datetime,
@Cantidad	float,
@Hoy	datetime,
@Dia	int,
@DiaSemana	int,
@Mes	int,
@Hora	int,
@Minuto	int,
@Segundo	int,
@ms		int
SELECT @CantidadSt = NULLIF(RTRIM(UPPER(@CantidadSt)), ''), @Unidad = UPPER(@Unidad)
IF @Unidad = 'A�O' SELECT @Unidad = 'ANO'
IF @Unidad IN ('ANO', 'MES', 'SEMANA', 'DIA')
SELECT @Hoy = dbo.fnFechaSinHora(@Fecha)
ELSE
SELECT @Hoy = @Fecha
SELECT @Dia = DAY(@Hoy), @DiaSemana = DATEPART(weekday, @Hoy), @Mes = MONTH(@Hoy),
@Hora = DATEPART(hour, @Hoy), @Minuto = DATEPART(minute, @Hoy), @Segundo = DATEPART(second, @Hoy), @ms = DATEPART(millisecond, @hoy)
SELECT @Resultado = @Hoy
IF dbo.fnEsNumerico(@CantidadSt) = 1
BEGIN
SELECT @Cantidad = CONVERT(float, @CantidadSt)
IF @Unidad = 'ANO'     SELECT @Resultado = DATEADD(year,   @Cantidad, @Resultado) ELSE
IF @Unidad = 'MES'     SELECT @Resultado = DATEADD(month,  @Cantidad, @Resultado) ELSE
IF @Unidad = 'SEMANA'  SELECT @Resultado = DATEADD(week,   @Cantidad, @Resultado) ELSE
IF @Unidad = 'DIA'     SELECT @Resultado = DATEADD(day,    @Cantidad, @Resultado) ELSE
IF @Unidad = 'HORA'    SELECT @Resultado = DATEADD(hour,   @Cantidad, @Resultado) ELSE
IF @Unidad = 'MINUTO'  SELECT @Resultado = DATEADD(minute,  @Cantidad, @Resultado) ELSE
IF @Unidad = 'SEGUNDO' SELECT @Resultado = DATEADD(second,  @Cantidad, @Resultado)
END ELSE
IF @CantidadSt IN ('ESTE', 'ESTA')
BEGIN
IF @Unidad = 'ANO'    SELECT @Resultado = dbo.fnUltimoDiaAno(@Resultado) ELSE
IF @Unidad = 'MES'    SELECT @Resultado = dbo.fnUltimoDiaMes(@Resultado) ELSE
IF @Unidad = 'SEMANA' SELECT @Resultado = dbo.fnUltimoDiaSemana(@Resultado) ELSE
SELECT @Resultado = NULL		
END
RETURN (@Resultado)
END

