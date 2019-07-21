SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spDineroAux
@EstacionTrabajo		int

AS BEGIN
DECLARE
@InfoEmpresa				varchar(5),
@InfoCtaDineroD			varchar(10),
@InfoCtaDineroA			varchar(10),
@InfoFechaD				datetime,
@InfoFechaA				datetime,
@InfoUso					varchar(20),
@InfoMov					varchar(20),
@InfoNivel				varchar(20),
@InfoMoneda				varchar(10),
@InfoTitulo				varchar(100),
@InfoUsuario				varchar(10),
@MonedaInicial			varchar(10),
@CuentaInicial			varchar(10),
@MovInicial				varchar(20),
@ID						int,
@Moneda					varchar(10),
@Cuenta					varchar(10),
@Fecha					datetime,
@Cargos					float,
@Abonos					float,
@CargosMC					float,
@AbonosMC					float,
@Saldo					float,
@SaldoMC					float,
@Mov						varchar(20),
@MovTotalCargos			float,
@MovTotalAbonos			float,
@MovTotalCargosMC			float,
@MovTotalAbonosMC			float,
@ContMoneda				varchar(10),
@InformeGraficarTipo		varchar(30),
@InformeGraficarCantidad	int,
@EmpresaNombre			varchar(100),
@Positivo					integer,
@VerGraficaDetalle		bit
SELECT
@InfoEmpresa		     =	 InfoEmpresa,
@InfoCtaDineroD		     =   ISNULL(InfoCtaDineroD,''),
@InfoCtaDineroA		     =   ISNULL(InfoCtaDineroA,''),
@InfoFechaD			     =   dbo.fnFechaSinHora(InfoFechaD),
@InfoFechaA			     =   dbo.fnFechaSinHora(InfoFechaA),
@InfoUso			     =	 CASE WHEN InfoUso IN( '(Todos)', '') THEN NULL ELSE InfoUso END,
@InfoMov			     =	 CASE WHEN InfoMov IN( '(Todos)', '') THEN NULL ELSE InfoMov END,
@InfoNivel			     =   ISNULL(InfoNivel,'Desglosado'),
@InfoMoneda			     =	 CASE WHEN InfoMoneda IN( '(Todas)', '') THEN NULL ELSE InfoMoneda END,
@InfoTitulo			     =   ISNULL(InfoTitulo,dbo.fnIdiomaTraducir(@InfoUsuario,'Tesorería - Auxiliar Movimientos Desglosado')),
@InfoUsuario		     =   InfoUsuario,
@InformeGraficarTipo     =   ISNULL(InformeGraficarTipo,'(Todos)'),
@InformeGraficarCantidad =   ISNULL(NULLIF(InformeGraficarCantidad,0),5),
@VerGraficaDetalle = ISNULL(VerGraficaDetalle,0)
FROM RepParam
WHERE Estacion = @EstacionTrabajo
SELECT @ContMoneda = ContMoneda FROM EmpresaCfg WHERE Empresa = @InfoEmpresa
SELECT @EmpresaNombre = Nombre FROM Empresa WHERE Empresa = @InfoEmpresa
DECLARE @Datos TABLE
(
Estacion					int NOT NULL,
ID						int identity(1,1) NOT NULL,
CtaDinero				varchar(10) COLLATE DATABASE_DEFAULT NULL,
NumeroCta				varchar(100) COLLATE DATABASE_DEFAULT NULL,
Descripcion				varchar(100) COLLATE DATABASE_DEFAULT NULL,
Tipo						varchar(20) COLLATE DATABASE_DEFAULT NULL,
Uso						varchar(20) COLLATE DATABASE_DEFAULT NULL,
Moneda					varchar(10) COLLATE DATABASE_DEFAULT NULL,
TipoCambio				float NULL,
Beneficiario				varchar(100) COLLATE DATABASE_DEFAULT NULL,
Fecha					datetime NULL,
Movimiento				varchar(50) COLLATE DATABASE_DEFAULT NULL,
Cargos					float NULL,
Abonos					float NULL,
Saldo					float NULL,
CargosMC					float NULL,
AbonosMC					float NULL,
SaldoMC					float NULL,
EsCancelacion			bit NULL DEFAULT 0,
Grafica					int NULL DEFAULT 0,
GraficaArgumento			varchar(20) COLLATE DATABASE_DEFAULT NULL,
GraficaValor1			float,
GraficaValor2			float,
GraficaValor3			float,
GraficaValor4			float,
GraficaPositivo			integer NULL DEFAULT 0,
Titulo					varchar(50) COLLATE DATABASE_DEFAULT NULL,
ContMoneda				varchar(10) COLLATE DATABASE_DEFAULT NULL,
FiltroEmpresa			varchar(100) COLLATE DATABASE_DEFAULT NULL,
FiltroCtaDineroD			varchar(10) COLLATE DATABASE_DEFAULT NULL,
FiltroCtaDineroA			varchar(10) COLLATE DATABASE_DEFAULT NULL,
FiltroFechaD				datetime NULL,
FiltroFechaA				datetime NULL,
FiltroUso				varchar(20) COLLATE DATABASE_DEFAULT NULL,
FiltroMov				varchar(20) COLLATE DATABASE_DEFAULT NULL,
FiltroNivel				varchar(20) COLLATE DATABASE_DEFAULT NULL,
FiltroMoneda				varchar(10) COLLATE DATABASE_DEFAULT NULL,
FiltroGraficarTipo		varchar(30) COLLATE DATABASE_DEFAULT NULL,
FiltroGraficarCantidad	int NULL
)
DECLARE @DatosGrafica TABLE
(
Estacion					int NOT NULL,
ID						int identity(1,1) NOT NULL,
CtaDinero				varchar(10) COLLATE DATABASE_DEFAULT NULL,
NumeroCta				varchar(100) COLLATE DATABASE_DEFAULT NULL,
Descripcion				varchar(100) COLLATE DATABASE_DEFAULT NULL,
Tipo						varchar(20) COLLATE DATABASE_DEFAULT NULL,
Uso						varchar(20) COLLATE DATABASE_DEFAULT NULL,
Moneda					varchar(10) COLLATE DATABASE_DEFAULT NULL,
TipoCambio				float NULL,
Beneficiario				varchar(100) COLLATE DATABASE_DEFAULT NULL,
Fecha					datetime NULL,
Movimiento				varchar(50) COLLATE DATABASE_DEFAULT NULL,
Cargos					float NULL,
Abonos					float NULL,
Saldo					float NULL,
CargosMC					float NULL,
AbonosMC					float NULL,
SaldoMC					float NULL,
EsCancelacion			bit NULL DEFAULT 0,
Grafica					int NULL DEFAULT 0,
GraficaArgumento			varchar(20) COLLATE DATABASE_DEFAULT NULL,
GraficaValor1			float,
GraficaValor2			float,
GraficaValor3			float,
GraficaValor4			float,
Titulo					varchar(50) COLLATE DATABASE_DEFAULT NULL,
ContMoneda				varchar(10) COLLATE DATABASE_DEFAULT NULL,
FiltroEmpresa			varchar(100) COLLATE DATABASE_DEFAULT NULL,
FiltroCtaDineroD			varchar(10) COLLATE DATABASE_DEFAULT NULL,
FiltroCtaDineroA			varchar(10) COLLATE DATABASE_DEFAULT NULL,
FiltroFechaD				datetime NULL,
FiltroFechaA				datetime NULL,
FiltroUso				varchar(20) COLLATE DATABASE_DEFAULT NULL,
FiltroMov				varchar(20) COLLATE DATABASE_DEFAULT NULL,
FiltroNivel				varchar(20) COLLATE DATABASE_DEFAULT NULL,
FiltroMoneda				varchar(10) COLLATE DATABASE_DEFAULT NULL,
FiltroGraficarTipo		varchar(30) COLLATE DATABASE_DEFAULT NULL,
FiltroGraficarCantidad	int NULL
)
INSERT @Datos (Estacion, CtaDinero, NumeroCta, Descripcion, Tipo, Uso, Moneda, TipoCambio, Beneficiario, Fecha, Movimiento, Cargos, Abonos, Saldo, CargosMC, AbonosMC, SaldoMC, EsCancelacion, Grafica, Titulo, ContMoneda, FiltroEmpresa, FiltroCtaDineroD, FiltroCtaDineroA, FiltroFechaD, FiltroFechaA, FiltroUso, FiltroMov, FiltroNivel, FiltroMoneda, FiltroGraficarTipo, FiltroGraficarCantidad)
SELECT
@EstacionTrabajo,
RTRIM(c.CtaDinero),
RTRIM(c.NumeroCta),
RTRIM(c.Descripcion),
NULL,
NULL,
c.Moneda,
NULL,
NULL,
DATEADD(day,-1,@InfoFechaD),
dbo.fnIdiomaTraducir(@InfoUsuario,'Saldo Inicial'),
SUM(ISNULL(a.Cargo,0.0)),
SUM(ISNULL(a.Abono,0.0)),
NULL,
SUM(ISNULL(a.Cargo,0.0)*ISNULL(a.TipoCambio,0)),
SUM(ISNULL(a.Abono,0.0)*ISNULL(a.TipoCambio,0)),
NULL,
0,
0,
@InfoTitulo,
@ContMoneda,
@EmpresaNombre,
@InfoCtaDineroD,
@InfoCtaDineroA,
@InfoFechaD,
@InfoFechaA,
ISNULL(@InfoUso,'(Todos)'),
ISNULL(@InfoMov,'(Todos)'),
@InfoNivel,
ISNULL(@InfoMoneda,'(Todas)'),
ISNULL(@InformeGraficarTipo,'(Todos)'),
@InformeGraficarCantidad
FROM
CtaDinero c LEFT OUTER JOIN Auxiliar a
ON a.Empresa = @InfoEmpresa AND a.Rama = 'DIN' AND c.CtaDinero = a.Cuenta AND a.Fecha < @InfoFechaD AND a.Mov = ISNULL(@InfoMov,a.Mov) AND a.Moneda = ISNULL(@InfoMoneda,a.Moneda) LEFT OUTER JOIN Dinero d
ON d.ID = a.ModuloID
WHERE c.CtaDinero BETWEEN @InfoCtaDineroD AND @InfoCtaDineroA
AND ISNULL(c.Uso,'') = ISNULL(@InfoUso,ISNULL(c.Uso,''))
GROUP BY RTRIM(c.CtaDinero), RTRIM(c.NumeroCta), RTRIM(c.Descripcion), c.Moneda
DELETE FROM @Datos WHERE ISNULL(Cargos,0.0) = 0.0 AND ISNULL(Abonos,0.0) = 0.0
INSERT @Datos (Estacion, CtaDinero, NumeroCta, Descripcion, Tipo, Uso, Moneda, TipoCambio, Beneficiario, Fecha, Movimiento, Cargos, Abonos, Saldo, CargosMC, AbonosMC, SaldoMC, EsCancelacion, Grafica, Titulo, GraficaArgumento, ContMoneda, FiltroEmpresa, FiltroCtaDineroD, FiltroCtaDineroA, FiltroFechaD, FiltroFechaA, FiltroUso, FiltroMov, FiltroNivel, FiltroMoneda, FiltroGraficarTipo, FiltroGraficarCantidad)
SELECT
@EstacionTrabajo,
RTRIM(c.CtaDinero),
RTRIM(c.NumeroCta),
RTRIM(c.Descripcion),
c.Tipo,
c.Uso,
a.Moneda,
a.TipoCambio,
d.BeneficiarioNombre,
a.Fecha,
RTRIM(RTRIM(ISNULL(a.Mov,'')) + ' ' + RTRIM(ISNULL(a.MovID,''))),
ISNULL(a.Cargo,0.0),
ISNULL(a.Abono,0.0),
NULL,
ISNULL(a.Cargo,0.0)*ISNULL(a.TipoCambio,0),
ISNULL(a.Abono,0.0)*ISNULL(a.TipoCambio,0),
NULL,
ISNULL(a.EsCancelacion,0),
0,
@InfoTitulo,
RTRIM(ISNULL(a.Mov,'')),
@ContMoneda,
@EmpresaNombre,
@InfoCtaDineroD,
@InfoCtaDineroA,
@InfoFechaD,
@InfoFechaA,
ISNULL(@InfoUso,'(Todos)'),
ISNULL(@InfoMov,'(Todos)'),
@InfoNivel,
ISNULL(@InfoMoneda,'(Todas)'),
ISNULL(@InformeGraficarTipo,'(Todos)'),
@InformeGraficarCantidad
FROM
CtaDinero c JOIN Auxiliar a
ON a.Rama = 'DIN' AND c.CtaDinero = a.Cuenta JOIN Dinero d
ON d.ID = a.ModuloID
WHERE a.Empresa = @InfoEmpresa
AND a.Cuenta BETWEEN @InfoCtaDineroD AND @InfoCtaDineroA
AND a.Fecha BETWEEN @InfoFechaD AND @InfoFechaA
AND ISNULL(c.Uso,'') = ISNULL(@InfoUso,ISNULL(c.Uso,''))
AND a.Mov = ISNULL(@InfoMov,a.Mov)
AND a.Moneda = ISNULL(@InfoMoneda,a.Moneda)
SELECT @MonedaInicial = '', @CuentaInicial = '', @Saldo = 0.0, @SaldoMC = 0.0
DECLARE crDineroAux CURSOR FOR
SELECT ID, Moneda, CtaDinero, Fecha, ISNULL(Cargos,0.0), ISNULL(Abonos,0.0), ISNULL(CargosMC,0.0), ISNULL(AbonosMC,0.0)
FROM @Datos
ORDER BY CtaDinero, Moneda, Fecha
OPEN crDineroAux
FETCH NEXT FROM crDineroAux INTO @ID, @Moneda, @Cuenta, @Fecha, @Cargos, @Abonos, @CargosMC, @AbonosMC
WHILE @@FETCH_STATUS = 0
BEGIN
IF @Moneda <> @MonedaInicial OR @Cuenta <> @CuentaInicial
BEGIN
SET @Saldo = 0.0
SET @SaldoMC = 0.0
SET @MonedaInicial = @Moneda
SET @CuentaInicial = @Cuenta
END
UPDATE @Datos
SET
Saldo = @Saldo + (@Cargos - @Abonos),
SaldoMC = @SaldoMC + (@CargosMC - @AbonosMC)
WHERE ID = @ID
SET @Saldo = @Saldo + (@Cargos - @Abonos)
SET @SaldoMC = @SaldoMC + (@CargosMC - @AbonosMC)
FETCH NEXT FROM crDineroAux INTO @ID, @Moneda, @Cuenta, @Fecha, @Cargos, @Abonos, @CargosMC, @AbonosMC
END
CLOSE crDineroAux
DEALLOCATE crDineroAux
SET @MonedaInicial = ''
SET @CuentaInicial = ''
SET @MovInicial = ''
SET @MovTotalCargos = 0.0
SET @MovTotalAbonos = 0.0
SET @MovTotalCargosMC = 0.0
SET @MovTotalAbonosMC = 0.0
DECLARE crDatos CURSOR STATIC FOR
SELECT ID, Moneda, CtaDinero, GraficaArgumento, ISNULL(Cargos,0.0), ISNULL(Abonos,0.0), ISNULL(CargosMC,0.0), ISNULL(AbonosMC,0.0)
FROM @Datos
WHERE ISNULL(Grafica,0) = 0
AND GraficaArgumento IS NOT NULL
ORDER BY GraficaArgumento, CtaDinero, Moneda
OPEN crDatos
FETCH NEXT FROM crDatos INTO @ID, @Moneda, @Cuenta, @Mov, @Cargos, @Abonos, @CargosMC, @AbonosMC
WHILE @@FETCH_STATUS = 0
BEGIN
IF @Moneda <> @MonedaInicial OR @Cuenta <> @CuentaInicial OR @Mov <> @MovInicial
BEGIN
IF NULLIF(@MovInicial,'') IS NOT NULL OR NULLIF(@CuentaInicial,'') IS NOT NULL OR NULLIF(@MonedaInicial,'') IS NOT NULL
BEGIN
INSERT @DatosGrafica (Estacion,         Moneda,         CtaDinero,        Grafica, GraficaArgumento, GraficaValor1,   GraficaValor2,   GraficaValor3,     GraficaValor4,     ContMoneda)
VALUES (@EstacionTrabajo, @MonedaInicial, @CuentaInicial,   1,       @MovInicial,      @MovTotalCargos, @MovTotalAbonos, @MovTotalCargosMC, @MovTotalAbonosMC, @ContMoneda)
END
SET @MovTotalCargos = 0.0
SET @MovTotalAbonos = 0.0
SET @MovTotalCargosMC = 0.0
SET @MovTotalAbonosMC = 0.0
SET @MonedaInicial = @Moneda
SET @CuentaInicial = @Cuenta
SET @MovInicial = @Mov
END
SET @MovTotalCargos = @MovTotalCargos + @Cargos
SET @MovTotalAbonos = @MovTotalAbonos + @Abonos
SET @MovTotalCargosMC = @MovTotalCargosMC + @CargosMC
SET @MovTotalAbonosMC = @MovTotalAbonosMC + @AbonosMC
FETCH NEXT FROM crDatos INTO @ID, @Moneda, @Cuenta, @Mov, @Cargos, @Abonos, @CargosMC, @AbonosMC
END
CLOSE crDatos
DEALLOCATE crDatos
IF NULLIF(@MovInicial,'') IS NOT NULL OR NULLIF(@CuentaInicial,'') IS NOT NULL OR NULLIF(@MonedaInicial,'') IS NOT NULL
BEGIN
INSERT @DatosGrafica (Estacion,         Moneda,         CtaDinero,        Grafica, GraficaArgumento, GraficaValor1,   GraficaValor2,   GraficaValor3,     GraficaValor4,     ContMoneda)
VALUES        (@EstacionTrabajo, @MonedaInicial, @CuentaInicial,   1,       @MovInicial,      @MovTotalCargos, @MovTotalAbonos, @MovTotalCargosMC, @MovTotalAbonosMC, @ContMoneda)
END
DECLARE crDatosGrafica CURSOR STATIC FOR
SELECT CtaDinero, Moneda, CASE WHEN ISNULL(GraficaValor1,0.0) > 0.0 AND ISNULL(GraficaValor2,0.0) = 0.0 THEN 1 ELSE 0 END
FROM @DatosGrafica
WHERE ISNULL(Grafica,0) = 1
AND NULLIF(CtaDinero,'') IS NOT NULL
GROUP BY CtaDinero, Moneda, CASE WHEN ISNULL(GraficaValor1,0.0) > 0.0 AND ISNULL(GraficaValor2,0.0) = 0.0 THEN 1 ELSE 0 END
OPEN crDatosGrafica
FETCH NEXT FROM crDatosGrafica INTO @Cuenta, @Moneda, @Positivo
WHILE @@FETCH_STATUS = 0
BEGIN
IF @InformeGraficarTipo = '(Todos)'
BEGIN
INSERT @Datos (Estacion, Moneda, CtaDinero, Grafica, GraficaArgumento, GraficaValor1, GraficaValor2, GraficaValor3, GraficaValor4, ContMoneda, GraficaPositivo)
SELECT
Estacion,
Moneda,
CtaDinero,
1,
GraficaArgumento,
ISNULL(GraficaValor1,0.0),
ISNULL(GraficaValor2,0.0),
ISNULL(GraficaValor3,0.0),
ISNULL(GraficaValor4,0.0),
ContMoneda,
@Positivo
FROM @DatosGrafica
WHERE Grafica = 1
AND CtaDinero = @Cuenta
AND Moneda = @Moneda
AND CASE WHEN ISNULL(GraficaValor1,0.0) > 0.0 AND ISNULL(GraficaValor2,0.0) = 0.0 THEN 1 ELSE 0 END = @Positivo
END ELSE
IF @InformeGraficarTipo = 'Mas Sobresalientes'
BEGIN
INSERT @Datos (Estacion, Moneda, CtaDinero, Grafica, GraficaArgumento, GraficaValor1, GraficaValor2, GraficaValor3, GraficaValor4, ContMoneda, GraficaPositivo)
SELECT TOP (@InformeGraficarCantidad)
Estacion,
Moneda,
CtaDinero,
1,
GraficaArgumento,
ISNULL(GraficaValor1,0.0),
ISNULL(GraficaValor2,0.0),
ISNULL(GraficaValor3,0.0),
ISNULL(GraficaValor4,0.0),
ContMoneda,
@Positivo
FROM @DatosGrafica
WHERE Grafica = 1
AND CtaDinero = @Cuenta
AND Moneda = @Moneda
AND CASE WHEN ISNULL(GraficaValor1,0.0) > 0.0 AND ISNULL(GraficaValor2,0.0) = 0.0 THEN 1 ELSE 0 END = @Positivo
ORDER BY (ISNULL(GraficaValor1,0.0) - ISNULL(GraficaValor2,0.0)) DESC
END ELSE
IF @InformeGraficarTipo = 'Menos Sobresalientes'
BEGIN
INSERT @Datos (Estacion, Moneda, CtaDinero, Grafica, GraficaArgumento, GraficaValor1, GraficaValor2, GraficaValor3, GraficaValor4, ContMoneda, GraficaPositivo)
SELECT TOP (@InformeGraficarCantidad)
Estacion,
Moneda,
CtaDinero,
1,
GraficaArgumento,
ISNULL(GraficaValor1,0.0),
ISNULL(GraficaValor2,0.0),
ISNULL(GraficaValor3,0.0),
ISNULL(GraficaValor4,0.0),
ContMoneda,
@Positivo
FROM @DatosGrafica
WHERE Grafica = 1
AND CtaDinero = @Cuenta
AND Moneda = @Moneda
AND CASE WHEN ISNULL(GraficaValor1,0.0) > 0.0 AND ISNULL(GraficaValor2,0.0) = 0.0 THEN 1 ELSE 0 END = @Positivo
ORDER BY (ISNULL(GraficaValor1,0.0) - ISNULL(GraficaValor2,0.0)) ASC
END
FETCH NEXT FROM crDatosGrafica INTO @Cuenta, @Moneda, @Positivo
END
CLOSE crDatosGrafica
DEALLOCATE crDatosGrafica
INSERT @Datos (Estacion, Grafica, GraficaArgumento, GraficaValor3, GraficaValor4, ContMoneda, GraficaPositivo)
SELECT
Estacion,
2,
GraficaArgumento,
SUM(ISNULL(GraficaValor3,0.0)),
SUM(ISNULL(GraficaValor4,0.0)),
ContMoneda,
GraficaPositivo
FROM @Datos
WHERE Grafica = 1
GROUP BY Estacion, GraficaArgumento, ContMoneda, GraficaPositivo
SELECT Estacion, ID, CtaDinero, NumeroCta, Descripcion, Tipo, Uso, Moneda, TipoCambio, Beneficiario, Fecha, Movimiento, Cargos, Abonos, Saldo, CargosMC, AbonosMC, SaldoMC, EsCancelacion, Grafica, GraficaArgumento, GraficaValor1, GraficaValor2, GraficaValor3, GraficaValor4, Titulo, ContMoneda, FiltroCtaDineroD, FiltroEmpresa, FiltroCtaDineroA, FiltroFechaD, FiltroFechaA, FiltroUso, FiltroMov, FiltroNivel, FiltroMoneda, FiltroGraficarTipo, FiltroGraficarCantidad, GraficaPositivo, @VerGraficaDetalle as VerGraficaDetalle
FROM @Datos
ORDER BY NumeroCta, Descripcion, CtaDinero, Fecha, Moneda, Grafica
END

