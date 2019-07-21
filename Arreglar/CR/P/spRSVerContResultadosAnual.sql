SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spRSVerContResultadosAnual
@Empresa		varchar(5),
@SEjercicio		varchar(4),
@CentroCostos	varchar(20) = NULL,
@Moneda			varchar(10) = NULL,
@SUEN			varchar(10)	= NULL,
@Proyecto		varchar(max)= NULL,
@CentroCostos2	varchar(50)	= NULL,
@CentroCostos3	varchar(50)	= NULL

AS
BEGIN
DECLARE @Ejercicio		int,
@UEN				int,
@ProyectoAux		varchar(50),
@ProyectoAuxAnt	varchar(50)
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
Proyecto			varchar(50)	COLLATE Database_Default NULL,
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
IF @CentroCostos='' SELECT @CentroCostos = NULL
IF @Moneda='' SELECT @Moneda = NULL
IF @SUEN='' SELECT @SUEN = NULL
IF @CentroCostos2='' SELECT @CentroCostos2 = NULL
IF @CentroCostos3='' SELECT @CentroCostos3 = NULL
SELECT @Ejercicio = CONVERT(int, @SEjercicio),
@UEN = CONVERT(int, @SUEN)
CREATE TABLE #Proy(Proyecto	varchar(50) COLLATE Database_Default )
IF @Proyecto = ''
BEGIN
INSERT INTO #Temp(
Orden, ID, Clase, SubClase, Rama, RamaDesc, RamaEsAcreedora, Cuenta, Descripcion, EsAcreedora, Saldo, SaldoAlEne, SaldoAlFeb, SaldoAlMar, SaldoAlAbr, SaldoAlMay, SaldoAlJun, SaldoAlJul, SaldoAlAgo, SaldoAlSep, SaldoAlOct, SaldoAlNov, SaldoAlDic, Ingresos, IngresosAlEne, IngresosAlFeb, IngresosAlMar, IngresosAlAbr, IngresosAlMay, IngresosAlJun, IngresosAlJul, IngresosAlAgo, IngresosAlSep, IngresosAlOct, IngresosAlNov, IngresosAlDic, Porcentaje, PorcentajeAlEne, PorcentajeAlFeb, PorcentajeAlMar, PorcentajeAlAbr, PorcentajeAlMay, PorcentajeAlJun, PorcentajeAlJul, PorcentajeAlAgo, PorcentajeAlSep, PorcentajeAlOct, PorcentajeAlNov, PorcentajeAlDic)
EXEC spVerContResultadosAnualRSProy @Empresa, @Ejercicio, @CentroCostos, @Moneda, NULL, @UEN, '', @CentroCostos2, @CentroCostos3
IF EXISTS(SELECT * FROM #Temp)
INSERT INTO #Consolidado(
Proyecto, Orden, Clase, SubClase, Rama, RamaDesc, RamaEsAcreedora, Cuenta, Descripcion, EsAcreedora, Saldo, SaldoAlEne, SaldoAlFeb, SaldoAlMar, SaldoAlAbr, SaldoAlMay, SaldoAlJun, SaldoAlJul, SaldoAlAgo, SaldoAlSep, SaldoAlOct, SaldoAlNov, SaldoAlDic, Ingresos, IngresosAlEne, IngresosAlFeb, IngresosAlMar, IngresosAlAbr, IngresosAlMay, IngresosAlJun, IngresosAlJul, IngresosAlAgo, IngresosAlSep, IngresosAlOct, IngresosAlNov, IngresosAlDic, Porcentaje, PorcentajeAlEne, PorcentajeAlFeb, PorcentajeAlMar, PorcentajeAlAbr, PorcentajeAlMay, PorcentajeAlJun, PorcentajeAlJul, PorcentajeAlAgo, PorcentajeAlSep, PorcentajeAlOct, PorcentajeAlNov, PorcentajeAlDic)
SELECT '',       Orden, Clase, SubClase, Rama, RamaDesc, RamaEsAcreedora, Cuenta, Descripcion, EsAcreedora, Saldo, SaldoAlEne, SaldoAlFeb, SaldoAlMar, SaldoAlAbr, SaldoAlMay, SaldoAlJun, SaldoAlJul, SaldoAlAgo, SaldoAlSep, SaldoAlOct, SaldoAlNov, SaldoAlDic, Ingresos, IngresosAlEne, IngresosAlFeb, IngresosAlMar, IngresosAlAbr, IngresosAlMay, IngresosAlJun, IngresosAlJul, IngresosAlAgo, IngresosAlSep, IngresosAlOct, IngresosAlNov, IngresosAlDic, Porcentaje, PorcentajeAlEne, PorcentajeAlFeb, PorcentajeAlMar, PorcentajeAlAbr, PorcentajeAlMay, PorcentajeAlJun, PorcentajeAlJul, PorcentajeAlAgo, PorcentajeAlSep, PorcentajeAlOct, PorcentajeAlNov, PorcentajeAlDic
FROM #Temp
END
IF @Proyecto LIKE '%(Todos)%'
BEGIN
INSERT INTO #Proy SELECT Proyecto FROM Proy
INSERT INTO #Proy SELECT 'Sin Proyecto'
SELECT @Proyecto = NULL
END
IF @Proyecto IS NOT NULL
INSERT INTO #Proy SELECT ValorTexto FROM dbo.fnParseaCadena(@Proyecto, ',')
SELECT @ProyectoAuxAnt = ''
WHILE(1=1)
BEGIN
SELECT @ProyectoAux = MIN(Proyecto)
FROM #Proy
WHERE Proyecto > @ProyectoAuxAnt
IF @ProyectoAux IS NULL BREAK
SELECT @ProyectoAuxAnt = @ProyectoAux
TRUNCATE TABLE #Temp
INSERT INTO #Temp(
Orden, ID, Clase, SubClase, Rama, RamaDesc, RamaEsAcreedora, Cuenta, Descripcion, EsAcreedora, Saldo, SaldoAlEne, SaldoAlFeb, SaldoAlMar, SaldoAlAbr, SaldoAlMay, SaldoAlJun, SaldoAlJul, SaldoAlAgo, SaldoAlSep, SaldoAlOct, SaldoAlNov, SaldoAlDic, Ingresos, IngresosAlEne, IngresosAlFeb, IngresosAlMar, IngresosAlAbr, IngresosAlMay, IngresosAlJun, IngresosAlJul, IngresosAlAgo, IngresosAlSep, IngresosAlOct, IngresosAlNov, IngresosAlDic, Porcentaje, PorcentajeAlEne, PorcentajeAlFeb, PorcentajeAlMar, PorcentajeAlAbr, PorcentajeAlMay, PorcentajeAlJun, PorcentajeAlJul, PorcentajeAlAgo, PorcentajeAlSep, PorcentajeAlOct, PorcentajeAlNov, PorcentajeAlDic)
EXEC spVerContResultadosAnualRSProy @Empresa, @Ejercicio, @CentroCostos, @Moneda, NULL, @UEN, @ProyectoAux, @CentroCostos2, @CentroCostos3
IF EXISTS(SELECT * FROM #Temp)
INSERT INTO #Consolidado(
Proyecto,    Orden, Clase, SubClase, Rama, RamaDesc, RamaEsAcreedora, Cuenta, Descripcion, EsAcreedora, Saldo, SaldoAlEne, SaldoAlFeb, SaldoAlMar, SaldoAlAbr, SaldoAlMay, SaldoAlJun, SaldoAlJul, SaldoAlAgo, SaldoAlSep, SaldoAlOct, SaldoAlNov, SaldoAlDic, Ingresos, IngresosAlEne, IngresosAlFeb, IngresosAlMar, IngresosAlAbr, IngresosAlMay, IngresosAlJun, IngresosAlJul, IngresosAlAgo, IngresosAlSep, IngresosAlOct, IngresosAlNov, IngresosAlDic, Porcentaje, PorcentajeAlEne, PorcentajeAlFeb, PorcentajeAlMar, PorcentajeAlAbr, PorcentajeAlMay, PorcentajeAlJun, PorcentajeAlJul, PorcentajeAlAgo, PorcentajeAlSep, PorcentajeAlOct, PorcentajeAlNov, PorcentajeAlDic)
SELECT @ProyectoAux, Orden, Clase, SubClase, Rama, RamaDesc, RamaEsAcreedora, Cuenta, Descripcion, EsAcreedora, Saldo, SaldoAlEne, SaldoAlFeb, SaldoAlMar, SaldoAlAbr, SaldoAlMay, SaldoAlJun, SaldoAlJul, SaldoAlAgo, SaldoAlSep, SaldoAlOct, SaldoAlNov, SaldoAlDic, Ingresos, IngresosAlEne, IngresosAlFeb, IngresosAlMar, IngresosAlAbr, IngresosAlMay, IngresosAlJun, IngresosAlJul, IngresosAlAgo, IngresosAlSep, IngresosAlOct, IngresosAlNov, IngresosAlDic, Porcentaje, PorcentajeAlEne, PorcentajeAlFeb, PorcentajeAlMar, PorcentajeAlAbr, PorcentajeAlMay, PorcentajeAlJun, PorcentajeAlJul, PorcentajeAlAgo, PorcentajeAlSep, PorcentajeAlOct, PorcentajeAlNov, PorcentajeAlDic
FROM #Temp
END
INSERT INTO #Consolidado(
Proyecto, Orden, Clase, SubClase, Rama, RamaDesc, RamaEsAcreedora, Cuenta, Descripcion, EsAcreedora, Saldo, SaldoAlEne, SaldoAlFeb, SaldoAlMar, SaldoAlAbr, SaldoAlMay, SaldoAlJun, SaldoAlJul, SaldoAlAgo, SaldoAlSep, SaldoAlOct, SaldoAlNov, SaldoAlDic)
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
Proyecto, Orden, Clase, SubClase, Rama, RamaDesc, RamaEsAcreedora, Cuenta, Descripcion, EsAcreedora, Saldo, SaldoAlEne, SaldoAlFeb, SaldoAlMar, SaldoAlAbr, SaldoAlMay, SaldoAlJun, SaldoAlJul, SaldoAlAgo, SaldoAlSep, SaldoAlOct, SaldoAlNov, SaldoAlDic)
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
UPDATE #Consolidado SET Proyecto='' WHERE Proyecto='Sin Proyecto' 
SELECT RID, Orden,
Proyecto, Clase, SubClase, Rama, RamaDesc, RamaEsAcreedora, Cuenta, Descripcion, EsAcreedora,
ISNULL(Saldo,0) Saldo, ISNULL(SaldoAlEne,0) SaldoAlEne, ISNULL(SaldoAlFeb,0) SaldoAlFeb, ISNULL(SaldoAlMar,0) SaldoAlMar,
ISNULL(SaldoAlAbr,0) SaldoAlAbr, ISNULL(SaldoAlMay,0) SaldoAlMay,	ISNULL(SaldoAlJun,0) SaldoAlJun,
ISNULL(SaldoAlJul,0) SaldoAlJul, ISNULL(SaldoAlAgo,0) SaldoAlAgo,	ISNULL(SaldoAlSep,0) SaldoAlSep,
ISNULL(SaldoAlOct,0) SaldoAlOct, ISNULL(SaldoAlNov,0) SaldoAlNov,  ISNULL(SaldoAlDic,0) SaldoAlDic,
ISNULL(Ingresos,0) Ingresos, ISNULL(IngresosAlEne,0) IngresosAlEne, ISNULL(IngresosAlFeb,0) IngresosAlFeb,
ISNULL(IngresosAlMar,0) IngresosAlMar, ISNULL(IngresosAlAbr,0) IngresosAlAbr, ISNULL(IngresosAlMay,0) IngresosAlMay,
ISNULL(IngresosAlJun,0) IngresosAlJun, ISNULL(IngresosAlJul,0) IngresosAlJul, ISNULL(IngresosAlAgo,0) IngresosAlAgo,
ISNULL(IngresosAlSep,0) IngresosAlSep, ISNULL(IngresosAlOct,0) IngresosAlOct, ISNULL(IngresosAlNov,0) IngresosAlNov,  ISNULL(Porcentaje,0),
ISNULL(PorcentajeAlEne,0),ISNULL(PorcentajeAlFeb,0) PorcentajeAlFeb, ISNULL(PorcentajeAlMar,0) PorcentajeAlMar, ISNULL(PorcentajeAlAbr,0) PorcentajeAlAbr,
ISNULL(PorcentajeAlMay,0) PorcentajeAlMay, ISNULL(PorcentajeAlJun,0) PorcentajeAlJun, ISNULL(PorcentajeAlJul,0) PorcentajeAlJul,
ISNULL(PorcentajeAlAgo,0) PorcentajeAlAgo, ISNULL(PorcentajeAlSep,0) PorcentajeAlSep, ISNULL(PorcentajeAlOct,0) PorcentajeAlOct,
ISNULL(PorcentajeAlNov,0) PorcentajeAlNov, ISNULL(PorcentajeAlDic,0) PorcentajeAlDic
FROM #Consolidado
ORDER BY Orden, Clase, Rama, Cuenta, Proyecto
RETURN
END

