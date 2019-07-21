SET DATEFIRST 7    
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1  
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROC spCFDIRetencionObtenerGasto
@Estacion   int,
@Empresa		varchar(5),
@FechaD			datetime,
@FechaA			datetime,
@Proveedor  varchar(10)

AS
BEGIN
DECLARE @MovRetencion		varchar(20);
WITH Cte
AS (
SELECT 0 [Orden], D.Empresa, M.DModulo [ModuloRaiz], M.DID [IDRaiz], M.DMov [MovRaiz], M.DMovID [MovIDRaiz], M.OModulo, M.OID, M.OMov, M.OMovID
FROM MovFlujo M WITH (NOLOCK)
JOIN Dinero D ON M.DID = D.ID
AND M.DModulo = 'DIN'
AND D.Empresa = @Empresa
AND D.FechaEmision >= @FechaD
AND D.FechaEmision <= @FechaA
AND D.Estatus = 'CONCLUIDO'
UNION ALL
SELECT C.Orden+1, C.Empresa, C.ModuloRaiz, C.IDRaiz, C.MovRaiz, C.MovIDRaiz, M.OModulo, M.OID, M.OMov, M.OMovID
FROM MovFlujo M WITH (NOLOCK)
JOIN Cte C ON M.DModulo = C.OModulo AND M.DID = C.OID
)
INSERT INTO #Movtos(Empresa, ModuloRaiz, IDRaiz, MovRaiz, MovIDRaiz, OModulo, OID, OMov, OMovID)
SELECT Empresa, ModuloRaiz, IDRaiz, MovRaiz, MovIDRaiz, OModulo, OID, OMov, OMovID
FROM Cte WITH (NOLOCK) ORDER BY 4,1
INSERT INTO #Movtos2(Empresa, ModuloRaiz, IDRaiz, MovRaiz, MovIDRaiz, OModulo, OID, OMov, OMovID)
(
SELECT D.Empresa, M.DModulo [ModuloRaiz], M.DID [IDRaiz], M.DMov [MovRaiz], M.DMovID [MovIDRaiz], M.OModulo, M.OID, M.OMov, M.OMovID
FROM MovFlujo M WITH (NOLOCK)
JOIN Dinero D WITH (NOLOCK) ON M.OID = D.ID
AND M.OModulo = 'DIN'
AND D.Empresa = @Empresa
AND D.FechaEmision >= @FechaD
AND D.FechaEmision <= @FechaA
AND D.Estatus = 'CONCLUIDO'
);
WITH Cte
AS (
SELECT 0 [Orden], D.Empresa, M.DModulo [ModuloRaiz], M.DID [IDRaiz], M.DMov [MovRaiz], M.DMovID [MovIDRaiz], M.OModulo, M.OID, M.OMov, M.OMovID
FROM MovFlujo M WITH (NOLOCK)
JOIN cxp D WITH (NOLOCK) ON M.DID = D.ID
AND M.DModulo = 'CXP'
AND D.Empresa = @Empresa
AND D.FechaEmision >= @FechaD
AND D.FechaEmision <= @FechaA
AND D.Estatus = 'PENDIENTE'
UNION ALL
SELECT C.Orden+1, C.Empresa, C.ModuloRaiz, C.IDRaiz, C.MovRaiz, C.MovIDRaiz, M.OModulo, M.OID, M.OMov, M.OMovID
FROM MovFlujo M WITH (NOLOCK)
JOIN Cte C ON M.DModulo = C.OModulo AND M.DID = C.OID
)
INSERT INTO #Movtos3(Empresa, ModuloRaiz, IDRaiz, MovRaiz, MovIDRaiz, OModulo, OID, OMov, OMovID)
SELECT Empresa, ModuloRaiz, IDRaiz, MovRaiz, MovIDRaiz, OModulo, OID, OMov, OMovID
FROM Cte WITH (NOLOCK) ORDER BY 4,1
DELETE FROM #Movtos WHERE IDRaiz IN (SELECT OID FROM #Movtos2 WHERE MovRaiz = 'Cheque Devuelto')
DELETE FROM #Movtos WHERE IDRaiz NOT IN (SELECT DISTINCT IDRaiz FROM #Movtos WHERE OMov = 'Retencion')
DELETE FROM #Movtos WHERE OMovID IN (SELECT OMovID FROM #Movtos3 GROUP BY OMovID)
SELECT @MovRetencion = CxpRetencion FROM EmpresaCfgMov WHERE Empresa = @Empresa
INSERT INTO #Pagos(
Modulo,  ID,   Empresa,   Mov,   MovID,   Ejercicio,   Periodo,   FechaEmision,   Aplica,   AplicaID, Importe,                                                                                                                                           TipoCambio,   Dinero,   DineroID,   FechaConciliacion,       EsComprobante,   DineroMov,   DineroMovID)
SELECT 'GAS', c.ID, c.Empresa, c.Mov, c.MovID, c.Ejercicio, c.Periodo, c.FechaEmision, c.Mov,    c.MovID,   SUM((ISNULL(cd.Importe,0.0)+ISNULL(cd.Impuestos,0.0)+ISNULL(cd.Impuestos2,0.0)-ISNULL(cd.Retencion,0.0)-ISNULL(cd.Retencion2,0.0))*c.TipoCambio), c.TipoCambio, c.Dinero, c.DineroID, c.DineroFechaConciliacion, 1,             c.Dinero,    c.DineroID
FROM Gasto c WITH (NOLOCK)
LEFT OUTER JOIN #Movtos M ON M.OModulo = 'GAS' AND c.id = M.OID
JOIN GastoD cd WITH (NOLOCK) ON cd.ID = c.ID
JOIN MovTipo mt WITH (NOLOCK) ON mt.Mov = c.Mov AND mt.Modulo = 'GAS'
LEFT OUTER JOIN CFDIRetPagoConciliado mtdc WITH (NOLOCK) ON mtdc.Mov = c.Mov AND ISNULL(mtdc.Aplica, c.Mov) = c.Mov
JOIN CFDIRetGastoAdicion WITH (NOLOCK) ON c.Mov = CFDIRetGastoAdicion.Mov
JOIN Prov WITH (NOLOCK) ON c.Acreedor = Prov.Proveedor
WHERE c.Estatus IN ('CONCLUIDO')
AND cd.Importe IS NOT NULL
AND c.Empresa = @Empresa
AND CASE ISNULL(mtdc.Mov, '') WHEN '' THEN c.FechaEmision ELSE c.DineroFechaConciliacion END BETWEEN @FechaD AND @FechaA
AND Prov.Proveedor = ISNULL(@Proveedor, Prov.Proveedor)
AND c.CFDRetencionTimbrado = 0
GROUP BY c.ID, c.Empresa, c.Mov, c.MovID, c.Ejercicio, c.Periodo, c.FechaEmision, c.Mov, c.MovID, c.TipoCambio, c.Dinero, c.DineroID, c.DineroFechaConciliacion
INSERT INTO #Documentos(
Modulo,	   ID,   Empresa,   Pago,  PagoID,  Mov,   MovID,   Ejercicio,   Periodo,   FechaEmision,   Proveedor,   Importe,              BaseIVA,                                                                                                                                  Tasa,                                                                       IVA,                                      ConceptoClave,    Concepto, IEPS,                                   ISAN,   Retencion1,                Retencion2,                       ConceptoSAT,    Sucursal,   ModuloID, PorcentajeDeducible)
SELECT 'GAS',   c.ID, c.Empresa, c.Mov, c.MovID, c.Mov, c.MovID, c.Ejercicio, c.Periodo, c.FechaEmision, c.Acreedor, cd.Importe*c.TipoCambio, (ISNULL(cd.Importe,0.0) + CASE WHEN ISNULL(ver.Impuesto2BaseImpuesto1,0.0) = 1 THEN ISNULL(cd.Impuestos2,0.0) ELSE 0.0 END)*c.TipoCambio, CASE WHEN NULLIF(cd.Impuestos,0.0) IS NULL THEN NULL ELSE cd.Impuesto1 END, ISNULL(cd.Impuestos,0.0)*c.TipoCambio, cd.Concepto,      cd.Concepto, ISNULL(cd.Impuestos2,0.0)*c.TipoCambio, 0.0, cd.Retencion*c.TipoCambio, cd.Retencion2*c.TipoCambio, Concepto.CFDIRetClave, c.Sucursal, c.ID,       ISNULL(cd.PorcentajeDeducible, 100)
FROM Gasto c WITH (NOLOCK)
JOIN #Movtos M ON M.OModulo = 'GAS' AND c.id = M.OID
JOIN GastoD cd WITH (NOLOCK) ON cd.ID = c.ID
JOIN MovTipo mt WITH (NOLOCK) ON mt.Mov = c.Mov AND mt.Modulo = 'GAS'
JOIN Concepto WITH (NOLOCK) ON cd.Concepto = Concepto.Concepto AND Concepto.Modulo = 'GAS'
JOIN Prov p WITH (NOLOCK) ON p.Proveedor = ISNULL(NULLIF(RTRIM(cd.AcreedorRef), ''), c.Acreedor)
LEFT OUTER JOIN Pais WITH (NOLOCK) ON p.Pais = Pais.Pais
LEFT OUTER JOIN CFDIRetPagoConciliado mtdc WITH (NOLOCK) ON mtdc.Mov = c.Mov AND ISNULL(mtdc.Aplica, c.Mov) = c.Mov
JOIN Version ver WITH (NOLOCK) ON 1=1
JOIN CFDIRetGastoAdicion WITH (NOLOCK) ON c.Mov = CFDIRetGastoAdicion.Mov
WHERE c.Estatus IN ('CONCLUIDO')
AND NOT EXISTS(SELECT DID FROM MovFlujo WHERE OModulo = 'GAS' AND OID = c.ID AND DModulo IN('CXP') AND DMov <> @MovRetencion)
AND cd.Importe IS NOT NULL
AND c.Empresa = @Empresa
AND mt.Clave NOT IN('GAS.CCH', 'GAS.GTC', 'GAS.C', 'GAS.CP')
AND p.Proveedor = ISNULL(@Proveedor, p.Proveedor)
AND CASE ISNULL(mtdc.Mov, '') WHEN '' THEN c.FechaEmision ELSE c.DineroFechaConciliacion END BETWEEN @FechaD AND @FechaA
AND (ISNULL(mt.SubClave, '') <> 'GAS.ESTRETSAT' OR ISNULL(mt.SubClave, '') <> 'GAS.ESTRETSATENEJAC' OR ISNULL(mt.SubClave, '') <> 'GAS.ESTRETSATINT') 
AND (ISNULL(mt.SubClave, '') = 'GAS.INT' or ISNULL(mt.SubClave, '') = 'GAS.DIV' or ISNULL(mt.SubClave, '') = 'GAS.ENJ')
INSERT INTO #Documentos(
Modulo,  ID,   Empresa,  Pago,  PagoID,  Mov,   MovID,   Ejercicio,   Periodo,   FechaEmision,   Proveedor,   Importe,              BaseIVA,                                                                                                                                  Tasa,                                                                       IVA,                                      ConceptoClave,    Concepto, IEPS,                                   ISAN,   Retencion1,                Retencion2,                       ConceptoSAT,    Sucursal,   ModuloID, PorcentajeDeducible,                 EsComplemento)
SELECT 'GAS', c.ID, c.Empresa, c.Mov, c.MovID, c.Mov, c.MovID, c.Ejercicio, c.Periodo, c.FechaEmision, c.Acreedor, cd.Importe*c.TipoCambio, (ISNULL(cd.Importe,0.0) + CASE WHEN ISNULL(ver.Impuesto2BaseImpuesto1,0.0) = 1 THEN ISNULL(cd.Impuestos2,0.0) ELSE 0.0 END)*c.TipoCambio, CASE WHEN NULLIF(cd.Impuestos,0.0) IS NULL THEN NULL ELSE cd.Impuesto1 END, ISNULL(cd.Impuestos,0.0)*c.TipoCambio, cd.Concepto,      cd.Concepto, ISNULL(cd.Impuestos2,0.0)*c.TipoCambio, 0.0, cd.Retencion*c.TipoCambio, cd.Retencion2*c.TipoCambio, Concepto.CFDIRetClave, c.Sucursal, c.ID,       ISNULL(cd.PorcentajeDeducible, 100), 1
FROM Gasto c WITH (NOLOCK)
LEFT OUTER JOIN #Movtos M ON M.OModulo = 'GAS' AND c.id = M.OID
JOIN GastoD cd WITH (NOLOCK) ON cd.ID = c.ID
JOIN MovTipo mt WITH (NOLOCK) ON mt.Mov = c.Mov AND mt.Modulo = 'GAS'
JOIN Concepto WITH (NOLOCK) ON cd.Concepto = Concepto.Concepto AND Concepto.Modulo = 'GAS'
JOIN Prov p WITH (NOLOCK) ON c.Acreedor = p.Proveedor
LEFT OUTER JOIN Pais WITH (NOLOCK) ON p.Pais = Pais.Pais
LEFT OUTER JOIN CFDIRetPagoConciliado mtdc WITH (NOLOCK) ON mtdc.Mov = c.Mov AND ISNULL(mtdc.Aplica, c.Mov) = c.Mov
JOIN Version ver WITH (NOLOCK) ON 1=1
JOIN CFDIRetGastoAdicion WITH (NOLOCK) ON c.Mov = CFDIRetGastoAdicion.Mov
WHERE c.Estatus IN ('CONCLUIDO')
AND cd.Importe IS NOT NULL
AND c.Empresa = @Empresa
AND (ISNULL(mt.SubClave, '') = 'GAS.ESTRETSAT' OR ISNULL(mt.SubClave, '') = 'GAS.ESTRETSATENEJAC' OR ISNULL(mt.SubClave, '') = 'GAS.ESTRETSATINT'
OR ISNULL(mt.SubClave, '') = 'GAS.INT' OR ISNULL(mt.SubClave, '') = 'GAS.DIV' OR ISNULL(mt.SubClave, '') = 'GAS.ENJ'
OR ISNULL(mt.SubClave, '') = 'GAS.EST') 
AND p.Proveedor = ISNULL(@Proveedor, p.Proveedor)
AND CASE ISNULL(mtdc.Mov, '') WHEN '' THEN c.FechaEmision ELSE c.DineroFechaConciliacion END BETWEEN @FechaD AND @FechaA
END

