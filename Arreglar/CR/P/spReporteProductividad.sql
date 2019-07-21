SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spReporteProductividad
@Estacion		int

AS BEGIN
DECLARE
@Flujo			varchar(10),
@Acomodador		varchar(10),
@Acomodo		varchar(10),
@Reacomodo		varchar(10),
@Surtido		varchar(10),
@Desde			datetime,
@Hasta			datetime
SELECT @Flujo			= ISNULL(InfoFlujo, '(Todos)'),
@Acomodador	= ISNULL(InfoAcomodador, '(Todos)'),
@Desde			= InfoFechaD,
@Hasta			= InfoFechaA
FROM RepParam
WHERE Estacion = @Estacion
IF @Flujo = '(Todos)'
SELECT @Acomodo		= 'TMA.OADO',
@Reacomodo	= 'TMA.ORADO',
@Surtido		= 'TMA.OSUR'
ELSE
IF @Flujo = 'Acomodo'
SELECT @Acomodo		= 'TMA.OADO',
@Reacomodo	= 'TMA.OADO',
@Surtido		= 'TMA.OADO'
ELSE
IF @Flujo = 'Reacomodo'
SELECT @Acomodo		= 'TMA.ORADO',
@Reacomodo	= 'TMA.ORADO',
@Surtido		= 'TMA.ORADO'
ELSE
IF @Flujo = 'Surtido'
SELECT @Acomodo		= 'TMA.OSUR',
@Reacomodo	= 'TMA.OSUR',
@Surtido		= 'TMA.OSUR'
DECLARE @Resultado		TABLE
(
Acomodador			varchar(20),
Nombre				varchar(100),
Movimientos		int,
Mov				varchar(20),
MovID				varchar(20),
Tarima				varchar(20),
Inicio				datetime,
Fin				datetime,
Productividad		float
)
IF @Acomodador = '(Todos)'
BEGIN
DECLARE crProductividad CURSOR FOR
SELECT Agente
FROM Agente
OPEN crProductividad
FETCH NEXT FROM crProductividad INTO @Acomodador
WHILE @@FETCH_STATUS = 0 
BEGIN
INSERT INTO @Resultado
SELECT t.Agente Acomodador, a.Nombre, 1 Movimientos, t.Mov, t.MovID, d.Tarima, ISNULL(t.FechaInicio, 0) Inicio, ISNULL(t.FechaFin, 0) Fin, ISNULL((((CONVERT(FLOAT, DATEDIFF(SECOND, t.FechaInicio, t.FechaFin)))/60)/60), 0) Productividad
FROM TMA t
JOIN TMAD d
ON t.ID = d.ID
JOIN MovTipo m
ON m.Mov = t.Mov AND m.Modulo = 'TMA'
JOIN Agente a
ON a.Agente = @Acomodador
WHERE t.Estatus = 'CONCLUIDO'
AND t.Agente = @Acomodador
AND m.Clave IN( @Acomodo, @Reacomodo, @Surtido)
AND dbo.fnFechaSinHora(@Desde) < = dbo.fnFechaSinHora(t.FechaInicio)
AND dbo.fnFechaSinHora(@Hasta) > = dbo.fnFechaSinHora(t.FechaFin)
AND dbo.fnFechaSinHora(t.FechaInicio) BETWEEN dbo.fnFechaSinHora(@Desde) AND dbo.fnFechaSinHora(@Hasta)
ORDER BY dbo.fnFechaSinHora(t.FechaInicio), dbo.fnFechaSinHora(t.FechaFin)
FETCH NEXT FROM crProductividad INTO @Acomodador
END
CLOSE crProductividad
DEALLOCATE crProductividad
END
ELSE
INSERT INTO @Resultado
SELECT t.Agente Acomodador, a.Nombre, 1 Movimientos, t.Mov, t.MovID, d.Tarima, ISNULL(t.FechaInicio, 0) Inicio, ISNULL(t.FechaFin, 0) Fin, ISNULL((((CONVERT(FLOAT, DATEDIFF(SECOND, t.FechaInicio, t.FechaFin)))/60)/60), 0) Productividad
FROM TMA t
JOIN TMAD d
ON t.ID = d.ID
JOIN MovTipo m
ON m.Mov = t.Mov AND m.Modulo = 'TMA'
JOIN Agente a
ON a.Agente = @Acomodador
WHERE t.Estatus = 'CONCLUIDO'
AND t.Agente = @Acomodador
AND m.Clave IN( @Acomodo, @Reacomodo, @Surtido)
AND dbo.fnFechaSinHora(@Desde) < = dbo.fnFechaSinHora(t.FechaInicio)
AND dbo.fnFechaSinHora(@Hasta) > = dbo.fnFechaSinHora(t.FechaFin)
AND dbo.fnFechaSinHora(t.FechaInicio) BETWEEN dbo.fnFechaSinHora(@Desde) AND dbo.fnFechaSinHora(@Hasta)
ORDER BY dbo.fnFechaSinHora(t.FechaInicio), dbo.fnFechaSinHora(t.FechaFin)
SELECT * FROM @Resultado
END

