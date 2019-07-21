SET DATEFIRST 7    
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1  
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER VIEW GastoAcum

AS
SELECT
g.Empresa,
g.Moneda,
g.Clase,
g.SubClase,
g.Ejercicio,
g.Periodo,
d.Concepto,
"Cantidad"     = SUM(d.Cantidad) * mt.Factor,
"Retencion1"    = SUM(d.Retencion) * mt.Factor,
"Retencion2"    = SUM(d.Retencion2) * mt.Factor,
"Retencion3"    = SUM(d.Retencion3) * mt.Factor,
"Importe"      = SUM(d.Importe) * mt.Factor,
"Impuestos"    = SUM(d.Impuestos) * mt.Factor,
"Retenciones"  = (SUM(ISNULL(d.Retencion, 0.0) + ISNULL(d.Retencion2, 0.0) + ISNULL(d.Retencion3, 0.0))) * mt.Factor,
"ImporteTotal" = (SUM(ISNULL(d.Importe, 0.0) - ISNULL(d.Retencion, 0.0) - ISNULL(d.Retencion2, 0.0) - ISNULL(d.Retencion3, 0.0) + ISNULL(d.Impuestos, 0.0))) * mt.Factor
FROM Gasto g WITH(NOLOCK)
JOIN GastoD d WITH(NOLOCK) ON g.ID=d.ID
JOIN MovTipo mt WITH(NOLOCK) ON g.Mov = mt.Mov AND mt.Modulo = 'GAS'
WHERE
mt.Clave IN ('GAS.G', 'GAS.GTC', 'GAS.C', 'GAS.CCH', 'GAS.EST', 'GAS.CI', 'GAS.CB'/*, 'GAS.GP'*/) AND g.Estatus='CONCLUIDO'
GROUP BY
g.Empresa, g.Moneda, d.Concepto, g.Clase, g.SubClase, g.Ejercicio, g.Periodo, mt.Factor

