SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROC spCorteDConsultaImporte
@ID					int,
@RID				int,
@MovTipo			varchar(20),
@CorteValuacion		varchar(50),
@CDesglosar			varchar(20),
@Ok					int				OUTPUT,
@OkRef				varchar(255)	OUTPUT

AS
BEGIN
DECLARE @Importe		float,
@SaldoU		float,
@SaldoI		float,
@Cargo		float,
@Abono		float
IF @MovTipo = 'CORTE.CORTEIMPORTE'
BEGIN
SELECT @Importe = SUM(Importe) ,
@SaldoU	= SUM(SaldoU)
FROM #CorteD
WHERE RIDConsulta = @RID
UPDATE CorteDConsulta
SET Importe	= @Importe,
SaldoU	= @SaldoU
WHERE ID		= @ID
AND RID		= @RID
END
ELSE IF @MovTipo IN('CORTE.CORTECONTABLE', 'CORTE.CORTECX')
BEGIN
SELECT Cuenta, ISNULL(SaldoI, 0) 'SaldoI', SUM(ISNULL(Cargo, 0)) 'Cargo', SUM(ISNULL(Abono, 0)) 'Abono'
INTO #Total
FROM #CorteD
WHERE ID			= @ID
AND RIDConsulta	= @RID
GROUP BY Cuenta, SaldoI
SELECT @SaldoI = SUM(SaldoI),
@Cargo  = SUM(Cargo),
@Abono  = SUM(Abono)
FROM #Total
UPDATE CorteDConsulta
SET SaldoI	= @SaldoI,
Cargo	= @Cargo,
Abono	= @Abono,
Saldo	= @SaldoI + @Cargo - @Abono
WHERE ID		= @ID
AND RID		= @RID
END
ELSE IF @MovTipo = 'CORTE.CORTEUNIDADES'
BEGIN
IF ISNULL(@CDesglosar, '') IN('Articulo', 'No')
UPDATE #CorteD
SET Importe = CASE ISNULL(@CorteValuacion, '')
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
SELECT Cuenta,					Grupo,			ISNULL(SaldoUI, 0) 'SaldoUI',	SUM(ISNULL(CargoU, 0)) 'CargoU',	SUM(ISNULL(AbonoU, 0)) 'AbonoU',
CostoPromedio,			UltimoCosto,	PrecioLista,					Precio2,							Precio3,
Precio4,					Precio5,		Precio6,						Precio7,							Precio8,
Precio9,					Precio10,		CostoEstandar,					CostoReposicion,					CostoUnitario,
CostoUnitarioOtraMoneda, MonedaContable,	SUM(Importe) 'Importe'
INTO #TotalU
FROM #CorteD
WHERE ID			= @ID
AND RIDConsulta	= @RID
GROUP BY Cuenta, Grupo, ISNULL(SaldoUI, 0), CostoPromedio, UltimoCosto, PrecioLista, Precio2, Precio3, Precio4, Precio5, Precio6,
Precio7, Precio8, Precio9, Precio10, CostoEstandar, CostoReposicion, CostoUnitario, CostoUnitarioOtraMoneda, MonedaContable
SELECT @SaldoI  = SUM(SaldoUI),
@Cargo   = SUM(CargoU),
@Abono   = SUM(AbonoU),
@Importe	= SUM(Importe)
FROM #TotalU
UPDATE CorteDConsulta
SET SaldoUI	= @SaldoI,
CargoU	= @Cargo,
AbonoU	= @Abono,
SaldoU	= @SaldoI + @Cargo - @Abono,
Importe	= @Importe
WHERE ID		= @ID
AND RID		= @RID
END
END

