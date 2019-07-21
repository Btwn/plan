SET DATEFIRST 7    
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1  
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spCalcularDiasHabiles
@FechaActual	datetime,
@Dias		int,
@DiasHabiles 	char(10),
@Todos		bit,
@FechaFinal		datetime	OUTPUT,
@ProyectoID		int	= NULL,
@Jornada		varchar(20) = NULL

AS BEGIN
SET DATEFIRST 7
DECLARE
@DiasAgregados	int,
@DiaSemana		int,
@Inc		int,
@Control	bit
IF @Jornada IS NOT NULL AND EXISTS(SELECT * FROM Jornada WITH (NOLOCK) WHERE Jornada = @Jornada AND UPPER(Tipo) = 'CONTROL ASISTENCIA')
SELECT @Control = 1
IF @Dias < 0 SELECT @Inc = -1 ELSE SELECT @Inc = 1
EXEC spExtraerFecha @FechaActual OUTPUT
SELECT @DiasAgregados = 0
SELECT @FechaFinal = @FechaActual
WHILE ABS(@DiasAgregados) < ABS(@Dias)
BEGIN
SELECT @FechaFinal = DATEADD(day, @Inc, @FechaFinal)
IF @Control = 1
BEGIN
IF @FechaFinal IN (SELECT DISTINCT Fecha FROM JornadaTiempo WITH (NOLOCK) WHERE Jornada = @Jornada)
SELECT @DiasAgregados = @DiasAgregados + @Inc
ELSE
SELECT @DiasAgregados = @DiasAgregados
END ELSE
BEGIN
IF @ProyectoID IS NOT NULL
BEGIN
IF NOT EXISTS(SELECT * FROM ProyectoInhabil WITH (NOLOCK) WHERE ID = @ProyectoID AND Fecha = @FechaFinal)
SELECT @DiasAgregados = @DiasAgregados + @Inc
END ELSE
BEGIN
SELECT @DiaSemana = DATEPART(weekday, @FechaFinal)
IF @Todos = 1
BEGIN
IF (@DiasHabiles <> 'TODOS' AND @DiaSemana = 1) OR
(@DiasHabiles = 'LUN-VIE' AND @DiaSemana = 7) OR
(@FechaFinal IN (SELECT Fecha FROM DiaFestivo WITH (NOLOCK)))
SELECT @DiasAgregados = @DiasAgregados
ELSE
SELECT @DiasAgregados = @DiasAgregados + @Inc
END ELSE
BEGIN
IF (@DiasHabiles <> 'TODOS' AND @DiaSemana = 1) OR
(@DiasHabiles = 'LUN-VIE' AND @DiaSemana = 7) OR
(@FechaFinal IN (SELECT Fecha FROM DiaFestivo WITH (NOLOCK) WHERE EsLaborable = 0))
SELECT @DiasAgregados = @DiasAgregados
ELSE
SELECT @DiasAgregados = @DiasAgregados + @Inc
END
END
END
END
RETURN
END

