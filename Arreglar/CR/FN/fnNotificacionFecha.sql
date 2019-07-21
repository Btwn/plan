SET DATEFIRST 7
SET ANSI_NULLS ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET ANSI_WARNINGS ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER FUNCTION fnNotificacionFecha
(
@TipoFechaNotificacion		varchar(50), 
@FechaNotificacion			datetime,
@AnticipacionFechaTipo		varchar(20),
@AnticipacionFecha			int,
@FechaEmision				datetime,
@FechaVencimiento			datetime
)
RETURNS datetime

AS BEGIN
DECLARE
@Resultado			datetime,
@Hoy					datetime
SET @Hoy = dbo.fnFechaSinHora(GETDATE())
SET @TipoFechaNotificacion = UPPER(@TipoFechaNotificacion)
SET @AnticipacionFechaTipo = RTRIM(UPPER(ISNULL(@AnticipacionFechaTipo,'APLAZAR')))
IF @AnticipacionFechaTipo = 'ADELANTAR' SET @AnticipacionFecha = 0 - ISNULL(@AnticipacionFecha,0) ELSE
IF @AnticipacionFechaTipo = 'APLAZAR'   SET @AnticipacionFecha = ISNULL(@AnticipacionFecha,0)
IF @TipoFechaNotificacion = '(EMISION)'
BEGIN
SET @Resultado = DATEADD(day,@AnticipacionFecha,ISNULL(@FechaEmision,@Hoy))
IF @Resultado < @Hoy SET @Resultado = @Hoy
END ELSE
IF @TipoFechaNotificacion = '(VENCIMIENTO)'
BEGIN
SET @Resultado = DATEADD(day,@AnticipacionFecha,ISNULL(ISNULL(@FechaVencimiento,@FechaEmision),@Hoy))
IF @Resultado < @Hoy SET @Resultado = @Hoy
END ELSE
IF @TipoFechaNotificacion = '(ESPECIFICA)'
BEGIN
SET @Resultado = DATEADD(day,@AnticipacionFecha,ISNULL(ISNULL(@FechaNotificacion,@FechaEmision),@Hoy))
IF @Resultado < @Hoy SET @Resultado = @Hoy
END
RETURN (dbo.fnFechaSinHora(ISNULL(@Resultado,@Hoy)))
END

