SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spRepPersonalKardex
@Estacion		int

AS BEGIN
DECLARE @Empresa		char(5),
@PersonalD		varchar(10),
@PersonalA		varchar(10),
@FechaD			datetime,
@FechaA			datetime,
@FechaEmision	datetime,
@Personal		varchar(10),
@HoraEntrada	char(5),
@HoraSalida		char(5),
@EmpresaCursor	char(5)
SELECT @Empresa = rp.InfoEmpresa,
@PersonalD = rp.InfoPersonalD,
@PersonalA = rp.InfoPersonalA,
@FechaD = rp.InfoFechaD,
@FechaA = rp.InfoFechaA
FROM RepParam rp
WHERE rp.Estacion = @Estacion
CREATE TABLE #KardexPersonal (
Empresa			char(5)			COLLATE Database_Default null,
FechaEmision	datetime		null,
Personal		varchar(10)		COLLATE Database_Default null,
Nombre			varchar(100)	COLLATE Database_Default null,
Tipo			varchar(20)		COLLATE Database_Default null,
Departamento	varchar(50)		COLLATE Database_Default null,
Puesto			varchar(50)		COLLATE Database_Default null,
SDI				money			null,
SueldoDiario	money			null,
Moneda			varchar(10)		COLLATE Database_Default null,
Jornada			varchar(20)		COLLATE Database_Default null,
Entrada			char(5)			null,
Salida			char(5)			null)
IF @PersonalD IN ('','(Todos)','(Todas)','NULL', NULL) SELECT @PersonalD = MIN(Personal) FROM Personal
IF @PersonalA IN ('','(Todos)','(Todas)','NULL', NULL) SELECT @PersonalA = MAX(Personal) FROM Personal
INSERT #KardexPersonal
SELECT a.Empresa,
a.FechaEmision,
ad.Personal,
Nombre = p.Nombre + ' ' + p.ApellidoPaterno + ' ' + p.ApellidoMaterno,
p.Tipo,
p.Departamento,
p.Puesto,
p.SDI,
p.SueldoDiario,
p.Moneda,
p.Jornada,
NULL,
NULL
FROM Asiste a
INNER JOIN AsisteD ad ON a.ID = ad.ID
INNER JOIN Personal p ON ad.Personal = p.Personal
INNER JOIN MovTipo mt ON a.Mov = mt.Mov
AND mt.Modulo = 'ASIS'
AND mt.Clave = 'ASIS.R'
WHERE a.Empresa = @Empresa
AND a.FechaEmision BETWEEN @FechaD AND @FechaA
AND ad.Personal BETWEEN @PersonalD AND @PersonalA
AND a.Estatus NOT IN ('CANCELADO', 'SINAFECTAR')
GROUP BY a.Empresa,
a.FechaEmision,
ad.Personal,
p.Nombre,
p.ApellidoPaterno,
p.ApellidoMaterno,
p.Tipo,
p.Departamento,
p.Puesto,
p.SDI,
p.SueldoDiario,
p.Moneda,
p.Jornada
DECLARE crKardexPersonal CURSOR LOCAL FOR
SELECT Empresa,
FechaEmision,
Personal
FROM #KardexPersonal
OPEN crKardexPersonal
FETCH NEXT FROM crKardexPersonal INTO @EmpresaCursor, @FechaEmision, @Personal
WHILE @@FETCH_STATUS <> -1
BEGIN
IF @@FETCH_STATUS <> -2
BEGIN
SELECT @HoraEntrada = MIN(ad.HoraRegistro)
FROM Asiste a
INNER JOIN AsisteD ad ON a.ID = ad.ID
WHERE a.Empresa = @EmpresaCursor
AND a.FechaEmision = @FechaEmision
AND ad.Personal = @Personal
AND ad.Registro = 'Entrada'
SELECT @HoraSalida = MAX(ad.HoraRegistro)
FROM Asiste a
INNER JOIN AsisteD ad ON a.ID = ad.ID
WHERE a.Empresa = @EmpresaCursor
AND a.FechaEmision = @FechaEmision
AND ad.Personal = @Personal
AND ad.Registro = 'Salida'
UPDATE #KardexPersonal SET Entrada = @HoraEntrada
WHERE Empresa = @EmpresaCursor
AND FechaEmision = @FechaEmision
AND Personal = @Personal
UPDATE #KardexPersonal SET Salida = @HoraSalida
WHERE Empresa = @EmpresaCursor
AND FechaEmision = @FechaEmision
AND Personal = @Personal
END
FETCH NEXT FROM crKardexPersonal INTO @EmpresaCursor, @FechaEmision, @Personal
END
CLOSE crKardexPersonal
DEALLOCATE crKardexPersonal
SELECT *
FROM #KardexPersonal
ORDER BY Personal,
FechaEmision
END

