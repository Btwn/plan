SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spWebAsistenciasPers
@Personal    Char(10),
@FechaD      Datetime,
@FechaA      Datetime,
@Empresa     Char(5)
AS BEGIN
SET NOCOUNT ON
SET DATEFIRST 7
DECLARE @Fecha      Datetime,
@Entrada    Char(5)
CREATE TABLE #AsistenciasPers (
Personal         Char(10) NULL,
Fecha            Datetime NULL,
HoraRegistroE    Char(5)  NULL,
HoraRegistroS    Char(5)  NULL,
Usuario          Char(10) NULL,
Comentarios      varChar(max) NULL,
Localidad     Varchar(50) NULL
)
SELECT @Fecha = @FechaD
WHILE @Fecha <= @FechaA
BEGIN
INSERT INTO #AsistenciasPers (Personal, Fecha) VALUES (@Personal, @Fecha)
SELECT @Fecha = DATEADD(DD, 1, @Fecha)
END
DELETE #AsistenciasPers
WHERE DATEPART(dw, Fecha) = 7 OR DATEPART(dw, Fecha) = 1
UPDATE #AsistenciasPers
SET HoraRegistroE = (SELECT MIN(HoraRegistro) FROM AsisteD, Asiste
WHERE Asiste.Id = AsisteD.Id
AND AsisteD.Personal = @Personal
AND CONVERT(Datetime, CONVERT(Varchar, AsisteD.FechaD, 102), 102) = #AsistenciasPers.Fecha
AND AsisteD.Registro = 'Entrada'
AND Asiste.Estatus <> 'CANCELADO'
AND Asiste.Mov IN ('Permiso Dias', 'Registro', 'Reporte Actividades', 'Actividades Extras', 'Registro por Periodo', 'Registro IAS')),
Comentarios = (SELECT MIN(Asiste.Mov) FROM AsisteD, Asiste
WHERE Asiste.Id = AsisteD.Id
AND AsisteD.Personal = @Personal
AND #AsistenciasPers.Fecha BETWEEN CONVERT(Datetime, CONVERT(Varchar, AsisteD.FechaD, 102), 102) AND CONVERT(Datetime, CONVERT(Varchar, AsisteD.FechaA, 102), 102)
AND Asiste.Estatus <> 'CANCELADO'
AND Asiste.Mov IN ('Permiso Dias', 'Registro', 'Reporte Actividades', 'Actividades Extras', 'Registro por Periodo', 'Registro IAS')),
Localidad = (SELECT MIN(Asiste.Localidad) FROM AsisteD
JOIN Asiste ON Asiste.Id = AsisteD.Id
AND Asiste.Mov IN ('Permiso Dias', 'Registro', 'Reporte Actividades', 'Actividades Extras', 'Registro por Periodo', 'Registro IAS')
AND Asiste.Estatus <> 'CANCELADO'
AND Asiste.Empresa IN (@Empresa, 'INTEL')
WHERE AsisteD.personal = @Personal
AND CONVERT(Datetime, CONVERT(Varchar,  AsisteD.FechaD, 102), 102) = #AsistenciasPers.Fecha
AND AsisteD.Registro = 'Entrada')
UPDATE #AsistenciasPers
SET HoraRegistroS = (SELECT MAX(HoraRegistro) FROM AsisteD, Asiste
WHERE Asiste.Id = AsisteD.Id
AND AsisteD.Personal = @Personal
AND CONVERT(Datetime, CONVERT(Varchar, AsisteD.FechaD, 102), 102) = #AsistenciasPers.Fecha
AND AsisteD.Registro = 'Salida'
AND Asiste.Estatus <> 'CANCELADO'
AND Asiste.Mov IN ('Permiso Dias', 'Registro', 'Reporte Actividades', 'Actividades Extras', 'Registro por Periodo', 'Registro IAS'))
UPDATE #AsistenciasPers
SET Comentarios = 'Dia festivo - ' + DiaFestivo.Concepto
FROM DiaFestivo, #AsistenciasPers
WHERE DiaFestivo.Fecha = #AsistenciasPers.Fecha
UPDATE #AsistenciasPers
SET Comentarios = NominaConcepto.Concepto
FROM Incidencia
JOIN IncidenciaD ON IncidenciaD.Id = Incidencia.Id
JOIN #AsistenciasPers ON #AsistenciasPers.Fecha = IncidenciaD.FechaAplicacion
JOIN NominaConcepto ON NominaConcepto.NominaConcepto = Incidencia.NominaConcepto
WHERE Incidencia.Personal = @Personal
AND Incidencia.NominaConcepto IN ('101', '255', '255C', '256', '257', '257T')
UPDATE #AsistenciasPers
SET Comentarios = NominaConcepto.Concepto
FROM Incidencia
JOIN IncidenciaD ON IncidenciaD.Id = Incidencia.Id
AND IncidenciaD.Cantidad > 0
AND IncidenciaD.Importe > 0
AND IncidenciaD.NominaConcepto In ('254')
JOIN #AsistenciasPers ON #AsistenciasPers.Fecha = IncidenciaD.FechaAplicacion
JOIN NominaConcepto ON NominaConcepto.NominaConcepto = IncidenciaD.NominaConcepto
WHERE Incidencia.Estatus in ('CONCLUIDO','PENDIENTE')
AND Incidencia.Personal = @Personal
UPDATE #AsistenciasPers
SET HoraRegistroE = '', HoraRegistroS = ''
WHERE RTRIM(Comentarios) = 'Permiso Dias'
DELETE #AsistenciasPers WHERE Fecha > getdate()
SELECT @Entrada = ISNULL(Entrada, '09:00')
FROM JornadaD
JOIN Personal ON Personal.Jornada = JornadaD.Jornada
AND Personal.Personal = @Personal
WHERE JornadaD.Logico3 = 1
SELECT Personal,
Fecha,
HoraRegistroE = ISNULL(HoraRegistroE, ''),
HoraRegistroS = ISNULL(HoraRegistroS, ''),
Lugar = ISNULL(Localidad, ''),
Retardo = CASE WHEN Comentarios = 'Registro' THEN IsNull(Datediff(n, @Entrada, HoraRegistroE), '')
ELSE 0 END,
Comentarios = ISNULL(Comentarios, '')
FROM #AsistenciasPers
SET NOCOUNT OFF
RETURN
END

