SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER FUNCTION dbo.fnCalculaAntiguedad
(
@FechaIngreso datetime,
@FechaActual  datetime
)
RETURNS varchar(25)
BEGIN
DECLARE @FechaAñoActual    datetime,
@FechaAñoActualMes datetime,
@DiffAño           int,
@DiffMes           int,
@DiffDia           int,
@sAño              varchar(8),
@sMes              varchar(9),
@sDia              varchar(8),
@sSalida           varchar(25)
SET @DiffAño = dbo.fnDiferenciaFecha('yy', @FechaIngreso, @FechaActual)
SET @FechaAñoActual = DATEADD(yy, @DiffAño, @FechaIngreso)
SET @DiffMes = dbo.fnDiferenciaFecha('mm', @FechaAñoActual, @FechaActual)
SET @FechaAñoActualMes = DATEADD(mm, @DiffMes, @FechaAñoActual)
SET @DiffDia = dbo.fnDiferenciaFecha('dd', @FechaAñoActualMes, @FechaActual)
SET @sAño =
CASE WHEN @DiffAño = 0 THEN ''
WHEN @DiffAño = 1 THEN CAST(@DiffAño AS varchar) + ' Año '
WHEN @DiffAño > 1 THEN CAST(@DiffAño AS varchar) + ' Años '
END
SET @sMes =
CASE WHEN @DiffMes = 0 THEN ''
WHEN @DiffMes = 1 THEN CAST(@DiffMes AS varchar) + ' Mes '
WHEN @DiffMes > 1 THEN CAST(@DiffMes AS varchar) + ' Meses '
END
SET @sDia =
CASE WHEN @DiffDia = 0 THEN ''
WHEN @DiffDia = 1 THEN CAST(@DiffDia AS varchar) + ' Día '
WHEN @DiffDia > 1 THEN CAST(@DiffDia AS varchar) + ' Días '
END
SET @sSalida = CASE WHEN @sAño + @sMes + @sDia = '' THEN 'Sin Antiguedad'
ELSE @sAño + @sMes + @sDia
END
RETURN @sSalida
END

