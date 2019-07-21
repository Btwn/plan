SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spCorteCalcPeriodoFecha
@ID				int,
@IDGenerar		int,
@Ok				int			 OUTPUT

AS
BEGIN
DECLARE @CorteFechaD			datetime,
@CorteFechaA			datetime,
@CorteEjercicio		int,
@CortePeriodo			int,
@CorteFiltrarFechas	bit
SELECT @CorteFiltrarFechas	= ISNULL(CorteFiltrarFechas, 0),
@CorteFechaD			= CorteFechaD,
@CorteFechaA			= CorteFechaA,
@CorteEjercicio		= CorteEjercicio,
@CortePeriodo			= CortePeriodo
FROM Corte
WHERE ID = @ID
IF @CorteFiltrarFechas = 1
BEGIN
UPDATE Corte
SET CorteFechaD = dbo.fnCorteCalcPeriodoFecha('INICIAL', @ID, GETDATE(), 'NUMERO PERIODOS','TIPO PERIODO'),
CorteFechaA = dbo.fnCorteCalcPeriodoFecha('FINAL', @ID, GETDATE(), 'NUMERO PERIODOS','TIPO PERIODO')
FROM Corte
WHERE ID = @IDGenerar
END
ELSE
BEGIN
IF ISNULL(@CorteEjercicio, 0) <> 0
UPDATE Corte
SET CorteEjercicio = YEAR(dbo.fnCorteCalcPeriodoFecha('FINAL', @ID, GETDATE(), 'NUMERO PERIODOS','TIPO PERIODO'))
FROM Corte
WHERE ID = @IDGenerar
IF ISNULL(@CortePeriodo, 0) <> 0
UPDATE Corte
SET CortePeriodo = MONTH(dbo.fnCorteCalcPeriodoFecha('FINAL', @ID, GETDATE(), 'NUMERO PERIODOS','TIPO PERIODO'))
FROM Corte
WHERE ID = @IDGenerar
IF ISNULL(@CorteEjercicio, 0) = 0 AND ISNULL(@CortePeriodo, 0) = 0
UPDATE Corte
SET CorteFiltrarFechas = 1,
CorteFechaD = dbo.fnCorteCalcPeriodoFecha('INICIAL', @ID, GETDATE(), 'NUMERO PERIODOS','TIPO PERIODO'),
CorteFechaA = dbo.fnCorteCalcPeriodoFecha('FINAL', @ID, GETDATE(), 'NUMERO PERIODOS','TIPO PERIODO')
FROM Corte
WHERE ID = @IDGenerar
END
END

