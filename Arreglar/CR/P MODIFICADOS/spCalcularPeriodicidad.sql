SET DATEFIRST 7    
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1  
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spCalcularPeriodicidad
@FechaEmision	datetime,
@Periodicidad	char(20),
@Vencimiento	datetime        OUTPUT,
@Ok 		int		OUTPUT,
@OkRef 		varchar(255)	OUTPUT,
@Reversa		bit		= 0

AS BEGIN
DECLARE
@Dia	int
EXEC spExtraerFecha @FechaEmision OUTPUT
IF @Reversa = 0
BEGIN
IF dbo.fnEsNumerico(@Periodicidad) = 1 SELECT @Vencimiento = DATEADD(day,   CONVERT(int, @Periodicidad), @FechaEmision) ELSE
IF @Periodicidad = 'DIARIA'     SELECT @Vencimiento = DATEADD(day,   1, @FechaEmision) ELSE
IF @Periodicidad = 'SEMANAL'    SELECT @Vencimiento = DATEADD(week,  1, @FechaEmision) ELSE
IF @Periodicidad = 'CATORCENAL'     SELECT @Vencimiento = DATEADD(day,   14, @FechaEmision) ELSE
IF @Periodicidad = 'MENSUAL'    SELECT @Vencimiento = DATEADD(month, 1, @FechaEmision) ELSE
IF @Periodicidad = 'BIMESTRAL'  SELECT @Vencimiento = DATEADD(month, 2, @FechaEmision) ELSE
IF @Periodicidad = 'TRIMESTRAL' SELECT @Vencimiento = DATEADD(month, 3, @FechaEmision) ELSE
IF @Periodicidad = 'SEMESTRAL'  SELECT @Vencimiento = DATEADD(month, 6, @FechaEmision) ELSE
IF @Periodicidad = 'ANUAL'      SELECT @Vencimiento = DATEADD(year,  1, @FechaEmision) ELSE
IF @Periodicidad = 'QUINCENAL'
BEGIN
SELECT @Dia = DATEPART(dd, @FechaEmision)
IF @Dia <= 15
SELECT @Vencimiento = DATEADD(dd, 15-@Dia, @FechaEmision) + 1
ELSE
SELECT @Vencimiento = DATEADD(dd, -DATEPART(dd, DATEADD(mm, 1, @FechaEmision)), DATEADD(mm, 1, @FechaEmision))+1
END ELSE
IF @Periodicidad = '<DIAS>' SELECT @Ok =55140, @OkRef = @Periodicidad ELSE SELECT @Vencimiento = NULL
END ELSE
BEGIN
IF dbo.fnEsNumerico(@Periodicidad) = 1 SELECT @Vencimiento = DATEADD(day,   -CONVERT(int, @Periodicidad), @FechaEmision) ELSE
IF @Periodicidad = 'DIARIA'     SELECT @Vencimiento = DATEADD(day,   -1, @FechaEmision) ELSE
IF @Periodicidad = 'SEMANAL'    SELECT @Vencimiento = DATEADD(week,  -1, @FechaEmision) ELSE
IF @Periodicidad = 'CATORCENAL'  SELECT @Vencimiento = DATEADD(day,   -14, @FechaEmision) ELSE
IF @Periodicidad = 'MENSUAL'    SELECT @Vencimiento = DATEADD(month, -1, @FechaEmision) ELSE
IF @Periodicidad = 'BIMESTRAL'  SELECT @Vencimiento = DATEADD(month, -2, @FechaEmision) ELSE
IF @Periodicidad = 'TRIMESTRAL' SELECT @Vencimiento = DATEADD(month, -3, @FechaEmision) ELSE
IF @Periodicidad = 'SEMESTRAL'  SELECT @Vencimiento = DATEADD(month, -6, @FechaEmision) ELSE
IF @Periodicidad = 'ANUAL'      SELECT @Vencimiento = DATEADD(year,  -1, @FechaEmision) ELSE
IF @Periodicidad = 'QUINCENAL'
BEGIN
SELECT @Dia = DATEPART(dd, @FechaEmision)
IF @Dia > 15
SELECT @Vencimiento = DATEADD(dd, -(@Dia-15), @FechaEmision)+1
ELSE
SELECT @Vencimiento = DATEADD(dd, -DATEPART(dd, @FechaEmision), @FechaEmision)+1
END ELSE
IF @Periodicidad = '<DIAS>' SELECT @Ok =55140, @OkRef = @Periodicidad ELSE SELECT @Vencimiento = NULL
END
RETURN
END

