SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER FUNCTION fnCalcPrepEjercido (@Empresa char(5),@Concepto varchar(50),@FechaD datetime,@FechaA Datetime,@Cual VarChar(10))
RETURNS Money
AS BEGIN
DECLARE
@Importe		Money
IF @Cual='Ejercido'
begin
SELECT @Importe=SUM((d.Importe-ISNULL(d.Provision, 0.0))*e.TipoCambio*CASE WHEN mt.Clave='GAS.DG' THEN -1 ELSE 1 END)
FROM Gasto e WITH (NOLOCK), GastoD d WITH (NOLOCK), MovTipo mt WITH (NOLOCK)
WHERE Empresa = @Empresa AND e.ID = d.ID AND e.Estatus IN ('PENDIENTE', 'CONCLUIDO')
AND e.Fechaemision between @Fechad and @FechaA
AND d.Concepto = @Concepto /*AND e.Moneda = @MovMoneda*/
AND mt.Modulo = 'GAS' AND mt.Mov = e.Mov AND mt.Clave IN ('GAS.G', 'GAS.P', 'GAS.GTC', 'GAS.C', 'GAS.DG', 'GAS.DPR', 'GAS.EST', 'GAS.CI')
end
IF @Cual='Pendiente'
begin
SELECT @Importe=(SUM(d.Importe*mt.Factor*e.TipoCambio))
FROM Gasto e WITH (NOLOCK), GastoD d WITH (NOLOCK), MovTipo mt WITH (NOLOCK)
WHERE Empresa = @Empresa AND e.ID = d.ID AND e.Estatus = 'PENDIENTE'
AND e.Fechaemision between @Fechad and @FechaA
AND d.Concepto = @Concepto
AND mt.Modulo = 'GAS' AND mt.Mov = e.Mov AND mt.Clave IN ('GAS.S', 'GAS.A')
end
RETURN(@Importe)
END

