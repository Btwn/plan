SET DATEFIRST 7
SET ANSI_NULLS ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET ANSI_WARNINGS ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER FUNCTION fnNotificacionParamCalcPeriodoFecha
(
@Tipo					varchar(20),
@Notificacion			varchar(50),
@Fecha					datetime,
@ParamNumeroPeriodos	varchar(100),
@ParamTipoPeriodo		varchar(100)
)
RETURNS datetime

AS BEGIN
DECLARE
@Resultado				datetime,
@FechaFinal				datetime,
@FechaInicial			datetime,
@NotificacionClave		varchar(50),
@NumeroPeriodos			int,
@PeriodoTipo			varchar(255)
SET @FechaFinal = dbo.fnFechaSinHora(DATEADD(DD,-1,@Fecha))
SET @Resultado = NULL
SELECT @NotificacionClave = Clave FROM Notificacion WHERE LTRIM(RTRIM(Notificacion)) = @Notificacion
SELECT @NumeroPeriodos = CONVERT(int,ISNULL(Valor,1)) FROM NotificacionParam WHERE Notificacion = @Notificacion AND Parametro = @ParamNumeroPeriodos
IF @@ERROR <> 0 SET @NumeroPeriodos = 1
SELECT @PeriodoTipo = ISNULL(NULLIF(Valor,''),'DIA') FROM NotificacionParam WHERE Notificacion = @Notificacion AND Parametro = @ParamTipoPeriodo
IF @PeriodoTipo NOT IN ('DIA','MES','AÑO') SET @PeriodoTipo = 'DIA'
IF @NumeroPeriodos >= 1 SET @NumeroPeriodos = @NumeroPeriodos -1 ELSE
IF @NumeroPeriodos < 0 SET @NumeroPeriodos = 0
IF @Tipo = 'FINAL'
BEGIN
SET @Resultado = @FechaFinal
END ELSE
BEGIN
IF @Tipo = 'INICIAL'
BEGIN
IF @PeriodoTipo = 'DIA'
BEGIN
SET @Resultado = DATEADD(dd,0-@NumeroPeriodos,@FechaFinal)
END ELSE
IF @PeriodoTipo = 'MES'
BEGIN
SET @FechaInicial = DATEADD(dd,0-(DAY(@FechaFinal)-1),@FechaFinal)
SET @Resultado = DATEADD(mm,0-@NumeroPeriodos,@FechaInicial)
END ELSE
IF @PeriodoTipo = 'AÑO'
BEGIN
SET @FechaInicial = DATEADD(dd,0-(DAY(@FechaFinal)-1),@FechaFinal)
SET @FechaInicial = DATEADD(mm,0-(MONTH(@FechaInicial)-1),@FechaInicial)
SET @Resultado = DATEADD(yy,0-@NumeroPeriodos,@FechaInicial)
END
END
END
RETURN (@Resultado)
END

