SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spRSRazonesFinancieras
@Empresa	 char(5),
@Ejercicio	 int,
@TipoPeriodo varchar(10)

AS
BEGIN
DECLARE
@ID				int,
@CtaActivo			char(20),
@CtaActivoFijo		char(20),
@CtaActivoDiferido	char(20),
@CtaActivoD			char(20),
@CtaActivoA			char(20),
@CtaPasivo			char(20),
@CtaPasivoLargoPlazo char(20),
@CtaPasivoDiferido	char(20),
@CtaPasivoD			char(20),
@CtaPasivoA			char(20),
@CtaInventario		char(20),
@CtaInventarioD		char(20),
@CtaInventarioA		char(20),
@CtaAF			char(20),
@SaldoActivo		money,
@SaldoPasivo		money,
@Moneda			char(10),
@Tipo			char(50),
@Mes			int,
@Saldo			money,
@DescPeriodo    varchar(20),
@CtaEfectivoCaja varchar(20),
@CtaEfectivoCajaD varchar(20),
@CtaEfectivoCajaA varchar(20),
@CtaEfectivoBanco varchar(20),
@CtaEfectivoBancoD varchar(20),
@CtaEfectivoBancoA varchar(20),
@CtaEfectivoInversion varchar(20),
@CtaEfectivoInversionD varchar(20),
@CtaEfectivoInversionA varchar(20),
@CtaActivoFijoD			char(20),
@CtaActivoFijoA			char(20),
@CtaActivoDiferidoD		char(20),
@CtaActivoDiferidoA			char(20),
@CtaPasivoLargoPlazoD		char(20),
@CtaPasivoLargoPlazoA			char(20),
@CtaPasivoDiferidoD		char(20),
@CtaPasivoDiferidoA			char(20),
@CtaCompras		char(20),
@CtaComprasD		char(20),
@CtaComprasA	    char(20),
@CtaDevoCompras		char(20),
@CtaDevoComprasD		char(20),
@CtaDevoComprasA	    char(20),
@CtaGastosFinancieros	char(20),
@CtaGastosFinancierosD		char(20),
@CtaGastosFinancierosA	    char(20),
@CtaVentas           	char(20), 
@CtaVentasD		        char(20),
@CtaVentasA	            char(20),
@CtaCostoVentas       	char(20), 
@CtaCostoVentasD        char(20),
@CtaCostoVentasA        char(20),
@CtaGastosOperacion     char(20), 
@CtaGastosOperacionD    char(20),
@CtaGastosOperacionA    char(20),
@CtaOtrosGastosProductos   char(20), 
@CtaOtrosGastosProductosD   char(20),
@CtaOtrosGastosProductosA   char(20),
@CtaOtrosIngresos        char(20), 
@CtaOtrosIngresosD        char(20),
@CtaOtrosIngresosA        char(20),
@CtaCuentasPorCobrar       	char(20),
@CtaCuentasPorCobrarD        char(20),
@CtaCuentasPorCobrarA        char(20),
@CtaProveedores       	char(20),
@CtaProveedoresD        char(20),
@CtaProveedoresA        char(20),
@CtaDepreAmort  char(20),
@CtaDepreAmortD char(20),
@CtaDepreAmortA char(20),
@CtaCuentasPorPagar       	char(20),
@CtaCuentasPorPagarD        char(20),
@CtaCuentasPorPagarA        char(20),
@CtaAcreedores       	char(20),
@CtaAcreedoresD        char(20),
@CtaAcreedoresA        char(20),
@CtaImpuestosPagados       	char(20),
@CtaImpuestosPagadosD        char(20),
@CtaImpuestosPagadosA        char(20),
@CtaCapitalContable       	char(20),
@CtaCapitalContableD        char(20),
@CtaCapitalContableA        char(20),
@CtaInversionCapital       	char(20),
@CtaInversionCapitalD        char(20),
@CtaInversionCapitalA        char(20),
@EsAcreedora                 int
SELECT @Moneda = ContMoneda FROM EmpresaCfg WHERE Empresa = @Empresa
CREATE TABLE #RazonesFinancieras(
DescripcionPeriodo varchar(20),
Activo		float	NULL,
Pasivo		float	NULL,
ActivoFijo float NULL,
ActivoDiferido float NULL,
PasivoLargoPlazo float NULL,
PasivoDiferido float NULL,
ActivoTotal float NULL,
PasivoTotal float NULL,
RazonCirculante  float   NULL,
Inventario  float   NULL,
RazonAcida  float   NULL,
Efectivo  float   NULL,
RazonEfectivo  float   NULL,
CapitalTrabajo float NULL,
CapitalTrabajo2 float NULL,
Compras float NULL,
DevolucionCompras float NULL,
MedicionIntervaloTiempo float NULL,
TotalDeuda float NULL,
RelacionFlujoCajaOperativo float NULL,
GastosFinancieros float NULL,
ImpuestosPagados float NULL,
Ventas float NULL, 
CostoVentas float NULL, 
GastosOperacion float NULL, 
OtrosGastosProductos float NULL, 
OtrosIngresos float NULL, 
UtilidadAntesImpuestosIntereses float NULL,
CuentasPorCobrar float NULL,
Proveedores float NULL,
CuentasPorPagar float NULL,
Acreedores float NULL,
UtilidadBruta float NULL,
UtilidadOperacion float NULL,
DepreciacionesAmortizaciones float NULL,
CapitalContable float NULL,
UAFIR float NULL,
UAFIRDA float NULL,
AplacamientoTotal float NULL,
AplacamientoCostoTotal float NULL,
AplacamientoCortoPlazo float NULL,
AplacamientoLargoPlazo float NULL,
CoberturaGastosFinancieros float NULL,
CoberturaEfectivo float NULL,
RotacionInventarios float NULL,
DiasInventarios float NULL,
RotacionCxc float NULL,
DiasCxc float NULL,
RotacionCxp float NULL,
DiasCxp float NULL,
RotacionTotalActivos float NULL,
RotacionActivosFijos float NULL,
InversionCapital float NULL,
MargenNeto float NULL,
RendimientoSobreActivos float NULL,
RendimientoSobreCapital float NULL,
MargenBruto float NULL,
MargenOperativo float NULL,
MargenUAFIRDA float NULL,
ROIC float NULL
)
CREATE TABLE #TiposPeriodo(
TipoPeriodo	varchar(10),
DescripcionPeriodo varchar(20),
PeriodoD	int	NULL,
PeriodoA	int	NULL,
)
CREATE TABLE #CuentasAplicar(
Cuenta varchar(20),
CuentaA varchar(20)
)
INSERT #TiposPeriodo
SELECT 'Trimestral','Trimestre 1', 1,3
UNION
SELECT 'Trimestral','Trimestre 2', 4,6
UNION
SELECT 'Trimestral','Trimestre 3',  7,9
UNION
SELECT 'Trimestral','Trimestre 4', 10,12
UNION
SELECT 'Semestral','Semestre 1', 1,6
UNION
SELECT 'Semestral','Semestre 2', 7,12
UNION
SELECT 'Anual','Anual', 1,12
SELECT DISTINCT
@CtaActivo   		= CtaActivo,
@CtaActivoFijo 	= CtaActivoFijo,
@CtaActivoDiferido  = CtaActivoDiferido,
@CtaPasivo   		= CtaPasivo,
@CtaPasivoLargoPlazo = CtaPasivoLargoPlazo,
@CtaPasivoDiferido = CtaPasivoDiferido,
@CtaInventario    = CtaInventario,
@CtaEfectivoCaja  = CtaEfectivoCaja,
@CtaEfectivoBanco  = CtaEfectivoBanco,
@CtaEfectivoInversion  = CtaEfectivoInversion,
@CtaCompras		 = CtaCompras,
@CtaDevoCompras    = CtaDevoluciones,
@CtaGastosFinancieros = CtaGastosFinancieros,
@CtaVentas            = CtaVentas,
@CtaCostoVentas            = CtaCostoVentas,
@CtaGastosOperacion            = CtaGastosOperacion,
@CtaOtrosGastosProductos   =CtaOtrosGastosProductos,
@CtaOtrosIngresos        =CtaOtrosIngresos,
@CtaCuentasPorCobrar     =CtaCuentasPorCobrar,
@CtaProveedores          =CtaProveedores,
@CtaDepreAmort=CtaDepreAmort,
@CtaImpuestosPagados=CtaImpuestosPagados,
@CtaCapitalContable=CtaCapitalContable,
@CtaInversionCapital=CtaInversionCapital,
@CtaAcreedores=CtaAcreedores
FROM CtaRazonFinanciera
INSERT INTO #CuentasAplicar (Cuenta, CuentaA)
SELECT DISTINCT @CtaActivo, Cty.Cuenta
FROM Cta C
JOIN Cta Ct ON Ct.Rama = C.Cuenta
JOIN Cta Ctx ON Ctx.Rama = Ct.Cuenta
JOIN Cta Cty ON Cty.Rama = Ctx.Cuenta
LEFT OUTER JOIN CtaRazonesFinancierasExcepcionar CtaE ON CtaE.Cuenta=C.Cuenta AND Cty.Cuenta=CtaE.CuentaE
WHERE C.Rama  = 'B'
AND C.Cuenta = @CtaActivo
AND CtaE.CuentaE IS NULL
UNION
SELECT DISTINCT @CtaActivo as CuentaAgrup, CtaA.CuentaA
FROM Cta
JOIN CtaRazonesFinancierasAdicionar CtaA ON CtaA.Cuenta=Cta.Cuenta
WHERE Cta.Cuenta = @CtaActivo
UNION
SELECT DISTINCT @CtaActivoFijo, Cty.Cuenta
FROM Cta C
JOIN Cta Ct ON Ct.Rama = C.Cuenta
JOIN Cta Ctx ON Ctx.Rama = Ct.Cuenta
JOIN Cta Cty ON Cty.Rama = Ctx.Cuenta
LEFT OUTER JOIN CtaRazonesFinancierasExcepcionar CtaE ON CtaE.Cuenta=C.Cuenta AND Cty.Cuenta=CtaE.CuentaE
WHERE C.Rama  = 'B'
AND C.Cuenta = @CtaActivoFijo
AND CtaE.CuentaE IS NULL
UNION
SELECT DISTINCT @CtaActivoFijo as CuentaAgrup, CtaA.CuentaA
FROM Cta
JOIN CtaRazonesFinancierasAdicionar CtaA ON CtaA.Cuenta=Cta.Cuenta
WHERE Cta.Cuenta = @CtaActivoFijo
UNION
SELECT DISTINCT @CtaActivoDiferido, Cty.Cuenta
FROM Cta C
JOIN Cta Ct ON Ct.Rama = C.Cuenta
JOIN Cta Ctx ON Ctx.Rama = Ct.Cuenta
JOIN Cta Cty ON Cty.Rama = Ctx.Cuenta
LEFT OUTER JOIN CtaRazonesFinancierasExcepcionar CtaE ON CtaE.Cuenta=C.Cuenta AND Cty.Cuenta=CtaE.CuentaE
WHERE C.Rama  = 'B'
AND C.Cuenta = @CtaActivoDiferido
AND CtaE.CuentaE IS NULL
UNION
SELECT DISTINCT @CtaActivoDiferido as CuentaAgrup, CtaA.CuentaA
FROM Cta
JOIN CtaRazonesFinancierasAdicionar CtaA ON CtaA.Cuenta=Cta.Cuenta
WHERE Cta.Cuenta = @CtaActivoDiferido
UNION
SELECT DISTINCT @CtaPasivo, Cty.Cuenta
FROM Cta C
JOIN Cta Ct ON Ct.Rama = C.Cuenta
JOIN Cta Ctx ON Ctx.Rama = Ct.Cuenta
JOIN Cta Cty ON Cty.Rama = Ctx.Cuenta
LEFT OUTER JOIN CtaRazonesFinancierasExcepcionar CtaE ON CtaE.Cuenta=C.Cuenta AND Cty.Cuenta=CtaE.CuentaE
WHERE C.Rama  = 'H'
AND C.Cuenta = @CtaPasivo
AND CtaE.CuentaE IS NULL
UNION
SELECT DISTINCT @CtaPasivo as CuentaAgrup, CtaA.CuentaA
FROM Cta
JOIN CtaRazonesFinancierasAdicionar CtaA ON CtaA.Cuenta=Cta.Cuenta
WHERE Cta.Cuenta = @CtaPasivo
UNION
SELECT DISTINCT @CtaPasivoDiferido, Cty.Cuenta
FROM Cta C
JOIN Cta Ct ON Ct.Rama = C.Cuenta
JOIN Cta Ctx ON Ctx.Rama = Ct.Cuenta
JOIN Cta Cty ON Cty.Rama = Ctx.Cuenta
LEFT OUTER JOIN CtaRazonesFinancierasExcepcionar CtaE ON CtaE.Cuenta=C.Cuenta AND Cty.Cuenta=CtaE.CuentaE
WHERE C.Rama  = 'H'
AND C.Cuenta = @CtaPasivoDiferido
AND CtaE.CuentaE IS NULL
UNION
SELECT DISTINCT @CtaPasivoDiferido as CuentaAgrup, CtaA.CuentaA
FROM Cta
JOIN CtaRazonesFinancierasAdicionar CtaA ON CtaA.Cuenta=Cta.Cuenta
WHERE Cta.Cuenta = @CtaPasivoDiferido
UNION
SELECT DISTINCT @CtaPasivoLargoPlazo, Cty.Cuenta
FROM Cta C
JOIN Cta Ct ON Ct.Rama = C.Cuenta
JOIN Cta Ctx ON Ctx.Rama = Ct.Cuenta
JOIN Cta Cty ON Cty.Rama = Ctx.Cuenta
LEFT OUTER JOIN CtaRazonesFinancierasExcepcionar CtaE ON CtaE.Cuenta=C.Cuenta AND Cty.Cuenta=CtaE.CuentaE
WHERE C.Rama  = 'H'
AND C.Cuenta = @CtaPasivoLargoPlazo
AND CtaE.CuentaE IS NULL
UNION
SELECT DISTINCT @CtaPasivoLargoPlazo as CuentaAgrup, CtaA.CuentaA
FROM Cta
JOIN CtaRazonesFinancierasAdicionar CtaA ON CtaA.Cuenta=Cta.Cuenta
WHERE Cta.Cuenta = @CtaPasivoLargoPlazo
UNION
SELECT DISTINCT @CtaInventario, Cty.Cuenta
FROM Cta C
JOIN Cta Ct ON Ct.Rama = C.Cuenta
JOIN Cta Ctx ON Ctx.Rama = Ct.Cuenta
JOIN Cta Cty ON Cty.Rama = Ctx.Cuenta
LEFT OUTER JOIN CtaRazonesFinancierasExcepcionar CtaE ON CtaE.Cuenta=C.Cuenta AND Cty.Cuenta=CtaE.CuentaE
WHERE C.Rama  = 'B'
AND Ct.Cuenta = @CtaInventario
AND CtaE.CuentaE IS NULL
UNION
SELECT DISTINCT @CtaInventario as CuentaAgrup, CtaA.CuentaA
FROM Cta
JOIN CtaRazonesFinancierasAdicionar CtaA ON CtaA.Cuenta=Cta.Cuenta
WHERE Cta.Cuenta = @CtaInventario
UNION
SELECT DISTINCT @CtaEfectivoCaja, Cty.Cuenta
FROM Cta C
JOIN Cta Ct ON Ct.Rama = C.Cuenta
JOIN Cta Ctx ON Ctx.Rama = Ct.Cuenta
JOIN Cta Cty ON Cty.Rama = Ctx.Cuenta
LEFT OUTER JOIN CtaRazonesFinancierasExcepcionar CtaE ON CtaE.Cuenta=C.Cuenta AND Cty.Cuenta=CtaE.CuentaE
WHERE C.Rama  = 'B'
AND Ct.Cuenta = @CtaEfectivoCaja
AND CtaE.CuentaE IS NULL
UNION
SELECT DISTINCT @CtaEfectivoCaja as CuentaAgrup, CtaA.CuentaA
FROM Cta
JOIN CtaRazonesFinancierasAdicionar CtaA ON CtaA.Cuenta=Cta.Cuenta
WHERE Cta.Cuenta = @CtaEfectivoCaja
UNION
SELECT DISTINCT @CtaEfectivoBanco, Cty.Cuenta
FROM Cta C
JOIN Cta Ct ON Ct.Rama = C.Cuenta
JOIN Cta Ctx ON Ctx.Rama = Ct.Cuenta
JOIN Cta Cty ON Cty.Rama = Ctx.Cuenta
LEFT OUTER JOIN CtaRazonesFinancierasExcepcionar CtaE ON CtaE.Cuenta=C.Cuenta AND Cty.Cuenta=CtaE.CuentaE
WHERE C.Rama  = 'B'
AND Ct.Cuenta = @CtaEfectivoBanco
AND CtaE.CuentaE IS NULL
UNION
SELECT DISTINCT @CtaEfectivoBanco as CuentaAgrup, CtaA.CuentaA
FROM Cta
JOIN CtaRazonesFinancierasAdicionar CtaA ON CtaA.Cuenta=Cta.Cuenta
WHERE Cta.Cuenta = @CtaEfectivoBanco
UNION
SELECT DISTINCT @CtaEfectivoInversion, Cty.Cuenta
FROM Cta C
JOIN Cta Ct ON Ct.Rama = C.Cuenta
JOIN Cta Ctx ON Ctx.Rama = Ct.Cuenta
JOIN Cta Cty ON Cty.Rama = Ctx.Cuenta
LEFT OUTER JOIN CtaRazonesFinancierasExcepcionar CtaE ON CtaE.Cuenta=C.Cuenta AND Cty.Cuenta=CtaE.CuentaE
WHERE C.Rama  = 'B'
AND Ct.Cuenta = @CtaEfectivoInversion
AND CtaE.CuentaE IS NULL
UNION
SELECT DISTINCT @CtaEfectivoInversion as CuentaAgrup, CtaA.CuentaA
FROM Cta
JOIN CtaRazonesFinancierasAdicionar CtaA ON CtaA.Cuenta=Cta.Cuenta
WHERE Cta.Cuenta = @CtaEfectivoInversion
UNION
SELECT DISTINCT @CtaCompras, Cty.Cuenta
FROM Cta C
JOIN Cta Ct ON Ct.Rama = C.Cuenta
JOIN Cta Ctx ON Ctx.Rama = Ct.Cuenta
JOIN Cta Cty ON Cty.Rama = Ctx.Cuenta
LEFT OUTER JOIN CtaRazonesFinancierasExcepcionar CtaE ON CtaE.Cuenta=C.Cuenta AND Cty.Cuenta=CtaE.CuentaE
WHERE 
Ct.Cuenta = @CtaCompras
AND CtaE.CuentaE IS NULL
UNION
SELECT DISTINCT @CtaCompras as CuentaAgrup, CtaA.CuentaA
FROM Cta
JOIN CtaRazonesFinancierasAdicionar CtaA ON CtaA.Cuenta=Cta.Cuenta
WHERE Cta.Cuenta = @CtaCompras
UNION
SELECT DISTINCT @CtaDevoCompras, Cty.Cuenta
FROM Cta C
JOIN Cta Ct ON Ct.Rama = C.Cuenta
JOIN Cta Ctx ON Ctx.Rama = Ct.Cuenta
JOIN Cta Cty ON Cty.Rama = Ctx.Cuenta
LEFT OUTER JOIN CtaRazonesFinancierasExcepcionar CtaE ON CtaE.Cuenta=C.Cuenta AND Cty.Cuenta=CtaE.CuentaE
WHERE 
Ct.Cuenta = @CtaDevoCompras
AND CtaE.CuentaE IS NULL
UNION
SELECT DISTINCT @CtaDevoCompras as CuentaAgrup, CtaA.CuentaA
FROM Cta
JOIN CtaRazonesFinancierasAdicionar CtaA ON CtaA.Cuenta=Cta.Cuenta
WHERE Cta.Cuenta = @CtaDevoCompras
UNION
SELECT DISTINCT @CtaGastosFinancieros, Cty.Cuenta
FROM Cta C
JOIN Cta Ct ON Ct.Rama = C.Cuenta
JOIN Cta Ctx ON Ctx.Rama = Ct.Cuenta
JOIN Cta Cty ON Cty.Rama = Ctx.Cuenta
LEFT OUTER JOIN CtaRazonesFinancierasExcepcionar CtaE ON CtaE.Cuenta=C.Cuenta AND Cty.Cuenta=CtaE.CuentaE
WHERE 
Ct.Cuenta = @CtaGastosFinancieros
AND CtaE.CuentaE IS NULL
UNION
SELECT DISTINCT @CtaGastosFinancieros as CuentaAgrup, CtaA.CuentaA
FROM Cta
JOIN CtaRazonesFinancierasAdicionar CtaA ON CtaA.Cuenta=Cta.Cuenta
WHERE Cta.Cuenta = @CtaGastosFinancieros
UNION
SELECT DISTINCT @CtaVentas, Ctx.Cuenta
FROM Cta C
JOIN Cta Ct ON Ct.Rama = C.Cuenta
JOIN Cta Ctx ON Ctx.Rama = Ct.Cuenta
LEFT OUTER JOIN CtaRazonesFinancierasExcepcionar CtaE ON CtaE.Cuenta=C.Cuenta AND Ctx.Cuenta=CtaE.CuentaE
WHERE C.Rama  = @CtaVentas
AND CtaE.CuentaE IS NULL
UNION
SELECT DISTINCT @CtaVentas as CuentaAgrup, CtaA.CuentaA
FROM Cta
JOIN CtaRazonesFinancierasAdicionar CtaA ON CtaA.Cuenta=Cta.Cuenta
WHERE Cta.Cuenta = @CtaVentas
UNION
SELECT DISTINCT @CtaCostoVentas, Ctx.Cuenta
FROM Cta C
JOIN Cta Ct ON Ct.Rama = C.Cuenta
JOIN Cta Ctx ON Ctx.Rama = Ct.Cuenta
LEFT OUTER JOIN CtaRazonesFinancierasExcepcionar CtaE ON CtaE.Cuenta=C.Cuenta AND Ctx.Cuenta=CtaE.CuentaE
WHERE C.Rama  = @CtaCostoVentas
AND CtaE.CuentaE IS NULL
UNION
SELECT DISTINCT @CtaCostoVentas as CuentaAgrup, CtaA.CuentaA
FROM Cta
JOIN CtaRazonesFinancierasAdicionar CtaA ON CtaA.Cuenta=Cta.Cuenta
WHERE Cta.Cuenta = @CtaCostoVentas
UNION
SELECT DISTINCT @CtaGastosOperacion, Cty.Cuenta
FROM Cta C
JOIN Cta Ct ON Ct.Rama = C.Cuenta
JOIN Cta Ctx ON Ctx.Rama = Ct.Cuenta
JOIN Cta Cty ON Cty.Rama = Ctx.Cuenta
LEFT OUTER JOIN CtaRazonesFinancierasExcepcionar CtaE ON CtaE.Cuenta=C.Cuenta AND Cty.Cuenta=CtaE.CuentaE
WHERE 
Ct.Cuenta = @CtaGastosOperacion
AND CtaE.CuentaE IS NULL
UNION
SELECT DISTINCT @CtaGastosOperacion as CuentaAgrup, CtaA.CuentaA
FROM Cta
JOIN CtaRazonesFinancierasAdicionar CtaA ON CtaA.Cuenta=Cta.Cuenta
WHERE Cta.Cuenta = @CtaGastosOperacion
UNION
SELECT DISTINCT @CtaOtrosGastosProductos, Ctx.Cuenta
FROM Cta C
JOIN Cta Ct ON Ct.Rama = C.Cuenta
JOIN Cta Ctx ON Ctx.Rama = Ct.Cuenta
LEFT OUTER JOIN CtaRazonesFinancierasExcepcionar CtaE ON CtaE.Cuenta=C.Cuenta AND Ctx.Cuenta=CtaE.CuentaE
WHERE C.Rama  = @CtaOtrosGastosProductos
AND CtaE.CuentaE IS NULL
UNION
SELECT DISTINCT @CtaOtrosGastosProductos as CuentaAgrup, CtaA.CuentaA
FROM Cta
JOIN CtaRazonesFinancierasAdicionar CtaA ON CtaA.Cuenta=Cta.Cuenta
WHERE Cta.Cuenta = @CtaOtrosGastosProductos
UNION
SELECT DISTINCT @CtaOtrosIngresos, Ctx.Cuenta
FROM Cta C
JOIN Cta Ct ON Ct.Rama = C.Cuenta
JOIN Cta Ctx ON Ctx.Rama = Ct.Cuenta
LEFT OUTER JOIN CtaRazonesFinancierasExcepcionar CtaE ON CtaE.Cuenta=C.Cuenta AND Ctx.Cuenta=CtaE.CuentaE
WHERE C.Rama  = 'U2'
AND C.Cuenta = @CtaOtrosIngresos
AND CtaE.CuentaE IS NULL
UNION
SELECT DISTINCT @CtaOtrosIngresos as CuentaAgrup, CtaA.CuentaA
FROM Cta
JOIN CtaRazonesFinancierasAdicionar CtaA ON CtaA.Cuenta=Cta.Cuenta
WHERE Cta.Cuenta = @CtaOtrosIngresos
UNION
SELECT DISTINCT @CtaProveedores, Ctx.Cuenta
FROM Cta C
JOIN Cta Ct ON Ct.Rama = C.Cuenta
JOIN Cta Ctx ON Ctx.Rama = Ct.Cuenta
LEFT OUTER JOIN CtaRazonesFinancierasExcepcionar CtaE ON CtaE.Cuenta=C.Cuenta AND Ctx.Cuenta=CtaE.CuentaE
WHERE 
C.Cuenta = @CtaProveedores
AND CtaE.CuentaE IS NULL
UNION
SELECT DISTINCT @CtaProveedores as CuentaAgrup, CtaA.CuentaA
FROM Cta
JOIN CtaRazonesFinancierasAdicionar CtaA ON CtaA.Cuenta=Cta.Cuenta
WHERE Cta.Cuenta = @CtaProveedores
UNION
SELECT DISTINCT @CtaAcreedores, Ctx.Cuenta
FROM Cta C
JOIN Cta Ct ON Ct.Rama = C.Cuenta
JOIN Cta Ctx ON Ctx.Rama = Ct.Cuenta
LEFT OUTER JOIN CtaRazonesFinancierasExcepcionar CtaE ON CtaE.Cuenta=C.Cuenta AND Ctx.Cuenta=CtaE.CuentaE
WHERE 
C.Cuenta = @CtaAcreedores
AND CtaE.CuentaE IS NULL
UNION
SELECT DISTINCT @CtaAcreedores as CuentaAgrup, CtaA.CuentaA
FROM Cta
JOIN CtaRazonesFinancierasAdicionar CtaA ON CtaA.Cuenta=Cta.Cuenta
WHERE Cta.Cuenta = @CtaAcreedores
UNION
SELECT DISTINCT @CtaImpuestosPagados, Ctx.Cuenta
FROM Cta C
JOIN Cta Ct ON Ct.Rama = C.Cuenta
JOIN Cta Ctx ON Ctx.Rama = Ct.Cuenta
LEFT OUTER JOIN CtaRazonesFinancierasExcepcionar CtaE ON CtaE.Cuenta=C.Cuenta AND Ctx.Cuenta=CtaE.CuentaE
WHERE 
C.Cuenta = @CtaImpuestosPagados
AND CtaE.CuentaE IS NULL
UNION
SELECT DISTINCT @CtaImpuestosPagados as CuentaAgrup, CtaA.CuentaA
FROM Cta
JOIN CtaRazonesFinancierasAdicionar CtaA ON CtaA.Cuenta=Cta.Cuenta
WHERE Cta.Cuenta = @CtaImpuestosPagados
UNION
SELECT DISTINCT @CtaCapitalContable, Ctx.Cuenta
FROM Cta C
JOIN Cta Ct ON Ct.Rama = C.Cuenta
JOIN Cta Ctx ON Ctx.Rama = Ct.Cuenta
LEFT OUTER JOIN CtaRazonesFinancierasExcepcionar CtaE ON CtaE.Cuenta=C.Cuenta AND Ctx.Cuenta=CtaE.CuentaE
WHERE 
Ct.Cuenta = @CtaCapitalContable
AND CtaE.CuentaE IS NULL
UNION
SELECT DISTINCT @CtaCapitalContable as CuentaAgrup, CtaA.CuentaA
FROM Cta
JOIN CtaRazonesFinancierasAdicionar CtaA ON CtaA.Cuenta=Cta.Cuenta
WHERE Cta.Cuenta = @CtaCapitalContable
UNION
SELECT DISTINCT @CtaInversionCapital, Ctx.Cuenta
FROM Cta C
JOIN Cta Ct ON Ct.Rama = C.Cuenta
JOIN Cta Ctx ON Ctx.Rama = Ct.Cuenta
LEFT OUTER JOIN CtaRazonesFinancierasExcepcionar CtaE ON CtaE.Cuenta=C.Cuenta AND Ctx.Cuenta=CtaE.CuentaE
WHERE 
C.Cuenta = @CtaInversionCapital
AND CtaE.CuentaE IS NULL
UNION
SELECT DISTINCT @CtaInversionCapital as CuentaAgrup, CtaA.CuentaA
FROM Cta
JOIN CtaRazonesFinancierasAdicionar CtaA ON CtaA.Cuenta=Cta.Cuenta
WHERE Cta.Cuenta = @CtaInversionCapital
UNION
SELECT DISTINCT @CtaCuentasPorCobrar, Ctx.Cuenta
FROM Cta C
JOIN Cta Ct ON Ct.Rama = C.Cuenta
JOIN Cta Ctx ON Ctx.Rama = Ct.Cuenta
LEFT OUTER JOIN CtaRazonesFinancierasExcepcionar CtaE ON CtaE.Cuenta=C.Cuenta AND Ctx.Cuenta=CtaE.CuentaE
WHERE 
C.Cuenta = @CtaCuentasPorCobrar
AND CtaE.CuentaE IS NULL
UNION
SELECT DISTINCT @CtaCuentasPorCobrar, /*C.Cuenta, Ct.Cuenta, Ctx.Cuenta,*/ Cty.Cuenta
FROM Cta C
JOIN Cta Ct ON Ct.Rama = C.Cuenta
JOIN Cta Ctx ON Ctx.Rama = Ct.Cuenta
JOIN Cta Cty ON Cty.Rama = Ctx.Cuenta
JOIN CtaRazonesFinancierasAdicionar CtaA ON Ct.Cuenta=CtaA.CuentaA
WHERE C.Rama  = 'B'
AND CtaA.Cuenta = @CtaCuentasPorCobrar
UNION
SELECT DISTINCT @CtaDepreAmort, Ctx.Cuenta
FROM Cta C
JOIN Cta Ct ON Ct.Rama = C.Cuenta
JOIN Cta Ctx ON Ctx.Rama = Ct.Cuenta
LEFT OUTER JOIN CtaRazonesFinancierasExcepcionar CtaE ON CtaE.Cuenta=C.Cuenta AND Ctx.Cuenta=CtaE.CuentaE
WHERE 
C.Cuenta = @CtaDepreAmort
AND CtaE.CuentaE IS NULL
UNION
SELECT DISTINCT @CtaDepreAmort, Cty.Cuenta
FROM Cta C
JOIN Cta Ct ON Ct.Rama = C.Cuenta
JOIN Cta Ctx ON Ctx.Rama = Ct.Cuenta
JOIN Cta Cty ON Cty.Rama = Ctx.Cuenta
JOIN CtaRazonesFinancierasAdicionar CtaA ON Ct.Cuenta=CtaA.CuentaA
WHERE 
CtaA.Cuenta = @CtaDepreAmort
DECLARE #crRazonesFinancieras CURSOR FOR
SELECT 'Tipo' = 'Activo', /*c.Cuenta, a.Periodo*/ tp.DescripcionPeriodo, 'Saldo' =  SUM(CASE WHEN c.EsAcreedora=1 THEN (ISNULL(a.Cargos,0)-ISNULL(a.Abonos,0))*1 ELSE ISNULL(a.Cargos,0)-ISNULL(a.Abonos,0) END)
FROM Cta c, Acum a, #TiposPeriodo tp , #CuentasAplicar ca
WHERE c.Cuenta = a.Cuenta
AND a.Rama = 'CONT'
AND a.Empresa = @Empresa
AND a.Ejercicio = @Ejercicio
AND tp.TipoPeriodo=@TipoPeriodo
AND a.Periodo BETWEEN tp.PeriodoD AND tp.PeriodoA
AND a.Moneda = @Moneda
AND ca.Cuenta=@CtaActivo
AND c.Cuenta=ca.CuentaA
AND c.EsAcumulativa = 0
AND ISNULL(c.Categoria,'') <> 'No Monetario'
GROUP BY tp.DescripcionPeriodo
UNION
SELECT 'Tipo' = 'ActivoFijo', /*a.Periodo*/ tp.DescripcionPeriodo, 'Saldo' =  SUM(CASE WHEN c.EsAcreedora=1 THEN (ISNULL(a.Cargos,0)-ISNULL(a.Abonos,0))*1 ELSE ISNULL(a.Cargos,0)-ISNULL(a.Abonos,0) END)
FROM Cta c, Acum a, #TiposPeriodo tp , #CuentasAplicar ca
WHERE c.Cuenta = a.Cuenta
AND a.Rama = 'CONT'
AND a.Empresa = @Empresa
AND a.Ejercicio = @Ejercicio
AND tp.TipoPeriodo=@TipoPeriodo
AND a.Periodo BETWEEN tp.PeriodoD AND tp.PeriodoA
AND a.Moneda = @Moneda
AND ca.Cuenta=@CtaActivoFijo
AND c.Cuenta=ca.CuentaA
AND c.EsAcumulativa = 0
AND ISNULL(c.Categoria,'') <> 'No Monetario'
GROUP BY tp.DescripcionPeriodo
UNION
SELECT 'Tipo' = 'ActivoDiferido', /*a.Periodo*/ tp.DescripcionPeriodo, 'Saldo' =  SUM(CASE WHEN c.EsAcreedora=1 THEN (ISNULL(a.Cargos,0)-ISNULL(a.Abonos,0))*1 ELSE ISNULL(a.Cargos,0)-ISNULL(a.Abonos,0) END)
FROM Cta c, Acum a, #TiposPeriodo tp , #CuentasAplicar ca
WHERE c.Cuenta = a.Cuenta
AND a.Rama = 'CONT'
AND a.Empresa = @Empresa
AND a.Ejercicio = @Ejercicio
AND tp.TipoPeriodo=@TipoPeriodo
AND a.Periodo BETWEEN tp.PeriodoD AND tp.PeriodoA
AND a.Moneda = @Moneda
AND ca.Cuenta=@CtaActivoDiferido
AND c.Cuenta=ca.CuentaA
AND c.EsAcumulativa = 0
AND ISNULL(c.Categoria,'') <> 'No Monetario'
GROUP BY tp.DescripcionPeriodo
UNION
SELECT 'Tipo' = 'Pasivo', /*a.Periodo*/ tp.DescripcionPeriodo,  'Saldo' =  SUM(CASE WHEN c.EsAcreedora=1 THEN (ISNULL(a.Cargos,0)-ISNULL(a.Abonos,0))*-1 ELSE ISNULL(a.Cargos,0)-ISNULL(a.Abonos,0) END) 
FROM Cta c, Acum a, #TiposPeriodo tp , #CuentasAplicar ca
WHERE c.Cuenta = a.Cuenta
AND a.Rama = 'CONT'
AND a.Empresa = @Empresa
AND a.Ejercicio = @Ejercicio
AND tp.TipoPeriodo=@TipoPeriodo
AND a.Periodo BETWEEN tp.PeriodoD AND tp.PeriodoA
AND a.Moneda = @Moneda
AND ca.Cuenta=@CtaPasivo
AND c.Cuenta=ca.CuentaA
AND c.EsAcumulativa = 0
GROUP BY tp.DescripcionPeriodo
UNION
SELECT 'Tipo' = 'PasivoLargoPlazo', /*a.Periodo*/ tp.DescripcionPeriodo,  'Saldo' =  SUM(CASE WHEN c.EsAcreedora=1 THEN (ISNULL(a.Cargos,0)-ISNULL(a.Abonos,0))*-1 ELSE ISNULL(a.Cargos,0)-ISNULL(a.Abonos,0) END) 
FROM Cta c, Acum a, #TiposPeriodo tp , #CuentasAplicar ca
WHERE c.Cuenta = a.Cuenta
AND a.Rama = 'CONT'
AND a.Empresa = @Empresa
AND a.Ejercicio = @Ejercicio
AND tp.TipoPeriodo=@TipoPeriodo
AND a.Periodo BETWEEN tp.PeriodoD AND tp.PeriodoA
AND a.Moneda = @Moneda
AND ca.Cuenta=@CtaPasivoLargoPlazo
AND c.Cuenta=ca.CuentaA
AND c.EsAcumulativa = 0
GROUP BY tp.DescripcionPeriodo
UNION
SELECT 'Tipo' = 'PasivoDiferido', /*a.Periodo*/ tp.DescripcionPeriodo,  'Saldo' =  SUM(CASE WHEN c.EsAcreedora=1 THEN (ISNULL(a.Cargos,0)-ISNULL(a.Abonos,0))*-1 ELSE ISNULL(a.Cargos,0)-ISNULL(a.Abonos,0) END) 
FROM Cta c, Acum a, #TiposPeriodo tp , #CuentasAplicar ca
WHERE c.Cuenta = a.Cuenta
AND a.Rama = 'CONT'
AND a.Empresa = @Empresa
AND a.Ejercicio = @Ejercicio
AND tp.TipoPeriodo=@TipoPeriodo
AND a.Periodo BETWEEN tp.PeriodoD AND tp.PeriodoA
AND a.Moneda = @Moneda
AND ca.Cuenta=@CtaPasivoDiferido
AND c.Cuenta=ca.CuentaA
AND c.EsAcumulativa = 0
GROUP BY tp.DescripcionPeriodo
UNION
SELECT 'Tipo' = 'Inventario', /*a.Periodo*/ tp.DescripcionPeriodo, 'Saldo' =  SUM(CASE WHEN c.EsAcreedora=1 THEN (ISNULL(a.Cargos,0)-ISNULL(a.Abonos,0))*1 ELSE ISNULL(a.Cargos,0)-ISNULL(a.Abonos,0) END)
FROM Cta c, Acum a, #TiposPeriodo tp , #CuentasAplicar ca
WHERE c.Cuenta = a.Cuenta
AND a.Rama = 'CONT'
AND a.Empresa = @Empresa
AND a.Ejercicio = @Ejercicio
AND tp.TipoPeriodo=@TipoPeriodo
AND a.Periodo BETWEEN tp.PeriodoD AND tp.PeriodoA
AND a.Moneda = @Moneda
AND ca.Cuenta=@CtaInventario
AND c.Cuenta=ca.CuentaA
AND c.EsAcumulativa = 0
GROUP BY tp.DescripcionPeriodo
UNION
SELECT 'Tipo' = 'Efectivo', /*a.Periodo*/ tp.DescripcionPeriodo, 'Saldo' =  SUM(CASE WHEN c.EsAcreedora=1 THEN (ISNULL(a.Cargos,0)-ISNULL(a.Abonos,0))*1 ELSE ISNULL(a.Cargos,0)-ISNULL(a.Abonos,0) END)
FROM Cta c, Acum a, #TiposPeriodo tp , #CuentasAplicar ca
WHERE c.Cuenta = a.Cuenta
AND a.Rama = 'CONT'
AND a.Empresa = @Empresa
AND a.Ejercicio = @Ejercicio
AND tp.TipoPeriodo=@TipoPeriodo
AND a.Periodo BETWEEN tp.PeriodoD AND tp.PeriodoA
AND a.Moneda = @Moneda
AND ca.Cuenta=@CtaEfectivoCaja
AND c.Cuenta=ca.CuentaA
AND c.EsAcumulativa = 0
GROUP BY tp.DescripcionPeriodo
UNION
SELECT 'Tipo' = 'Efectivo', /*a.Periodo*/ tp.DescripcionPeriodo, 'Saldo' =  SUM(CASE WHEN c.EsAcreedora=1 THEN (ISNULL(a.Cargos,0)-ISNULL(a.Abonos,0))*1 ELSE ISNULL(a.Cargos,0)-ISNULL(a.Abonos,0) END)
FROM Cta c, Acum a, #TiposPeriodo tp , #CuentasAplicar ca
WHERE c.Cuenta = a.Cuenta
AND a.Rama = 'CONT'
AND a.Empresa = @Empresa
AND a.Ejercicio = @Ejercicio
AND tp.TipoPeriodo=@TipoPeriodo
AND a.Periodo BETWEEN tp.PeriodoD AND tp.PeriodoA
AND a.Moneda = @Moneda
AND ca.Cuenta=@CtaEfectivoBanco
AND c.Cuenta=ca.CuentaA
AND c.EsAcumulativa = 0
GROUP BY tp.DescripcionPeriodo
UNION
SELECT 'Tipo' = 'Efectivo', /*a.Periodo*/ tp.DescripcionPeriodo, 'Saldo' =  SUM(CASE WHEN c.EsAcreedora=1 THEN (ISNULL(a.Cargos,0)-ISNULL(a.Abonos,0))*1 ELSE ISNULL(a.Cargos,0)-ISNULL(a.Abonos,0) END)
FROM Cta c, Acum a, #TiposPeriodo tp , #CuentasAplicar ca
WHERE c.Cuenta = a.Cuenta
AND a.Rama = 'CONT'
AND a.Empresa = @Empresa
AND a.Ejercicio = @Ejercicio
AND tp.TipoPeriodo=@TipoPeriodo
AND a.Periodo BETWEEN tp.PeriodoD AND tp.PeriodoA
AND a.Moneda = @Moneda
AND ca.Cuenta=@CtaEfectivoInversion
AND c.Cuenta=ca.CuentaA
AND c.EsAcumulativa = 0
GROUP BY tp.DescripcionPeriodo
UNION
SELECT 'Tipo' = 'Compras', /*a.Periodo*/ tp.DescripcionPeriodo, 'Saldo' =  SUM(CASE WHEN c.EsAcreedora=1 THEN (ISNULL(a.Cargos,0)-ISNULL(a.Abonos,0))*1 ELSE ISNULL(a.Cargos,0)-ISNULL(a.Abonos,0) END)
FROM Cta c, Acum a, #TiposPeriodo tp , #CuentasAplicar ca
WHERE c.Cuenta = a.Cuenta
AND a.Rama = 'CONT'
AND a.Empresa = @Empresa
AND a.Ejercicio = @Ejercicio
AND tp.TipoPeriodo=@TipoPeriodo
AND a.Periodo BETWEEN tp.PeriodoD AND tp.PeriodoA
AND a.Moneda = @Moneda
AND ca.Cuenta=@CtaCompras
AND c.Cuenta=ca.CuentaA
AND c.EsAcumulativa = 0
GROUP BY tp.DescripcionPeriodo
UNION
SELECT 'Tipo' = 'DevoCompras', /*a.Periodo*/ tp.DescripcionPeriodo, 'Saldo' =  SUM(CASE WHEN c.EsAcreedora=1 THEN (ISNULL(a.Cargos,0)-ISNULL(a.Abonos,0))*1 ELSE ISNULL(a.Cargos,0)-ISNULL(a.Abonos,0) END)
FROM Cta c, Acum a, #TiposPeriodo tp , #CuentasAplicar ca
WHERE c.Cuenta = a.Cuenta
AND a.Rama = 'CONT'
AND a.Empresa = @Empresa
AND a.Ejercicio = @Ejercicio
AND tp.TipoPeriodo=@TipoPeriodo
AND a.Periodo BETWEEN tp.PeriodoD AND tp.PeriodoA
AND a.Moneda = @Moneda
AND ca.Cuenta=@CtaDevoCompras
AND c.Cuenta=ca.CuentaA
AND c.EsAcumulativa = 0
GROUP BY tp.DescripcionPeriodo
UNION
SELECT 'Tipo' = 'GastosFinancieros', /*a.Periodo*/ tp.DescripcionPeriodo, 'Saldo' =  SUM(CASE WHEN c.EsAcreedora=1 THEN (ISNULL(a.Cargos,0)-ISNULL(a.Abonos,0))*1 ELSE ISNULL(a.Cargos,0)-ISNULL(a.Abonos,0) END)
FROM Cta c, Acum a, #TiposPeriodo tp , #CuentasAplicar ca
WHERE c.Cuenta = a.Cuenta
AND a.Rama = 'CONT'
AND a.Empresa = @Empresa
AND a.Ejercicio = @Ejercicio
AND tp.TipoPeriodo=@TipoPeriodo
AND a.Periodo BETWEEN tp.PeriodoD AND tp.PeriodoA
AND a.Moneda = @Moneda
AND ca.Cuenta=@CtaGastosFinancieros
AND c.Cuenta=ca.CuentaA
AND c.EsAcumulativa = 0
GROUP BY tp.DescripcionPeriodo
UNION
SELECT 'Tipo' = 'Ventas', /*a.Periodo*/ tp.DescripcionPeriodo, 'Saldo' =  SUM(CASE WHEN c.EsAcreedora=1 THEN (ISNULL(a.Cargos,0)-ISNULL(a.Abonos,0))*1 ELSE ISNULL(a.Cargos,0)-ISNULL(a.Abonos,0) END)
FROM Cta c, Acum a, #TiposPeriodo tp , #CuentasAplicar ca
WHERE c.Cuenta = a.Cuenta
AND a.Rama = 'CONT'
AND a.Empresa = @Empresa
AND a.Ejercicio = @Ejercicio
AND tp.TipoPeriodo=@TipoPeriodo
AND a.Periodo BETWEEN tp.PeriodoD AND tp.PeriodoA
AND a.Moneda = @Moneda
AND ca.Cuenta=@CtaVentas
AND c.Cuenta=ca.CuentaA
AND c.EsAcumulativa = 0
GROUP BY tp.DescripcionPeriodo
UNION
SELECT 'Tipo' = 'CostoVentas', /*a.Periodo*/ tp.DescripcionPeriodo, 'Saldo' =  SUM(CASE WHEN c.EsAcreedora=1 THEN (ISNULL(a.Cargos,0)-ISNULL(a.Abonos,0))*1 ELSE ISNULL(a.Cargos,0)-ISNULL(a.Abonos,0) END)
FROM Cta c, Acum a, #TiposPeriodo tp , #CuentasAplicar ca
WHERE c.Cuenta = a.Cuenta
AND a.Rama = 'CONT'
AND a.Empresa = @Empresa
AND a.Ejercicio = @Ejercicio
AND tp.TipoPeriodo=@TipoPeriodo
AND a.Periodo BETWEEN tp.PeriodoD AND tp.PeriodoA
AND a.Moneda = @Moneda
AND ca.Cuenta=@CtaCostoVentas
AND c.Cuenta=ca.CuentaA
AND c.EsAcumulativa = 0
GROUP BY tp.DescripcionPeriodo
UNION
SELECT 'Tipo' = 'GastosOperacion', /*a.Periodo*/ tp.DescripcionPeriodo, 'Saldo' =  SUM(CASE WHEN c.EsAcreedora=1 THEN (ISNULL(a.Cargos,0)-ISNULL(a.Abonos,0))*1 ELSE ISNULL(a.Cargos,0)-ISNULL(a.Abonos,0) END)
FROM Cta c, Acum a, #TiposPeriodo tp , #CuentasAplicar ca
WHERE c.Cuenta = a.Cuenta
AND a.Rama = 'CONT'
AND a.Empresa = @Empresa
AND a.Ejercicio = @Ejercicio
AND tp.TipoPeriodo=@TipoPeriodo
AND a.Periodo BETWEEN tp.PeriodoD AND tp.PeriodoA
AND a.Moneda = @Moneda
AND ca.Cuenta=@CtaGastosOperacion
AND c.Cuenta=ca.CuentaA
GROUP BY tp.DescripcionPeriodo
UNION
SELECT 'Tipo' = 'OtrosGastosProductos', /*a.Periodo*/ tp.DescripcionPeriodo, 'Saldo' =  SUM(CASE WHEN c.EsAcreedora=1 THEN (ISNULL(a.Cargos,0)-ISNULL(a.Abonos,0))*1 ELSE ISNULL(a.Cargos,0)-ISNULL(a.Abonos,0) END)
FROM Cta c, Acum a, #TiposPeriodo tp , #CuentasAplicar ca
WHERE c.Cuenta = a.Cuenta
AND a.Rama = 'CONT'
AND a.Empresa = @Empresa
AND a.Ejercicio = @Ejercicio
AND tp.TipoPeriodo=@TipoPeriodo
AND a.Periodo BETWEEN tp.PeriodoD AND tp.PeriodoA
AND a.Moneda = @Moneda
AND ca.Cuenta=@CtaOtrosGastosProductos
AND c.Cuenta=ca.CuentaA
GROUP BY tp.DescripcionPeriodo
UNION
SELECT 'Tipo' = 'OtrosIngresos', /*a.Periodo*/ tp.DescripcionPeriodo, 'Saldo' =  SUM(CASE WHEN c.EsAcreedora=1 THEN (ISNULL(a.Cargos,0)-ISNULL(a.Abonos,0))*1 ELSE ISNULL(a.Cargos,0)-ISNULL(a.Abonos,0) END)
FROM Cta c, Acum a, #TiposPeriodo tp , #CuentasAplicar ca
WHERE c.Cuenta = a.Cuenta
AND a.Rama = 'CONT'
AND a.Empresa = @Empresa
AND a.Ejercicio = @Ejercicio
AND tp.TipoPeriodo=@TipoPeriodo
AND a.Periodo BETWEEN tp.PeriodoD AND tp.PeriodoA
AND a.Moneda = @Moneda
AND ca.Cuenta=@CtaOtrosGastosProductos
AND c.Cuenta=ca.CuentaA
AND c.EsAcumulativa = 0
GROUP BY tp.DescripcionPeriodo
UNION
SELECT 'Tipo' = 'CuentasPorCobrar', /*a.Periodo*/ tp.DescripcionPeriodo, 'Saldo' =  SUM(CASE WHEN c.EsAcreedora=1 THEN (ISNULL(a.Cargos,0)-ISNULL(a.Abonos,0))*1 ELSE ISNULL(a.Cargos,0)-ISNULL(a.Abonos,0) END)
FROM Cta c, Acum a, #TiposPeriodo tp , #CuentasAplicar ca
WHERE c.Cuenta = a.Cuenta
AND a.Rama = 'CONT'
AND a.Empresa = @Empresa
AND a.Ejercicio = @Ejercicio
AND tp.TipoPeriodo=@TipoPeriodo
AND a.Periodo BETWEEN tp.PeriodoD AND tp.PeriodoA
AND a.Moneda = @Moneda
AND ca.Cuenta=@CtaCuentasPorCobrar
AND c.Cuenta=ca.CuentaA
AND c.EsAcumulativa = 0
GROUP BY tp.DescripcionPeriodo
UNION
SELECT 'Tipo' = 'Proveedores', /*a.Periodo*/ tp.DescripcionPeriodo, 'Saldo' =  SUM(CASE WHEN c.EsAcreedora=1 THEN (ISNULL(a.Cargos,0)-ISNULL(a.Abonos,0))*-1 ELSE ISNULL(a.Cargos,0)-ISNULL(a.Abonos,0) END) 
FROM Cta c, Acum a, #TiposPeriodo tp , #CuentasAplicar ca
WHERE c.Cuenta = a.Cuenta
AND a.Rama = 'CONT'
AND a.Empresa = @Empresa
AND a.Ejercicio = @Ejercicio
AND tp.TipoPeriodo=@TipoPeriodo
AND a.Periodo BETWEEN tp.PeriodoD AND tp.PeriodoA
AND a.Moneda = @Moneda
AND ca.Cuenta=@CtaProveedores
AND c.Cuenta=ca.CuentaA
AND c.EsAcumulativa = 0
GROUP BY tp.DescripcionPeriodo
UNION
SELECT 'Tipo' = 'Acreedores', /*a.Periodo*/ tp.DescripcionPeriodo, 'Saldo' =  SUM(CASE WHEN c.EsAcreedora=1 THEN (ISNULL(a.Cargos,0)-ISNULL(a.Abonos,0))*-1 ELSE ISNULL(a.Cargos,0)-ISNULL(a.Abonos,0) END) 
FROM Cta c, Acum a, #TiposPeriodo tp , #CuentasAplicar ca
WHERE c.Cuenta = a.Cuenta
AND a.Rama = 'CONT'
AND a.Empresa = @Empresa
AND a.Ejercicio = @Ejercicio
AND tp.TipoPeriodo=@TipoPeriodo
AND a.Periodo BETWEEN tp.PeriodoD AND tp.PeriodoA
AND a.Moneda = @Moneda
AND ca.Cuenta=@CtaAcreedores
AND c.Cuenta=ca.CuentaA
AND c.EsAcumulativa = 0
GROUP BY tp.DescripcionPeriodo
UNION
SELECT 'Tipo' = 'DepreciacionesAmortizaciones', /*a.Periodo*/ tp.DescripcionPeriodo, 'Saldo' =  SUM(CASE WHEN c.EsAcreedora=1 THEN (ISNULL(a.Cargos,0)-ISNULL(a.Abonos,0))*1 ELSE ISNULL(a.Cargos,0)-ISNULL(a.Abonos,0) END)
FROM Cta c, Acum a, #TiposPeriodo tp , #CuentasAplicar ca
WHERE c.Cuenta = a.Cuenta
AND a.Rama = 'CONT'
AND a.Empresa = @Empresa
AND a.Ejercicio = @Ejercicio
AND tp.TipoPeriodo=@TipoPeriodo
AND a.Periodo BETWEEN tp.PeriodoD AND tp.PeriodoA
AND a.Moneda = @Moneda
AND ca.Cuenta=@CtaDepreAmort
AND c.Cuenta=ca.CuentaA
GROUP BY tp.DescripcionPeriodo
UNION
SELECT 'Tipo' = 'ImpuestosPagados', /*a.Periodo*/ tp.DescripcionPeriodo, 'Saldo' =  SUM(CASE WHEN c.EsAcreedora=1 THEN (ISNULL(a.Cargos,0)-ISNULL(a.Abonos,0))*1 ELSE ISNULL(a.Cargos,0)-ISNULL(a.Abonos,0) END)
FROM Cta c, Acum a, #TiposPeriodo tp , #CuentasAplicar ca
WHERE c.Cuenta = a.Cuenta
AND a.Rama = 'CONT'
AND a.Empresa = @Empresa
AND a.Ejercicio = @Ejercicio
AND tp.TipoPeriodo=@TipoPeriodo
AND a.Periodo BETWEEN tp.PeriodoD AND tp.PeriodoA
AND a.Moneda = @Moneda
AND ca.Cuenta=@CtaImpuestosPagados
AND c.Cuenta=ca.CuentaA
AND c.EsAcumulativa = 0
GROUP BY tp.DescripcionPeriodo, c.EsAcreedora
UNION
SELECT 'Tipo' = 'CapitalContable', /*a.Periodo*/ tp.DescripcionPeriodo, 'Saldo' =  SUM(CASE WHEN c.EsAcreedora=1 THEN (ISNULL(a.Cargos,0)-ISNULL(a.Abonos,0))*-1 ELSE ISNULL(a.Cargos,0)-ISNULL(a.Abonos,0) END) 
FROM Cta c, Acum a, #TiposPeriodo tp , #CuentasAplicar ca
WHERE c.Cuenta = a.Cuenta
AND a.Rama = 'CONT'
AND a.Empresa = @Empresa
AND a.Ejercicio = @Ejercicio
AND tp.TipoPeriodo=@TipoPeriodo
AND a.Periodo BETWEEN tp.PeriodoD AND tp.PeriodoA
AND a.Moneda = @Moneda
AND ca.Cuenta=@CtaCapitalContable
AND c.Cuenta=ca.CuentaA
AND c.EsAcumulativa = 0
GROUP BY tp.DescripcionPeriodo
UNION
SELECT 'Tipo' = 'InversionCapital', /*a.Periodo*/ tp.DescripcionPeriodo, 'Saldo' =  SUM(CASE WHEN c.EsAcreedora=1 THEN (ISNULL(a.Cargos,0)-ISNULL(a.Abonos,0))*1 ELSE ISNULL(a.Cargos,0)-ISNULL(a.Abonos,0) END)
FROM Cta c, Acum a, #TiposPeriodo tp , #CuentasAplicar ca
WHERE c.Cuenta = a.Cuenta
AND a.Rama = 'CONT'
AND a.Empresa = @Empresa
AND a.Ejercicio = @Ejercicio
AND tp.TipoPeriodo=@TipoPeriodo
AND a.Periodo BETWEEN tp.PeriodoD AND tp.PeriodoA
AND a.Moneda = @Moneda
AND ca.Cuenta=@CtaInversionCapital
AND c.Cuenta=ca.CuentaA
AND c.EsAcumulativa = 0
GROUP BY tp.DescripcionPeriodo
OPEN #crRazonesFinancieras
FETCH NEXT FROM #crRazonesFinancieras INTO @Tipo, @DescPeriodo, @Saldo
WHILE @@FETCH_STATUS = 0
BEGIN
IF @Tipo = 'Activo'
BEGIN
UPDATE #RazonesFinancieras SET Activo = ISNULL(Activo,0) + ISNULL(@Saldo,0) WHERE DescripcionPeriodo = @DescPeriodo
IF @@ROWCOUNT = 0
INSERT INTO #RazonesFinancieras (DescripcionPeriodo, Activo) VALUES(@DescPeriodo, ISNULL(@Saldo,0))
END
ELSE
BEGIN
IF @Tipo = 'Pasivo'
BEGIN
UPDATE #RazonesFinancieras SET Pasivo = ISNULL(Pasivo,0) + ISNULL(@Saldo,0) WHERE DescripcionPeriodo = @DescPeriodo
IF @@ROWCOUNT = 0
INSERT INTO #RazonesFinancieras (DescripcionPeriodo, Pasivo) VALUES(@DescPeriodo, ISNULL(@Saldo,0))
END
END
IF @Tipo = 'ActivoFijo'
BEGIN
UPDATE #RazonesFinancieras SET ActivoFijo = ISNULL(ActivoFijo,0) + ISNULL(@Saldo,0) WHERE DescripcionPeriodo = @DescPeriodo
IF @@ROWCOUNT = 0
INSERT INTO #RazonesFinancieras (DescripcionPeriodo, ActivoFijo) VALUES(@DescPeriodo, ISNULL(@Saldo,0))
END
ELSE
BEGIN
IF @Tipo = 'ActivoDiferido'
BEGIN
UPDATE #RazonesFinancieras SET ActivoDiferido = ISNULL(ActivoDiferido,0) + ISNULL(@Saldo,0) WHERE DescripcionPeriodo = @DescPeriodo
IF @@ROWCOUNT = 0
INSERT INTO #RazonesFinancieras (DescripcionPeriodo, ActivoDiferido) VALUES(@DescPeriodo, ISNULL(@Saldo,0))
END
END
IF @Tipo = 'PasivoLargoPlazo'
BEGIN
UPDATE #RazonesFinancieras SET PasivoLargoPlazo = ISNULL(PasivoLargoPlazo,0) + ISNULL(@Saldo,0) WHERE DescripcionPeriodo = @DescPeriodo
IF @@ROWCOUNT = 0
INSERT INTO #RazonesFinancieras (DescripcionPeriodo, PasivoLargoPlazo) VALUES(@DescPeriodo, ISNULL(@Saldo,0))
END
ELSE
BEGIN
IF @Tipo = 'PasivoDiferido'
BEGIN
UPDATE #RazonesFinancieras SET PasivoDiferido = ISNULL(PasivoDiferido,0) + ISNULL(@Saldo,0) WHERE DescripcionPeriodo = @DescPeriodo
IF @@ROWCOUNT = 0
INSERT INTO #RazonesFinancieras (DescripcionPeriodo, PasivoDiferido) VALUES(@DescPeriodo, ISNULL(@Saldo,0))
END
END
IF @Tipo = 'Inventario'
BEGIN
UPDATE #RazonesFinancieras SET Inventario = ISNULL(Inventario,0) + ISNULL(@Saldo,0) WHERE DescripcionPeriodo = @DescPeriodo
IF @@ROWCOUNT = 0
INSERT INTO #RazonesFinancieras (DescripcionPeriodo, Inventario) VALUES(@DescPeriodo, ISNULL(@Saldo,0))
END
IF @Tipo = 'Efectivo'
BEGIN
UPDATE #RazonesFinancieras SET Efectivo = ISNULL(Efectivo,0) + ISNULL(@Saldo,0) WHERE DescripcionPeriodo = @DescPeriodo
IF @@ROWCOUNT = 0
INSERT INTO #RazonesFinancieras (DescripcionPeriodo, Efectivo) VALUES(@DescPeriodo, ISNULL(@Saldo,0))
END
IF @Tipo = 'Compras'
BEGIN
UPDATE #RazonesFinancieras SET Compras = ISNULL(Compras,0) + ISNULL(@Saldo,0) WHERE DescripcionPeriodo = @DescPeriodo
IF @@ROWCOUNT = 0
INSERT INTO #RazonesFinancieras (DescripcionPeriodo, Compras) VALUES(@DescPeriodo, ISNULL(@Saldo,0))
END
IF @Tipo = 'DevoCompras'
BEGIN
UPDATE #RazonesFinancieras SET DevolucionCompras = ISNULL(DevolucionCompras,0) + ISNULL(@Saldo,0) WHERE DescripcionPeriodo = @DescPeriodo
IF @@ROWCOUNT = 0
INSERT INTO #RazonesFinancieras (DescripcionPeriodo, DevolucionCompras) VALUES(@DescPeriodo, ISNULL(@Saldo,0))
END
IF @Tipo = 'GastosFinancieros'
BEGIN
UPDATE #RazonesFinancieras SET GastosFinancieros = ISNULL(GastosFinancieros,0) + ISNULL(@Saldo,0) WHERE DescripcionPeriodo = @DescPeriodo
IF @@ROWCOUNT = 0
INSERT INTO #RazonesFinancieras (DescripcionPeriodo, GastosFinancieros) VALUES(@DescPeriodo, ISNULL(@Saldo,0))
END
IF @Tipo = 'Ventas'
BEGIN
SELECT @EsAcreedora=CASE WHEN EsAcreedora=0 THEN 1 ELSE -1 END FROM Cta WHERE Cuenta=@CtaVentas
UPDATE #RazonesFinancieras SET Ventas = ISNULL(Ventas,0) + (ISNULL(@Saldo,0)*ISNULL(@EsAcreedora,1)) WHERE DescripcionPeriodo = @DescPeriodo
IF @@ROWCOUNT = 0
INSERT INTO #RazonesFinancieras (DescripcionPeriodo, Ventas) VALUES(@DescPeriodo, (ISNULL(@Saldo,0)*ISNULL(@EsAcreedora,1)))
END
IF @Tipo = 'CostoVentas'
BEGIN
UPDATE #RazonesFinancieras SET CostoVentas = ISNULL(CostoVentas,0) + ISNULL(@Saldo,0) WHERE DescripcionPeriodo = @DescPeriodo
IF @@ROWCOUNT = 0
INSERT INTO #RazonesFinancieras (DescripcionPeriodo, CostoVentas) VALUES(@DescPeriodo, ISNULL(@Saldo,0))
END
IF @Tipo = 'GastosOperacion'
BEGIN
UPDATE #RazonesFinancieras SET GastosOperacion = ISNULL(GastosOperacion,0) + ISNULL(@Saldo,0) WHERE DescripcionPeriodo = @DescPeriodo
IF @@ROWCOUNT = 0
INSERT INTO #RazonesFinancieras (DescripcionPeriodo, GastosOperacion) VALUES(@DescPeriodo, ISNULL(@Saldo,0))
END
IF @Tipo = 'OtrosGastosProductos'
BEGIN
UPDATE #RazonesFinancieras SET OtrosGastosProductos = ISNULL(OtrosGastosProductos,0) + ISNULL(@Saldo,0) WHERE DescripcionPeriodo = @DescPeriodo
IF @@ROWCOUNT = 0
INSERT INTO #RazonesFinancieras (DescripcionPeriodo, OtrosGastosProductos) VALUES(@DescPeriodo, ISNULL(@Saldo,0))
END
IF @Tipo = 'OtrosIngresos'
BEGIN
UPDATE #RazonesFinancieras SET OtrosIngresos = ISNULL(OtrosIngresos,0) + ISNULL(@Saldo,0) WHERE DescripcionPeriodo = @DescPeriodo
IF @@ROWCOUNT = 0
INSERT INTO #RazonesFinancieras (DescripcionPeriodo, OtrosIngresos) VALUES(@DescPeriodo, ISNULL(@Saldo,0))
END
IF @Tipo = 'CuentasPorCobrar'
BEGIN
UPDATE #RazonesFinancieras SET CuentasPorCobrar = ISNULL(CuentasPorCobrar,0) + ISNULL(@Saldo,0) WHERE DescripcionPeriodo = @DescPeriodo
IF @@ROWCOUNT = 0
INSERT INTO #RazonesFinancieras (DescripcionPeriodo, CuentasPorCobrar) VALUES(@DescPeriodo, ISNULL(@Saldo,0))
END
IF @Tipo = 'Proveedores'
BEGIN
UPDATE #RazonesFinancieras SET Proveedores = ISNULL(Proveedores,0) + ISNULL(@Saldo,0) WHERE DescripcionPeriodo = @DescPeriodo
IF @@ROWCOUNT = 0
INSERT INTO #RazonesFinancieras (DescripcionPeriodo, Proveedores) VALUES(@DescPeriodo, ISNULL(@Saldo,0))
END
IF @Tipo = 'Acreedores'
BEGIN
UPDATE #RazonesFinancieras SET Proveedores = ISNULL(Acreedores,0) + ISNULL(@Saldo,0) WHERE DescripcionPeriodo = @DescPeriodo
IF @@ROWCOUNT = 0
INSERT INTO #RazonesFinancieras (DescripcionPeriodo, Acreedores) VALUES(@DescPeriodo, ISNULL(@Saldo,0))
END
IF @Tipo = 'DepreciacionesAmortizaciones'
BEGIN
UPDATE #RazonesFinancieras SET DepreciacionesAmortizaciones = ISNULL(DepreciacionesAmortizaciones,0) + @Saldo WHERE DescripcionPeriodo = @DescPeriodo
IF @@ROWCOUNT = 0
INSERT INTO #RazonesFinancieras (DescripcionPeriodo, DepreciacionesAmortizaciones) VALUES(@DescPeriodo, ISNULL(@Saldo,0))
END
IF @Tipo = 'ImpuestosPagados'
BEGIN
UPDATE #RazonesFinancieras SET ImpuestosPagados = ISNULL(ImpuestosPagados,0) + ISNULL(@Saldo,0) WHERE DescripcionPeriodo = @DescPeriodo
IF @@ROWCOUNT = 0
INSERT INTO #RazonesFinancieras (DescripcionPeriodo, ImpuestosPagados) VALUES(@DescPeriodo, ISNULL(@Saldo,0))
END
IF @Tipo = 'CapitalContable'
BEGIN
UPDATE #RazonesFinancieras SET CapitalContable = ISNULL(CapitalContable,0) + ISNULL(@Saldo,0) WHERE DescripcionPeriodo = @DescPeriodo
IF @@ROWCOUNT = 0
INSERT INTO #RazonesFinancieras (DescripcionPeriodo, CapitalContable) VALUES(@DescPeriodo, ISNULL(@Saldo,0))
END
IF @Tipo = 'InversionCapital'
BEGIN
UPDATE #RazonesFinancieras SET InversionCapital = ISNULL(InversionCapital,0) + ISNULL(@Saldo,0) WHERE DescripcionPeriodo = @DescPeriodo
IF @@ROWCOUNT = 0
INSERT INTO #RazonesFinancieras (DescripcionPeriodo, InversionCapital) VALUES(@DescPeriodo, ISNULL(@Saldo,0))
END
UPDATE #RazonesFinancieras
SET RazonCirculante = ISNULL(Activo,0)/(CASE WHEN ISNULL(Pasivo,1)=0 THEN 1 ELSE ISNULL(Pasivo,1) END),
RazonAcida=  (ISNULL(Activo,0)-ISNULL(Inventario,0))/CASE WHEN ISNULL(Pasivo,1)=0 THEN 1 ELSE ISNULL(Pasivo,1) END,
RazonEfectivo=  ISNULL(Efectivo,0)/(CASE WHEN ISNULL(Pasivo,1)=0 THEN 1 ELSE ISNULL(Pasivo,1) END),
CapitalTrabajo=ISNULL(Activo,0)-ISNULL(Pasivo,0),
CapitalTrabajo2=(ISNULL(Activo,0)-ISNULL(Pasivo,0))/CASE WHEN ISNULL(Activo,0)+ISNULL(ActivoFijo,0)+ISNULL(ActivoDiferido,0)=0 THEN 1 ELSE ISNULL(Activo,0)+ISNULL(ActivoFijo,0)+ISNULL(ActivoDiferido,0) END,
MedicionIntervaloTiempo=ISNULL(Activo,0)/CASE WHEN ISNULL(Compras,0)-ISNULL(DevolucionCompras,0)=0 THEN 1 ELSE ISNULL(Compras,0)-ISNULL(DevolucionCompras,0) END,
TotalDeuda=ISNULL(Pasivo,0)+ISNULL(PasivoLargoPlazo,0), 
ActivoTotal=ISNULL(Activo,0)+ ISNULL(ActivoFijo,0)+ISNULL(ActivoDiferido,0),
PasivoTotal=ISNULL(Pasivo,0)+ISNULL(PasivoLargoPlazo,0)+ISNULL(PasivoDiferido,0),
UtilidadAntesImpuestosIntereses = Ventas-ISNULL(CostoVentas,0)-ISNULL(GastosOperacion,0), 
UtilidadBruta=(Ventas-ISNULL(CostoVentas,0)),
UtilidadOperacion=(Ventas-CostoVentas)-GastosOperacion,
RelacionFlujoCajaOperativo=(Ventas+CostoVentas+GastosOperacion)/CASE WHEN ISNULL(Pasivo,0)+ISNULL(PasivoLargoPlazo,0)=0 THEN 1 ELSE ISNULL(Pasivo,0)+ISNULL(PasivoLargoPlazo,0) END
WHERE DescripcionPeriodo = @DescPeriodo
UPDATE #RazonesFinancieras
SET
UAFIR=UtilidadAntesImpuestosIntereses,
UAFIRDA = UtilidadAntesImpuestosIntereses-ISNULL(OtrosGastosProductos,0)+ISNULL(DepreciacionesAmortizaciones,0), 
RelacionFlujoCajaOperativo=(Ventas+CostoVentas+GastosOperacion)/CASE WHEN ISNULL(Pasivo,0)+ISNULL(PasivoLargoPlazo,0)=0 THEN 1 ELSE ISNULL(Pasivo,0)+ISNULL(PasivoLargoPlazo,0) END
WHERE DescripcionPeriodo = @DescPeriodo
UPDATE #RazonesFinancieras
SET AplacamientoTotal=PasivoTotal/CASE WHEN ActivoTotal=0 THEN 1 ELSE ActivoTotal END,
AplacamientoCostoTotal=(Pasivo+ISNULL(PasivoLargoPlazo,0))/CASE WHEN ActivoTotal=0 THEN 1 ELSE ActivoTotal END,
AplacamientoCortoPlazo=Pasivo/CASE WHEN ActivoTotal=0 THEN 1 ELSE ActivoTotal END,
AplacamientoLargoPlazo=ISNULL(PasivoLargoPlazo,0)/CASE WHEN ActivoTotal=0 THEN 1 ELSE ActivoTotal END,
CoberturaGastosFinancieros=UAFIR/CASE WHEN GastosFinancieros=0 THEN 1 ELSE GastosFinancieros END,
CoberturaEfectivo=UAFIRDA/CASE WHEN GastosFinancieros=0 THEN 1 ELSE GastosFinancieros END
WHERE DescripcionPeriodo = @DescPeriodo
UPDATE #RazonesFinancieras
SET RotacionInventarios=CostoVentas/CASE WHEN Inventario=0 THEN 1 ELSE Inventario END,
DiasInventarios=365.00/CASE WHEN (CostoVentas/CASE WHEN Inventario=0 THEN 1 ELSE Inventario END )=0 THEN 1 ELSE CostoVentas/CASE WHEN Inventario=0 THEN 1 ELSE Inventario END END,
RotacionCxc=Ventas/CASE WHEN CuentasPorCobrar=0 THEN 1 ELSE CuentasPorCobrar END,
DiasCxc=365.00/(Ventas/CASE WHEN CuentasPorCobrar=0 THEN 1 ELSE CuentasPorCobrar END),
RotacionCxp=CostoVentas/CASE WHEN Proveedores+Acreedores=0 THEN 1 ELSE Proveedores+Acreedores END
WHERE DescripcionPeriodo = @DescPeriodo
UPDATE #RazonesFinancieras
SET 
DiasCxp=CASE WHEN RotacionCxp<>0 THEN 365.00/RotacionCxp ELSE 0 END,
RotacionTotalActivos=Ventas/CASE WHEN ActivoTotal=0 THEN 1 ELSE ActivoTotal END,
RotacionActivosFijos=Ventas/CASE WHEN ActivoFijo=0 THEN 1 ELSE ActivoFijo END
WHERE DescripcionPeriodo = @DescPeriodo
UPDATE #RazonesFinancieras
SET MargenNeto=(UtilidadAntesImpuestosIntereses-ISNULL(ImpuestosPagados,0))/CASE WHEN Ventas=0 THEN 1 ELSE Ventas END,
RendimientoSobreActivos=(UtilidadAntesImpuestosIntereses-ISNULL(ImpuestosPagados,0))/CASE WHEN ActivoTotal=0 THEN 1 ELSE ActivoTotal END,
RendimientoSobreCapital=CASE WHEN ISNULL(CapitalContable,0)<>0 THEN (UtilidadAntesImpuestosIntereses-ISNULL(ImpuestosPagados,0))/ISNULL(CapitalContable,0) ELSE 0 END,
MargenBruto=UtilidadBruta/CASE WHEN Ventas<=0 THEN 1 ELSE Ventas END,
MargenOperativo=UAFIR/CASE WHEN Ventas=0 THEN 1 ELSE Ventas END,
MargenUAFIRDA=UAFIRDA/CASE WHEN Ventas=0 THEN 1 ELSE Ventas END,
ROIC=CASE WHEN ISNULL(InversionCapital,0)<>0 THEN (UAFIRDA-ISNULL(ImpuestosPagados,0))/ISNULL(InversionCapital,0) ELSE 0 END
WHERE DescripcionPeriodo = @DescPeriodo
FETCH NEXT FROM #crRazonesFinancieras INTO @Tipo, @DescPeriodo, @Saldo
END
CLOSE #crRazonesFinancieras
DEALLOCATE #crRazonesFinancieras
SELECT *
FROM #RazonesFinancieras
END

