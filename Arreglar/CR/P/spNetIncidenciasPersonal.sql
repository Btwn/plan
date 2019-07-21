SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE dbo.spNetIncidenciasPersonal
@Personal		varchar(10),
@FechaD		datetime = NULL,
@FechaA		datetime = NULL
AS BEGIN
DECLARE @TablaMES TABLE (Fecha DATETIME)
DECLARE @TablaDiasLaborables TABLE (Fecha datetime)
DECLARE @TablaJornada TABLE (
Personal		varchar(10),
Jornada		varchar(20),
Dia			int,
Entrada		varchar(5))
DECLARE @TablaIncidencias TABLE (
ID			int,
Renglon		float,
MovClave		varchar(20),
Mov			varchar(20),
MovID			varchar(20),
Personal		varchar(10),
Registro		varchar(25),
HoraRegistro	varchar(5),
HoraD			time,
HoraA			time,
FechaD		datetime,
FechaA		datetime,
Concepto		varchar(50),
Incidencia	varchar(50),
Observaciones varchar(100))
DECLARE @TablaRegistros TABLE (
ID			int,
Renglon		float,
MovClave		varchar(20),
Mov			varchar(20),
MovID			varchar(20),
Personal		varchar(10),
Registro		varchar(25),
HoraRegistro	varchar(5),
HoraD			time,
HoraA			time,
FechaD		datetime,
FechaA		datetime,
Concepto		varchar(50),
Incidencia	varchar(50),
Observaciones varchar(100))
DECLARE @PrepFinal TABLE(
ID			int identity(1,1),
Registro		varchar(255),
Concepto		varchar(255),
Incidencia	varchar(255),
FechaD		datetime,
FechaA		datetime)
DECLARE @Final TABLE(
id			int identity(1,1),
title			varchar(255),
className		varchar(255),
start			datetime,
[end]			datetime)
DECLARE
@FirstDOM			datetime,
@LastDOM			datetime,
@MinDate			date,
@MaxDate			date,
@I_ID				int,
@I_Renglon		float,
@I_MovClave		varchar(20),
@I_Mov			varchar(20),
@I_MovID			varchar(20),
@I_Personal		varchar(10),
@I_Registro		varchar(10),
@I_HoraRegistro	varchar(5),
@I_HoraD			time,
@I_HoraA			time,
@I_FechaD			datetime,
@I_FechaA			datetime,
@I_Concepto		varchar(50),
@I_Incidencia		varchar(50),
@I_Observaciones  varchar(100),
@FIni				datetime,
@FFin				datetime,
@FechaIncidencia	datetime,
@R_Fecha			datetime,
@R_ID				int,
@R_Renglon		float,
@R_MovClave		varchar(20),
@R_Mov			varchar(20),
@R_MovID			varchar(20),
@R_Personal		varchar(10),
@R_Registro		varchar(10),
@R_HoraRegistro	varchar(5),
@R_HoraD			time,
@R_HoraA			time,
@R_FechaD			datetime,
@R_FechaA			datetime,
@R_Concepto		varchar(50),
@R_Incidencia		varchar(50),
@R_Observaciones	varchar(100),
@FR				datetime,
@Dia_W			int,
@HR				time,
@HR1				time,
@HR2				time,
@time_2			time,
@time_1			time,
@time_Acceso		int,
@time_ToletenciaEntrada int,
@Empresa			varchar(5),
@Jornada			varchar(20),
@ID				int,
@Fecha			datetime,
@Incidencia		varchar(255),
@title			varchar(255),
@classN			varchar(355)
SELECT @Empresa = Empresa, @Jornada = Jornada FROM Personal WHERE Personal = @Personal
SELECT @time_ToletenciaEntrada = AsisteToleraEntrada FROM EmpresaCfg WHERE Empresa = @Empresa
IF @FechaD IS NULL
SELECT @FechaD = MIN(Fecha) FROM JornadaTiempo WHERE Jornada = @Jornada
IF @FechaA IS NULL
SELECT @FechaA = MAX(Fecha) FROM JornadaTiempo WHERE Jornada = @Jornada
SELECT @MinDate = @FechaD, @MaxDate = @FechaA
INSERT INTO @TablaMES
SELECT TOP (DATEDIFF(DAY, @MinDate, @MaxDate) + 1)
Date = DATEADD(DAY, ROW_NUMBER() OVER(ORDER BY a.object_id) - 1, @MinDate)
FROM sys.all_objects a
CROSS JOIN sys.all_objects b;
INSERT INTO @TablaIncidencias
SELECT a.ID, ad.Renglon, mt.Clave, a.Mov,a.MovID,ad.Personal,ad.Registro,ad.HoraRegistro,ad.HoraD,ad.HoraA,ad.FechaD,ad.FechaA,ad.Concepto, NULL,a.Observaciones
FROM Asiste a
JOIN AsisteD ad ON a.ID = ad.ID
JOIN MovTipo mt ON 'ASIS' = mt.Modulo AND a.Mov = mt.Mov
WHERE mt.Clave NOT IN ('ASIS.R','ASIS.A','ASIS.C', 'ASIS.RA')
AND a.Estatus NOT IN ('SINAFECTAR','CANCELADO')
AND dbo.fnFechaSinHora(ad.FechaD) BETWEEN @FechaD AND @FechaA
AND ad.Personal = @Personal
INSERT INTO @TablaRegistros
SELECT a.ID, ad.Renglon, mt.Clave, a.Mov,a.MovID,ad.Personal,ad.Registro,ad.HoraRegistro,ad.HoraD,ad.HoraA,ad.FechaD,ad.FechaA,ad.Concepto, NULL,a.Observaciones
FROM Asiste a
JOIN AsisteD ad ON a.ID = ad.ID
JOIN MovTipo mt ON 'ASIS' = mt.Modulo AND a.Mov = mt.Mov
WHERE mt.Clave IN ('ASIS.R','ASIS.A')
AND a.Estatus NOT IN ('SINAFECTAR','CANCELADO')
AND dbo.fnFechaSinHora(ad.FechaD) BETWEEN @FechaD AND @FechaA
AND ad.Personal = @Personal
INSERT INTO @TablaJornada
SELECT p.Personal, j.Jornada,jd.Dia,MIN(jd.Entrada) Entrada
FROM Personal p
JOIN Jornada j ON p.Jornada = j.Jornada
JOIN JornadaD jd ON j.Jornada = jd.Jornada
WHERE p.Personal = @Personal
GROUP BY p.Personal, j.Jornada,jd.Dia
INSERT INTO @TablaDiasLaborables
SELECT Fecha FROM @TablaMES WHERE DATEPART(dw,CONVERT(DATE,Fecha-1)) IN (SELECT Dia FROM @TablaJornada)
DECLARE db_cursor CURSOR FOR
SELECT ID, Renglon, MovClave, Mov,MovID,Personal,Registro,HoraRegistro,HoraA, FechaD,FechaD,FechaA,Concepto, Incidencia,Observaciones FROM @TablaIncidencias
OPEN db_cursor
FETCH NEXT FROM db_cursor INTO @I_ID, @I_Renglon, @I_MovClave, @I_Mov,@I_MovID,@I_Personal,@I_Registro, @I_HoraRegistro,@I_HoraD,@I_HoraA, @I_FechaD, @I_FechaA,@I_Concepto,@I_Incidencia,@I_Observaciones
WHILE @@FETCH_STATUS = 0
BEGIN
SELECT @FIni = NULL, @FFin = NULL, @FechaIncidencia = NULL
SELECT @FIni = FechaD, @FFin = FechaA  FROM @TablaIncidencias WHERE ID = @I_ID
INSERT INTO @TablaRegistros
SELECT @I_ID AS ID, @I_Renglon AS Renglon, @I_MovClave AS MovClave, @I_Mov AS Mov,@I_MovID as MovID,@I_Personal as Personal,@I_Registro as Registro, @I_HoraRegistro as HoraRegistro,@I_HoraD as HoraD,@I_HoraA as HoraA, Fecha,Fecha,@I_Concepto as Concepto, '' as Incidencia, @I_Observaciones as Observaciones
FROM @TablaMES
WHERE DATEPART( dw,Fecha-1) IN (SELECT Dia FROM @TablaJornada) AND Fecha BETWEEN  @FIni AND @FFin
IF @I_MovClave IN ('ASIS.AU')
UPDATE @TablaRegistros SET Concepto = 'Ausente', Registro = 'Ausente' WHERE ID = @I_ID AND Mov = @I_Mov AND Personal = @I_Personal AND MovClave IN ('ASIS.AU')
IF @I_MovClave IN ('ASIS.PD', 'ASIS.PH')
UPDATE @TablaRegistros SET Incidencia = 'Justificado', Registro = 'Justificado' WHERE ID = @I_ID AND Mov = @I_Mov AND Personal = @I_Personal AND MovClave IN ('ASIS.PD', 'ASIS.PH')
ELSE
UPDATE @TablaRegistros SET Incidencia = Concepto WHERE ID = @I_ID AND Mov = @I_Mov AND Personal = @I_Personal
IF @I_MovClave IN ('ASIS.PH') AND DATEPART(dw,@FIni -1) NOT IN (SELECT Dia FROM @TablaJornada)
INSERT INTO @TablaRegistros
SELECT @I_ID AS ID, @I_Renglon AS Renglon, @I_MovClave AS MovClave, @I_Mov AS Mov,@I_MovID as MovID,@I_Personal as Personal,'Fuera de Jornada Laboral' as Registro, @I_HoraRegistro as HoraRegistro,@I_HoraD as HoraD,@I_HoraA as HoraA, Fecha,Fecha,@I_Concepto as Concepto, 'Fuera de Jornada Laboral' as Incidencia, @I_Observaciones as Observaciones
FROM @TablaMES
WHERE DATEPART(dw,Fecha-1) NOT IN (SELECT Dia FROM @TablaJornada) AND Fecha BETWEEN  @FIni AND @FFin
FETCH NEXT FROM db_cursor INTO @I_ID, @I_Renglon, @I_MovClave, @I_Mov,@I_MovID,@I_Personal,@I_Registro, @I_HoraRegistro,@I_HoraD,@I_HoraA, @I_FechaD, @I_FechaA,@I_Concepto,@I_Incidencia,@I_Observaciones
END
CLOSE db_cursor
DEALLOCATE db_cursor
DECLARE db_cursor_reg CURSOR FOR
SELECT * FROM @TablaDiasLaborables tdl LEFT OUTER JOIN @TablaRegistros tr ON tdl.Fecha = tr.FechaD ORDER BY Fecha,FechaD, ID DESC
OPEN db_cursor_reg
FETCH NEXT FROM db_cursor_reg INTO @R_Fecha,@R_ID, @R_Renglon, @R_MovClave, @R_Mov,@R_MovID,@R_Personal,@R_Registro, @R_HoraRegistro,@R_HoraD,@R_HoraA, @R_FechaD, @R_FechaA,@R_Concepto,@R_Incidencia,@R_Observaciones
WHILE @@FETCH_STATUS = 0
BEGIN
SELECT @FR = NULL, @Dia_W = NULL, @HR = NULL, @HR1 = NULL, @HR2 = NULL,@time_2 = NULL, @time_1 = NULL, @time_Acceso = NULL
IF @R_MovClave = 'ASIS.A'
BEGIN
SET @HR1 = @R_HoraD
SET @HR2 = @R_HoraA
UPDATE @TablaRegistros SET Registro = 'Entrada', HoraRegistro = @R_HoraD
WHERE MovClave = 'ASIS.A' AND  ID = @R_ID AND Renglon = @R_Renglon
INSERT INTO @TablaRegistros
SELECT 0, 0, @R_MovClave,@R_Mov,@R_MovID,@R_Personal,'Salida', @HR2,@HR1,@HR2 , @R_FechaD , @R_FechaA ,@R_Concepto,'Asistencia',@R_Observaciones
END
SET @time_2 = @R_HoraRegistro
SELECT @Dia_W =(DATEPART(dw,tr.FechaD) -1), @FR = tr.FechaD ,@HR =  tr.HoraRegistro FROM @TablaRegistros tr WHERE tr.ID = @R_ID AND tr.MovClave = 'ASIS.R'
SELECT @time_1 = Entrada FROM @TablaJornada WHERE Dia = @Dia_W
IF @time_2 >= @time_1
SELECT @time_Acceso = DATEDIFF(mi, @time_1,@time_2)
ELSE IF @time_2 < @time_1
SELECT @time_Acceso = DATEDIFF(mi,@time_2,@time_1)
IF  @time_Acceso > ISNULL(@time_ToletenciaEntrada,0) AND @R_MovClave IN ('ASIS.R','ASIS.A')  AND @R_Registro = 'Entrada'
BEGIN
UPDATE @TablaRegistros SET Concepto = 'Retardo'
WHERE ID = @R_ID AND Mov = @R_Mov AND Personal = @R_Personal AND MovClave IN ('ASIS.R','ASIS.A') AND Registro = 'Entrada'
AND HoraRegistro IN (SELECT TOP 1 HoraRegistro FROM @TablaRegistros
WHERE MovClave IN ('ASIS.R','ASIS.A') AND Registro = 'Entrada'
AND FechaD = @R_FechaD AND Personal = @R_Personal ORDER BY ID)
END
ELSE IF @time_Acceso <= ISNULL(@time_ToletenciaEntrada,0) IF @R_MovClave IN ('ASIS.R','ASIS.A')
BEGIN
UPDATE @TablaRegistros SET Incidencia = 'Asistencia'
WHERE ID = @R_ID AND Mov = @R_Mov AND Personal = @R_Personal AND MovClave IN ('ASIS.R','ASIS.A') AND Registro = 'Entrada'
AND HoraRegistro IN (SELECT TOP 1 HoraRegistro FROM @TablaRegistros
WHERE MovClave IN ('ASIS.R','ASIS.A') AND Registro = 'Entrada'
AND FechaD = @R_FechaD AND Personal = @R_Personal ORDER BY ID)
END
IF @R_ID IS NULL AND @R_Fecha IS NOT NULL AND @R_Fecha NOT IN (SELECT Fecha FROM JornadaDiaFestivo WHERE Fecha = @R_Fecha) AND @R_Fecha <= GETDATE()
INSERT INTO @TablaRegistros SELECT 0, 0, '', 'Falta',NULL,@R_Personal,'Falta',CONVERT(TIME,GETDATE()),@R_HoraD,@R_HoraA,@R_Fecha,@R_Fecha,'Falta', 'Falta',@R_Observaciones
ELSE IF @R_ID IS NULL AND @R_Fecha IS NOT NULL AND @R_Fecha IN (SELECT Fecha FROM JornadaDiaFestivo WHERE Fecha = @R_Fecha)
INSERT INTO @TablaRegistros SELECT 0, 0, '','Día Festivo',NULL,@R_Personal,'Festivo',CONVERT(TIME,GETDATE()),@R_HoraD,@R_HoraA,@R_Fecha,@R_Fecha,'Día Festivo','Día Festivo',@R_Observaciones
FETCH NEXT FROM db_cursor_reg INTO @R_Fecha,@R_ID, @R_Renglon, @R_MovClave, @R_Mov,@R_MovID,@R_Personal,@R_Registro, @R_HoraRegistro,@R_HoraD,@R_HoraA, @R_FechaD, @R_FechaA,@R_Concepto,@R_Incidencia,@R_Observaciones
END
CLOSE db_cursor_reg
DEALLOCATE db_cursor_reg
UPDATE @TablaRegistros SET Incidencia = Concepto WHERE ISNULL(Incidencia,'') = ''
INSERT INTO @PrepFinal(Registro, Concepto, Incidencia, FechaD, FechaA)
SELECT
CASE
WHEN tr.ID IS NULL AND tr.MovClave IS NULL THEN 'No Laborable'
WHEN tr.ID IS NOT NULL AND tr.MovClave IS NOT NULL THEN tr.Registro
END Registro,
tr.Concepto,
CASE
WHEN ID IS NULL AND MovClave IS NULL THEN 'No Laborable'
WHEN ID IS NOT NULL AND MovClave IS NOT NULL THEN tr.Incidencia
END Incidencia,
DATEADD(HOUR,CONVERT(int,LEFT(tr.HoraRegistro, 2)), DATEADD(MINUTE,CONVERT(int,RIGHT(tr.HoraRegistro, 2)),tr.FechaD)) FechaD,
DATEADD(HOUR,CONVERT(int,LEFT(tr.HoraRegistro, 2)), DATEADD(MINUTE,CONVERT(int,RIGHT(tr.HoraRegistro, 2)),tr.FechaA)) FechaA
FROM @TablaMES tdl LEFT OUTER JOIN @TablaRegistros tr ON tdl.Fecha = tr.FechaD
WHERE tr.FechaD IS NOT NULL
ORDER BY DATEADD(HOUR,CONVERT(int,LEFT(tr.HoraRegistro, 2)), DATEADD(MINUTE,CONVERT(int,RIGHT(tr.HoraRegistro, 2)),tr.FechaD)), ID
SELECT @Fecha = MIN(dbo.fnFechaSinHora(FechaD)) FROM @PrepFinal
WHILE @Fecha IS NOT NULL
BEGIN
SELECT @Incidencia = NULL, @title = NULL
SELECT TOP 1 @Incidencia = Incidencia, @title = Concepto FROM @PrepFinal WHERE dbo.fnFechaSinHora(FechaD) = @Fecha AND ISNULL(Incidencia,'') <> ''
SELECT @classN = CASE ISNULL(@Incidencia,'')
WHEN 'Día Festivo' THEN 'diafestivo labelE'
WHEN 'Ausente' THEN 'falta labelE'
WHEN 'Fuera de Jornada Laboral' THEN 'domingo labelE'
WHEN 'Asistencia' THEN 'asistencia labelE'
WHEN 'Retardo' THEN 'retardo labelE'
WHEN 'Justificado' THEN 'justificado labelE'
WHEN 'Falta' THEN 'falta labelE'
END
IF ISNULL(@title,'') = '' SELECT @title = @Incidencia
IF ISNULL(@title,'') = ''
INSERT INTO @Final (title, className, start, [end]) SELECT Registro, NULL, FechaD, FechaA FROM @PrepFinal WHERE dbo.fnFechaSinHora(FechaD) = @Fecha
ELSE
INSERT INTO @Final (title, className, start, [end]) SELECT @title, @classN, @Fecha, NULL
IF ((SELECT COUNT(1) FROM @PrepFinal WHERE dbo.fnFechaSinHora(FechaD) = @Fecha AND ISNULL(Incidencia,'') = '') >= 1) AND
((SELECT COUNT(1) FROM @PrepFinal WHERE dbo.fnFechaSinHora(FechaD) = @Fecha AND ISNULL(Incidencia,'') <> '') >= 1)
INSERT INTO @Final (title, className, start, [end]) SELECT Registro, NULL, FechaD, FechaA FROM @PrepFinal WHERE dbo.fnFechaSinHora(FechaD) = @Fecha
SELECT @Fecha = MIN(dbo.fnFechaSinHora(FechaD)) FROM @PrepFinal WHERE dbo.fnFechaSinHora(FechaD) > @Fecha
END
SELECT * FROM @Final
RETURN
END

