SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spRSContResultadosPresup
@Empresa		char(5),
@Ejercicio		int,
@ConMovs		char(20)    = 'NO',
@CentroCostos	varchar(Max) = NULL,
@Sucursal		int	    = NULL,
@OrdenCC		char(20)    = 'NO',
@Moneda			char(10)    = NULL,
@CCGrupo		varchar(50) = NULL,
@UEN			int	    = NULL,
@Proyecto		varchar(50) = NULL,
@CentroCostos2		varchar(50) = NULL,
@CentroCostos3		varchar(50) = NULL

AS
BEGIN
DECLARE
@CentroCostosAux		varchar(20),
@CentroCostosAuxAnt	varchar(20),
@Rama                 varchar(20),
@Cuenta               varchar(20),
@SubCuenta            varchar(20),
@Periodo              int,
@Saldo                money
CREATE TABLE #Temp(
Orden		int		NULL,
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
Orden		int		NULL,
RID				int			IDENTITY(1,1) NOT NULL,
CentroCostos       varchar(20) COLLATE Database_Default NULL,
Clase				varchar(50)	COLLATE Database_Default NULL,
SubClase			varchar(20)	COLLATE Database_Default NULL,
Rama				varchar(20)	COLLATE Database_Default NULL,
RamaDesc			varchar(100)COLLATE Database_Default NULL,
RamaEsAcreedora	bit NULL DEFAULT 0,
Cuenta				varchar(20)	COLLATE Database_Default NULL,
Descripcion		varchar(100)COLLATE Database_Default NULL,
EsAcreedora		bit			NULL DEFAULT 0,
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
PresupuestoAlEne	money		NULL,
PresupuestoAlFeb	money		NULL,
PresupuestoAlMar	money		NULL,
PresupuestoAlAbr	money		NULL,
PresupuestoAlMay	money		NULL,
PresupuestoAlJun	money		NULL,
PresupuestoAlJul	money		NULL,
PresupuestoAlAgo	money		NULL,
PresupuestoAlSep	money		NULL,
PresupuestoAlOct	money		NULL,
PresupuestoAlNov	money		NULL,
PresupuestoAlDic	money		NULL
)
SELECT * INTO #ConsolidadopPpto FROM #Consolidado
SELECT * INTO #Consolidado_S_UAFIRDA FROM #Consolidado 
SELECT * INTO #Consolidado_T_UAFIRDA FROM #Consolidado 
SELECT * INTO #Consolidado_U_UAFIRDA FROM #Consolidado 
SELECT * INTO #Consolidado_U2_UAFIRDA FROM #Consolidado 
SELECT * INTO #Consolidado_U3_UAFIRDA FROM #Consolidado 
CREATE TABLE #Presupuesto(
Rama      varchar(20) COLLATE Database_Default NULL,
Cuenta     varchar(20) COLLATE Database_Default NULL,
SubCuenta	 varchar(20) COLLATE Database_Default NULL,
Periodo    int,
Saldo		 money       NULL
)
IF @Moneda='' SELECT @Moneda = NULL
IF @UEN='' SELECT @UEN = NULL
IF @Proyecto='' SELECT @Proyecto = NULL
IF @CentroCostos2='' SELECT @CentroCostos2 = NULL
IF @CentroCostos3='' SELECT @CentroCostos3 = NULL
IF @CentroCostos='(Sin Desglose)' AND LEN(@CentroCostos)<=14 SELECT @CentroCostos = NULL 
IF @CentroCostos<>'(Sin Desglose)' AND LEN(@CentroCostos)>14 SELECT @CentroCostos = '(Todos)' 
SELECT @Ejercicio = CONVERT(int, @Ejercicio),
@UEN = CONVERT(int, @UEN)
IF ISNULL(@CentroCostos,'') = ''
INSERT INTO #Presupuesto(
Rama, Cuenta, SubCuenta, Periodo,    Saldo)
SELECT Ctx.Cuenta, y.Cuenta, NULL, x.Periodo, SaldoP = Sum(ISNULL(y.Debe, 0.0)) 
FROM Cont x
JOIN ContD y ON x.ID = y.ID
JOIN Cta Ctz ON Ctz.Cuenta = y.Cuenta
JOIN Cta Cty ON Cty.Cuenta = Ctz.Rama
JOIN Cta Ctx ON Ctx.Cuenta = Cty.Rama
WHERE x.Mov = 'Presupuesto'
AND x.Estatus = 'CONCLUIDO'
AND x.Empresa = @Empresa
AND x.Moneda = 'Pesos'
AND x.Ejercicio = @Ejercicio
AND ISNULL(x.Sucursal, 0)    = ISNULL(ISNULL(@Sucursal, x.Sucursal), 0)
GROUP BY Ctx.Cuenta, y.Cuenta, x.Periodo
ELSE
INSERT INTO #Presupuesto(
Rama, Cuenta, SubCuenta, Periodo,    Saldo)
SELECT Ctx.Cuenta, y.Cuenta, y.SubCuenta, x.Periodo, SaldoP = Sum(ISNULL(y.Debe, 0.0)) 
FROM Cont x
JOIN ContD y ON x.ID = y.ID
JOIN Cta Ctz ON Ctz.Cuenta = y.Cuenta
JOIN Cta Cty ON Cty.Cuenta = Ctz.Rama
JOIN Cta Ctx ON Ctx.Cuenta = Cty.Rama
WHERE x.Mov = 'Presupuesto'
AND x.Estatus = 'CONCLUIDO'
AND x.Empresa = @Empresa
AND x.Moneda = 'Pesos'
AND x.Ejercicio = @Ejercicio
AND ISNULL(x.Sucursal, 0)    = ISNULL(ISNULL(@Sucursal, x.Sucursal), 0)
GROUP BY Ctx.Cuenta, y.Cuenta, y.SubCuenta, x.Periodo
CREATE TABLE #CentroCostos(CentroCostos varchar(20) COLLATE Database_Default )
IF ISNULL(@CentroCostos,'') = ''
BEGIN
INSERT INTO #Temp(
Orden, ID, Clase, SubClase, Rama, RamaDesc, RamaEsAcreedora, Cuenta, Descripcion, EsAcreedora, Saldo, SaldoAlEne, SaldoAlFeb, SaldoAlMar, SaldoAlAbr, SaldoAlMay, SaldoAlJun, SaldoAlJul, SaldoAlAgo, SaldoAlSep, SaldoAlOct, SaldoAlNov, SaldoAlDic, Ingresos, IngresosAlEne, IngresosAlFeb, IngresosAlMar, IngresosAlAbr, IngresosAlMay, IngresosAlJun, IngresosAlJul, IngresosAlAgo, IngresosAlSep, IngresosAlOct, IngresosAlNov, IngresosAlDic, Porcentaje, PorcentajeAlEne, PorcentajeAlFeb, PorcentajeAlMar, PorcentajeAlAbr, PorcentajeAlMay, PorcentajeAlJun, PorcentajeAlJul, PorcentajeAlAgo, PorcentajeAlSep, PorcentajeAlOct, PorcentajeAlNov, PorcentajeAlDic)
EXEC spVerContResultadosEmpresaSucursalAnualRS @Empresa, @Ejercicio, @Sucursal, '', @Moneda, @UEN, @Proyecto, @CentroCostos2, @CentroCostos3
IF EXISTS(SELECT * FROM #Temp)
INSERT INTO #Consolidado(
Orden, CentroCostos, Clase, SubClase, Rama, RamaDesc, RamaEsAcreedora, Cuenta, Descripcion, EsAcreedora, Saldo, SaldoAlEne, SaldoAlFeb, SaldoAlMar, SaldoAlAbr, SaldoAlMay, SaldoAlJun, SaldoAlJul, SaldoAlAgo, SaldoAlSep, SaldoAlOct, SaldoAlNov, SaldoAlDic)
SELECT Orden, '',       Clase, SubClase, Rama, RamaDesc, RamaEsAcreedora, Cuenta, Descripcion, EsAcreedora, ISNULL(Saldo,0), ISNULL(SaldoAlEne,0), ISNULL(SaldoAlFeb,0), ISNULL(SaldoAlMar,0), ISNULL(SaldoAlAbr,0), ISNULL(SaldoAlMay,0), ISNULL(SaldoAlJun,0), ISNULL(SaldoAlJul,0), ISNULL(SaldoAlAgo,0), ISNULL(SaldoAlSep,0), ISNULL(SaldoAlOct,0), ISNULL(SaldoAlNov,0), ISNULL(SaldoAlDic,0)
FROM #Temp
SELECT @CentroCostos = NULL
END
IF ISNULL(@CentroCostos,'') LIKE '%(Todos)%'
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
EXEC spVerContResultadosEmpresaSucursalAnualRS @Empresa, @Ejercicio, @Sucursal, @CentroCostosAux, @Moneda, @UEN,  @Proyecto, @CentroCostos2, @CentroCostos3
IF EXISTS(SELECT * FROM #Temp)
INSERT INTO #Consolidado(
Orden, CentroCostos,    Clase, SubClase, Rama, RamaDesc, RamaEsAcreedora, Cuenta, Descripcion, EsAcreedora, Saldo, SaldoAlEne, SaldoAlFeb, SaldoAlMar, SaldoAlAbr, SaldoAlMay, SaldoAlJun, SaldoAlJul, SaldoAlAgo, SaldoAlSep, SaldoAlOct, SaldoAlNov, SaldoAlDic)
SELECT Orden, @CentroCostosAux, Clase, SubClase, Rama, RamaDesc, RamaEsAcreedora, Cuenta, Descripcion, EsAcreedora, ISNULL(Saldo,0), ISNULL(SaldoAlEne,0), ISNULL(SaldoAlFeb,0), ISNULL(SaldoAlMar,0), ISNULL(SaldoAlAbr,0), ISNULL(SaldoAlMay,0), ISNULL(SaldoAlJun,0), ISNULL(SaldoAlJul,0), ISNULL(SaldoAlAgo,0), ISNULL(SaldoAlSep,0), ISNULL(SaldoAlOct,0), ISNULL(SaldoAlNov,0), ISNULL(SaldoAlDic,0)
FROM #Temp
END
DECLARE #crPresupuesto CURSOR FOR
SELECT Rama, /*Cuenta,*/ SubCuenta, Periodo, SUM(Saldo) as Saldo
FROM #Presupuesto
GROUP BY Rama, /*Cuenta,*/ SubCuenta, Periodo
OPEN #crPresupuesto
FETCH NEXT FROM #crPresupuesto INTO @Rama, /*@Cuenta,*/ @SubCuenta, @Periodo, @Saldo
WHILE @@FETCH_STATUS = 0
BEGIN
IF @Periodo=1 AND @SubCuenta IS NOT NULL
UPDATE #Consolidado SET PresupuestoAlEne=@Saldo WHERE Cuenta=@Rama AND CentroCostos=ISNULL(@SubCuenta,CentroCostos)
IF @Periodo=1 AND @SubCuenta IS NULL
INSERT INTO #ConsolidadopPpto(Orden, CentroCostos, Clase, SubClase, Rama, RamaDesc, Cuenta, Descripcion, PresupuestoAlEne)
SELECT TOP 1 Orden, CASE WHEN CentroCostos='' THEN '' ELSE 'GENERAL PPTO' END, Clase, SubClase, Rama, RamaDesc, Cuenta, Descripcion, ISNULL(@Saldo,0)
FROM #Consolidado
WHERE Cuenta=@Rama
IF @Periodo=2 AND @SubCuenta IS NOT NULL
UPDATE #Consolidado SET PresupuestoAlFeb=@Saldo WHERE Cuenta=@Rama AND CentroCostos=ISNULL(@SubCuenta,CentroCostos)
IF @Periodo=2 AND @SubCuenta IS NULL
INSERT INTO #ConsolidadopPpto(Orden, CentroCostos, Clase, SubClase, Rama, RamaDesc, Cuenta, Descripcion, PresupuestoAlFeb)
SELECT TOP 1 Orden, CASE WHEN CentroCostos='' THEN '' ELSE 'GENERAL PPTO' END, Clase, SubClase, Rama, RamaDesc, Cuenta, Descripcion, ISNULL(@Saldo,0)
FROM #Consolidado
WHERE Cuenta=@Rama
IF @Periodo=3 AND @SubCuenta IS NOT NULL
UPDATE #Consolidado SET PresupuestoAlMar=@Saldo WHERE Cuenta=@Rama AND CentroCostos=ISNULL(@SubCuenta,CentroCostos)
IF @Periodo=3 AND @SubCuenta IS NULL
INSERT INTO #ConsolidadopPpto(Orden, CentroCostos, Clase, SubClase, Rama, RamaDesc, Cuenta, Descripcion, PresupuestoAlMar)
SELECT TOP 1 Orden, CASE WHEN CentroCostos='' THEN '' ELSE 'GENERAL PPTO' END, Clase, SubClase, Rama, RamaDesc, Cuenta, Descripcion, ISNULL(@Saldo,0)
FROM #Consolidado
WHERE Cuenta=@Rama
IF @Periodo=4 AND @SubCuenta IS NOT NULL
UPDATE #Consolidado SET PresupuestoAlAbr=@Saldo WHERE Cuenta=@Rama AND CentroCostos=ISNULL(@SubCuenta,CentroCostos)
IF @Periodo=4 AND @SubCuenta IS NULL
INSERT INTO #ConsolidadopPpto(Orden, CentroCostos, Clase, SubClase, Rama, RamaDesc, Cuenta, Descripcion, PresupuestoAlAbr)
SELECT TOP 1 Orden, CASE WHEN CentroCostos='' THEN '' ELSE 'GENERAL PPTO' END, Clase, SubClase, Rama, RamaDesc, Cuenta, Descripcion, ISNULL(@Saldo,0)
FROM #Consolidado
WHERE Cuenta=@Rama
IF @Periodo=5 AND @SubCuenta IS NOT NULL
UPDATE #Consolidado SET PresupuestoAlMay=@Saldo WHERE Cuenta=@Rama AND CentroCostos=ISNULL(@SubCuenta,CentroCostos)
IF @Periodo=5 AND @SubCuenta IS NULL
INSERT INTO #ConsolidadopPpto(Orden, CentroCostos, Clase, SubClase, Rama, RamaDesc, Cuenta, Descripcion, PresupuestoAlMay)
SELECT TOP 1 Orden, CASE WHEN CentroCostos='' THEN '' ELSE 'GENERAL PPTO' END, Clase, SubClase, Rama, RamaDesc, Cuenta, Descripcion, ISNULL(@Saldo,0)
FROM #Consolidado
WHERE Cuenta=@Rama
IF @Periodo=6 AND @SubCuenta IS NOT NULL
UPDATE #Consolidado SET PresupuestoAlJun=@Saldo WHERE Cuenta=@Rama AND CentroCostos=ISNULL(@SubCuenta,CentroCostos)
ELSE IF @Periodo=6 AND @SubCuenta IS NULL
BEGIN
INSERT INTO #ConsolidadopPpto(Orden, CentroCostos, Clase, SubClase, Rama, RamaDesc, Cuenta, Descripcion, PresupuestoAlJun)
SELECT TOP 1 Orden, CASE WHEN CentroCostos='' THEN '' ELSE 'GENERAL PPTO' END, Clase, SubClase, Rama, RamaDesc, Cuenta, Descripcion, ISNULL(@Saldo,0)
FROM #Consolidado
WHERE Cuenta=@Rama
END
IF @Periodo=7 AND @SubCuenta IS NOT NULL
UPDATE #Consolidado SET PresupuestoAlJul=@Saldo WHERE Cuenta=@Rama AND CentroCostos=ISNULL(@SubCuenta,CentroCostos)
IF @Periodo=7 AND @SubCuenta IS NULL
INSERT INTO #ConsolidadopPpto(Orden, CentroCostos, Clase, SubClase, Rama, RamaDesc, Cuenta, Descripcion, PresupuestoAlJul)
SELECT TOP 1 Orden, CASE WHEN CentroCostos='' THEN '' ELSE 'GENERAL PPTO' END, Clase, SubClase, Rama, RamaDesc, Cuenta, Descripcion, ISNULL(@Saldo,0)
FROM #Consolidado
WHERE Cuenta=@Rama
IF @Periodo=8 AND @SubCuenta IS NOT NULL
UPDATE #Consolidado SET PresupuestoAlAgo=@Saldo WHERE Cuenta=@Rama AND CentroCostos=ISNULL(@SubCuenta,CentroCostos)
IF @Periodo=8 AND @SubCuenta IS NULL
INSERT INTO #ConsolidadopPpto(Orden, CentroCostos, Clase, SubClase, Rama, RamaDesc, Cuenta, Descripcion, PresupuestoAlAgo)
SELECT TOP 1 Orden, CASE WHEN CentroCostos='' THEN '' ELSE 'GENERAL PPTO' END, Clase, SubClase, Rama, RamaDesc, Cuenta, Descripcion, ISNULL(@Saldo,0)
FROM #Consolidado
WHERE Cuenta=@Rama
IF @Periodo=9 AND @SubCuenta IS NOT NULL
UPDATE #Consolidado SET PresupuestoAlSep=@Saldo WHERE Cuenta=@Rama AND CentroCostos=ISNULL(@SubCuenta,CentroCostos)
IF @Periodo=9 AND @SubCuenta IS NULL
INSERT INTO #ConsolidadopPpto(Orden, CentroCostos, Clase, SubClase, Rama, RamaDesc, Cuenta, Descripcion, PresupuestoAlSep)
SELECT TOP 1 Orden, CASE WHEN CentroCostos='' THEN '' ELSE 'GENERAL PPTO' END, Clase, SubClase, Rama, RamaDesc, Cuenta, Descripcion, ISNULL(@Saldo,0)
FROM #Consolidado
WHERE Cuenta=@Rama
IF @Periodo=10 AND @SubCuenta IS NOT NULL
UPDATE #Consolidado SET PresupuestoAlOct=@Saldo WHERE Cuenta=@Rama AND CentroCostos=ISNULL(@SubCuenta,CentroCostos)
IF @Periodo=10 AND @SubCuenta IS NULL
INSERT INTO #ConsolidadopPpto(Orden, CentroCostos, Clase, SubClase, Rama, RamaDesc, Cuenta, Descripcion, PresupuestoAlOct)
SELECT TOP 1 Orden, CASE WHEN CentroCostos='' THEN '' ELSE 'GENERAL PPTO' END, Clase, SubClase, Rama, RamaDesc, Cuenta, Descripcion, ISNULL(@Saldo,0)
FROM #Consolidado
WHERE Cuenta=@Rama
IF @Periodo=11 AND @SubCuenta IS NOT NULL
UPDATE #Consolidado SET PresupuestoAlNov=@Saldo WHERE Cuenta=@Rama AND CentroCostos=ISNULL(@SubCuenta,CentroCostos)
IF @Periodo=11 AND @SubCuenta IS NULL
INSERT INTO #ConsolidadopPpto(Orden, CentroCostos, Clase, SubClase, Rama, RamaDesc, Cuenta, Descripcion, PresupuestoAlNov)
SELECT TOP 1 Orden, CASE WHEN CentroCostos='' THEN '' ELSE 'GENERAL PPTO' END, Clase, SubClase, Rama, RamaDesc, Cuenta, Descripcion, ISNULL(@Saldo,0)
FROM #Consolidado
WHERE Cuenta=@Rama
IF @Periodo=12 AND @SubCuenta IS NOT NULL
UPDATE #Consolidado SET PresupuestoAlDic=@Saldo WHERE Cuenta=@Rama AND CentroCostos=ISNULL(@SubCuenta,CentroCostos)
IF @Periodo=12 AND @SubCuenta IS NULL
INSERT INTO #ConsolidadopPpto(Orden, CentroCostos, Clase, SubClase, Rama, RamaDesc, Cuenta, Descripcion, PresupuestoAlDic)
SELECT TOP 1 Orden, CASE WHEN CentroCostos='' THEN '' ELSE 'GENERAL PPTO' END, Clase, SubClase, Rama, RamaDesc, Cuenta, Descripcion, ISNULL(@Saldo,0)
FROM #Consolidado
WHERE Cuenta=@Rama
FETCH NEXT FROM #crPresupuesto INTO @Rama, /*@Cuenta,*/ @SubCuenta, @Periodo, @Saldo
END
CLOSE #crPresupuesto
DEALLOCATE #crPresupuesto
INSERT INTO #Consolidado(Orden, CentroCostos, Clase, SubClase, Rama, RamaDesc, Cuenta, Descripcion, PresupuestoAlEne, PresupuestoAlFeb, PresupuestoAlMar, PresupuestoAlAbr, PresupuestoAlMay, PresupuestoAlJun, PresupuestoAlJul, PresupuestoAlAgo, PresupuestoAlSep, PresupuestoAlOct, PresupuestoAlNov, PresupuestoAlDic)
SELECT Orden, CentroCostos, Clase, SubClase, Rama, RamaDesc, Cuenta, Descripcion, SUM(ISNULL(PresupuestoAlEne,0)), SUM(ISNULL(PresupuestoAlFeb,0)), SUM(ISNULL(PresupuestoAlMar,0)), SUM(ISNULL(PresupuestoAlAbr,0)), SUM(ISNULL(PresupuestoAlMay,0)), SUM(ISNULL(PresupuestoAlJun,0)), SUM(ISNULL(PresupuestoAlJul,0)), SUM(ISNULL(PresupuestoAlAgo,0)), SUM(ISNULL(PresupuestoAlSep,0)), SUM(ISNULL(PresupuestoAlOct,0)), SUM(ISNULL(PresupuestoAlNov,0)), SUM(ISNULL(PresupuestoAlDic,0))
FROM #ConsolidadopPpto
GROUP BY Orden, CentroCostos, Clase, SubClase, Rama, RamaDesc, Cuenta, Descripcion
INSERT INTO #Consolidado_S_UAFIRDA
(CentroCostos, Orden, Clase, SubClase, Rama, RamaDesc, RamaEsAcreedora, Cuenta, Descripcion, EsAcreedora, Saldo, SaldoAlEne, SaldoAlFeb, SaldoAlMar, SaldoAlAbr, SaldoAlMay, SaldoAlJun, SaldoAlJul, SaldoAlAgo, SaldoAlSep, SaldoAlOct, SaldoAlNov, SaldoAlDic, PresupuestoAlEne, PresupuestoAlFeb, PresupuestoAlMar, PresupuestoAlAbr, PresupuestoAlMay, PresupuestoAlJun, PresupuestoAlJul, PresupuestoAlAgo, PresupuestoAlSep, PresupuestoAlOct, PresupuestoAlNov, PresupuestoAlDic)
SELECT '', 4, 'Utilidad Bruta - Ventas', 'UAFIRDA', Rama, 'UAFIRDA', 0, '', '', 0,
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
SUM(CASE WHEN RamaEsAcreedora=1 THEN SaldoAlDic*-1 ELSE SaldoAlDic END) SaldoAlDic,
SUM(CASE WHEN RamaEsAcreedora=1 THEN ISNULL(PresupuestoAlEne,0)*-1 ELSE ISNULL(PresupuestoAlEne,0) END) PresupuestoAlEne,
SUM(CASE WHEN RamaEsAcreedora=1 THEN ISNULL(PresupuestoAlFeb,0)*-1 ELSE ISNULL(PresupuestoAlFeb,0) END) PresupuestoAlFeb,
SUM(CASE WHEN RamaEsAcreedora=1 THEN ISNULL(PresupuestoAlMar,0)*-1 ELSE ISNULL(PresupuestoAlMar,0) END) PresupuestoAlMar,
SUM(CASE WHEN RamaEsAcreedora=1 THEN ISNULL(PresupuestoAlAbr,0)*-1 ELSE ISNULL(PresupuestoAlAbr,0) END) PresupuestoAlAbr,
SUM(CASE WHEN RamaEsAcreedora=1 THEN ISNULL(PresupuestoAlMay,0)*-1 ELSE ISNULL(PresupuestoAlMay,0) END) PresupuestoAlMay,
SUM(CASE WHEN RamaEsAcreedora=1 THEN ISNULL(PresupuestoAlJun,0)*-1 ELSE ISNULL(PresupuestoAlJun,0) END) PresupuestoAlJun,
SUM(CASE WHEN RamaEsAcreedora=1 THEN ISNULL(PresupuestoAlJul,0)*-1 ELSE ISNULL(PresupuestoAlJul,0) END) PresupuestoAlJul,
SUM(CASE WHEN RamaEsAcreedora=1 THEN ISNULL(PresupuestoAlAgo,0)*-1 ELSE ISNULL(PresupuestoAlAgo,0) END) PresupuestoAlAgo,
SUM(CASE WHEN RamaEsAcreedora=1 THEN ISNULL(PresupuestoAlSep,0)*-1 ELSE ISNULL(PresupuestoAlSep,0) END) PresupuestoAlSep,
SUM(CASE WHEN RamaEsAcreedora=1 THEN ISNULL(PresupuestoAlOct,0)*-1 ELSE ISNULL(PresupuestoAlOct,0) END) PresupuestoAlOct,
SUM(CASE WHEN RamaEsAcreedora=1 THEN ISNULL(PresupuestoAlNov,0)*-1 ELSE ISNULL(PresupuestoAlNov,0) END) PresupuestoAlNov,
SUM(CASE WHEN RamaEsAcreedora=1 THEN ISNULL(PresupuestoAlDic,0)*-1 ELSE ISNULL(PresupuestoAlDic,0) END) PresupuestoAlDic
FROM #Consolidado
WHERE Rama IN ('S')
GROUP BY Rama 
INSERT INTO #Consolidado_T_UAFIRDA
(CentroCostos, Orden, Clase, SubClase, Rama, RamaDesc, RamaEsAcreedora, Cuenta, Descripcion, EsAcreedora, Saldo, SaldoAlEne, SaldoAlFeb, SaldoAlMar, SaldoAlAbr, SaldoAlMay, SaldoAlJun, SaldoAlJul, SaldoAlAgo, SaldoAlSep, SaldoAlOct, SaldoAlNov, SaldoAlDic, PresupuestoAlEne, PresupuestoAlFeb, PresupuestoAlMar, PresupuestoAlAbr, PresupuestoAlMay, PresupuestoAlJun, PresupuestoAlJul, PresupuestoAlAgo, PresupuestoAlSep, PresupuestoAlOct, PresupuestoAlNov, PresupuestoAlDic)
SELECT '', 4, 'Utilidad Bruta - Costo Ventas', 'UAFIRDA', Rama, 'UAFIRDA', 0, '', '', 0,
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
SUM(CASE WHEN RamaEsAcreedora=1 THEN SaldoAlDic*-1 ELSE SaldoAlDic END) SaldoAlDic,
SUM(CASE WHEN RamaEsAcreedora=1 THEN ISNULL(PresupuestoAlEne,0)*-1 ELSE ISNULL(PresupuestoAlEne,0) END) PresupuestoAlEne,
SUM(CASE WHEN RamaEsAcreedora=1 THEN ISNULL(PresupuestoAlFeb,0)*-1 ELSE ISNULL(PresupuestoAlFeb,0) END) PresupuestoAlFeb,
SUM(CASE WHEN RamaEsAcreedora=1 THEN ISNULL(PresupuestoAlMar,0)*-1 ELSE ISNULL(PresupuestoAlMar,0) END) PresupuestoAlMar,
SUM(CASE WHEN RamaEsAcreedora=1 THEN ISNULL(PresupuestoAlAbr,0)*-1 ELSE ISNULL(PresupuestoAlAbr,0) END) PresupuestoAlAbr,
SUM(CASE WHEN RamaEsAcreedora=1 THEN ISNULL(PresupuestoAlMay,0)*-1 ELSE ISNULL(PresupuestoAlMay,0) END) PresupuestoAlMay,
SUM(CASE WHEN RamaEsAcreedora=1 THEN ISNULL(PresupuestoAlJun,0)*-1 ELSE ISNULL(PresupuestoAlJun,0) END) PresupuestoAlJun,
SUM(CASE WHEN RamaEsAcreedora=1 THEN ISNULL(PresupuestoAlJul,0)*-1 ELSE ISNULL(PresupuestoAlJul,0) END) PresupuestoAlJul,
SUM(CASE WHEN RamaEsAcreedora=1 THEN ISNULL(PresupuestoAlAgo,0)*-1 ELSE ISNULL(PresupuestoAlAgo,0) END) PresupuestoAlAgo,
SUM(CASE WHEN RamaEsAcreedora=1 THEN ISNULL(PresupuestoAlSep,0)*-1 ELSE ISNULL(PresupuestoAlSep,0) END) PresupuestoAlSep,
SUM(CASE WHEN RamaEsAcreedora=1 THEN ISNULL(PresupuestoAlOct,0)*-1 ELSE ISNULL(PresupuestoAlOct,0) END) PresupuestoAlOct,
SUM(CASE WHEN RamaEsAcreedora=1 THEN ISNULL(PresupuestoAlNov,0)*-1 ELSE ISNULL(PresupuestoAlNov,0) END) PresupuestoAlNov,
SUM(CASE WHEN RamaEsAcreedora=1 THEN ISNULL(PresupuestoAlDic,0)*-1 ELSE ISNULL(PresupuestoAlDic,0) END) PresupuestoAlDic
FROM #Consolidado
WHERE Rama IN ('T')
GROUP BY Rama 
INSERT INTO #Consolidado_U_UAFIRDA
(CentroCostos, Orden, Clase, SubClase, Rama, RamaDesc, RamaEsAcreedora, Cuenta, Descripcion, EsAcreedora, Saldo, SaldoAlEne, SaldoAlFeb, SaldoAlMar, SaldoAlAbr, SaldoAlMay, SaldoAlJun, SaldoAlJul, SaldoAlAgo, SaldoAlSep, SaldoAlOct, SaldoAlNov, SaldoAlDic, PresupuestoAlEne, PresupuestoAlFeb, PresupuestoAlMar, PresupuestoAlAbr, PresupuestoAlMay, PresupuestoAlJun, PresupuestoAlJul, PresupuestoAlAgo, PresupuestoAlSep, PresupuestoAlOct, PresupuestoAlNov, PresupuestoAlDic)
SELECT '', 4, 'Gastos de Operación', 'UAFIRDA', Rama, 'UAFIRDA', 0, '', '', 0,
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
SUM(CASE WHEN RamaEsAcreedora=1 THEN SaldoAlDic*-1 ELSE SaldoAlDic END) SaldoAlDic,
SUM(CASE WHEN RamaEsAcreedora=1 THEN ISNULL(PresupuestoAlEne,0)*-1 ELSE ISNULL(PresupuestoAlEne,0) END) PresupuestoAlEne,
SUM(CASE WHEN RamaEsAcreedora=1 THEN ISNULL(PresupuestoAlFeb,0)*-1 ELSE ISNULL(PresupuestoAlFeb,0) END) PresupuestoAlFeb,
SUM(CASE WHEN RamaEsAcreedora=1 THEN ISNULL(PresupuestoAlMar,0)*-1 ELSE ISNULL(PresupuestoAlMar,0) END) PresupuestoAlMar,
SUM(CASE WHEN RamaEsAcreedora=1 THEN ISNULL(PresupuestoAlAbr,0)*-1 ELSE ISNULL(PresupuestoAlAbr,0) END) PresupuestoAlAbr,
SUM(CASE WHEN RamaEsAcreedora=1 THEN ISNULL(PresupuestoAlMay,0)*-1 ELSE ISNULL(PresupuestoAlMay,0) END) PresupuestoAlMay,
SUM(CASE WHEN RamaEsAcreedora=1 THEN ISNULL(PresupuestoAlJun,0)*-1 ELSE ISNULL(PresupuestoAlJun,0) END) PresupuestoAlJun,
SUM(CASE WHEN RamaEsAcreedora=1 THEN ISNULL(PresupuestoAlJul,0)*-1 ELSE ISNULL(PresupuestoAlJul,0) END) PresupuestoAlJul,
SUM(CASE WHEN RamaEsAcreedora=1 THEN ISNULL(PresupuestoAlAgo,0)*-1 ELSE ISNULL(PresupuestoAlAgo,0) END) PresupuestoAlAgo,
SUM(CASE WHEN RamaEsAcreedora=1 THEN ISNULL(PresupuestoAlSep,0)*-1 ELSE ISNULL(PresupuestoAlSep,0) END) PresupuestoAlSep,
SUM(CASE WHEN RamaEsAcreedora=1 THEN ISNULL(PresupuestoAlOct,0)*-1 ELSE ISNULL(PresupuestoAlOct,0) END) PresupuestoAlOct,
SUM(CASE WHEN RamaEsAcreedora=1 THEN ISNULL(PresupuestoAlNov,0)*-1 ELSE ISNULL(PresupuestoAlNov,0) END) PresupuestoAlNov,
SUM(CASE WHEN RamaEsAcreedora=1 THEN ISNULL(PresupuestoAlDic,0)*-1 ELSE ISNULL(PresupuestoAlDic,0) END) PresupuestoAlDic
FROM #Consolidado
WHERE Rama='U'
GROUP BY Rama 
INSERT INTO #Consolidado_U2_UAFIRDA
(CentroCostos, Orden, Clase, SubClase, Rama, RamaDesc, RamaEsAcreedora, Cuenta, Descripcion, EsAcreedora, Saldo, SaldoAlEne, SaldoAlFeb, SaldoAlMar, SaldoAlAbr, SaldoAlMay, SaldoAlJun, SaldoAlJul, SaldoAlAgo, SaldoAlSep, SaldoAlOct, SaldoAlNov, SaldoAlDic, PresupuestoAlEne, PresupuestoAlFeb, PresupuestoAlMar, PresupuestoAlAbr, PresupuestoAlMay, PresupuestoAlJun, PresupuestoAlJul, PresupuestoAlAgo, PresupuestoAlSep, PresupuestoAlOct, PresupuestoAlNov, PresupuestoAlDic)
SELECT '', 4, 'Otros Gastos y Productos', 'UAFIRDA', Rama, 'UAFIRDA', 0, '', '', 0,
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
SUM(CASE WHEN RamaEsAcreedora=1 THEN SaldoAlDic*-1 ELSE SaldoAlDic END) SaldoAlDic,
SUM(CASE WHEN RamaEsAcreedora=1 THEN ISNULL(PresupuestoAlEne,0)*-1 ELSE ISNULL(PresupuestoAlEne,0) END) PresupuestoAlEne,
SUM(CASE WHEN RamaEsAcreedora=1 THEN ISNULL(PresupuestoAlFeb,0)*-1 ELSE ISNULL(PresupuestoAlFeb,0) END) PresupuestoAlFeb,
SUM(CASE WHEN RamaEsAcreedora=1 THEN ISNULL(PresupuestoAlMar,0)*-1 ELSE ISNULL(PresupuestoAlMar,0) END) PresupuestoAlMar,
SUM(CASE WHEN RamaEsAcreedora=1 THEN ISNULL(PresupuestoAlAbr,0)*-1 ELSE ISNULL(PresupuestoAlAbr,0) END) PresupuestoAlAbr,
SUM(CASE WHEN RamaEsAcreedora=1 THEN ISNULL(PresupuestoAlMay,0)*-1 ELSE ISNULL(PresupuestoAlMay,0) END) PresupuestoAlMay,
SUM(CASE WHEN RamaEsAcreedora=1 THEN ISNULL(PresupuestoAlJun,0)*-1 ELSE ISNULL(PresupuestoAlJun,0) END) PresupuestoAlJun,
SUM(CASE WHEN RamaEsAcreedora=1 THEN ISNULL(PresupuestoAlJul,0)*-1 ELSE ISNULL(PresupuestoAlJul,0) END) PresupuestoAlJul,
SUM(CASE WHEN RamaEsAcreedora=1 THEN ISNULL(PresupuestoAlAgo,0)*-1 ELSE ISNULL(PresupuestoAlAgo,0) END) PresupuestoAlAgo,
SUM(CASE WHEN RamaEsAcreedora=1 THEN ISNULL(PresupuestoAlSep,0)*-1 ELSE ISNULL(PresupuestoAlSep,0) END) PresupuestoAlSep,
SUM(CASE WHEN RamaEsAcreedora=1 THEN ISNULL(PresupuestoAlOct,0)*-1 ELSE ISNULL(PresupuestoAlOct,0) END) PresupuestoAlOct,
SUM(CASE WHEN RamaEsAcreedora=1 THEN ISNULL(PresupuestoAlNov,0)*-1 ELSE ISNULL(PresupuestoAlNov,0) END) PresupuestoAlNov,
SUM(CASE WHEN RamaEsAcreedora=1 THEN ISNULL(PresupuestoAlDic,0)*-1 ELSE ISNULL(PresupuestoAlDic,0) END) PresupuestoAlDic
FROM #Consolidado
WHERE Rama='U2'
GROUP BY Rama 
INSERT INTO #Consolidado_U3_UAFIRDA
(CentroCostos, Orden, Clase, SubClase, Rama, RamaDesc, RamaEsAcreedora, Cuenta, Descripcion, EsAcreedora, Saldo, SaldoAlEne, SaldoAlFeb, SaldoAlMar, SaldoAlAbr, SaldoAlMay, SaldoAlJun, SaldoAlJul, SaldoAlAgo, SaldoAlSep, SaldoAlOct, SaldoAlNov, SaldoAlDic, PresupuestoAlEne, PresupuestoAlFeb, PresupuestoAlMar, PresupuestoAlAbr, PresupuestoAlMay, PresupuestoAlJun, PresupuestoAlJul, PresupuestoAlAgo, PresupuestoAlSep, PresupuestoAlOct, PresupuestoAlNov, PresupuestoAlDic)
SELECT '', 4, 'Impuestos', 'UAFIRDA', Rama, 'UAFIRDA', 0, '', '', 0,
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
SUM(CASE WHEN RamaEsAcreedora=1 THEN SaldoAlDic*-1 ELSE SaldoAlDic END) SaldoAlDic,
SUM(CASE WHEN RamaEsAcreedora=1 THEN ISNULL(PresupuestoAlEne,0)*-1 ELSE ISNULL(PresupuestoAlEne,0) END) PresupuestoAlEne,
SUM(CASE WHEN RamaEsAcreedora=1 THEN ISNULL(PresupuestoAlFeb,0)*-1 ELSE ISNULL(PresupuestoAlFeb,0) END) PresupuestoAlFeb,
SUM(CASE WHEN RamaEsAcreedora=1 THEN ISNULL(PresupuestoAlMar,0)*-1 ELSE ISNULL(PresupuestoAlMar,0) END) PresupuestoAlMar,
SUM(CASE WHEN RamaEsAcreedora=1 THEN ISNULL(PresupuestoAlAbr,0)*-1 ELSE ISNULL(PresupuestoAlAbr,0) END) PresupuestoAlAbr,
SUM(CASE WHEN RamaEsAcreedora=1 THEN ISNULL(PresupuestoAlMay,0)*-1 ELSE ISNULL(PresupuestoAlMay,0) END) PresupuestoAlMay,
SUM(CASE WHEN RamaEsAcreedora=1 THEN ISNULL(PresupuestoAlJun,0)*-1 ELSE ISNULL(PresupuestoAlJun,0) END) PresupuestoAlJun,
SUM(CASE WHEN RamaEsAcreedora=1 THEN ISNULL(PresupuestoAlJul,0)*-1 ELSE ISNULL(PresupuestoAlJul,0) END) PresupuestoAlJul,
SUM(CASE WHEN RamaEsAcreedora=1 THEN ISNULL(PresupuestoAlAgo,0)*-1 ELSE ISNULL(PresupuestoAlAgo,0) END) PresupuestoAlAgo,
SUM(CASE WHEN RamaEsAcreedora=1 THEN ISNULL(PresupuestoAlSep,0)*-1 ELSE ISNULL(PresupuestoAlSep,0) END) PresupuestoAlSep,
SUM(CASE WHEN RamaEsAcreedora=1 THEN ISNULL(PresupuestoAlOct,0)*-1 ELSE ISNULL(PresupuestoAlOct,0) END) PresupuestoAlOct,
SUM(CASE WHEN RamaEsAcreedora=1 THEN ISNULL(PresupuestoAlNov,0)*-1 ELSE ISNULL(PresupuestoAlNov,0) END) PresupuestoAlNov,
SUM(CASE WHEN RamaEsAcreedora=1 THEN ISNULL(PresupuestoAlDic,0)*-1 ELSE ISNULL(PresupuestoAlDic,0) END) PresupuestoAlDic
FROM #Consolidado
WHERE Rama='U3'
GROUP BY Rama 
INSERT INTO #Consolidado(
CentroCostos, Orden, Clase, SubClase, Rama, RamaDesc, RamaEsAcreedora, Cuenta, Descripcion, EsAcreedora, Saldo, SaldoAlEne, SaldoAlFeb, SaldoAlMar, SaldoAlAbr, SaldoAlMay, SaldoAlJun, SaldoAlJul, SaldoAlAgo, SaldoAlSep, SaldoAlOct, SaldoAlNov, SaldoAlDic, PresupuestoAlEne, PresupuestoAlFeb, PresupuestoAlMar, PresupuestoAlAbr, PresupuestoAlMay, PresupuestoAlJun, PresupuestoAlJul, PresupuestoAlAgo, PresupuestoAlSep, PresupuestoAlOct, PresupuestoAlNov, PresupuestoAlDic)
SELECT '', 4, 'Utilidad Bruta - Gastos de Operación', 'UAFIRDA', 'STUU2', 'UAFIRDA', 0, '', '', 0,
((S.Saldo-T.Saldo)-U.Saldo)-u2.Saldo,
((S.SaldoAlEne-T.SaldoAlEne)-U.SaldoAlEne)-U2.SaldoAlEne,
((S.SaldoAlFeb-T.SaldoAlFeb)-U.SaldoAlFeb)-U2.SaldoAlFeb,
((S.SaldoAlMar-T.SaldoAlMar)-U.SaldoAlMar)-U2.SaldoAlMar,
((S.SaldoAlAbr-T.SaldoAlAbr)-U.SaldoAlAbr)-U2.SaldoAlAbr,
((S.SaldoAlMay-T.SaldoAlMay)-U.SaldoAlMay)-U2.SaldoAlMay,
((S.SaldoAlJun-T.SaldoAlJun)-U.SaldoAlJun)-U2.SaldoAlJun,
((S.SaldoAlJul-T.SaldoAlJul)-U.SaldoAlJul)-U2.SaldoAlJul,
((S.SaldoAlAgo-T.SaldoAlAgo)-U.SaldoAlAgo)-u2.SaldoAlAgo,
((S.SaldoAlSep-T.SaldoAlSep)-U.SaldoAlSep)-U2.SaldoAlSep,
((S.saldoAlOct-T.saldoAlOct)-U.saldoAlOct)-U2.saldoAlOct,
((S.SaldoAlNov-T.SaldoAlNov)-U.SaldoAlNov)-U2.SaldoAlNov,
((S.SaldoAlDic-T.SaldoAlDic)-U.SaldoAlDic)-U2.SaldoAlDic,
((S.PresupuestoAlEne-T.PresupuestoAlEne)-U.PresupuestoAlEne)-U2.PresupuestoAlEne,
((S.PresupuestoAlFeb-T.PresupuestoAlFeb)-U.PresupuestoAlFeb)-U2.PresupuestoAlFeb,
((S.PresupuestoAlMar-T.PresupuestoAlMar)-U.PresupuestoAlMar)-U2.PresupuestoAlMar,
((S.PresupuestoAlAbr-T.PresupuestoAlAbr)-U.PresupuestoAlAbr)-U2.PresupuestoAlAbr,
((S.PresupuestoAlMay-T.PresupuestoAlMay)-U.PresupuestoAlMay)-U2.PresupuestoAlMay,
((S.PresupuestoAlJun-T.PresupuestoAlJun)-U.PresupuestoAlJun)-U2.PresupuestoAlJun,
((S.PresupuestoAlJul-T.PresupuestoAlJul)-U.PresupuestoAlJul)-U2.PresupuestoAlJul,
((S.PresupuestoAlAgo-T.PresupuestoAlAgo)-U.PresupuestoAlAgo)-u2.PresupuestoAlAgo,
((S.PresupuestoAlSep-T.PresupuestoAlSep)-U.PresupuestoAlSep)-U2.PresupuestoAlSep,
((S.PresupuestoAlOct-T.PresupuestoAlOct)-U.PresupuestoAlOct)-U2.PresupuestoAlOct,
((S.PresupuestoAlNov-T.PresupuestoAlNov)-U.PresupuestoAlNov)-U2.PresupuestoAlNov,
((S.PresupuestoAlDic-T.PresupuestoAlDic)-U.PresupuestoAlDic)-U2.PresupuestoAlDic
FROM #Consolidado_S_UAFIRDA S, #Consolidado_T_UAFIRDA T, #Consolidado_U_UAFIRDA U, #Consolidado_U2_UAFIRDA U2
WHERE S.RamaDesc=T.RamaDesc AND
U.RamaDesc=T.RamaDesc AND
U2.RamaDesc=U.RamaDesc
INSERT INTO #Consolidado(
CentroCostos, Orden, Clase, SubClase, Rama, RamaDesc, RamaEsAcreedora, Cuenta, Descripcion, EsAcreedora, Saldo, SaldoAlEne, SaldoAlFeb, SaldoAlMar, SaldoAlAbr, SaldoAlMay, SaldoAlJun, SaldoAlJul, SaldoAlAgo, SaldoAlSep, SaldoAlOct, SaldoAlNov, SaldoAlDic, PresupuestoAlEne, PresupuestoAlFeb, PresupuestoAlMar, PresupuestoAlAbr, PresupuestoAlMay, PresupuestoAlJun, PresupuestoAlJul, PresupuestoAlAgo, PresupuestoAlSep, PresupuestoAlOct, PresupuestoAlNov, PresupuestoAlDic)
SELECT '', 6, 'Utilidad Neta', U3.SubClase, 'STUU2U3', 'Utilidad Neta', 0, '', '', 0,
(((S.Saldo-T.Saldo)-U.Saldo)-U2.Saldo)-ISNULL(U3.Saldo,0),
(((S.SaldoAlEne-T.SaldoAlEne)-U.SaldoAlEne)-U2.SaldoAlEne)-ISNULL(U3.SaldoAlEne,0),
(((S.SaldoAlFeb-T.SaldoAlFeb)-U.SaldoAlFeb)-U2.SaldoAlFeb)-ISNULL(U3.SaldoAlFeb,0),
(((S.SaldoAlMar-T.SaldoAlMar)-U.SaldoAlMar)-U2.SaldoAlMar)-ISNULL(U3.SaldoAlMar,0),
(((S.SaldoAlAbr-T.SaldoAlAbr)-U.SaldoAlAbr)-U2.SaldoAlAbr)-ISNULL(U3.SaldoAlAbr,0),
(((S.SaldoAlMay-T.SaldoAlMay)-U.SaldoAlMay)-U2.SaldoAlMay)-ISNULL(U3.SaldoAlMay,0),
(((S.SaldoAlJun-T.SaldoAlJun)-U.SaldoAlJun)-U2.SaldoAlJun)-ISNULL(U3.SaldoAlJun,0),
(((S.SaldoAlJul-T.SaldoAlJul)-U.SaldoAlJul)-U2.SaldoAlJul)-ISNULL(U3.SaldoAlJul,0),
(((S.SaldoAlAgo-T.SaldoAlAgo)-U.SaldoAlAgo)-U2.SaldoAlAgo)-ISNULL(U3.SaldoAlAgo,0),
(((S.SaldoAlSep-T.SaldoAlSep)-U.SaldoAlSep)-U2.SaldoAlSep)-ISNULL(U3.SaldoAlSep,0),
(((S.saldoAlOct-T.saldoAlOct)-U.saldoAlOct)-U2.saldoAlOct)-ISNULL(U3.saldoAlOct,0),
(((S.SaldoAlNov-T.SaldoAlNov)-U.SaldoAlNov)-U2.SaldoAlNov)-ISNULL(U3.SaldoAlNov,0),
(((S.SaldoAlDic-T.SaldoAlDic)-U.SaldoAlDic)-U2.SaldoAlDic)-ISNULL(U3.SaldoAlDic,0),
(((S.PresupuestoAlEne-T.PresupuestoAlEne)-U.PresupuestoAlEne)-U2.PresupuestoAlEne)-ISNULL(U3.PresupuestoAlEne,0),
(((S.PresupuestoAlFeb-T.PresupuestoAlFeb)-U.PresupuestoAlFeb)-U2.PresupuestoAlFeb)-ISNULL(U3.PresupuestoAlFeb,0),
(((S.PresupuestoAlMar-T.PresupuestoAlMar)-U.PresupuestoAlMar)-U2.PresupuestoAlMar)-ISNULL(U3.PresupuestoAlMar,0),
(((S.PresupuestoAlAbr-T.PresupuestoAlAbr)-U.PresupuestoAlAbr)-U2.PresupuestoAlAbr)-ISNULL(U3.PresupuestoAlAbr,0),
(((S.PresupuestoAlMay-T.PresupuestoAlMay)-U.PresupuestoAlMay)-U2.PresupuestoAlMay)-ISNULL(U3.PresupuestoAlMay,0),
(((S.PresupuestoAlJun-T.PresupuestoAlJun)-U.PresupuestoAlJun)-U2.PresupuestoAlJun)-ISNULL(U3.PresupuestoAlJun,0),
(((S.PresupuestoAlJul-T.PresupuestoAlJul)-U.PresupuestoAlJul)-U2.PresupuestoAlJul)-ISNULL(U3.PresupuestoAlJul,0),
(((S.PresupuestoAlAgo-T.PresupuestoAlAgo)-U.PresupuestoAlAgo)-U2.PresupuestoAlAgo)-ISNULL(U3.PresupuestoAlAgo,0),
(((S.PresupuestoAlSep-T.PresupuestoAlSep)-U.PresupuestoAlSep)-U2.PresupuestoAlSep)-ISNULL(U3.PresupuestoAlSep,0),
(((S.PresupuestoAlOct-T.PresupuestoAlOct)-U.PresupuestoAlOct)-U2.PresupuestoAlOct)-ISNULL(U3.PresupuestoAlOct,0),
(((S.PresupuestoAlNov-T.PresupuestoAlNov)-U.PresupuestoAlNov)-U2.PresupuestoAlNov)-ISNULL(U3.PresupuestoAlNov,0),
(((S.PresupuestoAlDic-T.PresupuestoAlDic)-U.PresupuestoAlDic)-U2.PresupuestoAlDic)-ISNULL(U3.PresupuestoAlDic,0)
FROM #Consolidado_S_UAFIRDA S, #Consolidado_T_UAFIRDA T,
#Consolidado_U_UAFIRDA U, #Consolidado_U2_UAFIRDA U2,
#Consolidado_U3_UAFIRDA U3
WHERE S.RamaDesc=T.RamaDesc AND
U.RamaDesc=T.RamaDesc AND
U2.RamaDesc=U.RamaDesc AND
U3.SubClase=u2.RamaDesc
UPDATE #Consolidado SET CentroCostos='Sin Centro Costos' WHERE CentroCostos='Sin CC' 
UPDATE #Consolidado SET CentroCostos='Sin Centro Costos' WHERE CentroCostos='GENERAL PPTO' 
SELECT * INTO #ConsolidadoSinCC FROM #Consolidado WHERE CentroCostos='Sin Centro Costos'
DELETE FROM #Consolidado WHERE CentroCostos='Sin Centro Costos'
INSERT INTO #Consolidado(Orden, CentroCostos, Clase, SubClase, Rama, RamaDesc, Cuenta, Descripcion, Saldo, SaldoAlEne, SaldoAlFeb, SaldoAlMar, SaldoAlAbr, SaldoAlMay, SaldoAlJun, SaldoAlJul, SaldoAlAgo, SaldoAlSep, SaldoAlOct, SaldoAlNov, SaldoAlDic, PresupuestoAlEne, PresupuestoAlFeb, PresupuestoAlMar, PresupuestoAlAbr, PresupuestoAlMay, PresupuestoAlJun, PresupuestoAlJul, PresupuestoAlAgo, PresupuestoAlSep, PresupuestoAlOct, PresupuestoAlNov, PresupuestoAlDic)
SELECT Orden, CentroCostos, Clase, SubClase, Rama, RamaDesc, Cuenta, Descripcion,
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
SUM(SaldoAlDic) SaldoAlDic,
SUM(ISNULL(PresupuestoAlEne,0)) PresupuestoAlEne,
SUM(ISNULL(PresupuestoAlFeb,0)) PresupuestoAlFeb,
SUM(ISNULL(PresupuestoAlMar,0)) PresupuestoAlMar,
SUM(ISNULL(PresupuestoAlAbr,0)) PresupuestoAlAbr,
SUM(ISNULL(PresupuestoAlMay,0)) PresupuestoAlMay,
SUM(ISNULL(PresupuestoAlJun,0)) PresupuestoAlJun,
SUM(ISNULL(PresupuestoAlJul,0)) PresupuestoAlJul,
SUM(ISNULL(PresupuestoAlAgo,0)) PresupuestoAlAgo,
SUM(ISNULL(PresupuestoAlSep,0)) PresupuestoAlSep,
SUM(ISNULL(PresupuestoAlOct,0)) PresupuestoAlOct,
SUM(ISNULL(PresupuestoAlNov,0)) PresupuestoAlNov,
SUM(ISNULL(PresupuestoAlDic,0)) PresupuestoAlDic
FROM #ConsolidadoSinCC
GROUP BY Orden, CentroCostos, Clase, SubClase, Rama, RamaDesc, Cuenta, Descripcion
ORDER BY Orden, Clase, Rama, CentroCostos, Cuenta
select Orden, RID, CentroCostos, Clase, SubClase, Rama, RamaDesc, RamaEsAcreedora, Cuenta, Descripcion, EsAcreedora,
ISNULL(Saldo,0) Saldo, ISNULL(SaldoAlEne,0) SaldoAlEne, ISNULL(SaldoAlFeb,0) SaldoAlFeb,
ISNULL(SaldoAlMar,0) SaldoAlMar, ISNULL(SaldoAlAbr,0) SaldoAlAbr, ISNULL(SaldoAlMay,0) SaldoAlMay,
ISNULL(SaldoAlJun,0) SaldoAlJun, ISNULL(SaldoAlJul,0) SaldoAlJul, ISNULL(SaldoAlAgo,0) SaldoAlAgo,
ISNULL(SaldoAlSep,0) SaldoAlSep, ISNULL(SaldoAlOct,0) SaldoAlOct, ISNULL(SaldoAlNov,0) SaldoAlNov,
ISNULL(SaldoAlDic,0) SaldoAlDic,
ISNULL(Ingresos,0) Ingresos,
ISNULL(PresupuestoAlEne,0) PresupuestoAlEne, ISNULL(PresupuestoAlFeb,0) PresupuestoAlFeb,
ISNULL(PresupuestoAlMar,0) PresupuestoAlMar, ISNULL(PresupuestoAlAbr,0) PresupuestoAlAbr, ISNULL(PresupuestoAlMay,0) PresupuestoAlMay,
ISNULL(PresupuestoAlJun,0) PresupuestoAlJun, ISNULL(PresupuestoAlJul,0) PresupuestoAlJul, ISNULL(PresupuestoAlAgo,0) PresupuestoAlAgo,
ISNULL(PresupuestoAlSep,0) PresupuestoAlSep, ISNULL(PresupuestoAlOct,0) PresupuestoAlOct, ISNULL(PresupuestoAlNov,0) PresupuestoAlNov,
ISNULL(PresupuestoAlDic,0) PresupuestoAlDic
FROM #Consolidado ORDER BY Orden, Clase, Rama, CentroCostos, Cuenta
RETURN
END

