SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spDineroAcum
@EstacionTrabajo		int

AS BEGIN
DECLARE
@Empresa					varchar(5),
@CtaDineroD				varchar(10),
@CtaDineroA				varchar(10),
@Moneda					varchar(10),
@Ejercicio				int,
@Titulo					varchar(100),
@Usuario					varchar(10),
@MonedaInicial			varchar(10),
@CuentaInicial			varchar(10),
@AcumMoneda				varchar(10),
@AcumCuenta				varchar(10),
@EjercicioCursor			int,
@PeriodoCursor			int,
@Cargos					float,
@Abonos					float,
@CargosAcumulados			float,
@AbonosAcumulados			float,
@SaldoFinalAcumulado		float,
@CargosMC					float,
@AbonosMC					float,
@CargosAcumuladosMC		float,
@AbonosAcumuladosMC		float,
@SaldoFinalAcumuladoMC	float,
@ID						int,
@Descripcion				varchar(100),
@Rama						varchar(10),
@ContMoneda				varchar(10),
@EmpresaNombre			varchar(100),
@VerGraficaDetalle		bit
SELECT
@Empresa		=	InfoEmpresa,
@CtaDineroD		=   ISNULL(InfoCtaDineroD,''),
@CtaDineroA		=   ISNULL(InfoCtaDineroA,''),
@Moneda         =	CASE WHEN InfoMoneda IN( '(Todas)', '') THEN NULL ELSE InfoMoneda END,
@Ejercicio		=   InfoEjercicio,
@Titulo         =   InfoTitulo,
@Usuario        =   InfoUsuario,
@VerGraficaDetalle = ISNULL(VerGraficaDetalle,0)
FROM RepParam
WHERE Estacion = @EstacionTrabajo
SELECT @EmpresaNombre = Nombre FROM Empresa WHERE Empresa = @Empresa
DECLARE @Datos TABLE
(
Estacion					int NOT NULL,
ID						int identity(1,1) NOT NULL,
CtaDinero				varchar(10) COLLATE DATABASE_DEFAULT NULL,
Descripcion				varchar(100) COLLATE DATABASE_DEFAULT NULL,
Tipo						varchar(20) COLLATE DATABASE_DEFAULT NULL,
Uso						varchar(20) COLLATE DATABASE_DEFAULT NULL,
NumeroCta				varchar(100) COLLATE DATABASE_DEFAULT NULL,
CuentaHabiente			varchar(100) COLLATE DATABASE_DEFAULT NULL,
Moneda					varchar(10) COLLATE DATABASE_DEFAULT NULL,
Beneficiario				int NULL,
Estatus					varchar(15) COLLATE DATABASE_DEFAULT NULL,
UltimoCambio				datetime NULL,
Alta						datetime NULL,
Conciliar				bit NULL,
Mensaje					varchar(50) COLLATE DATABASE_DEFAULT NULL,
Sucursal					int NULL,
Empresa					varchar(5) COLLATE DATABASE_DEFAULT NULL,
Rama						varchar(5) COLLATE DATABASE_DEFAULT NULL,
Cuenta					varchar(20) COLLATE DATABASE_DEFAULT NULL,
SubCuenta				varchar(50) COLLATE DATABASE_DEFAULT NULL,
Grupo					varchar(10) COLLATE DATABASE_DEFAULT NULL,
Ejercicio				int NULL,
Periodo					int NULL,
PeriodoNombre			varchar(50) COLLATE DATABASE_DEFAULT NULL,
Cargos					float NULL,
Abonos					float NULL,
CargosMC					float NULL,
AbonosMC					float NULL,
AcumUltimoCambio			datetime NULL,
AcumMoneda				varchar(10) COLLATE DATABASE_DEFAULT NULL,
SaldoFinal				float NULL,
CargosAcumulados			float NULL,
AbonosAcumulados			float NULL,
SaldoFinalMC				float NULL,
CargosAcumuladosMC		float NULL,
AbonosAcumuladosMC		float NULL,
ContMoneda				varchar(10) NULL,
Grafica					int NULL DEFAULT 0,
FiltroCtaDineroD			varchar(10) COLLATE DATABASE_DEFAULT NULL,
FiltroCtaDineroA			varchar(10) COLLATE DATABASE_DEFAULT NULL,
FiltroMoneda				varchar(10) COLLATE DATABASE_DEFAULT NULL,
FiltroEjercicio			int NULL,
EmpresaNombre			varchar(100) COLLATE DATABASE_DEFAULT NULL
)
INSERT @Datos (Estacion, CtaDinero, Descripcion, Tipo, Uso, NumeroCta, CuentaHabiente, Moneda, Beneficiario, Estatus, UltimoCambio, Alta, Conciliar, Mensaje, Sucursal, Empresa, Rama, Cuenta, SubCuenta, Grupo, Ejercicio, Periodo, PeriodoNombre, Cargos, Abonos, CargosMC, AbonosMC, AcumUltimoCambio, AcumMoneda, ContMoneda, Grafica, FiltroCtaDineroD, FiltroCtaDineroA, FiltroMoneda, FiltroEjercicio, EmpresaNombre)
SELECT
@EstacionTrabajo,
RTRIM(CtaDinero.CtaDinero),
RTRIM(CtaDinero.Descripcion),
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
Acum.Empresa,
Acum.Rama,
Acum.Cuenta,
NULL,
NULL,
@Ejercicio,
0,
RTRIM(dbo.fnIdiomaTraducir(@Usuario,'Saldo Inicial')),
SUM(ISNULL(Acum.Cargos,0.0)),
SUM(ISNULL(Acum.Abonos,0.0)),
dbo.fnImporteAMonedaContable(SUM(ISNULL(Acum.Cargos,0.0)),ISNULL(Mon.TipoCambio,1.0),RTRIM(EmpresaCfg.ContMoneda)),
dbo.fnImporteAMonedaContable(SUM(ISNULL(Acum.Abonos,0.0)),ISNULL(Mon.TipoCambio,1.0),RTRIM(EmpresaCfg.ContMoneda)),
NULL,
RTRIM(Acum.Moneda),
RTRIM(EmpresaCfg.ContMoneda),
1,
ISNULL(@CtaDineroD,''),
ISNULL(@CtaDineroA,''),
ISNULL(@Moneda,'(Todas)'),
@Ejercicio,
@EmpresaNombre
FROM
CtaDinero JOIN Acum
ON @Empresa =Acum.Empresa AND 'DIN'=Acum.Rama AND CtaDinero.CtaDinero=Acum.Cuenta JOIN Mon
ON Mon.Moneda = Acum.Moneda JOIN EmpresaCfg
ON Acum.Empresa = EmpresaCfg.Empresa
WHERE Acum.Ejercicio < @Ejercicio
AND Acum.Cuenta BETWEEN @CtaDineroD AND @CtaDineroA
AND Acum.Moneda = ISNULL(@Moneda,Acum.Moneda)
GROUP BY RTRIM(CtaDinero.CtaDinero), RTRIM(CtaDinero.Descripcion), Acum.Empresa, Acum.Rama, Acum.Cuenta, RTRIM(Acum.Moneda), Mon.TipoCambio, RTRIM(EmpresaCfg.ContMoneda)
INSERT @Datos (Estacion, CtaDinero, Descripcion, Tipo, Uso, NumeroCta, CuentaHabiente, Moneda, Beneficiario, Estatus, UltimoCambio, Alta, Conciliar, Mensaje, Sucursal, Empresa, Rama, Cuenta, SubCuenta, Grupo, Ejercicio, Periodo, PeriodoNombre, Cargos, Abonos, CargosMC, AbonosMC, AcumUltimoCambio, AcumMoneda, ContMoneda, Grafica, FiltroCtaDineroD, FiltroCtaDineroA, FiltroMoneda, FiltroEjercicio, EmpresaNombre)
SELECT
@EstacionTrabajo,
RTRIM(CtaDinero.CtaDinero),
RTRIM(CtaDinero.Descripcion),
CtaDinero.Tipo,
CtaDinero.Uso,
CtaDinero.NumeroCta,
CtaDinero.CuentaHabiente,
CtaDinero.Moneda,
CtaDinero.Beneficiario,
CtaDinero.Estatus,
CtaDinero.UltimoCambio,
CtaDinero.Alta,
CtaDinero.Conciliar,
CtaDinero.Mensaje,
Acum.Sucursal,
Acum.Empresa,
Acum.Rama,
Acum.Cuenta,
Acum.SubCuenta,
Acum.Grupo,
Acum.Ejercicio,
Acum.Periodo,
dbo.fnPeriodoNombre(Acum.Periodo,@Usuario),
Acum.Cargos,
Acum.Abonos,
dbo.fnImporteAMonedaContable(ISNULL(Acum.Cargos,0.0),ISNULL(Mon.TipoCambio,1.0),EmpresaCfg.ContMoneda),
dbo.fnImporteAMonedaContable(ISNULL(Acum.Abonos,0.0),ISNULL(Mon.TipoCambio,1.0),EmpresaCfg.ContMoneda),
Acum.UltimoCambio,
RTRIM(Acum.Moneda),
RTRIM(EmpresaCfg.ContMoneda),
1,
ISNULL(@CtaDineroD,''),
ISNULL(@CtaDineroA,''),
ISNULL(@Moneda,'(Todas)'),
@Ejercicio,
@EmpresaNombre
FROM
CtaDinero JOIN Acum
ON @Empresa =Acum.Empresa AND 'DIN'=Acum.Rama AND CtaDinero.CtaDinero=Acum.Cuenta JOIN Mon
ON Mon.Moneda = Acum.Moneda JOIN EmpresaCfg
ON Acum.Empresa = EmpresaCfg.Empresa
WHERE Acum.Ejercicio = @Ejercicio
AND Acum.Cuenta BETWEEN @CtaDineroD AND @CtaDineroA
AND Acum.Moneda = ISNULL(@Moneda,Acum.Moneda)
DECLARE crDatos CURSOR FOR
SELECT RTRIM(Cuenta), RTRIM(AcumMoneda), RTRIM(ContMoneda), RTRIM(Descripcion), Rama
FROM @Datos
GROUP BY Cuenta, AcumMoneda, ContMoneda, Descripcion, Rama
ORDER BY Cuenta, AcumMoneda, ContMoneda, Descripcion, Rama
OPEN crDatos
FETCH NEXT FROM crDatos INTO @AcumCuenta, @AcumMoneda, @ContMoneda, @Descripcion, @Rama
WHILE @@FETCH_STATUS = 0
BEGIN
IF NOT EXISTS(SELECT 1 FROM @Datos WHERE Cuenta = @AcumCuenta AND AcumMoneda = @AcumMoneda AND ContMoneda = @ContMoneda AND PeriodoNombre = dbo.fnIdiomaTraducir(@Usuario,'Saldo Inicial'))
BEGIN
INSERT @Datos (Estacion,         CtaDinero,   Descripcion,  Empresa,  Rama,  Cuenta,      Ejercicio,  Periodo, PeriodoNombre,                                  Cargos, Abonos, CargosMC, AbonosMC, AcumMoneda,  ContMoneda,  Grafica, FiltroCtaDineroD,       FiltroCtaDineroA,       FiltroMoneda,              FiltroEjercicio, EmpresaNombre)
VALUES (@EstacionTrabajo, @AcumCuenta, @Descripcion, @Empresa, @Rama, @AcumCuenta, @Ejercicio, 0,       dbo.fnIdiomaTraducir(@Usuario,'Saldo Inicial'), 0.0,    0.0,    0.0,      0.0,      @AcumMoneda, @ContMoneda, 1,       ISNULL(@CtaDineroD,''), ISNULL(@CtaDineroA,''), ISNULL(@Moneda,'(Todas)'), @Ejercicio,      @EmpresaNombre)
END
FETCH NEXT FROM crDatos INTO @AcumCuenta, @AcumMoneda, @ContMoneda, @Descripcion, @Rama
END
CLOSE crDatos
DEALLOCATE crDatos
SELECT @MonedaInicial = '', @CuentaInicial = '', @CargosAcumulados = 0.0, @AbonosAcumulados = 0.0, @SaldoFinalAcumuladoMC = 0.0, @CargosAcumuladosMC = 0.0, @AbonosAcumuladosMC = 0.0, @SaldoFinalAcumuladoMC = 0.0
DECLARE crDineroAcum CURSOR FOR
SELECT ID, AcumMoneda, Cuenta, Ejercicio, Periodo, ISNULL(Cargos,0.0), ISNULL(Abonos,0.0), ISNULL(CargosMC,0.0), ISNULL(AbonosMC,0.0)
FROM @Datos
ORDER BY AcumMoneda, Cuenta, Ejercicio, Periodo
OPEN crDineroAcum
FETCH NEXT FROM crDineroAcum INTO @ID, @AcumMoneda, @AcumCuenta, @EjercicioCursor, @PeriodoCursor, @Cargos, @Abonos, @CargosMC, @AbonosMC
WHILE @@FETCH_STATUS = 0
BEGIN
IF @AcumMoneda <> @MonedaInicial OR @AcumCuenta <> @CuentaInicial
BEGIN
SET @CargosAcumulados = 0.0
SET @AbonosAcumulados = 0.0
SET @CargosAcumuladosMC = 0.0
SET @AbonosAcumuladosMC = 0.0
SET @SaldoFinalAcumulado = 0.0
SET @MonedaInicial = @AcumMoneda
SET @CuentaInicial = @AcumCuenta
END
UPDATE @Datos
SET
SaldoFinal = @SaldoFinalAcumulado + (@Cargos - @Abonos),
CargosAcumulados = @CargosAcumulados + @Cargos,
AbonosAcumulados = @AbonosAcumulados + @Abonos,
SaldoFinalMC = @SaldoFinalAcumuladoMC + (@CargosMC - @AbonosMC),
CargosAcumuladosMC = @CargosAcumuladosMC + @CargosMC,
AbonosAcumuladosMC = @AbonosAcumuladosMC + @AbonosMC
WHERE ID = @ID
SET @SaldoFinalAcumulado = @SaldoFinalAcumulado + (@Cargos - @Abonos)
SET @CargosAcumulados = @CargosAcumulados + @Cargos
SET @AbonosAcumulados = @AbonosAcumulados + @Abonos
SET @SaldoFinalAcumuladoMC = @SaldoFinalAcumuladoMC + (@CargosMC - @AbonosMC)
SET @CargosAcumuladosMC = @CargosAcumuladosMC + @CargosMC
SET @AbonosAcumuladosMC = @AbonosAcumuladosMC + @AbonosMC
FETCH NEXT FROM crDineroAcum INTO @ID, @AcumMoneda, @AcumCuenta, @EjercicioCursor, @PeriodoCursor, @Cargos, @Abonos, @CargosMC, @AbonosMC
END
CLOSE crDineroAcum
DEALLOCATE crDineroAcum
INSERT @Datos (Estacion, CtaDinero, Descripcion, Tipo, Uso, NumeroCta, CuentaHabiente, Moneda, Beneficiario, Estatus, UltimoCambio, Alta, Conciliar, Mensaje, Sucursal, Empresa, Rama, Cuenta, SubCuenta, Grupo, Ejercicio, Periodo, PeriodoNombre, Cargos, Abonos, CargosMC, AbonosMC, AcumUltimoCambio, AcumMoneda, ContMoneda, Grafica)
SELECT
Estacion,
CtaDinero,
Descripcion,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
Empresa,
Rama,
Cuenta,
NULL,
NULL,
Ejercicio,
Periodo,
PeriodoNombre,
NULL,
NULL,
SUM(CargosMC),
SUM(AbonosMC),
NULL,
AcumMoneda,
ContMoneda,
2
FROM
@Datos
GROUP BY Estacion, CtaDinero, Descripcion, Empresa, Rama, Cuenta, Ejercicio, Periodo, PeriodoNombre, AcumMoneda, ContMoneda
ORDER BY Periodo
SELECT @MonedaInicial = '', @CuentaInicial = '', @SaldoFinalAcumuladoMC = 0.0, @CargosAcumuladosMC = 0.0, @AbonosAcumuladosMC = 0.0, @SaldoFinalAcumuladoMC = 0.0
DECLARE crDineroAcum CURSOR FOR
SELECT ID, AcumMoneda, Cuenta, Ejercicio, Periodo, ISNULL(CargosMC,0.0), ISNULL(AbonosMC,0.0)
FROM @Datos
WHERE Grafica = 2
ORDER BY AcumMoneda, Cuenta, Ejercicio, Periodo
OPEN crDineroAcum
FETCH NEXT FROM crDineroAcum INTO @ID, @AcumMoneda, @AcumCuenta, @EjercicioCursor, @PeriodoCursor, @CargosMC, @AbonosMC
WHILE @@FETCH_STATUS = 0
BEGIN
IF @AcumMoneda <> @MonedaInicial OR @AcumCuenta <> @CuentaInicial
BEGIN
SET @CargosAcumuladosMC = 0.0
SET @AbonosAcumuladosMC = 0.0
SET @SaldoFinalAcumuladoMC = 0.0
SET @MonedaInicial = @AcumMoneda
SET @CuentaInicial = @AcumCuenta
END
UPDATE @Datos
SET
SaldoFinalMC = @SaldoFinalAcumuladoMC + (@CargosMC - @AbonosMC),
CargosAcumuladosMC = @CargosAcumuladosMC + @CargosMC,
AbonosAcumuladosMC = @AbonosAcumuladosMC + @AbonosMC
WHERE ID = @ID
SET @SaldoFinalAcumuladoMC = @SaldoFinalAcumuladoMC + (@CargosMC - @AbonosMC)
SET @CargosAcumuladosMC = @CargosAcumuladosMC + @CargosMC
SET @AbonosAcumuladosMC = @AbonosAcumuladosMC + @AbonosMC
FETCH NEXT FROM crDineroAcum INTO @ID, @AcumMoneda, @AcumCuenta, @EjercicioCursor, @PeriodoCursor, @CargosMC, @AbonosMC
END
CLOSE crDineroAcum
DEALLOCATE crDineroAcum
SELECT AcumMoneda, CtaDinero, Descripcion, Ejercicio, Periodo, PeriodoNombre, Cargos, Abonos, SaldoFinal, CargosAcumulados, AbonosAcumulados, CargosMC, AbonosMC, SaldoFinalMC, CargosAcumuladosMC, AbonosAcumuladosMC, ContMoneda, Grafica, FiltroCtaDineroD, FiltroCtaDineroA, FiltroMoneda, FiltroEjercicio, EmpresaNombre, @VerGraficaDetalle as VerGraficaDetalle
FROM @Datos
ORDER BY Grafica, Moneda, CtaDinero, Periodo, Ejercicio
END

