SET DATEFIRST 7
SET ANSI_NULLS ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET ANSI_WARNINGS ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spNotificacionEnFrecuencia
@Notificacion				varchar(50),
@FechaEmision				datetime,
@Resultado					bit OUTPUT,
@Ok							int = NULL OUTPUT,
@OkRef						varchar(255) = NULL OUTPUT

AS BEGIN
DECLARE
@RID							int,
@FechaD						datetime,
@FechaA						datetime,
@PrimerDiaSemana				int,
@Frecuencia					varchar(20),
@DiaSemanaEmision				int,
@DiaEmision					int,
@MesEmision					int,
@AnoEmision					int,
@DiasMesEmision				int,
@Lunes						bit,
@Martes						bit,
@Miercoles					bit,
@Jueves						bit,
@Viernes						bit,
@Sabado						bit,
@Domingo						bit,
@DiaMes						int,
@FechaInicio					datetime,
@Diferencia					int
SET @PrimerDiaSemana = @@DATEFIRST
SET DATEFIRST 1
SET @DiaSemanaEmision = DATEPART(dw,@FechaEmision)
SET @DiaEmision       = DATEPART(d,@FechaEmision)
SET @MesEmision       = DATEPART(mm,@FechaEmision)
SET @AnoEmision       = DATEPART(yy,@FechaEmision)
SET @DiasMesEmision = dbo.fnDiasMes(@MesEmision,@AnoEmision)
SET @Resultado = 0
SELECT
@Frecuencia = ISNULL(Frecuencia,'(Diaria)'),
@DiaMes = ISNULL(DiaMes,0),
@FechaInicio = FechaInicio,
@Lunes = ISNULL(Lunes,0),
@Martes = ISNULL(Martes,0),
@Miercoles = ISNULL(Miercoles,0),
@Jueves = ISNULL(Jueves,0),
@Viernes = ISNULL(Viernes,0),
@Sabado = ISNULL(Sabado,0),
@Domingo = ISNULL(Domingo,0)
FROM Notificacion
WHERE RTRIM(Notificacion) = RTRIM(@Notificacion)
IF @DiasMesEmision < @DiaMes SET @DiaMes = @DiasMesEmision
SET @Diferencia = DATEDIFF(mm,CONVERT(datetime,@FechaInicio),CONVERT(datetime,@FechaEmision))
IF @Frecuencia IN ('(Mensual)','(Bimestral)','(Trimestral)','(Semestral)','(Anual)') AND (@Ok IS NULL OR @Ok BETWEEN 80030 AND 81000) AND @FechaInicio IS NULL SELECT @Ok = 41020, @OkRef = @Notificacion ELSE
IF @Frecuencia IN ('(Mensual)','(Bimestral)','(Trimestral)','(Semestral)','(Anual)') AND (@Ok IS NULL OR @Ok BETWEEN 80030 AND 81000) AND @DiaMes = 0 SELECT @Ok = 10060, @OkRef = @Notificacion
IF @Frecuencia = '(Diaria)' AND (@Ok IS NULL OR @Ok BETWEEN 80030 AND 81000)
BEGIN
SET @Resultado = 1
END ELSE
IF @Frecuencia = '(Semanal)' AND (@Ok IS NULL OR @Ok BETWEEN 80030 AND 81000)
BEGIN
IF @DiaSemanaEmision = 1 SET @Resultado = ISNULL(@Lunes,0) ELSE
IF @DiaSemanaEmision = 2 SET @Resultado = ISNULL(@Martes,0) ELSE
IF @DiaSemanaEmision = 3 SET @Resultado = ISNULL(@Miercoles,0) ELSE
IF @DiaSemanaEmision = 4 SET @Resultado = ISNULL(@Jueves,0) ELSE
IF @DiaSemanaEmision = 5 SET @Resultado = ISNULL(@Viernes,0) ELSE
IF @DiaSemanaEmision = 6 SET @Resultado = ISNULL(@Sabado,0) ELSE
IF @DiaSemanaEmision = 7 SET @Resultado = ISNULL(@Domingo,0)
END ELSE
IF @Frecuencia = '(Mensual)' AND (@Ok IS NULL OR @Ok BETWEEN 80030 AND 81000)
BEGIN
IF @FechaEmision >= @FechaInicio
BEGIN
IF @DiaEmision = @DiaMes SELECT @Resultado = 1
END
END ELSE
IF @Frecuencia = '(Bimestral)' AND (@Ok IS NULL OR @Ok BETWEEN 80030 AND 81000)
BEGIN
IF (@FechaEmision >= @FechaInicio) AND ( @Diferencia % 2 = 0)
BEGIN
IF @DiaEmision = @DiaMes SELECT @Resultado = 1
END
END ELSE
IF @Frecuencia = '(Trimestral)' AND (@Ok IS NULL OR @Ok BETWEEN 80030 AND 81000)
BEGIN
IF (@FechaEmision >= @FechaInicio) AND ( @Diferencia % 3 = 0)
BEGIN
IF @DiaEmision = @DiaMes SELECT @Resultado = 1
END
END ELSE
IF @Frecuencia = '(Semestral)' AND (@Ok IS NULL OR @Ok BETWEEN 80030 AND 81000)
BEGIN
IF (@FechaEmision >= @FechaInicio) AND ( @Diferencia % 6 = 0)
BEGIN
IF @DiaEmision = @DiaMes SELECT @Resultado = 1
END
END ELSE
IF @Frecuencia = '(Anual)' AND (@Ok IS NULL OR @Ok BETWEEN 80030 AND 81000)
BEGIN
IF (@FechaEmision >= @FechaInicio) AND ( @Diferencia % 12 = 0)
BEGIN
IF @DiaEmision = @DiaMes SELECT @Resultado = 1
END
END
SET DATEFIRST @PrimerDiaSemana
END

