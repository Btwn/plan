SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spRSVerContBalanzaAnualCC
@Empresa		varchar(5),
@SEjercicio		varchar(4),
@Tipo           varchar(15),
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
@CentroCostosAuxAnt	varchar(20),
@CentroCostosMin		varchar(20),
@CentroCostosMax	    varchar(20)
CREATE TABLE #Temp(
Rama				varchar(20)	COLLATE Database_Default NULL,
RamaDesc			varchar(100)COLLATE Database_Default NULL,
CentroCostos       varchar(20) COLLATE Database_Default NULL,
DescripcionCC      varchar(100)COLLATE Database_Default NULL,
Cuenta				varchar(20)	COLLATE Database_Default NULL,
Descripcion		varchar(100)COLLATE Database_Default NULL,
Tipo               varchar(15) COLLATE Database_Default NULL,
Inicio             money		NULL,
CargosEne          money		NULL,
AbonosEne          money		NULL,
CargosFeb			money		NULL,
AbonosFeb			money		NULL,
CargosMar			money		NULL,
AbonosMar			money		NULL,
CargosAbr			money		NULL,
AbonosAbr			money		NULL,
CargosMay			money		NULL,
AbonosMay			money		NULL,
CargosJun			money		NULL,
AbonosJun			money		NULL,
CargosJul			money		NULL,
AbonosJul			money		NULL,
CargosAgo			money		NULL,
AbonosAgo			money		NULL,
CargosSep			money		NULL,
AbonosSep			money		NULL,
CargosOct			money		NULL,
AbonosOct			money		NULL,
CargosNov			money		NULL,
AbonosNov			money		NULL,
CargosDic			money		NULL,
AbonosDic			money		NULL,
Final              money       NULL
)
IF @Moneda='' SELECT @Moneda = NULL
IF @SUEN='' SELECT @SUEN = NULL
IF @Proyecto='' SELECT @Proyecto = NULL
IF @CentroCostos2='' SELECT @CentroCostos2 = NULL
IF @CentroCostos3='' SELECT @CentroCostos3 = NULL
SELECT @CentroCostosMin=Min(CentroCostos), @CentroCostosMax=Max(CentroCostos) FROM CentroCostos
SELECT @Ejercicio = CONVERT(int, @SEjercicio),
@UEN = CONVERT(int, @SUEN)
CREATE TABLE #CentroCostos(CentroCostos varchar(20) COLLATE Database_Default )
IF @CentroCostos='(Sin Desglose)' AND LEN(@CentroCostos)<=14 SELECT @CentroCostos = NULL 
IF @CentroCostos<>'(Sin Desglose)' AND LEN(@CentroCostos)>14 SELECT @CentroCostos = '(Todos)' 
IF ISNULL(@CentroCostos,'') = ''
BEGIN
EXEC spVerContBalanzaAnualRSCC @Empresa, @@SPID, @Ejercicio, @Tipo, NULL, NULL, '', @Moneda, NULL, @UEN, @Proyecto, @CentroCostos2, @CentroCostos3
INSERT INTO #Temp 
SELECT '', '', 'Global', 'Acumulado del Ejercicio' , Cta.Cuenta, Cta.Descripcion, Cta.Tipo, ISNULL(Inicio,0), ISNULL(CargosEne,0), ISNULL(AbonosEne,0), ISNULL(CargosFeb,0), ISNULL(AbonosFeb,0), ISNULL(CargosMar,0), ISNULL(AbonosMar,0), ISNULL(CargosAbr,0), ISNULL(AbonosAbr,0), ISNULL(CargosMay,0), ISNULL(AbonosMay,0), ISNULL(CargosJun,0), ISNULL(AbonosJun,0), ISNULL(CargosJul,0), ISNULL(AbonosJul,0), ISNULL(CargosAgo,0), ISNULL(AbonosAgo,0), ISNULL(CargosSep,0), ISNULL(AbonosSep,0), ISNULL(CargosOct,0), ISNULL(AbonosOct,0), ISNULL(CargosNov,0), ISNULL(AbonosNov,0), ISNULL(CargosDic,0), ISNULL(AbonosDic,0), NULL
FROM VerContBalanzaAnual vcb
LEFT OUTER JOIN Cta ON Cta.Cuenta=vcb.Cuenta
WHERE Estacion=@@SPID
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
EXEC spVerContBalanzaAnualRSCC @Empresa, @@SPID, @Ejercicio, @Tipo, NULL, NULL,  @CentroCostosAux, @Moneda, NULL, @UEN, @Proyecto, @CentroCostos2, @CentroCostos3
INSERT INTO #Temp 
SELECT '', '', @CentroCostosAux, Cc.Descripcion, Cta.Cuenta, Cta.Descripcion, Cta.Tipo, ISNULL(Inicio,0), ISNULL(CargosEne,0), ISNULL(AbonosEne,0), ISNULL(CargosFeb,0), ISNULL(AbonosFeb,0), ISNULL(CargosMar,0), ISNULL(AbonosMar,0), ISNULL(CargosAbr,0), ISNULL(AbonosAbr,0), ISNULL(CargosMay,0), ISNULL(AbonosMay,0), ISNULL(CargosJun,0), ISNULL(AbonosJun,0), ISNULL(CargosJul,0), ISNULL(AbonosJul,0), ISNULL(CargosAgo,0), ISNULL(AbonosAgo,0), ISNULL(CargosSep,0), ISNULL(AbonosSep,0), ISNULL(CargosOct,0), ISNULL(AbonosOct,0), ISNULL(CargosNov,0), ISNULL(AbonosNov,0), ISNULL(CargosDic,0), ISNULL(AbonosDic,0), NULL
FROM VerContBalanzaAnual vcb
LEFT OUTER JOIN Cta ON Cta.Cuenta=vcb.Cuenta
LEFT OUTER JOIN CentroCostos Cc ON Cc.CentroCostos=@CentroCostosAux
WHERE Estacion=@@SPID
END
UPDATE #Temp
SET Final=ISNULL(Inicio+(CargosEne+CargosFeb+CargosMar+CargosAbr+CargosMay+CargosJun+CargosJul+CargosAgo+CargosSep+CargosOct+CargosNov+CargosDic)-(AbonosEne+AbonosFeb+AbonosMar+AbonosAbr+AbonosMay+AbonosJun+AbonosJul+AbonosAgo+AbonosSep+AbonosOct+AbonosNov+AbonosDic),0)
SELECT * FROM #Temp ORDER BY Cuenta, CentroCostos
RETURN
END

