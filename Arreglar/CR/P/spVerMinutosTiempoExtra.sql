SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE [dbo].[spVerMinutosTiempoExtra]
@ID			int,
@Empresa	varchar(5),
@FechaD		datetime,
@FechaA		datetime,
@BorraTabla bit

AS BEGIN
DECLARE
@SQL		    varchar(max),
@DiasIns        varchar(max),
@Insert		    varchar(max),
@Semana		    int,
@DiaSem		    int,
@S1D6           datetime,
@S2D6           datetime,
@S1D7           datetime,
@S2D7           datetime,
@Idt            int,
@InsDia         datetime,
@cPersonal      varchar(10),
@cDia           datetime,
@cDias          datetime,
@Jornada        varchar(20),
@MinutosJor     float,
@cID            int,
@MinutosAs      float,
@MinutosAu      float,
@MinutosLab     float,
@MinutosHE      float,
@cNum           int,
@cNum1          int,
@cFechaD        varchar(10),
@cFechaA        datetime,
@IdDias			int
IF EXISTS(SELECT * FROM AuxAsistenciaHE WHERE ID = @ID AND Estatus <> 'SINAFECTAR')
BEGIN
RETURN
END
IF @BorraTabla = 0
BEGIN
DECLARE @TABLE TABLE
(
Id      Int,
Fecha	varchar(10),
DiaS    Int
)
SET LANGUAGE ESPAÑOL
INSERT INTO @TABLE (Id, Fecha, DiaS)
SELECT ROW_NUMBER() OVER(ORDER BY B.Fecha ASC),
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
GROUP BY B.Fecha
SELECT @IdDias = COUNT(*) FROM @TABLE
IF NOT EXISTS (SELECT * FROM @TABLE WHERE DiaS = 6)
BEGIN
SELECT @Idt = COUNT(*) FROM @TABLE
SELECT @S1D6 = DATEADD (DAY,1,FECHA)
FROM @TABLE
WHERE dias = 5
ORDER BY FECHA ASC
INSERT INTO @TABLE (Id, Fecha, DiaS)
SELECT @Idt + 1, CONVERT(varchar(10),@S1D6,105), CASE  WHEN DATEPART(dw, @S1D6) = 1 THEN 1
WHEN DATEPART(dw, @S1D6) = 2 THEN 2
WHEN DATEPART(dw, @S1D6) = 3 THEN 3
WHEN DATEPART(dw, @S1D6) = 4 THEN 4
WHEN DATEPART(dw, @S1D6) = 5 THEN 5
WHEN DATEPART(dw, @S1D6) = 6 THEN 6
ELSE 7 END
IF @IdDias > 5
BEGIN
SELECT @Idt = COUNT(*)
FROM @TABLE
SELECT @S2D6 = DATEADD (DAY,1,FECHA)
FROM @TABLE
WHERE dias = 5
ORDER BY FECHA DESC
INSERT INTO @TABLE (Id, Fecha, DiaS)
SELECT @Idt + 1, CONVERT(varchar(10),@S1D6,105), CASE  WHEN DATEPART(dw, @S2D6) = 1 THEN 1
WHEN DATEPART(dw, @S2D6) = 2 THEN 2
WHEN DATEPART(dw, @S2D6) = 3 THEN 3
WHEN DATEPART(dw, @S2D6) = 4 THEN 4
WHEN DATEPART(dw, @S2D6) = 5 THEN 5
WHEN DATEPART(dw, @S2D6) = 6 THEN 6
ELSE 7 END
END
END
IF NOT EXISTS (SELECT * FROM @TABLE WHERE DiaS = 7)
BEGIN
SELECT @Idt = COUNT(*) FROM @TABLE
SELECT @S1D7 = DATEADD (DAY,1,FECHA)
FROM @TABLE
WHERE dias = 6
ORDER BY FECHA ASC
INSERT INTO @TABLE (Id, Fecha, DiaS)
SELECT @Idt + 1, CONVERT(varchar(10),@S1D7,105), CASE  WHEN DATEPART(dw, @S1D7) = 1 THEN 1
WHEN DATEPART(dw, @S1D7) = 2 THEN 2
WHEN DATEPART(dw, @S1D7) = 3 THEN 3
WHEN DATEPART(dw, @S1D7) = 4 THEN 4
WHEN DATEPART(dw, @S1D7) = 5 THEN 5
WHEN DATEPART(dw, @S1D7) = 6 THEN 6
ELSE 7 END
IF @IdDias > 5
BEGIN
SELECT @Idt = COUNT(*) FROM @TABLE
SELECT @S2D7 = DATEADD (DAY,1,FECHA)
FROM @TABLE
WHERE dias = 6
ORDER BY FECHA DESC
INSERT INTO @TABLE (Id, Fecha, DiaS)
SELECT @Idt + 1, CONVERT(varchar(10),@S1D7,105), CASE  WHEN DATEPART(dw, @S2D7) = 1 THEN 1
WHEN DATEPART(dw, @S2D7) = 2 THEN 2
WHEN DATEPART(dw, @S2D7) = 3 THEN 3
WHEN DATEPART(dw, @S2D7) = 4 THEN 4
WHEN DATEPART(dw, @S2D7) = 5 THEN 5
WHEN DATEPART(dw, @S2D7) = 6 THEN 6
ELSE 7 END
END
END
DECLARE cDías CURSOR FOR
SELECT ROW_NUMBER() OVER(ORDER BY Fecha ASC),
CONVERT(DATETIME, fecha)
FROM @TABLE
ORDER BY fecha
SELECT @Insert = 'INSERT INTO AuxAsistenciaHE (ID,Personal, Empresa, FechaD, FechaA'
OPEN cDías
FETCH NEXT FROM cDías INTO @cNum1, @cDias
WHILE @@FETCH_STATUS = 0 AND @cNum1 <= 14
BEGIN
SELECT @Semana = CEILING(@cNum1/7.0),
@DiaSem = CASE WHEN @cNum1 <= 7
THEN @cNum1
ELSE CASE WHEN @cNum1%7.0 = 0
THEN 7
ELSE (@cNum1 - (FLOOR(@cNum1/7.0)*7))
END
END,
@cFechaD = ISNULL(@cFechaD,@cDias),
@cFechaA = @cDias
SELECT @Insert = @Insert+',Semana'+CAST(@Semana AS VARCHAR)+'Dia'+CAST(@DiaSem AS VARCHAR)
FETCH NEXT FROM cDías INTO @cNum1,@cDia
END
CLOSE cDías
DEALLOCATE cDías
DECLARE @Dias TABLE(Dia datetime)
SET @InsDia = @FechaD
WHILE @InsDia <= @FechaA
BEGIN
INSERT INTO @Dias(Dia) VALUES(@InsDia)
SELECT @InsDia = @InsDia + 1
END
DECLARE cPersonal CURSOR FOR
SELECT A.ID, B.Personal
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
GROUP BY A.ID, B.Personal
ORDER BY A.ID, B.Personal ASC
OPEN cPersonal
FETCH NEXT FROM cPersonal INTO @cID, @cPersonal
WHILE @@FETCH_STATUS = 0
BEGIN
SELECT @cNum = 0, @DiasIns = ''
SELECT @Jornada = Jornada FROM Personal WHERE Personal = @cPersonal
DECLARE cDias CURSOR FOR
SELECT Dia FROM @Dias
OPEN cDias
FETCH NEXT FROM cDias INTO @cDia
WHILE @@FETCH_STATUS = 0
BEGIN
SELECT  @MinutosAs = 0, @MinutosAu = 0, @MinutosLab = 0, @MinutosHE = 0
SELECT @MinutosJor = ISNULL(SUM(DATEDIFF(mi,Entrada,Salida)),0)
FROM VerJornadaTiempo
WHERE Jornada = @Jornada
AND DATEPART(YEAR,@cDia) = Ano
AND DATEPART(MONTH,@cDia) = Mes
AND DATEPART(DAY,@cDia) = Dia
GROUP BY Ano, Mes, Dia
SELECT @MinutosAs = ISNULL(SUM(Cantidad),0) FROM ASISTED WHERE ID = @cID AND Personal = @cPersonal AND Fecha = @cDia AND Tipo = 'Minutos Asistencia'
SELECT @MinutosAu = ISNULL(SUM(Cantidad),0) FROM ASISTED WHERE ID = @cID AND Personal = @cPersonal AND Fecha = @cDia AND Tipo = 'Minutos Ausencia'
SELECT @MinutosLab = @MinutosAs - @MinutosAu
IF @MinutosJor < @MinutosLab
SELECT @MinutosHE = @MinutosLab - @MinutosJor
IF @cNum < 14 AND @IdDias > 5
BEGIN
SELECT @DiasIns = ISNULL(@DiasIns, '') + ',' + CAST(@MinutosHE AS VARCHAR(4))
SELECT @cNum = ISNULL(@cNum,0) + 1
END
IF @cNum < 14 AND @IdDias = 5
BEGIN
SELECT @DiasIns = ISNULL(@DiasIns, '') + ',' + CAST(@MinutosHE AS VARCHAR(4))
SELECT @cNum = ISNULL(@cNum,0) + 1
END
FETCH NEXT FROM cDias INTO @cDia
END
CLOSE cDias
DEALLOCATE cDias
SELECT @SQL = @Insert + ') '+
'SELECT '+ CAST(@ID AS VARCHAR)+','+CHAR(39)+@cPersonal+CHAR(39)+','+CHAR(39)+@Empresa+CHAR(39)+','+CHAR(39)+CONVERT(VARCHAR(10), @FechaD, 105) +CHAR(39)+','+CHAR(39)+CONVERT(VARCHAR(10), @FechaA, 105)+CHAR(39)+
@DiasIns
EXEC(@SQL)
FETCH NEXT FROM cPersonal INTO @cID, @cPersonal
END
CLOSE cPersonal
DEALLOCATE cPersonal
END
END

