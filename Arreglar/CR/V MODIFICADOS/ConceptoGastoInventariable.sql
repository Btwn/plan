SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER VIEW ConceptoGastoInventariable
AS
SELECT
gd.Cantidad * mt.Factor AS Cantidad,
gd.Concepto,
g.Empresa,
gd.Sucursal,
gd.Importe
FROM dbo.GastoD gd WITH (NOLOCK) JOIN dbo.Gasto g WITH (NOLOCK)
ON g.ID = gd.ID JOIN dbo.MovTipo mt WITH (NOLOCK)
ON mt.Mov = g.Mov JOIN Concepto c WITH (NOLOCK)
ON gd.Concepto = c.Concepto AND c.Modulo = 'GAS'
WHERE mt.Modulo = 'GAS'
AND mt.Clave = 'GAS.CI'
AND g.Estatus = 'CONCLUIDO'

