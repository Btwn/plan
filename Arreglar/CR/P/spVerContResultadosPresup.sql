SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spVerContResultadosPresup
@Estacion		int,
@Empresa		char(5),
@Ejercicio		int,
@PeriodoD		int,
@PeriodoA		int,
@ConMovs		char(20)    = 'NO',
@CentroCostosD		char(20)    = NULL,
@CentroCostosA		char(20)    = NULL,
@Sucursal		int	    = NULL,
@OrdenCC		char(20)    = 'NO',
@Moneda			char(10)    = NULL,
@CCGrupo		varchar(50) = NULL,
@Controladora		char(5)     = NULL,
@UEN			int	    = NULL,
@Proyecto		varchar(50) = NULL,
@CentroCostos2		varchar(50) = NULL,
@CentroCostos3		varchar(50) = NULL,
@ReExpresar     char(20) = 'NO', 
@ReExpresarTipoCambio float = NULL 

AS BEGIN
DECLARE
@ID				int,
@CtaResultados			char(20),
@CtaIngresos			char(20),
@CtaCostoDirecto		char(20),
@CtaGastosOperacion		char(20),
@CtaOtrosGastosProductos	char(20),
@CtaImpuestos			char(20),
@Saldo				money,
@Ingresos			money,
@IngresosAl			money,
@SaldoP				money,
@IngresosPE			money,
@IngresosAlPE			money,
@SaldoDif			money,
@IngresosDif			money,
@IngresosAlDif			money
SELECT @Moneda        = NULLIF(NULLIF(RTRIM(@Moneda), ''), '0'),
@CCGrupo       = NULLIF(NULLIF(RTRIM(@CCGrupo), ''), '0')
IF @Moneda IS NULL SELECT @Moneda = ContMoneda FROM EmpresaCfg WHERE Empresa = @Empresa
IF @CentroCostosD IN ('0', 'NULL', '(TODOS)','') SELECT @CentroCostosD = NULL
IF @CentroCostosA IN ('0', 'NULL', '(TODOS)','') SELECT @CentroCostosA = NULL
IF @UEN = 0 SELECT @UEN = NULL
IF UPPER(@Proyecto)  	 IN ('0', 'NULL', '(TODOS)','') SELECT @Proyecto = NULL
IF UPPER(@CentroCostos2) IN ('0', 'NULL', '(TODOS)','') SELECT @CentroCostos2 = NULL
IF UPPER(@CentroCostos3) IN ('0', 'NULL', '(TODOS)','') SELECT @CentroCostos3 = NULL
IF exists(SELECT * FROM Information_Schema.TABLES WHERE Table_Name = 'Resultado1') DELETE Resultado1 WHERE Estacion = @Estacion
ELSE
CREATE TABLE Resultado1 (
Estacion 	int		NOT NULL,
Orden		int		NOT NULL,
ID		int		IDENTITY(1,1) NOT NULL,
Clase		char(30)	NULL,
SubClase	char(20)	NULL,
Rama		char(20)	NULL,
RamaDesc	varchar(100)	NULL,
RamaEsAcreedora	bit		NOT NULL DEFAULT 0,
Cuenta		char(20)	NULL,
Descripcion	varchar(100)	NULL,
EsAcreedora	bit		NOT NULL DEFAULT 0,
SubCta		char(20)	NULL,
SubDescripcion	varchar(100)	NULL,
SubEsAcreedora	bit		NULL,
SubCuenta	varchar(20)	NULL,
CentroCostos	varchar(100)	NULL,
Saldo		money		NULL,
Ingresos	money		NULL,
Porcentaje	float		NULL,
SaldoAl		money		NULL,
IngresosAl	money		NULL,
PorcentajeAl	float		NULL,
SaldoPE		money		NULL,
IngresosPE	money		NULL,
PorcentajePE	float		NULL,
SaldoAlPE	money		NULL,
IngresosAlPE	money		NULL,
PorcentajeAlPE	float		NULL,
CONSTRAINT priTempResultado1 PRIMARY KEY CLUSTERED (Estacion, Orden, ID)
)
IF NOT EXISTS (SELECT * FROM SYSINDEXES WHERE NAME = 'indTempResultado1')
CREATE NONCLUSTERED INDEX indTempResultado1 ON Resultado1 (SubCta ASC, SubCuenta ASC)
IF NOT EXISTS (SELECT * FROM SYSINDEXES WHERE NAME = 'indTempResultado2')
CREATE NONCLUSTERED INDEX indTempResultado2 ON Resultado1 ( SubCuenta ASC,SubCta ASC)
IF NOT EXISTS (SELECT * FROM SYSINDEXES WHERE NAME = 'Cont14')
CREATE NONCLUSTERED INDEX Cont14 ON Cont (ID ASC, Moneda ASC, Ejercicio ASC, Periodo ASC, Empresa ASC, Mov ASC, Estatus ASC, Sucursal ASC )
IF NOT EXISTS (SELECT * FROM SYSINDEXES WHERE NAME = 'DEBEHABER')
CREATE NONCLUSTERED INDEX DEBEHABER ON ContD (ID, [Cuenta], [SubCuenta], [Debe], [Haber], [Sucursal])
SELECT @ConMovs = UPPER(@ConMovs)
IF @Sucursal<0 SELECT @Sucursal = NULL
SELECT @CtaResultados   		= CtaResultados,
@CtaIngresos	   		= CtaIngresos,
@CtaCostoDirecto 		= CtaCostoDirecto,
@CtaGastosOperacion		= CtaGastosOperacion,
@CtaOtrosGastosProductos	= CtaOtrosGastosProductos,
@CtaImpuestos			= CtaImpuestos
FROM EmpresaCfg
WHERE Empresa = @Empresa
INSERT Resultado1
SELECT @Estacion,
1, 'Utilidad Bruta',
'Ventas',
Rama.Cuenta,
Rama.Descripcion,
Rama.EsAcreedora,
Cta.Cuenta,
Cta.Descripcion,
Cta.EsAcreedora,
SubCta.Cuenta,
SubCta.Descripcion,
SubCta.EsAcreedora,
SubCuenta = ISNULL(cc.CentroCostos, ''),
CentroCostos = cc.Descripcion,
NULL,NULL,NULL,
NULL,NULL,NULL,
NULL,NULL,NULL,
NULL,NULL,NULL
FROM Cta
JOIN Cta Rama  ON Cta.Rama  = Rama.Cuenta
LEFT OUTER JOIN Cta SubCta  ON Cta.Cuenta = SubCta.Rama
LEFT OUTER JOIN CtaSub cs ON Cta.Cuenta = cs.Cuenta
LEFT OUTER JOIN CentroCostos cc ON cs.SubCuenta = cc.CentroCostos
WHERE Cta.Tipo = 'MAYOR'
AND (Cta.Rama = @CtaIngresos OR Rama.Rama = @CtaIngresos)
INSERT Resultado1
SELECT @Estacion,
2, 'Utilidad Bruta',
'Costos',
Rama.Cuenta,
Rama.Descripcion,
Rama.EsAcreedora,
Cta.Cuenta,
Cta.Descripcion,
Cta.EsAcreedora,
SubCta.Cuenta,
SubCta.Descripcion,
SubCta.EsAcreedora,
SubCuenta = cc.CentroCostos,
CentroCostos = cc.Descripcion,
NULL,NULL,NULL,
NULL,NULL,NULL,
NULL,NULL,NULL,
NULL,NULL,NULL
FROM Cta
JOIN Cta Rama  ON Cta.Rama  = Rama.Cuenta
LEFT OUTER JOIN Cta SubCta  ON Cta.Cuenta = SubCta.Rama
LEFT OUTER JOIN CtaSub cs ON Cta.Cuenta = cs.Cuenta
LEFT OUTER JOIN CentroCostos cc ON cs.SubCuenta = cc.CentroCostos
WHERE Cta.Tipo = 'MAYOR'
AND (Cta.Rama = @CtaCostoDirecto OR Rama.Rama = @CtaCostoDirecto)
INSERT Resultado1
SELECT @Estacion,
3, 'UAFIR',
'Gastos',
Rama.Cuenta,
Rama.Descripcion,
Rama.EsAcreedora,
Cta.Cuenta,
Cta.Descripcion,
Cta.EsAcreedora,
SubCta.Cuenta,
SubCta.Descripcion,
SubCta.EsAcreedora,
SubCuenta = cc.CentroCostos,
CentroCostos = cc.Descripcion,
NULL,NULL,NULL,
NULL,NULL,NULL,
NULL,NULL,NULL,
NULL,NULL,NULL
FROM Cta
JOIN Cta Rama  ON Cta.Rama  = Rama.Cuenta
LEFT OUTER JOIN Cta SubCta  ON Cta.Cuenta = SubCta.Rama
LEFT OUTER JOIN CtaSub cs ON Cta.Cuenta = cs.Cuenta
LEFT OUTER JOIN CentroCostos cc ON cs.SubCuenta = cc.CentroCostos
WHERE Cta.Tipo = 'MAYOR'
AND (Cta.Rama = @CtaGastosOperacion OR Rama.Rama = @CtaGastosOperacion)
INSERT Resultado1
SELECT @Estacion,
4, 'Utilidad Antes de Impuestos',
'Gastos',
Rama.Cuenta,
Rama.Descripcion,
Rama.EsAcreedora,
Cta.Cuenta,
Cta.Descripcion,
Cta.EsAcreedora,
SubCta.Cuenta,
SubCta.Descripcion,
SubCta.EsAcreedora,
SubCuenta = cc.CentroCostos,
CentroCostos = cc.Descripcion,
NULL,NULL,NULL,
NULL,NULL,NULL,
NULL,NULL,NULL,
NULL,NULL,NULL
FROM Cta
JOIN Cta Rama  ON Cta.Rama  = Rama.Cuenta
LEFT OUTER JOIN Cta SubCta  ON Cta.Cuenta = SubCta.Rama
LEFT OUTER JOIN CtaSub cs ON Cta.Cuenta = cs.Cuenta
LEFT OUTER JOIN CentroCostos cc ON cs.SubCuenta = cc.CentroCostos
WHERE Cta.Tipo = 'MAYOR'
AND (Cta.Rama = @CtaOtrosGastosProductos OR Rama.Rama = @CtaOtrosGastosProductos)
INSERT Resultado1
SELECT @Estacion,
5, 'Utilidad Neta',
'Otros',
Rama.Cuenta,
Rama.Descripcion,
Rama.EsAcreedora,
Cta.Cuenta,
Cta.Descripcion,
Cta.EsAcreedora,
SubCta.Cuenta,
SubCta.Descripcion,
SubCta.EsAcreedora,
SubCuenta = cc.CentroCostos,
CentroCostos = cc.Descripcion,
NULL,NULL,NULL,
NULL,NULL,NULL,
NULL,NULL,NULL,
NULL,NULL,NULL
FROM Cta
JOIN Cta Rama  ON Cta.Rama  = Rama.Cuenta
LEFT OUTER JOIN Cta SubCta  ON Cta.Cuenta = SubCta.Rama
LEFT OUTER JOIN CtaSub cs ON Cta.Cuenta = cs.Cuenta
LEFT OUTER JOIN CentroCostos cc ON cs.SubCuenta = cc.CentroCostos
WHERE Cta.Tipo = 'MAYOR'
AND (Cta.Rama = @CtaResultados OR Rama.Rama = @CtaResultados)
AND (Cta.Rama <> @CtaIngresos AND Rama.Rama <> @CtaIngresos)
AND (Cta.Rama <> @CtaCostoDirecto AND Rama.Rama <> @CtaCostoDirecto)
AND (Cta.Rama <> @CtaGastosOperacion AND Rama.Rama <> @CtaGastosOperacion)
AND (Cta.Rama <> @CtaOtrosGastosProductos AND Rama.Rama <> @CtaOtrosGastosProductos)
SELECT @Ingresos = Sum(ISNULL(Cargos, 0.0)-ISNULL(Abonos, 0.0))
FROM Acum
WHERE Empresa = @Empresa
AND Rama = 'CONT'
AND Cuenta = @CtaIngresos
AND ISNULL(SubCuenta, '') >= ISNULL(ISNULL(@CentroCostosD, SubCuenta), '')
AND ISNULL(SubCuenta, '') <= ISNULL(ISNULL(@CentroCostosA, SubCuenta), '')
AND ISNULL(Sucursal, 0) = ISNULL(ISNULL(@Sucursal, Sucursal), 0)
AND Ejercicio = @Ejercicio
AND Periodo BETWEEN @PeriodoD AND @PeriodoA
AND Moneda = @Moneda
SELECT @IngresosAl = Sum(ISNULL(Cargos, 0.0)-ISNULL(Abonos, 0.0))
FROM Acum
WHERE Empresa = @Empresa
AND Rama = 'CONT'
AND Cuenta = @CtaIngresos
AND ISNULL(SubCuenta, '') >= ISNULL(ISNULL(@CentroCostosD, SubCuenta), '')
AND ISNULL(SubCuenta, '') <= ISNULL(ISNULL(@CentroCostosA, SubCuenta), '')
AND ISNULL(Sucursal, 0) = ISNULL(ISNULL(@Sucursal, Sucursal), 0)
AND Moneda = @Moneda
AND Ejercicio = @Ejercicio
AND Periodo = @PeriodoA
UPDATE Resultado1
SET Saldo = (SELECT Sum(ISNULL(a.Cargos, 0.0)-ISNULL(a.Abonos, 0.0))
FROM Acum a
WHERE a.Cuenta = ISNULL(NULLIF(b.SubCta, ''), b.Cuenta)
AND ISNULL(a.SubCuenta, '') = ISNULL(ISNULL(b.SubCuenta, a.SubCuenta), '')
AND a.Empresa = @Empresa
AND a.Rama = 'CONT'
AND ISNULL(a.SubCuenta, '') >= ISNULL(ISNULL(@CentroCostosD, a.SubCuenta), '')
AND ISNULL(a.SubCuenta, '') <= ISNULL(ISNULL(@CentroCostosA, a.SubCuenta), '')
AND ISNULL(a.Sucursal, 0) = ISNULL(ISNULL(@Sucursal, a.Sucursal), 0)
AND a.Moneda = @Moneda
AND a.Ejercicio = @Ejercicio
AND a.Periodo BETWEEN @PeriodoD AND @PeriodoA)
FROM Resultado1 b WHERE Estacion = @Estacion
UPDATE Resultado1
SET Ingresos = @Ingresos,
Porcentaje = (Saldo/(CASE WHEN @Ingresos = 0 THEN 1 ELSE @Ingresos END))*100 WHERE Estacion = @Estacion
UPDATE Resultado1
SET SaldoAl = (SELECT Sum(ISNULL(a.Cargos, 0.0)-ISNULL(a.Abonos, 0.0))
FROM Acum a
WHERE a.Cuenta = ISNULL(NULLIF(b.SubCta, ''), b.Cuenta)
AND ISNULL(a.SubCuenta, '') = ISNULL(ISNULL(b.SubCuenta, a.SubCuenta), '')
AND a.Empresa = @Empresa
AND a.Rama = 'CONT'
AND ISNULL(a.SubCuenta, '') >= ISNULL(ISNULL(@CentroCostosD, a.SubCuenta), '')
AND ISNULL(a.SubCuenta, '') <= ISNULL(ISNULL(@CentroCostosA, a.SubCuenta), '')
AND ISNULL(a.Sucursal, 0) = ISNULL(ISNULL(@Sucursal, a.Sucursal), 0)
AND a.Moneda = @Moneda
AND a.Ejercicio = @Ejercicio
AND a.Periodo = @PeriodoA)
FROM Resultado1 b WHERE Estacion = @Estacion
UPDATE Resultado1
SET IngresosAl = @IngresosAl,
PorcentajeAl = (SaldoAl/(CASE WHEN @IngresosAl = 0 THEN 1 ELSE @IngresosAl END))*100 WHERE Estacion = @Estacion
SELECT @IngresosPE = Sum(ISNULL(y.Debe, 0.0)) - Sum(ISNULL(y.Haber, 0.0))
FROM Cont x
JOIN ContD y ON x.ID = y.ID
WHERE x.Mov = 'Presupuesto'
AND x.Estatus = 'CONCLUIDO'
AND x.Empresa = @Empresa
AND y.Cuenta = @CtaIngresos
AND ISNULL(y.SubCuenta, '') >= ISNULL(ISNULL(@CentroCostosD, y.SubCuenta), '')
AND ISNULL(y.SubCuenta, '') <= ISNULL(ISNULL(@CentroCostosA, y.SubCuenta), '')
AND ISNULL(x.Sucursal, 0) = ISNULL(ISNULL(@Sucursal, x.Sucursal), 0)
AND x.Moneda = @Moneda
AND x.Ejercicio = @Ejercicio
AND x.Periodo BETWEEN @PeriodoD AND @PeriodoA
SELECT @IngresosAlPE = Sum(ISNULL(y.Debe, 0.0)) - Sum(ISNULL(y.Haber, 0.0))
FROM Cont x
JOIN ContD y ON x.ID = y.ID
WHERE x.Mov = 'Presupuesto'
AND x.Estatus = 'CONCLUIDO'
AND x.Empresa = @Empresa
AND y.Cuenta = @CtaIngresos
AND ISNULL(y.SubCuenta, '') >= ISNULL(ISNULL(@CentroCostosD, y.SubCuenta), '')
AND ISNULL(y.SubCuenta, '') <= ISNULL(ISNULL(@CentroCostosA, y.SubCuenta), '')
AND ISNULL(x.Sucursal, 0) = ISNULL(ISNULL(@Sucursal, x.Sucursal), 0)
AND x.Moneda = @Moneda
AND x.Ejercicio = @Ejercicio
AND x.Periodo = @PeriodoA
SELECT y.Cuenta, SubCuenta = ISNULL(y.SubCuenta, ''), SaldoP = Sum(ISNULL(y.Debe, 0.0)) - Sum(ISNULL(y.Haber, 0.0))
INTO #SaldoPEx
FROM Cont x
JOIN ContD y ON x.ID = y.ID
WHERE x.Mov = 'Presupuesto'
AND x.Estatus = 'CONCLUIDO'
AND x.Empresa = @Empresa
AND x.Moneda = @Moneda
AND x.Ejercicio = @Ejercicio
AND x.Periodo BETWEEN @PeriodoD AND @PeriodoA
AND ISNULL(y.SubCuenta, '') >= ISNULL(ISNULL(@CentroCostosD, y.SubCuenta), '')
AND ISNULL(y.SubCuenta, '') <= ISNULL(ISNULL(@CentroCostosA, y.SubCuenta), '')
AND ISNULL(x.Sucursal, 0)    = ISNULL(ISNULL(@Sucursal, x.Sucursal), 0)
GROUP BY y.Cuenta, y.SubCuenta
HAVING Sum(ISNULL(y.Debe, 0.0)) - Sum(ISNULL(y.Haber, 0.0)) <> 0.0
UPDATE Resultado1
SET SaldoPE = a.SaldoP
FROM #SaldoPEx a
JOIN Resultado1 b ON a.Cuenta  = ISNULL(NULLIF(b.SubCta, ''), b.Cuenta) AND ISNULL(a.SubCuenta, '') = ISNULL(ISNULL(b.SubCuenta, a.SubCuenta), '')
WHERE b.Estacion = @Estacion
UPDATE Resultado1
SET IngresosPE = @IngresosPE,
PorcentajePE = (SaldoPE/@IngresosPE)*100 WHERE Estacion = @Estacion
SELECT y.Cuenta, SubCuenta = ISNULL(y.SubCuenta, ''), SaldoAlP = Sum(ISNULL(y.Debe, 0.0)) - Sum(ISNULL(y.Haber, 0.0))
INTO #SaldoAlPEx
FROM Cont x
JOIN ContD y ON x.ID = y.ID
WHERE x.Mov = 'Presupuesto'
AND x.Estatus = 'CONCLUIDO'
AND x.Empresa = @Empresa
AND x.Moneda = @Moneda
AND x.Ejercicio = @Ejercicio
AND x.Periodo = @PeriodoA
AND ISNULL(y.SubCuenta, '') >= ISNULL(ISNULL(@CentroCostosD, y.SubCuenta), '')
AND ISNULL(y.SubCuenta, '') <= ISNULL(ISNULL(@CentroCostosA, y.SubCuenta), '')
AND ISNULL(x.Sucursal, 0)    = ISNULL(ISNULL(@Sucursal, x.Sucursal), 0)
GROUP BY y.Cuenta, y.SubCuenta
HAVING Sum(ISNULL(y.Debe, 0.0)) - Sum(ISNULL(y.Haber, 0.0)) <> 0.0
UPDATE Resultado1
SET SaldoAlPE = a.SaldoAlP
FROM #SaldoAlPEx a
JOIN Resultado1 b ON a.Cuenta  = ISNULL(NULLIF(b.SubCta, ''), b.Cuenta) AND ISNULL(a.SubCuenta, '') = ISNULL(ISNULL(b.SubCuenta, a.SubCuenta), '')
WHERE b.Estacion = @Estacion
UPDATE Resultado1
SET IngresosAlPE = @IngresosAlPE,
PorcentajeAlPE = (SaldoAlPE/@IngresosAlPE)*100 WHERE Estacion = @Estacion
IF @ReExpresar='Si'
UPDATE Resultado1
SET Ingresos=Ingresos/ISNULL(@ReExpresarTipoCambio,1),
SaldoAl=SaldoAl/ISNULL(@ReExpresarTipoCambio,1),
IngresosAl=IngresosAl/ISNULL(@ReExpresarTipoCambio,1),
SaldoPE=SaldoPE/ISNULL(@ReExpresarTipoCambio,1),
IngresosPE=IngresosPE/ISNULL(@ReExpresarTipoCambio,1),
SaldoAlPE=SaldoAlPE/ISNULL(@ReExpresarTipoCambio,1),
IngresosAlPE=IngresosAlPE/ISNULL(@ReExpresarTipoCambio,1)
WHERE Estacion = @Estacion
IF @OrdenCC = 'NO'
BEGIN
IF @ConMovs = 'SI'
SELECT r.*, "Grupo" = CONVERT(varchar(50), null), "SubGrupo" = CONVERT(varchar(50), null), "SubSubGrupo" = CONVERT(varchar(50), NULL)
FROM Resultado1 r
WHERE (ISNULL(r.Saldo, 0.0) <> 0.0 OR ISNULL(r.SaldoAl, 0.0) <> 0.0 OR ISNULL(r.SaldoPE, 0.0) <> 0.0 OR ISNULL(r.SaldoAlPE, 0.0) <> 0.0) AND r.Estacion = @Estacion
ORDER BY r.Orden, r.SubCta, r.SubCuenta, r.ID
ELSE
SELECT r.*, "Grupo" = CONVERT(varchar(50), null), "SubGrupo" = CONVERT(varchar(50), null), "SubSubGrupo" = CONVERT(varchar(50), NULL)
FROM Resultado1 r
WHERE r.Estacion = @Estacion
ORDER BY r.Orden, r.SubCta, r.SubCuenta, r.ID
END ELSE
BEGIN
IF @CCGrupo <> 'NULL'
BEGIN
IF @ConMovs = 'SI'
SELECT r.*, cc.Grupo, cc.SubGrupo, cc.SubSubGrupo
FROM Resultado1 r JOIN CentroCostos cc ON r.SubCuenta = cc.CentroCostos AND cc.Grupo = ISNULL(@CCGrupo, cc.Grupo)
WHERE (ISNULL(r.Saldo, 0.0) <> 0.0 OR ISNULL(r.SaldoAl, 0.0) <> 0.0 OR ISNULL(r.SaldoPE, 0.0) <> 0.0 OR ISNULL(r.SaldoAlPE, 0.0) <> 0.0) AND r.Estacion = @Estacion
ORDER BY r.Orden, r.Rama, r.SubCta, cc.Grupo, cc.SubGrupo, cc.SubSubGrupo, r.SubCuenta, r.ID
ELSE
SELECT r.*, cc.Grupo, cc.SubGrupo, cc.SubSubGrupo
FROM Resultado1 r JOIN CentroCostos cc ON r.SubCuenta = cc.CentroCostos AND cc.Grupo = ISNULL(@CCGrupo, cc.Grupo)
WHERE r.Estacion = @Estacion
ORDER BY r.Orden, r.Rama, r.SubCta, cc.Grupo, cc.SubGrupo, cc.SubSubGrupo, r.SubCuenta, r.ID
END ELSE
BEGIN
IF @ConMovs = 'SI'
SELECT r.*, cc.Grupo, cc.SubGrupo, cc.SubSubGrupo
FROM Resultado1 r LEFT OUTER JOIN CentroCostos cc ON r.SubCuenta = cc.CentroCostos
WHERE (ISNULL(r.Saldo, 0.0) <> 0.0 OR ISNULL(r.SaldoAl, 0.0) <> 0.0  OR ISNULL(r.SaldoPE, 0.0) <> 0.0 OR ISNULL(r.SaldoAlPE, 0.0) <> 0.0) AND r.Estacion = @Estacion
ORDER BY r.Orden, r.Rama, r.SubCta, cc.Grupo, cc.SubGrupo, cc.SubSubGrupo, r.SubCuenta, r.ID
ELSE
SELECT r.*, cc.Grupo, cc.SubGrupo, cc.SubSubGrupo
FROM Resultado1 r LEFT OUTER JOIN CentroCostos cc ON r.SubCuenta = cc.CentroCostos
WHERE r.Estacion = @Estacion
ORDER BY r.Orden, r.Rama, r.SubCta, cc.Grupo, cc.SubGrupo, cc.SubSubGrupo, r.SubCuenta, r.ID
END
END
END

