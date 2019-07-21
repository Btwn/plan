SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROC spCorteDRecalcEncabezado
@ID			int,
@MovTipo	varchar(20),
@Ok			int				OUTPUT,
@OkRef		varchar(255)	OUTPUT

AS
BEGIN
DECLARE @Suma			float,
@Resta		float,
@SumaSaldoI	float,
@RestaSaldoI	float,
@SumaCargo	float,
@RestaCargo	float,
@SumaAbono	float,
@RestaAbono	float,
@SumaSaldo	float,
@RestaSaldo	float,
@Importe		float,
@SumaImporte	float,
@RestaImporte	float
IF @MovTipo = 'CORTE.CORTEIMPORTE'
BEGIN
SELECT @Suma		= SUM(Importe),
@SumaSaldo	= SUM(SaldoU)
FROM CorteDConsulta
WHERE ID = @ID
AND Accion = 'Sumar'
SELECT @Resta		= SUM(Importe),
@RestaSaldo	= SUM(SaldoU)
FROM CorteDConsulta
WHERE ID = @ID
AND Accion = 'Restar'
UPDATE Corte
SET Importe	= ISNULL(@Suma, 0) - ISNULL(@Resta, 0),
SaldoU	= ISNULL(@SumaSaldo, 0) - ISNULL(@RestaSaldo, 0)
WHERE ID = @ID
END
ELSE IF @MovTipo IN('CORTE.CORTECONTABLE', 'CORTE.CORTECX')
BEGIN
SELECT @SumaSaldoI	= SUM(SaldoI),
@SumaCargo	= SUM(Cargo),
@SumaAbono	= SUM(Abono),
@SumaSaldo	= SUM(Saldo)
FROM CorteDConsulta
WHERE ID = @ID
AND Accion = 'Sumar'
SELECT @RestaSaldoI	= SUM(SaldoI),
@RestaCargo	= SUM(Cargo),
@RestaAbono	= SUM(Abono),
@RestaSaldo	= SUM(Saldo)
FROM CorteDConsulta
WHERE ID = @ID
AND Accion = 'Restar'
UPDATE Corte
SET SaldoI	= ISNULL(@SumaSaldoI, 0) - ISNULL(@RestaSaldoI, 0),
Cargo	= ISNULL(@SumaCargo, 0)  - ISNULL(@RestaCargo, 0),
Abono	= ISNULL(@SumaAbono, 0)  - ISNULL(@RestaAbono, 0),
Saldo	= ISNULL(@SumaSaldo, 0) - ISNULL(@RestaSaldo, 0)
WHERE ID = @ID
END
ELSE IF @MovTipo IN('CORTE.CORTEUNIDADES')
BEGIN
SELECT @SumaSaldoI	= SUM(SaldoUI),
@SumaCargo	= SUM(CargoU),
@SumaAbono	= SUM(AbonoU),
@SumaSaldo	= SUM(SaldoU),
@SumaImporte	= SUM(Importe)
FROM CorteDConsulta
WHERE ID = @ID
AND Accion = 'Sumar'
SELECT @RestaSaldoI	 = SUM(SaldoUI),
@RestaCargo	 = SUM(CargoU),
@RestaAbono	 = SUM(AbonoU),
@RestaSaldo	 = SUM(SaldoU),
@RestaImporte = SUM(Importe)
FROM CorteDConsulta
WHERE ID = @ID
AND Accion = 'Restar'
UPDATE Corte
SET SaldoUI	= ISNULL(@SumaSaldoI, 0)  - ISNULL(@RestaSaldoI, 0),
CargoU	= ISNULL(@SumaCargo, 0)   - ISNULL(@RestaCargo, 0),
AbonoU	= ISNULL(@SumaAbono, 0)   - ISNULL(@RestaAbono, 0),
SaldoU	= ISNULL(@SumaSaldo, 0)   - ISNULL(@RestaSaldo, 0),
Importe = ISNULL(@SumaImporte, 0) - ISNULL(@RestaImporte, 0)
WHERE ID = @ID
END
END

