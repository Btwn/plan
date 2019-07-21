SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spIVADeclarado
@Estacion	int,
@FechaD		Datetime,
@FechaA		Datetime,
@Empresa	char(5)

AS BEGIN
DELETE FROM IVADeclaradoInicial WHERE Estacion = @Estacion
INSERT IVADeclaradoInicial (
Estacion,  Empresa,   Proveedor,   RFC,   Nombre,   OrigenMov, OrigenMovID, TipoOperacion,   ModuloMov, ModuloMovID, Mov,   MovID,   Descripcion, DestinoMov, DestinoMovID, FechaConciliacion,
Importe,                  Impuesto, Impuesto15, Impuesto10, ImpuestoValidar, IvaOExento, RetencionIVA, RetencionISR, PorcentajeDeducible)
SELECT @Estacion, a.Empresa, a.Proveedor, p.RFC, p.Nombre, y.Mov,     y.MovID,     g.TipoOperacion , x.Mov,     x.MovID,     a.Mov, a.MovID, z.Concepto,  e.Mov,      e.MovID,      e.FechaConciliacion,
Importe = CASE WHEN b.importe - (b.Importe * h.Ivafiscal) <>
((((CONVERT(float, z.Importe)/CONVERT(float, y.Importe)) * b.Importe) - (((CONVERT(float, z.Importe)/CONVERT(float, y.Importe)) * b.Importe) * ISNULL(h.IvaFiscal, 0))) ) THEN
((((CONVERT(float, z.Importe)/CONVERT(float, y.Importe)) * b.Importe) - (((CONVERT(float, z.Importe)/CONVERT(float, y.Importe)) * b.Importe) * ISNULL(h.IvaFiscal, 0))) ) +
ISNULL((z.Importe - ((((CONVERT(float, z.Importe)/CONVERT(float, y.Importe)) * b.Importe) - (((CONVERT(float, z.Importe)/CONVERT(float, y.Importe)) * b.Importe) * ISNULL(h.IvaFiscal, 0))))), 0) * e.TipoCambio ELSE
((((CONVERT(float, z.Importe)/CONVERT(float, y.Importe)) * b.Importe) - (((CONVERT(float, z.Importe)/CONVERT(float, y.Importe)) * b.Importe) * ISNULL(h.IvaFiscal, 0))) ) +
ISNULL((((((CONVERT(float, z.Importe)/CONVERT(float, y.Importe)) * b.Importe) - (((CONVERT(float, z.Importe)/CONVERT(float, y.Importe)) * b.Importe) * ISNULL(h.IvaFiscal, 0))) ) / (y.importe - (y.importe * (dbo.fnConceptoImpuestoTasa(@Empresa, 'GAS', z.Concepto,'Retencion2')/100))) * z.Retencion2), 0) +
ISNULL((((((CONVERT(float, z.Importe)/CONVERT(float, y.Importe)) * b.Importe) - (((CONVERT(float, z.Importe)/CONVERT(float, y.Importe)) * b.Importe) * ISNULL(h.IvaFiscal, 0))) ) / (y.importe - (y.importe * (dbo.fnConceptoImpuestoTasa(@Empresa, 'GAS', z.Concepto,'Retencion1')/100))) * z.Retencion), 0) * e.TipoCambio END,
Impuestos = (CASE WHEN ISNULL(y.Impuestos, 0) <> 0 THEN (((CONVERT(float, z.Impuestos)/CONVERT(float, y.Impuestos))) * ISNULL(h.IvaFiscal, 0)) * b.Importe ELSE 0 END) * e.TipoCambio,
Impuesto15 = CASE WHEN ROUND(z.Impuestos/z.Importe, 2) = 0.16 THEN (CASE WHEN ISNULL(y.Impuestos, 0) <> 0 THEN (((CONVERT(float, z.Impuestos)/CONVERT(float, y.Impuestos))) * ISNULL(h.IvaFiscal, 0)) * b.Importe ELSE 0 END) * e.TipoCambio END,
Impuesto10 = CASE WHEN ROUND(z.Impuestos/z.Importe, 2) = 0.11 THEN (CASE WHEN ISNULL(y.Impuestos, 0) <> 0 THEN (((CONVERT(float, z.Impuestos)/CONVERT(float, y.Impuestos))) * ISNULL(h.IvaFiscal, 0)) * b.Importe ELSE 0 END) * e.TipoCambio END,
ImpuestoValidar = CASE WHEN (ROUND(z.Impuestos/z.Importe, 2) <> 0.11) AND (ROUND(z.Impuestos/z.Importe, 2) <> 0.16) THEN (CASE WHEN ISNULL(y.Impuestos, 0) <> 0 THEN (((CONVERT(float, z.Impuestos)/CONVERT(float, y.Impuestos))) * ISNULL(h.IvaFiscal, 0)) * b.Importe ELSE 0 END) * e.TipoCambio END,
IvaOExento = CASE WHEN (g.Impuesto1Excento = 0) AND (((CASE WHEN ROUND(z.Impuestos/z.Importe, 2) = 0.16 THEN z.Impuestos * e.TipoCambio END) IS NULL) AND ((CASE WHEN ROUND(z.Impuestos/z.Importe, 2) = 0.11 THEN z.Impuestos * e.TipoCambio END) IS NULL)) THEN 'IVA 0%'
WHEN (g.Impuesto1Excento = 0) AND ((CASE WHEN ROUND(z.Impuestos/z.Importe, 2) = 0.16 THEN z.Impuestos * e.TipoCambio END) IS NOT NULL) THEN 'IVA 16%'
WHEN (g.Impuesto1Excento = 0) AND ((CASE WHEN ROUND(z.Impuestos/z.Importe, 2) = 0.11 THEN z.Impuestos * e.TipoCambio END) IS NOT NULL) THEN 'IVA 11%'
WHEN (g.Impuesto1Excento = 1) THEN 'Exento' ELSE 'No Aplica' END,
RetencionIVA = CASE WHEN b.importe - (b.Importe * h.Ivafiscal) <> ((((CONVERT(float, z.Importe)/CONVERT(float, y.Importe)) * b.Importe) - (((CONVERT(float, z.Importe)/CONVERT(float, y.Importe)) * b.Importe) * ISNULL(h.IvaFiscal, 0))) ) THEN
ISNULL(((((((CONVERT(float, z.Importe)/CONVERT(float, y.Importe)) * b.Importe) - (((CONVERT(float, z.Importe)/CONVERT(float, y.Importe)) * b.Importe) * ISNULL(h.IvaFiscal, 0))) ) +
ISNULL((z.Importe - ((((CONVERT(float, z.Importe)/CONVERT(float, y.Importe)) * b.Importe) - (((CONVERT(float, z.Importe)/CONVERT(float, y.Importe)) * b.Importe) * ISNULL(h.IvaFiscal, 0))))), 0)) * (dbo.fnConceptoImpuestoTasa(@Empresa, 'GAS', z.Concepto,'Retencion2')/100)),0) * e.TipoCambio ELSE 
ISNULL(((((((CONVERT(float, z.Importe)/CONVERT(float, y.Importe)) * b.Importe) - (((CONVERT(float, z.Importe)/CONVERT(float, y.Importe)) * b.Importe) * ISNULL(h.IvaFiscal, 0))) ) +
ISNULL((((((CONVERT(float, z.Importe)/CONVERT(float, y.Importe)) * b.Importe) - (((CONVERT(float, z.Importe)/CONVERT(float, y.Importe)) * b.Importe) * ISNULL(h.IvaFiscal, 0))) ) / (y.importe - (y.importe * (dbo.fnConceptoImpuestoTasa(@Empresa, 'GAS', z.Concepto,'Retencion2')/100))) * z.Retencion2), 0) +
ISNULL((((((CONVERT(float, z.Importe)/CONVERT(float, y.Importe)) * b.Importe) - (((CONVERT(float, z.Importe)/CONVERT(float, y.Importe)) * b.Importe) * ISNULL(h.IvaFiscal, 0))) ) / (y.importe - (y.importe * (dbo.fnConceptoImpuestoTasa(@Empresa, 'GAS', z.Concepto,'Retencion1')/100))) * z.Retencion), 0)) * (dbo.fnConceptoImpuestoTasa(@Empresa, 'GAS', z.Concepto,'Retencion2')/100)),0) * e.TipoCambio END,
RetencionISR = CASE WHEN b.importe - (b.Importe * h.Ivafiscal) <> ((((CONVERT(float, z.Importe)/CONVERT(float, y.Importe)) * b.Importe) - (((CONVERT(float, z.Importe)/CONVERT(float, y.Importe)) * b.Importe) * ISNULL(h.IvaFiscal, 0))) ) THEN
ISNULL(((((((CONVERT(float, z.Importe)/CONVERT(float, y.Importe)) * b.Importe) - (((CONVERT(float, z.Importe)/CONVERT(float, y.Importe)) * b.Importe) * ISNULL(h.IvaFiscal, 0))) ) +
ISNULL((z.Importe - ((((CONVERT(float, z.Importe)/CONVERT(float, y.Importe)) * b.Importe) - (((CONVERT(float, z.Importe)/CONVERT(float, y.Importe)) * b.Importe) * ISNULL(h.IvaFiscal, 0))))), 0)) * (dbo.fnConceptoImpuestoTasa(@Empresa, 'GAS', z.Concepto,'Retencion1')/100)),0) * e.TipoCambio ELSE
ISNULL(((((((CONVERT(float, z.Importe)/CONVERT(float, y.Importe)) * b.Importe) - (((CONVERT(float, z.Importe)/CONVERT(float, y.Importe)) * b.Importe) * ISNULL(h.IvaFiscal, 0))) ) +
ISNULL((((((CONVERT(float, z.Importe)/CONVERT(float, y.Importe)) * b.Importe) - (((CONVERT(float, z.Importe)/CONVERT(float, y.Importe)) * b.Importe) * ISNULL(h.IvaFiscal, 0))) ) / (y.importe - (y.importe * (dbo.fnConceptoImpuestoTasa(@Empresa, 'GAS', z.Concepto,'Retencion2')/100))) * z.Retencion2), 0) +
ISNULL((((((CONVERT(float, z.Importe)/CONVERT(float, y.Importe)) * b.Importe) - (((CONVERT(float, z.Importe)/CONVERT(float, y.Importe)) * b.Importe) * ISNULL(h.IvaFiscal, 0))) ) / (y.importe - (y.importe * (dbo.fnConceptoImpuestoTasa(@Empresa, 'GAS', z.Concepto,'Retencion1')/100))) * z.Retencion), 0)) * (dbo.fnConceptoImpuestoTasa(@Empresa, 'GAS', z.Concepto,'Retencion1')/100)),0) * e.TipoCambio END,
z.PorcentajeDeducible
FROM Cxp a
JOIN CxpD b ON a.ID = b.ID
JOIN MovTipo mtx ON mtx.Mov = a.Mov AND mtx.Modulo = 'CXP' AND mtx.Clave = 'CXP.P'
JOIN CxpAplica h ON b.Aplica = h.Mov AND b.AplicaID = h.MovID AND h.Empresa = @Empresa
JOIN Dinero e ON e.CtaDinero = a.DineroCtaDinero AND a.Dinero = e.Mov AND a.DineroID = e.MovID
JOIN MovTipo mt2 ON mt2.Mov = e.Mov AND mt2.Modulo = 'DIN' AND mt2.Clave IN ('DIN.CH', 'DIN.CHE', 'DIN.E')
JOIN Prov p ON a.Proveedor = p.Proveedor
JOIN Cxp x ON b.Aplica = x.Mov AND b.AplicaID = x.MovID
JOIN Gasto y ON x.Origen = y.Mov AND x.OrigenID = y.MovID
JOIN GastoD z ON y.ID = z.ID
LEFT OUTER JOIN Concepto g ON z.Concepto = g.Concepto AND g.Modulo = 'GAS'
JOIN MovTipo mt3 ON mt3.Mov = y.Mov AND mt3.Modulo = 'GAS' AND mt3.Clave = 'GAS.G'
JOIN MovTipo mt4 ON mt4.Mov = b.Aplica AND mt4.Modulo = 'CXP' AND mt4.Clave IN ('CXP.AA','CXP.AF','CXP.D','CXP.DA','CXP.F')
WHERE
e.FechaConciliacion BETWEEN @FechaD AND @FechaA
AND a.Estatus = 'CONCLUIDO'
AND e.Estatus IN ('CONCILIADO', 'CONCLUIDO') 
AND x.Estatus IN ('PENDIENTE', 'CONCLUIDO')
AND y.Estatus = 'CONCLUIDO'
AND a.Empresa = @Empresa
AND e.Empresa = @Empresa
AND x.Empresa = @Empresa
AND y.Empresa = @Empresa
INSERT IVADeclaradoInicial (
Estacion,  Empresa,   Proveedor,   RFC,   Nombre,   OrigenMov, OrigenMovID, TipoOperacion,   ModuloMov, ModuloMovID, Mov,   MovID,   Descripcion, DestinoMov, DestinoMovID, FechaConciliacion,
Importe, Impuesto, Impuesto15, Impuesto10, ImpuestoValidar, IvaOExento, RetencionIVA, RetencionISR, PorcentajeDeducible)
SELECT @Estacion, a.Empresa, a.Proveedor, p.RFC, p.Nombre, y.Mov,     y.MovID,     g.TipoOperacion, x.Mov,     x.MovID,     a.Mov, a.MovID, z.Concepto,  e.Mov,      e.MovID,      e.FechaConciliacion,
Importe = CASE WHEN b.importe - (b.Importe * h.Ivafiscal) <>
((((CONVERT(float, z.Importe)/CONVERT(float, y.Importe)) * b.Importe) - (((CONVERT(float, z.Importe)/CONVERT(float, y.Importe)) * b.Importe) * ISNULL(h.IvaFiscal, 0))) ) THEN
((((CONVERT(float, z.Importe)/CONVERT(float, y.Importe)) * b.Importe) - (((CONVERT(float, z.Importe)/CONVERT(float, y.Importe)) * b.Importe) * ISNULL(h.IvaFiscal, 0))) ) +
ISNULL((z.Importe - ((((CONVERT(float, z.Importe)/CONVERT(float, y.Importe)) * b.Importe) - (((CONVERT(float, z.Importe)/CONVERT(float, y.Importe)) * b.Importe) * ISNULL(h.IvaFiscal, 0))))), 0) * e.TipoCambio ELSE
((((CONVERT(float, z.Importe)/CONVERT(float, y.Importe)) * b.Importe) - (((CONVERT(float, z.Importe)/CONVERT(float, y.Importe)) * b.Importe) * ISNULL(h.IvaFiscal, 0))) ) +
ISNULL((((((CONVERT(float, z.Importe)/CONVERT(float, y.Importe)) * b.Importe) - (((CONVERT(float, z.Importe)/CONVERT(float, y.Importe)) * b.Importe) * ISNULL(h.IvaFiscal, 0))) ) / (y.importe - (y.importe * (dbo.fnConceptoImpuestoTasa(@Empresa, 'GAS', z.Concepto,'Retencion2')/100))) * z.Retencion2), 0) +
ISNULL((((((CONVERT(float, z.Importe)/CONVERT(float, y.Importe)) * b.Importe) - (((CONVERT(float, z.Importe)/CONVERT(float, y.Importe)) * b.Importe) * ISNULL(h.IvaFiscal, 0))) ) / (y.importe - (y.importe * (dbo.fnConceptoImpuestoTasa(@Empresa, 'GAS', z.Concepto,'Retencion1')/100))) * z.Retencion), 0) * e.TipoCambio END,
Impuestos = (CASE WHEN ISNULL(y.Impuestos, 0) <> 0 THEN (((CONVERT(float, z.Impuestos)/CONVERT(float, y.Impuestos))) * ISNULL(h.IvaFiscal, 0)) * c.Importe ELSE 0 END) * e.TipoCambio,
Impuesto15 = CASE WHEN ROUND(z.Impuestos/z.Importe, 2) = 0.16 THEN (CASE WHEN ISNULL(y.Impuestos, 0) <> 0 THEN (((CONVERT(float, z.Impuestos)/CONVERT(float, y.Impuestos))) * ISNULL(h.IvaFiscal, 0)) * c.Importe ELSE 0 END) * e.TipoCambio END,
Impuesto10 = CASE WHEN ROUND(z.Impuestos/z.Importe, 2) = 0.11 THEN (CASE WHEN ISNULL(y.Impuestos, 0) <> 0 THEN (((CONVERT(float, z.Impuestos)/CONVERT(float, y.Impuestos))) * ISNULL(h.IvaFiscal, 0)) * c.Importe ELSE 0 END) * e.TipoCambio END,
ImpuestoValidar = CASE WHEN (ROUND(z.Impuestos/z.Importe, 2) <> 0.11) AND (ROUND(z.Impuestos/z.Importe, 2) <> 0.16) THEN (CASE WHEN ISNULL(y.Impuestos, 0) <> 0 THEN (((CONVERT(float, z.Impuestos)/CONVERT(float, y.Impuestos))) * ISNULL(h.IvaFiscal, 0)) * b.Importe ELSE 0 END) * e.TipoCambio END,
IvaOExento = CASE WHEN (g.Impuesto1Excento = 0) AND (((CASE WHEN ROUND(z.Impuestos/z.Importe, 2) = 0.16 THEN z.Impuestos * e.TipoCambio END) IS NULL) AND ((CASE WHEN ROUND(z.Impuestos/z.Importe, 2) = 0.11 THEN z.Impuestos * e.TipoCambio END) IS NULL)) THEN 'IVA 0%'
WHEN (g.Impuesto1Excento = 0) AND ((CASE WHEN ROUND(z.Impuestos/z.Importe, 2) = 0.16 THEN z.Impuestos * e.TipoCambio END) IS NOT NULL) THEN 'IVA 16%'
WHEN (g.Impuesto1Excento = 0) AND ((CASE WHEN ROUND(z.Impuestos/z.Importe, 2) = 0.11 THEN z.Impuestos * e.TipoCambio END) IS NOT NULL) THEN 'IVA 11%'
WHEN (g.Impuesto1Excento = 1) THEN 'Exento' ELSE 'No Aplica' END,
RetencionIVA = CASE WHEN b.importe - (b.Importe * h.Ivafiscal) <> ((((CONVERT(float, z.Importe)/CONVERT(float, y.Importe)) * b.Importe) - (((CONVERT(float, z.Importe)/CONVERT(float, y.Importe)) * b.Importe) * ISNULL(h.IvaFiscal, 0))) ) THEN
ISNULL(((((((CONVERT(float, z.Importe)/CONVERT(float, y.Importe)) * b.Importe) - (((CONVERT(float, z.Importe)/CONVERT(float, y.Importe)) * b.Importe) * ISNULL(h.IvaFiscal, 0))) ) +
ISNULL((z.Importe - ((((CONVERT(float, z.Importe)/CONVERT(float, y.Importe)) * b.Importe) - (((CONVERT(float, z.Importe)/CONVERT(float, y.Importe)) * b.Importe) * ISNULL(h.IvaFiscal, 0))))), 0)) * (dbo.fnConceptoImpuestoTasa(@Empresa, 'GAS', z.Concepto,'Retencion2')/100)),0) * e.TipoCambio ELSE
ISNULL(((((((CONVERT(float, z.Importe)/CONVERT(float, y.Importe)) * b.Importe) - (((CONVERT(float, z.Importe)/CONVERT(float, y.Importe)) * b.Importe) * ISNULL(h.IvaFiscal, 0))) ) +
ISNULL((((((CONVERT(float, z.Importe)/CONVERT(float, y.Importe)) * b.Importe) - (((CONVERT(float, z.Importe)/CONVERT(float, y.Importe)) * b.Importe) * ISNULL(h.IvaFiscal, 0))) ) / (y.importe - (y.importe * (dbo.fnConceptoImpuestoTasa(@Empresa, 'GAS', z.Concepto,'Retencion2')/100))) * z.Retencion2), 0) +
ISNULL((((((CONVERT(float, z.Importe)/CONVERT(float, y.Importe)) * b.Importe) - (((CONVERT(float, z.Importe)/CONVERT(float, y.Importe)) * b.Importe) * ISNULL(h.IvaFiscal, 0))) ) / (y.importe - (y.importe * (dbo.fnConceptoImpuestoTasa(@Empresa, 'GAS', z.Concepto,'Retencion1')/100))) * z.Retencion), 0)) * (dbo.fnConceptoImpuestoTasa(@Empresa, 'GAS', z.Concepto,'Retencion2')/100)),0) * e.TipoCambio END,
RetencionISR = CASE WHEN b.importe - (b.Importe * h.Ivafiscal) <> ((((CONVERT(float, z.Importe)/CONVERT(float, y.Importe)) * b.Importe) - (((CONVERT(float, z.Importe)/CONVERT(float, y.Importe)) * b.Importe) * ISNULL(h.IvaFiscal, 0))) ) THEN
ISNULL(((((((CONVERT(float, z.Importe)/CONVERT(float, y.Importe)) * b.Importe) - (((CONVERT(float, z.Importe)/CONVERT(float, y.Importe)) * b.Importe) * ISNULL(h.IvaFiscal, 0))) ) +
ISNULL((z.Importe - ((((CONVERT(float, z.Importe)/CONVERT(float, y.Importe)) * b.Importe) - (((CONVERT(float, z.Importe)/CONVERT(float, y.Importe)) * b.Importe) * ISNULL(h.IvaFiscal, 0))))), 0)) * (dbo.fnConceptoImpuestoTasa(@Empresa, 'GAS', z.Concepto,'Retencion1')/100)),0) * e.TipoCambio ELSE
ISNULL(((((((CONVERT(float, z.Importe)/CONVERT(float, y.Importe)) * b.Importe) - (((CONVERT(float, z.Importe)/CONVERT(float, y.Importe)) * b.Importe) * ISNULL(h.IvaFiscal, 0))) ) +
ISNULL((((((CONVERT(float, z.Importe)/CONVERT(float, y.Importe)) * b.Importe) - (((CONVERT(float, z.Importe)/CONVERT(float, y.Importe)) * b.Importe) * ISNULL(h.IvaFiscal, 0))) ) / (y.importe - (y.importe * (dbo.fnConceptoImpuestoTasa(@Empresa, 'GAS', z.Concepto,'Retencion2')/100))) * z.Retencion2), 0) +
ISNULL((((((CONVERT(float, z.Importe)/CONVERT(float, y.Importe)) * b.Importe) - (((CONVERT(float, z.Importe)/CONVERT(float, y.Importe)) * b.Importe) * ISNULL(h.IvaFiscal, 0))) ) / (y.importe - (y.importe * (dbo.fnConceptoImpuestoTasa(@Empresa, 'GAS', z.Concepto,'Retencion1')/100))) * z.Retencion), 0)) * (dbo.fnConceptoImpuestoTasa(@Empresa, 'GAS', z.Concepto,'Retencion1')/100)),0) * e.TipoCambio END,
z.PorcentajeDeducible
FROM Cxp c
JOIN CxpD b ON c.ID = b.ID
JOIN MovTipo mty ON mty.Mov = c.Mov AND mty.Modulo = 'CXP' AND mty.Clave = 'CXP.ANC'
JOIN MovFlujo w ON w.DMov = c.Mov AND w.DMovID = c.MovID AND w.OModulo = 'CXP'
JOIN Cxp a ON w.OMov = a.Mov AND w.OMovID = a.MovID AND w.DModulo = 'CXP'
JOIN MovTipo mtx ON mtx.Mov = a.Mov AND mtx.Modulo = 'CXP' AND mtX.Clave = 'CXP.A'
JOIN CxpAplica h ON c.Mov = h.Mov AND c.MovID = h.MovID AND h.Empresa = @Empresa
JOIN Cxp x ON b.Aplica = x.Mov AND b.AplicaID = x.MovID
JOIN Gasto y ON x.Origen = y.Mov AND x.OrigenID = y.MovID
JOIN GastoD z ON y.ID = z.ID
LEFT OUTER JOIN Concepto g ON z.Concepto = g.Concepto AND g.Modulo = 'GAS'
JOIN MovTipo mt3 ON mt3.Mov = y.Mov AND mt3.Modulo = 'GAS' AND mt3.Clave = 'GAS.G'
JOIN Dinero e ON e.CtaDinero = a.DineroCtaDinero AND a.Dinero = e.Mov AND a.DineroID = e.MovID
JOIN MovTipo mt2 ON mt2.Mov = e.Mov AND mt2.Modulo = 'DIN' AND mt2.Clave IN ('DIN.CH', 'DIN.CHE', 'DIN.E')
JOIN Prov p ON a.Proveedor = p.Proveedor
JOIN MovTipo mt4 ON mt4.Mov = b.Aplica AND mt4.Modulo = 'CXP' AND mt4.Clave IN ('CXP.AA','CXP.AF','CXP.D','CXP.DA','CXP.F')
WHERE
e.FechaConciliacion BETWEEN @FechaD AND @FechaA
AND a.Estatus = 'CONCLUIDO'
AND e.Estatus IN ('CONCILIADO', 'CONCLUIDO') 
AND x.Estatus IN ('PENDIENTE', 'CONCLUIDO')
AND y.Estatus = 'CONCLUIDO'
AND a.Empresa = @Empresa
AND c.Empresa = @Empresa
AND x.Empresa = @Empresa
AND y.Empresa = @Empresa
AND e.Empresa = @Empresa
INSERT IVADeclaradoInicial (
Estacion,  Empresa,   Proveedor,   RFC,   Nombre,   OrigenMov, OrigenMovID, TipoOperacion,   ModuloMov, ModuloMovID, Mov,   MovID,   Descripcion, DestinoMov, DestinoMovID, FechaConciliacion,
Importe, Impuesto, Impuesto15, Impuesto10, ImpuestoValidar, IvaOExento, RetencionIVA, RetencionISR, PorcentajeDeducible)
SELECT @Estacion, a.Empresa, a.Proveedor, p.RFC, p.Nombre, y.Mov,     y.MovID,     g.TipoOperacion, x.Mov,     x.MovID,     a.Mov, a.MovID, z.Concepto,  e.Mov,      e.MovID,      e.FechaConciliacion,
Importe = CASE WHEN b.importe - (b.Importe * h.Ivafiscal) <>
((((CONVERT(float, z.Importe)/CONVERT(float, y.Importe)) * b.Importe) - (((CONVERT(float, z.Importe)/CONVERT(float, y.Importe)) * b.Importe) * ISNULL(h.IvaFiscal, 0))) ) THEN
((((CONVERT(float, z.Importe)/CONVERT(float, y.Importe)) * b.Importe) - (((CONVERT(float, z.Importe)/CONVERT(float, y.Importe)) * b.Importe) * ISNULL(h.IvaFiscal, 0))) ) +
ISNULL((z.Importe - ((((CONVERT(float, z.Importe)/CONVERT(float, y.Importe)) * b.Importe) - (((CONVERT(float, z.Importe)/CONVERT(float, y.Importe)) * b.Importe) * ISNULL(h.IvaFiscal, 0))))), 0) * e.TipoCambio ELSE
((((CONVERT(float, z.Importe)/CONVERT(float, y.Importe)) * b.Importe) - (((CONVERT(float, z.Importe)/CONVERT(float, y.Importe)) * b.Importe) * ISNULL(h.IvaFiscal, 0))) ) +
ISNULL((((((CONVERT(float, z.Importe)/CONVERT(float, y.Importe)) * b.Importe) - (((CONVERT(float, z.Importe)/CONVERT(float, y.Importe)) * b.Importe) * ISNULL(h.IvaFiscal, 0))) ) / (y.importe - (y.importe * (dbo.fnConceptoImpuestoTasa(@Empresa, 'GAS', z.Concepto,'Retencion2')/100))) * z.Retencion2), 0) +
ISNULL((((((CONVERT(float, z.Importe)/CONVERT(float, y.Importe)) * b.Importe) - (((CONVERT(float, z.Importe)/CONVERT(float, y.Importe)) * b.Importe) * ISNULL(h.IvaFiscal, 0))) ) / (y.importe - (y.importe * (dbo.fnConceptoImpuestoTasa(@Empresa, 'GAS', z.Concepto,'Retencion1')/100))) * z.Retencion), 0) * e.TipoCambio END,
Impuestos = (CASE WHEN ISNULL(y.Impuestos, 0) <> 0 THEN (((CONVERT(float, z.Impuestos)/CONVERT(float, y.Impuestos))) * ISNULL(h.IvaFiscal, 0)) * b.Importe ELSE 0 END) * e.TipoCambio,
Impuesto15 = CASE WHEN ROUND(z.Impuestos/z.Importe, 2) = 0.16 THEN (CASE WHEN ISNULL(y.Impuestos, 0) <> 0 THEN (((CONVERT(float, z.Impuestos)/CONVERT(float, y.Impuestos))) * ISNULL(h.IvaFiscal, 0)) * b.Importe ELSE 0 END) * e.TipoCambio END,
Impuesto10 = CASE WHEN ROUND(z.Impuestos/z.Importe, 2) = 0.11 THEN (CASE WHEN ISNULL(y.Impuestos, 0) <> 0 THEN (((CONVERT(float, z.Impuestos)/CONVERT(float, y.Impuestos))) * ISNULL(h.IvaFiscal, 0)) * b.Importe ELSE 0 END) * e.TipoCambio END,
ImpuestoValidar = CASE WHEN (ROUND(z.Impuestos/z.Importe, 2) <> 0.11) AND (ROUND(z.Impuestos/z.Importe, 2) <> 0.16) THEN (CASE WHEN ISNULL(y.Impuestos, 0) <> 0 THEN (((CONVERT(float, z.Impuestos)/CONVERT(float, y.Impuestos))) * ISNULL(h.IvaFiscal, 0)) * b.Importe ELSE 0 END) * e.TipoCambio END,
IvaOExento = CASE WHEN (g.Impuesto1Excento = 0) AND (((CASE WHEN ROUND(z.Impuestos/z.Importe, 2) = 0.16 THEN z.Impuestos * e.TipoCambio END) IS NULL) AND ((CASE WHEN ROUND(z.Impuestos/z.Importe, 2) = 0.11 THEN z.Impuestos * e.TipoCambio END) IS NULL)) THEN 'IVA 0%'
WHEN (g.Impuesto1Excento = 0) AND ((CASE WHEN ROUND(z.Impuestos/z.Importe, 2) = 0.16 THEN z.Impuestos * e.TipoCambio END) IS NOT NULL) THEN 'IVA 16%'
WHEN (g.Impuesto1Excento = 0) AND ((CASE WHEN ROUND(z.Impuestos/z.Importe, 2) = 0.11 THEN z.Impuestos * e.TipoCambio END) IS NOT NULL) THEN 'IVA 11%'
WHEN (g.Impuesto1Excento = 1) THEN 'Exento' ELSE 'No Aplica' END,
RetencionIVA = CASE WHEN b.importe - (b.Importe * h.Ivafiscal) <> ((((CONVERT(float, z.Importe)/CONVERT(float, y.Importe)) * b.Importe) - (((CONVERT(float, z.Importe)/CONVERT(float, y.Importe)) * b.Importe) * ISNULL(h.IvaFiscal, 0))) ) THEN
ISNULL(((((((CONVERT(float, z.Importe)/CONVERT(float, y.Importe)) * b.Importe) - (((CONVERT(float, z.Importe)/CONVERT(float, y.Importe)) * b.Importe) * ISNULL(h.IvaFiscal, 0))) ) +
ISNULL((z.Importe - ((((CONVERT(float, z.Importe)/CONVERT(float, y.Importe)) * b.Importe) - (((CONVERT(float, z.Importe)/CONVERT(float, y.Importe)) * b.Importe) * ISNULL(h.IvaFiscal, 0))))), 0)) * (dbo.fnConceptoImpuestoTasa(@Empresa, 'GAS', z.Concepto,'Retencion2')/100)),0) * e.TipoCambio ELSE
ISNULL(((((((CONVERT(float, z.Importe)/CONVERT(float, y.Importe)) * b.Importe) - (((CONVERT(float, z.Importe)/CONVERT(float, y.Importe)) * b.Importe) * ISNULL(h.IvaFiscal, 0))) ) +
ISNULL((((((CONVERT(float, z.Importe)/CONVERT(float, y.Importe)) * b.Importe) - (((CONVERT(float, z.Importe)/CONVERT(float, y.Importe)) * b.Importe) * ISNULL(h.IvaFiscal, 0))) ) / (y.importe - (y.importe * (dbo.fnConceptoImpuestoTasa(@Empresa, 'GAS', z.Concepto,'Retencion2')/100))) * z.Retencion2), 0) +
ISNULL((((((CONVERT(float, z.Importe)/CONVERT(float, y.Importe)) * b.Importe) - (((CONVERT(float, z.Importe)/CONVERT(float, y.Importe)) * b.Importe) * ISNULL(h.IvaFiscal, 0))) ) / (y.importe - (y.importe * (dbo.fnConceptoImpuestoTasa(@Empresa, 'GAS', z.Concepto,'Retencion1')/100))) * z.Retencion), 0)) * (dbo.fnConceptoImpuestoTasa(@Empresa, 'GAS', z.Concepto,'Retencion2')/100)),0) * e.TipoCambio END,
RetencionISR = CASE WHEN b.importe - (b.Importe * h.Ivafiscal) <> ((((CONVERT(float, z.Importe)/CONVERT(float, y.Importe)) * b.Importe) - (((CONVERT(float, z.Importe)/CONVERT(float, y.Importe)) * b.Importe) * ISNULL(h.IvaFiscal, 0))) ) THEN
ISNULL(((((((CONVERT(float, z.Importe)/CONVERT(float, y.Importe)) * b.Importe) - (((CONVERT(float, z.Importe)/CONVERT(float, y.Importe)) * b.Importe) * ISNULL(h.IvaFiscal, 0))) ) +
ISNULL((z.Importe - ((((CONVERT(float, z.Importe)/CONVERT(float, y.Importe)) * b.Importe) - (((CONVERT(float, z.Importe)/CONVERT(float, y.Importe)) * b.Importe) * ISNULL(h.IvaFiscal, 0))))), 0)) * (dbo.fnConceptoImpuestoTasa(@Empresa, 'GAS', z.Concepto,'Retencion1')/100)),0) * e.TipoCambio ELSE
ISNULL(((((((CONVERT(float, z.Importe)/CONVERT(float, y.Importe)) * b.Importe) - (((CONVERT(float, z.Importe)/CONVERT(float, y.Importe)) * b.Importe) * ISNULL(h.IvaFiscal, 0))) ) +
ISNULL((((((CONVERT(float, z.Importe)/CONVERT(float, y.Importe)) * b.Importe) - (((CONVERT(float, z.Importe)/CONVERT(float, y.Importe)) * b.Importe) * ISNULL(h.IvaFiscal, 0))) ) / (y.importe - (y.importe * (dbo.fnConceptoImpuestoTasa(@Empresa, 'GAS', z.Concepto,'Retencion2')/100))) * z.Retencion2), 0) +
ISNULL((((((CONVERT(float, z.Importe)/CONVERT(float, y.Importe)) * b.Importe) - (((CONVERT(float, z.Importe)/CONVERT(float, y.Importe)) * b.Importe) * ISNULL(h.IvaFiscal, 0))) ) / (y.importe - (y.importe * (dbo.fnConceptoImpuestoTasa(@Empresa, 'GAS', z.Concepto,'Retencion1')/100))) * z.Retencion), 0)) * (dbo.fnConceptoImpuestoTasa(@Empresa, 'GAS', z.Concepto,'Retencion1')/100)),0) * e.TipoCambio END,
z.PorcentajeDeducible
FROM Cxp a
JOIN CxpD b ON a.ID = b.ID
JOIN MovTipo mtx ON mtx.Mov = a.Mov AND mtx.Modulo = 'CXP' AND mtX.Clave = 'CXP.P'
JOIN CxpAplica h ON b.Aplica = h.Mov AND b.AplicaID = h.MovID AND h.Empresa = @Empresa
JOIN Dinero e ON e.CtaDinero = a.DineroCtaDinero AND a.Dinero = e.Mov AND a.DineroID = e.MovID
JOIN MovTipo mt2 ON mt2.Mov = e.Mov AND mt2.Modulo = 'DIN' AND mt2.Clave IN ('DIN.CH', 'DIN.CHE', 'DIN.E')
JOIN Prov p ON a.Proveedor = p.Proveedor
JOIN Cxp x ON b.Aplica = x.Mov AND b.AplicaID = x.MovID
JOIN CxpD w ON x.ID = w.ID
JOIN Cxp v ON v.Mov = w.Aplica AND v.MovID = w.AplicaID
JOIN Gasto y ON v.Origen = y.Mov AND v.OrigenID = y.MovID
JOIN GastoD z ON y.ID = z.ID
LEFT OUTER JOIN Concepto g ON z.Concepto = g.Concepto AND g.Modulo = 'GAS'
JOIN MovTipo mt3 ON mt3.Mov = y.Mov AND mt3.Modulo = 'GAS' AND mt3.Clave = 'GAS.G'
JOIN MovTipo mt4 ON mt4.Mov = b.Aplica AND mt4.Modulo = 'CXP' AND mt4.Clave IN ('CXP.AA','CXP.AF','CXP.D','CXP.DA','CXP.F')
WHERE
e.FechaConciliacion BETWEEN @FechaD AND @FechaA
AND a.Estatus = 'CONCLUIDO'
AND e.Estatus IN ('CONCILIADO', 'CONCLUIDO') 
AND x.Estatus IN ('PENDIENTE', 'CONCLUIDO')
AND y.Estatus = 'CONCLUIDO'
AND a.Empresa = @Empresa
AND e.Empresa = @Empresa
AND x.Empresa = @Empresa
AND v.Empresa = @Empresa
AND y.Empresa = @Empresa
INSERT IVADeclaradoInicial (
Estacion,  Empresa,   Proveedor,   RFC,   Nombre,   OrigenMov, OrigenMovID, TipoOperacion,   ModuloMov, ModuloMovID, Mov,   MovID,   Descripcion, DestinoMov, DestinoMovID, FechaConciliacion,
Importe, Impuesto, Impuesto15, Impuesto10, ImpuestoValidar, IvaOExento, RetencionIVA, RetencionISR, PorcentajeDeducible)
SELECT @Estacion, a.Empresa, a.Proveedor, p.RFC, p.Nombre, y.Mov,     y.MovID,     g.TipoOperacion, x.Mov,      x.MovID,     a.Mov, a.MovID, z.Concepto,  e.Mov,      e.MovID,      e.FechaConciliacion,
Importe = CASE WHEN b.importe - (b.Importe * h.Ivafiscal) <>
((((CONVERT(float, z.Importe)/CONVERT(float, y.Importe)) * b.Importe) - (((CONVERT(float, z.Importe)/CONVERT(float, y.Importe)) * b.Importe) * ISNULL(h.IvaFiscal, 0))) ) THEN
((((CONVERT(float, z.Importe)/CONVERT(float, y.Importe)) * b.Importe) - (((CONVERT(float, z.Importe)/CONVERT(float, y.Importe)) * b.Importe) * ISNULL(h.IvaFiscal, 0))) ) +
ISNULL((z.Importe - ((((CONVERT(float, z.Importe)/CONVERT(float, y.Importe)) * b.Importe) - (((CONVERT(float, z.Importe)/CONVERT(float, y.Importe)) * b.Importe) * ISNULL(h.IvaFiscal, 0))))), 0) * e.TipoCambio ELSE
((((CONVERT(float, z.Importe)/CONVERT(float, y.Importe)) * b.Importe) - (((CONVERT(float, z.Importe)/CONVERT(float, y.Importe)) * b.Importe) * ISNULL(h.IvaFiscal, 0))) ) +
ISNULL((((((CONVERT(float, z.Importe)/CONVERT(float, y.Importe)) * b.Importe) - (((CONVERT(float, z.Importe)/CONVERT(float, y.Importe)) * b.Importe) * ISNULL(h.IvaFiscal, 0))) ) / (y.importe - (y.importe * (dbo.fnConceptoImpuestoTasa(@Empresa, 'GAS', z.Concepto,'Retencion2')/100))) * z.Retencion2), 0) +
ISNULL((((((CONVERT(float, z.Importe)/CONVERT(float, y.Importe)) * b.Importe) - (((CONVERT(float, z.Importe)/CONVERT(float, y.Importe)) * b.Importe) * ISNULL(h.IvaFiscal, 0))) ) / (y.importe - (y.importe * (dbo.fnConceptoImpuestoTasa(@Empresa, 'GAS', z.Concepto,'Retencion1')/100))) * z.Retencion), 0) * e.TipoCambio END,
Impuestos = (CASE WHEN ISNULL(y.Impuestos, 0) <> 0 THEN (((CONVERT(float, z.Impuestos)/CONVERT(float, y.Impuestos))) * ISNULL(h.IvaFiscal, 0)) * b.Importe ELSE 0 END) * e.TipoCambio,
Impuesto15 = CASE WHEN ROUND(z.Impuestos/z.Importe, 2) = 0.16 THEN (CASE WHEN ISNULL(y.Impuestos, 0) <> 0 THEN (((CONVERT(float, z.Impuestos)/CONVERT(float, y.Impuestos))) * ISNULL(h.IvaFiscal, 0)) * b.Importe ELSE 0 END) * e.TipoCambio END,
Impuesto10 = CASE WHEN ROUND(z.Impuestos/z.Importe, 2) = 0.11 THEN (CASE WHEN ISNULL(y.Impuestos, 0) <> 0 THEN (((CONVERT(float, z.Impuestos)/CONVERT(float, y.Impuestos))) * ISNULL(h.IvaFiscal, 0)) * b.Importe ELSE 0 END) * e.TipoCambio END,
ImpuestoValidar = CASE WHEN (ROUND(z.Impuestos/z.Importe, 2) <> 0.11) AND (ROUND(z.Impuestos/z.Importe, 2) <> 0.16) THEN (CASE WHEN ISNULL(y.Impuestos, 0) <> 0 THEN (((CONVERT(float, z.Impuestos)/CONVERT(float, y.Impuestos))) * ISNULL(h.IvaFiscal, 0)) * b.Importe ELSE 0 END) * e.TipoCambio END,
IvaOExento = CASE WHEN (g.Impuesto1Excento = 0) AND (((CASE WHEN ROUND(z.Impuestos/z.Importe, 2) = 0.16 THEN z.Impuestos * e.TipoCambio END) IS NULL) AND ((CASE WHEN ROUND(z.Impuestos/z.Importe, 2) = 0.11 THEN z.Impuestos * e.TipoCambio END) IS NULL)) THEN 'IVA 0%'
WHEN (g.Impuesto1Excento = 0) AND ((CASE WHEN ROUND(z.Impuestos/z.Importe, 2) = 0.16 THEN z.Impuestos * e.TipoCambio END) IS NOT NULL) THEN 'IVA 16%'
WHEN (g.Impuesto1Excento = 0) AND ((CASE WHEN ROUND(z.Impuestos/z.Importe, 2) = 0.11 THEN z.Impuestos * e.TipoCambio END) IS NOT NULL) THEN 'IVA 11%'
WHEN (g.Impuesto1Excento = 1) THEN 'Exento' ELSE 'No Aplica' END,
RetencionIVA = CASE WHEN b.importe - (b.Importe * h.Ivafiscal) <> ((((CONVERT(float, z.Importe)/CONVERT(float, y.Importe)) * b.Importe) - (((CONVERT(float, z.Importe)/CONVERT(float, y.Importe)) * b.Importe) * ISNULL(h.IvaFiscal, 0))) ) THEN
ISNULL(((((((CONVERT(float, z.Importe)/CONVERT(float, y.Importe)) * b.Importe) - (((CONVERT(float, z.Importe)/CONVERT(float, y.Importe)) * b.Importe) * ISNULL(h.IvaFiscal, 0))) ) +
ISNULL((z.Importe - ((((CONVERT(float, z.Importe)/CONVERT(float, y.Importe)) * b.Importe) - (((CONVERT(float, z.Importe)/CONVERT(float, y.Importe)) * b.Importe) * ISNULL(h.IvaFiscal, 0))))), 0)) * (dbo.fnConceptoImpuestoTasa(@Empresa, 'GAS', z.Concepto,'Retencion2')/100)),0) * e.TipoCambio ELSE
ISNULL(((((((CONVERT(float, z.Importe)/CONVERT(float, y.Importe)) * b.Importe) - (((CONVERT(float, z.Importe)/CONVERT(float, y.Importe)) * b.Importe) * ISNULL(h.IvaFiscal, 0))) ) +
ISNULL((((((CONVERT(float, z.Importe)/CONVERT(float, y.Importe)) * b.Importe) - (((CONVERT(float, z.Importe)/CONVERT(float, y.Importe)) * b.Importe) * ISNULL(h.IvaFiscal, 0))) ) / (y.importe - (y.importe * (dbo.fnConceptoImpuestoTasa(@Empresa, 'GAS', z.Concepto,'Retencion2')/100))) * z.Retencion2), 0) +
ISNULL((((((CONVERT(float, z.Importe)/CONVERT(float, y.Importe)) * b.Importe) - (((CONVERT(float, z.Importe)/CONVERT(float, y.Importe)) * b.Importe) * ISNULL(h.IvaFiscal, 0))) ) / (y.importe - (y.importe * (dbo.fnConceptoImpuestoTasa(@Empresa, 'GAS', z.Concepto,'Retencion1')/100))) * z.Retencion), 0)) * (dbo.fnConceptoImpuestoTasa(@Empresa, 'GAS', z.Concepto,'Retencion2')/100)),0) * e.TipoCambio END,
RetencionISR = CASE WHEN b.importe - (b.Importe * h.Ivafiscal) <> ((((CONVERT(float, z.Importe)/CONVERT(float, y.Importe)) * b.Importe) - (((CONVERT(float, z.Importe)/CONVERT(float, y.Importe)) * b.Importe) * ISNULL(h.IvaFiscal, 0))) ) THEN
ISNULL(((((((CONVERT(float, z.Importe)/CONVERT(float, y.Importe)) * b.Importe) - (((CONVERT(float, z.Importe)/CONVERT(float, y.Importe)) * b.Importe) * ISNULL(h.IvaFiscal, 0))) ) +
ISNULL((z.Importe - ((((CONVERT(float, z.Importe)/CONVERT(float, y.Importe)) * b.Importe) - (((CONVERT(float, z.Importe)/CONVERT(float, y.Importe)) * b.Importe) * ISNULL(h.IvaFiscal, 0))))), 0)) * (dbo.fnConceptoImpuestoTasa(@Empresa, 'GAS', z.Concepto,'Retencion1')/100)),0) * e.TipoCambio ELSE
ISNULL(((((((CONVERT(float, z.Importe)/CONVERT(float, y.Importe)) * b.Importe) - (((CONVERT(float, z.Importe)/CONVERT(float, y.Importe)) * b.Importe) * ISNULL(h.IvaFiscal, 0))) ) +
ISNULL((((((CONVERT(float, z.Importe)/CONVERT(float, y.Importe)) * b.Importe) - (((CONVERT(float, z.Importe)/CONVERT(float, y.Importe)) * b.Importe) * ISNULL(h.IvaFiscal, 0))) ) / (y.importe - (y.importe * (dbo.fnConceptoImpuestoTasa(@Empresa, 'GAS', z.Concepto,'Retencion2')/100))) * z.Retencion2), 0) +
ISNULL((((((CONVERT(float, z.Importe)/CONVERT(float, y.Importe)) * b.Importe) - (((CONVERT(float, z.Importe)/CONVERT(float, y.Importe)) * b.Importe) * ISNULL(h.IvaFiscal, 0))) ) / (y.importe - (y.importe * (dbo.fnConceptoImpuestoTasa(@Empresa, 'GAS', z.Concepto,'Retencion1')/100))) * z.Retencion), 0)) * (dbo.fnConceptoImpuestoTasa(@Empresa, 'GAS', z.Concepto,'Retencion1')/100)),0) * e.TipoCambio END,
z.PorcentajeDeducible
FROM Cxp c
JOIN CxpD b ON c.ID = b.ID
JOIN MovTipo mty ON mty.Mov = c.Mov AND mty.Modulo = 'CXP' AND mty.Clave = 'CXP.ANC'
JOIN MovFlujo w ON w.DMov = c.Mov AND w.DMovID = c.MovID AND w.OModulo = 'CXP'
JOIN Cxp a ON w.OMov = a.Mov AND w.OMovID = a.MovID AND w.DModulo = 'CXP'
JOIN MovTipo mtx ON mtx.Mov = a.Mov AND mtx.Modulo = 'CXP' AND mtX.Clave = 'CXP.A'
JOIN CxpAplica h ON c.Mov = h.Mov AND c.MovID = h.MovID AND h.Empresa = @Empresa
JOIN Cxp x ON b.Aplica = x.Mov AND b.AplicaID = x.MovID
JOIN CxpD j ON x.ID = j.ID
JOIN Cxp k ON k.Mov = j.Aplica AND k.MovID = j.AplicaID
JOIN Gasto y ON x.Origen = y.Mov AND x.OrigenID = y.MovID
JOIN GastoD z ON y.ID = z.ID
LEFT OUTER JOIN Concepto g ON z.Concepto = g.Concepto AND g.Modulo = 'GAS'
JOIN MovTipo mt3 ON mt3.Mov = y.Mov AND mt3.Modulo = 'GAS' AND mt3.Clave = 'GAS.G'
JOIN Dinero e ON e.CtaDinero = a.DineroCtaDinero AND a.Dinero = e.Mov AND a.DineroID = e.MovID
JOIN MovTipo mt2 ON mt2.Mov = e.Mov AND mt2.Modulo = 'DIN' AND mt2.Clave IN ('DIN.CH', 'DIN.CHE', 'DIN.E')
JOIN Prov p ON a.Proveedor = p.Proveedor
JOIN MovTipo mt4 ON mt4.Mov = b.Aplica AND mt4.Modulo = 'CXP' AND mt4.Clave IN ('CXP.AA','CXP.AF','CXP.D','CXP.DA','CXP.F')
WHERE
e.FechaConciliacion BETWEEN @FechaD AND @FechaA
AND a.Estatus = 'CONCLUIDO'
AND e.Estatus IN ('CONCILIADO', 'CONCLUIDO') 
AND x.Estatus IN ('PENDIENTE', 'CONCLUIDO')
AND y.Estatus = 'CONCLUIDO'
AND a.Empresa = @Empresa
AND c.Empresa = @Empresa
AND x.Empresa = @Empresa
AND k.Empresa = @Empresa
AND y.Empresa = @Empresa
INSERT IVADeclaradoInicial (
Estacion,  Empresa,   Proveedor,   RFC,   Nombre,   OrigenMov, OrigenMovID, TipoOperacion, ModuloMov, ModuloMovID, Mov,   MovID,   Descripcion,                       DestinoMov, DestinoMovID, FechaConciliacion,
Importe, Impuesto, Impuesto15, Impuesto10, ImpuestoValidar, IEPS20, IEPS25, IEPS30, IEPS50, IEPSCigarros, IEPSTabacos, IvaOExento, PorcentajeDeducible)
SELECT @Estacion, a.Empresa, a.Proveedor, p.RFC, p.Nombre, y.Mov,     y.MovID,     'Otros',       x.Mov,     x.MovID,     a.Mov, a.MovID, RTRIM(z.Articulo)+' '+z.SubCuenta, e.Mov,      e.MovID,      e.FechaConciliacion,
Importe = ((((b.Importe * ((z.Cantidad * z.Costo) - ISNULL(z.DescuentoImporte, 0)) / (y.Importe)) -
ISNULL(h.IVAFiscal * (b.Importe * ((z.Cantidad * z.Costo) - ISNULL(z.DescuentoImporte, 0)) / (y.Importe)), 0) -
ISNULL(h.IEPSFiscal * (b.Importe * ((z.Cantidad * z.Costo) - ISNULL(z.DescuentoImporte, 0)) / (y.Importe)), 0))) * e.TipoCambio),
Impuesto = ISNULL((h.IVAFiscal * (b.Importe * ((z.Cantidad * z.Costo) - ISNULL(z.DescuentoImporte, 0)) / y.Importe)), 0) * e.TipoCambio,
Impuesto15 = ((((z.Cantidad * z.Costo) - ISNULL(z.DescuentoImporte, 0)) / (y.Importe)) * (CASE WHEN m.Impuesto1 = 15.0 THEN ISNULL(m.Importe1, 0) END)) * e.TipoCambio,
Impuesto10 = ((((z.Cantidad * z.Costo) - ISNULL(z.DescuentoImporte, 0)) / (y.Importe)) * (CASE WHEN m.Impuesto1 = 10.0 THEN ISNULL(m.Importe1, 0) END)) * e.TipoCambio,
ImpuestoValidar = CASE WHEN (m.Impuesto1 <> 16.0) AND (m.Impuesto1 <> 11.0) THEN (((z.Cantidad * z.Costo) - ISNULL(z.DescuentoImporte, 0)) / (y.Importe)) * ISNULL(m.Importe1, 0) * e.TipoCambio END,
IEPS20 = ((((z.Cantidad * z.Costo) - ISNULL(z.DescuentoImporte, 0)) / (y.Importe)) * (CASE WHEN m.Impuesto2 = 20.0 THEN ISNULL(m.Importe2, 0) END)) * e.TipoCambio,
IEPS25 = ((((z.Cantidad * z.Costo) - ISNULL(z.DescuentoImporte, 0)) / (y.Importe)) * (CASE WHEN m.Impuesto2 = 25.0 THEN ISNULL(m.Importe2, 0) END)) * e.TipoCambio,
IEPS30 = ((((z.Cantidad * z.Costo) - ISNULL(z.DescuentoImporte, 0)) / (y.Importe)) * (CASE WHEN m.Impuesto2 = 30.0 THEN ISNULL(m.Importe2, 0) END)) * e.TipoCambio,
IEPS50 = ((((z.Cantidad * z.Costo) - ISNULL(z.DescuentoImporte, 0)) / (y.Importe)) * (CASE WHEN m.Impuesto2 = 50.0 THEN ISNULL(m.Importe2, 0) END)) * e.TipoCambio,
IEPSCigarros = ((((z.Cantidad * z.Costo) - ISNULL(z.DescuentoImporte, 0)) / (y.Importe)) * (CASE WHEN m.Impuesto2 = 100.0 THEN ISNULL(m.Importe2, 0) END)) * e.TipoCambio,
IEPSTabacos  = ((((z.Cantidad * z.Costo) - ISNULL(z.DescuentoImporte, 0)) / (y.Importe)) * (CASE WHEN m.Impuesto2 = 20.9 THEN ISNULL(m.Importe2, 0) END)) * e.TipoCambio,
IvaOExento = CASE WHEN (g.Impuesto1Excento = 0) AND (m.Impuesto1 =  0.0) THEN 'IVA 0%'
WHEN (g.Impuesto1Excento = 0) AND (m.Impuesto1 = 16.0) THEN 'IVA 16%'
WHEN (g.Impuesto1Excento = 0) AND (m.Impuesto1 = 11.0) THEN 'IVA 11%'
WHEN (g.Impuesto1Excento = 1) THEN 'Exento' ELSE 'No Aplica' END, 100
FROM Cxp a
JOIN CxpD b ON a.ID = b.ID
JOIN MovTipo mtx ON mtx.Mov = a.Mov AND mtx.Modulo = 'CXP' AND mtX.Clave = 'CXP.P'
JOIN CxpAplica h ON b.Aplica = h.Mov AND b.AplicaID = h.MovID AND h.Empresa = @Empresa
JOIN Dinero e ON e.CtaDinero = a.DineroCtaDinero AND a.Dinero = e.Mov AND a.DineroID = e.MovID
JOIN MovTipo mt2 ON mt2.Mov = e.Mov AND mt2.Modulo = 'DIN' AND mt2.Clave IN ('DIN.CH', 'DIN.CHE', 'DIN.E')
JOIN Prov p ON a.Proveedor = p.Proveedor
JOIN Cxp x ON b.Aplica = x.Mov AND b.AplicaID = x.MovID
JOIN Compra y ON x.Origen = y.Mov AND x.OrigenID = y.MovID
JOIN CompraD z ON y.ID = z.ID
JOIN Art g ON z.Articulo = g.Articulo
JOIN MovTipo mt3 ON mt3.Mov = y.Mov AND mt3.Modulo = 'COMS' AND mt3.Clave IN ('COMS.F', 'COMS.FL', 'COMS.EG')
JOIN MovImpuesto m ON y.ID = m.ModuloID AND m.Modulo = 'COMS' AND ((ROUND(m.SubTotal, 2) = ROUND(y.Importe, 2)) OR (ROUND(m.SubTotal+m.Importe1+m.Importe2, 2) = ROUND(y.Importe, 2)))
JOIN MovTipo mt4 ON mt4.Mov = b.Aplica AND mt4.Modulo = 'CXP' AND mt4.Clave IN ('CXP.AA','CXP.AF','CXP.D','CXP.DA','CXP.F')
WHERE
e.FechaConciliacion BETWEEN @FechaD AND @FechaA
AND a.Estatus = 'CONCLUIDO'
AND e.Estatus IN ('CONCILIADO', 'CONCLUIDO') 
AND x.Estatus IN ('PENDIENTE', 'CONCLUIDO')
AND y.Estatus = 'CONCLUIDO'
AND a.Empresa = @Empresa
AND e.Empresa = @Empresa
AND x.Empresa = @Empresa
AND y.Empresa = @Empresa
INSERT IVADeclaradoInicial (
Estacion,  Empresa,   Proveedor,   RFC,   Nombre,   OrigenMov, OrigenMovID, TipoOperacion, ModuloMov, ModuloMovID, Mov,   MovID,   Descripcion,                       DestinoMov, DestinoMovID, FechaConciliacion,
Importe, Impuesto, Impuesto15, Impuesto10, ImpuestoValidar, IEPS20, IEPS25, IEPS30, IEPS50, IEPSCigarros, IEPSTabacos, IvaOExento, PorcentajeDeducible)
SELECT @Estacion, a.Empresa, a.Proveedor, p.RFC, p.Nombre, y.Mov,     y.MovID,     'Otros',       x.Mov,     x.MovID,     a.Mov, a.MovID, RTRIM(z.Articulo)+' '+z.SubCuenta, e.Mov,      e.MovID,      e.FechaConciliacion,
Importe = ((((b.Importe * ((z.Cantidad * z.Costo) - ISNULL(z.DescuentoImporte, 0)) / (y.Importe)) -
ISNULL(h.IVAFiscal * (b.Importe * ((z.Cantidad * z.Costo) - ISNULL(z.DescuentoImporte, 0)) / (y.Importe)), 0) -
ISNULL(h.IEPSFiscal * (b.Importe * ((z.Cantidad * z.Costo) - ISNULL(z.DescuentoImporte, 0)) / (y.Importe)), 0))) * e.TipoCambio),
Impuestos = ISNULL((h.IVAFiscal * (b.Importe * ((z.Cantidad * z.Costo) - ISNULL(z.DescuentoImporte, 0)) / y.Importe)), 0) * e.TipoCambio,
Impuesto15 = ((((z.Cantidad * z.Costo) - ISNULL(z.DescuentoImporte, 0)) / (y.Importe)) * (CASE WHEN m.Impuesto1 = 16.0 THEN ISNULL(m.Importe1, 0) END)) * e.TipoCambio,
Impuesto10 = ((((z.Cantidad * z.Costo) - ISNULL(z.DescuentoImporte, 0)) / (y.Importe)) * (CASE WHEN m.Impuesto1 = 11.0 THEN ISNULL(m.Importe1, 0) END)) * e.TipoCambio,
ImpuestoValidar = CASE WHEN (m.Impuesto1 <> 11.0) AND (m.Impuesto1 <> 16.0) THEN (((z.Cantidad * z.Costo) - ISNULL(z.DescuentoImporte, 0)) / (y.Importe)) * ISNULL(m.Importe1, 0) * e.TipoCambio END,
IEPS20 = ((((z.Cantidad * z.Costo) - ISNULL(z.DescuentoImporte, 0)) / (y.Importe)) * (CASE WHEN m.Impuesto2 = 20.0 THEN ISNULL(m.Importe2, 0) END)) * e.TipoCambio,
IEPS25 = ((((z.Cantidad * z.Costo) - ISNULL(z.DescuentoImporte, 0)) / (y.Importe)) * (CASE WHEN m.Impuesto2 = 25.0 THEN ISNULL(m.Importe2, 0) END)) * e.TipoCambio,
IEPS30 = ((((z.Cantidad * z.Costo) - ISNULL(z.DescuentoImporte, 0)) / (y.Importe)) * (CASE WHEN m.Impuesto2 = 30.0 THEN ISNULL(m.Importe2, 0) END)) * e.TipoCambio,
IEPS50 = ((((z.Cantidad * z.Costo) - ISNULL(z.DescuentoImporte, 0)) / (y.Importe)) * (CASE WHEN m.Impuesto2 = 50.0 THEN ISNULL(m.Importe2, 0) END)) * e.TipoCambio,
IEPSCigarros = ((((z.Cantidad * z.Costo) - ISNULL(z.DescuentoImporte, 0)) / (y.Importe)) * (CASE WHEN m.Impuesto2 = 100.0 THEN ISNULL(m.Importe2, 0) END)) * e.TipoCambio,
IEPSTabacos  = ((((z.Cantidad * z.Costo) - ISNULL(z.DescuentoImporte, 0)) / (y.Importe)) * (CASE WHEN m.Impuesto2 = 20.9 THEN ISNULL(m.Importe2, 0) END)) * e.TipoCambio,
IvaOExento = CASE WHEN (g.Impuesto1Excento = 0) AND (m.Impuesto1 =  0.0) THEN 'IVA 0%'
WHEN (g.Impuesto1Excento = 0) AND (m.Impuesto1 = 16.0) THEN 'IVA 16%'
WHEN (g.Impuesto1Excento = 0) AND (m.Impuesto1 = 11.0) THEN 'IVA 11%'
WHEN (g.Impuesto1Excento = 1) THEN 'Exento' ELSE 'No Aplica' END, 100
FROM Cxp c
JOIN CxpD b ON c.ID = b.ID
JOIN MovTipo mty ON mty.Mov = c.Mov AND mty.Modulo = 'CXP' AND mty.Clave = 'CXP.ANC'
JOIN MovFlujo w ON w.DMov = c.Mov AND w.DMovID = c.MovID AND w.OModulo = 'CXP'
JOIN Cxp a ON w.OMov = a.Mov AND w.OMovID = a.MovID AND w.DModulo = 'CXP'
JOIN MovTipo mtx ON mtx.Mov = a.Mov AND mtx.Modulo = 'CXP' AND mtX.Clave = 'CXP.A'
JOIN CxpAplica h ON c.Mov = h.Mov AND c.MovID = h.MovID AND h.Empresa = @Empresa
JOIN Cxp x ON b.Aplica = x.Mov AND b.AplicaID = x.MovID
JOIN Compra y ON x.Origen = y.Mov AND x.OrigenID = y.MovID
JOIN CompraD z ON y.ID = z.ID
JOIN Art g ON z.Articulo = g.Articulo
JOIN MovTipo mt3 ON mt3.Mov = y.Mov AND mt3.Modulo = 'COMS' AND mt3.Clave IN ('COMS.F', 'COMS.FL', 'COMS.EG')
JOIN Dinero e ON e.CtaDinero = a.DineroCtaDinero AND a.Dinero = e.Mov AND a.DineroID = e.MovID
JOIN MovTipo mt2 ON mt2.Mov = e.Mov AND mt2.Modulo = 'DIN' AND mt2.Clave IN ('DIN.CH', 'DIN.CHE')
JOIN Prov p ON a.Proveedor = p.Proveedor
JOIN MovImpuesto m ON y.ID = m.ModuloID AND m.Modulo = 'COMS' AND ((ROUND(m.SubTotal, 2) = ROUND(y.Importe, 2)) OR (ROUND(m.SubTotal+m.Importe1+m.Importe2, 2) = ROUND(y.Importe, 2)))
JOIN MovTipo mt4 ON mt4.Mov = b.Aplica AND mt4.Modulo = 'CXP' AND mt4.Clave IN ('CXP.AA','CXP.AF','CXP.D','CXP.DA','CXP.F')
WHERE
e.FechaConciliacion BETWEEN @FechaD AND @FechaA
AND a.Estatus = 'CONCLUIDO'
AND e.Estatus IN ('CONCILIADO', 'CONCLUIDO') 
AND x.Estatus IN ('PENDIENTE', 'CONCLUIDO')
AND y.Estatus = 'CONCLUIDO'
AND a.Empresa = @Empresa
AND c.Empresa = @Empresa
AND x.Empresa = @Empresa
AND y.Empresa = @Empresa
AND e.Empresa = @Empresa
INSERT IVADeclaradoInicial (
Estacion,  Empresa,   Proveedor,   RFC,   Nombre,   OrigenMov, OrigenMovID, TipoOperacion,   ModuloMov, ModuloMovID, Mov,   MovID,   Descripcion,
Importe, Impuesto, Impuesto15, Impuesto10, ImpuestoValidar, IvaOExento, PorcentajeDeducible)
SELECT @Estacion, a.Empresa, y.Acreedor, p.RFC, p.Nombre, y.Mov,     y.MovID,      g.TipoOperacion, x.Mov,     x.MovID,     a.Mov, a.MovID, z.Concepto,
Importe = (((CONVERT(float, z.Importe)/CONVERT(float, y.Importe)) * b.Importe) - (((CONVERT(float, z.Importe)/CONVERT(float, y.Importe)) * b.Importe) * ISNULL(h.IvaFiscal, 0))) * a.TipoCambio,
Impuestos = (CASE WHEN ISNULL(y.Impuestos, 0) <> 0 THEN (((CONVERT(float, z.Impuestos)/CONVERT(float, y.Impuestos))) * ISNULL(h.IvaFiscal, 0)) * b.Importe ELSE 0 END) * a.TipoCambio,
Impuesto15 = CASE WHEN ROUND(z.Impuestos/z.Importe, 2) = 0.16 THEN (CASE WHEN ISNULL(y.Impuestos, 0) <> 0 THEN (((CONVERT(float, z.Impuestos)/CONVERT(float, y.Impuestos))) * ISNULL(h.IvaFiscal, 0)) * b.Importe ELSE 0 END) * a.TipoCambio END,
Impuesto10 = CASE WHEN ROUND(z.Impuestos/z.Importe, 2) = 0.11 THEN (CASE WHEN ISNULL(y.Impuestos, 0) <> 0 THEN (((CONVERT(float, z.Impuestos)/CONVERT(float, y.Impuestos))) * ISNULL(h.IvaFiscal, 0)) * b.Importe ELSE 0 END) * a.TipoCambio END,
ImpuestoValidar = CASE WHEN (ROUND(z.Impuestos/z.Importe, 2) <> 0.11) AND (ROUND(z.Impuestos/z.Importe, 2) <> 0.16) THEN (CASE WHEN ISNULL(y.Impuestos, 0) <> 0 THEN (((CONVERT(float, z.Impuestos)/CONVERT(float, y.Impuestos))) * ISNULL(h.IvaFiscal, 0)) * b.Importe ELSE 0 END) * a.TipoCambio END,
IvaOExento = CASE WHEN (g.Impuesto1Excento = 0) AND (((CASE WHEN ROUND(z.Impuestos/z.Importe, 2) = 0.16 THEN z.Impuestos * a.TipoCambio END) IS NULL) AND ((CASE WHEN ROUND(z.Impuestos/z.Importe, 2) = 0.11 THEN z.Impuestos * a.TipoCambio END) IS NULL)) THEN 'IVA 0%'
WHEN (g.Impuesto1Excento = 0) AND ((CASE WHEN ROUND(z.Impuestos/z.Importe, 2) = 0.16 THEN z.Impuestos * a.TipoCambio END) IS NOT NULL) THEN 'IVA 16%'
WHEN (g.Impuesto1Excento = 0) AND ((CASE WHEN ROUND(z.Impuestos/z.Importe, 2) = 0.11 THEN z.Impuestos * a.TipoCambio END) IS NOT NULL) THEN 'IVA 11%'
WHEN (g.Impuesto1Excento = 1) THEN 'Exento' ELSE 'No Aplica' END,
z.PorcentajeDeducible
FROM Cxp a
JOIN CxpD b ON a.ID = b.ID
JOIN MovTipo mt ON a.Mov = mt.Mov AND mt.Modulo = 'CXP' AND mt.Clave IN ('CXP.FAC', 'CXP.DAC')
JOIN CxpAplica h ON b.Aplica = h.Mov AND b.AplicaID = h.MovID AND h.Empresa = @Empresa
JOIN Cxp x ON b.Aplica = x.Mov AND b.AplicaID = x.MovID
JOIN Gasto y ON x.Origen = y.Mov AND x.OrigenID = y.MovID
JOIN GastoD z ON y.ID = z.ID
JOIN Prov p ON y.Acreedor = p.Proveedor
LEFT OUTER JOIN Concepto g ON z.Concepto = g.Concepto AND g.Modulo = 'GAS'
JOIN MovTipo mt3 ON mt3.Mov = y.Mov AND mt3.Modulo = 'GAS' AND mt3.Clave = 'GAS.G'
WHERE a.Estatus = 'CONCLUIDO'
AND a.FechaEmision BETWEEN @FechaD AND @FechaA
AND x.Estatus IN ('PENDIENTE', 'CONCLUIDO')
AND y.Estatus = 'CONCLUIDO'
AND a.Empresa = @Empresa
AND x.Empresa = @Empresa
AND y.Empresa = @Empresa
INSERT IVADeclaradoInicial (
Estacion,  Empresa,   Proveedor,   RFC,   Nombre,   OrigenMov, OrigenMovID, TipoOperacion,   ModuloMov, ModuloMovID, Mov,   MovID,   Descripcion,
Importe, Impuesto, Impuesto15, Impuesto10, ImpuestoValidar, IEPS20, IEPS25, IEPS30, IEPS50, IEPSCigarros, IEPSTabacos, IvaOExento, PorcentajeDeducible)
SELECT @Estacion, a.Empresa, a.Proveedor, p.RFC, p.Nombre, y.Mov,     y.MovID,     'Otros',         x.Mov,     x.MovID,     a.Mov, a.MovID, RTRIM(z.Articulo)+' '+z.SubCuenta,
Importe = ((((b.Importe * ((z.Cantidad * z.Costo) - ISNULL(z.DescuentoImporte, 0)) / (y.Importe)) -
ISNULL(h.IVAFiscal * (b.Importe * ((z.Cantidad * z.Costo) - ISNULL(z.DescuentoImporte, 0)) / (y.Importe)), 0) -
ISNULL(h.IEPSFiscal * (b.Importe * ((z.Cantidad * z.Costo) - ISNULL(z.DescuentoImporte, 0)) / (y.Importe)), 0))) * a.TipoCambio),
Impuestos = ISNULL((h.IVAFiscal * (b.Importe * ((z.Cantidad * z.Costo) - ISNULL(z.DescuentoImporte, 0)) / y.Importe)), 0) * a.TipoCambio,
Impuesto15 = ((((z.Cantidad * z.Costo) - ISNULL(z.DescuentoImporte, 0)) / (y.Importe)) * (CASE WHEN m.Impuesto1 = 16.0 THEN ISNULL(m.Importe1, 0) END)) * a.TipoCambio,
Impuesto10 = ((((z.Cantidad * z.Costo) - ISNULL(z.DescuentoImporte, 0)) / (y.Importe)) * (CASE WHEN m.Impuesto1 = 11.0 THEN ISNULL(m.Importe1, 0) END)) * a.TipoCambio,
ImpuestoValidar = CASE WHEN (m.Impuesto1 <> 16.0) AND (m.Impuesto1 <> 11.0) THEN (((z.Cantidad * z.Costo) - ISNULL(z.DescuentoImporte, 0)) / (y.Importe)) * ISNULL(m.Importe1, 0) * a.TipoCambio END,
IEPS20 = ((((z.Cantidad * z.Costo) - ISNULL(z.DescuentoImporte, 0)) / (y.Importe)) * (CASE WHEN m.Impuesto2 = 20.0 THEN ISNULL(m.Importe2, 0) END)) * a.TipoCambio,
IEPS25 = ((((z.Cantidad * z.Costo) - ISNULL(z.DescuentoImporte, 0)) / (y.Importe)) * (CASE WHEN m.Impuesto2 = 25.0 THEN ISNULL(m.Importe2, 0) END)) * a.TipoCambio,
IEPS30 = ((((z.Cantidad * z.Costo) - ISNULL(z.DescuentoImporte, 0)) / (y.Importe)) * (CASE WHEN m.Impuesto2 = 30.0 THEN ISNULL(m.Importe2, 0) END)) * a.TipoCambio,
IEPS50 = ((((z.Cantidad * z.Costo) - ISNULL(z.DescuentoImporte, 0)) / (y.Importe)) * (CASE WHEN m.Impuesto2 = 50.0 THEN ISNULL(m.Importe2, 0) END)) * a.TipoCambio,
IEPSCigarros = ((((z.Cantidad * z.Costo) - ISNULL(z.DescuentoImporte, 0)) / (y.Importe)) * (CASE WHEN m.Impuesto2 = 100.0 THEN ISNULL(m.Importe2, 0) END)) * a.TipoCambio,
IEPSTabacos  = ((((z.Cantidad * z.Costo) - ISNULL(z.DescuentoImporte, 0)) / (y.Importe)) * (CASE WHEN m.Impuesto2 = 20.9 THEN ISNULL(m.Importe2, 0) END)) * a.TipoCambio,
IvaOExento = CASE WHEN (g.Impuesto1Excento = 0) AND (m.Impuesto1 =  0.0) THEN 'IVA 0%'
WHEN (g.Impuesto1Excento = 0) AND (m.Impuesto1 = 16.0) THEN 'IVA 16%'
WHEN (g.Impuesto1Excento = 0) AND (m.Impuesto1 = 11.0) THEN 'IVA 11%'
WHEN (g.Impuesto1Excento = 1) THEN 'Exento' ELSE 'No Aplica' END, 100
FROM Cxp a
JOIN CxpD b ON a.ID = b.ID
JOIN MovTipo mt ON a.Mov = mt.Mov AND mt.Modulo = 'CXP' AND mt.Clave IN ('CXP.NET')
JOIN CxpAplica h ON b.Aplica = h.Mov AND b.AplicaID = h.MovID AND h.Empresa = @Empresa
JOIN Prov p ON a.Proveedor = p.Proveedor
JOIN Cxp x ON b.Aplica = x.Mov AND b.AplicaID = x.MovID
JOIN Compra y ON x.Origen = y.Mov AND x.OrigenID = y.MovID
JOIN CompraD z ON y.ID = z.ID
JOIN Art g ON z.Articulo = g.Articulo
JOIN MovTipo mt3 ON mt3.Mov = y.Mov AND mt3.Modulo = 'COMS' AND mt3.Clave = 'COMS.F'
JOIN MovImpuesto m ON y.ID = m.ModuloID AND m.Modulo = 'COMS' AND ((ROUND(m.SubTotal, 2) = ROUND(y.Importe, 2)) OR (ROUND(m.SubTotal+m.Importe1+m.Importe2, 2) = ROUND(y.Importe, 2)))
WHERE a.Estatus = 'CONCLUIDO'
AND a.FechaEmision BETWEEN @FechaD AND @FechaA
AND x.Estatus IN ('PENDIENTE', 'CONCLUIDO')
AND y.Estatus = 'CONCLUIDO'
AND a.Empresa = @Empresa
AND x.Empresa = @Empresa
AND y.Empresa = @Empresa
INSERT IVADeclaradoInicial (
Estacion,  Empresa,   Proveedor,     RFC,   Nombre,   Mov,   MovID,   TipoOperacion,   Descripcion,
Importe, Impuesto, Impuesto15, Impuesto10, ImpuestoValidar, IvaOExento, PorcentajeDeducible)
SELECT @Estacion, a.Empresa, b.AcreedorRef, p.RFC, p.Nombre, a.Mov, a.MovID, g.TipoOperacion, b.Concepto,
b.Importe*a.TipoCambio, b.Impuestos * a.TipoCambio,
Impuesto15 = ISNULL(CASE WHEN ROUND(b.Impuestos/b.Importe, 2) = 0.16 THEN b.Impuestos * a.TipoCambio END, 0),
Impuesto10 = ISNULL(CASE WHEN ROUND(b.Impuestos/b.Importe, 2) = 0.11 THEN b.Impuestos * a.TipoCambio END, 0),
ImpuestoValidar = CASE WHEN (ROUND(b.Impuestos/b.Importe, 2) <> 0.11) AND (ROUND(b.Impuestos/b.Importe, 2) <> 0.16) THEN b.Impuestos * a.TipoCambio END,
IvaOExento = CASE WHEN (g.Impuesto1Excento = 0) AND (((CASE WHEN ROUND(b.Impuestos/b.Importe, 2) = 0.16 THEN b.Impuestos * a.TipoCambio END) IS NULL) AND ((CASE WHEN ROUND(b.Impuestos/b.Importe, 2) = 0.11 THEN b.Impuestos * a.TipoCambio END) IS NULL)) THEN 'IVA 0%'
WHEN (g.Impuesto1Excento = 0) AND ((CASE WHEN ROUND(b.Impuestos/b.Importe, 2) = 0.16 THEN b.Impuestos * a.TipoCambio END) IS NOT NULL) THEN 'IVA 16%'
WHEN (g.Impuesto1Excento = 0) AND ((CASE WHEN ROUND(b.Impuestos/b.Importe, 2) = 0.11 THEN b.Impuestos * a.TipoCambio END) IS NOT NULL) THEN 'IVA 11%'
WHEN (g.Impuesto1Excento = 1) THEN 'Exento' ELSE 'No Aplica' END,
b.PorcentajeDeducible
FROM Gasto a
JOIN GastoD b ON a.ID = b.ID
LEFT OUTER JOIN Concepto g ON b.Concepto = g.Concepto AND g.Modulo = 'GAS'
JOIN Prov p ON p.Proveedor = b.AcreedorRef
JOIN MovTipo mt ON mt.Mov = a.Mov AND mt.Modulo = 'GAS' AND mt.Clave IN ('GAS.CCH', 'GAS.C', 'GAS.CB')
WHERE
a.Estatus = 'CONCLUIDO'
AND b.Fecha BETWEEN @FechaD AND @FechaA
AND a.Empresa = @Empresa
INSERT IVADeclaradoInicial (
Estacion,  Empresa,   Proveedor,     RFC,   Nombre,   Mov,   MovID,   TipoOperacion,   Descripcion,
Importe, Impuesto, Impuesto15, Impuesto10, ImpuestoValidar, IvaOExento, PorcentajeDeducible)
SELECT @Estacion, a.Empresa, b.AcreedorRef, p.RFC, p.Nombre, a.Mov, a.MovID, g.TipoOperacion, b.Concepto,
b.Importe*a.TipoCambio, b.Impuestos * a.TipoCambio,
Impuesto15 = ISNULL(CASE WHEN ROUND(b.Impuestos/b.Importe, 2) = 0.16 THEN b.Impuestos * a.TipoCambio END, 0),
Impuesto10 = ISNULL(CASE WHEN ROUND(b.Impuestos/b.Importe, 2) = 0.11 THEN b.Impuestos * a.TipoCambio END, 0),
ImpuestoValidar = CASE WHEN (ROUND(b.Impuestos/b.Importe, 2) <> 0.11) AND (ROUND(b.Impuestos/b.Importe, 2) <> 0.16) THEN b.Impuestos * a.TipoCambio END,
IvaOExento = CASE WHEN (g.Impuesto1Excento = 0) AND (((CASE WHEN ROUND(b.Impuestos/b.Importe, 2) = 0.16 THEN b.Impuestos * a.TipoCambio END) IS NULL) AND ((CASE WHEN ROUND(b.Impuestos/b.Importe, 2) = 0.11 THEN b.Impuestos * a.TipoCambio END) IS NULL)) THEN 'IVA 0%'
WHEN (g.Impuesto1Excento = 0) AND ((CASE WHEN ROUND(b.Impuestos/b.Importe, 2) = 0.16 THEN b.Impuestos * a.TipoCambio END) IS NOT NULL) THEN 'IVA 16%'
WHEN (g.Impuesto1Excento = 0) AND ((CASE WHEN ROUND(b.Impuestos/b.Importe, 2) = 0.11 THEN b.Impuestos * a.TipoCambio END) IS NOT NULL) THEN 'IVA 11%'
WHEN (g.Impuesto1Excento = 1) THEN 'Exento' ELSE 'No Aplica' END,
b.PorcentajeDeducible
FROM Gasto a
JOIN GastoD b ON a.ID = b.ID
LEFT OUTER JOIN Concepto g ON b.Concepto = g.Concepto AND g.Modulo = 'GAS'
JOIN Prov p ON p.Proveedor = b.AcreedorRef
JOIN MovTipo mt ON mt.Mov = a.Mov AND mt.Modulo = 'GAS' AND mt.Clave = 'GAS.GTC'
WHERE
a.Estatus = 'CONCLUIDO'
AND b.Fecha BETWEEN @FechaD AND @FechaA
AND a.Empresa = @Empresa
AND (SELECT ROUND(AVG(Pagado), 0) FROM PagadoAux WHERE ModuloID = a.ID) = 100.0
INSERT IVADeclaradoInicial (
Estacion,  Empresa,   Proveedor,  RFC,   Nombre,   Mov,   MovID,   TipoOperacion,   Descripcion,
Importe, Impuesto, Impuesto15, Impuesto10, ImpuestoValidar, IvaOExento, PorcentajeDeducible)
SELECT @Estacion, a.Empresa, a.Acreedor, p.RFC, p.Nombre, a.Mov, a.MovID, g.TipoOperacion, b.Concepto,
b.Importe*a.TipoCambio, b.Impuestos * a.TipoCambio,
Impuesto15 = ISNULL(CASE WHEN ROUND(b.Impuestos/b.Importe, 2) = 0.16 THEN b.Impuestos * a.TipoCambio END, 0),
Impuesto10 = ISNULL(CASE WHEN ROUND(b.Impuestos/b.Importe, 2) = 0.11 THEN b.Impuestos * a.TipoCambio END, 0),
ImpuestoValidar = CASE WHEN (ROUND(b.Impuestos/b.Importe, 2) <> 0.11) AND (ROUND(b.Impuestos/b.Importe, 2) <> 0.16) THEN b.Impuestos * a.TipoCambio END,
IvaOExento = CASE WHEN (g.Impuesto1Excento = 0) AND (((CASE WHEN ROUND(b.Impuestos/b.Importe, 2) = 0.16 THEN b.Impuestos * a.TipoCambio END) IS NULL) AND ((CASE WHEN ROUND(b.Impuestos/b.Importe, 2) = 0.11 THEN b.Impuestos * a.TipoCambio END) IS NULL)) THEN 'IVA 0%'
WHEN (g.Impuesto1Excento = 0) AND ((CASE WHEN ROUND(b.Impuestos/b.Importe, 2) = 0.16 THEN b.Impuestos * a.TipoCambio END) IS NOT NULL) THEN 'IVA 16%'
WHEN (g.Impuesto1Excento = 0) AND ((CASE WHEN ROUND(b.Impuestos/b.Importe, 2) = 0.11 THEN b.Impuestos * a.TipoCambio END) IS NOT NULL) THEN 'IVA 11%'
WHEN (g.Impuesto1Excento = 1) THEN 'Exento' ELSE 'No Aplica' END,
b.PorcentajeDeducible
FROM Gasto a
JOIN GastoD b ON a.ID = b.ID
LEFT OUTER JOIN Concepto g ON b.Concepto = g.Concepto AND g.Modulo = 'GAS'
JOIN Prov p ON p.Proveedor = a.Acreedor
WHERE
a.Mov = 'Ajustes Op. Terceros' AND 
a.Estatus = 'CONCLUIDO'
AND a.FechaEmision BETWEEN @FechaD AND @FechaA
AND a.Empresa = @Empresa
INSERT IVADeclaradoInicial (
Estacion,  Empresa,   Proveedor,   RFC,   Nombre,   OrigenMov, OrigenMovID, TipoOperacion, ModuloMov, ModuloMovID, Mov,   MovID,   Descripcion,                       DestinoMov, DestinoMovID, FechaConciliacion,
Importe, Impuesto, Impuesto15, Impuesto10, ImpuestoValidar, IEPS20, IEPS25, IEPS30, IEPS50, IEPSCigarros, IEPSTabacos, IvaOExento, PorcentajeDeducible)
SELECT @Estacion, a.Empresa, a.Proveedor, p.RFC, p.Nombre, y.Mov,     y.MovID,     'Otros',       x.Mov,     x.MovID,     a.Mov, a.MovID, RTRIM(z.Articulo)+' '+z.SubCuenta, e.Mov,      e.MovID,      e.FechaConciliacion,
Importe = ((((b.Importe * ((z.Cantidad * z.Costo) - ISNULL(z.DescuentoImporte, 0)) / (y.Importe)) -
ISNULL(h.IVAFiscal * (b.Importe * ((z.Cantidad * z.Costo) - ISNULL(z.DescuentoImporte, 0)) / (y.Importe)), 0) -
ISNULL(h.IEPSFiscal * (b.Importe * ((z.Cantidad * z.Costo) - ISNULL(z.DescuentoImporte, 0)) / (y.Importe)), 0))) * e.TipoCambio),
Impuesto = (((((b.Importe * ((z.Cantidad * z.Costo) - ISNULL(z.DescuentoImporte, 0)) / (y.Importe)) -
ISNULL(h.IVAFiscal * (b.Importe * ((z.Cantidad * z.Costo) - ISNULL(z.DescuentoImporte, 0)) / (y.Importe)), 0) -
ISNULL(h.IEPSFiscal * (b.Importe * ((z.Cantidad * z.Costo) - ISNULL(z.DescuentoImporte, 0)) / (y.Importe)), 0))) * 0.16) * e.TipoCambio),
Impuesto15 = (((((b.Importe * ((z.Cantidad * z.Costo) - ISNULL(z.DescuentoImporte, 0)) / (y.Importe)) -
ISNULL(h.IVAFiscal * (b.Importe * ((z.Cantidad * z.Costo) - ISNULL(z.DescuentoImporte, 0)) / (y.Importe)), 0) -
ISNULL(h.IEPSFiscal * (b.Importe * ((z.Cantidad * z.Costo) - ISNULL(z.DescuentoImporte, 0)) / (y.Importe)), 0))) * 0.16) * e.TipoCambio),
Impuesto10 = (((((b.Importe * ((z.Cantidad * z.Costo) - ISNULL(z.DescuentoImporte, 0)) / (y.Importe)) -
ISNULL(h.IVAFiscal * (b.Importe * ((z.Cantidad * z.Costo) - ISNULL(z.DescuentoImporte, 0)) / (y.Importe)), 0) -
ISNULL(h.IEPSFiscal * (b.Importe * ((z.Cantidad * z.Costo) - ISNULL(z.DescuentoImporte, 0)) / (y.Importe)), 0))) * m.Impuesto1) * e.TipoCambio),
ImpuestoValidar = CASE WHEN (m.Impuesto1 <> 16.0) AND (m.Impuesto1 <> 11.0) THEN (((z.Cantidad * z.Costo) - ISNULL(z.DescuentoImporte, 0)) / (y.Importe)) * ISNULL(m.Importe1, 0) * e.TipoCambio END,
IEPS20 = ((((z.Cantidad * z.Costo) - ISNULL(z.DescuentoImporte, 0)) / (y.Importe)) * (CASE WHEN m.Impuesto2 = 20.0 THEN ISNULL(m.Importe2, 0) END)) * e.TipoCambio,
IEPS25 = ((((z.Cantidad * z.Costo) - ISNULL(z.DescuentoImporte, 0)) / (y.Importe)) * (CASE WHEN m.Impuesto2 = 25.0 THEN ISNULL(m.Importe2, 0) END)) * e.TipoCambio,
IEPS30 = ((((z.Cantidad * z.Costo) - ISNULL(z.DescuentoImporte, 0)) / (y.Importe)) * (CASE WHEN m.Impuesto2 = 30.0 THEN ISNULL(m.Importe2, 0) END)) * e.TipoCambio,
IEPS50 = ((((z.Cantidad * z.Costo) - ISNULL(z.DescuentoImporte, 0)) / (y.Importe)) * (CASE WHEN m.Impuesto2 = 50.0 THEN ISNULL(m.Importe2, 0) END)) * e.TipoCambio,
IEPSCigarros = ((((z.Cantidad * z.Costo) - ISNULL(z.DescuentoImporte, 0)) / (y.Importe)) * (CASE WHEN m.Impuesto2 = 100.0 THEN ISNULL(m.Importe2, 0) END)) * e.TipoCambio,
IEPSTabacos  = ((((z.Cantidad * z.Costo) - ISNULL(z.DescuentoImporte, 0)) / (y.Importe)) * (CASE WHEN m.Impuesto2 = 20.9 THEN ISNULL(m.Importe2, 0) END)) * e.TipoCambio,
IvaOExento = 'IVA 16%', 100
FROM Cxp a
JOIN CxpD b ON a.ID = b.ID
JOIN MovTipo mtx ON mtx.Mov = a.Mov AND mtx.Modulo = 'CXP' AND mtX.Clave = 'CXP.P'
JOIN CxpAplica h ON b.Aplica = h.Mov AND b.AplicaID = h.MovID AND h.Empresa = @Empresa
JOIN Dinero e ON e.CtaDinero = a.DineroCtaDinero AND a.Dinero = e.Mov AND a.DineroID = e.MovID
JOIN MovTipo mt2 ON mt2.Mov = e.Mov AND mt2.Modulo = 'DIN' AND mt2.Clave IN ('DIN.CH', 'DIN.CHE', 'DIN.E')
JOIN Prov p ON a.Proveedor = p.Proveedor
JOIN Cxp x ON b.Aplica = x.Mov AND b.AplicaID = x.MovID
JOIN Compra y ON x.Origen = y.Mov AND x.OrigenID = y.MovID
JOIN CompraD z ON y.ID = z.ID
JOIN Art g ON z.Articulo = g.Articulo
JOIN MovTipo mt3 ON mt3.Mov = y.Mov AND mt3.Modulo = 'COMS' AND mt3.Clave IN ('COMS.EI')
JOIN MovImpuesto m ON y.ID = m.ModuloID AND m.Modulo = 'COMS' AND ((ROUND(m.SubTotal, 2) = ROUND(y.Importe, 2)) OR (ROUND(m.SubTotal+m.Importe1+m.Importe2, 2) = ROUND(y.Importe, 2)))
WHERE e.FechaConciliacion BETWEEN @FechaD AND @FechaA
AND a.Estatus = 'CONCLUIDO'
AND e.Estatus IN ('CONCILIADO', 'CONCLUIDO') 
AND x.Estatus IN ('PENDIENTE', 'CONCLUIDO')
AND y.Estatus = 'CONCLUIDO'
AND a.Empresa = @Empresa
AND e.Empresa = @Empresa
AND x.Empresa = @Empresa
AND y.Empresa = @Empresa
SELECT * FROM IVADeclaradoInicial WHERE Estacion = @Estacion ORDER BY Proveedor, Mov, MovID
END

