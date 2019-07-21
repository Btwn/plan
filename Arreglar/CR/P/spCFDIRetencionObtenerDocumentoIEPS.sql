SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROC spCFDIRetencionObtenerDocumentoIEPS
@Estacion			int,
@Empresa			varchar(5),
@FechaD				datetime,
@FechaA				datetime,
@Proveedor			varchar(10)

AS
BEGIN
INSERT INTO #Documentos(
Modulo,    ID,   Empresa,   Pago,  PagoID,  Mov,   MovID,   Ejercicio,   Periodo,   FechaEmision,   Proveedor,   ConceptoClave,   Concepto,     Importe,               IVA,                                         IEPS,                                                                                                                                                ISAN,    Retencion1,                       Retencion2,                       ConceptoSAT,    Sucursal,   ModuloID, PorcentajeDeducible, EsComplemento, EsRetencion, EsIEPS)
SELECT 'COMS',  g.ID, g.Empresa, p.Mov, p.MovID, g.Mov, g.MovID, g.Ejercicio, g.Periodo, g.FechaEmision, g.Proveedor, d.Articulo,      d.Articulo, ctc.SubTotal*g.TipoCambio, ISNULL(ctc.Impuesto1Total,0.0)*g.TipoCambio, CASE Art.CFDIRetIEPSImpuesto WHEN 'Impuesto 2' THEN ISNULL(ctc.Impuesto2Total,0.0)*g.TipoCambio ELSE ISNULL(ctc.Impuesto3Total, 0)*g.TipoCambio END, 0.0, ctc.Retencion1Total*g.TipoCambio, ctc.Retencion2Total*g.TipoCambio, Art.CFDIRetClave, g.Sucursal, g.ID,       100,                 0,             0,           1
FROM Compra g
JOIN CompraD d ON g.ID = d.ID
JOIN CompraTCalc ctc ON ctc.RenglonSub = d.RenglonSub AND ctc.Renglon = d.Renglon AND ctc.ID = d.ID
JOIN #Pagos p ON g.ID = p.AplicaModuloID
JOIN Version ver ON 1=1
JOIN Art ON d.Articulo = Art.Articulo
WHERE g.Empresa = @Empresa
AND p.AplicaModulo = 'COMS'
AND ISNULL(p.EsIEPS, 0) = 1
AND g.Proveedor = @Proveedor
INSERT INTO #Documentos(
Modulo,	  ID,   Empresa,   Pago,  PagoID,  Mov,   MovID,   Ejercicio,   Periodo,   FechaEmision,   Proveedor,   Importe,              BaseIVA,                                                                                                                                Tasa,                                                                     IVA,                                    ConceptoClave,   Concepto, IEPS,                                  ISAN,   Retencion1,               Retencion2,                       ConceptoSAT,    Sucursal,   ModuloID, PorcentajeDeducible,                EsComplemento, EsRetencion, EsIEPS)
SELECT 'GAS',  g.ID, g.Empresa, p.Mov, p.MovID, g.Mov, g.MovID, g.Ejercicio, g.Periodo, g.FechaEmision, g.Acreedor,  d.Importe*g.TipoCambio, (ISNULL(d.Importe,0.0) + CASE WHEN ISNULL(ver.Impuesto2BaseImpuesto1,0.0) = 1 THEN ISNULL(d.Impuestos2,0.0) ELSE 0.0 END)*g.TipoCambio, CASE WHEN NULLIF(d.Impuestos,0.0) IS NULL THEN NULL ELSE d.Impuesto1 END, ISNULL(d.Impuestos,0.0)*g.TipoCambio, d.Concepto,      d.Concepto, ISNULL(d.Impuestos2,0.0)*g.TipoCambio, 0.0,  d.Retencion*g.TipoCambio, d.Retencion2*g.TipoCambio, Concepto.CFDIRetClave, g.Sucursal, g.ID,       ISNULL(d.PorcentajeDeducible, 100), 0,             0,           1
FROM Gasto g
JOIN GastoD d ON g.ID = d.ID
JOIN #Pagos p ON g.ID = p.AplicaModuloID
JOIN Version ver ON 1=1
JOIN Concepto ON d.Concepto = Concepto.Concepto AND Concepto.Modulo = 'GAS'
JOIN Prov pr ON g.Acreedor = pr.Proveedor
LEFT OUTER JOIN Pais ON pr.Pais = Pais.Pais
WHERE g.Empresa = @Empresa
AND p.AplicaModulo = 'GAS'
AND ISNULL(p.EsIEPS, 0) = 1
AND g.Acreedor = @Proveedor
RETURN
END

