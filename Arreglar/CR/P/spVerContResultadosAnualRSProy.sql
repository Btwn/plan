SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spVerContResultadosAnualRSProy
@Empresa		varchar(5),
@Ejercicio		int,
@CentroCostos	varchar(20) = NULL,
@Moneda			varchar(10) = NULL,
@Controladora	varchar(5)  = NULL,
@UEN			int		= NULL,
@Proyecto		varchar(50)	= NULL,
@CentroCostos2	varchar(50)	= NULL,
@CentroCostos3	varchar(50)	= NULL

AS BEGIN
DECLARE
@ID			int,
@CtaResultados	varchar(20),
@CtaIngresos	varchar(20),
@CtaCostoDirecto	varchar(20),
@Saldo               money,
@SaldoAlEne         money,
@SaldoAlFeb         money,
@SaldoAlMar         money,
@SaldoAlAbr         money,
@SaldoAlMay         money,
@SaldoAlJun         money,
@SaldoAlJul         money,
@SaldoAlAgo         money,
@SaldoAlSep         money,
@SaldoAlOct         money,
@SaldoAlNov         money,
@SaldoAlDic         money,
@Ingresos		money,
@IngresosAlEne 	money,
@IngresosAlFeb 	money,
@IngresosAlMar 	money,
@IngresosAlAbr 	money,
@IngresosAlMay 	money,
@IngresosAlJun 	money,
@IngresosAlJul 	money,
@IngresosAlAgo 	money,
@IngresosAlSep 	money,
@IngresosAlOct 	money,
@IngresosAlNov 	money,
@IngresosAlDic 	money,
@PorcentajeAlEne    money,
@PorcentajeAlFeb    money,
@PorcentajeAlMar    money,
@PorcentajeAlAbr    money,
@PorcentajeAlMay    money,
@PorcentajeAlJun    money,
@PorcentajeAlJul    money,
@PorcentajeAlAgo    money,
@PorcentajeAlSep    money,
@PorcentajeAlOct    money,
@PorcentajeAlNov    money,
@PorcentajeAlDic    money,
@CtaGastosOperacion varchar(20),
@CtaOtrosGastosProductos  varchar(20)
SELECT @Moneda = NULLIF(NULLIF(RTRIM(@Moneda), ''), '0')
IF @Moneda IS NULL SELECT @Moneda = ContMoneda FROM EmpresaCfg WHERE Empresa = @Empresa
CREATE TABLE #ResultadoAnual (
Orden		int		NOT NULL,
ID			int		IDENTITY(1,1) NOT NULL,
Clase		varchar(50)	COLLATE Database_Default NULL,
SubClase		varchar(20)	COLLATE Database_Default NULL,
Rama		varchar(20)	COLLATE Database_Default NULL,
RamaDesc		varchar(100)	COLLATE Database_Default NULL,
RamaEsAcreedora	bit		NOT NULL DEFAULT 0,
Cuenta		varchar(20)	COLLATE Database_Default NULL,
Descripcion	varchar(100)	COLLATE Database_Default NULL,
EsAcreedora	bit		NOT NULL DEFAULT 0,
Saldo		money		NULL,
SaldoAlEne		money		NULL,
SaldoAlFeb		money		NULL,
SaldoAlMar		money		NULL,
SaldoAlAbr		money		NULL,
SaldoAlMay		money		NULL,
SaldoAlJun		money		NULL,
SaldoAlJul		money		NULL,
SaldoAlAgo		money		NULL,
SaldoAlSep		money		NULL,
SaldoAlOct 	money		NULL,
SaldoAlNov		money		NULL,
SaldoAlDic		money		NULL,
Ingresos		money		NULL,
IngresosAlEne	money		NULL,
IngresosAlFeb	money		NULL,
IngresosAlMar	money		NULL,
IngresosAlAbr	money		NULL,
IngresosAlMay	money		NULL,
IngresosAlJun	money		NULL,
IngresosAlJul	money		NULL,
IngresosAlAgo	money		NULL,
IngresosAlSep	money		NULL,
IngresosAlOct	money		NULL,
IngresosAlNov	money		NULL,
IngresosAlDic	money		NULL,
Porcentaje		float		NULL,
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
CONSTRAINT priTempResultado PRIMARY KEY CLUSTERED (ID)
)
SELECT /*@ConMovs = UPPER(@ConMovs),*/ @CentroCostos = NULLIF(RTRIM(@CentroCostos), '')
IF UPPER(@CentroCostos) IN ('0', 'NULL', '(TODOS)', '(ALL)') SELECT @CentroCostos = NULL
IF @UEN = 0 SELECT @UEN = NULL
IF UPPER(@Proyecto)      IN ('0', 'NULL', '(TODOS)','', '(ALL)') SELECT @Proyecto = NULL
IF UPPER(@CentroCostos2) IN ('0', 'NULL', '(TODOS)','', '(ALL)') SELECT @CentroCostos2 = NULL
IF UPPER(@CentroCostos3) IN ('0', 'NULL', '(TODOS)','', '(ALL)') SELECT @CentroCostos3 = NULL
SELECT DISTINCT
@CtaResultados   = CtaResultados,
@CtaIngresos	   = CtaIngresos,
@CtaCostoDirecto = CtaCostoDirecto,
@CtaGastosOperacion = CtaGastosOperacion,
@CtaOtrosGastosProductos = CtaOtrosGastosProductos
FROM EmpresaCfg
WHERE Empresa = @Empresa
INSERT #ResultadoAnual
SELECT 1, "Utilidad Bruta",
"Ventas",
Rama.Cuenta,
Rama.Descripcion,
Rama.EsAcreedora,
Cta.Cuenta,
Cta.Descripcion,
Cta.EsAcreedora,
NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,
NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,
NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,
NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL
FROM Cta, Cta Rama
WHERE Cta.Rama   = Rama.Cuenta
AND UPPER(Cta.Tipo) = 'MAYOR'
AND (Cta.Rama = @CtaIngresos OR Rama.Rama = @CtaIngresos)
INSERT #ResultadoAnual
SELECT 2, "Utilidad Bruta",
"Costos",
Rama.Cuenta,
Rama.Descripcion,
Rama.EsAcreedora,
Cta.Cuenta,
Cta.Descripcion,
Cta.EsAcreedora,
NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,
NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,
NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,
NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL
FROM Cta, Cta Rama
WHERE Cta.Rama   = Rama.Cuenta
AND UPPER(Cta.Tipo) = 'MAYOR'
AND (Cta.Rama = @CtaCostoDirecto OR Rama.Rama = @CtaCostoDirecto)
INSERT #ResultadoAnual
SELECT 3, "Utilidad Antes de Impuestos",
"Gastos",
Rama.Cuenta,
Rama.Descripcion,
Rama.EsAcreedora,
Cta.Cuenta,
Cta.Descripcion,
Cta.EsAcreedora,
NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,
NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,
NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,
NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL
FROM Cta, Cta Rama
WHERE Cta.Rama   = Rama.Cuenta
AND UPPER(Cta.Tipo) = 'MAYOR'
AND (Cta.Rama = @CtaGastosOperacion OR Rama.Rama = @CtaGastosOperacion)
INSERT #ResultadoAnual
SELECT 3, "Utilidad Antes de Impuestos",
"Gastos",
Rama.Cuenta,
Rama.Descripcion,
Rama.EsAcreedora,
Cta.Cuenta,
Cta.Descripcion,
Cta.EsAcreedora,
NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,
NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,
NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,
NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL
FROM Cta, Cta Rama
WHERE Cta.Rama   = Rama.Cuenta
AND UPPER(Cta.Tipo) = 'MAYOR'
AND (Cta.Rama = @CtaOtrosGastosProductos OR Rama.Rama = @CtaOtrosGastosProductos)
INSERT #ResultadoAnual
SELECT 5, "Utilidad Después de Impuestos",
"Otros",
Rama.Cuenta,
Rama.Descripcion,
Rama.EsAcreedora,
Cta.Cuenta,
Cta.Descripcion,
Cta.EsAcreedora,
NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,
NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,
NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,
NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL
FROM Cta, Cta Rama
WHERE Cta.Rama   = Rama.Cuenta
AND UPPER(Cta.Tipo) = 'MAYOR'
AND (Cta.Rama = @CtaResultados OR Rama.Rama = @CtaResultados)
AND (Cta.Rama <> @CtaIngresos AND Rama.Rama <> @CtaIngresos)
AND (Cta.Rama <> @CtaCostoDirecto AND Rama.Rama <> @CtaCostoDirecto)
AND (Cta.Rama <> @CtaGastosOperacion AND Rama.Rama <> @CtaGastosOperacion)
AND (Cta.Rama <> @CtaOtrosGastosProductos AND Rama.Rama <> @CtaOtrosGastosProductos)
IF @CentroCostos IS NULL
SELECT @Ingresos = Sum(ISNULL(a.Cargos, 0.0)-ISNULL(a.Abonos, 0.0))
FROM Acum a
WHERE a.Rama = 'CONT'
AND a.Cuenta = @CtaIngresos
AND a.Ejercicio = @Ejercicio
AND a.Moneda = @Moneda
AND a.Periodo BETWEEN 1 AND 12
AND a.Empresa = @Empresa
AND (@CentroCostos2 IS NULL OR a.SubCuenta2 = @CentroCostos2)
AND (@CentroCostos3 IS NULL OR a.SubCuenta3 = @CentroCostos3)
AND ISNULL(a.UEN, 0) = ISNULL(ISNULL(@UEN, a.UEN), 0)
AND (CASE WHEN a.Proyecto = '' THEN 'Sin Proyecto' Else a.Proyecto END) = ISNULL(@Proyecto, a.Proyecto)
ELSE
SELECT @Ingresos = Sum(ISNULL(a.Cargos, 0.0)-ISNULL(a.Abonos, 0.0))
FROM Acum a
WHERE a.Rama = 'CONT'
AND a.Cuenta = @CtaIngresos
AND a.SubCuenta = @CentroCostos
AND a.Moneda = @Moneda
AND a.Ejercicio = @Ejercicio
AND a.Periodo BETWEEN 1 AND 12
AND a.Empresa = @Empresa
AND (@CentroCostos2 IS NULL OR a.SubCuenta2 = @CentroCostos2)
AND (@CentroCostos3 IS NULL OR a.SubCuenta3 = @CentroCostos3)
AND ISNULL(a.UEN, 0) = ISNULL(ISNULL(@UEN, a.UEN), 0)
AND (CASE WHEN a.Proyecto = '' THEN 'Sin Proyecto' Else a.Proyecto END) = ISNULL(@Proyecto, a.Proyecto)
IF @CentroCostos IS NULL
SELECT @IngresosAlEne = Sum(ISNULL(a.Cargos, 0.0)-ISNULL(a.Abonos, 0.0))
FROM Acum a
WHERE a.Rama = 'CONT'
AND a.Cuenta = @CtaIngresos
AND a.Moneda = @Moneda
AND a.Ejercicio = @Ejercicio
AND a.Empresa = @Empresa
AND a.Periodo = 1
AND (@CentroCostos2 IS NULL OR a.SubCuenta2 = @CentroCostos2)
AND (@CentroCostos3 IS NULL OR a.SubCuenta3 = @CentroCostos3)
AND ISNULL(a.UEN, 0) = ISNULL(ISNULL(@UEN, a.UEN), 0)
AND (CASE WHEN a.Proyecto = '' THEN 'Sin Proyecto' Else a.Proyecto END) = ISNULL(@Proyecto, a.Proyecto)
ELSE
SELECT @IngresosAlEne = Sum(ISNULL(a.Cargos, 0.0)-ISNULL(a.Abonos, 0.0))
FROM Acum a
WHERE a.Rama = 'CONT'
AND a.Cuenta = @CtaIngresos
AND a.Moneda = @Moneda
AND a.SubCuenta = @CentroCostos
AND a.Ejercicio = @Ejercicio
AND a.Empresa = @Empresa
AND a.Periodo = 1
AND (@CentroCostos2 IS NULL OR a.SubCuenta2 = @CentroCostos2)
AND (@CentroCostos3 IS NULL OR a.SubCuenta3 = @CentroCostos3)
AND ISNULL(a.UEN, 0) = ISNULL(ISNULL(@UEN, a.UEN), 0)
AND (CASE WHEN a.Proyecto = '' THEN 'Sin Proyecto' Else a.Proyecto END) = ISNULL(@Proyecto, a.Proyecto)
IF @CentroCostos IS NULL
SELECT @IngresosAlFeb = Sum(ISNULL(a.Cargos, 0.0)-ISNULL(a.Abonos, 0.0))
FROM Acum a
WHERE a.Rama = 'CONT'
AND a.Cuenta = @CtaIngresos
AND a.Moneda = @Moneda
AND a.Ejercicio = @Ejercicio
AND a.Empresa = @Empresa
AND a.Periodo = 2
AND (@CentroCostos2 IS NULL OR a.SubCuenta2 = @CentroCostos2)
AND (@CentroCostos3 IS NULL OR a.SubCuenta3 = @CentroCostos3)
AND ISNULL(a.UEN, 0) = ISNULL(ISNULL(@UEN, a.UEN), 0)
AND (CASE WHEN a.Proyecto = '' THEN 'Sin Proyecto' Else a.Proyecto END) = ISNULL(@Proyecto, a.Proyecto)
ELSE
SELECT @IngresosAlFeb = Sum(ISNULL(a.Cargos, 0.0)-ISNULL(a.Abonos, 0.0))
FROM Acum a
WHERE a.Rama = 'CONT'
AND a.Cuenta = @CtaIngresos
AND a.SubCuenta = @CentroCostos
AND a.Moneda = @Moneda
AND a.Ejercicio = @Ejercicio
AND a.Empresa = @Empresa
AND a.Periodo = 2
AND (@CentroCostos2 IS NULL OR a.SubCuenta2 = @CentroCostos2)
AND (@CentroCostos3 IS NULL OR a.SubCuenta3 = @CentroCostos3)
AND ISNULL(a.UEN, 0) = ISNULL(ISNULL(@UEN, a.UEN), 0)
AND (CASE WHEN a.Proyecto = '' THEN 'Sin Proyecto' Else a.Proyecto END) = ISNULL(@Proyecto, a.Proyecto)
IF @CentroCostos IS NULL
SELECT @IngresosAlMar = Sum(ISNULL(a.Cargos, 0.0)-ISNULL(a.Abonos, 0.0))
FROM Acum a
WHERE a.Rama = 'CONT'
AND a.Cuenta = @CtaIngresos
AND a.Moneda = @Moneda
AND a.Ejercicio = @Ejercicio
AND a.Empresa = @Empresa
AND a.Periodo = 3
AND (@CentroCostos2 IS NULL OR a.SubCuenta2 = @CentroCostos2)
AND (@CentroCostos3 IS NULL OR a.SubCuenta3 = @CentroCostos3)
AND ISNULL(a.UEN, 0) = ISNULL(ISNULL(@UEN, a.UEN), 0)
AND (CASE WHEN a.Proyecto = '' THEN 'Sin Proyecto' Else a.Proyecto END) = ISNULL(@Proyecto, a.Proyecto)
ELSE
SELECT @IngresosAlMar = Sum(ISNULL(a.Cargos, 0.0)-ISNULL(a.Abonos, 0.0))
FROM Acum a
WHERE a.Rama = 'CONT'
AND a.Cuenta = @CtaIngresos
AND a.SubCuenta = @CentroCostos
AND a.Moneda = @Moneda
AND a.Ejercicio = @Ejercicio
AND a.Empresa = @Empresa
AND a.Periodo = 3
AND (@CentroCostos2 IS NULL OR a.SubCuenta2 = @CentroCostos2)
AND (@CentroCostos3 IS NULL OR a.SubCuenta3 = @CentroCostos3)
AND ISNULL(a.UEN, 0) = ISNULL(ISNULL(@UEN, a.UEN), 0)
AND (CASE WHEN a.Proyecto = '' THEN 'Sin Proyecto' Else a.Proyecto END) = ISNULL(@Proyecto, a.Proyecto)
IF @CentroCostos IS NULL
SELECT @IngresosAlAbr = Sum(ISNULL(a.Cargos, 0.0)-ISNULL(a.Abonos, 0.0))
FROM Acum a
WHERE a.Rama = 'CONT'
AND a.Cuenta = @CtaIngresos
AND a.Moneda = @Moneda
AND a.Ejercicio = @Ejercicio
AND a.Empresa = @Empresa
AND a.Periodo = 4
AND (@CentroCostos2 IS NULL OR a.SubCuenta2 = @CentroCostos2)
AND (@CentroCostos3 IS NULL OR a.SubCuenta3 = @CentroCostos3)
AND ISNULL(a.UEN, 0) = ISNULL(ISNULL(@UEN, a.UEN), 0)
AND (CASE WHEN a.Proyecto = '' THEN 'Sin Proyecto' Else a.Proyecto END) = ISNULL(@Proyecto, a.Proyecto)
ELSE
SELECT @IngresosAlAbr = Sum(ISNULL(a.Cargos, 0.0)-ISNULL(a.Abonos, 0.0))
FROM Acum a
WHERE a.Rama = 'CONT'
AND a.Cuenta = @CtaIngresos
AND a.SubCuenta = @CentroCostos
AND a.Moneda = @Moneda
AND a.Ejercicio = @Ejercicio
AND a.Empresa = @Empresa
AND a.Periodo = 4
AND (@CentroCostos2 IS NULL OR a.SubCuenta2 = @CentroCostos2)
AND (@CentroCostos3 IS NULL OR a.SubCuenta3 = @CentroCostos3)
AND ISNULL(a.UEN, 0) = ISNULL(ISNULL(@UEN, a.UEN), 0)
AND (CASE WHEN a.Proyecto = '' THEN 'Sin Proyecto' Else a.Proyecto END) = ISNULL(@Proyecto, a.Proyecto)
IF @CentroCostos IS NULL
SELECT @IngresosAlMay = Sum(ISNULL(a.Cargos, 0.0)-ISNULL(a.Abonos, 0.0))
FROM Acum a
WHERE a.Rama = 'CONT'
AND a.Cuenta = @CtaIngresos
AND a.Moneda = @Moneda
AND a.Ejercicio = @Ejercicio
AND a.Empresa = @Empresa
AND a.Periodo = 5
AND (@CentroCostos2 IS NULL OR a.SubCuenta2 = @CentroCostos2)
AND (@CentroCostos3 IS NULL OR a.SubCuenta3 = @CentroCostos3)
AND ISNULL(a.UEN, 0) = ISNULL(ISNULL(@UEN, a.UEN), 0)
AND (CASE WHEN a.Proyecto = '' THEN 'Sin Proyecto' Else a.Proyecto END) = ISNULL(@Proyecto, a.Proyecto)
ELSE
SELECT @IngresosAlMay = Sum(ISNULL(a.Cargos, 0.0)-ISNULL(a.Abonos, 0.0))
FROM Acum a
WHERE a.Rama = 'CONT'
AND a.Cuenta = @CtaIngresos
AND a.SubCuenta = @CentroCostos
AND a.Moneda = @Moneda
AND a.Ejercicio = @Ejercicio
AND a.Empresa = @Empresa
AND a.Periodo = 5
AND (@CentroCostos2 IS NULL OR a.SubCuenta2 = @CentroCostos2)
AND (@CentroCostos3 IS NULL OR a.SubCuenta3 = @CentroCostos3)
AND ISNULL(a.UEN, 0) = ISNULL(ISNULL(@UEN, a.UEN), 0)
AND (CASE WHEN a.Proyecto = '' THEN 'Sin Proyecto' Else a.Proyecto END) = ISNULL(@Proyecto, a.Proyecto)
IF @CentroCostos IS NULL
SELECT @IngresosAlJun = Sum(ISNULL(a.Cargos, 0.0)-ISNULL(a.Abonos, 0.0))
FROM Acum a
WHERE a.Rama = 'CONT'
AND a.Cuenta = @CtaIngresos
AND a.Moneda = @Moneda
AND a.Ejercicio = @Ejercicio
AND a.Empresa = @Empresa
AND a.Periodo = 6
AND (@CentroCostos2 IS NULL OR a.SubCuenta2 = @CentroCostos2)
AND (@CentroCostos3 IS NULL OR a.SubCuenta3 = @CentroCostos3)
AND ISNULL(a.UEN, 0) = ISNULL(ISNULL(@UEN, a.UEN), 0)
AND (CASE WHEN a.Proyecto = '' THEN 'Sin Proyecto' Else a.Proyecto END) = ISNULL(@Proyecto, a.Proyecto)
ELSE
SELECT @IngresosAlJun = Sum(ISNULL(a.Cargos, 0.0)-ISNULL(a.Abonos, 0.0))
FROM Acum a
WHERE a.Rama = 'CONT'
AND a.Cuenta = @CtaIngresos
AND a.SubCuenta = @CentroCostos
AND a.Moneda = @Moneda
AND a.Ejercicio = @Ejercicio
AND a.Empresa = @Empresa
AND a.Periodo = 6
AND (@CentroCostos2 IS NULL OR a.SubCuenta2 = @CentroCostos2)
AND (@CentroCostos3 IS NULL OR a.SubCuenta3 = @CentroCostos3)
AND ISNULL(a.UEN, 0) = ISNULL(ISNULL(@UEN, a.UEN), 0)
AND (CASE WHEN a.Proyecto = '' THEN 'Sin Proyecto' Else a.Proyecto END) = ISNULL(@Proyecto, a.Proyecto)
IF @CentroCostos IS NULL
SELECT @IngresosAlJul = Sum(ISNULL(a.Cargos, 0.0)-ISNULL(a.Abonos, 0.0))
FROM Acum a
WHERE a.Rama = 'CONT'
AND a.Cuenta = @CtaIngresos
AND a.Moneda = @Moneda
AND a.Ejercicio = @Ejercicio
AND a.Empresa = @Empresa
AND a.Periodo = 7
AND (@CentroCostos2 IS NULL OR a.SubCuenta2 = @CentroCostos2)
AND (@CentroCostos3 IS NULL OR a.SubCuenta3 = @CentroCostos3)
AND ISNULL(a.UEN, 0) = ISNULL(ISNULL(@UEN, a.UEN), 0)
AND (CASE WHEN a.Proyecto = '' THEN 'Sin Proyecto' Else a.Proyecto END) = ISNULL(@Proyecto, a.Proyecto)
ELSE
SELECT @IngresosAlJul = Sum(ISNULL(a.Cargos, 0.0)-ISNULL(a.Abonos, 0.0))
FROM Acum a
WHERE a.Rama = 'CONT'
AND a.Cuenta = @CtaIngresos
AND a.SubCuenta = @CentroCostos
AND a.Moneda = @Moneda
AND a.Ejercicio = @Ejercicio
AND a.Empresa = @Empresa
AND a.Periodo = 7
AND (@CentroCostos2 IS NULL OR a.SubCuenta2 = @CentroCostos2)
AND (@CentroCostos3 IS NULL OR a.SubCuenta3 = @CentroCostos3)
AND ISNULL(a.UEN, 0) = ISNULL(ISNULL(@UEN, a.UEN), 0)
AND (CASE WHEN a.Proyecto = '' THEN 'Sin Proyecto' Else a.Proyecto END) = ISNULL(@Proyecto, a.Proyecto)
IF @CentroCostos IS NULL
SELECT @IngresosAlAgo = Sum(ISNULL(a.Cargos, 0.0)-ISNULL(a.Abonos, 0.0))
FROM Acum a
WHERE a.Rama = 'CONT'
AND a.Cuenta = @CtaIngresos
AND a.Moneda = @Moneda
AND a.Ejercicio = @Ejercicio
AND a.Empresa = @Empresa
AND a.Periodo = 8
AND (@CentroCostos2 IS NULL OR a.SubCuenta2 = @CentroCostos2)
AND (@CentroCostos3 IS NULL OR a.SubCuenta3 = @CentroCostos3)
AND ISNULL(a.UEN, 0) = ISNULL(ISNULL(@UEN, a.UEN), 0)
AND (CASE WHEN a.Proyecto = '' THEN 'Sin Proyecto' Else a.Proyecto END) = ISNULL(@Proyecto, a.Proyecto)
ELSE
SELECT @IngresosAlAgo = Sum(ISNULL(a.Cargos, 0.0)-ISNULL(a.Abonos, 0.0))
FROM Acum a
WHERE a.Rama = 'CONT'
AND a.Cuenta = @CtaIngresos
AND a.SubCuenta = @CentroCostos
AND a.Moneda = @Moneda
AND a.Ejercicio = @Ejercicio
AND a.Empresa = @Empresa
AND a.Periodo = 8
AND (@CentroCostos2 IS NULL OR a.SubCuenta2 = @CentroCostos2)
AND (@CentroCostos3 IS NULL OR a.SubCuenta3 = @CentroCostos3)
AND ISNULL(a.UEN, 0) = ISNULL(ISNULL(@UEN, a.UEN), 0)
AND (CASE WHEN a.Proyecto = '' THEN 'Sin Proyecto' Else a.Proyecto END) = ISNULL(@Proyecto, a.Proyecto)
IF @CentroCostos IS NULL
SELECT @IngresosAlSep = Sum(ISNULL(a.Cargos, 0.0)-ISNULL(a.Abonos, 0.0))
FROM Acum a
WHERE a.Rama = 'CONT'
AND a.Cuenta = @CtaIngresos
AND a.Moneda = @Moneda
AND a.Ejercicio = @Ejercicio
AND a.Empresa = @Empresa
AND a.Periodo = 9
AND (@CentroCostos2 IS NULL OR a.SubCuenta2 = @CentroCostos2)
AND (@CentroCostos3 IS NULL OR a.SubCuenta3 = @CentroCostos3)
AND ISNULL(a.UEN, 0) = ISNULL(ISNULL(@UEN, a.UEN), 0)
AND (CASE WHEN a.Proyecto = '' THEN 'Sin Proyecto' Else a.Proyecto END) = ISNULL(@Proyecto, a.Proyecto)
ELSE
SELECT @IngresosAlSep = Sum(ISNULL(a.Cargos, 0.0)-ISNULL(a.Abonos, 0.0))
FROM Acum a
WHERE a.Rama = 'CONT'
AND a.Cuenta = @CtaIngresos
AND a.SubCuenta = @CentroCostos
AND a.Moneda = @Moneda
AND a.Ejercicio = @Ejercicio
AND a.Empresa = @Empresa
AND a.Periodo = 9
AND (@CentroCostos2 IS NULL OR a.SubCuenta2 = @CentroCostos2)
AND (@CentroCostos3 IS NULL OR a.SubCuenta3 = @CentroCostos3)
AND ISNULL(a.UEN, 0) = ISNULL(ISNULL(@UEN, a.UEN), 0)
AND (CASE WHEN a.Proyecto = '' THEN 'Sin Proyecto' Else a.Proyecto END) = ISNULL(@Proyecto, a.Proyecto)
IF @CentroCostos IS NULL
SELECT @IngresosAlOct = Sum(ISNULL(a.Cargos, 0.0)-ISNULL(a.Abonos, 0.0))
FROM Acum a
WHERE a.Rama = 'CONT'
AND a.Cuenta = @CtaIngresos
AND a.Moneda = @Moneda
AND a.Ejercicio = @Ejercicio
AND a.Empresa = @Empresa
AND a.Periodo = 10
AND (@CentroCostos2 IS NULL OR a.SubCuenta2 = @CentroCostos2)
AND (@CentroCostos3 IS NULL OR a.SubCuenta3 = @CentroCostos3)
AND ISNULL(a.UEN, 0) = ISNULL(ISNULL(@UEN, a.UEN), 0)
AND (CASE WHEN a.Proyecto = '' THEN 'Sin Proyecto' Else a.Proyecto END) = ISNULL(@Proyecto, a.Proyecto)
ELSE
SELECT @IngresosAlOct = Sum(ISNULL(a.Cargos, 0.0)-ISNULL(a.Abonos, 0.0))
FROM Acum a
WHERE a.Rama = 'CONT'
AND a.Cuenta = @CtaIngresos
AND a.SubCuenta = @CentroCostos
AND a.Moneda = @Moneda
AND a.Ejercicio = @Ejercicio
AND a.Empresa = @Empresa
AND a.Periodo = 10
AND (@CentroCostos2 IS NULL OR a.SubCuenta2 = @CentroCostos2)
AND (@CentroCostos3 IS NULL OR a.SubCuenta3 = @CentroCostos3)
AND ISNULL(a.UEN, 0) = ISNULL(ISNULL(@UEN, a.UEN), 0)
AND (CASE WHEN a.Proyecto = '' THEN 'Sin Proyecto' Else a.Proyecto END) = ISNULL(@Proyecto, a.Proyecto)
IF @CentroCostos IS NULL
SELECT @IngresosAlNov = Sum(ISNULL(a.Cargos, 0.0)-ISNULL(a.Abonos, 0.0))
FROM Acum a
WHERE a.Rama = 'CONT'
AND a.Cuenta = @CtaIngresos
AND a.Moneda = @Moneda
AND a.Ejercicio = @Ejercicio
AND a.Empresa = @Empresa
AND a.Periodo = 11
AND (@CentroCostos2 IS NULL OR a.SubCuenta2 = @CentroCostos2)
AND (@CentroCostos3 IS NULL OR a.SubCuenta3 = @CentroCostos3)
AND ISNULL(a.UEN, 0) = ISNULL(ISNULL(@UEN, a.UEN), 0)
AND (CASE WHEN a.Proyecto = '' THEN 'Sin Proyecto' Else a.Proyecto END) = ISNULL(@Proyecto, a.Proyecto)
ELSE
SELECT @IngresosAlNov = Sum(ISNULL(a.Cargos, 0.0)-ISNULL(a.Abonos, 0.0))
FROM Acum a
WHERE a.Rama = 'CONT'
AND a.Cuenta = @CtaIngresos
AND a.SubCuenta = @CentroCostos
AND a.Moneda = @Moneda
AND a.Ejercicio = @Ejercicio
AND a.Empresa = @Empresa
AND a.Periodo = 11
AND (@CentroCostos2 IS NULL OR a.SubCuenta2 = @CentroCostos2)
AND (@CentroCostos3 IS NULL OR a.SubCuenta3 = @CentroCostos3)
AND ISNULL(a.UEN, 0) = ISNULL(ISNULL(@UEN, a.UEN), 0)
AND (CASE WHEN a.Proyecto = '' THEN 'Sin Proyecto' Else a.Proyecto END) = ISNULL(@Proyecto, a.Proyecto)
IF @CentroCostos IS NULL
SELECT @IngresosAlDic = Sum(ISNULL(a.Cargos, 0.0)-ISNULL(a.Abonos, 0.0))
FROM Acum a
WHERE a.Rama = 'CONT'
AND a.Cuenta = @CtaIngresos
AND a.Moneda = @Moneda
AND a.Ejercicio = @Ejercicio
AND a.Empresa = @Empresa
AND a.Periodo = 12
AND (@CentroCostos2 IS NULL OR a.SubCuenta2 = @CentroCostos2)
AND (@CentroCostos3 IS NULL OR a.SubCuenta3 = @CentroCostos3)
AND ISNULL(a.UEN, 0) = ISNULL(ISNULL(@UEN, a.UEN), 0)
AND (CASE WHEN a.Proyecto = '' THEN 'Sin Proyecto' Else a.Proyecto END) = ISNULL(@Proyecto, a.Proyecto)
ELSE
SELECT @IngresosAlDic = Sum(ISNULL(a.Cargos, 0.0)-ISNULL(a.Abonos, 0.0))
FROM Acum a
WHERE a.Rama = 'CONT'
AND a.Cuenta = @CtaIngresos
AND a.SubCuenta = @CentroCostos
AND a.Moneda = @Moneda
AND a.Ejercicio = @Ejercicio
AND a.Empresa = @Empresa
AND a.Periodo = 12
AND (@CentroCostos2 IS NULL OR a.SubCuenta2 = @CentroCostos2)
AND (@CentroCostos3 IS NULL OR a.SubCuenta3 = @CentroCostos3)
AND ISNULL(a.UEN, 0) = ISNULL(ISNULL(@UEN, a.UEN), 0)
AND (CASE WHEN a.Proyecto = '' THEN 'Sin Proyecto' Else a.Proyecto END) = ISNULL(@Proyecto, a.Proyecto)
IF @CentroCostos IS NULL
DECLARE crResultado CURSOR FOR
SELECT ID,
"Saldo" = (
SELECT Sum(ISNULL(a.Cargos, 0.0)-ISNULL(a.Abonos, 0.0))
FROM Acum a
WHERE a.Rama = 'CONT'
AND a.Cuenta = b.Cuenta
AND a.Ejercicio = @Ejercicio
AND a.Empresa = @Empresa
AND a.Moneda = @Moneda
AND Periodo BETWEEN 1 AND 12
AND (@CentroCostos2 IS NULL OR a.SubCuenta2 = @CentroCostos2)
AND (@CentroCostos3 IS NULL OR a.SubCuenta3 = @CentroCostos3)
AND ISNULL(a.UEN, 0) = ISNULL(ISNULL(@UEN, a.UEN), 0)
AND (CASE WHEN a.Proyecto = '' THEN 'Sin Proyecto' Else a.Proyecto END) = ISNULL(@Proyecto, a.Proyecto)
/*        AND a.Periodo BETWEEN @PeriodoD AND @PeriodoA*/)
FROM #ResultadoAnual b
ELSE
DECLARE crResultado CURSOR FOR
SELECT ID,
"Saldo" = (
SELECT Sum(ISNULL(a.Cargos, 0.0)-ISNULL(a.Abonos, 0.0))
FROM Acum a
WHERE a.Rama = 'CONT'
AND a.Cuenta = b.Cuenta
AND a.SubCuenta = @CentroCostos
AND a.Moneda = @Moneda
AND a.Ejercicio = @Ejercicio
AND a.Empresa = @Empresa
AND Periodo BETWEEN 1 AND 12
AND (@CentroCostos2 IS NULL OR a.SubCuenta2 = @CentroCostos2)
AND (@CentroCostos3 IS NULL OR a.SubCuenta3 = @CentroCostos3)
AND ISNULL(a.UEN, 0) = ISNULL(ISNULL(@UEN, a.UEN), 0)
AND (CASE WHEN a.Proyecto = '' THEN 'Sin Proyecto' Else a.Proyecto END) = ISNULL(@Proyecto, a.Proyecto)
/*        AND a.Periodo BETWEEN @PeriodoD AND @PeriodoA*/)
FROM #ResultadoAnual b
OPEN crResultado
FETCH NEXT FROM crResultado INTO @ID, @Saldo
WHILE @@FETCH_STATUS <> -1 AND @@Error = 0
BEGIN
IF @@FETCH_STATUS <> -2
UPDATE #ResultadoAnual
SET Saldo = @Saldo,
Ingresos = @Ingresos,
Porcentaje = (@Saldo/@Ingresos)*100
WHERE ID = @ID
FETCH NEXT FROM crResultado INTO @ID, @Saldo
END
CLOSE crResultado
DEALLOCATE crResultado
IF @CentroCostos IS NULL
DECLARE crResultadoAl CURSOR FOR
SELECT ID,
"SaldoAlEne" = (SELECT Sum(ISNULL(a.Cargos, 0.0)-ISNULL(a.Abonos, 0.0)) FROM Acum a WHERE a.Moneda = @Moneda AND a.Rama = 'CONT' AND a.Cuenta = b.Cuenta AND a.Empresa = @Empresa AND a.Ejercicio = @Ejercicio AND a.Periodo = 1  AND (@CentroCostos2 IS NULL OR a.SubCuenta2 = @CentroCostos2) AND (@CentroCostos3 IS NULL OR a.SubCuenta3 = @CentroCostos3) AND ISNULL(a.UEN, 0) = ISNULL(ISNULL(@UEN, a.UEN), 0) AND (CASE WHEN a.Proyecto = '' THEN 'Sin Proyecto' Else a.Proyecto END) = ISNULL(@Proyecto, a.Proyecto)),
"SaldoAlFeb" = (SELECT Sum(ISNULL(a.Cargos, 0.0)-ISNULL(a.Abonos, 0.0)) FROM Acum a WHERE a.Moneda = @Moneda AND a.Rama = 'CONT' AND a.Cuenta = b.Cuenta AND a.Empresa = @Empresa AND a.Ejercicio = @Ejercicio AND a.Periodo = 2  AND (@CentroCostos2 IS NULL OR a.SubCuenta2 = @CentroCostos2) AND (@CentroCostos3 IS NULL OR a.SubCuenta3 = @CentroCostos3) AND ISNULL(a.UEN, 0) = ISNULL(ISNULL(@UEN, a.UEN), 0) AND (CASE WHEN a.Proyecto = '' THEN 'Sin Proyecto' Else a.Proyecto END) = ISNULL(@Proyecto, a.Proyecto)),
"SaldoAlMar" = (SELECT Sum(ISNULL(a.Cargos, 0.0)-ISNULL(a.Abonos, 0.0)) FROM Acum a WHERE a.Moneda = @Moneda AND a.Rama = 'CONT' AND a.Cuenta = b.Cuenta AND a.Empresa = @Empresa AND a.Ejercicio = @Ejercicio AND a.Periodo = 3  AND (@CentroCostos2 IS NULL OR a.SubCuenta2 = @CentroCostos2) AND (@CentroCostos3 IS NULL OR a.SubCuenta3 = @CentroCostos3) AND ISNULL(a.UEN, 0) = ISNULL(ISNULL(@UEN, a.UEN), 0) AND (CASE WHEN a.Proyecto = '' THEN 'Sin Proyecto' Else a.Proyecto END) = ISNULL(@Proyecto, a.Proyecto)),
"SaldoAlAbr" = (SELECT Sum(ISNULL(a.Cargos, 0.0)-ISNULL(a.Abonos, 0.0)) FROM Acum a WHERE a.Moneda = @Moneda AND a.Rama = 'CONT' AND a.Cuenta = b.Cuenta AND a.Empresa = @Empresa AND a.Ejercicio = @Ejercicio AND a.Periodo = 4  AND (@CentroCostos2 IS NULL OR a.SubCuenta2 = @CentroCostos2) AND (@CentroCostos3 IS NULL OR a.SubCuenta3 = @CentroCostos3) AND ISNULL(a.UEN, 0) = ISNULL(ISNULL(@UEN, a.UEN), 0) AND (CASE WHEN a.Proyecto = '' THEN 'Sin Proyecto' Else a.Proyecto END) = ISNULL(@Proyecto, a.Proyecto)),
"SaldoAlMay" = (SELECT Sum(ISNULL(a.Cargos, 0.0)-ISNULL(a.Abonos, 0.0)) FROM Acum a WHERE a.Moneda = @Moneda AND a.Rama = 'CONT' AND a.Cuenta = b.Cuenta AND a.Empresa = @Empresa AND a.Ejercicio = @Ejercicio AND a.Periodo = 5  AND (@CentroCostos2 IS NULL OR a.SubCuenta2 = @CentroCostos2) AND (@CentroCostos3 IS NULL OR a.SubCuenta3 = @CentroCostos3) AND ISNULL(a.UEN, 0) = ISNULL(ISNULL(@UEN, a.UEN), 0) AND (CASE WHEN a.Proyecto = '' THEN 'Sin Proyecto' Else a.Proyecto END) = ISNULL(@Proyecto, a.Proyecto)),
"SaldoAlJun" = (SELECT Sum(ISNULL(a.Cargos, 0.0)-ISNULL(a.Abonos, 0.0)) FROM Acum a WHERE a.Moneda = @Moneda AND a.Rama = 'CONT' AND a.Cuenta = b.Cuenta AND a.Empresa = @Empresa AND a.Ejercicio = @Ejercicio AND a.Periodo = 6  AND (@CentroCostos2 IS NULL OR a.SubCuenta2 = @CentroCostos2) AND (@CentroCostos3 IS NULL OR a.SubCuenta3 = @CentroCostos3) AND ISNULL(a.UEN, 0) = ISNULL(ISNULL(@UEN, a.UEN), 0) AND (CASE WHEN a.Proyecto = '' THEN 'Sin Proyecto' Else a.Proyecto END) = ISNULL(@Proyecto, a.Proyecto)),
"SaldoAlJul" = (SELECT Sum(ISNULL(a.Cargos, 0.0)-ISNULL(a.Abonos, 0.0)) FROM Acum a WHERE a.Moneda = @Moneda AND a.Rama = 'CONT' AND a.Cuenta = b.Cuenta AND a.Empresa = @Empresa AND a.Ejercicio = @Ejercicio AND a.Periodo = 7  AND (@CentroCostos2 IS NULL OR a.SubCuenta2 = @CentroCostos2) AND (@CentroCostos3 IS NULL OR a.SubCuenta3 = @CentroCostos3) AND ISNULL(a.UEN, 0) = ISNULL(ISNULL(@UEN, a.UEN), 0) AND (CASE WHEN a.Proyecto = '' THEN 'Sin Proyecto' Else a.Proyecto END) = ISNULL(@Proyecto, a.Proyecto)),
"SaldoAlAgo" = (SELECT Sum(ISNULL(a.Cargos, 0.0)-ISNULL(a.Abonos, 0.0)) FROM Acum a WHERE a.Moneda = @Moneda AND a.Rama = 'CONT' AND a.Cuenta = b.Cuenta AND a.Empresa = @Empresa AND a.Ejercicio = @Ejercicio AND a.Periodo = 8  AND (@CentroCostos2 IS NULL OR a.SubCuenta2 = @CentroCostos2) AND (@CentroCostos3 IS NULL OR a.SubCuenta3 = @CentroCostos3) AND ISNULL(a.UEN, 0) = ISNULL(ISNULL(@UEN, a.UEN), 0) AND (CASE WHEN a.Proyecto = '' THEN 'Sin Proyecto' Else a.Proyecto END) = ISNULL(@Proyecto, a.Proyecto)),
"SaldoAlSep" = (SELECT Sum(ISNULL(a.Cargos, 0.0)-ISNULL(a.Abonos, 0.0)) FROM Acum a WHERE a.Moneda = @Moneda AND a.Rama = 'CONT' AND a.Cuenta = b.Cuenta AND a.Empresa = @Empresa AND a.Ejercicio = @Ejercicio AND a.Periodo = 9  AND (@CentroCostos2 IS NULL OR a.SubCuenta2 = @CentroCostos2) AND (@CentroCostos3 IS NULL OR a.SubCuenta3 = @CentroCostos3) AND ISNULL(a.UEN, 0) = ISNULL(ISNULL(@UEN, a.UEN), 0) AND (CASE WHEN a.Proyecto = '' THEN 'Sin Proyecto' Else a.Proyecto END) = ISNULL(@Proyecto, a.Proyecto)),
"SaldoAlOct" = (SELECT Sum(ISNULL(a.Cargos, 0.0)-ISNULL(a.Abonos, 0.0)) FROM Acum a WHERE a.Moneda = @Moneda AND a.Rama = 'CONT' AND a.Cuenta = b.Cuenta AND a.Empresa = @Empresa AND a.Ejercicio = @Ejercicio AND a.Periodo = 10 AND (@CentroCostos2 IS NULL OR a.SubCuenta2 = @CentroCostos2) AND (@CentroCostos3 IS NULL OR a.SubCuenta3 = @CentroCostos3) AND ISNULL(a.UEN, 0) = ISNULL(ISNULL(@UEN, a.UEN), 0) AND (CASE WHEN a.Proyecto = '' THEN 'Sin Proyecto' Else a.Proyecto END) = ISNULL(@Proyecto, a.Proyecto)),
"SaldoAlNov" = (SELECT Sum(ISNULL(a.Cargos, 0.0)-ISNULL(a.Abonos, 0.0)) FROM Acum a WHERE a.Moneda = @Moneda AND a.Rama = 'CONT' AND a.Cuenta = b.Cuenta AND a.Empresa = @Empresa AND a.Ejercicio = @Ejercicio AND a.Periodo = 11 AND (@CentroCostos2 IS NULL OR a.SubCuenta2 = @CentroCostos2) AND (@CentroCostos3 IS NULL OR a.SubCuenta3 = @CentroCostos3) AND ISNULL(a.UEN, 0) = ISNULL(ISNULL(@UEN, a.UEN), 0) AND (CASE WHEN a.Proyecto = '' THEN 'Sin Proyecto' Else a.Proyecto END) = ISNULL(@Proyecto, a.Proyecto)),
"SaldoAlDic" = (SELECT Sum(ISNULL(a.Cargos, 0.0)-ISNULL(a.Abonos, 0.0)) FROM Acum a WHERE a.Moneda = @Moneda AND a.Rama = 'CONT' AND a.Cuenta = b.Cuenta AND a.Empresa = @Empresa AND a.Ejercicio = @Ejercicio AND a.Periodo = 12 AND (@CentroCostos2 IS NULL OR a.SubCuenta2 = @CentroCostos2) AND (@CentroCostos3 IS NULL OR a.SubCuenta3 = @CentroCostos3) AND ISNULL(a.UEN, 0) = ISNULL(ISNULL(@UEN, a.UEN), 0) AND (CASE WHEN a.Proyecto = '' THEN 'Sin Proyecto' Else a.Proyecto END) = ISNULL(@Proyecto, a.Proyecto))
FROM #ResultadoAnual b
ELSE
DECLARE crResultadoAl CURSOR FOR
SELECT ID,
"SaldoAlEne" = (SELECT Sum(ISNULL(a.Cargos, 0.0)-ISNULL(a.Abonos, 0.0)) FROM Acum a WHERE a.Moneda = @Moneda AND a.Rama = 'CONT' AND a.Cuenta = b.Cuenta AND a.SubCuenta = @CentroCostos AND a.Empresa = @Empresa AND a.Ejercicio = @Ejercicio AND a.Periodo = 1  AND (@CentroCostos2 IS NULL OR a.SubCuenta2 = @CentroCostos2) AND (@CentroCostos3 IS NULL OR a.SubCuenta3 = @CentroCostos3) AND ISNULL(a.UEN, 0) = ISNULL(ISNULL(@UEN, a.UEN), 0) AND (CASE WHEN a.Proyecto = '' THEN 'Sin Proyecto' Else a.Proyecto END) = ISNULL(@Proyecto, a.Proyecto)),
"SaldoAlFeb" = (SELECT Sum(ISNULL(a.Cargos, 0.0)-ISNULL(a.Abonos, 0.0)) FROM Acum a WHERE a.Moneda = @Moneda AND a.Rama = 'CONT' AND a.Cuenta = b.Cuenta AND a.SubCuenta = @CentroCostos AND a.Empresa = @Empresa AND a.Ejercicio = @Ejercicio AND a.Periodo = 2  AND (@CentroCostos2 IS NULL OR a.SubCuenta2 = @CentroCostos2) AND (@CentroCostos3 IS NULL OR a.SubCuenta3 = @CentroCostos3) AND ISNULL(a.UEN, 0) = ISNULL(ISNULL(@UEN, a.UEN), 0) AND (CASE WHEN a.Proyecto = '' THEN 'Sin Proyecto' Else a.Proyecto END) = ISNULL(@Proyecto, a.Proyecto)),
"SaldoAlMar" = (SELECT Sum(ISNULL(a.Cargos, 0.0)-ISNULL(a.Abonos, 0.0)) FROM Acum a WHERE a.Moneda = @Moneda AND a.Rama = 'CONT' AND a.Cuenta = b.Cuenta AND a.SubCuenta = @CentroCostos AND a.Empresa = @Empresa AND a.Ejercicio = @Ejercicio AND a.Periodo = 3  AND (@CentroCostos2 IS NULL OR a.SubCuenta2 = @CentroCostos2) AND (@CentroCostos3 IS NULL OR a.SubCuenta3 = @CentroCostos3) AND ISNULL(a.UEN, 0) = ISNULL(ISNULL(@UEN, a.UEN), 0) AND (CASE WHEN a.Proyecto = '' THEN 'Sin Proyecto' Else a.Proyecto END) = ISNULL(@Proyecto, a.Proyecto)),
"SaldoAlAbr" = (SELECT Sum(ISNULL(a.Cargos, 0.0)-ISNULL(a.Abonos, 0.0)) FROM Acum a WHERE a.Moneda = @Moneda AND a.Rama = 'CONT' AND a.Cuenta = b.Cuenta AND a.SubCuenta = @CentroCostos AND a.Empresa = @Empresa AND a.Ejercicio = @Ejercicio AND a.Periodo = 4  AND (@CentroCostos2 IS NULL OR a.SubCuenta2 = @CentroCostos2) AND (@CentroCostos3 IS NULL OR a.SubCuenta3 = @CentroCostos3) AND ISNULL(a.UEN, 0) = ISNULL(ISNULL(@UEN, a.UEN), 0) AND (CASE WHEN a.Proyecto = '' THEN 'Sin Proyecto' Else a.Proyecto END) = ISNULL(@Proyecto, a.Proyecto)),
"SaldoAlMay" = (SELECT Sum(ISNULL(a.Cargos, 0.0)-ISNULL(a.Abonos, 0.0)) FROM Acum a WHERE a.Moneda = @Moneda AND a.Rama = 'CONT' AND a.Cuenta = b.Cuenta AND a.SubCuenta = @CentroCostos AND a.Empresa = @Empresa AND a.Ejercicio = @Ejercicio AND a.Periodo = 5  AND (@CentroCostos2 IS NULL OR a.SubCuenta2 = @CentroCostos2) AND (@CentroCostos3 IS NULL OR a.SubCuenta3 = @CentroCostos3) AND ISNULL(a.UEN, 0) = ISNULL(ISNULL(@UEN, a.UEN), 0) AND (CASE WHEN a.Proyecto = '' THEN 'Sin Proyecto' Else a.Proyecto END) = ISNULL(@Proyecto, a.Proyecto)),
"SaldoAlJun" = (SELECT Sum(ISNULL(a.Cargos, 0.0)-ISNULL(a.Abonos, 0.0)) FROM Acum a WHERE a.Moneda = @Moneda AND a.Rama = 'CONT' AND a.Cuenta = b.Cuenta AND a.SubCuenta = @CentroCostos AND a.Empresa = @Empresa AND a.Ejercicio = @Ejercicio AND a.Periodo = 6  AND (@CentroCostos2 IS NULL OR a.SubCuenta2 = @CentroCostos2) AND (@CentroCostos3 IS NULL OR a.SubCuenta3 = @CentroCostos3) AND ISNULL(a.UEN, 0) = ISNULL(ISNULL(@UEN, a.UEN), 0) AND (CASE WHEN a.Proyecto = '' THEN 'Sin Proyecto' Else a.Proyecto END) = ISNULL(@Proyecto, a.Proyecto)),
"SaldoAlJul" = (SELECT Sum(ISNULL(a.Cargos, 0.0)-ISNULL(a.Abonos, 0.0)) FROM Acum a WHERE a.Moneda = @Moneda AND a.Rama = 'CONT' AND a.Cuenta = b.Cuenta AND a.SubCuenta = @CentroCostos AND a.Empresa = @Empresa AND a.Ejercicio = @Ejercicio AND a.Periodo = 7  AND (@CentroCostos2 IS NULL OR a.SubCuenta2 = @CentroCostos2) AND (@CentroCostos3 IS NULL OR a.SubCuenta3 = @CentroCostos3) AND ISNULL(a.UEN, 0) = ISNULL(ISNULL(@UEN, a.UEN), 0) AND (CASE WHEN a.Proyecto = '' THEN 'Sin Proyecto' Else a.Proyecto END) = ISNULL(@Proyecto, a.Proyecto)),
"SaldoAlAgo" = (SELECT Sum(ISNULL(a.Cargos, 0.0)-ISNULL(a.Abonos, 0.0)) FROM Acum a WHERE a.Moneda = @Moneda AND a.Rama = 'CONT' AND a.Cuenta = b.Cuenta AND a.SubCuenta = @CentroCostos AND a.Empresa = @Empresa AND a.Ejercicio = @Ejercicio AND a.Periodo = 8  AND (@CentroCostos2 IS NULL OR a.SubCuenta2 = @CentroCostos2) AND (@CentroCostos3 IS NULL OR a.SubCuenta3 = @CentroCostos3) AND ISNULL(a.UEN, 0) = ISNULL(ISNULL(@UEN, a.UEN), 0) AND (CASE WHEN a.Proyecto = '' THEN 'Sin Proyecto' Else a.Proyecto END) = ISNULL(@Proyecto, a.Proyecto)),
"SaldoAlSep" = (SELECT Sum(ISNULL(a.Cargos, 0.0)-ISNULL(a.Abonos, 0.0)) FROM Acum a WHERE a.Moneda = @Moneda AND a.Rama = 'CONT' AND a.Cuenta = b.Cuenta AND a.SubCuenta = @CentroCostos AND a.Empresa = @Empresa AND a.Ejercicio = @Ejercicio AND a.Periodo = 9  AND (@CentroCostos2 IS NULL OR a.SubCuenta2 = @CentroCostos2) AND (@CentroCostos3 IS NULL OR a.SubCuenta3 = @CentroCostos3) AND ISNULL(a.UEN, 0) = ISNULL(ISNULL(@UEN, a.UEN), 0) AND (CASE WHEN a.Proyecto = '' THEN 'Sin Proyecto' Else a.Proyecto END) = ISNULL(@Proyecto, a.Proyecto)),
"SaldoAlOct" = (SELECT Sum(ISNULL(a.Cargos, 0.0)-ISNULL(a.Abonos, 0.0)) FROM Acum a WHERE a.Moneda = @Moneda AND a.Rama = 'CONT' AND a.Cuenta = b.Cuenta AND a.SubCuenta = @CentroCostos AND a.Empresa = @Empresa AND a.Ejercicio = @Ejercicio AND a.Periodo = 10 AND (@CentroCostos2 IS NULL OR a.SubCuenta2 = @CentroCostos2) AND (@CentroCostos3 IS NULL OR a.SubCuenta3 = @CentroCostos3) AND ISNULL(a.UEN, 0) = ISNULL(ISNULL(@UEN, a.UEN), 0) AND (CASE WHEN a.Proyecto = '' THEN 'Sin Proyecto' Else a.Proyecto END) = ISNULL(@Proyecto, a.Proyecto)),
"SaldoAlNov" = (SELECT Sum(ISNULL(a.Cargos, 0.0)-ISNULL(a.Abonos, 0.0)) FROM Acum a WHERE a.Moneda = @Moneda AND a.Rama = 'CONT' AND a.Cuenta = b.Cuenta AND a.SubCuenta = @CentroCostos AND a.Empresa = @Empresa AND a.Ejercicio = @Ejercicio AND a.Periodo = 11 AND (@CentroCostos2 IS NULL OR a.SubCuenta2 = @CentroCostos2) AND (@CentroCostos3 IS NULL OR a.SubCuenta3 = @CentroCostos3) AND ISNULL(a.UEN, 0) = ISNULL(ISNULL(@UEN, a.UEN), 0) AND (CASE WHEN a.Proyecto = '' THEN 'Sin Proyecto' Else a.Proyecto END) = ISNULL(@Proyecto, a.Proyecto)),
"SaldoAlDic" = (SELECT Sum(ISNULL(a.Cargos, 0.0)-ISNULL(a.Abonos, 0.0)) FROM Acum a WHERE a.Moneda = @Moneda AND a.Rama = 'CONT' AND a.Cuenta = b.Cuenta AND a.SubCuenta = @CentroCostos AND a.Empresa = @Empresa AND a.Ejercicio = @Ejercicio AND a.Periodo = 12 AND (@CentroCostos2 IS NULL OR a.SubCuenta2 = @CentroCostos2) AND (@CentroCostos3 IS NULL OR a.SubCuenta3 = @CentroCostos3) AND ISNULL(a.UEN, 0) = ISNULL(ISNULL(@UEN, a.UEN), 0) AND (CASE WHEN a.Proyecto = '' THEN 'Sin Proyecto' Else a.Proyecto END) = ISNULL(@Proyecto, a.Proyecto))
FROM #ResultadoAnual b
OPEN crResultadoAl
FETCH NEXT FROM crResultadoAl INTO @ID, @SaldoAlEne, @SaldoAlFeb, @SaldoAlMar, @SaldoAlAbr, @SaldoAlMay, @SaldoAlJun, @SaldoAlJul, @SaldoAlAgo, @SaldoAlSep, @SaldoAlOct, @SaldoAlNov, @SaldoAlDic/*, @IngresosAlEne, @IngresosAlFeb, @IngresosAlMar, @IngresosAlAbr, @IngresosAlMay, @IngresosAlJun, @IngresosAlJul, @IngresosAlAgo, @IngresosAlSep, @IngresosAlOct, @IngresosAlNov, @IngresosAlDic, @PorcentajeAlEne, @PorcentajeAlFeb, @PorcentajeAlMar, @PorcentajeAlAbr, @PorcentajeAlMay, @PorcentajeAlJun, @PorcentajeAlJul, @PorcentajeAlAgo, @PorcentajeAlSep, @PorcentajeAlOct, @PorcentajeAlNov, @PorcentajeAlDic*/
WHILE @@FETCH_STATUS <> -1 AND @@Error = 0
BEGIN
IF @@FETCH_STATUS <> -2
UPDATE #ResultadoAnual
SET SaldoAlEne = @SaldoAlEne,
SaldoAlFeb = @SaldoAlFeb,
SaldoAlMar = @SaldoAlMar,
SaldoAlAbr = @SaldoAlAbr,
SaldoAlMay = @SaldoAlMay,
SaldoAlJun = @SaldoAlJun,
SaldoAlJul = @SaldoAlJul,
SaldoAlAgo = @SaldoAlAgo,
SaldoAlSep = @SaldoAlSep,
SaldoAlOct = @SaldoAlOct,
SaldoAlNov = @SaldoAlNov,
SaldoAlDic = @SaldoAlDic,
IngresosAlEne = @IngresosAlEne,
IngresosAlFeb = @IngresosAlFeb,
IngresosAlMar = @IngresosAlMar,
IngresosAlAbr = @IngresosAlAbr,
IngresosAlMay = @IngresosAlMay,
IngresosAlJun = @IngresosAlJun,
IngresosAlJul = @IngresosAlJul,
IngresosAlAgo = @IngresosAlAgo,
IngresosAlSep = @IngresosAlSep,
IngresosAlOct = @IngresosAlOct,
IngresosAlNov = @IngresosAlNov,
IngresosAlDic = @IngresosAlDic,
PorcentajeAlEne = (@SaldoAlEne/@IngresosAlEne)*100,
PorcentajeAlFeb = (@SaldoAlFeb/@IngresosAlFeb)*100,
PorcentajeAlMar = (@SaldoAlMar/@IngresosAlMar)*100,
PorcentajeAlAbr = (@SaldoAlAbr/@IngresosAlAbr)*100,
PorcentajeAlMay = (@SaldoAlMay/@IngresosAlMay)*100,
PorcentajeAlJun = (@SaldoAlJun/@IngresosAlJun)*100,
PorcentajeAlJul = (@SaldoAlJul/@IngresosAlJul)*100,
PorcentajeAlAgo = (@SaldoAlAgo/@IngresosAlAgo)*100,
PorcentajeAlSep = (@SaldoAlSep/@IngresosAlSep)*100,
PorcentajeAlOct = (@SaldoAlOct/@IngresosAlOct)*100,
PorcentajeAlNov = (@SaldoAlNov/@IngresosAlNov)*100,
PorcentajeAlDic = (@SaldoAlDic/@IngresosAlDic)*100
WHERE ID = @ID
FETCH NEXT FROM crResultadoAl INTO @ID, @SaldoAlEne, @SaldoAlFeb, @SaldoAlMar, @SaldoAlAbr, @SaldoAlMay, @SaldoAlJun, @SaldoAlJul, @SaldoAlAgo, @SaldoAlSep, @SaldoAlOct, @SaldoAlNov, @SaldoAlDic/*, @IngresosAlEne, @IngresosAlFeb, @IngresosAlMar, @IngresosAlAbr, @IngresosAlMay, @IngresosAlJun, @IngresosAlJul, @IngresosAlAgo, @IngresosAlSep, @IngresosAlOct, @IngresosAlNov, @IngresosAlDic, @PorcentajeAlEne, @PorcentajeAlFeb, @PorcentajeAlMar, @PorcentajeAlAbr, @PorcentajeAlMay, @PorcentajeAlJun, @PorcentajeAlJul, @PorcentajeAlAgo, @PorcentajeAlSep, @PorcentajeAlOct, @PorcentajeAlNov, @PorcentajeAlDic*/
END
CLOSE crResultadoAl
DEALLOCATE crResultadoAl
/*  IF @ConMovs = 'SI'
SELECT * FROM #ResultadoAnual WHERE ISNULL(Saldo, 0.0) <> 0.0 OR ISNULL(SaldoAlEne, 0.0) <> 0.0
ELSE*/
SELECT * FROM #ResultadoAnual
END

