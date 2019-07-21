SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spRepTabNomProv
@ID                		INT,
@Estacion               INT,
@Opcion                 INT
AS
BEGIN
DECLARE
@SQL varchar(8000),
@SQL2 varchar(8000),
@Columna int,
@Concepto varchar(100),
@Tipo varchar(20),
@Personal varchar(20),
@Total money,
@Mov varchar(20),
@MovID varchar(20),
@FechaD datetime,
@FechaA datetime,
@ApellidoPaterno varchar(50),
@ApellidoMaterno varchar(50),
@Nombre varchar(50),
@Registro varchar(50),
@Registro2 varchar(50),
@SDI money,
@Puesto varchar(50),
@Departamento varchar(50),
@Empresa varchar(50),
@NombreEmpresa varchar(100),
@NombreCompleto  varchar(100),
@TotalPercepciones money,
@TotalDeducciones money,
@TotalNeto money,
@ElaNombre varchar(100),
@ElaPuesto varchar(50),
@AutNombre varchar(100),
@AutPuest  varchar(50),
@RutaArchivo    VARCHAR(255),
@RutaRespaldo   VARCHAR(255),
@NombreArchivo  VARCHAR(50),
@BaseDatos      VARCHAR(100),
@TotalProvision  money
DELETE NomTabPipe WHERE Estacion = @Estacion
SELECT @Empresa = Empresa
FROM Nomina
WHERE ID = @ID
SELECT @RutaArchivo = RutaArchivo, @RutaRespaldo = RutaRespaldo, @NombreArchivo = NombreArchivo, @BaseDatos = BaseDatos
FROM NomTabArchivo
WHERE Empresa = @Empresa
CREATE TABLE #PasoTotales(
Personal	VARCHAR(20)  COLLATE database_DEFAULT NULL,
Columna		VARCHAR(100) COLLATE database_DEFAULT,
Total		MONEY NULL,
Tipo		VARCHAR(30)  COLLATE database_DEFAULT NULL,
Orden		INT NULL
)
SET @SQL2= ''
SELECT @Mov =  n.Mov, @MovID = n.MovID, @FechaD = n.FechaD, @FechaA = n.FechaA, @Empresa = n.Empresa
FROM NOMINA n
WHERE n.ESTATUS = 'CONCLUIDO' AND n.MOV = 'NOMINA' AND n.ID = @ID
SELECT @NombreEmpresa = Nombre FROM empresa WHERE Empresa = @Empresa
SET @SQL2= @NombreEmpresa + ', ' + @Mov + ', ' + @MovID + ', '+ convert(varchar(12),@FechaD) + ', ' + convert(varchar(12),@FechaA)
INSERT INTO NomTabPipe(Estacion, Cadena01)
SELECT @Estacion, @SQL2
SELECT @SQL2 = ''
SELECT @SQL2 = 'Empleado, Nombre, RFC, No Afiliacion, SDI, Departamento, Puesto,'
DECLARE	Crpipe CURSOR LOCAL FAST_FORWARD  FOR
SELECT	Columna, Tipo, Concepto
FROM NomTabCfg
WHERE Tipo IN ('Percepciones') AND Concepto IN ('Sueldo','Prima Vacacional Exenta','Prima Antiguedad Gravable')
OPEN	Crpipe
FETCH	NEXT FROM Crpipe
INTO	@Columna, @Tipo, @Concepto
WHILE	@@FETCH_STATUS <> -1
BEGIN
IF	@@FETCH_STATUS <> -2
BEGIN
SET @SQL2= @SQL2 +  @Concepto+  ', '
SELECT @Total = 0
END
FETCH	NEXT FROM Crpipe INTO @Columna, @Tipo, @Concepto
END
CLOSE	Crpipe
DEALLOCATE	Crpipe
SET @SQL2= @SQL2 +  'Total Percepciones' +  ', '
DECLARE	Crpipe CURSOR LOCAL FAST_FORWARD  FOR
SELECT	Columna, Tipo, Concepto
FROM NomTabCfg
WHERE Tipo in ('Deducciones') AND Concepto IN ('IMSS','ISR Aguinaldo','ISR Liquidacion')
OPEN	Crpipe
FETCH	NEXT FROM Crpipe
INTO	@Columna, @Tipo, @Concepto
WHILE	@@FETCH_STATUS <> -1
BEGIN
IF	@@FETCH_STATUS <> -2
BEGIN
SET @SQL2= @SQL2 +  @Concepto+  ', '
END
FETCH	NEXT FROM Crpipe INTO @Columna, @Tipo, @Concepto
END
CLOSE	Crpipe
DEALLOCATE	Crpipe
SET @SQL2= @SQL2 +  'Total Deducciones' +  ', '
DECLARE	Crpipe CURSOR LOCAL FAST_FORWARD  FOR
SELECT	Columna, Tipo, Concepto FROM NomTabCfg WHERE Tipo IN ('Provision')
OPEN	Crpipe
FETCH	NEXT FROM Crpipe
INTO	@Columna, @Tipo, @Concepto
WHILE	@@FETCH_STATUS <> -1
BEGIN
IF	@@FETCH_STATUS <> -2
BEGIN
SET @SQL2= @SQL2 +  @Concepto+  ', '
SELECT @Total = 0
END
FETCH	NEXT FROM Crpipe INTO @Columna, @Tipo, @Concepto
END
CLOSE	Crpipe
DEALLOCATE	Crpipe
SET @SQL2= @SQL2 +  'Total Provisiones' +  ', Total Neto '
INSERT INTO NomTabPipe(Estacion, Cadena01)
SELECT @Estacion, @SQL2
SET @SQL2= ''
DECLARE	CrpipePersonal CURSOR LOCAL FAST_FORWARD  FOR
SELECT DISTINCT n.Mov, n.MovID, n.FechaD, n.FechaA, nd.Personal, p.ApellidoPaterno, p.ApellidoMaterno, p.Nombre, p.Registro, p.Registro2, p.SDI, p.Puesto, p.Departamento, p.Empresa
FROM NOMINA n
JOIN NOMINAD nd ON n.ID = nd.ID
JOIN Personal p On nd.Personal = p.Personal
WHERE n.ESTATUS = 'CONCLUIDO' AND n.MOV = 'NOMINA' AND n.ID = @ID AND nd.Personal IS NOT NULL
OPEN	CrpipePersonal
FETCH	NEXT FROM CrpipePersonal INTO @Mov, @MovID, @FechaD, @FechaA, @Personal, @ApellidoPaterno, @ApellidoMaterno, @Nombre, @Registro, @Registro2, @SDI, @Puesto, @Departamento, @Empresa
WHILE	@@FETCH_STATUS <> -1
BEGIN
IF	@@FETCH_STATUS <> -2
BEGIN
SELECT @NombreCompleto = @Personal + ', ' +@Nombre + ' ' +  @ApellidoPaterno + ' ' + @ApellidoMaterno + ', '
DECLARE	Crpipe CURSOR LOCAL FAST_FORWARD  FOR
SELECT	Columna, Tipo, Concepto
FROM NomTabCfg
WHERE Tipo IN ('Percepciones') AND Concepto IN ('Sueldo','Prima Vacacional Exenta','Prima Antiguedad Gravable')
OPEN	Crpipe
FETCH	NEXT FROM Crpipe
INTO	@Columna, @Tipo, @Concepto
WHILE	@@FETCH_STATUS <> -1
BEGIN
IF	@@FETCH_STATUS <> -2
BEGIN
SELECT @Total = Importe
FROM NOMINA n JOIN NOMINAD nd ON n.ID = nd.ID
WHERE ESTATUS = 'CONCLUIDO' AND MOV = 'NOMINA' AND n.ID = @ID AND nd.Movimiento IN ('Percepcion') AND ND.Personal = @Personal AND ND.Concepto = @Concepto
SET @SQL2= @SQL2 +  CONVERT(VARCHAR,ISNULL(@Total,0)) + ', '
SELECT @TotalPercepciones = ISNULL(@TotalPercepciones,0) + ISNULL(@Total,0)
SELECT @Total = 0
END
FETCH	NEXT FROM Crpipe INTO @Columna, @Tipo, @Concepto
END
CLOSE	Crpipe
DEALLOCATE	Crpipe
SET @SQL2= @SQL2 +  CONVERT(VARCHAR,ISNULL(@TotalPercepciones,0)) + ', '
DECLARE	Crpipe CURSOR LOCAL FAST_FORWARD  FOR
SELECT	Columna, Tipo, Concepto
FROM NomTabCfg
WHERE Tipo IN ('Deducciones') AND Concepto IN ('IMSS','ISR Aguinaldo','ISR Liquidacion')
OPEN	Crpipe
FETCH	NEXT FROM Crpipe
INTO	@Columna, @Tipo, @Concepto
WHILE	@@FETCH_STATUS <> -1
BEGIN
IF	@@FETCH_STATUS <> -2
BEGIN
SELECT @Total = Importe
FROM NOMINA n JOIN NOMINAD nd ON n.ID = nd.ID
WHERE ESTATUS = 'CONCLUIDO' AND MOV = 'NOMINA' AND n.ID = @ID AND nd.Movimiento IN ('Deduccion') AND ND.Personal = @Personal AND ND.Concepto = @Concepto
SET @SQL2= @SQL2 +  CONVERT(VARCHAR,ISNULL(@Total,0)) + ', '
SELECT @TotalDeducciones = ISNULL(@TotalDeducciones,0) + ISNULL(@Total,0)
SELECT @Total = 0
END
FETCH	NEXT FROM Crpipe INTO @Columna, @Tipo, @Concepto
END
CLOSE	Crpipe
DEALLOCATE	Crpipe
SELECT @TotalPercepciones = ISNULL(@TotalDeducciones,0) + ISNULL(@Total,0)
DECLARE	Crpipe CURSOR LOCAL FAST_FORWARD  FOR
SELECT	Columna, Tipo, Concepto
FROM NomTabCfg
WHERE Tipo IN ('Provision')
OPEN	Crpipe
FETCH	NEXT FROM Crpipe
INTO	@Columna, @Tipo, @Concepto
WHILE	@@FETCH_STATUS <> -1
BEGIN
IF	@@FETCH_STATUS <> -2
BEGIN
SELECT @Total = Importe
FROM NOMINA n JOIN NOMINAD nd ON n.ID = nd.ID
WHERE ESTATUS = 'CONCLUIDO' AND MOV = 'NOMINA' AND n.ID = @ID AND nd.Movimiento in ('Provision') AND ND.Personal = @Personal AND ND.Concepto = @Concepto
SET @SQL2= @SQL2 +  CONVERT(VARCHAR,ISNULL(@Total,0)) + ', '
SELECT @TotalProvision = ISNULL(@TotalProvision,0) + ISNULL(@Total,0)
SELECT @Total = 0
END
FETCH	NEXT FROM Crpipe INTO @Columna, @Tipo, @Concepto
ENd
CLOSE	Crpipe
DEALLOCATE	Crpipe
SET @SQL2= @SQL2 +  CONVERT(VARCHAR,ISNULL(@TotalProvision,0)) + ', '
SELECT @TotalNeto = ISNULL(@TotalPercepciones,0) + ISNULL(@TotalDeducciones,0) + isnull(@TotalProvision,0)
SET @SQL2= @SQL2 +  CONVERT(VARCHAR,ISNULL(@TotalNeto,0)) + ', '
SET @SQL= @NombreCompleto+', ' +  isnull(@Registro,'')+  ', '+  isnull(@Registro2,'')+  ', '+  convert(varchar,@SDI)+  ', '+ @Departamento +  ', ' + @Puesto + ','+ @SQL2
END
INSERT INTO NomTabPipe(Estacion, Cadena01)
SELECT @Estacion, @SQL
FETCH	NEXT FROM CrpipePersonal INTO @Mov, @MovID, @FechaD, @FechaA, @Personal, @ApellidoPaterno, @ApellidoMaterno, @Nombre, @Registro, @Registro2, @SDI, @Puesto, @Departamento, @Empresa
END
CLOSE	CrpipePersonal
DEALLOCATE	CrpipePersonal
SELECT @TotalPercepciones = 0
SELECT @TotalDeducciones = 0
DELETE #PasoTotales WHERE ISNULL(TOTAL,0)<=0
SELECT @SQL2 = ''
DECLARE	Crpipe CURSOR LOCAL FAST_FORWARD  FOR
SELECT	Columna, Tipo, Concepto
FROM NomTabCfg
WHERE Tipo IN ('Percepciones') AND Concepto IN ('Sueldo','Prima Vacacional Exenta','Prima Antiguedad Gravable')
OPEN	Crpipe
FETCH	NEXT FROM Crpipe
INTO	@Columna, @Tipo, @Concepto
WHILE	@@FETCH_STATUS <> -1
BEGIN
IF	@@FETCH_STATUS <> -2
BEGIN
SELECT @Total = 0
SELECT @Total = isnull(nd.Importe,0)
FROM NOMINA n JOIN NOMINAD nd ON n.ID = nd.ID
WHERE ESTATUS = 'CONCLUIDO' AND MOV = 'NOMINA' AND n.ID = @ID AND nd.Movimiento in ('Percepcion') AND  ND.Concepto = @Concepto
SELECT @TotalPercepciones = ISNULL(@TotalPercepciones,0) + ISNULL(@Total,0)
SET @SQL2= @SQL2 +  CONVERT(VARCHAR,ISNULL(@Total,0)) + ', '
END
FETCH	NEXT FROM Crpipe INTO @Columna, @Tipo, @Concepto
END
CLOSE	Crpipe
DEALLOCATE	Crpipe
DECLARE	Crpipe CURSOR LOCAL FAST_FORWARD  FOR
SELECT	Columna, Tipo, Concepto
FROM NomTabCfg
WHERE Tipo IN ('Deducciones') AND Concepto IN ('IMSS','ISR Aguinaldo','ISR Liquidacion')
OPEN	Crpipe
FETCH	NEXT FROM Crpipe
INTO	@Columna, @Tipo, @Concepto
WHILE	@@FETCH_STATUS <> -1
BEGIN
IF	@@FETCH_STATUS <> -2
BEGIN
SELECT @Total = 0
SELECT @Total = isnull(Importe,0)
FROM NOMINA n JOIN NOMINAD nd ON n.ID = nd.ID
WHERE ESTATUS = 'CONCLUIDO' AND MOV = 'NOMINA' AND n.ID = @ID AND nd.Movimiento in ('Deduccion') AND ND.Concepto = @Concepto
SELECT @TotalDeducciones = ISNULL(@TotalDeducciones,0) + ISNULL(@Total,0)
SET @SQL2= @SQL2 +  CONVERT(VARCHAR,ISNULL(@TotalDeducciones,0)) + ', '
END
FETCH	NEXT FROM Crpipe INTO @Columna, @Tipo, @Concepto
END
CLOSE	Crpipe
DEALLOCATE	Crpipe
DECLARE	Crpipe CURSOR LOCAL FAST_FORWARD  FOR
SELECT	Columna, Tipo, Concepto
FROM NomTabCfg
WHERE Tipo IN ('Provision')
OPEN	Crpipe
FETCH	NEXT FROM Crpipe
INTO	@Columna, @Tipo, @Concepto
WHILE	@@FETCH_STATUS <> -1
BEGIN
IF	@@FETCH_STATUS <> -2
BEGIN
SELECT @Total = 0
SELECT @Total = isnull(Importe,0)
FROM NOMINA n JOIN NOMINAD nd ON n.ID = nd.ID
WHERE ESTATUS = 'CONCLUIDO' AND MOV = 'NOMINA' AND n.ID = @ID AND nd.Movimiento IN ('Provision') AND ND.Concepto = @Concepto
SELECT @TotalProvision = ISNULL(@TotalProvision,0) + ISNULL(@Total,0)
SET @SQL2= @SQL2 +  CONVERT(VARCHAR,ISNULL(@TotalProvision,0)) + ', '
END
FETCH	NEXT FROM Crpipe INTO @Columna, @Tipo, @Concepto
END
CLOSE	Crpipe
DEALLOCATE	Crpipe
INSERT INTO NomTabPipe(Estacion, Cadena01)
SELECT @Estacion, @SQL2
SELECT @ElaNombre = ElaNombre, @ElaPuesto = ElaPuesto, @AutNombre = AutNombre, @AutPuest = AutPuesto
FROM NomTabFirmas
INSERT INTO NomTabPipe(Estacion, Cadena01)
SELECT @Estacion, 'Elaboro:' + ', , , , , , Autorizo: '
INSERT INTO NomTabPipe(Estacion, Cadena01)
SELECT @Estacion, @ElaNombre +  + ', , , , , , ' + @AutNombre
INSERT INTO NomTabPipe(Estacion, Cadena01)
SELECT @Estacion, @ElaPuesto + ', , , , , ,  ' + @AutPuest
IF @Opcion = 1
SELECT Cadena01 FROM NomTabPipe WHERE Estacion = @Estacion
IF @Opcion = 2
BEGIN
SET @SQL2='Exec Master..xp_Cmdshell ''bcp "SELECT Cadena01 FROM ' + @BaseDatos + '.dbo.NomTabPipe where Estacion = ' + CONVERT(VARCHAR,@Estacion) + '" queryout "' + @RutaArchivo + '\' + @NombreArchivo + @Mov+ @MovID + '.txt" -c -T'''
EXEC(@SQL2)
END
RETURN
END

