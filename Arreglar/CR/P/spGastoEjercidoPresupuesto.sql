SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spGastoEjercidoPresupuesto
@Empresa	varchar(5),
@Ejercicio	int,
@Periodo	int,
@Concepto	varchar(50),
@MovMoneda	varchar(10),
@Proyecto 	varchar(50) = NULL,
@GastoEjercido	float OUTPUT

AS BEGIN
SELECT @Proyecto = NULLIF(NULLIF(RTRIM(@Proyecto), '0'), '')
IF (SELECT GastoValidarPresupuestoFR FROM EmpresaCfg2 WHERE Empresa = @Empresa) = 1
SELECT @GastoEjercido = SUM((d.Importe-ISNULL(d.Provision, 0.0))*CASE WHEN mt.Clave='GAS.DG' THEN -1 ELSE 1 END)
FROM Gasto e, GastoD d, MovTipo mt
WHERE Empresa = @Empresa AND e.ID = d.ID AND e.Estatus IN ('PENDIENTE', 'CONCLUIDO') AND DATEPART(year, e.FechaRequerida) = @Ejercicio AND DATEPART(month, e.FechaRequerida) = @Periodo
AND d.Concepto = @Concepto AND e.Moneda = @MovMoneda
AND ISNULL(d.Proyecto, '') = ISNULL(ISNULL(@Proyecto, d.Proyecto), '')
AND mt.Modulo = 'GAS' AND mt.Mov = e.Mov AND mt.Clave IN ('GAS.G', 'GAS.P', 'GAS.GTC', 'GAS.C', 'GAS.DG', 'GAS.DPR', 'GAS.EST')
ELSE
SELECT @GastoEjercido = SUM((d.Importe-ISNULL(d.Provision, 0.0))*CASE WHEN mt.Clave='GAS.DG' THEN -1 ELSE 1 END)
FROM Gasto e, GastoD d, MovTipo mt
WHERE Empresa = @Empresa AND e.ID = d.ID AND e.Estatus IN ('PENDIENTE', 'CONCLUIDO') AND DATEPART(year, e.FechaEmision) = @Ejercicio AND DATEPART(month, e.FechaEmision) = @Periodo
AND d.Concepto = @Concepto AND e.Moneda = @MovMoneda AND ISNULL(d.Proyecto, '') = ISNULL(ISNULL(@Proyecto, d.Proyecto), '')
AND mt.Modulo = 'GAS' AND mt.Mov = e.Mov AND mt.Clave IN ('GAS.G', 'GAS.P', 'GAS.GTC', 'GAS.C', 'GAS.DG', 'GAS.DPR', 'GAS.EST')
RETURN
END

