SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROC spCFDIRetencionObtenerDocumento
@Estacion			int,
@Empresa			varchar(5),
@FechaD				datetime,
@FechaA				datetime,
@Proveedor			varchar(10)

AS
BEGIN
DECLARE @RetencionAlPago		bit,
@Concepto             varchar(50)
CREATE TABLE #Retenciones(
ID			int,
Mov			varchar(20)	COLLATE DATABASE_DEFAULT NULL,
MovID		varchar(20)	COLLATE DATABASE_DEFAULT NULL,
OrigenTipo	varchar(5)	COLLATE DATABASE_DEFAULT NULL,
Origen		varchar(20)	COLLATE DATABASE_DEFAULT NULL,
OrigenID	varchar(20)	COLLATE DATABASE_DEFAULT NULL,
Concepto	varchar(50)	COLLATE DATABASE_DEFAULT NULL
)
SELECT @RetencionAlPago = RetencionAlPago FROM EmpresaCfg2 WHERE Empresa = @Empresa
SELECT @Concepto = Cxp.Concepto
FROM #Pagos p
JOIN Cxp ON p.Empresa = Cxp.Empresa AND p.Aplica = Cxp.Mov AND p.AplicaID = Cxp.MovID
JOIN Prov ON Cxp.Proveedor = Prov.Proveedor
LEFT OUTER JOIN Pais ON Prov.Pais = Pais.Pais
JOIN Version ver ON 1 = 1
WHERE Cxp.Empresa = @Empresa
AND ISNULL(Cxp.OrigenTipo, '') <> 'RETENCION'
AND ISNULL(p.EsRetencion, 0) = 1
AND Cxp.Concepto IS NOT NULL
INSERT INTO #Retenciones(
ID,     Mov,     MovID,     OrigenTipo,     Origen,     OrigenID,     Concepto)
SELECT Cxp.ID, Cxp.Mov, Cxp.MovID, Cxp.OrigenTipo, Cxp.Origen, Cxp.OrigenID, CASE WHEN ISNULL(Cxp.Concepto,'') = '' THEN @Concepto ELSE Cxp.Concepto END
FROM #Pagos p
JOIN Cxp ON p.Empresa = Cxp.Empresa AND p.Aplica = Cxp.Mov AND p.AplicaID = Cxp.MovID 
JOIN Prov ON Cxp.Proveedor = Prov.Proveedor
LEFT OUTER JOIN Pais ON Prov.Pais = Pais.Pais
JOIN Version ver ON 1 = 1
WHERE Cxp.Empresa = @Empresa
AND ISNULL(Cxp.OrigenTipo, '') <> 'RETENCION'
AND ISNULL(p.EsRetencion, 0) = 1
INSERT INTO #Retenciones(
ID,     Mov,     MovID,    OrigenTipo,    Origen,    OrigenID,     Concepto)
SELECT Cxp.ID, Cxp.Mov, Cxp.MovID, oo.OrigenTipo, oo.Origen, oo.OrigenID, CASE WHEN ISNULL(Cxp.Concepto,'') = '' THEN @Concepto ELSE Cxp.Concepto END
FROM #Pagos p
JOIN Cxp ON p.Empresa = Cxp.Empresa AND p.Aplica = Cxp.Mov AND p.AplicaID = Cxp.MovID 
LEFT OUTER JOIN Cxp O ON Cxp.Empresa = O.Empresa AND Cxp.Origen = O.Mov AND Cxp.OrigenID = O.MovID
LEFT OUTER JOIN CxpD ON O.ID = CxpD.ID
LEFT OUTER JOIN Cxp oo ON O.Origen = oo.Mov AND O.OrigenID = oo.MovID
JOIN Prov ON Cxp.Proveedor = Prov.Proveedor
LEFT OUTER JOIN Pais ON Prov.Pais = Pais.Pais
JOIN Version ver ON 1 = 1
WHERE Cxp.Empresa = @Empresa
AND ISNULL(Cxp.OrigenTipo, '') = 'RETENCION'
AND ISNULL(p.EsRetencion, 0) = 1
INSERT INTO #Documentos(
Modulo,   ID,   Empresa,   Pago,  PagoID,  Mov,   MovID,   Ejercicio,   Periodo,   FechaEmision,   Proveedor,   ConceptoClave,   Concepto, Retencion1,                                                                           Retencion2,                                                                                     ConceptoSAT,    Sucursal,   ModuloID, PorcentajeDeducible,                EsComplemento, EsRetencion,   Importe,              IVA,                                  IEPS)
SELECT 'GAS',  g.ID, g.Empresa, p.Mov, p.MovID, r.Mov, r.MovID, g.Ejercicio, g.Periodo, g.FechaEmision, g.Acreedor,  d.Concepto,      d.Concepto, /*CASE SUBSTRING(r.Concepto, 1, 3) WHEN 'ISR' THEN*/ d.Retencion*g.TipoCambio/* ELSE 0 END*/, /*CASE SUBSTRING(r.Concepto, 1, 3) WHEN 'IVA' THEN */d.Retencion2*g.TipoCambio /*ELSE 0 END*/, Concepto.CFDIRetClave, g.Sucursal, g.ID,       ISNULL(d.PorcentajeDeducible, 100), 0,             1,           d.Importe*g.TipoCambio, ISNULL(d.Impuestos,0.0)*g.TipoCambio, ISNULL(d.Impuestos2,0.0)*g.TipoCambio
FROM Gasto g
JOIN GastoD d ON g.ID = d.ID
JOIN #Retenciones r ON g.Mov = r.Origen AND g.MovID = r.OrigenID 
JOIN #Pagos p ON p.Aplica = r.Mov AND p.AplicaID = r.MovID
JOIN Version ver ON 1=1
JOIN Concepto ON d.Concepto = Concepto.Concepto AND Concepto.Modulo IN('GAS', 'COMSG')
WHERE g.Empresa = @Empresa
AND r.OrigenTipo = 'GAS'
AND ISNULL(p.EsRetencion, 0) = 1
AND g.Acreedor = @Proveedor
INSERT INTO #Documentos(
Modulo,    ID,   Empresa,   Pago,  PagoID,  Mov,   MovID,   Ejercicio,   Periodo,   FechaEmision,   Proveedor,   ConceptoClave,   Concepto, Retencion1,                                                                                   Retencion2,                                                                                       ConceptoSAT,    Sucursal,   ModuloID, PorcentajeDeducible, EsComplemento, EsRetencion,    Importe,               IVA,                                         IEPS,                                                                                                                                                ISAN)
SELECT 'COMS',  g.ID, g.Empresa, p.Mov, p.MovID, r.Mov, r.MovID, g.Ejercicio, g.Periodo, g.FechaEmision, g.Proveedor, d.Articulo,      d.Articulo, /*CASE SUBSTRING(r.Concepto, 1, 3) WHEN 'ISR' THEN */ctc.Retencion1Total*g.TipoCambio/* ELSE 0 END*/,/* CASE SUBSTRING(r.Concepto, 1, 3) WHEN 'IVA' THEN */ctc.Retencion2Total*g.TipoCambio/* ELSE 0 END*/, Art.CFDIRetClave, g.Sucursal, g.ID,       100,                 0,             1,          ctc.SubTotal*g.TipoCambio, ISNULL(ctc.Impuesto1Total,0.0)*g.TipoCambio, CASE Art.CFDIRetIEPSImpuesto WHEN 'Impuesto 2' THEN ISNULL(ctc.Impuesto2Total,0.0)*g.TipoCambio ELSE ISNULL(ctc.Impuesto3Total, 0)*g.TipoCambio END, 0.0
FROM Compra g
JOIN CompraD d ON g.ID = d.ID
JOIN CompraTCalc ctc ON ctc.RenglonSub = d.RenglonSub AND ctc.Renglon = d.Renglon AND ctc.ID = d.ID
JOIN #Retenciones r ON g.Mov = r.Origen AND g.MovID = r.OrigenID 
JOIN #Pagos p ON p.Aplica = r.Mov AND p.AplicaID = r.MovID
JOIN Version ver ON 1=1
JOIN Art ON d.Articulo = Art.Articulo
WHERE g.Empresa = @Empresa
AND r.OrigenTipo = 'COMS'
AND ISNULL(p.EsRetencion, 0) = 1
AND g.Proveedor = @Proveedor
RETURN
END

