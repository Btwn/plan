SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spVerContResultados
@Empresa		varchar(5)  = NULL,
@Ejercicio		int,
@PeriodoD		int,
@PeriodoA		int,
@ConMovs		varchar(20) = 'NO',
@CentroCostos	varchar(50) = NULL,
@Sucursal		int	    = NULL,
@OrdenCC		varchar(20) = 'NO',
@Moneda		varchar(10) = NULL,
@CCGrupo		varchar(50) = NULL,
@Controladora	varchar(5)  = NULL,
@UEN		int	    = NULL,
@Proyecto		varchar(50) = NULL,
@CentroCostos2	varchar(50) = NULL,
@CentroCostos3	varchar(50) = NULL,
@AlCentroCostos	varchar(20) = NULL,
@AlCentroCostos2	varchar(20) = NULL,
@AlCentroCostos3	varchar(20) = NULL,
@ReExpresar     char(20) = 'NO', 
@ReExpresarTipoCambio float = NULL 

AS BEGIN
DECLARE
@ID				int,
@CtaResultados		varchar(20),
@CtaIngresos		varchar(20),
@CtaCostoDirecto		varchar(20),
@CtaGastosOperacion		varchar(20),
@CtaOtrosGastosProductos	varchar(20),
@CtaImpuestos		varchar(20),
@Saldo			money,
@Ingresos			money,
@IngresosAl			money
SELECT @Moneda        = NULLIF(NULLIF(RTRIM(@Moneda), ''), '0'),
@CCGrupo       = NULLIF(NULLIF(RTRIM(@CCGrupo), ''), '0')
IF @Moneda IS NULL SELECT @Moneda = ContMoneda FROM EmpresaCfg WHERE Empresa = @Empresa
CREATE TABLE #Resultado (
Orden		int		NOT NULL,
ID			int		IDENTITY(1,1) NOT NULL,
Clase		varchar(30)	COLLATE Database_Default NULL,
SubClase		varchar(20)	COLLATE Database_Default NULL,
Rama		varchar(20)	COLLATE Database_Default NULL,
RamaDesc		varchar(100)	COLLATE Database_Default NULL,
RamaEsAcreedora	bit		NOT NULL DEFAULT 0,
Cuenta		varchar(20)	COLLATE Database_Default NULL,
Descripcion	varchar(100)	COLLATE Database_Default NULL,
EsAcreedora	bit		NOT NULL DEFAULT 0,
SubCuenta		varchar(20)	COLLATE Database_Default NULL,
CentroCostos	varchar(100)	COLLATE Database_Default NULL,
Saldo		money		NULL,
Ingresos		money		NULL,
Porcentaje		float		NULL,
SaldoAl		money		NULL,
IngresosAl		money		NULL,
PorcentajeAl	float		NULL,
CONSTRAINT priTempResultado PRIMARY KEY CLUSTERED (Orden, ID)
)
SELECT @ConMovs = UPPER(@ConMovs), @CentroCostos = NULLIF(RTRIM(@CentroCostos), '')
IF @Sucursal<0 SELECT @Sucursal = NULL
IF @UEN = 0 SELECT @UEN = NULL
IF UPPER(@Proyecto)        IN ('0', 'NULL', '(TODOS)','', '(ALL)') SELECT @Proyecto = NULL
IF UPPER(@CentroCostos)    IN ('0', 'NULL', '(TODOS)','', '(ALL)') SELECT @CentroCostos = NULL
IF UPPER(@CentroCostos2)   IN ('0', 'NULL', '(TODOS)','', '(ALL)') SELECT @CentroCostos2 = NULL
IF UPPER(@CentroCostos3)   IN ('0', 'NULL', '(TODOS)','', '(ALL)') SELECT @CentroCostos3 = NULL
IF UPPER(@AlCentroCostos)  IN ('0', 'NULL', '(TODOS)','', '(ALL)') SELECT @AlCentroCostos = NULL
IF UPPER(@AlCentroCostos2) IN ('0', 'NULL', '(TODOS)','', '(ALL)') SELECT @AlCentroCostos2 = NULL
IF UPPER(@AlCentroCostos3) IN ('0', 'NULL', '(TODOS)','', '(ALL)') SELECT @AlCentroCostos3 = NULL
SELECT @AlCentroCostos  = ISNULL(@AlCentroCostos, @CentroCostos),
@AlCentroCostos2 = ISNULL(@AlCentroCostos2, @CentroCostos2),
@AlCentroCostos3 = ISNULL(@AlCentroCostos3, @CentroCostos3)
SELECT DISTINCT
@CtaResultados   		= CtaResultados,
@CtaIngresos	   		= CtaIngresos,
@CtaCostoDirecto 		= CtaCostoDirecto,
@CtaGastosOperacion		= CtaGastosOperacion,
@CtaOtrosGastosProductos	= CtaOtrosGastosProductos,
@CtaImpuestos			= CtaImpuestos
FROM EmpresaCfg
WHERE Empresa = @Empresa
INSERT #Resultado
SELECT DISTINCT 1, "Utilidad Bruta",
"Ventas",
Rama.Cuenta,
Rama.Descripcion,
Rama.EsAcreedora,
Cta.Cuenta,
Cta.Descripcion,
Cta.EsAcreedora,
cc.SubCuenta,
cc.CentroCostos,
NULL,NULL,NULL,
NULL,NULL,NULL
FROM Cta
JOIN Cta Rama ON Rama.Cuenta = Cta.Rama
JOIN ContSubSaldo cc ON cc.Cuenta = Cta.cuenta AND cc.Moneda = @Moneda AND cc.Empresa = @Empresa
WHERE UPPER(Cta.Tipo) = 'MAYOR'
AND (Cta.Rama = @CtaIngresos OR Rama.Rama = @CtaIngresos)
INSERT #Resultado
SELECT DISTINCT 2, "Utilidad Bruta",
"Costos",
Rama.Cuenta,
Rama.Descripcion,
Rama.EsAcreedora,
Cta.Cuenta,
Cta.Descripcion,
Cta.EsAcreedora,
cc.SubCuenta,
cc.CentroCostos,
NULL,NULL,NULL,
NULL,NULL,NULL
FROM Cta
JOIN Cta Rama ON Rama.Cuenta = Cta.Rama
JOIN ContSubSaldo cc ON cc.Cuenta = Cta.cuenta AND cc.Moneda = @Moneda AND cc.Empresa = @Empresa
WHERE UPPER(Cta.Tipo) = 'MAYOR'
AND (Cta.Rama = @CtaCostoDirecto OR Rama.Rama = @CtaCostoDirecto)
INSERT #Resultado
SELECT DISTINCT 3, "UAFIR",
"Gastos",
Rama.Cuenta,
Rama.Descripcion,
Rama.EsAcreedora,
Cta.Cuenta,
Cta.Descripcion,
Cta.EsAcreedora,
cc.SubCuenta,
cc.CentroCostos,
NULL,NULL,NULL,
NULL,NULL,NULL
FROM Cta
JOIN Cta Rama ON Rama.Cuenta = Cta.Rama
JOIN ContSubSaldo cc ON cc.Cuenta = Cta.cuenta AND cc.Moneda = @Moneda AND cc.Empresa = @Empresa
WHERE UPPER(Cta.Tipo) = 'MAYOR'
AND (Cta.Rama = @CtaGastosOperacion OR Rama.Rama = @CtaGastosOperacion)
INSERT #Resultado
SELECT DISTINCT 4, "Utilidad Antes de Impuestos",
"Gastos",
Rama.Cuenta,
Rama.Descripcion,
Rama.EsAcreedora,
Cta.Cuenta,
Cta.Descripcion,
Cta.EsAcreedora,
cc.SubCuenta,
cc.CentroCostos,
NULL,NULL,NULL,
NULL,NULL,NULL
FROM Cta
JOIN Cta Rama ON Rama.Cuenta = Cta.Rama
JOIN ContSubSaldo cc ON cc.Cuenta = Cta.cuenta AND cc.Moneda = @Moneda AND cc.Empresa = @Empresa
WHERE UPPER(Cta.Tipo) = 'MAYOR'
AND (Cta.Rama = @CtaOtrosGastosProductos OR Rama.Rama = @CtaOtrosGastosProductos)
INSERT #Resultado
SELECT DISTINCT 5, "Utilidad Neta",
"Otros",
Rama.Cuenta,
Rama.Descripcion,
Rama.EsAcreedora,
Cta.Cuenta,
Cta.Descripcion,
Cta.EsAcreedora,
cc.SubCuenta,
cc.CentroCostos,
NULL,NULL,NULL,
NULL,NULL,NULL
FROM Cta
JOIN Cta Rama ON Rama.Cuenta = Cta.Rama
JOIN ContSubSaldo cc ON cc.Cuenta = Cta.cuenta AND cc.Moneda = @Moneda AND cc.Empresa = @Empresa
WHERE UPPER(Cta.Tipo) = 'MAYOR'
AND (Cta.Rama = @CtaResultados OR Rama.Rama = @CtaResultados)
AND (Cta.Rama <> @CtaIngresos AND Rama.Rama <> @CtaIngresos)
AND (Cta.Rama <> @CtaCostoDirecto AND Rama.Rama <> @CtaCostoDirecto)
AND (Cta.Rama <> @CtaGastosOperacion AND Rama.Rama <> @CtaGastosOperacion)
AND (Cta.Rama <> @CtaOtrosGastosProductos AND Rama.Rama <> @CtaOtrosGastosProductos)
SELECT @Ingresos = Sum(ISNULL(a.Cargos, 0.0)-ISNULL(a.Abonos, 0.0))
FROM Acum a
WHERE a.Rama = 'CONT'
AND a.Cuenta = @CtaIngresos
AND ISNULL(a.Sucursal, 0) = ISNULL(ISNULL(@Sucursal, a.Sucursal), 0)
AND ISNULL(a.UEN, 0) = ISNULL(ISNULL(@UEN, a.UEN), 0)
AND ISNULL(a.Proyecto, '') = ISNULL(ISNULL(@Proyecto, a.Proyecto), '')
AND (@CentroCostos  IS NULL OR a.SubCuenta  BETWEEN @CentroCostos  AND @AlCentroCostos)
AND (@CentroCostos2 IS NULL OR a.SubCuenta2 BETWEEN @CentroCostos2 AND @AlCentroCostos2)
AND (@CentroCostos2 IS NULL OR a.SubCuenta3 BETWEEN @CentroCostos3 AND @AlCentroCostos3)
AND a.Ejercicio = @Ejercicio
AND a.Periodo BETWEEN @PeriodoD AND @PeriodoA
AND a.Moneda = @Moneda
AND a.Empresa = @Empresa
SELECT @IngresosAl = Sum(ISNULL(a.Cargos, 0.0)-ISNULL(a.Abonos, 0.0))
FROM Acum a
WHERE a.Rama = 'CONT'
AND a.Cuenta = @CtaIngresos
AND ISNULL(a.Sucursal, 0) = ISNULL(ISNULL(@Sucursal, a.Sucursal), 0)
AND ISNULL(a.UEN, 0) = ISNULL(ISNULL(@UEN, a.UEN), 0)
AND ISNULL(a.Proyecto, '') = ISNULL(ISNULL(@Proyecto, a.Proyecto), '')
AND (@CentroCostos  IS NULL OR a.SubCuenta  BETWEEN @CentroCostos  AND @AlCentroCostos)
AND (@CentroCostos2 IS NULL OR a.SubCuenta2 BETWEEN @CentroCostos2 AND @AlCentroCostos2)
AND (@CentroCostos2 IS NULL OR a.SubCuenta3 BETWEEN @CentroCostos3 AND @AlCentroCostos3)
AND a.Moneda = @Moneda
AND a.Ejercicio = @Ejercicio
AND a.Periodo = @PeriodoA
AND a.Empresa = @Empresa
UPDATE #Resultado
SET Saldo = (
SELECT Sum(ISNULL(a.Cargos, 0.0)-ISNULL(a.Abonos, 0.0))
FROM Acum a
WHERE a.Rama = 'CONT'
AND a.Cuenta = b.Cuenta
AND ISNULL(a.SubCuenta, '') = ISNULL(b.SubCuenta, '')
AND ISNULL(a.Sucursal, 0) = ISNULL(ISNULL(@Sucursal, a.Sucursal), 0)
AND ISNULL(a.UEN, 0) = ISNULL(ISNULL(@UEN, a.UEN), 0)
AND ISNULL(a.Proyecto, '') = ISNULL(ISNULL(@Proyecto, a.Proyecto), '')
AND (@CentroCostos  IS NULL OR a.SubCuenta  BETWEEN @CentroCostos  AND @AlCentroCostos)
AND (@CentroCostos2 IS NULL OR a.SubCuenta2 BETWEEN @CentroCostos2 AND @AlCentroCostos2)
AND (@CentroCostos2 IS NULL OR a.SubCuenta3 BETWEEN @CentroCostos3 AND @AlCentroCostos3)
AND a.Moneda = @Moneda
AND a.Ejercicio = @Ejercicio
AND a.Periodo BETWEEN @PeriodoD AND @PeriodoA
AND a.Empresa = @Empresa)
FROM #Resultado b
UPDATE #Resultado
SET Ingresos = @Ingresos,
Porcentaje = (Saldo/dbo.fnEvitarDivisionCero(@Ingresos))*100
UPDATE #Resultado
SET SaldoAl = (
SELECT Sum(ISNULL(a.Cargos, 0.0)-ISNULL(a.Abonos, 0.0))
FROM Acum a
WHERE a.Rama = 'CONT'
AND a.Cuenta = b.Cuenta
AND ISNULL(a.SubCuenta, '') = ISNULL(b.SubCuenta, '')
AND ISNULL(a.Sucursal, 0) = ISNULL(ISNULL(@Sucursal, a.Sucursal), 0)
AND ISNULL(a.UEN, 0) = ISNULL(ISNULL(@UEN, a.UEN), 0)
AND ISNULL(a.Proyecto, '') = ISNULL(ISNULL(@Proyecto, a.Proyecto), '')
AND (@CentroCostos  IS NULL OR a.SubCuenta  BETWEEN @CentroCostos  AND @AlCentroCostos)
AND (@CentroCostos2 IS NULL OR a.SubCuenta2 BETWEEN @CentroCostos2 AND @AlCentroCostos2)
AND (@CentroCostos2 IS NULL OR a.SubCuenta3 BETWEEN @CentroCostos3 AND @AlCentroCostos3)
AND a.Moneda = @Moneda
AND a.Ejercicio = @Ejercicio
AND a.Periodo = @PeriodoA
AND a.Empresa = @Empresa)
FROM #Resultado b
UPDATE #Resultado
SET IngresosAl = @IngresosAl,
PorcentajeAl = (SaldoAl/dbo.fnEvitarDivisionCero(@IngresosAl))*100
IF @ReExpresar = 'Si'
UPDATE #Resultado
SET Saldo=Saldo/ISNULL(@ReExpresarTipoCambio,1),
Ingresos=Ingresos/ISNULL(@ReExpresarTipoCambio,1),
SaldoAl=SaldoAl/ISNULL(@ReExpresarTipoCambio,1),
IngresosAl=IngresosAl/ISNULL(@ReExpresarTipoCambio,1)
IF @OrdenCC = 'NO'
BEGIN
IF @ConMovs = 'SI'
SELECT r.*, "Grupo" = CONVERT(varchar(50), null), "SubGrupo" = CONVERT(varchar(50), null), "SubSubGrupo" = CONVERT(varchar(50), null)
FROM #Resultado r
WHERE ISNULL(r.Saldo, 0.0) <> 0.0 OR ISNULL(r.SaldoAl, 0.0) <> 0.0 ORDER BY r.Orden, r.ID
ELSE
SELECT r.*, "Grupo" = CONVERT(varchar(50), null), "SubGrupo" = CONVERT(varchar(50), null), "SubSubGrupo" = CONVERT(varchar(50), null)
FROM #Resultado r
ORDER BY r.Orden, r.ID
END ELSE
BEGIN
IF @CCGrupo <> 'NULL'
BEGIN
IF @ConMovs = 'SI'
SELECT r.*, cc.Grupo, cc.SubGrupo, cc.SubSubGrupo
FROM #Resultado r JOIN CentroCostos cc ON r.SubCuenta = cc.CentroCostos AND cc.Grupo = ISNULL(@CCGrupo, cc.Grupo)
WHERE ISNULL(r.Saldo, 0.0) <> 0.0 OR ISNULL(r.SaldoAl, 0.0) <> 0.0
ORDER BY r.Orden, r.Rama, cc.Grupo, cc.SubGrupo, cc.SubSubGrupo, r.SubCuenta, r.ID
ELSE
SELECT r.*, cc.Grupo, cc.SubGrupo, cc.SubSubGrupo
FROM #Resultado r JOIN CentroCostos cc ON r.SubCuenta = cc.CentroCostos AND cc.Grupo = ISNULL(@CCGrupo, cc.Grupo)
ORDER BY r.Orden, r.Rama, cc.Grupo, cc.SubGrupo, cc.SubSubGrupo, r.SubCuenta, r.ID
END ELSE
BEGIN
IF @ConMovs = 'SI'
SELECT r.*, cc.Grupo, cc.SubGrupo, cc.SubSubGrupo
FROM #Resultado r LEFT OUTER JOIN CentroCostos cc ON r.SubCuenta = cc.CentroCostos
WHERE ISNULL(r.Saldo, 0.0) <> 0.0 OR ISNULL(r.SaldoAl, 0.0) <> 0.0
ORDER BY r.Orden, r.Rama, cc.Grupo, cc.SubGrupo, cc.SubSubGrupo, r.SubCuenta, r.ID
ELSE
SELECT r.*, cc.Grupo, cc.SubGrupo, cc.SubSubGrupo
FROM #Resultado r LEFT OUTER JOIN CentroCostos cc ON r.SubCuenta = cc.CentroCostos
ORDER BY r.Orden, r.Rama, cc.Grupo, cc.SubGrupo, cc.SubSubGrupo, r.SubCuenta, r.ID
END
END
END

