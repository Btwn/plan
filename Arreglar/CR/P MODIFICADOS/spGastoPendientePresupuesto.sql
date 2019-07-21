SET DATEFIRST 7    
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1  
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spGastoPendientePresupuesto
@Empresa	varchar(5),
@Ejercicio	int,
@Periodo	int,
@Concepto	varchar(50),
@MovMoneda	varchar(10),
@Proyecto 	varchar(50) = NULL,
@GastoPendiente	float OUTPUT

AS BEGIN
SELECT @Proyecto = NULLIF(NULLIF(RTRIM(@Proyecto), '0'), '')
IF (SELECT GastoValidarPresupuestoFR FROM EmpresaCfg2  WITH (NOLOCK) WHERE Empresa = @Empresa) = 1
SELECT @GastoPendiente = SUM(d.Importe*mt.Factor)
FROM Gasto e  WITH (NOLOCK), GastoD d  WITH (NOLOCK), MovTipo mt  WITH (NOLOCK)
WHERE Empresa = @Empresa AND e.ID = d.ID AND e.Estatus = 'PENDIENTE' AND DATEPART(year, e.FechaRequerida) = @Ejercicio AND DATEPART(month, e.FechaRequerida) = @Periodo
AND d.Concepto = @Concepto AND e.Moneda = @MovMoneda AND ISNULL(d.Proyecto, '') = ISNULL(ISNULL(@Proyecto, d.Proyecto), '')
AND mt.Modulo = 'GAS' AND mt.Mov = e.Mov AND mt.Clave IN ('GAS.S', 'GAS.A')
ELSE
SELECT @GastoPendiente = SUM(d.Importe*mt.Factor)
FROM Gasto e  WITH (NOLOCK), GastoD d  WITH (NOLOCK), MovTipo mt  WITH (NOLOCK)
WHERE Empresa = @Empresa AND e.ID = d.ID AND e.Estatus = 'PENDIENTE' AND DATEPART(year, e.FechaEmision) = @Ejercicio AND DATEPART(month, e.FechaEmision) = @Periodo
AND d.Concepto = @Concepto AND e.Moneda = @MovMoneda
AND ISNULL(d.Proyecto, '') = ISNULL(ISNULL(@Proyecto, d.Proyecto), '')
AND mt.Modulo = 'GAS' AND mt.Mov = e.Mov AND mt.Clave IN ('GAS.S', 'GAS.A')
RETURN
END

