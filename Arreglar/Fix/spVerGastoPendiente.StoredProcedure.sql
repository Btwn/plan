SET DATEFIRST 7    
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1  
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE [dbo].[spVerGastoPendiente]
 @Empresa CHAR(5)
,@FechaEmision DATETIME
,@FechaRequerida DATETIME
,@Concepto VARCHAR(50)
,@MovMoneda CHAR(10)
,@ContUso CHAR(20)
,@EnSilencio BIT = 0
,@GastoPendiente MONEY = NULL OUTPUT
,@ContUso2 CHAR(20) = NULL
,@ContUso3 CHAR(20) = NULL
AS
BEGIN
	SELECT @ContUso = NULLIF(NULLIF(RTRIM(@ContUso), '0'), '')
		  ,@ContUso2 = NULLIF(NULLIF(RTRIM(@ContUso2), '0'), '')
		  ,@ContUso3 = NULLIF(NULLIF(RTRIM(@ContUso3), '0'), '')
		  ,@FechaRequerida = ISNULL(@FechaRequerida, @FechaEmision)
		  ,@GastoPendiente = NULL

	IF (
			SELECT GastoValidarPresupuestoFR
			FROM EmpresaCfg2
			WHERE Empresa = @Empresa
		)
		= 1
		SELECT @GastoPendiente = SUM(d.Importe * mt.Factor)
		FROM Gasto e
			,GastoD d
			,MovTipo mt
		WHERE Empresa = @Empresa
		AND e.ID = d.ID
		AND e.Estatus = 'PENDIENTE'
		AND DATEPART(YEAR, e.FechaRequerida) = DATEPART(YEAR, @FechaRequerida)
		AND DATEPART(MONTH, e.FechaRequerida) = DATEPART(MONTH, @FechaRequerida)
		AND d.Concepto = @Concepto
		AND e.Moneda = @MovMoneda
		AND ISNULL(d.ContUso, '') = ISNULL(ISNULL(@ContUso, d.ContUso), '')
		AND ISNULL(d.ContUso2, '') = ISNULL(ISNULL(@ContUso2, d.ContUso2), '')
		AND ISNULL(d.ContUso3, '') = ISNULL(ISNULL(@ContUso3, d.ContUso3), '')
		AND mt.Modulo = 'GAS'
		AND mt.Mov = e.Mov
		AND mt.Clave IN ('GAS.S')
	ELSE
		SELECT @GastoPendiente = SUM(d.Importe * mt.Factor)
		FROM Gasto e
			,GastoD d
			,MovTipo mt
		WHERE Empresa = @Empresa
		AND e.ID = d.ID
		AND e.Estatus = 'PENDIENTE'
		AND DATEPART(YEAR, e.FechaEmision) = DATEPART(YEAR, @FechaEmision)
		AND DATEPART(MONTH, e.FechaEmision) = DATEPART(MONTH, @FechaEmision)
		AND d.Concepto = @Concepto
		AND e.Moneda = @MovMoneda
		AND ISNULL(d.ContUso, '') = ISNULL(ISNULL(@ContUso, d.ContUso), '')
		AND ISNULL(d.ContUso2, '') = ISNULL(ISNULL(@ContUso2, d.ContUso2), '')
		AND ISNULL(d.ContUso3, '') = ISNULL(ISNULL(@ContUso3, d.ContUso3), '')
		AND mt.Modulo = 'GAS'
		AND mt.Mov = e.Mov
		AND mt.Clave IN ('GAS.S')

	SELECT @GastoPendiente = ISNULL(@GastoPendiente, 0.0)

	IF @EnSilencio = 0
		SELECT 'GastoPendiente' = @GastoPendiente

END
GO