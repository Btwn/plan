SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE dbo.spReporteDim
@Cadena		VARCHAR(2),
@Empresa	VARCHAR(5),
@Anio		int,
@Estacion	int

AS BEGIN
SET NOCOUNT ON
DECLARE
@Personal				VARCHAR(30),
@Columna				VARCHAR(30),
@SQL					VARCHAR(8000),
@SQL2					VARCHAR(8000),
@FechaD					DATETIME,
@FechaA					DATETIME,
@FechaDSiguiente		DATETIME,
@FechaASiguiente		DATETIME,
@Campo					VARCHAR(50),
@Tabla					BIT,
@Tipo					VARCHAR(30),
@obligatorio			BIT,
@MaxColum				INT,
@Titulo					VARCHAR(90),
@ConceptoSubsidioEmpleo	VARCHAR(50)  ,
@Colum30				VARCHAR(2),
@Colum31				VARCHAR(2),
@Colum32				VARCHAR(2),
@PagosporSeparacionMov	VARCHAR(50),
@AsimiladosASalarios	VARCHAR(50),
@PagoPatronEfectuados	VARCHAR(50),
@Movimiento             VARCHAR(20),
@MovConcepto            VARCHAR(50),
@Concepto               VARCHAR(50),
@Cantidad               MONEY
SET DATEFORMAT mdy;
CREATE TABLE #PasoAjusteAnual(Personal VARCHAR(20)COLLATE database_DEFAULT  NULL)
CREATE TABLE #PasoSeparacion(Personal VARCHAR(20)COLLATE database_DEFAULT  NULL)
CREATE TABLE #PasoPagoPatronEfectuados(Personal VARCHAR(20)COLLATE database_DEFAULT  NULL)
CREATE TABLE #PasoAsimilado(Personal VARCHAR(20)COLLATE database_DEFAULT  NULL)
CREATE TABLE #PasoPagoPatron(Personal VARCHAR(20)COLLATE database_DEFAULT  NULL)
CREATE TABLE #PasoValor (Valor VARCHAR(30) COLLATE database_DEFAULT NULL)
CREATE TABLE #PasoOrden(IDColum  int,Columna  VARCHAR(30)COLLATE database_DEFAULT  NULL)
CREATE TABLE #PasoPersonal(IDPer VARCHAR(20)COLLATE database_DEFAULT,Personal VARCHAR(20)COLLATE database_DEFAULT  NULL)
CREATE TABLE #PasoSubTotales(Personal VARCHAR(20)COLLATE database_DEFAULT NULL,Columna  VARCHAR(30)COLLATE database_DEFAULT,SubTotal MONEY NULL,SubTotalC MONEY NULL)
CREATE TABLE #PasoTotales(Personal VARCHAR(20) COLLATE database_DEFAULT NULL,Columna  VARCHAR(30)COLLATE database_DEFAULT,Total    int NULL)
CREATE TABLE #PasoExisteEnMov(Personal VARCHAR(20) COLLATE database_DEFAULT	NULL)
CREATE TABLE #Pasotexto(Personal VARCHAR(20) COLLATE database_DEFAULT NULL,Columna  VARCHAR(30) COLLATE database_DEFAULT,Valor    VARCHAR(90) COLLATE database_DEFAULT NULL)
CREATE TABLE #PasoPTUa(Personal VARCHAR(20)COLLATE database_DEFAULT  NULL,Importe FLOAT NULL)
CREATE TABLE #PasoPTUb(Personal VARCHAR(20)COLLATE database_DEFAULT  NULL,Importe FLOAT NULL)
IF NOT EXISTS(SELECT * FROM sysindexes WHERE sysindexes.name = 'PSTPersonal')
CREATE INDEX PTTPersonal ON #PasoSubTotales(Personal,Columna)INCLUDE(SubTotal)
IF NOT EXISTS(SELECT * FROM sysindexes WHERE sysindexes.name = 'PTTPersonal')
CREATE INDEX PTTPersonal ON #PasoTotales(Personal)
IF NOT EXISTS(SELECT * FROM sysindexes WHERE sysindexes.name = 'PTPersonalColumna')
CREATE INDEX PTPersonalColumna ON #Pasotexto(Personal,Columna)
IF NOT EXISTS(SELECT * FROM sysindexes WHERE sysindexes.name = 'PTPersonal')
CREATE INDEX PTPersonal ON #Pasotexto(Personal)
IF @Cadena='SI'
BEGIN
DELETE	DimPasoPipe	WHERE Estacion=@Estacion
DELETE	DimPaso		WHERE Estacion=@Estacion AND Personal='0'
SELECT	@MaxColum=134
DECLARE	CrpipePersonal CURSOR LOCAL FAST_FORWARD  FOR
SELECT	Personal
FROM	DIMPaso
WHERE	Estacion=@Estacion
OPEN	CrpipePersonal
FETCH	NEXT FROM CrpipePersonal INTO @Personal
WHILE	@@FETCH_STATUS <> -1
BEGIN
IF	@@FETCH_STATUS <> -2
BEGIN
SELECT	@Colum30='',@Colum31='',@Colum32=''
DECLARE	Crpipe CURSOR LOCAL FAST_FORWARD  FOR
SELECT	Columna FROM DimCfg WHERE /*Obligatorio=1 AND*/    empresa=@empresa
SELECT	@SQL='INSERT INTO DimPasoPipe (Estacion,Cadena01) SELECT '+Convert(VARCHAR(10),@Estacion)+', '
OPEN	Crpipe
FETCH	NEXT FROM Crpipe
INTO	@Columna
WHILE	@@FETCH_STATUS <> -1
BEGIN
IF	@@FETCH_STATUS <> -2
BEGIN
IF @Columna IN (30,31,32)
BEGIN
DELETE	#pasoValor
SET		@SQL2=''
SET		@SQL2='INSERT INTO #pasoValor (Valor) SELECT ISNULL( Dim'+@Columna+','+CHAR(39)+CHAR(39)+') FROM  DIMPaso WHERE Personal='+CHAR(39)+@Personal+CHAR(39)+' AND Estacion='+Convert(VARCHAR(10),@Estacion)
EXEC	(@SQL2)
IF	@Columna=30
SELECT @Colum30=vALOR FROM #pasoValor
IF	@Columna=31
SELECT @Colum31=vALOR FROM #pasoValor
IF	@Columna=32
SELECT @Colum32=vALOR FROM #pasoValor
END
IF @Columna BETWEEN 33 AND 126
BEGIN
IF	(@Colum30='2' AND @Columna BETWEEN 33 AND 50 )
OR	(@Colum31='2' AND @Columna BETWEEN 51 AND 57 )
OR	(@Colum32='2' AND @Columna BETWEEN 58 AND 126)
BEGIN
SELECT @SQL = @SQL + CHAR(39)+CHAR(39) + '+'
SELECT @SQL = @SQL + CHAR(39)+'|'+CHAR(39)+ '+'
END
ELSE
BEGIN
SELECT @SQL = @SQL + 'ISNULL( Dim'+@Columna+','''' )+''|'''
SELECT @SQL = @SQL + '+'
END
END
ELSE
BEGIN
SELECT @SQL = @SQL +'ISNULL( Dim'+@Columna+','''' )+''|'''
IF @MaxColum <> @Columna
BEGIN
SELECT @SQL = @SQL + '+'
END
ELSE
BEGIN
SELECT @SQL = @SQL+' FROM DIMPaso WHERE Personal='+CHAR(39)+@Personal+CHAR(39)+' AND  Estacion='+Convert(VARCHAR(10),@Estacion)+' ORDER BY  Personal'
END
END
END
FETCH	NEXT FROM Crpipe INTO @Columna
END
CLOSE	Crpipe
DEALLOCATE	Crpipe
EXECUTE (@SQL)
END
FETCH	NEXT FROM CrpipePersonal INTO @Personal
END
CLOSE	CrpipePersonal
DEALLOCATE	CrpipePersonal
SELECT	Estacion, Cadena01, Cadena02
FROM	DimPasoPipe
WHERE	Estacion=@Estacion
END
ELSE
BEGIN
DELETE	DIMPaso WHERE Estacion=@Estacion
SELECT  @FechaD='01/01/'+CONVERT(VARCHAR(4),@Anio), @FechaA='12/31/'+CONVERT(VARCHAR(4),@Anio)
SELECT	@FechaDSiguiente = DATEADD(YEAR,1,@FechaD),@FechaASiguiente=DATEADD(YEAR,1,@FechaA)
DECLARE	@NomAuto bit
SELECT	@NomAuto=NomAuto
FROM	Empresagral
WHERE	Empresa=@Empresa
IF @NomAuto=1
BEGIN
INSERT	#PasoSubTotales (
Personal ,	Columna,	SubTotal,                SubTotalC)
SELECT	d.Personal,	C.Columna,	Sum(ISNULL(CASE WHEN D.Movimiento = 'Deduccion' THEN -1 ELSE 1 END * d.Importe,0)),Sum(ISNULL(d.Cantidad,0))
FROM	Nomina N
JOIN  NominaD D	ON D.ID = N.ID
JOIN	DimCfgD Cd	ON D.NominaConcepto=Cd.NominaConcepto
JOIN	DimCfg C	ON C.Id =Cd.Id
WHERE  N.FechaA BETWEEN @FechaD AND @FechaA
AND	n.Empresa=@Empresa
AND	c.Empresa=@Empresa
AND	n.Estatus IN ('CONCLUIDO')
GROUP	BY d.Personal,C.Columna
END
IF @NomAuto=0
BEGIN
INSERT	#PasoSubTotales (
Personal,	Columna,	SubTotal,                SubTotalC)
SELECT	d.Personal,	C.Columna,	Sum(ISNULL(CASE WHEN D.Movimiento =  'Deduccion' THEN -1 ELSE 1 END * d.Importe,0)),Sum(ISNULL(d.Cantidad,0))
FROM	Nomina N
JOIN	NominaD D  ON D.ID = N.ID
JOIN	DimCfgD Cd ON ISNULL(D.Concepto,D.NominaConcepto)=Cd.Concepto
JOIN	DimCfg C   ON C.Id =Cd.Id
WHERE	N.FechaA BETWEEN @FechaD AND @FechaA
AND n.Empresa=@Empresa
AND c.Empresa=@Empresa
AND n.Estatus IN ('CONCLUIDO')
GROUP	BY d.Personal,C.Columna
END
UPDATE #PasoSubTotales SET SubTotal = SubTotalC WHERE ISNULL(SubTotal,0) = 0
INSERT	#PasoOrden(
idColum, Columna)
SELECT	1,		 Columna
FROM	DimCfg
WHERE	Empresa=@Empresa
ORDER	BY Columna DESC
INSERT	#PasoPersonal(
idPer, Personal)
SELECT	1,	   Personal
FROM	#PasoSubTotales
GROUP	BY Personal
INSERT	#PasoPersonal(
idPer, Personal)
SELECT	1,	   0
INSERT	DIMPaso(
id, Personal, Estacion)
SELECT	1,  Personal, @Estacion
FROM	#PasoPersonal
INSERT	#PasoSubTotales(
Personal,	 Columna,	 SubTotal)
SELECT	pp.Personal, po.Columna, 0
FROM	#PasoOrden po
JOIN	#PasoPersonal pp ON po.idColum=pp.idPer
INSERT	#PasoTotales(
Personal, Columna, Total)
SELECT	Personal, Columna, ISNULL(ROUND(SUM(SubTotal),0),0)
FROM	#PasoSubTotales
GROUP	BY Personal, Columna
UPDATE	#PasoTotales SET Total=Total*-1
WHERE	Total<0
DECLARE	CrCamposPersonal CURSOR LOCAL FAST_FORWARD FOR
SELECT	Columna,Campo,Tipo
FROM	DimCfg
WHERE	Obligatorio=1 AND Empresa=@Empresa
OPEN	CrCamposPersonal
FETCH	NEXT FROM CrCamposPersonal INTO  @Columna,@Campo,@Tipo
WHILE	@@FETCH_STATUS <> -1
BEGIN
IF	@@FETCH_STATUS <> -2
BEGIN
IF @Tipo='Tabla Personal'
BEGIN
SET @SQL=''
IF @Campo in ('FechaAlta')
BEGIN
SET	@SQL='INSERT INTO #Pasotexto (Personal ,Columna ,Valor) SELECT p.Personal, '+@Columna+', right('+CHAR(39)+'00'+CHAR(39)+'+CONVERT(VARCHAR(2),DATEPART(MONTH, case when p.FechaAlta < '+CHAR(39)+convert(VARCHAR(10),@FechaD,101)+CHAR(39)+' then '+CHAR(39)
+convert(VARCHAR(10),@FechaD,101)+CHAR(39)+' else p.FechaAlta END)),2) FROM #PasoTotales Pst JOIN Personal p ON pst.Personal=p.Personal'
END
ELSE IF @Campo in ('FechaBaja')
BEGIN
SET	@SQL='INSERT INTO #Pasotexto (Personal ,Columna ,Valor)	SELECT p.Personal,'+@Columna+',
right('+CHAR(39)+'00'+CHAR(39)+'+CONVERT(VARCHAR(2),DATEPART(MONTH, case when p.Estatus = '+CHAR(39)+'BAJA'+CHAR(39)+' AND p.FechaBaja <'+CHAR(39)+convert(VARCHAR(10),@FechaA,101)+CHAR(39)+' then p.FechaBaja else '+CHAR(39)+convert(VARCHAR(10),@FechaA,101)+CHAR(39)+' END)),2)
FROM #PasoTotales Pst JOIN Personal p ON pst.Personal=p.Personal '
END
ELSE IF @Campo in ('ZonaEconomica')
BEGIN
SET	@SQL='INSERT INTO #Pasotexto (Personal ,Columna ,Valor) SELECT p.Personal, '+@Columna+',  case p.ZonaEconomica when '+CHAR(39)+'A'+CHAR(39)+' then '+CHAR(39)+'01'+CHAR(39)+' when '+CHAR(39)+'B'+CHAR(39)+' then '+CHAR(39)+'02'+CHAR(39)+' when '+CHAR(39
)+'C'+CHAR(39)+' then '+CHAR(39)+'03'+CHAR(39)+' else '+CHAR(39)+'0'+CHAR(39)+' END  FROM #PasoTotales Pst JOIN Personal p ON pst.Personal=p.Personal'
END
ELSE IF @Campo in ('Sindicato')
BEGIN
SET	@SQL='INSERT INTO #Pasotexto (Personal ,Columna ,Valor) SELECT p.Personal, '+@Columna+', ISNULL(p.'+@Campo+','+CHAR(39)+'2'+CHAR(39)+') FROM #PasoTotales Pst JOIN Personal p ON pst.Personal=p.Personal'
END
ELSE
BEGIN
SET	@SQL='INSERT INTO #Pasotexto (Personal ,Columna ,Valor) SELECT p.Personal, '+@Columna+', replace (p.'+@Campo+','+CHAR(39)+'Ñ'+CHAR(39)+','+CHAR(39)+'N'+CHAR(39)+') FROM #PasoTotales Pst JOIN Personal p ON pst.Personal=p.Personal'
END
EXEC (@SQL)
END
IF @Columna IN (70)
BEGIN
SELECT @Movimiento = m.Campo, @MovConcepto = d.MovConcepto,
@Concepto = d.NominaConcepto, @Cantidad = d.Cantidad
FROM DimCfg m
JOIN DimCfgD d on m.ID=d.ID
WHERE m.Columna = @Columna AND m.Empresa = @Empresa
INSERT	INTO #PasoPTUa (Personal,Importe)
SELECT	nd.Personal,SUM(nd.Importe)
FROM	Nomina n
JOIN  NominaD nd ON n.id=nd.id
WHERE	n.Estatus='CONCLUIDO'
AND YEAR(n.FechaA) = @Anio
AND n.Mov = @Movimiento
AND n.Empresa = @Empresa
AND nd.Concepto = @Concepto
GROUP BY nd.Personal
END
IF @Columna IN (71)
BEGIN
SELECT @Movimiento = m.Campo, @MovConcepto = d.MovConcepto,
@Concepto = d.NominaConcepto, @Cantidad = d.Cantidad
FROM DimCfg m
JOIN DimCfgD d on m.ID=d.ID
WHERE m.Columna = @Columna AND m.Empresa = @Empresa
INSERT	INTO #PasoPTUb (Personal,Importe)
SELECT	nd.Personal,SUM(nd.Importe)
FROM	Nomina n
JOIN  NominaD nd ON n.id=nd.id
WHERE	n.Estatus='CONCLUIDO'
AND YEAR(n.FechaA) = @Anio
AND n.Mov = @Movimiento
AND n.Empresa = @Empresa
AND nd.Concepto = @Concepto
GROUP BY nd.Personal
END
IF @Columna = 9 
BEGIN
SELECT @Movimiento = d.Mov, @MovConcepto = d.MovConcepto,
@Concepto = d.NominaConcepto, @Cantidad = d.Cantidad
FROM DimCfg m
JOIN DimCfgD d on m.ID=d.ID
WHERE m.Columna = @Columna AND m.Empresa = @Empresa
INSERT	INTO #PasoAjusteAnual (Personal)
SELECT	nd.Personal
FROM	Nomina n
JOIN  NominaD nd ON n.id=nd.id
WHERE	n.Estatus='CONCLUIDO'
AND YEAR(n.FechaA) = @Anio
AND n.Mov = @Movimiento
AND n.Concepto = @MovConcepto
AND n.Empresa = @Empresa
AND nd.Concepto = @Concepto
AND nd.Cantidad = @Cantidad
GROUP BY nd.Personal
END
IF @Tipo='Expresion'
BEGIN
IF @Campo IN ('Entidad')
BEGIN
INSERT	INTO #Pasotexto (Personal ,Columna ,Valor)
SELECT	pp.Personal,@Columna,RIGHT('00'+ISNULL(Clave,'0'),2)
FROM	#PasoPersonal pp
JOIN  Personal p	  ON  pp.Personal= p.Personal
JOIN	Sucursal s	  ON p.SucursalTrabajo=s.Sucursal
JOIN	PaisEstado pe ON pe.Estado=s.Estado
END
END
IF @Tipo='Texto'
BEGIN
INSERT	#Pasotexto(
Personal, Columna,  Valor)
SELECT	Personal, @Columna, CASE WHEN @Campo='NULL' THEN '' ELSE @Campo END
FROM	#PasoPersonal
END
END
FETCH NEXT FROM CrCamposPersonal INTO  @Columna,@Campo,@Tipo
END
CLOSE	CrCamposPersonal
DEALLOCATE	CrCamposPersonal
DECLARE	CrActualiza CURSOR LOCAL FAST_FORWARD  FOR
SELECT	cfg.Columna, cfg.Titulo, cfg.Tipo
FROM	#PasoOrden po
JOIN	DimCfg cfg ON po.Columna=cfg.Columna
WHERE	cfg.Obligatorio=1 AND cfg.Empresa=@Empresa
OPEN	CrActualiza
FETCH	NEXT FROM CrActualiza INTO @Columna, @Titulo, @Tipo
WHILE	@@FETCH_STATUS <> -1
BEGIN
IF @@FETCH_STATUS <> -2
BEGIN
SELECT	@SQL=''
IF	@Tipo ='Suma Concepto'
BEGIN
SET	@SQL='Update DIMPaso set  Dim'+ @Columna +'=pt.Total FROM DIMPaso po join #PasoTotales pt ON po.Personal=pt.Personal WHERE pt.Columna='+@Columna
END
ELSE
BEGIN
SET	@SQL='Update DIMPaso set  Dim'+ @Columna +'=pt.Valor FROM DIMPaso po join #Pasotexto pt ON po.Personal=pt.Personal WHERE pt.Columna='+@Columna
END
EXEC(@SQL)
SELECT	@SQL=''
SELECT	@SQL='Update DIMPaso set  Dim'+ @Columna +'='+CHAR(39)+Case when ISNULL(@Titulo,'')='' then 'Titulo '+@Columna else @Titulo END+CHAR(39)+' WHERE Personal='+CHAR(39)+'0'+CHAR(39)
EXEC(@SQL)
END
FETCH	NEXT FROM CrActualiza INTO @Columna, @Titulo, @Tipo
END
CLOSE	CrActualiza
DEALLOCATE	CrActualiza
UPDATE	DIMPaso SET Dim13=CASE WHEN Dim13='Sindicalizado' THEN '1' ELSE '2' END
WHERE	Estacion=@Estacion AND Personal<>'0'
SELECT	@PagosporSeparacionMov=Campo
FROM	DimCfg
WHERE	Empresa=@Empresa AND columna=30
SELECT	@AsimiladosASalarios=Campo
FROM	DimCfg
WHERE	Empresa=@Empresa AND columna=31
SELECT	@PagoPatronEfectuados=Campo
FROM	DimCfg
WHERE	Empresa=@Empresa AND columna=32
DELETE	#PasoSeparacion
INSERT	#PasoSeparacion(
Personal)
SELECT	b.Personal
FROM	Nomina a
JOIN	NominaD b ON a.id=b.id
WHERE	a.Mov =ltrim(rtrim(@PagosporSeparacionMov))
AND a.FechaA BETWEEN @FechaD AND @FechaA
AND a.Estatus IN ('Concluido')
AND b.Personal <> NULL
GROUP	BY b.Personal
ORDER	BY b.Personal
DELETE  #PasoPagoPatronEfectuados
INSERT  #PasoPagoPatronEfectuados(
Personal)
SELECT  d.Personal
FROM	Nomina a
JOIN	NominaD d ON a.id=d.id
WHERE  a.Mov IN (SELECT LTRIM(RTRIM(d.Mov)) FROM DimCfg c JOIN DimCfgD d ON(c.ID = d.ID) WHERE c.Empresa = @Empresa AND c.Columna = 32)
AND a.FechaA BETWEEN @FechaD AND @FechaA
AND a.Estatus IN ('Concluido')
AND d.Personal <> NULL
DELETE	#PasoAsimilado
INSERT	#PasoAsimilado(
Personal)
SELECT	b.Personal
FROM	Nomina a
JOIN	NominaD b ON a.id=b.id
WHERE	a.Mov =ltrim(rtrim(@AsimiladosASalarios))
AND a.FechaA BETWEEN @FechaD AND @FechaA
AND a.Estatus IN ('Concluido')
AND b.Personal <> NULL
GROUP	BY b.Personal
ORDER	BY b.Personal
DELETE	#PasoPagoPatron
INSERT	#PasoPagoPatron(
Personal)
SELECT	b.Personal
FROM	Nomina a
JOIN	NominaD b ON a.id=b.id
WHERE	a.Mov =ltrim(rtrim(@PagoPatronEfectuados))
AND a.FechaA BETWEEN @FechaD AND @FechaA
AND a.Estatus IN ('Concluido')
AND b.Personal <> NULL
GROUP	BY b.Personal
ORDER	BY b.Personal
UPDATE DIMPaso SET Dim30 = '2',Dim31 = '2',Dim32 = '2',Dim9='2'  WHERE Estacion = @Estacion AND Personal <>'0'
UPDATE DimPaso SET Dim30 = '1', Dim32 = '1' WHERE Estacion = @Estacion AND Personal IN(SELECT Personal FROM #PasoSeparacion)
UPDATE DimPaso SET Dim31 = '1' WHERE Estacion = @Estacion AND Personal IN(SELECT Personal FROM #PasoAsimilado)
UPDATE DimPaso SET Dim32 = '1' WHERE Estacion = @Estacion AND Personal IN(SELECT Personal FROM #PasoPagoPatron)
UPDATE DimPaso SET Dim9 = '1' WHERE Estacion = @Estacion AND Personal IN(SELECT Personal FROM #PasoAjusteAnual)
UPDATE DimPaso SET Dim31 = '1', Dim32 = 1 WHERE Estacion = @Estacion AND Personal IN(SELECT Personal FROM #PasoPagoPatronEfectuados)
UPDATE DimPaso SET Dim70 = ISNULL(ROUND(i.Importe,0,0),0),Dim32 = '1'
FROM DimPaso d
JOIN #PasoPTUa i ON d.Personal = i.Personal
WHERE Estacion = @Estacion 
UPDATE DimPaso SET Dim71 = ISNULL(ROUND(i.Importe,0,0),0),Dim32 = '1'
FROM DimPaso d
JOIN #PasoPTUb i ON d.Personal = i.Personal
WHERE Estacion = @Estacion 
UPDATE DIMPaso SET Dim51='',Dim52='',Dim53='',Dim54='',Dim55='',Dim56='',Dim57='' WHERE Estacion = @Estacion AND Personal <>'0' AND Dim31 = '2'
/*********************CONDICIONANTES****************************/
UPDATE	DIMPaso
SET	Dim58='',Dim59='',Dim60='',Dim61='',Dim62='',Dim63='',Dim64='',Dim65='',Dim66='',Dim67='',Dim68='',Dim69='',
Dim70='',Dim71='',Dim72='',Dim73='',Dim74='',Dim75='',Dim76='',Dim77='',Dim78='',Dim79='',Dim80='',Dim81='',Dim82='',Dim83='',Dim84='',Dim85='',
Dim86='',Dim87='',Dim88='',Dim89='',Dim90='',Dim91='',Dim92='',Dim93='',Dim94='',Dim95='',Dim96='',Dim97='',Dim98='',Dim99='',Dim100='',Dim101='',
Dim102='',Dim103='',Dim104='',Dim105='',Dim106='',Dim107='',Dim108='',Dim109='',Dim110='',Dim111='',Dim112='',Dim113='',Dim114='',Dim115='',Dim116='',
Dim117='',Dim118='',Dim119='',Dim120='',Dim121='',Dim122='',Dim123='',Dim124='',Dim125='',Dim126=''
WHERE	Estacion=@Estacion
AND Personal<>'0'
AND  Personal in (SELECT Personal FROM #PasoPersonal)
AND Personal NOT in (SELECT Personal FROM #PasoSubTotales WHERE Columna=58 AND Personal<>'0' AND SubTotal>0 )
AND Personal NOT IN (SELECT Personal FROM #PasoPTUa)
AND Personal NOT IN (SELECT Personal FROM #PasoPTUb)
AND Personal NOT IN (SELECT Personal FROM #PasoSeparacion)
AND Personal NOT IN (Select Personal FROM #PasoPagoPatronEfectuados)
UPDATE	DIMPaso set Dim14='0'
WHERE	Estacion=@Estacion AND  Dim31='2'
SELECT	*
FROM	DIMPaso
WHERE	Estacion=@Estacion
ORDER	BY Personal
END
RETURN(0)
SET NOCOUNT OFF
END

