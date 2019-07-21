SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spRSFlujoEfectivo
@Empresa		varchar(10),
@Sucursal	    int,
@CtaDineroD	varchar(10),
@CtaDineroA    varchar(10),
@Moneda		varchar(10),
@FechaD        datetime,
@FechaA        datetime

AS BEGIN
DECLARE
@EstacionTrabajo		    int,
@InfoUso					varchar(20),
@InfoMov					varchar(20),
@InfoNivel				varchar(20),
@InfoTitulo				varchar(100),
@InfoUsuario				varchar(10),
@MonedaInicial			varchar(10),
@CuentaInicial			varchar(10),
@MovInicial				varchar(20),
@ID						int,
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
SELECT @EstacionTrabajo=@@SPID
SELECT @InfoUso='(Todos)', @InfoMov='(Todos)', @InfoNivel=NULL
SELECT @InfoUso    = CASE WHEN @InfoUso IN( '(Todos)', '') THEN NULL ELSE @InfoUso END,
@InfoMov    = CASE WHEN @InfoMov IN( '(Todos)', '') THEN NULL ELSE @InfoMov END,
@InfoNivel  =   ISNULL(@InfoNivel,'Desglosado'),
@InfoTitulo = NULL,
@Moneda     = CASE WHEN @Moneda IN( '(Todas)', '') THEN NULL ELSE @Moneda END,
@Empresa     = CASE WHEN @Empresa IN( '(Todas)', '') THEN NULL ELSE @Empresa END
SELECT @ContMoneda = ContMoneda FROM EmpresaCfg WHERE Empresa = @Empresa
SELECT @EmpresaNombre = Nombre FROM Empresa WHERE Empresa = @Empresa
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
DECLARE @DatosDin TABLE
(
Modulo                   varchar(5),
ModuloNombre             varchar(50),
CtaDinero				varchar(10) COLLATE DATABASE_DEFAULT NULL,
NumeroCta				varchar(100) COLLATE DATABASE_DEFAULT NULL,
CtaDineroDescripcion		varchar(100) COLLATE DATABASE_DEFAULT NULL,
ClienteProveedor         varchar(10) NULL,
Nombre                   varchar(100) NULL,
Mov      		        varchar (50) NULL, 
MovID		            varchar (20) COLLATE DATABASE_DEFAULT NULL,
FechaEmision				datetime NULL,
FechaVencimiento     	datetime NULL,
Importe					float NULL,
Cargos					float NULL,
Abonos					float NULL,
Saldo					float NULL,
TotalClienteProveedor    float NULL, 
Moneda					varchar(10) COLLATE DATABASE_DEFAULT NULL
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
DATEADD(day,-1,@FechaD),
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
@CtaDineroD,
@CtaDineroA,
@FechaD,
@FechaA,
ISNULL(@InfoUso,'(Todos)'),
ISNULL(@InfoMov,'(Todos)'),
@InfoNivel,
ISNULL(@Moneda,'(Todas)'),
ISNULL(@InformeGraficarTipo,'(Todos)'),
@InformeGraficarCantidad
FROM
CtaDinero c
LEFT OUTER JOIN Auxiliar a ON a.Empresa = ISNULL(@Empresa,a.Empresa) AND a.Sucursal=ISNULL(@Sucursal,a.Sucursal) AND a.Rama = 'DIN' AND c.CtaDinero = a.Cuenta
AND a.Moneda = ISNULL(@Moneda,a.Moneda)
LEFT OUTER JOIN Dinero d ON d.ID = a.ModuloID AND d.Empresa=a.Empresa AND d.Sucursal=a.Sucursal
WHERE c.CtaDinero BETWEEN @CtaDineroD AND @CtaDineroA
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
@CtaDineroD,
@CtaDineroA,
@FechaD,
@FechaA,
ISNULL(@InfoUso,'(Todos)'),
ISNULL(@InfoMov,'(Todos)'),
@InfoNivel,
ISNULL(@Moneda,'(Todas)'),
ISNULL(@InformeGraficarTipo,'(Todos)'),
@InformeGraficarCantidad
FROM
CtaDinero c JOIN Auxiliar a
ON a.Empresa = ISNULL(@Empresa,a.Empresa) AND a.Sucursal=ISNULL(@Sucursal,a.Sucursal) AND a.Rama = 'DIN' AND c.CtaDinero = a.Cuenta JOIN Dinero d 
ON d.ID = a.ModuloID AND d.Empresa=a.Empresa AND d.Sucursal=a.Sucursal
WHERE a.Empresa = @Empresa
AND a.Cuenta BETWEEN @CtaDineroD AND @CtaDineroA
AND ISNULL(c.Uso,'') = ISNULL(@InfoUso,ISNULL(c.Uso,''))
AND a.Moneda = ISNULL(@Moneda,a.Moneda)
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
INSERT INTO @DatosDin ( Modulo, ModuloNombre, CtaDinero, NumeroCta, CtaDineroDescripcion, ClienteProveedor, Nombre, Mov, MovID, FechaEmision, FechaVencimiento, Importe, Cargos, Abonos, Saldo, TotalClienteProveedor, Moneda)
SELECT 'DIN', 'Cuentas de Dinero', d.CtaDinero, d.NumeroCta, d.CtaDinero+' - '+d.Descripcion, NULL, NULL, NULL, NULL, NULL, NULL, NULL, SUM(d.Cargos) AS Cargos, SUM(d.Abonos) AS Abonos, SUM(d.Saldo)- CASE WHEN cd.Tipo='Caja' THEN ISNULL(cd.FondoFijo,0) ELSE ISNULL(cd.SaldoInicial,0) END AS Saldo, NULL, d.Moneda 
FROM @Datos d, CtaDinero cd
WHERE cd.CtaDinero=d.CtaDinero
GROUP BY d.CtaDinero, d.NumeroCta, d.Descripcion, d.Moneda, cd.Tipo, cd.FondoFijo, cd.SaldoInicial
UNION
SELECT 'CXC', 'Cuentas por Cobrar', 'CXC', NULL, 'CXC', Cxc.Cliente, Cxc.Cliente+' - '+Cte.Nombre, Cxc.Mov+' - '+ Cxc.MovID, Cxc.MovID, Cxc.FechaEmision, Cxc.Vencimiento,
Sum(Cxc.Importe) as Importe, NULL, NULL, SUM(CASE WHEN mt.Clave IN ('CXC.A','CXC.FACX') THEN Cxc.Saldo*-1 ELSE Cxc.Saldo END), SUM(CASE WHEN mt.Clave IN ('CXC.A','CXC.FACX') THEN Cxc.Saldo*-1 ELSE Cxc.Saldo END), Cxc.Moneda
FROM Cxc
JOIN Cte on Cte.Cliente=Cxc.Cliente
JOIN MovTipo Mt ON Mt.Modulo='CXC' AND Mt.Mov=Cxc.Mov
WHERE Cxc.Empresa=ISNULL(@Empresa,Cxc.Empresa) AND Cxc.Sucursal=ISNULL(@Sucursal,Cxc.Sucursal)
AND Cxc.Vencimiento BETWEEN @FechaD AND @FechaA
AND Cxc.Estatus='PENDIENTE'
AND Cxc.Mov = ISNULL(@InfoMov,Cxc.Mov)
AND Cxc.Moneda = ISNULL(@Moneda,Cxc.Moneda)
AND mt.Clave IN ('CXC.F', 'CXC.NC', 'CXC.FA', 'CXC.A', 'CXC.FAC', 'CXC.D', 'CXC.CAP', 'CXC.C', 'CXC.NET', 'CXC.SD') 
GROUP BY Cxc.Cliente, Cte.Nombre, Cxc.Mov, Cxc.MovID, Cxc.FechaEmision, Cxc.Vencimiento, Cxc.Moneda
UNION
SELECT 'CXP', 'Cuentas por Pagar', 'CXP', NULL, 'CXP', Cxp.Proveedor, Cxp.Proveedor+' - '+Prov.Nombre, Cxp.Mov+' - '+Cxp.MovID, Cxp.MovID, Cxp.FechaEmision, Cxp.Vencimiento,
Sum(Cxp.Importe) as Importe, NULL, NULL, SUM(Cxp.Saldo), SUM(Cxp.Saldo), Cxp.Moneda
FROM Cxp
JOIN Prov on Prov.Proveedor=Cxp.Proveedor
JOIN MovTipo Mt ON Mt.Modulo='CXP' AND Mt.Mov=Cxp.Mov
WHERE Cxp.Empresa=ISNULL(@Empresa, Cxp.Empresa) AND Cxp.Sucursal=ISNULL(@Sucursal, Cxp.Sucursal)
AND Cxp.Vencimiento BETWEEN @FechaD AND @FechaA
AND Cxp.Estatus='PENDIENTE'
AND Cxp.Mov = ISNULL(@InfoMov,Cxp.Mov)
AND Cxp.Moneda = ISNULL(@Moneda, Cxp.Moneda)
AND mt.Clave IN ('CXP.NC', 'CXP.CA', 'CXP.F', 'CXP.FAC', 'CXP.D', 'CXP.P', 'CXP.SCH', 'CXP.CAP')
GROUP BY Cxp.Proveedor, Prov.Nombre, Cxp.Mov, Cxp.MovID, Cxp.FechaEmision, Cxp.Vencimiento, Cxp.Moneda
SELECT * FROM @DatosDin ORDER BY Modulo DESC, ClienteProveedor, FechaEmision ASC
END

