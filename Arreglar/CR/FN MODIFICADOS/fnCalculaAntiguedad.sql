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
DECLARE @FechaA�oActual    datetime,
@FechaA�oActualMes datetime,
@DiffA�o           int,
@DiffMes           int,
@DiffDia           int,
@sA�o              varchar(8),
@sMes              varchar(9),
@sDia              varchar(8),
@sSalida           varchar(25)
SET @DiffA�o = dbo.fnDiferenciaFecha('yy', @FechaIngreso, @FechaActual)
SET @FechaA�oActual = DATEADD(yy, @DiffA�o, @FechaIngreso)
SET @DiffMes = dbo.fnDiferenciaFecha('mm', @FechaA�oActual, @FechaActual)
SET @FechaA�oActualMes = DATEADD(mm, @DiffMes, @FechaA�oActual)
SET @DiffDia = dbo.fnDiferenciaFecha('dd', @FechaA�oActualMes, @FechaActual)
SET @sA�o =
CASE WHEN @DiffA�o = 0 THEN ''
WHEN @DiffA�o = 1 THEN CAST(@DiffA�o AS varchar) + ' A�o '
WHEN @DiffA�o > 1 THEN CAST(@DiffA�o AS varchar) + ' A�os '
END
SET @sMes =
CASE WHEN @DiffMes = 0 THEN ''
WHEN @DiffMes = 1 THEN CAST(@DiffMes AS varchar) + ' Mes '
WHEN @DiffMes > 1 THEN CAST(@DiffMes AS varchar) + ' Meses '
END
SET @sDia =
CASE WHEN @DiffDia = 0 THEN ''
WHEN @DiffDia = 1 THEN CAST(@DiffDia AS varchar) + ' D�a '
WHEN @DiffDia > 1 THEN CAST(@DiffDia AS varchar) + ' D�as '
END
SET @sSalida = CASE WHEN @sA�o + @sMes + @sDia = '' THEN 'Sin Antiguedad'
ELSE @sA�o + @sMes + @sDia
END
RETURN @sSalida
END

