SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spVerPersonalCosto
@Personal        char(20),
@TipoCambio      float,
@FechaEmision    datetime = NULL

AS BEGIN
DECLARE
@Dias     	int,
@DiasLibres int,
@Anio     	int,
@Mes      	int,
@FechaIni 	datetime,
@FechaFin 	datetime,
@Jornada  	varchar(20),
@Costo1   	float,
@Costo2   	float,
@Costo3   	float
IF @FechaEmision IS NULL SELECT @FechaEmision = GETDATE()
SELECT @Anio    = YEAR(@FechaEmision), @Mes = MONTH(@FechaEmision)
SELECT @Jornada = Jornada FROM Personal WHERE Personal = @Personal
EXEC spDiasMes @Mes, @Anio, @Dias OUTPUT
EXEC spIntToDateTime 1,     @Mes, @Anio, @FechaIni OUTPUT
EXEC spIntToDateTime @Dias, @Mes, @Anio, @FechaFin OUTPUT
EXEC spJornadaDiasLibres @Jornada, @FechaIni, @FechaFin, @DiasLibres OUTPUT
SELECT @Costo1 = SUM(CASE WHEN d.Concepto = 'Credito al Salario'
THEN -1
ELSE 1
END * d.Importe * m.TipoCambio / j.HorasPromedio) / (@Dias - @DiasLibres) / @TipoCambio
FROM Nomina   n
JOIN NominaD  d ON d.ID       = n.ID
JOIN Personal p ON p.Personal = d.Personal
JOIN Jornada  j ON j.Jornada  = p.Jornada
JOIN Mon      m ON m.Moneda   = n.Moneda
WHERE d.Concepto IN ('Total Percepciones',
'Impuesto Estatal',
'IMSS Patron',
'Infonavit',
'Retiro y Cesantia',
'Credito al Salario')
AND n.Estatus  =   'CONCLUIDO'
AND d.Personal =   @Personal
AND n.FechaD       BETWEEN @FechaIni AND @FechaFin
SELECT @FechaIni = DATEADD(m,-1,@FechaIni)
SELECT @Anio     = YEAR(@FechaIni), @Mes = MONTH(@FechaIni)
EXEC spDiasMes @Mes, @Anio, @Dias OUTPUT
EXEC spIntToDateTime @Dias, @Mes, @Anio, @FechaFin OUTPUT
EXEC spJornadaDiasLibres @Jornada, @FechaIni, @FechaFin, @DiasLibres OUTPUT
SELECT @Costo2 = SUM(CASE WHEN d.Concepto = 'Credito al Salario'
THEN -1
ELSE 1
END * d.Importe * m.TipoCambio / j.HorasPromedio) / (@Dias - @DiasLibres) / @TipoCambio
FROM Nomina   n
JOIN NominaD  d ON d.ID       = n.ID
JOIN Personal p ON p.Personal = d.Personal
JOIN Jornada  j ON j.Jornada  = p.Jornada
JOIN Mon      m ON m.Moneda   = n.Moneda
WHERE d.Concepto IN ('Total Percepciones',
'Impuesto Estatal',
'IMSS Patron',
'Infonavit',
'Retiro y Cesantia',
'Credito al Salario')
AND n.Estatus  =   'CONCLUIDO'
AND d.Personal =   @Personal
AND n.FechaD       BETWEEN @FechaIni AND @FechaFin
SELECT @Costo3 = (SUM(p.SueldoDiario * m.TipoCambio / j.HorasPromedio) / @TipoCambio ) * 1.25
FROM Personal p
JOIN Jornada  j ON j.Jornada = p.Jornada
JOIN Mon      m ON m.Moneda  = p.Moneda
WHERE p.Personal = @Personal
IF @Costo1 >= @Costo2 AND @Costo1 >= @Costo3
SELECT "Costo" = @Costo1
ELSE
IF @Costo2 >= @Costo3 AND @Costo2 >= @Costo1
SELECT "Costo" = @Costo2
ELSE
SELECT "Costo" = @Costo3
RETURN
END

