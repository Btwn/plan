SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE [dbo].[spVerMinutosTiempoExtra2]
@ID			int,
@Empresa	varchar(5),
@FechaD		datetime,
@FechaA		datetime,
@BorraTabla bit

AS BEGIN
DECLARE
@SQL		varchar(max),
@Dias		varchar(max),
@Insert		varchar(max),
@cNum		int,
@cDia		varchar(10),
@cFechaD	varchar(10),
@cFechaA	varchar(10),
@Semana		int,
@DiaSem		int,
@S1D6       datetime,
@S2D6       datetime,
@S1D7       datetime,
@S2D7       datetime,
@Idt        int
IF EXISTS(SELECT * FROM AuxAsistenciaHE WHERE ID = @ID AND Estatus <> 'SINAFECTAR')
BEGIN
RETURN
END
SELECT * FROM AuxAsistenciaHE
IF @BorraTabla = 0
BEGIN
DECLARE @TABLE TABLE
(
Id    Int,
Fecha varchar(10),
DiaS  Int
)
INSERT INTO @TABLE (Id, Fecha, DiaS)
SELECT ROW_NUMBER() OVER(ORDER BY Fecha ASC),
CONVERT(varchar(10),B.Fecha,105),
CASE WHEN DATEPART(dw, B.Fecha) = 1 THEN 1
WHEN DATEPART(dw, B.Fecha) = 2 THEN 2
WHEN DATEPART(dw, B.Fecha) = 3 THEN 3
WHEN DATEPART(dw, B.Fecha) = 4 THEN 4
WHEN DATEPART(dw, B.Fecha) = 5 THEN 5
WHEN DATEPART(dw, B.Fecha) = 6 THEN 6
ELSE 7 END
FROM Asiste A
JOIN AsisteD B
ON A.ID = B.ID
JOIN MovTipo C
ON A.Mov = C.Mov
WHERE C.Clave = 'ASIS.C'
AND A.Empresa = @Empresa
AND A.FechaD  = @FechaD
AND A.FechaA  = @FechaA
AND A.Estatus <> 'CANCELADO'
GROUP BY Fecha
IF NOT EXISTS (SELECT * FROM @TABLE WHERE DiaS = 6)
BEGIN
SELECT @Idt = COUNT(*) FROM @TABLE
SELECT @S1D6 = DATEADD (DAY,1,FECHA)
FROM @TABLE
WHERE dias = 5
ORDER BY FECHA ASC
INSERT INTO @TABLE (Id, Fecha, DiaS)
SELECT @Idt + 1, @S1D6, CASE  WHEN DATEPART(dw, @S1D6) = 1 THEN 1
WHEN DATEPART(dw, @S1D6) = 2 THEN 2
WHEN DATEPART(dw, @S1D6) = 3 THEN 3
WHEN DATEPART(dw, @S1D6) = 4 THEN 4
WHEN DATEPART(dw, @S1D6) = 5 THEN 5
WHEN DATEPART(dw, @S1D6) = 6 THEN 6
ELSE 7 END
SELECT @Idt = COUNT(*) FROM @TABLE
SELECT @S2D6 = DATEADD (DAY,1,FECHA)
FROM @TABLE
WHERE dias = 5
ORDER BY FECHA DESC
INSERT INTO @TABLE (Id, Fecha, DiaS)
SELECT @Idt + 1, @S2D6, CASE  WHEN DATEPART(dw, @S2D6) = 1 THEN 1
WHEN DATEPART(dw, @S2D6) = 2 THEN 2
WHEN DATEPART(dw, @S2D6) = 3 THEN 3
WHEN DATEPART(dw, @S2D6) = 4 THEN 4
WHEN DATEPART(dw, @S2D6) = 5 THEN 5
WHEN DATEPART(dw, @S2D6) = 6 THEN 6
ELSE 7 END
END
IF NOT EXISTS (SELECT * FROM @TABLE WHERE DiaS = 7)
BEGIN
SELECT @Idt = COUNT(*) FROM @TABLE
SELECT @S1D7 = DATEADD (DAY,1,FECHA)
FROM @TABLE
WHERE dias = 6
ORDER BY FECHA ASC
INSERT INTO @TABLE (Id, Fecha, DiaS)
SELECT @Idt + 1, @S1D7, CASE  WHEN DATEPART(dw, @S1D7) = 1 THEN 1
WHEN DATEPART(dw, @S1D7) = 2 THEN 2
WHEN DATEPART(dw, @S1D7) = 3 THEN 3
WHEN DATEPART(dw, @S1D7) = 4 THEN 4
WHEN DATEPART(dw, @S1D7) = 5 THEN 5
WHEN DATEPART(dw, @S1D7) = 6 THEN 6
ELSE 7 END
SELECT @Idt = COUNT(*) FROM @TABLE
SELECT @S2D7 = DATEADD (DAY,1,FECHA)
FROM @TABLE
WHERE dias = 6
ORDER BY FECHA DESC
INSERT INTO @TABLE (Id, Fecha, DiaS)
SELECT @Idt + 1, @S2D7, CASE  WHEN DATEPART(dw, @S2D7) = 1 THEN 1
WHEN DATEPART(dw, @S2D7) = 2 THEN 2
WHEN DATEPART(dw, @S2D7) = 3 THEN 3
WHEN DATEPART(dw, @S2D7) = 4 THEN 4
WHEN DATEPART(dw, @S2D7) = 5 THEN 5
WHEN DATEPART(dw, @S2D7) = 6 THEN 6
ELSE 7 END
END
DECLARE cDías CURSOR FOR
SELECT ROW_NUMBER() OVER(ORDER BY Fecha ASC),
CONVERT(VARCHAR(10),fecha,105)
FROM @TABLE
ORDER BY fecha
SELECT @Insert = 'INSERT INTO AuxAsistenciaHE(ID,Personal, Empresa, FechaD, FechaA'
OPEN cDías
FETCH NEXT FROM cDías INTO @cNum,@cDia
WHILE @@FETCH_STATUS = 0 AND @cNum <= 14
BEGIN
SELECT @Semana = CEILING(@cNum/7.0),
@DiaSem = CASE WHEN @cNum <= 7
THEN @cNum
ELSE CASE WHEN @cNum%7.0 = 0
THEN 7
ELSE (@cNum - (FLOOR(@cNum/7.0)*7))
END
END,
@cFechaD = ISNULL(@cFechaD,@cDia),
@cFechaA = @cDia
SELECT @Insert = @Insert+',Semana'+CAST(@Semana AS VARCHAR)+'Dia'+CAST(@DiaSem AS VARCHAR)
SELECT @Dias = ISNULL(@Dias,'')+
' ,CASE WHEN ('+
' DATEDIFF(mi,(MIN(CASE WHEN B.Registro = '+CHAR(39)+'Entrada'+CHAR(39)+' AND B.Fecha = '+CHAR(39)+@cDia+CHAR(39)+' THEN B.HoraRegistro ELSE '+CHAR(39)+'00:00'+CHAR(39)+' END)),'+
'              (MIN(CASE WHEN B.Registro = '+CHAR(39)+'Entrada'+CHAR(39)+' AND B.Fecha = '+CHAR(39)+@cDia+CHAR(39)+' THEN CONVERT(Time,F.Entrada) ELSE '+CHAR(39)+'00:00'+CHAR(39)+' END)))'+
') < 0 THEN 0 ELSE'+
' DATEDIFF(mi,(MIN(CASE WHEN B.Registro = '+CHAR(39)+'Entrada'+CHAR(39)+' AND B.Fecha = '+CHAR(39)+@cDia+CHAR(39)+' THEN B.HoraRegistro ELSE '+CHAR(39)+'00:00'+CHAR(39)+' END)),'+
'              (MIN(CASE WHEN B.Registro = '+CHAR(39)+'Entrada'+CHAR(39)+' AND B.Fecha = '+CHAR(39)+@cDia+CHAR(39)+' THEN CONVERT(Time,F.Entrada) ELSE '+CHAR(39)+'00:00'+CHAR(39)+' END)))'+
'END + '+
' CASE WHEN ('+
'  DATEDIFF(mi,(MAX(CASE WHEN B.Registro = '+CHAR(39)+'Salida'+CHAR(39)+' AND B.Fecha = '+CHAR(39)+@cDia+CHAR(39)+' THEN CONVERT(Time,F.Salida) ELSE '+CHAR(39)+'00:00'+CHAR(39)+' END)),'+
'              (MAX(CASE WHEN B.Registro = '+CHAR(39)+'Salida'+CHAR(39)+' AND B.Fecha = '+CHAR(39)+@cDia+CHAR(39)+' THEN B.HoraRegistro ELSE '+CHAR(39)+'00:00'+CHAR(39)+' END)))'+
') < 0 THEN 0 ELSE'+
'  DATEDIFF(mi,(MAX(CASE WHEN B.Registro = '+CHAR(39)+'Salida'+CHAR(39)+' AND B.Fecha = '+CHAR(39)+@cDia+CHAR(39)+' THEN CONVERT(Time,F.Salida) ELSE '+CHAR(39)+'00:00'+CHAR(39)+' END)),'+
'              (MAX(CASE WHEN B.Registro = '+CHAR(39)+'Salida'+CHAR(39)+' AND B.Fecha = '+CHAR(39)+@cDia+CHAR(39)+' THEN B.HoraRegistro ELSE '+CHAR(39)+'00:00'+CHAR(39)+' END)))'+
'END'
FETCH NEXT FROM cDías INTO @cNum,@cDia
END
CLOSE cDías
DEALLOCATE cDías
IF OBJECT_ID(N'tempdb..#VerJornadaTiempo', N'U') IS NOT NULL
DROP TABLE #VerJornadaTiempo
SET LANGUAGE ESPAÑOL
SELECT DISTINCT B.Personal, F.Jornada, F.Entrada, F.Salida, F.Ano, F.Mes, F.Dia, F.Semana
INTO #VerJornadaTiempo
FROM Asiste A
JOIN AsisteD B  ON A.ID = B.ID
JOIN MovTipo C  ON A.Mov = C.Mov AND C.Modulo = 'ASIS' AND C.Clave = 'ASIS.R'
JOIN Personal D ON B.Personal = D.Personal
JOIN VerJornadaTiempo F ON D.Jornada = F.Jornada AND CONVERT(DATE, B.Fecha,105) = CONVERT(DATE, F.Entrada, 105)
WHERE B.Fecha >= CONVERT(DATETIME,@FechaD,105)
AND B.Fecha <= CONVERT(DATETIME,@FechaA,105)
AND A.Estatus <> 'CANCELADO'
AND A.Empresa = @Empresa
UNION
SELECT B.Personal, D.Jornada, B.Fecha,CAST((CONVERT(VARCHAR(10),B.Fecha,105)+' '+
CAST(MIN(CASE WHEN B.Registro = 'Entrada' THEN B.HoraRegistro ELSE '23:59' END) AS VARCHAR(5))) AS DATETIME),
DATEPART(YEAR,B.Fecha), DATEPART(Month,B.Fecha), DATEPART(day,B.Fecha), DATEPART(week,B.Fecha)
FROM Asiste A
JOIN AsisteD B  ON A.ID = B.ID
JOIN MovTipo C  ON A.Mov = C.Mov AND C.Modulo = 'ASIS' AND C.Clave = 'ASIS.R'
JOIN Personal D ON B.Personal = D.Personal
LEFT JOIN VerJornadaTiempo F ON D.Jornada = F.Jornada AND CONVERT(DATE, B.Fecha,105) = CONVERT(DATE, F.Entrada, 105)
WHERE B.Fecha >= CONVERT(DATETIME,@FechaD,105)
AND B.Fecha <= CONVERT(DATETIME,@FechaA,105)
AND A.Estatus <> 'CANCELADO'
AND A.Empresa = @Empresa
AND F.Jornada IS NULL
GROUP BY D.Jornada, B.Fecha, B.Personal
SELECT @SQL = @Insert+') '+
'SELECT '+CAST(@ID AS VARCHAR)+', B.Personal, A.Empresa,'+CHAR(39)+@cFechaD+CHAR(39)+','+CHAR(39)+@cFechaA+CHAR(39)+
@Dias+
' FROM Asiste A'+
' JOIN AsisteD B'+
'   ON A.ID = B.ID'+
' JOIN MovTipo C'+
'   ON A.Mov = C.Mov'+
'  AND C.Modulo = '+CHAR(39)+'ASIS'+CHAR(39)+
'  AND C.Clave = '+CHAR(39)+'ASIS.R'+CHAR(39)+' '+
' JOIN Personal D'+
'   ON B.Personal = D.Personal'+
' JOIN #VerJornadaTiempo F'+
'   ON D.Jornada = F.Jornada'+
'  AND D.Personal = F.Personal'+
'  AND CONVERT(DATE, B.Fecha,105) = CONVERT(DATE, F.Entrada, 105)'+
'WHERE B.Fecha >= CONVERT(DATETIME,'+CHAR(39)+CONVERT(VARCHAR(10),@FechaD,105)+CHAR(39)+',105)'+
' AND B.Fecha <= CONVERT(DATETIME,'+CHAR(39)+CONVERT(VARCHAR(10),@FechaA,105)+CHAR(39)+',105)'+
' AND A.Estatus <> '+CHAR(39)+'CANCELADO'+CHAR(39)+
' AND A.Empresa = ' +CHAR(39)+@Empresa+CHAR(39)+
' GROUP BY B.Personal, A.Empresa'
EXEC(@SQL)
IF OBJECT_ID(N'tempdb..#VerJornadaTiempo', N'U') IS NOT NULL
DROP TABLE #VerJornadaTiempo
END
END

