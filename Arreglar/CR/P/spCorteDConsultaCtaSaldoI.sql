SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROC spCorteDConsultaCtaSaldoI
@ID					int,
@RID				int,
@CFiltrarFechas		bit,
@CPeriodo			int,
@CEjercicio			int,
@CFechaD			datetime,
@CFechaA			datetime,
@CDesglosar			varchar(20),
@CMoneda			varchar(10),
@Moneda				varchar(10),
@TipoCambio			float,
@MovTipo			varchar(20),
@CAlmacen			varchar(10),
@CValuacion			varchar(50),
@CModulo			varchar(5),
@Ok                	int          OUTPUT,
@OkRef             	varchar(255) OUTPUT

AS
BEGIN
DECLARE @Fecha			datetime,
@RIDAux			int,
@RIDAuxAnt		int,
@Cuenta			varchar(20),
@CuentaAnt		varchar(20),
@ContMoneda		varchar(10),
@Sucursal			int,
@SubCuenta		varchar(50),
@Empresa			varchar(5),
@Saldo			float,
@Grupo			varchar(10),
@Cargo			float,
@Abono			float,
@SaldoI			float
IF ISNULL(@CFiltrarFechas, 0) = 0
SELECT @Fecha = dbo.fnFechaInicialEjercicio(@CEjercicio, @CPeriodo)
ELSE
SELECT @Fecha = @CFechaD
CREATE TABLE #Saldo(Saldo float NULL)
IF @MovTipo = 'CORTE.CORTECONTABLE' OR(@MovTipo IN('CORTE.CORTEUNIDADES', 'CORTE.CORTECX') AND ISNULL(@CDesglosar, '') <> 'Movimiento')
BEGIN
SELECT @RIDAuxAnt = 0
WHILE(1=1)
BEGIN
SELECT @RIDAux = MIN(RID)
FROM #CorteD
WHERE ID				= @ID
AND RIDConsulta	= @RID
AND RID			> @RIDAuxAnt
IF @RIDAux IS NULL BREAK
SELECT @RIDAuxAnt = @RIDAux
SELECT @Cuenta = NULL, @ContMoneda = NULL, @Sucursal = NULL, @SubCuenta = NULL, @Empresa = NULL, @Grupo = NULL
SELECT @Cuenta	= Cuenta,
@Sucursal	= Sucursal,
@SubCuenta	= SubCuenta,
@Empresa	= Empresa,
@Grupo		= Grupo
FROM #CorteD
WHERE ID				= @ID
AND RIDConsulta	= @RID
AND RID			= @RIDAux
DELETE #Saldo
IF @MovTipo IN('CORTE.CORTECONTABLE')
BEGIN
SELECT @ContMoneda = ContMoneda FROM EmpresaCfg WHERE Empresa = @Empresa
INSERT INTO #Saldo
EXEC spVerSaldoInicialMSucursal @Empresa, 'CONT', @ContMoneda, @Cuenta, @Fecha, @Sucursal, @SubCuenta
SELECT @Saldo = Saldo / @TipoCambio FROM #Saldo
UPDATE #CorteD
SET SaldoI		= @Saldo,
Saldo		= ISNULL(@Saldo, 0) + ISNULL(Cargo, 0) - ISNULL(Abono, 0)
WHERE ID			= @ID
AND RIDConsulta	= @RID
AND RID			= @RIDAux
END
ELSE IF @MovTipo = 'CORTE.CORTEUNIDADES'
BEGIN
INSERT INTO #Saldo
EXEC spVerSaldoInicialU @Empresa, 'INV', @CMoneda, @Cuenta, @Grupo, @Fecha, ''
SELECT @Saldo = Saldo FROM #Saldo
UPDATE #CorteD
SET SaldoUI		= @Saldo,
SaldoU		= ISNULL(@Saldo, 0) + ISNULL(CargoU, 0) - ISNULL(AbonoU, 0)
WHERE ID			= @ID
AND RIDConsulta	= @RID
AND RID			= @RIDAux
END
ELSE IF @MovTipo = 'CORTE.CORTECX'
BEGIN
INSERT INTO #Saldo
EXEC spVerSaldoInicialMSucursal @Empresa, @CModulo, @CMoneda, @Cuenta, @Fecha, @Sucursal, @SubCuenta
SELECT @Saldo = Saldo / @TipoCambio FROM #Saldo
UPDATE #CorteD
SET SaldoI		= @Saldo,
Saldo		= ISNULL(@Saldo, 0) + ISNULL(Cargo, 0) - ISNULL(Abono, 0)
WHERE ID			= @ID
AND RIDConsulta	= @RID
AND RID			= @RIDAux
END
END
END
ELSE IF @MovTipo = 'CORTE.CORTEUNIDADES' AND ISNULL(@CDesglosar, '') = 'Movimiento'
BEGIN
SELECT @CuentaAnt = ''
WHILE(1=1)
BEGIN
SELECT @Cuenta = MIN(Cuenta)
FROM #CorteD
WHERE ID				= @ID
AND RIDConsulta	= @RID
AND Cuenta			> @CuentaAnt
IF @Cuenta IS NULL BREAK
SELECT @CuentaAnt = @Cuenta
SELECT @Saldo = NULL
SELECT @Empresa	= Empresa
FROM #CorteD
WHERE ID				= @ID
AND RIDConsulta	= @RID
AND Cuenta			= @CuentaAnt
INSERT INTO #Saldo
EXEC spVerSaldoInicialU @Empresa, 'INV', @CMoneda, @Cuenta, @CAlmacen, @Fecha, ''
SELECT @Saldo = ISNULL(Saldo, 0) FROM #Saldo
SELECT @RIDAuxAnt = 0
WHILE(1=1)
BEGIN
SELECT @RIDAux = MIN(RID)
FROM #CorteD
WHERE ID			= @ID
AND RIDConsulta	= @RID
AND Cuenta		= @Cuenta
AND RID			> @RIDAuxAnt
IF @RIDAux IS NULL BREAK
SELECT @RIDAuxAnt = @RIDAux, @Cargo = NULL, @Abono = NULL
SELECT @Cargo	= ISNULL(CargoU, 0),
@Abono	= ISNULL(AbonoU, 0)
FROM #CorteD
WHERE ID			= @ID
AND RIDConsulta	= @RID
AND Cuenta		= @Cuenta
AND RID			= @RIDAux
UPDATE #CorteD
SET SaldoUI	= @Saldo,
SaldoU	= @Saldo + @Cargo - @Abono
FROM #CorteD
WHERE ID			= @ID
AND RIDConsulta	= @RID
AND Cuenta		= @Cuenta
AND RID			= @RIDAux
SELECT @Saldo = @Saldo + @Cargo - @Abono
END
UPDATE #CorteD
SET Importe = CASE ISNULL(@CValuacion, '')
WHEN '(Sin Valuar)'		THEN NULL
WHEN ''					THEN NULL
WHEN 'Costo Promedio'		THEN CostoPromedio * (ISNULL(SaldoUI, 0) + ISNULL(CargoU, 0) - ISNULL(AbonoU, 0))
WHEN 'Ultimo Costo'		THEN UltimoCosto * (ISNULL(SaldoUI, 0) + ISNULL(CargoU, 0) - ISNULL(AbonoU, 0))
WHEN 'Costo Estandar'		THEN CostoEstandar * (ISNULL(SaldoUI, 0) + ISNULL(CargoU, 0) - ISNULL(AbonoU, 0))
WHEN 'Costo Reposicion'	THEN CostoReposicion * (ISNULL(SaldoUI, 0) + ISNULL(CargoU, 0) - ISNULL(AbonoU, 0))
WHEN 'UEPS'				THEN NULL
WHEN 'PEPS'				THEN NULL
WHEN 'Precio Lista'		THEN PrecioLista * (ISNULL(SaldoUI, 0) + ISNULL(CargoU, 0) - ISNULL(AbonoU, 0))
WHEN 'Precio 2'			THEN Precio2 * (ISNULL(SaldoUI, 0) + ISNULL(CargoU, 0) - ISNULL(AbonoU, 0))
WHEN 'Precio 3'			THEN Precio3 * (ISNULL(SaldoUI, 0) + ISNULL(CargoU, 0) - ISNULL(AbonoU, 0))
WHEN 'Precio 4'			THEN Precio4 * (ISNULL(SaldoUI, 0) + ISNULL(CargoU, 0) - ISNULL(AbonoU, 0))
WHEN 'Precio 5'			THEN Precio5 * (ISNULL(SaldoUI, 0) + ISNULL(CargoU, 0) - ISNULL(AbonoU, 0))
WHEN 'Precio 6'			THEN Precio6 * (ISNULL(SaldoUI, 0) + ISNULL(CargoU, 0) - ISNULL(AbonoU, 0))
WHEN 'Precio 7'			THEN Precio7 * (ISNULL(SaldoUI, 0) + ISNULL(CargoU, 0) - ISNULL(AbonoU, 0))
WHEN 'Precio 8'			THEN Precio8 * (ISNULL(SaldoUI, 0) + ISNULL(CargoU, 0) - ISNULL(AbonoU, 0))
WHEN 'Precio 9'			THEN Precio9 * (ISNULL(SaldoUI, 0) + ISNULL(CargoU, 0) - ISNULL(AbonoU, 0))
WHEN 'Precio 10'			THEN Precio10 * (ISNULL(SaldoUI, 0) + ISNULL(CargoU, 0) - ISNULL(AbonoU, 0))
WHEN 'Costo Promedio (Nivel Opción)'	THEN NULL
WHEN 'Ultimo Costo (Nivel Opción)'	THEN NULL
END
WHERE ID				= @ID
AND RIDConsulta	= @RID
AND Cuenta			= @Cuenta
AND RID			= (SELECT MAX(RID) FROM #CorteD WHERE Cuenta = @Cuenta AND ID = @ID AND RIDConsulta	= @RID)
UPDATE #CorteD
SET SaldoUI = NULL
WHERE ID				= @ID
AND RIDConsulta	= @RID
AND Cuenta			= @Cuenta
AND RID			<> (SELECT MIN(RID) FROM #CorteD WHERE Cuenta = @Cuenta AND ID = @ID AND RIDConsulta	= @RID)
END
END
ELSE IF @MovTipo = 'CORTE.CORTECX' AND ISNULL(@CDesglosar, '') = 'Movimiento'
BEGIN
SELECT @CuentaAnt = ''
WHILE(1=1)
BEGIN
SELECT @Cuenta = MIN(Cuenta)
FROM #CorteD
WHERE ID				= @ID
AND RIDConsulta	= @RID
AND Cuenta			> @CuentaAnt
IF @Cuenta IS NULL BREAK
SELECT @CuentaAnt = @Cuenta
SELECT @Saldo = NULL
SELECT @Empresa	= Empresa
FROM #CorteD
WHERE ID				= @ID
AND RIDConsulta	= @RID
AND Cuenta			= @CuentaAnt
INSERT INTO #Saldo
EXEC spVerSaldoInicialMSucursal @Empresa, @CModulo, @CMoneda, @Cuenta, @Fecha, @Sucursal, @SubCuenta
SELECT @Saldo = ISNULL(Saldo, 0) / @TipoCambio FROM #Saldo
SELECT @RIDAuxAnt = 0
WHILE(1=1)
BEGIN
SELECT @RIDAux = MIN(RID)
FROM #CorteD
WHERE ID			= @ID
AND RIDConsulta	= @RID
AND Cuenta		= @Cuenta
AND RID			> @RIDAuxAnt
IF @RIDAux IS NULL BREAK
SELECT @RIDAuxAnt = @RIDAux, @Cargo = NULL, @Abono = NULL
SELECT @Cargo	= ISNULL(Cargo, 0),
@Abono	= ISNULL(Abono, 0)
FROM #CorteD
WHERE ID			= @ID
AND RIDConsulta	= @RID
AND Cuenta		= @Cuenta
AND RID			= @RIDAux
UPDATE #CorteD
SET SaldoI	= @Saldo,
Saldo	= @Saldo + @Cargo - @Abono
FROM #CorteD
WHERE ID			= @ID
AND RIDConsulta	= @RID
AND Cuenta		= @Cuenta
AND RID			= @RIDAux
SELECT @Saldo = @Saldo + @Cargo - @Abono
END
UPDATE #CorteD
SET SaldoI = NULL
WHERE ID				= @ID
AND RIDConsulta	= @RID
AND Cuenta			= @Cuenta
AND RID			<> (SELECT MIN(RID) FROM #CorteD WHERE Cuenta = @Cuenta AND ID = @ID AND RIDConsulta	= @RID)
END
END
END

