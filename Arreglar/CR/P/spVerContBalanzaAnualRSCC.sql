SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spVerContBalanzaAnualRSCC
@Empresa		varchar(5),
@Estacion		int,
@Ejercicio		int,
@Tipo		varchar(20) = 'MAYOR',
@CuentaD		varchar(20) = NULL,
@CuentaA		varchar(20) = NULL,
@CentroCostos       varchar(50) = NULL,
@Moneda		varchar(10) = NULL,
@Controladora	varchar(5)  = NULL,
@UEN		int	    = NULL,
@Proyecto		varchar(50) = NULL,
@CentroCostos2	varchar(50) = NULL,
@CentroCostos3	varchar(50) = NULL

AS BEGIN
DECLARE
@Cuenta		varchar(20),
@Periodo		int,
@Cargos		float,
@Abonos		float,
@CargosEne		float,
@AbonosEne		float,
@CargosFeb		float,
@AbonosFeb		float,
@CargosMar		float,
@AbonosMar		float,
@CargosAbr		float,
@AbonosAbr		float,
@CargosMay		float,
@AbonosMay		float,
@CargosJun		float,
@AbonosJun		float,
@CargosJul		float,
@AbonosJul		float,
@CargosAgo		float,
@AbonosAgo		float,
@CargosSep		float,
@AbonosSep		float,
@CargosOct		float,
@AbonosOct		float,
@CargosNov		float,
@AbonosNov		float,
@CargosDic		float,
@AbonosDic		float,
@Rama   		varchar(5),
@CuentaRangoD	varchar(20),
@CuentaRangoA	varchar(20),
@Tipos  		varchar(100),
@Inicio 		money
SELECT @Rama = 'CONT', 
@Tipo = NULLIF(RTRIM(UPPER(@Tipo)), ''),
@Moneda = NULLIF(NULLIF(RTRIM(@Moneda), ''), '0')
IF @Moneda IS NULL SELECT @Moneda = ContMoneda FROM EmpresaCfg WHERE Empresa = @Empresa
SELECT @CuentaRangoD = NULLIF(RTRIM(@CuentaD), '0'), @CuentaRangoA = NULLIF(RTRIM(@CuentaA), '0')
IF @CuentaRangoD IS NULL SELECT @CuentaRangoD = MIN(Cuenta) FROM Cta
IF @CuentaRangoA IS NULL SELECT @CuentaRangoA = MAX(Cuenta) FROM Cta
IF UPPER(@Empresa) 	  IN ('0', 'NULL', '(TODOS)','', '(ALL)') SELECT @Empresa = NULL
IF UPPER(@Controladora) 	  IN ('0', 'NULL', '(TODOS)','', '(ALL)') SELECT @Controladora = NULL
EXEC spContEmpresaGrupo @Empresa OUTPUT, @Controladora OUTPUT
IF UPPER(@CentroCostos) IN ('0', 'NULL', '(TODOS)', '(ALL)') SELECT @CentroCostos = NULL
IF @UEN = 0 SELECT @UEN = NULL
IF UPPER(@Proyecto)      IN ('0', 'NULL', '(TODOS)','', '(ALL)') SELECT @Proyecto = NULL
IF UPPER(@CentroCostos2) IN ('0', 'NULL', '(TODOS)','', '(ALL)') SELECT @CentroCostos2 = NULL
IF UPPER(@CentroCostos3) IN ('0', 'NULL', '(TODOS)','', '(ALL)') SELECT @CentroCostos3 = NULL
IF @CentroCostos='Sin CC' SELECT @CentroCostos=''
DELETE VerContBalanzaAnual WHERE Estacion = @Estacion
IF @CentroCostos = NULL
BEGIN
DECLARE ContBalanzaAnual CURSOR FOR
SELECT c.Cuenta, c.Tipo, a.Periodo, a.Cargos, a.Abonos
FROM Acum a JOIN Empresa e ON e.Empresa = a.Empresa AND e.Empresa = ISNULL(@Empresa, e.Empresa) AND ISNULL(e.Controladora,'') = ISNULL(@Controladora, ISNULL(e.Controladora,''))
LEFT OUTER JOIN Cta c ON c.Cuenta = a.Cuenta
WHERE a.Rama = @Rama
AND a.Ejercicio = @Ejercicio
AND a.Periodo BETWEEN 0 AND 12
AND UPPER(c.Tipo) = @Tipo
AND c.Cuenta BETWEEN @CuentaRangoD AND @CuentaRangoA
AND a.Moneda = @Moneda
END
ELSE
DECLARE ContBalanzaAnual CURSOR FOR
SELECT c.Cuenta, c.Tipo, a.Periodo, a.Cargos, a.Abonos
FROM Acum a JOIN Empresa e ON e.Empresa = a.Empresa AND e.Empresa = ISNULL(@Empresa, e.Empresa) AND ISNULL(e.Controladora,'') = ISNULL(@Controladora, ISNULL(e.Controladora,''))
LEFT OUTER JOIN Cta c ON c.Cuenta = a.Cuenta
WHERE a.Rama = @Rama
AND a.Ejercicio = @Ejercicio
AND a.Periodo BETWEEN 0 AND 12
AND UPPER(c.Tipo) = @Tipo
AND c.Cuenta BETWEEN @CuentaRangoD AND @CuentaRangoA
AND a.SubCuenta = @CentroCostos
AND a.Moneda = @Moneda
OPEN ContBalanzaAnual
FETCH NEXT FROM ContBalanzaAnual INTO @Cuenta, @Tipo, @Periodo, @Cargos, @Abonos
WHILE @@FETCH_STATUS <> -1 AND @@Error = 0
BEGIN
IF @@FETCH_STATUS <> -2
BEGIN
SELECT @Inicio=Null,
@CargosEne = Null, @AbonosEne = Null,
@CargosFeb = Null, @AbonosFeb = Null,
@CargosMar = Null, @AbonosMar = Null,
@CargosAbr = Null, @AbonosAbr = Null,
@CargosMay = Null, @AbonosMay = Null,
@CargosJun = Null, @AbonosJun = Null,
@CargosJul = Null, @AbonosJul = Null,
@CargosAgo = Null, @AbonosAgo = Null,
@CargosSep = Null, @AbonosSep = Null,
@CargosOct = Null, @AbonosOct = Null,
@CargosNov = Null, @AbonosNov = Null,
@CargosDic = Null, @AbonosDic = Null
IF @Periodo = 0 	SELECT @Inicio = ( @Cargos - @Abonos )
IF @Periodo = 1 	SELECT @CargosEne = @Cargos, @AbonosEne = @Abonos
IF @Periodo = 2 	SELECT @CargosFeb = @Cargos, @AbonosFeb = @Abonos
IF @Periodo = 3	SELECT @CargosMar = @Cargos, @AbonosMar = @Abonos
IF @Periodo = 4 	SELECT @CargosAbr = @Cargos, @AbonosAbr = @Abonos
IF @Periodo = 5 	SELECT @CargosMay = @Cargos, @AbonosMay = @Abonos
IF @Periodo = 6 	SELECT @CargosJun = @Cargos, @AbonosJun = @Abonos
IF @Periodo = 7 	SELECT @CargosJul = @Cargos, @AbonosJul = @Abonos
IF @Periodo = 8 	SELECT @CargosAgo = @Cargos, @AbonosAgo = @Abonos
IF @Periodo = 9 	SELECT @CargosSep = @Cargos, @AbonosSep = @Abonos
IF @Periodo = 10  SELECT @CargosOct = @Cargos, @AbonosOct = @Abonos
IF @Periodo = 11  SELECT @CargosNov = @Cargos, @AbonosNov = @Abonos
IF @Periodo = 12  SELECT @CargosDic = @Cargos, @AbonosDic = @Abonos
UPDATE VerContBalanzaAnual
SET Inicio    = ISNULL(Inicio,0.0)    + ISNULL(@Inicio,0.0),
CargosEne = ISNULL(CargosEne,0.0) + ISNULL(@CargosEne,0.0),
AbonosEne = ISNULL(AbonosEne,0.0) + ISNULL(@AbonosEne,0.0),
CargosFeb = ISNULL(CargosFeb,0.0) + ISNULL(@CargosFeb,0.0),
AbonosFeb = ISNULL(AbonosFeb,0.0) + ISNULL(@AbonosFeb,0.0),
CargosMar = ISNULL(CargosMar,0.0) + ISNULL(@CargosMar,0.0),
AbonosMar = ISNULL(AbonosMar,0.0) + ISNULL(@AbonosMar,0.0),
CargosAbr = ISNULL(CargosAbr,0.0) + ISNULL(@CargosAbr,0.0),
AbonosAbr = ISNULL(AbonosAbr,0.0) + ISNULL(@AbonosAbr,0.0),
CargosMay = ISNULL(CargosMay,0.0) + ISNULL(@CargosMay,0.0),
AbonosMay = ISNULL(AbonosMay,0.0) + ISNULL(@AbonosMay,0.0),
CargosJun = ISNULL(CargosJun,0.0) + ISNULL(@CargosJun,0.0),
AbonosJun = ISNULL(AbonosJun,0.0) + ISNULL(@AbonosJun,0.0),
CargosJul = ISNULL(CargosJul,0.0) + ISNULL(@CargosJul,0.0),
AbonosJul = ISNULL(AbonosJul,0.0) + ISNULL(@AbonosJul,0.0),
CargosAgo = ISNULL(CargosAgo,0.0) + ISNULL(@CargosAgo,0.0),
AbonosAgo = ISNULL(AbonosAgo,0.0) + ISNULL(@AbonosAgo,0.0),
CargosSep = ISNULL(CargosSep,0.0) + ISNULL(@CargosSep,0.0),
AbonosSep = ISNULL(AbonosSep,0.0) + ISNULL(@AbonosSep,0.0),
CargosOct = ISNULL(CargosOct,0.0) + ISNULL(@CargosOct,0.0),
AbonosOct = ISNULL(AbonosOct,0.0) + ISNULL(@AbonosOct,0.0),
CargosNov = ISNULL(CargosNov,0.0) + ISNULL(@CargosNov,0.0),
AbonosNov = ISNULL(AbonosNov,0.0) + ISNULL(@AbonosNov,0.0),
CargosDic = ISNULL(CargosDic,0.0) + ISNULL(@CargosDic,0.0),
AbonosDic = ISNULL(AbonosDic,0.0) + ISNULL(@AbonosDic,0.0)
WHERE Estacion = @Estacion AND Cuenta = @Cuenta
IF @@ROWCOUNT = 0
INSERT VerContBalanzaAnual (Estacion, Cuenta, Tipo, Inicio, CargosEne, AbonosEne, CargosFeb, AbonosFeb, CargosMar, AbonosMar, CargosAbr, AbonosAbr, CargosMay, AbonosMay, CargosJun, AbonosJun, CargosJul, AbonosJul, CargosAgo, AbonosAgo, CargosSep, AbonosSep, CargosOct, AbonosOct, CargosNov, AbonosNov, CargosDic, AbonosDic)
VALUES (@Estacion,@Cuenta,@Tipo,@Inicio,@CargosEne,@AbonosEne,@CargosFeb,@AbonosFeb,@CargosMar,@AbonosMar,@CargosAbr,@AbonosAbr,@CargosMay,@AbonosMay,@CargosJun,@AbonosJun,@CargosJul,@AbonosJul,@CargosAgo,@AbonosAgo,@CargosSep,@AbonosSep,@CargosOct,@AbonosOct,@CargosNov,@AbonosNov,@CargosDic,@AbonosDic)
END
FETCH NEXT FROM ContBalanzaAnual INTO @Cuenta, @Tipo, @Periodo, @Cargos, @Abonos
END
CLOSE ContBalanzaAnual
DEALLOCATE ContBalanzaAnual
RETURN
END

