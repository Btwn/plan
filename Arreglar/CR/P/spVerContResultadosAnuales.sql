SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spVerContResultadosAnuales
@Empresa		char(5)	    = NULL,
@EjercicioD		int,
@EjercicioA		int,
@PeriodoA		int,
@Anual		char(20),
@ConMovs		char(20)    = 'NO',
@CentroCostos	char(20)    = NULL,
@Sucursal		int	    = NULL,
@OrdenCC		char(20)    = 'NO',
@Moneda		char(10)    = NULL,
@CCGrupo		varchar(50) = NULL,
@UEN		int	    = NULL,
@Proyecto		varchar(50) = NULL,
@CentroCostos2	varchar(50) = NULL,
@CentroCostos3	varchar(50) = NULL,
@ReExpresar     char(20) = 'NO', 
@ReExpresarTipoCambio float = NULL 

AS BEGIN
DECLARE
@ID				int,
@CtaResultados		char(20),
@CtaIngresos		char(20),
@CtaCostoDirecto		char(20),
@CtaGastosOperacion		char(20),
@CtaOtrosGastosProductos	char(20),
@CtaImpuestos		char(20),
@Saldo			money,
@Ingresos1			money,
@Ingresos2			money,
@Ingresos3			money,
@Ingresos4			money,
@Ingresos5			money,
@Numero			int,
@PeriodoX			int,
@AnioInicial		int,
@AnioFinal			int,
@EjercicioX			int,
@Cuantos			int
SELECT @Moneda        = NULLIF(NULLIF(RTRIM(@Moneda), ''), '0'),
@CCGrupo       = NULLIF(NULLIF(RTRIM(@CCGrupo), ''), '0')
IF @Moneda IS NULL SELECT @Moneda = ContMoneda FROM EmpresaCfg WHERE Empresa = @Empresa
CREATE TABLE #ResultadoA (
Orden		int		NOT NULL,
ID			int		IDENTITY(1,1) NOT NULL,
Clase		char(30)	COLLATE Database_Default NULL,
SubClase		char(20)	COLLATE Database_Default NULL,
Rama		char(20)	COLLATE Database_Default NULL,
RamaDesc		varchar(100)	COLLATE Database_Default NULL,
RamaEsAcreedora	bit		NOT NULL DEFAULT 0,
Cuenta		char(20)	COLLATE Database_Default NULL,
Descripcion	varchar(100)	COLLATE Database_Default NULL,
EsAcreedora	bit		NOT NULL DEFAULT 0,
SubCuenta		varchar(50)	COLLATE Database_Default NULL,
CentroCostos	varchar(100)	COLLATE Database_Default NULL,
Ejercicio1		int		NULL,
Saldo1		money		NULL,
Ingresos1		money		NULL,
Porcentaje1	float		NULL,
Ejercicio2		int		NULL,
Saldo2		money		NULL,
Ingresos2		money		NULL,
Porcentaje2	float		NULL,
Ejercicio3		int		NULL,
Saldo3		money		NULL,
Ingresos3		money		NULL,
Porcentaje3	float		NULL,
Ejercicio4		int		NULL,
Saldo4		money		NULL,
Ingresos4		money		NULL,
Porcentaje4	float		NULL,
Ejercicio5		int		NULL,
Saldo5		money		NULL,
Ingresos5		money		NULL,
Porcentaje5	float		NULL,
CONSTRAINT priTempResultado PRIMARY KEY CLUSTERED (Orden, ID)
)
SELECT @ConMovs = UPPER(@ConMovs), @CentroCostos = NULLIF(RTRIM(@CentroCostos), '')
IF UPPER(@CentroCostos) IN ('0', 'NULL', '(TODOS)') SELECT @CentroCostos = NULL
IF @Sucursal<0 SELECT @Sucursal = NULL
IF @UEN = 0 SELECT @UEN = NULL
IF UPPER(@Proyecto)      IN ('0', 'NULL', '(TODOS)','') SELECT @Proyecto = NULL
IF UPPER(@CentroCostos2) IN ('0', 'NULL', '(TODOS)','') SELECT @CentroCostos2 = NULL
IF UPPER(@CentroCostos3) IN ('0', 'NULL', '(TODOS)','') SELECT @CentroCostos3 = NULL
SELECT DISTINCT
@CtaResultados   		= CtaResultados,
@CtaIngresos	   		= CtaIngresos,
@CtaCostoDirecto 		= CtaCostoDirecto,
@CtaGastosOperacion		= CtaGastosOperacion,
@CtaOtrosGastosProductos	= CtaOtrosGastosProductos,
@CtaImpuestos			= CtaImpuestos
FROM EmpresaCfg
WHERE Empresa = @Empresa
INSERT #ResultadoA
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
NULL,NULL,NULL,NULL,
NULL,NULL,NULL,NULL,
NULL,NULL,NULL,NULL,
NULL,NULL,NULL,NULL,
NULL,NULL,NULL,NULL
FROM Cta
JOIN Cta Rama ON Cta.Rama = Rama.Cuenta
JOIN ContSubSaldo cc ON Cta.cuenta = cc.Cuenta
WHERE UPPER(Cta.Tipo) = 'MAYOR'
AND (Cta.Rama = @CtaIngresos OR Rama.Rama = @CtaIngresos)
AND cc.Moneda = @Moneda
AND cc.Empresa = @Empresa
INSERT #ResultadoA
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
NULL,NULL,NULL,NULL,
NULL,NULL,NULL,NULL,
NULL,NULL,NULL,NULL,
NULL,NULL,NULL,NULL,
NULL,NULL,NULL,NULL
FROM Cta
JOIN Cta Rama ON Cta.Rama = Rama.Cuenta
JOIN ContSubSaldo cc ON Cta.Cuenta = cc.Cuenta
WHERE UPPER(Cta.Tipo) = 'MAYOR'
AND (Cta.Rama = @CtaCostoDirecto OR Rama.Rama = @CtaCostoDirecto)
AND cc.Moneda = @Moneda
AND cc.Empresa = @Empresa
INSERT #ResultadoA
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
NULL,NULL,NULL,NULL,
NULL,NULL,NULL,NULL,
NULL,NULL,NULL,NULL,
NULL,NULL,NULL,NULL,
NULL,NULL,NULL,NULL
FROM Cta
JOIN Cta Rama ON Cta.Rama = Rama.Cuenta
JOIN ContSubSaldo cc ON Cta.cuenta = cc.Cuenta
WHERE UPPER(Cta.Tipo) = 'MAYOR'
AND (Cta.Rama = @CtaGastosOperacion OR Rama.Rama = @CtaGastosOperacion)
AND cc.Moneda = @Moneda
AND cc.Empresa = @Empresa
INSERT #ResultadoA
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
NULL,NULL,NULL,NULL,
NULL,NULL,NULL,NULL,
NULL,NULL,NULL,NULL,
NULL,NULL,NULL,NULL,
NULL,NULL,NULL,NULL
FROM Cta
JOIN Cta Rama ON Cta.Rama = Rama.Cuenta
JOIN ContSubSaldo cc ON Cta.cuenta = cc.Cuenta
WHERE UPPER(Cta.Tipo) = 'MAYOR'
AND (Cta.Rama = @CtaOtrosGastosProductos OR Rama.Rama = @CtaOtrosGastosProductos)
AND cc.Moneda = @Moneda
AND cc.Empresa = @Empresa
INSERT #ResultadoA
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
NULL,NULL,NULL,NULL,
NULL,NULL,NULL,NULL,
NULL,NULL,NULL,NULL,
NULL,NULL,NULL,NULL,
NULL,NULL,NULL,NULL
FROM Cta
JOIN Cta Rama ON Cta.Rama = Rama.Cuenta
JOIN ContSubSaldo cc ON Cta.cuenta = cc.Cuenta
WHERE UPPER(Cta.Tipo) = 'MAYOR'
AND (Cta.Rama = @CtaResultados OR Rama.Rama = @CtaResultados)
AND (Cta.Rama <> @CtaIngresos AND Rama.Rama <> @CtaIngresos)
AND (Cta.Rama <> @CtaCostoDirecto AND Rama.Rama <> @CtaCostoDirecto)
AND (Cta.Rama <> @CtaGastosOperacion AND Rama.Rama <> @CtaGastosOperacion)
AND (Cta.Rama <> @CtaOtrosGastosProductos AND Rama.Rama <> @CtaOtrosGastosProductos)
AND cc.Moneda = @Moneda
AND cc.Empresa = @Empresa
CREATE TABLE #Ejercicios
(
Numero		int		NULL,
Ejercicio		int		NULL)
SELECT @Numero = 1, @PeriodoX = MONTH(GETDATE())
DECLARE cr_Anio CURSOR FOR
SELECT @EjercicioD, @EjercicioA
OPEN cr_Anio
FETCH NEXT FROM cr_Anio INTO @AnioInicial, @AnioFinal
WHILE @@FETCH_STATUS <> -1
BEGIN
IF @@FETCH_STATUS <> -2
BEGIN
WHILE @AnioInicial <= @AnioFinal
BEGIN
INSERT #Ejercicios (Numero, Ejercicio)
VALUES (@Numero, @AnioInicial)
SELECT @AnioInicial = @AnioInicial + 1, @Numero = @Numero + 1
END
END
FETCH NEXT FROM cr_Anio INTO @AnioInicial, @AnioFinal
END
CLOSE cr_Anio
DEALLOCATE cr_Anio
SELECT @Cuantos = COUNT(Ejercicio) FROM #Ejercicios
UPDATE #ResultadoA SET Ejercicio1  = (SELECT Ejercicio FROM #Ejercicios WHERE Numero = 1),  Ejercicio2  = (SELECT Ejercicio FROM #Ejercicios WHERE Numero = 2),
Ejercicio3  = (SELECT Ejercicio FROM #Ejercicios WHERE Numero = 3),  Ejercicio4  = (SELECT Ejercicio FROM #Ejercicios WHERE Numero = 4),
Ejercicio5  = (SELECT Ejercicio FROM #Ejercicios WHERE Numero = 5)
IF @Anual = 'Del Ejercicio'
BEGIN
DECLARE Cursor_Ingresos CURSOR FOR
SELECT Ejercicio
FROM #Ejercicios
OPEN Cursor_Ingresos
FETCH NEXT FROM Cursor_Ingresos INTO @EjercicioX
WHILE @@FETCH_STATUS <> -1
BEGIN
IF @@FETCH_STATUS <> -2
BEGIN
UPDATE #ResultadoA SET Ingresos1  = (SELECT Sum(ISNULL(a.Cargos, 0.0)-ISNULL(a.Abonos, 0.0)) FROM Acum a WHERE a.Rama = 'CONT' AND a.Cuenta = @CtaIngresos AND ISNULL(a.SubCuenta, '') = ISNULL(ISNULL(@CentroCostos, a.SubCuenta), '') AND ISNULL(a.Sucursal, 0) = ISNULL(ISNULL(@Sucursal, a.Sucursal), 0) AND ISNULL(a.UEN, 0) = ISNULL(ISNULL(@UEN, a.UEN), 0) AND ISNULL(a.Proyecto, '')  = ISNULL(ISNULL(@Proyecto, a.Proyecto), '') AND ISNULL(a.SubCuenta2, '')= ISNULL(ISNULL(@CentroCostos2, a.SubCuenta2), '') AND ISNULL(a.SubCuenta3, '')= ISNULL(ISNULL(@CentroCostos3, a.SubCuenta3), '') AND a.Ejercicio = b.Ejercicio1 AND a.Periodo <= @PeriodoX AND a.Moneda = @Moneda AND a.Empresa = @Empresa) FROM #ResultadoA b WHERE b.Ejercicio1 = @EjercicioX
UPDATE #ResultadoA SET Ingresos2  = (SELECT Sum(ISNULL(a.Cargos, 0.0)-ISNULL(a.Abonos, 0.0)) FROM Acum a WHERE a.Rama = 'CONT' AND a.Cuenta = @CtaIngresos AND ISNULL(a.SubCuenta, '') = ISNULL(ISNULL(@CentroCostos, a.SubCuenta), '') AND ISNULL(a.Sucursal, 0) = ISNULL(ISNULL(@Sucursal, a.Sucursal), 0) AND ISNULL(a.UEN, 0) = ISNULL(ISNULL(@UEN, a.UEN), 0) AND ISNULL(a.Proyecto, '')  = ISNULL(ISNULL(@Proyecto, a.Proyecto), '') AND ISNULL(a.SubCuenta2, '')= ISNULL(ISNULL(@CentroCostos2, a.SubCuenta2), '') AND ISNULL(a.SubCuenta3, '')= ISNULL(ISNULL(@CentroCostos3, a.SubCuenta3), '') AND a.Ejercicio = b.Ejercicio2 AND a.Periodo <= @PeriodoX AND a.Moneda = @Moneda AND a.Empresa = @Empresa) FROM #ResultadoA b WHERE b.Ejercicio2 = @EjercicioX
UPDATE #ResultadoA SET Ingresos3  = (SELECT Sum(ISNULL(a.Cargos, 0.0)-ISNULL(a.Abonos, 0.0)) FROM Acum a WHERE a.Rama = 'CONT' AND a.Cuenta = @CtaIngresos AND ISNULL(a.SubCuenta, '') = ISNULL(ISNULL(@CentroCostos, a.SubCuenta), '') AND ISNULL(a.Sucursal, 0) = ISNULL(ISNULL(@Sucursal, a.Sucursal), 0) AND ISNULL(a.UEN, 0) = ISNULL(ISNULL(@UEN, a.UEN), 0) AND ISNULL(a.Proyecto, '')  = ISNULL(ISNULL(@Proyecto, a.Proyecto), '') AND ISNULL(a.SubCuenta2, '')= ISNULL(ISNULL(@CentroCostos2, a.SubCuenta2), '') AND ISNULL(a.SubCuenta3, '')= ISNULL(ISNULL(@CentroCostos3, a.SubCuenta3), '') AND a.Ejercicio = b.Ejercicio3 AND a.Periodo <= @PeriodoX AND a.Moneda = @Moneda AND a.Empresa = @Empresa) FROM #ResultadoA b WHERE b.Ejercicio3 = @EjercicioX
UPDATE #ResultadoA SET Ingresos4  = (SELECT Sum(ISNULL(a.Cargos, 0.0)-ISNULL(a.Abonos, 0.0)) FROM Acum a WHERE a.Rama = 'CONT' AND a.Cuenta = @CtaIngresos AND ISNULL(a.SubCuenta, '') = ISNULL(ISNULL(@CentroCostos, a.SubCuenta), '') AND ISNULL(a.Sucursal, 0) = ISNULL(ISNULL(@Sucursal, a.Sucursal), 0) AND ISNULL(a.UEN, 0) = ISNULL(ISNULL(@UEN, a.UEN), 0) AND ISNULL(a.Proyecto, '')  = ISNULL(ISNULL(@Proyecto, a.Proyecto), '') AND ISNULL(a.SubCuenta2, '')= ISNULL(ISNULL(@CentroCostos2, a.SubCuenta2), '') AND ISNULL(a.SubCuenta3, '')= ISNULL(ISNULL(@CentroCostos3, a.SubCuenta3), '') AND a.Ejercicio = b.Ejercicio4 AND a.Periodo <= @PeriodoX AND a.Moneda = @Moneda AND a.Empresa = @Empresa) FROM #ResultadoA b WHERE b.Ejercicio4 = @EjercicioX
UPDATE #ResultadoA SET Ingresos5  = (SELECT Sum(ISNULL(a.Cargos, 0.0)-ISNULL(a.Abonos, 0.0)) FROM Acum a WHERE a.Rama = 'CONT' AND a.Cuenta = @CtaIngresos AND ISNULL(a.SubCuenta, '') = ISNULL(ISNULL(@CentroCostos, a.SubCuenta), '') AND ISNULL(a.Sucursal, 0) = ISNULL(ISNULL(@Sucursal, a.Sucursal), 0) AND ISNULL(a.UEN, 0) = ISNULL(ISNULL(@UEN, a.UEN), 0) AND ISNULL(a.Proyecto, '')  = ISNULL(ISNULL(@Proyecto, a.Proyecto), '') AND ISNULL(a.SubCuenta2, '')= ISNULL(ISNULL(@CentroCostos2, a.SubCuenta2), '') AND ISNULL(a.SubCuenta3, '')= ISNULL(ISNULL(@CentroCostos3, a.SubCuenta3), '') AND a.Ejercicio = b.Ejercicio5 AND a.Periodo <= @PeriodoX AND a.Moneda = @Moneda AND a.Empresa = @Empresa) FROM #ResultadoA b WHERE b.Ejercicio5 = @EjercicioX
UPDATE #ResultadoA SET Saldo1 = (SELECT Sum(ISNULL(a.Cargos, 0.0)-ISNULL(a.Abonos, 0.0)) FROM Acum a WHERE a.Rama = 'CONT' AND a.Cuenta = b.Cuenta AND a.Ejercicio = b.Ejercicio1 AND ISNULL(a.SubCuenta, '') = ISNULL(b.SubCuenta, '') AND ISNULL(a.SubCuenta, '') = ISNULL(ISNULL(@CentroCostos, a.SubCuenta), '') AND ISNULL(a.Sucursal, 0) = ISNULL(ISNULL(@Sucursal, a.Sucursal), 0) AND ISNULL(a.UEN, 0) = ISNULL(ISNULL(@UEN, a.UEN), 0) AND ISNULL(a.Proyecto, '')  = ISNULL(ISNULL(@Proyecto, a.Proyecto), '') AND ISNULL(a.SubCuenta2, '')= ISNULL(ISNULL(@CentroCostos2, a.SubCuenta2), '') AND ISNULL(a.SubCuenta3, '')= ISNULL(ISNULL(@CentroCostos3, a.SubCuenta3), '') AND a.Moneda = @Moneda AND a.Periodo <= @PeriodoX AND a.Empresa = @Empresa) FROM #ResultadoA b WHERE b.Ejercicio1 = @EjercicioX
UPDATE #ResultadoA SET Saldo2 = (SELECT Sum(ISNULL(a.Cargos, 0.0)-ISNULL(a.Abonos, 0.0)) FROM Acum a WHERE a.Rama = 'CONT' AND a.Cuenta = b.Cuenta AND a.Ejercicio = b.Ejercicio2 AND ISNULL(a.SubCuenta, '') = ISNULL(b.SubCuenta, '') AND ISNULL(a.SubCuenta, '') = ISNULL(ISNULL(@CentroCostos, a.SubCuenta), '') AND ISNULL(a.Sucursal, 0) = ISNULL(ISNULL(@Sucursal, a.Sucursal), 0) AND ISNULL(a.UEN, 0) = ISNULL(ISNULL(@UEN, a.UEN), 0) AND ISNULL(a.Proyecto, '')  = ISNULL(ISNULL(@Proyecto, a.Proyecto), '') AND ISNULL(a.SubCuenta2, '')= ISNULL(ISNULL(@CentroCostos2, a.SubCuenta2), '') AND ISNULL(a.SubCuenta3, '')= ISNULL(ISNULL(@CentroCostos3, a.SubCuenta3), '') AND a.Moneda = @Moneda AND a.Periodo <= @PeriodoX AND a.Empresa = @Empresa) FROM #ResultadoA b WHERE b.Ejercicio2 = @EjercicioX
UPDATE #ResultadoA SET Saldo3 = (SELECT Sum(ISNULL(a.Cargos, 0.0)-ISNULL(a.Abonos, 0.0)) FROM Acum a WHERE a.Rama = 'CONT' AND a.Cuenta = b.Cuenta AND a.Ejercicio = b.Ejercicio3 AND ISNULL(a.SubCuenta, '') = ISNULL(b.SubCuenta, '') AND ISNULL(a.SubCuenta, '') = ISNULL(ISNULL(@CentroCostos, a.SubCuenta), '') AND ISNULL(a.Sucursal, 0) = ISNULL(ISNULL(@Sucursal, a.Sucursal), 0) AND ISNULL(a.UEN, 0) = ISNULL(ISNULL(@UEN, a.UEN), 0) AND ISNULL(a.Proyecto, '')  = ISNULL(ISNULL(@Proyecto, a.Proyecto), '') AND ISNULL(a.SubCuenta2, '')= ISNULL(ISNULL(@CentroCostos2, a.SubCuenta2), '') AND ISNULL(a.SubCuenta3, '')= ISNULL(ISNULL(@CentroCostos3, a.SubCuenta3), '') AND a.Moneda = @Moneda AND a.Periodo <= @PeriodoX AND a.Empresa = @Empresa) FROM #ResultadoA b WHERE b.Ejercicio3 = @EjercicioX
UPDATE #ResultadoA SET Saldo4 = (SELECT Sum(ISNULL(a.Cargos, 0.0)-ISNULL(a.Abonos, 0.0)) FROM Acum a WHERE a.Rama = 'CONT' AND a.Cuenta = b.Cuenta AND a.Ejercicio = b.Ejercicio4 AND ISNULL(a.SubCuenta, '') = ISNULL(b.SubCuenta, '') AND ISNULL(a.SubCuenta, '') = ISNULL(ISNULL(@CentroCostos, a.SubCuenta), '') AND ISNULL(a.Sucursal, 0) = ISNULL(ISNULL(@Sucursal, a.Sucursal), 0) AND ISNULL(a.UEN, 0) = ISNULL(ISNULL(@UEN, a.UEN), 0) AND ISNULL(a.Proyecto, '')  = ISNULL(ISNULL(@Proyecto, a.Proyecto), '') AND ISNULL(a.SubCuenta2, '')= ISNULL(ISNULL(@CentroCostos2, a.SubCuenta2), '') AND ISNULL(a.SubCuenta3, '')= ISNULL(ISNULL(@CentroCostos3, a.SubCuenta3), '') AND a.Moneda = @Moneda AND a.Periodo <= @PeriodoX AND a.Empresa = @Empresa) FROM #ResultadoA b WHERE b.Ejercicio4 = @EjercicioX
UPDATE #ResultadoA SET Saldo5 = (SELECT Sum(ISNULL(a.Cargos, 0.0)-ISNULL(a.Abonos, 0.0)) FROM Acum a WHERE a.Rama = 'CONT' AND a.Cuenta = b.Cuenta AND a.Ejercicio = b.Ejercicio5 AND ISNULL(a.SubCuenta, '') = ISNULL(b.SubCuenta, '') AND ISNULL(a.SubCuenta, '') = ISNULL(ISNULL(@CentroCostos, a.SubCuenta), '') AND ISNULL(a.Sucursal, 0) = ISNULL(ISNULL(@Sucursal, a.Sucursal), 0) AND ISNULL(a.UEN, 0) = ISNULL(ISNULL(@UEN, a.UEN), 0) AND ISNULL(a.Proyecto, '')  = ISNULL(ISNULL(@Proyecto, a.Proyecto), '') AND ISNULL(a.SubCuenta2, '')= ISNULL(ISNULL(@CentroCostos2, a.SubCuenta2), '') AND ISNULL(a.SubCuenta3, '')= ISNULL(ISNULL(@CentroCostos3, a.SubCuenta3), '') AND a.Moneda = @Moneda AND a.Periodo <= @PeriodoX AND a.Empresa = @Empresa) FROM #ResultadoA b WHERE b.Ejercicio5 = @EjercicioX
UPDATE #ResultadoA SET Porcentaje1 = (Saldo1/dbo.fnEvitarDivisionCero(Ingresos1))*100 WHERE Ejercicio1 = @EjercicioX
UPDATE #ResultadoA SET Porcentaje2 = (Saldo2/dbo.fnEvitarDivisionCero(Ingresos2))*100 WHERE Ejercicio2 = @EjercicioX
UPDATE #ResultadoA SET Porcentaje3 = (Saldo3/dbo.fnEvitarDivisionCero(Ingresos3))*100 WHERE Ejercicio3 = @EjercicioX
UPDATE #ResultadoA SET Porcentaje4 = (Saldo4/dbo.fnEvitarDivisionCero(Ingresos4))*100 WHERE Ejercicio4 = @EjercicioX
UPDATE #ResultadoA SET Porcentaje5 = (Saldo5/dbo.fnEvitarDivisionCero(Ingresos5))*100 WHERE Ejercicio5 = @EjercicioX
END
FETCH NEXT FROM Cursor_Ingresos INTO @EjercicioX
END
CLOSE Cursor_Ingresos
DEALLOCATE Cursor_Ingresos
END
IF @Anual = 'Acumulado a'
BEGIN
DECLARE Cursor_Ingresos CURSOR FOR
SELECT Ejercicio
FROM #Ejercicios
OPEN Cursor_Ingresos
FETCH NEXT FROM Cursor_Ingresos INTO @EjercicioX
WHILE @@FETCH_STATUS <> -1
BEGIN
IF @@FETCH_STATUS <> -2
BEGIN
UPDATE #ResultadoA SET Ingresos1  = (SELECT Sum(ISNULL(a.Cargos, 0.0)-ISNULL(a.Abonos, 0.0)) FROM Acum a WHERE a.Rama = 'CONT' AND a.Cuenta = @CtaIngresos AND ISNULL(a.SubCuenta, '') = ISNULL(ISNULL(@CentroCostos, a.SubCuenta), '') AND ISNULL(a.Sucursal, 0) = ISNULL(ISNULL(@Sucursal, a.Sucursal), 0) AND ISNULL(a.UEN, 0) = ISNULL(ISNULL(@UEN, a.UEN), 0) AND ISNULL(a.Proyecto, '')  = ISNULL(ISNULL(@Proyecto, a.Proyecto), '') AND ISNULL(a.SubCuenta2, '')= ISNULL(ISNULL(@CentroCostos2, a.SubCuenta2), '') AND ISNULL(a.SubCuenta3, '')= ISNULL(ISNULL(@CentroCostos3, a.SubCuenta3), '') AND a.Ejercicio = b.Ejercicio1 AND a.Periodo <= @PeriodoA AND a.Moneda = @Moneda AND a.Empresa = @Empresa) FROM #ResultadoA b WHERE b.Ejercicio1 = @EjercicioX
UPDATE #ResultadoA SET Ingresos2  = (SELECT Sum(ISNULL(a.Cargos, 0.0)-ISNULL(a.Abonos, 0.0)) FROM Acum a WHERE a.Rama = 'CONT' AND a.Cuenta = @CtaIngresos AND ISNULL(a.SubCuenta, '') = ISNULL(ISNULL(@CentroCostos, a.SubCuenta), '') AND ISNULL(a.Sucursal, 0) = ISNULL(ISNULL(@Sucursal, a.Sucursal), 0) AND ISNULL(a.UEN, 0) = ISNULL(ISNULL(@UEN, a.UEN), 0) AND ISNULL(a.Proyecto, '')  = ISNULL(ISNULL(@Proyecto, a.Proyecto), '') AND ISNULL(a.SubCuenta2, '')= ISNULL(ISNULL(@CentroCostos2, a.SubCuenta2), '') AND ISNULL(a.SubCuenta3, '')= ISNULL(ISNULL(@CentroCostos3, a.SubCuenta3), '') AND a.Ejercicio = b.Ejercicio2 AND a.Periodo <= @PeriodoA AND a.Moneda = @Moneda AND a.Empresa = @Empresa) FROM #ResultadoA b WHERE b.Ejercicio2 = @EjercicioX
UPDATE #ResultadoA SET Ingresos3  = (SELECT Sum(ISNULL(a.Cargos, 0.0)-ISNULL(a.Abonos, 0.0)) FROM Acum a WHERE a.Rama = 'CONT' AND a.Cuenta = @CtaIngresos AND ISNULL(a.SubCuenta, '') = ISNULL(ISNULL(@CentroCostos, a.SubCuenta), '') AND ISNULL(a.Sucursal, 0) = ISNULL(ISNULL(@Sucursal, a.Sucursal), 0) AND ISNULL(a.UEN, 0) = ISNULL(ISNULL(@UEN, a.UEN), 0) AND ISNULL(a.Proyecto, '')  = ISNULL(ISNULL(@Proyecto, a.Proyecto), '') AND ISNULL(a.SubCuenta2, '')= ISNULL(ISNULL(@CentroCostos2, a.SubCuenta2), '') AND ISNULL(a.SubCuenta3, '')= ISNULL(ISNULL(@CentroCostos3, a.SubCuenta3), '') AND a.Ejercicio = b.Ejercicio3 AND a.Periodo <= @PeriodoA AND a.Moneda = @Moneda AND a.Empresa = @Empresa) FROM #ResultadoA b WHERE b.Ejercicio3 = @EjercicioX
UPDATE #ResultadoA SET Ingresos4  = (SELECT Sum(ISNULL(a.Cargos, 0.0)-ISNULL(a.Abonos, 0.0)) FROM Acum a WHERE a.Rama = 'CONT' AND a.Cuenta = @CtaIngresos AND ISNULL(a.SubCuenta, '') = ISNULL(ISNULL(@CentroCostos, a.SubCuenta), '') AND ISNULL(a.Sucursal, 0) = ISNULL(ISNULL(@Sucursal, a.Sucursal), 0) AND ISNULL(a.UEN, 0) = ISNULL(ISNULL(@UEN, a.UEN), 0) AND ISNULL(a.Proyecto, '')  = ISNULL(ISNULL(@Proyecto, a.Proyecto), '') AND ISNULL(a.SubCuenta2, '')= ISNULL(ISNULL(@CentroCostos2, a.SubCuenta2), '') AND ISNULL(a.SubCuenta3, '')= ISNULL(ISNULL(@CentroCostos3, a.SubCuenta3), '') AND a.Ejercicio = b.Ejercicio4 AND a.Periodo <= @PeriodoA AND a.Moneda = @Moneda AND a.Empresa = @Empresa) FROM #ResultadoA b WHERE b.Ejercicio4 = @EjercicioX
UPDATE #ResultadoA SET Ingresos5  = (SELECT Sum(ISNULL(a.Cargos, 0.0)-ISNULL(a.Abonos, 0.0)) FROM Acum a WHERE a.Rama = 'CONT' AND a.Cuenta = @CtaIngresos AND ISNULL(a.SubCuenta, '') = ISNULL(ISNULL(@CentroCostos, a.SubCuenta), '') AND ISNULL(a.Sucursal, 0) = ISNULL(ISNULL(@Sucursal, a.Sucursal), 0) AND ISNULL(a.UEN, 0) = ISNULL(ISNULL(@UEN, a.UEN), 0) AND ISNULL(a.Proyecto, '')  = ISNULL(ISNULL(@Proyecto, a.Proyecto), '') AND ISNULL(a.SubCuenta2, '')= ISNULL(ISNULL(@CentroCostos2, a.SubCuenta2), '') AND ISNULL(a.SubCuenta3, '')= ISNULL(ISNULL(@CentroCostos3, a.SubCuenta3), '') AND a.Ejercicio = b.Ejercicio5 AND a.Periodo <= @PeriodoA AND a.Moneda = @Moneda AND a.Empresa = @Empresa) FROM #ResultadoA b WHERE b.Ejercicio5 = @EjercicioX
UPDATE #ResultadoA SET Saldo1 = (SELECT Sum(ISNULL(a.Cargos, 0.0)-ISNULL(a.Abonos, 0.0)) FROM Acum a WHERE a.Rama = 'CONT' AND a.Cuenta = b.Cuenta AND a.Ejercicio = b.Ejercicio1 AND ISNULL(a.SubCuenta, '') = ISNULL(b.SubCuenta, '') AND ISNULL(a.SubCuenta, '') = ISNULL(ISNULL(@CentroCostos, a.SubCuenta), '') AND ISNULL(a.Sucursal, 0) = ISNULL(ISNULL(@Sucursal, a.Sucursal), 0) AND ISNULL(a.UEN, 0) = ISNULL(ISNULL(@UEN, a.UEN), 0) AND ISNULL(a.Proyecto, '')  = ISNULL(ISNULL(@Proyecto, a.Proyecto), '') AND ISNULL(a.SubCuenta2, '')= ISNULL(ISNULL(@CentroCostos2, a.SubCuenta2), '') AND ISNULL(a.SubCuenta3, '')= ISNULL(ISNULL(@CentroCostos3, a.SubCuenta3), '') AND a.Moneda = @Moneda AND a.Periodo <= @PeriodoA AND a.Empresa = @Empresa) FROM #ResultadoA b WHERE b.Ejercicio1 = @EjercicioX
UPDATE #ResultadoA SET Saldo2 = (SELECT Sum(ISNULL(a.Cargos, 0.0)-ISNULL(a.Abonos, 0.0)) FROM Acum a WHERE a.Rama = 'CONT' AND a.Cuenta = b.Cuenta AND a.Ejercicio = b.Ejercicio2 AND ISNULL(a.SubCuenta, '') = ISNULL(b.SubCuenta, '') AND ISNULL(a.SubCuenta, '') = ISNULL(ISNULL(@CentroCostos, a.SubCuenta), '') AND ISNULL(a.Sucursal, 0) = ISNULL(ISNULL(@Sucursal, a.Sucursal), 0) AND ISNULL(a.UEN, 0) = ISNULL(ISNULL(@UEN, a.UEN), 0) AND ISNULL(a.Proyecto, '')  = ISNULL(ISNULL(@Proyecto, a.Proyecto), '') AND ISNULL(a.SubCuenta2, '')= ISNULL(ISNULL(@CentroCostos2, a.SubCuenta2), '') AND ISNULL(a.SubCuenta3, '')= ISNULL(ISNULL(@CentroCostos3, a.SubCuenta3), '') AND a.Moneda = @Moneda AND a.Periodo <= @PeriodoA AND a.Empresa = @Empresa) FROM #ResultadoA b WHERE b.Ejercicio2 = @EjercicioX
UPDATE #ResultadoA SET Saldo3 = (SELECT Sum(ISNULL(a.Cargos, 0.0)-ISNULL(a.Abonos, 0.0)) FROM Acum a WHERE a.Rama = 'CONT' AND a.Cuenta = b.Cuenta AND a.Ejercicio = b.Ejercicio3 AND ISNULL(a.SubCuenta, '') = ISNULL(b.SubCuenta, '') AND ISNULL(a.SubCuenta, '') = ISNULL(ISNULL(@CentroCostos, a.SubCuenta), '') AND ISNULL(a.Sucursal, 0) = ISNULL(ISNULL(@Sucursal, a.Sucursal), 0) AND ISNULL(a.UEN, 0) = ISNULL(ISNULL(@UEN, a.UEN), 0) AND ISNULL(a.Proyecto, '')  = ISNULL(ISNULL(@Proyecto, a.Proyecto), '') AND ISNULL(a.SubCuenta2, '')= ISNULL(ISNULL(@CentroCostos2, a.SubCuenta2), '') AND ISNULL(a.SubCuenta3, '')= ISNULL(ISNULL(@CentroCostos3, a.SubCuenta3), '') AND a.Moneda = @Moneda AND a.Periodo <= @PeriodoA AND a.Empresa = @Empresa) FROM #ResultadoA b WHERE b.Ejercicio3 = @EjercicioX
UPDATE #ResultadoA SET Saldo4 = (SELECT Sum(ISNULL(a.Cargos, 0.0)-ISNULL(a.Abonos, 0.0)) FROM Acum a WHERE a.Rama = 'CONT' AND a.Cuenta = b.Cuenta AND a.Ejercicio = b.Ejercicio4 AND ISNULL(a.SubCuenta, '') = ISNULL(b.SubCuenta, '') AND ISNULL(a.SubCuenta, '') = ISNULL(ISNULL(@CentroCostos, a.SubCuenta), '') AND ISNULL(a.Sucursal, 0) = ISNULL(ISNULL(@Sucursal, a.Sucursal), 0) AND ISNULL(a.UEN, 0) = ISNULL(ISNULL(@UEN, a.UEN), 0) AND ISNULL(a.Proyecto, '')  = ISNULL(ISNULL(@Proyecto, a.Proyecto), '') AND ISNULL(a.SubCuenta2, '')= ISNULL(ISNULL(@CentroCostos2, a.SubCuenta2), '') AND ISNULL(a.SubCuenta3, '')= ISNULL(ISNULL(@CentroCostos3, a.SubCuenta3), '') AND a.Moneda = @Moneda AND a.Periodo <= @PeriodoA AND a.Empresa = @Empresa) FROM #ResultadoA b WHERE b.Ejercicio4 = @EjercicioX
UPDATE #ResultadoA SET Saldo5 = (SELECT Sum(ISNULL(a.Cargos, 0.0)-ISNULL(a.Abonos, 0.0)) FROM Acum a WHERE a.Rama = 'CONT' AND a.Cuenta = b.Cuenta AND a.Ejercicio = b.Ejercicio5 AND ISNULL(a.SubCuenta, '') = ISNULL(b.SubCuenta, '') AND ISNULL(a.SubCuenta, '') = ISNULL(ISNULL(@CentroCostos, a.SubCuenta), '') AND ISNULL(a.Sucursal, 0) = ISNULL(ISNULL(@Sucursal, a.Sucursal), 0) AND ISNULL(a.UEN, 0) = ISNULL(ISNULL(@UEN, a.UEN), 0) AND ISNULL(a.Proyecto, '')  = ISNULL(ISNULL(@Proyecto, a.Proyecto), '') AND ISNULL(a.SubCuenta2, '')= ISNULL(ISNULL(@CentroCostos2, a.SubCuenta2), '') AND ISNULL(a.SubCuenta3, '')= ISNULL(ISNULL(@CentroCostos3, a.SubCuenta3), '') AND a.Moneda = @Moneda AND a.Periodo <= @PeriodoA AND a.Empresa = @Empresa) FROM #ResultadoA b WHERE b.Ejercicio5 = @EjercicioX
UPDATE #ResultadoA SET Porcentaje1 = (Saldo1/dbo.fnEvitarDivisionCero(Ingresos1))*100 WHERE Ejercicio1 = @EjercicioX
UPDATE #ResultadoA SET Porcentaje2 = (Saldo2/dbo.fnEvitarDivisionCero(Ingresos2))*100 WHERE Ejercicio2 = @EjercicioX
UPDATE #ResultadoA SET Porcentaje3 = (Saldo3/dbo.fnEvitarDivisionCero(Ingresos3))*100 WHERE Ejercicio3 = @EjercicioX
UPDATE #ResultadoA SET Porcentaje4 = (Saldo4/dbo.fnEvitarDivisionCero(Ingresos4))*100 WHERE Ejercicio4 = @EjercicioX
UPDATE #ResultadoA SET Porcentaje5 = (Saldo5/dbo.fnEvitarDivisionCero(Ingresos5))*100 WHERE Ejercicio5 = @EjercicioX
END
FETCH NEXT FROM Cursor_Ingresos INTO @EjercicioX
END
CLOSE Cursor_Ingresos
DEALLOCATE Cursor_Ingresos
END
IF @Anual = 'Del Mes'
BEGIN
DECLARE Cursor_Ingresos CURSOR FOR
SELECT Ejercicio
FROM #Ejercicios
OPEN Cursor_Ingresos
FETCH NEXT FROM Cursor_Ingresos INTO @EjercicioX
WHILE @@FETCH_STATUS <> -1
BEGIN
IF @@FETCH_STATUS <> -2
BEGIN
UPDATE #ResultadoA SET Ingresos1  = (SELECT Sum(ISNULL(a.Cargos, 0.0)-ISNULL(a.Abonos, 0.0)) FROM Acum a WHERE a.Rama = 'CONT' AND a.Cuenta = @CtaIngresos AND ISNULL(a.SubCuenta, '') = ISNULL(ISNULL(@CentroCostos, a.SubCuenta), '') AND ISNULL(a.Sucursal, 0) = ISNULL(ISNULL(@Sucursal, a.Sucursal), 0) AND ISNULL(a.UEN, 0) = ISNULL(ISNULL(@UEN, a.UEN), 0) AND ISNULL(a.Proyecto, '')  = ISNULL(ISNULL(@Proyecto, a.Proyecto), '') AND ISNULL(a.SubCuenta2, '')= ISNULL(ISNULL(@CentroCostos2, a.SubCuenta2), '') AND ISNULL(a.SubCuenta3, '')= ISNULL(ISNULL(@CentroCostos3, a.SubCuenta3), '') AND a.Ejercicio = b.Ejercicio1 AND a.Periodo = @PeriodoA AND a.Moneda = @Moneda AND a.Empresa = @Empresa) FROM #ResultadoA b WHERE b.Ejercicio1 = @EjercicioX
UPDATE #ResultadoA SET Ingresos2  = (SELECT Sum(ISNULL(a.Cargos, 0.0)-ISNULL(a.Abonos, 0.0)) FROM Acum a WHERE a.Rama = 'CONT' AND a.Cuenta = @CtaIngresos AND ISNULL(a.SubCuenta, '') = ISNULL(ISNULL(@CentroCostos, a.SubCuenta), '') AND ISNULL(a.Sucursal, 0) = ISNULL(ISNULL(@Sucursal, a.Sucursal), 0) AND ISNULL(a.UEN, 0) = ISNULL(ISNULL(@UEN, a.UEN), 0) AND ISNULL(a.Proyecto, '')  = ISNULL(ISNULL(@Proyecto, a.Proyecto), '') AND ISNULL(a.SubCuenta2, '')= ISNULL(ISNULL(@CentroCostos2, a.SubCuenta2), '') AND ISNULL(a.SubCuenta3, '')= ISNULL(ISNULL(@CentroCostos3, a.SubCuenta3), '') AND a.Ejercicio = b.Ejercicio2 AND a.Periodo = @PeriodoA AND a.Moneda = @Moneda AND a.Empresa = @Empresa) FROM #ResultadoA b WHERE b.Ejercicio2 = @EjercicioX
UPDATE #ResultadoA SET Ingresos3  = (SELECT Sum(ISNULL(a.Cargos, 0.0)-ISNULL(a.Abonos, 0.0)) FROM Acum a WHERE a.Rama = 'CONT' AND a.Cuenta = @CtaIngresos AND ISNULL(a.SubCuenta, '') = ISNULL(ISNULL(@CentroCostos, a.SubCuenta), '') AND ISNULL(a.Sucursal, 0) = ISNULL(ISNULL(@Sucursal, a.Sucursal), 0) AND ISNULL(a.UEN, 0) = ISNULL(ISNULL(@UEN, a.UEN), 0) AND ISNULL(a.Proyecto, '')  = ISNULL(ISNULL(@Proyecto, a.Proyecto), '') AND ISNULL(a.SubCuenta2, '')= ISNULL(ISNULL(@CentroCostos2, a.SubCuenta2), '') AND ISNULL(a.SubCuenta3, '')= ISNULL(ISNULL(@CentroCostos3, a.SubCuenta3), '') AND a.Ejercicio = b.Ejercicio3 AND a.Periodo = @PeriodoA AND a.Moneda = @Moneda AND a.Empresa = @Empresa) FROM #ResultadoA b WHERE b.Ejercicio3 = @EjercicioX
UPDATE #ResultadoA SET Ingresos4  = (SELECT Sum(ISNULL(a.Cargos, 0.0)-ISNULL(a.Abonos, 0.0)) FROM Acum a WHERE a.Rama = 'CONT' AND a.Cuenta = @CtaIngresos AND ISNULL(a.SubCuenta, '') = ISNULL(ISNULL(@CentroCostos, a.SubCuenta), '') AND ISNULL(a.Sucursal, 0) = ISNULL(ISNULL(@Sucursal, a.Sucursal), 0) AND ISNULL(a.UEN, 0) = ISNULL(ISNULL(@UEN, a.UEN), 0) AND ISNULL(a.Proyecto, '')  = ISNULL(ISNULL(@Proyecto, a.Proyecto), '') AND ISNULL(a.SubCuenta2, '')= ISNULL(ISNULL(@CentroCostos2, a.SubCuenta2), '') AND ISNULL(a.SubCuenta3, '')= ISNULL(ISNULL(@CentroCostos3, a.SubCuenta3), '') AND a.Ejercicio = b.Ejercicio4 AND a.Periodo = @PeriodoA AND a.Moneda = @Moneda AND a.Empresa = @Empresa) FROM #ResultadoA b WHERE b.Ejercicio4 = @EjercicioX
UPDATE #ResultadoA SET Ingresos5  = (SELECT Sum(ISNULL(a.Cargos, 0.0)-ISNULL(a.Abonos, 0.0)) FROM Acum a WHERE a.Rama = 'CONT' AND a.Cuenta = @CtaIngresos AND ISNULL(a.SubCuenta, '') = ISNULL(ISNULL(@CentroCostos, a.SubCuenta), '') AND ISNULL(a.Sucursal, 0) = ISNULL(ISNULL(@Sucursal, a.Sucursal), 0) AND ISNULL(a.UEN, 0) = ISNULL(ISNULL(@UEN, a.UEN), 0) AND ISNULL(a.Proyecto, '')  = ISNULL(ISNULL(@Proyecto, a.Proyecto), '') AND ISNULL(a.SubCuenta2, '')= ISNULL(ISNULL(@CentroCostos2, a.SubCuenta2), '') AND ISNULL(a.SubCuenta3, '')= ISNULL(ISNULL(@CentroCostos3, a.SubCuenta3), '') AND a.Ejercicio = b.Ejercicio5 AND a.Periodo = @PeriodoA AND a.Moneda = @Moneda AND a.Empresa = @Empresa) FROM #ResultadoA b WHERE b.Ejercicio5 = @EjercicioX
UPDATE #ResultadoA SET Saldo1 = (SELECT Sum(ISNULL(a.Cargos, 0.0)-ISNULL(a.Abonos, 0.0)) FROM Acum a WHERE a.Rama = 'CONT' AND a.Cuenta = b.Cuenta AND a.Ejercicio = b.Ejercicio1 AND ISNULL(a.SubCuenta, '') = ISNULL(b.SubCuenta, '') AND ISNULL(a.SubCuenta, '') = ISNULL(ISNULL(@CentroCostos, a.SubCuenta), '') AND ISNULL(a.Sucursal, 0) = ISNULL(ISNULL(@Sucursal, a.Sucursal), 0) AND ISNULL(a.UEN, 0) = ISNULL(ISNULL(@UEN, a.UEN), 0) AND ISNULL(a.Proyecto, '')  = ISNULL(ISNULL(@Proyecto, a.Proyecto), '') AND ISNULL(a.SubCuenta2, '')= ISNULL(ISNULL(@CentroCostos2, a.SubCuenta2), '') AND ISNULL(a.SubCuenta3, '')= ISNULL(ISNULL(@CentroCostos3, a.SubCuenta3), '') AND a.Moneda = @Moneda AND a.Periodo = @PeriodoA AND a.Empresa = @Empresa) FROM #ResultadoA b WHERE b.Ejercicio1 = @EjercicioX
UPDATE #ResultadoA SET Saldo2 = (SELECT Sum(ISNULL(a.Cargos, 0.0)-ISNULL(a.Abonos, 0.0)) FROM Acum a WHERE a.Rama = 'CONT' AND a.Cuenta = b.Cuenta AND a.Ejercicio = b.Ejercicio2 AND ISNULL(a.SubCuenta, '') = ISNULL(b.SubCuenta, '') AND ISNULL(a.SubCuenta, '') = ISNULL(ISNULL(@CentroCostos, a.SubCuenta), '') AND ISNULL(a.Sucursal, 0) = ISNULL(ISNULL(@Sucursal, a.Sucursal), 0) AND ISNULL(a.UEN, 0) = ISNULL(ISNULL(@UEN, a.UEN), 0) AND ISNULL(a.Proyecto, '')  = ISNULL(ISNULL(@Proyecto, a.Proyecto), '') AND ISNULL(a.SubCuenta2, '')= ISNULL(ISNULL(@CentroCostos2, a.SubCuenta2), '') AND ISNULL(a.SubCuenta3, '')= ISNULL(ISNULL(@CentroCostos3, a.SubCuenta3), '') AND a.Moneda = @Moneda AND a.Periodo = @PeriodoA AND a.Empresa = @Empresa) FROM #ResultadoA b WHERE b.Ejercicio2 = @EjercicioX
UPDATE #ResultadoA SET Saldo3 = (SELECT Sum(ISNULL(a.Cargos, 0.0)-ISNULL(a.Abonos, 0.0)) FROM Acum a WHERE a.Rama = 'CONT' AND a.Cuenta = b.Cuenta AND a.Ejercicio = b.Ejercicio3 AND ISNULL(a.SubCuenta, '') = ISNULL(b.SubCuenta, '') AND ISNULL(a.SubCuenta, '') = ISNULL(ISNULL(@CentroCostos, a.SubCuenta), '') AND ISNULL(a.Sucursal, 0) = ISNULL(ISNULL(@Sucursal, a.Sucursal), 0) AND ISNULL(a.UEN, 0) = ISNULL(ISNULL(@UEN, a.UEN), 0) AND ISNULL(a.Proyecto, '')  = ISNULL(ISNULL(@Proyecto, a.Proyecto), '') AND ISNULL(a.SubCuenta2, '')= ISNULL(ISNULL(@CentroCostos2, a.SubCuenta2), '') AND ISNULL(a.SubCuenta3, '')= ISNULL(ISNULL(@CentroCostos3, a.SubCuenta3), '') AND a.Moneda = @Moneda AND a.Periodo = @PeriodoA AND a.Empresa = @Empresa) FROM #ResultadoA b WHERE b.Ejercicio3 = @EjercicioX
UPDATE #ResultadoA SET Saldo4 = (SELECT Sum(ISNULL(a.Cargos, 0.0)-ISNULL(a.Abonos, 0.0)) FROM Acum a WHERE a.Rama = 'CONT' AND a.Cuenta = b.Cuenta AND a.Ejercicio = b.Ejercicio4 AND ISNULL(a.SubCuenta, '') = ISNULL(b.SubCuenta, '') AND ISNULL(a.SubCuenta, '') = ISNULL(ISNULL(@CentroCostos, a.SubCuenta), '') AND ISNULL(a.Sucursal, 0) = ISNULL(ISNULL(@Sucursal, a.Sucursal), 0) AND ISNULL(a.UEN, 0) = ISNULL(ISNULL(@UEN, a.UEN), 0) AND ISNULL(a.Proyecto, '')  = ISNULL(ISNULL(@Proyecto, a.Proyecto), '') AND ISNULL(a.SubCuenta2, '')= ISNULL(ISNULL(@CentroCostos2, a.SubCuenta2), '') AND ISNULL(a.SubCuenta3, '')= ISNULL(ISNULL(@CentroCostos3, a.SubCuenta3), '') AND a.Moneda = @Moneda AND a.Periodo = @PeriodoA AND a.Empresa = @Empresa) FROM #ResultadoA b WHERE b.Ejercicio4 = @EjercicioX
UPDATE #ResultadoA SET Saldo5 = (SELECT Sum(ISNULL(a.Cargos, 0.0)-ISNULL(a.Abonos, 0.0)) FROM Acum a WHERE a.Rama = 'CONT' AND a.Cuenta = b.Cuenta AND a.Ejercicio = b.Ejercicio5 AND ISNULL(a.SubCuenta, '') = ISNULL(b.SubCuenta, '') AND ISNULL(a.SubCuenta, '') = ISNULL(ISNULL(@CentroCostos, a.SubCuenta), '') AND ISNULL(a.Sucursal, 0) = ISNULL(ISNULL(@Sucursal, a.Sucursal), 0) AND ISNULL(a.UEN, 0) = ISNULL(ISNULL(@UEN, a.UEN), 0) AND ISNULL(a.Proyecto, '')  = ISNULL(ISNULL(@Proyecto, a.Proyecto), '') AND ISNULL(a.SubCuenta2, '')= ISNULL(ISNULL(@CentroCostos2, a.SubCuenta2), '') AND ISNULL(a.SubCuenta3, '')= ISNULL(ISNULL(@CentroCostos3, a.SubCuenta3), '') AND a.Moneda = @Moneda AND a.Periodo = @PeriodoA AND a.Empresa = @Empresa) FROM #ResultadoA b WHERE b.Ejercicio5 = @EjercicioX
UPDATE #ResultadoA SET Porcentaje1 = (Saldo1/dbo.fnEvitarDivisionCero(Ingresos1))*100 WHERE Ejercicio1 = @EjercicioX
UPDATE #ResultadoA SET Porcentaje2 = (Saldo2/dbo.fnEvitarDivisionCero(Ingresos2))*100 WHERE Ejercicio2 = @EjercicioX
UPDATE #ResultadoA SET Porcentaje3 = (Saldo3/dbo.fnEvitarDivisionCero(Ingresos3))*100 WHERE Ejercicio3 = @EjercicioX
UPDATE #ResultadoA SET Porcentaje4 = (Saldo4/dbo.fnEvitarDivisionCero(Ingresos4))*100 WHERE Ejercicio4 = @EjercicioX
UPDATE #ResultadoA SET Porcentaje5 = (Saldo5/dbo.fnEvitarDivisionCero(Ingresos5))*100 WHERE Ejercicio5 = @EjercicioX
END
FETCH NEXT FROM Cursor_Ingresos INTO @EjercicioX
END
CLOSE Cursor_Ingresos
DEALLOCATE Cursor_Ingresos
END
IF @ReExpresar='Si'
UPDATE #ResultadoA
SET Saldo1=Saldo1/ISNULL(@ReExpresarTipoCambio,1),
Ingresos1=Ingresos1/ISNULL(@ReExpresarTipoCambio,1),
Saldo2=Saldo2/ISNULL(@ReExpresarTipoCambio,1),
Ingresos2=Ingresos2/ISNULL(@ReExpresarTipoCambio,1),
Saldo3=Saldo3/ISNULL(@ReExpresarTipoCambio,1),
Ingresos3=Ingresos3/ISNULL(@ReExpresarTipoCambio,1),
Saldo4=Saldo4/ISNULL(@ReExpresarTipoCambio,1),
Ingresos4=Ingresos4/ISNULL(@ReExpresarTipoCambio,1),
Saldo5=Saldo5/ISNULL(@ReExpresarTipoCambio,1),
Ingresos5=Ingresos5/ISNULL(@ReExpresarTipoCambio,1)
IF @OrdenCC = 'NO'
BEGIN
IF @ConMovs = 'SI'
SELECT r.*, "Grupo" = CONVERT(varchar(50), null), "SubGrupo" = CONVERT(varchar(50), null), "SubSubGrupo" = CONVERT(varchar(50), null)
FROM #ResultadoA r
WHERE ISNULL(r.Saldo1, 0.0) <> 0.0 OR ISNULL(r.Saldo2, 0.0) <> 0.0 OR ISNULL(r.Saldo3, 0.0) <> 0.0 OR ISNULL(r.Saldo4, 0.0) <> 0.0 OR ISNULL(r.Saldo5, 0.0) <> 0.0 ORDER BY r.Orden, r.ID
ELSE
SELECT r.*, "Grupo" = CONVERT(varchar(50), null), "SubGrupo" = CONVERT(varchar(50), null), "SubSubGrupo" = CONVERT(varchar(50), null)
FROM #ResultadoA r
ORDER BY r.Orden, r.ID
END ELSE
BEGIN
IF @CCGrupo <> 'NULL'
BEGIN
IF @ConMovs = 'SI'
SELECT r.*, cc.Grupo, cc.SubGrupo, cc.SubSubGrupo
FROM #ResultadoA r JOIN CentroCostos cc ON r.SubCuenta = cc.CentroCostos AND cc.Grupo = ISNULL(@CCGrupo, cc.Grupo)
WHERE ISNULL(r.Saldo1, 0.0) <> 0.0 OR ISNULL(r.Saldo2, 0.0) <> 0.0 OR ISNULL(r.Saldo3, 0.0) <> 0.0 OR ISNULL(r.Saldo4, 0.0) <> 0.0 OR ISNULL(r.Saldo5, 0.0) <> 0.0
ORDER BY r.Orden, r.Rama, cc.Grupo, cc.SubGrupo, cc.SubSubGrupo, r.SubCuenta, r.ID
ELSE
SELECT r.*, cc.Grupo, cc.SubGrupo, cc.SubSubGrupo
FROM #ResultadoA r JOIN CentroCostos cc ON r.SubCuenta = cc.CentroCostos AND cc.Grupo = ISNULL(@CCGrupo, cc.Grupo)
ORDER BY r.Orden, r.Rama, cc.Grupo, cc.SubGrupo, cc.SubSubGrupo, r.SubCuenta, r.ID
END ELSE
BEGIN
IF @ConMovs = 'SI'
SELECT r.*, cc.Grupo, cc.SubGrupo, cc.SubSubGrupo
FROM #ResultadoA r LEFT OUTER JOIN CentroCostos cc ON r.SubCuenta = cc.CentroCostos
WHERE ISNULL(r.Saldo1, 0.0) <> 0.0 OR ISNULL(r.Saldo2, 0.0) <> 0.0 OR ISNULL(r.Saldo3, 0.0) <> 0.0 OR ISNULL(r.Saldo4, 0.0) <> 0.0 OR ISNULL(r.Saldo5, 0.0) <> 0.0
ORDER BY r.Orden, r.Rama, cc.Grupo, cc.SubGrupo, cc.SubSubGrupo, r.SubCuenta, r.ID
ELSE
SELECT r.*, cc.Grupo, cc.SubGrupo, cc.SubSubGrupo
FROM #ResultadoA r LEFT OUTER JOIN CentroCostos cc ON r.SubCuenta = cc.CentroCostos
ORDER BY r.Orden, r.Rama, cc.Grupo, cc.SubGrupo, cc.SubSubGrupo, r.SubCuenta, r.ID
END
END
END

