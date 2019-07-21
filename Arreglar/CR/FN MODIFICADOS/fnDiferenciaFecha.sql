SET DATEFIRST 7    
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1  
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER FUNCTION dbo.fnDiferenciaFecha
(
@Tipo         varchar(2),
@FechaIngreso datetime,
@FechaActual  datetime
)
RETURNS INT
BEGIN
RETURN
CASE WHEN @FechaIngreso > @FechaActual
THEN NULL
ELSE
CASE WHEN UPPER(@Tipo) NOT IN ('YY','MM','DD') THEN NULL
WHEN UPPER(@Tipo) = 'YY' THEN
CASE
WHEN DATEPART(DAY, @FechaIngreso) > DATEPART(DAY, @FechaActual) THEN DATEDIFF(MONTH, @FechaIngreso, @FechaActual) - 1
ELSE DATEDIFF(MONTH, @FechaIngreso, @FechaActual)
END / 12
WHEN UPPER(@Tipo) = 'MM' THEN
CASE
WHEN DATEPART(DAY, @FechaIngreso) > DATEPART(DAY, @FechaActual) THEN DATEDIFF(MONTH, @FechaIngreso, @FechaActual) - 1
ELSE DATEDIFF(MONTH, @FechaIngreso, @FechaActual)
END
WHEN UPPER(@Tipo) = 'DD' THEN
CASE
WHEN CONVERT(varchar,@FechaIngreso,108) > CONVERT(varchar,@FechaActual,108)  THEN DATEDIFF(dd, @FechaIngreso, @FechaActual) - 1
ELSE DATEDIFF(dd, @FechaIngreso, @FechaActual)
END
END
END
END

