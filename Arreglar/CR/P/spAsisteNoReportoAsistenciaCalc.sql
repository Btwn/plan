SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spAsisteNoReportoAsistenciaCalc
@Estacion	int,
@Empresa	varchar(5),
@FechaD	DateTime,
@FechaA	DateTime,
@ReportaA	varchar(20),
@Sucursal	int	= NULL,
@EnviarMail	bit	= NULL,
@DBMailPerfil	varchar(50) = NULL

AS BEGIN
DECLARE @FechaDiaria			DateTime,
@FechaEmision			DateTime,
@Personal			varchar(10),
@Jornada			varchar(20),
@Estatus			varchar(20),
@DebeChecar			bit,
@EmpresaNombre		varchar(100),
@MensajePersonal		varchar(10),
@MensajeFecha			DateTime,
@Email			varchar(50),
@MensajePersonalActual	varchar(10),
@Mensaje			varchar(MAX),
@Titulo			varchar(100)
CREATE TABLE #PersonalCheca	(
Fecha		DateTime		NULL,
Personal	varchar(10) COLLATE Database_Default NULL,
Estatus		varchar(20) COLLATE Database_Default NULL,
DebeChecar	bit)
SELECT @EmpresaNombre = Nombre
FROM Empresa e
WHERE e.Empresa = @Empresa
SELECT r2.Personal,
r.FechaEmision,
r.Mov,
r.MovID,
r2.Jornada,
mt.Orden,
mt.Clave
INTO #PersonalHist
FROM RH r
INNER JOIN RHD r2 ON r.ID = r2.ID
INNER JOIN MovTipo mt ON r.Mov = mt.Mov
AND mt.Modulo = 'RH'
AND mt.Clave IN ('RH.A', 'RH.B', 'RH.M')
WHERE r.Estatus NOT IN ('CANCELADO', 'SINAFECTAR', 'BORRADOR')
AND r.Empresa = @Empresa
SELECT @FechaDiaria = @FechaD
WHILE @FechaDiaria <= @FechaA
BEGIN
DECLARE crPersonal CURSOR LOCAL FOR
SELECT p.Personal
FROM Personal p
ORDER BY p.Personal
OPEN crPersonal
FETCH NEXT FROM crPersonal INTO @Personal
WHILE @@FETCH_STATUS <> -1
BEGIN
IF @@FETCH_STATUS <> -2
BEGIN
SELECT @Jornada = NULL,
@Estatus = NULL,
@DebeChecar = 0
SELECT TOP(1) @Jornada = ph.Jornada,
@Estatus = CASE WHEN ph.Clave IN ('RH.A', 'RH.M') THEN 'ALTA'
ELSE 'BAJA'
END,
@DebeChecar = CASE WHEN ISNULL(jdf.EsLaborable, 1) = 1
THEN CASE ISNULL(@Estatus, 'BAJA')
WHEN 'BAJA' THEN 0
ELSE CASE DatePart(dw,@FechaDiaria)
WHEN 1 THEN CASE WHEN j.Domingo = 0 THEN 1
ELSE 0
END
WHEN 2 THEN CASE WHEN j.Lunes = 0 THEN 1
ELSE 0
END
WHEN 3 THEN CASE WHEN j.Martes = 0 THEN 1
ELSE 0
END
WHEN 4 THEN CASE WHEN j.Miercoles = 0 THEN 1
ELSE 0
END
WHEN 5 THEN CASE WHEN j.Jueves = 0 THEN 1
ELSE 0
END
WHEN 6 THEN CASE WHEN j.Viernes = 0 THEN 1
ELSE 0
END
WHEN 7 THEN CASE WHEN j.Sabado = 0 THEN 1
ELSE 0
END
END
END
ELSE 0
END
FROM #PersonalHist ph
LEFT OUTER JOIN Jornada j ON ph.Jornada = j.Jornada
LEFT OUTER JOIN JornadaDiaFestivo jdf ON j.Jornada = jdf.Jornada
AND jdf.Fecha = @FechaDiaria
WHERE ph.FechaEmision <= @FechaDiaria
AND ph.Personal = @Personal
ORDER BY ph.FechaEmision DESC,
ph.Orden DESC
IF @Estatus is NULL SELECT @Estatus = 'BAJA'
INSERT #PersonalCheca (Fecha,        Personal,  Estatus,  DebeChecar)
SELECT @FechaDiaria, @Personal, @Estatus, @DebeChecar
END
FETCH NEXT FROM crPersonal INTO @Personal
END
CLOSE crPersonal
DEALLOCATE crPersonal
SELECT @FechaDiaria = @FechaDiaria + 1
END;
WITH AsistePersonalCorte(FechaEmision, Personal)
AS
(SELECT a.FechaEmision,
ad.Personal
FROM Asiste a
INNER JOIN AsisteD ad ON a.ID = ad.ID
AND ad.Registro = 'Entrada'
INNER JOIN Personal p ON ad.Personal = p.Personal
INNER JOIN MovTipo mt ON mt.Modulo = 'ASIS'
AND mt.Mov = a.Mov
AND mt.Clave = 'ASIS.R'
WHERE a.Estatus NOT IN ('CANCELADO', 'SINAFECTAR', 'BORRADOR')
AND a.FechaEmision BETWEEN @FechaD AND @FechaA
AND a.Empresa = @Empresa)
SELECT pc.Fecha,
pc.Personal,
Checo = CASE WHEN MAX(apc.Personal) IS NOT NULL THEN 1
ELSE 0
END
INTO #PersonalnoChecoCalc
FROM #PersonalCheca pc
LEFT OUTER JOIN AsistePersonalCorte apc ON apc.Personal = pc.Personal
AND apc.FechaEmision = pc.Fecha
WHERE pc.DebeChecar = 1
GROUP BY pc.Fecha,
pc.Personal
ORDER BY pc.Personal,
pc.Fecha
SELECT pnc.Fecha,
pnc.Personal,
p.Nombre,
p.ApellidoPaterno,
p.ApellidoMaterno,
p.Empresa,
p.SucursalTrabajo,
Supervisor = p.ReportaA,
SupervisorNombre = p2.Nombre + ' ' + p2.ApellidoPaterno + ' ' + p2.ApellidoMaterno,
FechaD = @FechaD,
FechaA = @FechaA
INTO #PersonalnoCheco
FROM #PersonalnoChecoCalc pnc
INNER JOIN Personal p ON pnc.Personal = p.Personal
LEFT OUTER JOIN Personal p2 ON p.ReportaA = p2.Personal
WHERE pnc.Checo = 0
AND ((p.SucursalTrabajo = @Sucursal) OR (@Sucursal is NULL))
ORDER BY pnc.Personal,
pnc.Fecha
IF ISNULL(@EnviarMail,0) = 0
SELECT *
FROM #PersonalnoCheco pnc
WHERE ISNULL(pnc.Supervisor,'') = ISNULL(NULLIF(@ReportaA,''), ISNULL(pnc.Supervisor,''))
ORDER BY ISNULL(pnc.Supervisor, ''),
pnc.Personal
IF ISNULL(@EnviarMail,0) = 1
BEGIN
DECLARE crMail CURSOR LOCAL FOR
SELECT pnc.Personal,
p.eMail,
pnc.Fecha
FROM #PersonalNoCheco pnc
INNER JOIN Personal p ON pnc.personal = p.Personal
OPEN crMail
FETCH NEXT FROM crMail INTO @MensajePersonal, @Email, @MensajeFecha
SELECT @Mensaje = 'Nuestros Registros Muestran que usted no checó asistencia el(los) dia(s)'
SELECT @Titulo = 'Registro de No Asistencia a ' + @EmpresaNombre
WHILE @@FETCH_STATUS <> -1
BEGIN
IF @@FETCH_STATUS <> -2
BEGIN
IF @MensajePersonalActual <> @MensajePersonal
BEGIN
IF @Email LIKE '%@%' 
BEGIN
EXEC msdb.dbo.sp_send_dbmail
@profile_name =@DBMailPerfil,
@recipients=@Email,
@subject = @Titulo,
@body = @Mensaje,
@body_format = 'HTML'
END
ELSE
SELECT @Mensaje = 'Nuestros Registros Muestran que usted no checó asistencia el(los) dia(s)'
END
SELECT @MensajePersonalActual = @MensajePersonal
SELECT @Mensaje = @Mensaje + ', ' + CONVERT(varchar, @MensajeFecha, 102)
END
FETCH NEXT FROM crMail INTO @MensajePersonal, @Email, @MensajeFecha
END
CLOSE crMail
DEALLOCATE crMail
END
END

