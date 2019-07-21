SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spRSVerContResultadosAnualCC
@Empresa		varchar(5),
@SEjercicio		varchar(4),
@CentroCostos	varchar(Max) = NULL,
@Moneda			varchar(10) = NULL,
@SUEN			varchar(10)	= NULL,
@Proyecto		varchar(50)= NULL,
@CentroCostos2	varchar(50)	= NULL,
@CentroCostos3	varchar(50)	= NULL

AS
BEGIN
DECLARE @Ejercicio		int,
@UEN				int,
@CentroCostosAux		varchar(20),
@CentroCostosAuxAnt	varchar(20)
CREATE TABLE #Temp(
Orden		        int		    NOT NULL, 
ID					int			NULL,
Clase				varchar(50)	COLLATE Database_Default NULL,
SubClase			varchar(20)	COLLATE Database_Default NULL,
Rama				varchar(20)	COLLATE Database_Default NULL,
RamaDesc			varchar(100)COLLATE Database_Default NULL,
RamaEsAcreedora	bit			NOT NULL DEFAULT 0,
Cuenta				varchar(20)	COLLATE Database_Default NULL,
Descripcion		varchar(100)COLLATE Database_Default NULL,
EsAcreedora		bit			NOT NULL DEFAULT 0,
Saldo				money		NULL,
SaldoAlEne			money		NULL,
SaldoAlFeb			money		NULL,
SaldoAlMar			money		NULL,
SaldoAlAbr			money		NULL,
SaldoAlMay			money		NULL,
SaldoAlJun			money		NULL,
SaldoAlJul			money		NULL,
SaldoAlAgo			money		NULL,
SaldoAlSep			money		NULL,
SaldoAlOct 		money		NULL,
SaldoAlNov			money		NULL,
SaldoAlDic			money		NULL,
Ingresos			money		NULL,
IngresosAlEne		money		NULL,
IngresosAlFeb		money		NULL,
IngresosAlMar		money		NULL,
IngresosAlAbr		money		NULL,
IngresosAlMay		money		NULL,
IngresosAlJun		money		NULL,
IngresosAlJul		money		NULL,
IngresosAlAgo		money		NULL,
IngresosAlSep		money		NULL,
IngresosAlOct		money		NULL,
IngresosAlNov		money		NULL,
IngresosAlDic		money		NULL,
Porcentaje			float		NULL,
PorcentajeAlEne	float		NULL,
PorcentajeAlFeb	float		NULL,
PorcentajeAlMar	float		NULL,
PorcentajeAlAbr	float		NULL,
PorcentajeAlMay	float		NULL,
PorcentajeAlJun	float		NULL,
PorcentajeAlJul	float		NULL,
PorcentajeAlAgo	float		NULL,
PorcentajeAlSep	float		NULL,
PorcentajeAlOct	float		NULL,
PorcentajeAlNov	float		NULL,
PorcentajeAlDic	float		NULL
)
CREATE TABLE #Consolidado(
Orden		        int		    NOT NULL, 
RID				int			IDENTITY(1,1) NOT NULL,
CentroCostos       varchar(20) COLLATE Database_Default NULL,
Clase				varchar(50)	COLLATE Database_Default NULL,
SubClase			varchar(20)	COLLATE Database_Default NULL,
Rama				varchar(20)	COLLATE Database_Default NULL,
RamaDesc			varchar(100)COLLATE Database_Default NULL,
RamaEsAcreedora	bit			NOT NULL DEFAULT 0,
Cuenta				varchar(20)	COLLATE Database_Default NULL,
Descripcion		varchar(100)COLLATE Database_Default NULL,
EsAcreedora		bit			NOT NULL DEFAULT 0,
Saldo				money		NULL,
SaldoAlEne			money		NULL,
SaldoAlFeb			money		NULL,
SaldoAlMar			money		NULL,
SaldoAlAbr			money		NULL,
SaldoAlMay			money		NULL,
SaldoAlJun			money		NULL,
SaldoAlJul			money		NULL,
SaldoAlAgo			money		NULL,
SaldoAlSep			money		NULL,
SaldoAlOct 		money		NULL,
SaldoAlNov			money		NULL,
SaldoAlDic			money		NULL,
Ingresos			money		NULL,
IngresosAlEne		money		NULL,
IngresosAlFeb		money		NULL,
IngresosAlMar		money		NULL,
IngresosAlAbr		money		NULL,
IngresosAlMay		money		NULL,
IngresosAlJun		money		NULL,
IngresosAlJul		money		NULL,
IngresosAlAgo		money		NULL,
IngresosAlSep		money		NULL,
IngresosAlOct		money		NULL,
IngresosAlNov		money		NULL,
IngresosAlDic		money		NULL,
Porcentaje			float		NULL,
PorcentajeAlEne	float		NULL,
PorcentajeAlFeb	float		NULL,
PorcentajeAlMar	float		NULL,
PorcentajeAlAbr	float		NULL,
PorcentajeAlMay	float		NULL,
PorcentajeAlJun	float		NULL,
PorcentajeAlJul	float		NULL,
PorcentajeAlAgo	float		NULL,
PorcentajeAlSep	float		NULL,
PorcentajeAlOct	float		NULL,
PorcentajeAlNov	float		NULL,
PorcentajeAlDic	float		NULL
)
IF @Moneda='' SELECT @Moneda = NULL
IF @SUEN='' SELECT @SUEN = NULL
IF @Proyecto='' SELECT @Proyecto = NULL
IF @CentroCostos2='' SELECT @CentroCostos2 = NULL
IF @CentroCostos3='' SELECT @CentroCostos3 = NULL
SELECT @Ejercicio = CONVERT(int, @SEjercicio),
@UEN = CONVERT(int, @SUEN)
CREATE TABLE #CentroCostos(CentroCostos varchar(20) COLLATE Database_Default )
IF @CentroCostos='(Sin Desglose)' AND LEN(@CentroCostos)<=14 SELECT @CentroCostos = NULL 
IF @CentroCostos<>'(Sin Desglose)' AND LEN(@CentroCostos)>14 SELECT @CentroCostos = '(Todos)' 
IF @CentroCostos = ''
BEGIN
INSERT INTO #Temp(
Orden, ID, Clase, SubClase, Rama, RamaDesc, RamaEsAcreedora, Cuenta, Descripcion, EsAcreedora, Saldo, SaldoAlEne, SaldoAlFeb, SaldoAlMar, SaldoAlAbr, SaldoAlMay, SaldoAlJun, SaldoAlJul, SaldoAlAgo, SaldoAlSep, SaldoAlOct, SaldoAlNov, SaldoAlDic, Ingresos, IngresosAlEne, IngresosAlFeb, IngresosAlMar, IngresosAlAbr, IngresosAlMay, IngresosAlJun, IngresosAlJul, IngresosAlAgo, IngresosAlSep, IngresosAlOct, IngresosAlNov, IngresosAlDic, Porcentaje, PorcentajeAlEne, PorcentajeAlFeb, PorcentajeAlMar, PorcentajeAlAbr, PorcentajeAlMay, PorcentajeAlJun, PorcentajeAlJul, PorcentajeAlAgo, PorcentajeAlSep, PorcentajeAlOct, PorcentajeAlNov, PorcentajeAlDic) 
EXEC spVerContResultadosAnualRSCC @Empresa, @Ejercicio, '', @Moneda, NULL, @UEN, @Proyecto, @CentroCostos2, @CentroCostos3
IF EXISTS(SELECT * FROM #Temp)
INSERT INTO #Consolidado(
Orden, CentroCostos, Clase, SubClase, Rama, RamaDesc, RamaEsAcreedora, Cuenta, Descripcion, EsAcreedora, Saldo, SaldoAlEne, SaldoAlFeb, SaldoAlMar, SaldoAlAbr, SaldoAlMay, SaldoAlJun, SaldoAlJul, SaldoAlAgo, SaldoAlSep, SaldoAlOct, SaldoAlNov, SaldoAlDic, Ingresos, IngresosAlEne, IngresosAlFeb, IngresosAlMar, IngresosAlAbr, IngresosAlMay, IngresosAlJun, IngresosAlJul, IngresosAlAgo, IngresosAlSep, IngresosAlOct, IngresosAlNov, IngresosAlDic, Porcentaje, PorcentajeAlEne, PorcentajeAlFeb, PorcentajeAlMar, PorcentajeAlAbr, PorcentajeAlMay, PorcentajeAlJun, PorcentajeAlJul, PorcentajeAlAgo, PorcentajeAlSep, PorcentajeAlOct, PorcentajeAlNov, PorcentajeAlDic) 
SELECT Orden, '', Clase, SubClase, Rama, RamaDesc, RamaEsAcreedora, Cuenta, Descripcion, EsAcreedora, Saldo, SaldoAlEne, SaldoAlFeb, SaldoAlMar, SaldoAlAbr, SaldoAlMay, SaldoAlJun, SaldoAlJul, SaldoAlAgo, SaldoAlSep, SaldoAlOct, SaldoAlNov, SaldoAlDic, Ingresos, IngresosAlEne, IngresosAlFeb, IngresosAlMar, IngresosAlAbr, IngresosAlMay, IngresosAlJun, IngresosAlJul, IngresosAlAgo, IngresosAlSep, IngresosAlOct, IngresosAlNov, IngresosAlDic, Porcentaje, PorcentajeAlEne, PorcentajeAlFeb, PorcentajeAlMar, PorcentajeAlAbr, PorcentajeAlMay, PorcentajeAlJun, PorcentajeAlJul, PorcentajeAlAgo, PorcentajeAlSep, PorcentajeAlOct, PorcentajeAlNov, PorcentajeAlDic
FROM #Temp
SELECT @CentroCostos = NULL
END
IF @CentroCostos LIKE '%(Todos)%'
BEGIN
INSERT INTO #CentroCostos SELECT CentroCostos FROM CentroCostos
INSERT INTO #CentroCostos SELECT 'Sin CC'
SELECT @CentroCostos = NULL
END
IF @CentroCostos IS NOT NULL
BEGIN
INSERT INTO #CentroCostos SELECT ValorTexto FROM dbo.fnParseaCadena(@CentroCostos, ',')
DELETE FROM #CentroCostos WHERE CentroCostos='(Sin Desglose)'  
END
SELECT @CentroCostosAuxAnt = ''
WHILE(1=1)
BEGIN
SELECT @CentroCostosAux = MIN(CentroCostos)
FROM #CentroCostos
WHERE CentroCostos > @CentroCostosAuxAnt
IF @CentroCostosAux IS NULL BREAK
SELECT @CentroCostosAuxAnt = @CentroCostosAux
TRUNCATE TABLE #Temp
INSERT INTO #Temp(
Orden, ID, Clase, SubClase, Rama, RamaDesc, RamaEsAcreedora, Cuenta, Descripcion, EsAcreedora, Saldo, SaldoAlEne, SaldoAlFeb, SaldoAlMar, SaldoAlAbr, SaldoAlMay, SaldoAlJun, SaldoAlJul, SaldoAlAgo, SaldoAlSep, SaldoAlOct, SaldoAlNov, SaldoAlDic, Ingresos, IngresosAlEne, IngresosAlFeb, IngresosAlMar, IngresosAlAbr, IngresosAlMay, IngresosAlJun, IngresosAlJul, IngresosAlAgo, IngresosAlSep, IngresosAlOct, IngresosAlNov, IngresosAlDic, Porcentaje, PorcentajeAlEne, PorcentajeAlFeb, PorcentajeAlMar, PorcentajeAlAbr, PorcentajeAlMay, PorcentajeAlJun, PorcentajeAlJul, PorcentajeAlAgo, PorcentajeAlSep, PorcentajeAlOct, PorcentajeAlNov, PorcentajeAlDic)
EXEC spVerContResultadosAnualRSCC @Empresa, @Ejercicio, @CentroCostosAux, @Moneda, NULL, @UEN,  @Proyecto, @CentroCostos2, @CentroCostos3
IF EXISTS(SELECT * FROM #Temp)
INSERT INTO #Consolidado(
Orden, CentroCostos,    Clase, SubClase, Rama, RamaDesc, RamaEsAcreedora, Cuenta, Descripcion, EsAcreedora, Saldo, SaldoAlEne, SaldoAlFeb, SaldoAlMar, SaldoAlAbr, SaldoAlMay, SaldoAlJun, SaldoAlJul, SaldoAlAgo, SaldoAlSep, SaldoAlOct, SaldoAlNov, SaldoAlDic, Ingresos, IngresosAlEne, IngresosAlFeb, IngresosAlMar, IngresosAlAbr, IngresosAlMay, IngresosAlJun, IngresosAlJul, IngresosAlAgo, IngresosAlSep, IngresosAlOct, IngresosAlNov, IngresosAlDic, Porcentaje, PorcentajeAlEne, PorcentajeAlFeb, PorcentajeAlMar, PorcentajeAlAbr, PorcentajeAlMay, PorcentajeAlJun, PorcentajeAlJul, PorcentajeAlAgo, PorcentajeAlSep, PorcentajeAlOct, PorcentajeAlNov, PorcentajeAlDic)
SELECT Orden, @CentroCostosAux, Clase, SubClase, Rama, RamaDesc, RamaEsAcreedora, Cuenta, Descripcion, EsAcreedora, Saldo, SaldoAlEne, SaldoAlFeb, SaldoAlMar, SaldoAlAbr, SaldoAlMay, SaldoAlJun, SaldoAlJul, SaldoAlAgo, SaldoAlSep, SaldoAlOct, SaldoAlNov, SaldoAlDic, Ingresos, IngresosAlEne, IngresosAlFeb, IngresosAlMar, IngresosAlAbr, IngresosAlMay, IngresosAlJun, IngresosAlJul, IngresosAlAgo, IngresosAlSep, IngresosAlOct, IngresosAlNov, IngresosAlDic, Porcentaje, PorcentajeAlEne, PorcentajeAlFeb, PorcentajeAlMar, PorcentajeAlAbr, PorcentajeAlMay, PorcentajeAlJun, PorcentajeAlJul, PorcentajeAlAgo, PorcentajeAlSep, PorcentajeAlOct, PorcentajeAlNov, PorcentajeAlDic
FROM #Temp
END
INSERT INTO #Consolidado(
CentroCostos, Orden, Clase, SubClase, Rama, RamaDesc, RamaEsAcreedora, Cuenta, Descripcion, EsAcreedora, Saldo, SaldoAlEne, SaldoAlFeb, SaldoAlMar, SaldoAlAbr, SaldoAlMay, SaldoAlJun, SaldoAlJul, SaldoAlAgo, SaldoAlSep, SaldoAlOct, SaldoAlNov, SaldoAlDic)
SELECT '', 4, 'Utilidad Bruta - Gastos de Operación', 'UAFIRDA', Rama, 'UAFIRDA', RamaEsAcreedora, '', '', 0,
SUM(Saldo) Saldo,
SUM(SaldoAlEne) SaldoAlEne,
SUM(SaldoAlFeb) SaldoAlFeb,
SUM(SaldoAlMar) SaldoAlMar,
SUM(SaldoAlAbr) SaldoAlAbr,
SUM(SaldoAlMay) SaldoAlMay,
SUM(SaldoAlJun) SaldoAlJun,
SUM(SaldoAlJul) SaldoAlJul,
SUM(SaldoAlAgo) SaldoAlAgo,
SUM(SaldoAlSep) SaldoAlSep,
SUM(SaldoAlOct) SaldoAlOct,
SUM(SaldoAlNov) SaldoAlNov,
SUM(SaldoAlDic) SaldoAlDic
FROM #Consolidado
WHERE Rama IN ('S','T','U','U2')
GROUP BY Rama, RamaEsAcreedora
INSERT INTO #Consolidado(
CentroCostos, Orden, Clase, SubClase, Rama, RamaDesc, RamaEsAcreedora, Cuenta, Descripcion, EsAcreedora, Saldo, SaldoAlEne, SaldoAlFeb, SaldoAlMar, SaldoAlAbr, SaldoAlMay, SaldoAlJun, SaldoAlJul, SaldoAlAgo, SaldoAlSep, SaldoAlOct, SaldoAlNov, SaldoAlDic)
SELECT '', 6, 'Utilidad Neta', '', Rama, 'Utilidad Neta', RamaEsAcreedora, '', '', 0,
SUM(Saldo) Saldo,
SUM(SaldoAlEne) SaldoAlEne,
SUM(SaldoAlFeb) SaldoAlFeb,
SUM(SaldoAlMar) SaldoAlMar,
SUM(SaldoAlAbr) SaldoAlAbr,
SUM(SaldoAlMay) SaldoAlMay,
SUM(SaldoAlJun) SaldoAlJun,
SUM(SaldoAlJul) SaldoAlJul,
SUM(SaldoAlAgo) SaldoAlAgo,
SUM(SaldoAlSep) SaldoAlSep,
SUM(SaldoAlOct) SaldoAlOct,
SUM(SaldoAlNov) SaldoAlNov,
SUM(SaldoAlDic) SaldoAlDic
FROM #Consolidado
WHERE Rama IN ('S','T','U','U2','U3') AND SubClase<>'UAFIRDA'
GROUP BY Rama, RamaEsAcreedora
UPDATE #Consolidado SET CentroCostos='Sin Centro Costos' WHERE CentroCostos='Sin CC' 
SELECT Clase, SubClase, Rama,
SUM(CASE WHEN RamaEsAcreedora=1 THEN Saldo*-1 ELSE Saldo END) Saldo,
SUM(CASE WHEN RamaEsAcreedora=1 THEN SaldoAlEne*-1 ELSE SaldoAlEne END) SaldoAlEne,
SUM(CASE WHEN RamaEsAcreedora=1 THEN SaldoAlFeb*-1 ELSE SaldoAlFeb END) SaldoAlFeb,
SUM(CASE WHEN RamaEsAcreedora=1 THEN SaldoAlMar*-1 ELSE SaldoAlMar END) SaldoAlMar,
SUM(CASE WHEN RamaEsAcreedora=1 THEN SaldoAlAbr*-1 ELSE SaldoAlAbr END) SaldoAlAbr,
SUM(CASE WHEN RamaEsAcreedora=1 THEN SaldoAlMay*-1 ELSE SaldoAlMay END) SaldoAlMay,
SUM(CASE WHEN RamaEsAcreedora=1 THEN SaldoAlJun*-1 ELSE SaldoAlJun END) SaldoAlJun,
SUM(CASE WHEN RamaEsAcreedora=1 THEN SaldoAlJul*-1 ELSE SaldoAlJul END) SaldoAlJul,
SUM(CASE WHEN RamaEsAcreedora=1 THEN SaldoAlAgo*-1 ELSE SaldoAlAgo END) SaldoAlAgo,
SUM(CASE WHEN RamaEsAcreedora=1 THEN SaldoAlSep*-1 ELSE SaldoAlSep END) SaldoAlSep,
SUM(CASE WHEN RamaEsAcreedora=1 THEN SaldoAlOct*-1 ELSE SaldoAlOct END) SaldoAlOct,
SUM(CASE WHEN RamaEsAcreedora=1 THEN SaldoAlNov*-1 ELSE SaldoAlNov END) SaldoAlNov,
SUM(CASE WHEN RamaEsAcreedora=1 THEN SaldoAlDic*-1 ELSE SaldoAlDic END) SaldoAlDic
INTO #ConsolidadoAcumClaseSubClaseRama
FROM #Consolidado
GROUP BY Clase, SubClase, Rama
UPDATE #Consolidado
SET Saldo=ISNULL(SaldoAlEne,0)+ISNULL(SaldoAlFeb,0)+ISNULL(SaldoAlMar,0)+ISNULL(SaldoAlAbr,0)+
ISNULL(SaldoAlMay,0)+ISNULL(SaldoAlJun,0)+ISNULL(SaldoAlJul,0)+ISNULL(SaldoAlAgo,0)+
ISNULL(SaldoAlSep,0)+ISNULL(SaldoAlOct,0)+ISNULL(SaldoAlNov,0)+ISNULL(SaldoAlDic,0)
UPDATE #Consolidado
SET Porcentaje=Saldo/(SELECT CASE
WHEN ISNULL(csr.SaldoAlEne,0)+ISNULL(csr.SaldoAlFeb,0)+ISNULL(csr.SaldoAlMar,0)+
ISNULL(csr.SaldoAlAbr,0)+ISNULL(csr.SaldoAlMay,0)+ISNULL(csr.SaldoAlJun,0)+
ISNULL(csr.SaldoAlJul,0)+ISNULL(csr.SaldoAlAgo,0)+ISNULL(csr.SaldoAlSep,0)+
ISNULL(csr.SaldoAlOct,0)+ISNULL(csr.SaldoAlNov,0)+ISNULL(csr.SaldoAlDic,0)=0
THEN 1
ELSE ISNULL(csr.SaldoAlEne,0)+ISNULL(csr.SaldoAlFeb,0)+ISNULL(csr.SaldoAlMar,0)+
ISNULL(csr.SaldoAlAbr,0)+ISNULL(csr.SaldoAlMay,0)+ISNULL(csr.SaldoAlJun,0)+
ISNULL(csr.SaldoAlJul,0)+ISNULL(csr.SaldoAlAgo,0)+ISNULL(csr.SaldoAlSep,0)+
ISNULL(csr.SaldoAlOct,0)+ISNULL(csr.SaldoAlNov,0)+ISNULL(csr.SaldoAlDic,0)
END  FROM #ConsolidadoAcumClaseSubClaseRama csr WHERE csr.Clase='Utilidad Bruta' AND csr.SubClase='Ventas' AND csr.Rama='S')
SELECT RID, Orden,
CentroCostos, Clase, SubClase, Rama, RamaDesc, RamaEsAcreedora, Cuenta, Descripcion, EsAcreedora,
ISNULL(Saldo,0) Saldo, ISNULL(SaldoAlEne,0) SaldoAlEne, ISNULL(SaldoAlFeb,0) SaldoAlFeb, ISNULL(SaldoAlMar,0) SaldoAlMar,
ISNULL(SaldoAlAbr,0) SaldoAlAbr, ISNULL(SaldoAlMay,0) SaldoAlMay,	ISNULL(SaldoAlJun,0) SaldoAlJun,
ISNULL(SaldoAlJul,0) SaldoAlJul, ISNULL(SaldoAlAgo,0) SaldoAlAgo,	ISNULL(SaldoAlSep,0) SaldoAlSep,
ISNULL(SaldoAlOct,0) SaldoAlOct, ISNULL(SaldoAlNov,0) SaldoAlNov,  ISNULL(SaldoAlDic,0) SaldoAlDic,
ISNULL(Ingresos,0) Ingresos, ISNULL(IngresosAlEne,0) IngresosAlEne, ISNULL(IngresosAlFeb,0) IngresosAlFeb,
ISNULL(IngresosAlMar,0) IngresosAlMar, ISNULL(IngresosAlAbr,0) IngresosAlAbr,
ISNULL(IngresosAlMay,0) IngresosAlMay, ISNULL(IngresosAlJun,0) IngresosAlJun,
ISNULL(IngresosAlJul,0) IngresosAlJul, ISNULL(IngresosAlAgo,0) IngresosAlAgo,
ISNULL(IngresosAlSep,0) IngresosAlSep, ISNULL(IngresosAlOct,0) IngresosAlOct,
ISNULL(IngresosAlNov,0) IngresosAlNov,  ISNULL(IngresosAlDic,0) IngresosAlDic,
ISNULL(Porcentaje,0) Porcentaje,
ISNULL(SaldoAlEne,0)/(SELECT CASE WHEN ISNULL(csr.SaldoAlEne,0)=0 THEN 1 ELSE ISNULL(csr.SaldoAlEne,0) END  FROM #ConsolidadoAcumClaseSubClaseRama csr WHERE csr.Clase='Utilidad Bruta' AND csr.SubClase='Ventas' AND csr.Rama='S') PorcentajeAlEne,
ISNULL(SaldoAlFeb,0)/(SELECT CASE WHEN ISNULL(csr.SaldoAlFeb,0)=0 THEN 1 ELSE ISNULL(csr.SaldoAlFeb,0) END  FROM #ConsolidadoAcumClaseSubClaseRama csr WHERE csr.Clase='Utilidad Bruta' AND csr.SubClase='Ventas' AND csr.Rama='S') PorcentajeAlFeb,
ISNULL(SaldoAlMar,0)/(SELECT CASE WHEN ISNULL(csr.SaldoAlMar,0)=0 THEN 1 ELSE ISNULL(csr.SaldoAlMar,0) END  FROM #ConsolidadoAcumClaseSubClaseRama csr WHERE csr.Clase='Utilidad Bruta' AND csr.SubClase='Ventas' AND csr.Rama='S') PorcentajeAlMar,
ISNULL(SaldoAlAbr,0)/(SELECT CASE WHEN ISNULL(csr.SaldoAlAbr,0)=0 THEN 1 ELSE ISNULL(csr.SaldoAlAbr,0) END  FROM #ConsolidadoAcumClaseSubClaseRama csr WHERE csr.Clase='Utilidad Bruta' AND csr.SubClase='Ventas' AND csr.Rama='S') PorcentajeAlAbr,
ISNULL(SaldoAlMay,0)/(SELECT CASE WHEN ISNULL(csr.SaldoAlMay,0)=0 THEN 1 ELSE ISNULL(csr.SaldoAlMay,0) END  FROM #ConsolidadoAcumClaseSubClaseRama csr WHERE csr.Clase='Utilidad Bruta' AND csr.SubClase='Ventas' AND csr.Rama='S') PorcentajeAlMay,
ISNULL(SaldoAlJun,0)/(SELECT CASE WHEN ISNULL(csr.SaldoAlJun,0)=0 THEN 1 ELSE ISNULL(csr.SaldoAlJun,0) END  FROM #ConsolidadoAcumClaseSubClaseRama csr WHERE csr.Clase='Utilidad Bruta' AND csr.SubClase='Ventas' AND csr.Rama='S') PorcentajeAlJun,
ISNULL(SaldoAlJul,0)/(SELECT CASE WHEN ISNULL(csr.SaldoAlJul,0)=0 THEN 1 ELSE ISNULL(csr.SaldoAlJul,0) END  FROM #ConsolidadoAcumClaseSubClaseRama csr WHERE csr.Clase='Utilidad Bruta' AND csr.SubClase='Ventas' AND csr.Rama='S') PorcentajeAlJul,
ISNULL(SaldoAlAgo,0)/(SELECT CASE WHEN ISNULL(csr.SaldoAlAgo,0)=0 THEN 1 ELSE ISNULL(csr.SaldoAlAgo,0) END  FROM #ConsolidadoAcumClaseSubClaseRama csr WHERE csr.Clase='Utilidad Bruta' AND csr.SubClase='Ventas' AND csr.Rama='S') PorcentajeAlAgo,
ISNULL(SaldoAlSep,0)/(SELECT CASE WHEN ISNULL(csr.SaldoAlSep,0)=0 THEN 1 ELSE ISNULL(csr.SaldoAlSep,0) END  FROM #ConsolidadoAcumClaseSubClaseRama csr WHERE csr.Clase='Utilidad Bruta' AND csr.SubClase='Ventas' AND csr.Rama='S') PorcentajeAlSep,
ISNULL(SaldoAlOct,0)/(SELECT CASE WHEN ISNULL(csr.SaldoAlOct,0)=0 THEN 1 ELSE ISNULL(csr.SaldoAlOct,0) END  FROM #ConsolidadoAcumClaseSubClaseRama csr WHERE csr.Clase='Utilidad Bruta' AND csr.SubClase='Ventas' AND csr.Rama='S') PorcentajeAlOct,
ISNULL(SaldoAlNov,0)/(SELECT CASE WHEN ISNULL(csr.SaldoAlNov,0)=0 THEN 1 ELSE ISNULL(csr.SaldoAlNov,0) END  FROM #ConsolidadoAcumClaseSubClaseRama csr WHERE csr.Clase='Utilidad Bruta' AND csr.SubClase='Ventas' AND csr.Rama='S') PorcentajeAlNov,
ISNULL(SaldoAlDic,0)/(SELECT CASE WHEN ISNULL(csr.SaldoAlDic,0)=0 THEN 1 ELSE ISNULL(csr.SaldoAlDic,0) END  FROM #ConsolidadoAcumClaseSubClaseRama csr WHERE csr.Clase='Utilidad Bruta' AND csr.SubClase='Ventas' AND csr.Rama='S') PorcentajeAlDic
FROM #Consolidado c
ORDER BY Orden, Clase, Rama, Cuenta, CentroCostos
RETURN
END

