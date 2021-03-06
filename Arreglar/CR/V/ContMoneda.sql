SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER VIEW ContMoneda

AS
SELECT
ec.Empresa,
ec.ContMoneda,
m.TipoCambio,
m.TipoCambio TipoCambioInv
FROM EmpresaCfg ec JOIN Mon m
ON m.Moneda = ec.ContMoneda

