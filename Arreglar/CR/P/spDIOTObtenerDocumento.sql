SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROC spDIOTObtenerDocumento
@Estacion						int,
@Empresa						varchar(5),
@FechaD							datetime,
@FechaA							datetime,
@CalcularBaseImportacion		bit,
@COMSIVAImportacionAnticipado	bit,
@GASIncluirMovSinCxp			bit

AS
BEGIN
DECLARE @CxpGastoDiverso		varchar(20)
SELECT @CxpGastoDiverso = CxpGastoDiverso FROM EmpresaCfgMov WHERE Empresa = @Empresa
EXEC xpDIOTObtenerDocumentoCOMS @Estacion, @Empresa, @FechaD, @FechaA, @CalcularBaseImportacion, @COMSIVAImportacionAnticipado
IF NOT EXISTS(SELECT 1 FROM #Documentos WHERE TipoInsert = 1)
INSERT INTO #Documentos(ID, Empresa, Pago, PagoID, Mov, MovID, Ejercicio, Periodo,
FechaEmision, Proveedor, Nombre, RFC, ImportadorRegistro, Pais, Nacionalidad, TipoDocumento,
TipoTercero, Importe, BaseIVA, Tasa, IVA, ConceptoClave, Concepto, EsImportacion, EsExcento,
IEPS, ISAN, Retencion1, Retencion2, DineroMov, DineroMovID,
DineroMov2,	DineroMovID2, DineroFormaPago, DineroImporte, ContID, ContMov, ContMovID, TipoInsert)
SELECT Cxp.ID, Cxp.Empresa, p.Mov, p.MovID, Cxp.Mov, Cxp.MovID, Cxp.Ejercicio, Cxp.Periodo,
Cxp.FechaEmision, Cxp.Proveedor, Prov.Nombre, Prov.RFC, Prov.ImportadorRegistro, dp.Pais, dp.Nacionalidad, dbo.fnDIOTTipoDocumento('COMS', c.Mov),
dbo.fnDIOTTipoTercero(Cxp.Proveedor), ctc.SubTotal*c.TipoCambio, ROUND((ISNULL(ctc.SubTotal,0.0) + CASE WHEN ISNULL(ver.Impuesto2BaseImpuesto1,0.0) = 1 THEN ISNULL(ctc.Impuesto2Total,0.0) ELSE 0.0 END)*c.TipoCambio, 2), ISNULL(d.Impuesto1, 0), ISNULL(ctc.Impuesto1Total,0.0)*c.TipoCambio, Art.Articulo,      Art.Descripcion1, dbo.fnDIOTEsImportacion('COMS', c.Mov), ISNULL(Art.Impuesto1Excento,0),
ISNULL(ctc.Impuesto2Total,0.0)*c.TipoCambio, 0.0,  ctc.Retencion2Total*c.TipoCambio, ctc.Retencion1Total*c.TipoCambio, DineroMov, DineroMovID,
p.DineroMov2, p.DineroMovID2, p.DineroFormaPago, p.DineroImporte, p.ContID, p.ContMov, p.ContMovID, 1
FROM #Pagos p
JOIN Cxp ON p.Empresa = Cxp.Empresa AND p.Aplica = Cxp.Mov AND p.AplicaID = Cxp.MovID
JOIN Compra c ON c.MovID = Cxp.OrigenID AND c.Mov = cxp.Origen AND Cxp.OrigenTipo = 'COMS' AND c.Empresa = cxp.Empresa
JOIN CompraD d ON c.ID = d.ID
JOIN CompraTCalc ctc ON ctc.RenglonSub = d.RenglonSub AND ctc.Renglon = d.Renglon AND ctc.ID = d.ID
JOIN MovTipo ON c.Mov = MovTipo.Mov AND MovTipo.Modulo = 'COMS'
JOIN Art ON d.Articulo = Art.Articulo
JOIN Prov ON Cxp.Proveedor = Prov.Proveedor
LEFT OUTER JOIN Pais ON Prov.Pais = Pais.Pais
LEFT OUTER JOIN DIOTPais dp ON Pais.Pais = dp.Pais
LEFT JOIN DIOTArt ON Art.Articulo = DIOTArt.Articulo
JOIN Version ver ON 1 = 1
WHERE ISNULL(DIOTArt.Articulo, '') = Art.Articulo
AND MovTipo.Clave NOT IN ('COMS.EI','COMS.GX')
AND Cxp.Mov <> @CxpGastoDiverso
EXEC xpDIOTObtenerDocumentoGD @Estacion, @Empresa, @FechaD, @FechaA, @CalcularBaseImportacion, @COMSIVAImportacionAnticipado
IF NOT EXISTS(SELECT 1 FROM #Documentos WHERE TipoInsert = 2)
INSERT INTO #Documentos(ID, Empresa, Pago, PagoID, Mov, MovID, Ejercicio, Periodo,
FechaEmision, Proveedor, Nombre, RFC, ImportadorRegistro, Pais, Nacionalidad, TipoDocumento,
TipoTercero, Importe, BaseIVA, Tasa, IVA, ConceptoClave, Concepto, EsImportacion, EsExcento,
IEPS, ISAN, Retencion1, Retencion2, DineroMov, DineroMovID,
DineroMov2,	DineroMovID2, DineroFormaPago, DineroImporte, ContID, ContMov, ContMovID, TipoInsert)
SELECT Cxp.ID, Cxp.Empresa, p.Mov,  p.MovID, Cxp.Mov, Cxp.MovID, Cxp.Ejercicio, Cxp.Periodo,
Cxp.FechaEmision, Cxp.Proveedor, Prov.Nombre, Prov.RFC, Prov.ImportadorRegistro, dp.Pais, dp.Nacionalidad, dbo.fnDIOTTipoDocumento('CXP', Cxp.Mov),
dbo.fnDIOTTipoTercero(Cxp.Proveedor), Cxp.Importe*Cxp.TipoCambio, (ISNULL(CONVERT(float,Cxp.Importe),0.0) + CASE WHEN ISNULL(ver.Impuesto2BaseImpuesto1,0.0) = 1 THEN ((CONVERT(float,Cxp.Importe)/NULLIF((1.0-ISNULL(CONVERT(float,Cxp.IEPSFiscal),0.0)),0.0))*ISNULL(CONVERT(float,Cxp.IEPSFiscal),0.0)) ELSE 0.0 END)*Cxp.TipoCambio, dbo.fnDIOTIVATasa(Cxp.Empresa,Cxp.Importe,Cxp.Impuestos), dbo.fnDIOTIVA(Cxp.Importe, Cxp.Impuestos), Cxp.Concepto,  Cxp.Concepto, dbo.fnDIOTEsImportacion('CXP', Cxp.Mov), 0, (ISNULL(CONVERT(float,Cxp.Importe),0.0)/NULLIF((1.0-ISNULL(CONVERT(float,Cxp.IEPSFiscal),0.0)),0.0))*ISNULL(CONVERT(float,Cxp.IEPSFiscal),0.0)*Cxp.TipoCambio, 0.0,  cgd.Retencion*Cxp.TipoCambio,        cgd.Retencion2*Cxp.TipoCambio, DineroMov, DineroMovID,
p.DineroMov2, p.DineroMovID2, p.DineroFormaPago, p.DineroImporte, p.ContID, p.ContMov, p.ContMovID, 2
FROM #Pagos p
JOIN Cxp ON p.Empresa = Cxp.Empresa AND p.Aplica = Cxp.Mov AND p.AplicaID = Cxp.MovID
JOIN Compra c ON c.MovID = Cxp.OrigenID AND c.Mov = cxp.Origen AND Cxp.OrigenTipo = 'COMS' AND c.Empresa = cxp.Empresa
JOIN CompraD d ON c.ID = d.ID
JOIN CompraTCalc ctc ON ctc.RenglonSub = d.RenglonSub AND ctc.Renglon = d.Renglon AND ctc.ID = d.ID
JOIN MovTipo ON c.Mov = MovTipo.Mov AND MovTipo.Modulo = 'COMS'
LEFT JOIN CompraGastoDiverso cgd ON cgd.Id = c.id
JOIN Art ON d.Articulo = Art.Articulo
JOIN Prov ON Cxp.Proveedor = Prov.Proveedor
LEFT OUTER JOIN Pais ON Prov.Pais = Pais.Pais
LEFT OUTER JOIN DIOTPais dp ON Pais.Pais = dp.Pais
LEFT JOIN DIOTArt ON Art.Articulo = DIOTArt.Articulo
JOIN Version ver ON 1 = 1
WHERE ISNULL(DIOTArt.Articulo, '') = Art.Articulo
AND MovTipo.Clave NOT IN ('COMS.EI','COMS.GX')
AND Cxp.Mov = @CxpGastoDiverso
IF @CalcularBaseImportacion = 1 AND @COMSIVAImportacionAnticipado = 0
BEGIN
EXEC xpDIOTObtenerDocumentoEI @Estacion, @Empresa, @FechaD, @FechaA, @CalcularBaseImportacion, @COMSIVAImportacionAnticipado
IF NOT EXISTS(SELECT 1 FROM #Documentos WHERE TipoInsert = 3)
INSERT INTO #Documentos(ID, Empresa, Pago, PagoID, Mov, MovID, Ejercicio, Periodo, FechaEmision, Proveedor, Nombre, RFC,
ImportadorRegistro, Pais, Nacionalidad, TipoDocumento, TipoTercero, Importe, BaseIVA, Tasa, IVA,
EsImportacion, EsExcento, IEPS, ISAN, Retencion1, Retencion2,
BaseIVAImportacion, DineroMov, DineroMovID,
p.DineroMov2, p.DineroMovID2, p.DineroFormaPago, p.DineroImporte, p.ContID, p.ContMov, p.ContMovID, TipoInsert)
SELECT Cxp.ID, Cxp.Empresa, p.Mov, p.MovID, Cxp.Mov, Cxp.MovID, Cxp.Ejercicio, Cxp.Periodo, Cxp.FechaEmision, Cxp.Proveedor, Prov.Nombre, Prov.RFC,
Prov.ImportadorRegistro, dp.Pais, dp.Nacionalidad, dbo.fnDIOTTipoDocumento('COMS', c.Mov), dbo.fnDIOTTipoTercero(Cxp.Proveedor),
SUM((ctc.SubTotal*c.TipoCambio))+dbo.fnDIOTBaseIVAImportacion(Cxp.Origen, Cxp.OrigenID, c.Empresa, DIOTCfg.CalcularBaseImportacion) 'Importe',
SUM((ctc.SubTotal*c.TipoCambio))+ dbo.fnDIOTBaseIVAImportacion(Cxp.Origen, Cxp.OrigenID, c.Empresa, DIOTCfg.CalcularBaseImportacion) 'BaseIVA',
CASE dbo.fnDIOTIVAImportacion(Cxp.Origen, Cxp.OrigenID, c.Empresa, DIOTCfg.CalcularBaseImportacion) WHEN 0 THEN 0 ELSE dbo.fnDIOTTasaIVAImportacion(Cxp.Origen, Cxp.OrigenID, c.Empresa, DIOTCfg.CalcularBaseImportacion, eg.DefImpuesto) END 'Tasa',
dbo.fnDIOTIVAImportacion(Cxp.Origen, Cxp.OrigenID, c.Empresa, DIOTCfg.CalcularBaseImportacion) 'IVA',
dbo.fnDIOTEsImportacion('COMS', c.Mov), ISNULL(Art.Impuesto1Excento,0), SUM(ISNULL(ctc.Impuesto2Total,0.0)*c.TipoCambio), 0.0,
SUM(cgd.Retencion*cgd.TipoCambio), SUM(cgd.Retencion2*cgd.TipoCambio),
ISNULL(dbo.fnDIOTBaseIVAImportacion(Cxp.Origen, Cxp.OrigenID, c.Empresa, DIOTCfg.CalcularBaseImportacion), 0) + ISNULL(dbo.fnDIOTIVAImportacion(Cxp.Origen, Cxp.OrigenID, c.Empresa, DIOTCfg.CalcularBaseImportacion), 0) - SUM(ISNULL(ctc.Impuesto1Total,0.0)*c.TipoCambio),
DineroMov, DineroMovID,
p.DineroMov2, p.DineroMovID2, p.DineroFormaPago, p.DineroImporte, p.ContID, p.ContMov, p.ContMovID, 3
FROM #Pagos p
JOIN Cxp ON p.Empresa = Cxp.Empresa AND p.Aplica = Cxp.Mov AND p.AplicaID = Cxp.MovID
JOIN Compra c ON c.MovID = Cxp.OrigenID AND c.Mov = cxp.Origen AND Cxp.OrigenTipo = 'COMS' AND c.Empresa = cxp.Empresa
JOIN CompraD d ON c.ID = d.ID AND Cxp.Proveedor = ISNULL(NULLIF(RTRIM(d.ImportacionProveedor), ''), c.Proveedor) AND ISNULL(Cxp.Referencia, '') = ISNULL(NULLIF(RTRIM(d.ImportacionReferencia), ''), ISNULL(Cxp.Referencia, ''))
JOIN CompraTCalc ctc ON ctc.RenglonSub = d.RenglonSub AND ctc.Renglon = d.Renglon AND ctc.ID = d.ID
JOIN MovTipo ON c.Mov = MovTipo.Mov AND MovTipo.Modulo = 'COMS'
LEFT JOIN CompraGastoDiverso cgd ON cgd.Id = c.id AND cgd.Concepto IN (SELECT Concepto FROM DIOTConceptoImportacion)
JOIN Art ON d.Articulo = Art.Articulo
JOIN Prov ON Cxp.Proveedor = Prov.Proveedor
LEFT OUTER JOIN Pais ON Prov.Pais = Pais.Pais
LEFT OUTER JOIN DIOTPais dp ON Pais.Pais = dp.Pais
LEFT JOIN DIOTArt ON Art.Articulo = DIOTArt.Articulo
JOIN Version ver ON 1 = 1
JOIN DIOTCfg ON DIOTCfg.Empresa = Cxp.Empresa
JOIN EmpresaGral eg ON eg.Empresa = c.Empresa
WHERE ISNULL(DIOTArt.Articulo, '') = Art.Articulo
AND MovTipo.Clave IN ('COMS.EI','COMS.GX')
AND Cxp.Mov <> @CxpGastoDiverso
GROUP BY Cxp.ID, Cxp.Empresa, p.Mov, p.MovID, Cxp.Mov, Cxp.MovID, Cxp.Ejercicio, Cxp.Periodo, Cxp.FechaEmision, Cxp.Proveedor, Prov.Nombre, Prov.RFC, dp.Pais, dp.Nacionalidad,
c.Mov, Cxp.Origen, Cxp.OrigenID, c.Empresa, DIOTCfg.CalcularBaseImportacion, ISNULL(Art.Impuesto1Excento,0), Prov.ImportadorRegistro, DineroMov, DineroMovID, eg.DefImpuesto,
p.DineroMov2, p.DineroMovID2, p.DineroFormaPago, p.DineroImporte, p.ContID, p.ContMov, p.ContMovID
END
ELSE IF @CalcularBaseImportacion = 0 AND @COMSIVAImportacionAnticipado = 1
BEGIN
INSERT INTO #Documentos(ID, Empresa, Pago, PagoID, Mov, MovID, Ejercicio, Periodo, FechaEmision, Proveedor, Nombre, RFC,
ImportadorRegistro, Pais, Nacionalidad, TipoDocumento, TipoTercero, Importe, BaseIVA, Tasa,
IVA, ConceptoClave,Concepto, EsImportacion, EsExcento, IEPS, ISAN, Retencion1, Retencion2, DineroMov, DineroMovID,
BaseIVAImportacion, PorcentajeDeducible,
DineroMov2,	DineroMovID2, DineroFormaPago, DineroImporte, ContID, ContMov, ContMovID, TipoInsert)
SELECT Cxp.ID, Cxp.Empresa, p.Mov, p.MovID, Cxp.Mov, Cxp.MovID, Cxp.Ejercicio, Cxp.Periodo, Cxp.FechaEmision, co.Proveedor, Prov.Nombre, Prov.RFC, Prov.ImportadorRegistro, dp.Pais, dp.Nacionalidad, dbo.fnDIOTTipoDocumento('COMS', co.Mov),
dbo.fnDIOTTipoTercero(co.Proveedor),
SUM(((ISNULL(ctc.SubTotal,0.0) + CASE WHEN ISNULL(ver.Impuesto2BaseImpuesto1,0.0) = 1 THEN ISNULL(ctc.Impuesto2Total,0.0) ELSE 0.0 END)*c.TipoCambio)) + dbo.fnDIOTBaseIVAImportacion(co.Mov, co.MovID, co.Empresa, CalcularBaseImportacion),
SUM(((ISNULL(ctc.SubTotal,0.0) + CASE WHEN ISNULL(ver.Impuesto2BaseImpuesto1,0.0) = 1 THEN ISNULL(ctc.Impuesto2Total,0.0) ELSE 0.0 END)*c.TipoCambio)) + dbo.fnDIOTBaseIVAImportacion(co.Mov, co.MovID, co.Empresa, CalcularBaseImportacion),
ISNULL(NULLIF(dbo.fnDIOTIVATasa(cxp.Empresa, cxp.Importe, cxp.Impuestos), 0), eg.DefImpuesto),
(ISNULL(cxp.Importe, 0) + ISNULL(cxp.Impuestos, 0))*cxp.TipoCambio,
d.Concepto, d.Concepto, dbo.fnDIOTEsImportacion('COMS', co.Mov), ISNULL(Concepto.Impuesto1Excento,0), ISNULL(0.0/*d.Impuestos2*/,0.0)*c.TipoCambio, 0.0,
SUM(cgd.Retencion*cgd.TipoCambio),
SUM(cgd.Retencion2*cgd.TipoCambio),
DineroMov, DineroMovID,
-1,
100,
p.DineroMov2, p.DineroMovID2, p.DineroFormaPago, p.DineroImporte, p.ContID, p.ContMov, p.ContMovID, 3
FROM #Pagos p
JOIN Cxp ON p.Empresa = Cxp.Empresa AND p.Aplica = Cxp.Mov AND p.AplicaID = Cxp.MovID
JOIN Gasto c ON c.MovID = Cxp.OrigenID AND c.Mov = cxp.Origen AND Cxp.OrigenTipo = 'GAS' AND c.Empresa = cxp.Empresa
JOIN GastoD d ON c.ID = d.ID
JOIN Compra co ON co.MovID = c.OrigenID AND co.Mov = c.Origen AND c.OrigenTipo = 'COMS' AND c.Empresa = co.Empresa
JOIN CompraD cd on co.ID = cd.ID
JOIN CompraTCalc ctc ON ctc.RenglonSub = cd.RenglonSub AND ctc.Renglon = cd.Renglon AND ctc.ID = cd.ID
LEFT OUTER JOIN Concepto ON d.Concepto = Concepto.Concepto AND Concepto.Modulo = 'COMSG'
JOIN Prov ON co.Proveedor = Prov.Proveedor
LEFT OUTER JOIN MovTipo mt ON mt.Mov = c.Origen AND mt.Modulo = c.OrigenTipo
LEFT JOIN CompraGastoDiverso cgd ON cgd.Id = co.id
LEFT OUTER JOIN Pais ON Prov.Pais = Pais.Pais
LEFT OUTER JOIN DIOTPais dp ON Pais.Pais = dp.Pais
JOIN DIOTCfg ON DIOTCfg.Empresa = Cxp.Empresa
JOIN EmpresaGral eg ON Cxp.Empresa = eg.Empresa
JOIN Version ver ON 1 = 1
WHERE (ISNULL(mt.Clave, '') IN ('COMS.EI','COMS.GX')
AND d.Concepto IN(SELECT Concepto FROM DIOTConceptoIVAImportacion))
GROUP BY c.Origen, c.OrigenID, Cxp.ID, Cxp.Empresa, p.Mov, p.MovID, Cxp.Mov, Cxp.MovID, Cxp.Ejercicio, Cxp.Periodo, Cxp.FechaEmision, co.Proveedor,
Prov.Nombre, Prov.RFC, Prov.ImportadorRegistro, dp.Pais, dp.Nacionalidad, c.Mov, Cxp.Proveedor,
d.Concepto, d.Concepto, c.Mov, Concepto.Impuesto1Excento, c.TipoCambio, cxp.Importe, cxp.Impuestos,eg.DefImpuesto,cxp.TipoCambio,ver.Impuesto2BaseImpuesto1,
co.Mov, co.MovID, co.Empresa, CalcularBaseImportacion, Cxp.Origen, Cxp.OrigenID, c.Empresa,
DineroMov, DineroMovID,
p.DineroMov2, p.DineroMovID2, p.DineroFormaPago, p.DineroImporte, p.ContID, p.ContMov, p.ContMovID
INSERT INTO #Documentos(ID, Empresa, Pago, PagoID, Mov, MovID, Ejercicio, Periodo, FechaEmision, Proveedor, Nombre, RFC,
ImportadorRegistro, Pais, Nacionalidad, TipoDocumento, TipoTercero, Importe, BaseIVA, Tasa, IVA,
ConceptoClave,Concepto, EsImportacion, EsExcento, IEPS, ISAN, Retencion1, Retencion2, DineroMov, DineroMovID,
BaseIVAImportacion, PorcentajeDeducible,
DineroMov2,	DineroMovID2, DineroFormaPago, DineroImporte, ContID, ContMov, ContMovID, TipoInsert)
SELECT Cxp.ID, Cxp.Empresa, p.Mov, p.MovID, Cxp.Mov, Cxp.MovID, Cxp.Ejercicio, Cxp.Periodo, Cxp.FechaEmision, c.Proveedor, Prov.Nombre, Prov.RFC, Prov.ImportadorRegistro, dp.Pais, dp.Nacionalidad, dbo.fnDIOTTipoDocumento('COMS', c.Mov),
dbo.fnDIOTTipoTercero(c.Proveedor),
SUM(((ISNULL(ctc.SubTotal,0.0) + CASE WHEN ISNULL(ver.Impuesto2BaseImpuesto1,0.0) = 1 THEN ISNULL(ctc.Impuesto2Total,0.0) ELSE 0.0 END)*c.TipoCambio)) + dbo.fnDIOTBaseIVAImportacion(c.Mov, c.MovID, c.Empresa, CalcularBaseImportacion),
SUM(((ISNULL(ctc.SubTotal,0.0) + CASE WHEN ISNULL(ver.Impuesto2BaseImpuesto1,0.0) = 1 THEN ISNULL(ctc.Impuesto2Total,0.0) ELSE 0.0 END)*c.TipoCambio)) + dbo.fnDIOTBaseIVAImportacion(c.Mov, c.MovID, c.Empresa, CalcularBaseImportacion),
ISNULL(NULLIF(dbo.fnDIOTIVATasa(cxp.Empresa, cxp.Importe, cxp.Impuestos), 0), eg.DefImpuesto),
(ISNULL(cxp.Importe, 0) + ISNULL(cxp.Impuestos, 0))*cxp.TipoCambio,
Cxp.Concepto, Cxp.Concepto, dbo.fnDIOTEsImportacion('COMS', c.Mov), ISNULL(Concepto.Impuesto1Excento,0), ISNULL(0.0/*d.Impuestos2*/,0.0)*c.TipoCambio, 0.0,
SUM(cgd.Retencion*cgd.TipoCambio),
SUM(cgd.Retencion2*cgd.TipoCambio),
DineroMov, DineroMovID,
-1,
100,
p.DineroMov2, p.DineroMovID2, p.DineroFormaPago, p.DineroImporte, p.ContID, p.ContMov, p.ContMovID, 3
FROM #Pagos p
JOIN Cxp ON p.Empresa = Cxp.Empresa AND p.Aplica = Cxp.Mov AND p.AplicaID = Cxp.MovID
JOIN Compra c ON c.MovID = Cxp.OrigenID AND c.Mov = cxp.Origen AND Cxp.OrigenTipo = 'COMS' AND c.Empresa = cxp.Empresa
JOIN CompraD cd on c.ID = cd.ID
JOIN CompraTCalc ctc ON ctc.RenglonSub = cd.RenglonSub AND ctc.Renglon = cd.Renglon AND ctc.ID = cd.ID
JOIN MovTipo ON c.Mov = MovTipo.Mov AND MovTipo.Modulo = 'COMS'
LEFT JOIN CompraGastoDiverso cgd ON cgd.Id = c.id AND cgd.Concepto IN (SELECT Concepto FROM DIOTConceptoImportacion)
JOIN Prov ON Cxp.Proveedor = Prov.Proveedor
LEFT OUTER JOIN Pais ON Prov.Pais = Pais.Pais
LEFT OUTER JOIN DIOTPais dp ON Pais.Pais = dp.Pais
JOIN Version ver ON 1 = 1
LEFT OUTER JOIN Concepto ON cxp.Concepto = Concepto.Concepto AND Concepto.Modulo = 'COMSG'
JOIN DIOTCfg ON DIOTCfg.Empresa = Cxp.Empresa
JOIN EmpresaGral eg ON Cxp.Empresa = eg.Empresa
WHERE (ISNULL(MovTipo.Clave, '') IN ('COMS.EI','COMS.GX')
AND cxp.Concepto IN(SELECT Concepto FROM DIOTConceptoIVAImportacion))
AND Cxp.Mov = @CxpGastoDiverso
GROUP BY Cxp.ID, Cxp.Empresa, p.Mov, p.MovID, Cxp.Mov, Cxp.MovID, Cxp.Ejercicio, Cxp.Periodo, Cxp.FechaEmision, c.Proveedor, Prov.Nombre, Prov.RFC,
Prov.ImportadorRegistro, dp.Pais, dp.Nacionalidad, c.Mov, c.Proveedor, cxp.Empresa, cxp.Importe, cxp.Impuestos, eg.DefImpuesto,
cxp.Importe, cxp.Impuestos, cxp.TipoCambio, Cxp.Concepto, c.Mov, Concepto.Impuesto1Excento,DineroMov, DineroMovID, c.MovID,c.Empresa,
DIOTCfg.CalcularBaseImportacion, c.TipoCambio,
p.DineroMov2, p.DineroMovID2, p.DineroFormaPago, p.DineroImporte, p.ContID, p.ContMov, p.ContMovID
INSERT INTO #Documentos(ID, Empresa, Pago, PagoID, Mov, MovID, Ejercicio, Periodo, FechaEmision, Proveedor, Nombre, RFC,
ImportadorRegistro, Pais, Nacionalidad, TipoDocumento, TipoTercero, Importe, BaseIVA, Tasa, IVA,
ConceptoClave,Concepto, EsImportacion, EsExcento, IEPS, ISAN, Retencion1, Retencion2, DineroMov, DineroMovID,
BaseIVAImportacion, PorcentajeDeducible,
DineroMov2,	DineroMovID2, DineroFormaPago, DineroImporte, ContID, ContMov, ContMovID, TipoInsert)
SELECT	Cxp.ID, Cxp.Empresa, p.Mov, p.MovID, Cxp.Mov, Cxp.MovID, Cxp.Ejercicio, Cxp.Periodo, Cxp.FechaEmision, Cxp.Proveedor, Prov.Nombre, Prov.RFC, Prov.ImportadorRegistro, dp.Pais, dp.Nacionalidad, dbo.fnDIOTTipoDocumento('COMS', c2.Mov),
dbo.fnDIOTTipoTercero(c2.Proveedor),
SUM(((ISNULL(ctc.SubTotal,0.0) + CASE WHEN ISNULL(ver.Impuesto2BaseImpuesto1,0.0) = 1 THEN ISNULL(ctc.Impuesto2Total,0.0) ELSE 0.0 END)*c2.TipoCambio)) + dbo.fnDIOTBaseIVAImportacion(c2.Mov, c2.MovID, c2.Empresa, CalcularBaseImportacion),
SUM(((ISNULL(ctc.SubTotal,0.0) + CASE WHEN ISNULL(ver.Impuesto2BaseImpuesto1,0.0) = 1 THEN ISNULL(ctc.Impuesto2Total,0.0) ELSE 0.0 END)*c2.TipoCambio)) + dbo.fnDIOTBaseIVAImportacion(c2.Mov, c2.MovID, c2.Empresa, CalcularBaseImportacion),
ISNULL(NULLIF(dbo.fnDIOTIVATasa(cxp.Empresa, cxp.Importe, cxp.Impuestos), 0), eg.DefImpuesto),
(ISNULL(cxp.Importe, 0) + ISNULL(cxp.Impuestos, 0))*cxp.TipoCambio,
Cxp.Concepto, Cxp.Concepto, dbo.fnDIOTEsImportacion('COMS', c2.Mov), ISNULL(Concepto.Impuesto1Excento,0), ISNULL(0.0/*d.Impuestos2*/,0.0)*c2.TipoCambio, 0.0,
SUM(cgd.Retencion*cgd.TipoCambio),
SUM(cgd.Retencion2*cgd.TipoCambio),
DineroMov, DineroMovID,
-1,
100,
p.DineroMov2, p.DineroMovID2, p.DineroFormaPago, p.DineroImporte, p.ContID, p.ContMov, p.ContMovID, 3
FROM #Pagos p
JOIN Cxp ON p.Empresa = Cxp.Empresa AND p.Aplica = Cxp.Mov AND p.AplicaID = Cxp.MovID
JOIN Cxp c2 ON c2.Empresa = cxp.Empresa AND c2.Mov = cxp.Origen AND c2.MovID = cxp.OrigenID
JOIN Compra c3 ON c3.MovID = c2.OrigenID AND c3.Mov = c2.Origen AND c2.OrigenTipo = 'COMS' AND c3.Empresa = c2.Empresa
JOIN CompraD cd on c3.ID = cd.ID
JOIN CompraTCalc ctc ON ctc.RenglonSub = cd.RenglonSub AND ctc.Renglon = cd.Renglon AND ctc.ID = cd.ID
JOIN MovTipo mt ON c3.Mov = mt.Mov AND mt.Modulo = 'COMS'
JOIN MovTipo mt2 ON Cxp.Mov = mt2.Mov AND mt2.Modulo = 'CXP'
LEFT JOIN CompraGastoDiverso cgd ON cgd.Id = c3.id AND cgd.Concepto IN (SELECT Concepto FROM DIOTConceptoImportacion)
JOIN Prov ON Cxp.Proveedor = Prov.Proveedor
LEFT OUTER JOIN Pais ON Prov.Pais = Pais.Pais
LEFT OUTER JOIN DIOTPais dp ON Pais.Pais = dp.Pais
JOIN Version ver ON 1 = 1
LEFT OUTER JOIN Concepto ON cxp.Concepto = Concepto.Concepto AND Concepto.Modulo = 'COMSG'
JOIN DIOTCfg ON DIOTCfg.Empresa = Cxp.Empresa
JOIN EmpresaGral eg ON Cxp.Empresa = eg.Empresa
WHERE ISNULL(mt.Clave, '') IN ('COMS.EI','COMS.GX')
AND ISNULL(mt2.Clave,'') IN ('CXP.FAC','CXP.D')
AND cxp.Concepto IN(SELECT Concepto FROM DIOTConceptoIVAImportacion)
AND c2.Mov = @CxpGastoDiverso
GROUP BY Cxp.ID, Cxp.Empresa, p.Mov, p.MovID, Cxp.Mov, Cxp.MovID, Cxp.Ejercicio, Cxp.Periodo, Cxp.FechaEmision, Cxp.Proveedor, Prov.Nombre, Prov.RFC,
Prov.ImportadorRegistro, dp.Pais, dp.Nacionalidad, c2.Mov, c2.Proveedor, cxp.Empresa, cxp.Importe, cxp.Impuestos, eg.DefImpuesto,
cxp.Importe, cxp.Impuestos, cxp.TipoCambio, Cxp.Concepto, c2.Mov, Concepto.Impuesto1Excento,DineroMov, DineroMovID, c2.MovID,c2.Empresa,
DIOTCfg.CalcularBaseImportacion, c2.TipoCambio,
p.DineroMov2, p.DineroMovID2, p.DineroFormaPago, p.DineroImporte, p.ContID, p.ContMov, p.ContMovID
END
ELSE IF @CalcularBaseImportacion = 0 AND @COMSIVAImportacionAnticipado = 0
INSERT INTO #Documentos(ID, Empresa, Pago, PagoID, Mov, MovID, Ejercicio, Periodo, FechaEmision, Proveedor, Nombre, RFC,
ImportadorRegistro, Pais, Nacionalidad, TipoDocumento, TipoTercero, Importe, BaseIVA,
Tasa, IVA, ConceptoClave, Concepto, EsImportacion, EsExcento, IEPS, ISAN, Retencion1, Retencion2, DineroMov, DineroMovID,
DineroMov2,	DineroMovID2, DineroFormaPago, DineroImporte, ContID, ContMov, ContMovID, TipoInsert)
SELECT Cxp.ID, Cxp.Empresa, p.Mov, p.MovID, Cxp.Mov, Cxp.MovID, Cxp.Ejercicio, Cxp.Periodo, Cxp.FechaEmision, Cxp.Proveedor, Prov.Nombre, Prov.RFC,
Prov.ImportadorRegistro, dp.Pais, dp.Nacionalidad, dbo.fnDIOTTipoDocumento('COMS', c.Mov), dbo.fnDIOTTipoTercero(Cxp.Proveedor), ctc.SubTotal*c.TipoCambio, ROUND((ISNULL(ctc.SubTotal,0.0) + CASE WHEN ISNULL(ver.Impuesto2BaseImpuesto1,0.0) = 1 THEN ISNULL(ctc.Impuesto2Total,0.0) ELSE 0.0 END)*c.TipoCambio, 2),
ISNULL(d.Impuesto1, 0), ISNULL(ctc.Impuesto1Total,0.0)*c.TipoCambio, Art.Articulo, Art.Descripcion1, dbo.fnDIOTEsImportacion('COMS', c.Mov), ISNULL(Art.Impuesto1Excento,0), ISNULL(ctc.Impuesto2Total,0.0)*c.TipoCambio, 0.0,  cgd.Retencion*cgd.TipoCambio, cgd.Retencion2*cgd.TipoCambio, DineroMov, DineroMovID,
p.DineroMov2, p.DineroMovID2, p.DineroFormaPago, p.DineroImporte, p.ContID, p.ContMov, p.ContMovID, 3
FROM #Pagos p
JOIN Cxp ON p.Empresa = Cxp.Empresa AND p.Aplica = Cxp.Mov AND p.AplicaID = Cxp.MovID
JOIN Compra c ON c.MovID = Cxp.OrigenID AND c.Mov = cxp.Origen AND Cxp.OrigenTipo = 'COMS' AND c.Empresa = cxp.Empresa
JOIN CompraD d ON c.ID = d.ID AND Cxp.Proveedor = ISNULL(NULLIF(RTRIM(d.ImportacionProveedor), ''), c.Proveedor) AND ISNULL(Cxp.Referencia, '') = ISNULL(NULLIF(RTRIM(d.ImportacionReferencia), ''), ISNULL(Cxp.Referencia, ''))
JOIN CompraTCalc ctc ON ctc.RenglonSub = d.RenglonSub AND ctc.Renglon = d.Renglon AND ctc.ID = d.ID
JOIN MovTipo ON c.Mov = MovTipo.Mov AND MovTipo.Modulo = 'COMS'
LEFT JOIN CompraGastoDiverso cgd ON cgd.Id = c.id
JOIN Art ON d.Articulo = Art.Articulo
JOIN Prov ON Cxp.Proveedor = Prov.Proveedor
LEFT OUTER JOIN Pais ON Prov.Pais = Pais.Pais
LEFT OUTER JOIN DIOTPais dp ON Pais.Pais = dp.Pais
LEFT JOIN DIOTArt ON Art.Articulo = DIOTArt.Articulo
JOIN Version ver ON 1 = 1
JOIN DIOTCfg ON DIOTCfg.Empresa = Cxp.Empresa
WHERE ISNULL(DIOTArt.Articulo, '') = Art.Articulo
AND MovTipo.Clave IN ('COMS.EI', 'COMS.GX')
EXEC xpDIOTObtenerDocumentoGAS @Estacion, @Empresa, @FechaD, @FechaA, @CalcularBaseImportacion, @COMSIVAImportacionAnticipado
IF NOT EXISTS(SELECT 1 FROM #Documentos WHERE TipoInsert = 4) OR ISNULL(@GASIncluirMovSinCxp,0) = 1
INSERT INTO #Documentos(ID, Empresa, Pago, PagoID, Mov, MovID, Ejercicio, Periodo, FechaEmision, Proveedor, Nombre, RFC,
ImportadorRegistro, Pais, Nacionalidad, TipoDocumento, TipoTercero, Importe, BaseIVA, Tasa, IVA,
ConceptoClave, Concepto, EsImportacion, EsExcento, IEPS, ISAN, Retencion1, Retencion2,
DineroMov, DineroMovID, PorcentajeDeducible,
DineroMov2,	DineroMovID2, DineroFormaPago, DineroImporte, ContID, ContMov, ContMovID, TipoInsert)
SELECT Cxp.ID, Cxp.Empresa, p.Mov, p.MovID, Cxp.Mov, Cxp.MovID, Cxp.Ejercicio, Cxp.Periodo, Cxp.FechaEmision, Cxp.Proveedor, Prov.Nombre, Prov.RFC,
Prov.ImportadorRegistro, dp.Pais, dp.Nacionalidad, dbo.fnDIOTTipoDocumento('GAS', c.Mov), dbo.fnDIOTTipoTercero(Cxp.Proveedor), d.Importe*c.TipoCambio, (ISNULL(d.Importe,0.0) + CASE WHEN ISNULL(ver.Impuesto2BaseImpuesto1,0.0) = 1 THEN ISNULL(d.Impuestos2,0.0) ELSE 0.0 END)*c.TipoCambio, CASE WHEN NULLIF(d.Impuestos,0.0) IS NULL THEN NULL ELSE d.Impuesto1 END,
ISNULL(d.Impuestos,0.0)*c.TipoCambio, d.Concepto, d.Concepto, dbo.fnDIOTEsImportacion('GAS', c.Mov), ISNULL(Concepto.Impuesto1Excento,0), ISNULL(d.Impuestos2,0.0)*c.TipoCambio, 0.0,  d.Retencion*c.TipoCambio, d.Retencion2*c.TipoCambio,
DineroMov, DineroMovID, d.PorcentajeDeducible,
p.DineroMov2, p.DineroMovID2, p.DineroFormaPago, p.DineroImporte, p.ContID, p.ContMov, p.ContMovID, 4
FROM #Pagos p
JOIN Cxp ON p.Empresa = Cxp.Empresa AND p.Aplica = Cxp.Mov AND p.AplicaID = Cxp.MovID
JOIN Gasto c ON c.MovID = Cxp.OrigenID AND c.Mov = cxp.Origen AND Cxp.OrigenTipo = 'GAS' AND c.Empresa = cxp.Empresa
JOIN GastoD d ON c.ID = d.ID
JOIN GastoT ctc ON ctc.RenglonSub = d.RenglonSub AND ctc.Renglon = d.Renglon AND ctc.ID = d.ID
JOIN Concepto ON d.Concepto = Concepto.Concepto AND Concepto.Modulo = 'GAS'
JOIN Prov ON Cxp.Proveedor = Prov.Proveedor
JOIN MovTipo mt1 ON mt1.Mov = c.Mov AND mt1.Modulo = 'GAS'
LEFT OUTER JOIN MovTipo mt ON mt.Mov = c.Origen AND mt.Modulo = c.OrigenTipo
LEFT OUTER JOIN Pais ON Prov.Pais = Pais.Pais
LEFT OUTER JOIN DIOTPais dp ON Pais.Pais = dp.Pais
JOIN DIOTConcepto ON Concepto.Modulo = 'GAS' AND DIOTConcepto.Concepto = Concepto.Concepto
JOIN Version ver ON 1 = 1
WHERE ISNULL(mt.Clave, '') NOT IN('COMS.EI','COMS.GX')
AND mt1.Clave NOT IN('GAS.CCH', 'GAS.GTC', 'GAS.C', 'GAS.CP')
AND d.Concepto NOT IN(SELECT Concepto FROM DIOTConceptoImportacion UNION ALL SELECT Concepto FROM DIOTConceptoIVAImportacion)
EXEC xpDIOTObtenerDocumentoGAS2 @Estacion, @Empresa, @FechaD, @FechaA, @CalcularBaseImportacion, @COMSIVAImportacionAnticipado
IF NOT EXISTS(SELECT 1 FROM #Documentos WHERE TipoInsert = 5)
INSERT INTO #Documentos(ID, Empresa, Pago, PagoID, Mov, MovID, Ejercicio, Periodo, FechaEmision, Proveedor, Nombre, RFC,
ImportadorRegistro, Pais, Nacionalidad, TipoDocumento, TipoTercero, Importe, BaseIVA, Tasa, IVA,
ConceptoClave, Concepto, EsImportacion, EsExcento, IEPS, ISAN, Retencion1, Retencion2, DineroMov, DineroMovID, PorcentajeDeducible,
DineroMov2,	DineroMovID2, DineroFormaPago, DineroImporte, ContID, ContMov, ContMovID, TipoInsert)
SELECT Cxp.ID, Cxp.Empresa, p.Mov, p.MovID, Cxp.Mov, Cxp.MovID, Cxp.Ejercicio, Cxp.Periodo, Cxp.FechaEmision, ISNULL(NULLIF(RTRIM(d.AcreedorRef), ''), c.Acreedor), Prov.Nombre, Prov.RFC,
Prov.ImportadorRegistro, dp.Pais, dp.Nacionalidad, dbo.fnDIOTTipoDocumento('GAS', c.Mov), dbo.fnDIOTTipoTercero(Cxp.Proveedor), d.Importe*c.TipoCambio, (ISNULL(d.Importe,0.0) + CASE WHEN ISNULL(ver.Impuesto2BaseImpuesto1,0.0) = 1 THEN ISNULL(d.Impuestos2,0.0) ELSE 0.0 END)*c.TipoCambio, CASE WHEN NULLIF(d.Impuestos,0.0) IS NULL THEN NULL ELSE d.Impuesto1 END, ISNULL(d.Impuestos,0.0)*c.TipoCambio,
d.Concepto, d.Concepto, dbo.fnDIOTEsImportacion('GAS', c.Mov), ISNULL(Concepto.Impuesto1Excento,0), ISNULL(d.Impuestos2,0.0)*c.TipoCambio, 0.0,  d.Retencion*c.TipoCambio, d.Retencion2*c.TipoCambio, DineroMov, DineroMovID, d.PorcentajeDeducible,
p.DineroMov2, p.DineroMovID2, p.DineroFormaPago, p.DineroImporte, p.ContID, p.ContMov, p.ContMovID, 5
FROM #Pagos p
JOIN Cxp ON p.Empresa = Cxp.Empresa AND p.Aplica = Cxp.Mov AND p.AplicaID = Cxp.MovID
JOIN Gasto c ON c.MovID = Cxp.OrigenID AND c.Mov = cxp.Origen AND Cxp.OrigenTipo = 'GAS' AND c.Empresa = cxp.Empresa
JOIN GastoD d ON c.ID = d.ID AND d.Concepto = Cxp.Concepto AND ISNULL(d.Referencia, ISNULL(Cxp.Referencia, '')) = ISNULL(Cxp.Referencia, '')
JOIN GastoT ctc ON ctc.RenglonSub = d.RenglonSub AND ctc.Renglon = d.Renglon AND ctc.ID = d.ID
JOIN Concepto ON d.Concepto = Concepto.Concepto AND Concepto.Modulo = 'GAS'
JOIN Prov ON Prov.Proveedor = ISNULL(NULLIF(RTRIM(d.AcreedorRef), ''), c.Acreedor)
JOIN MovTipo mt1 ON mt1.Mov = c.Mov AND mt1.Modulo = 'GAS'
LEFT OUTER JOIN MovTipo mt ON mt.Mov = c.Origen AND mt.Modulo = c.OrigenTipo
LEFT OUTER JOIN Pais ON Prov.Pais = Pais.Pais
LEFT OUTER JOIN DIOTPais dp ON Pais.Pais = dp.Pais
JOIN DIOTConcepto ON Concepto.Modulo = 'GAS' AND DIOTConcepto.Concepto = Concepto.Concepto
JOIN Version ver ON 1 = 1
WHERE ISNULL(mt.Clave, '') NOT IN('COMS.EI','COMS.GX')
AND mt1.Clave IN('GAS.CCH', 'GAS.GTC', 'GAS.C', 'GAS.CP')
AND d.Concepto NOT IN(SELECT Concepto FROM DIOTConceptoImportacion UNION ALL SELECT Concepto FROM DIOTConceptoIVAImportacion)
INSERT INTO #Documentos(ID, Empresa, Pago, PagoID, Mov, MovID, Ejercicio, Periodo, FechaEmision, Proveedor, Nombre, RFC,
ImportadorRegistro, Pais, Nacionalidad, TipoDocumento, TipoTercero, Importe, BaseIVA, Tasa,
IVA, ConceptoClave, Concepto, EsImportacion, EsExcento, IEPS, ISAN, Retencion1, Retencion2,
DineroMov, DineroMovID, PorcentajeDeducible,
DineroMov2,	DineroMovID2, DineroFormaPago, DineroImporte, ContID, ContMov, ContMovID)
SELECT Cxp.ID, Cxp.Empresa, p.Mov, p.MovID, Cxp.Mov, Cxp.MovID, Cxp.Ejercicio, Cxp.Periodo, Cxp.FechaEmision, Cxp.Proveedor, Prov.Nombre, Prov.RFC,
Prov.ImportadorRegistro, dp.Pais, dp.Nacionalidad, dbo.fnDIOTTipoDocumento('GAS', c.Mov), dbo.fnDIOTTipoTercero(Cxp.Proveedor), d.Importe*c.TipoCambio, (ISNULL(d.Importe,0.0) + CASE WHEN ISNULL(ver.Impuesto2BaseImpuesto1,0.0) = 1 THEN ISNULL(d.Impuestos2,0.0) ELSE 0.0 END)*c.TipoCambio, CASE WHEN NULLIF(d.Impuestos,0.0) IS NULL THEN NULL ELSE d.Impuesto1 END,
ISNULL(d.Impuestos,0.0)*c.TipoCambio, d.Concepto, d.Concepto, dbo.fnDIOTEsImportacion('GAS', c.Mov), ISNULL(Concepto.Impuesto1Excento,0), ISNULL(d.Impuestos2,0.0)*c.TipoCambio, 0.0,  d.Retencion*c.TipoCambio, d.Retencion2*c.TipoCambio,
DineroMov, DineroMovID, d.PorcentajeDeducible,
p.DineroMov2, p.DineroMovID2, p.DineroFormaPago, p.DineroImporte, p.ContID, p.ContMov, p.ContMovID
FROM #Pagos p
JOIN Cxp ON p.Empresa = Cxp.Empresa AND p.Aplica = Cxp.Mov AND p.AplicaID = Cxp.MovID
JOIN Gasto c ON c.MovID = Cxp.OrigenID AND c.Mov = cxp.Origen AND Cxp.OrigenTipo = 'GAS' AND c.Empresa = cxp.Empresa
JOIN GastoD d ON c.ID = d.ID
JOIN GastoT ctc ON ctc.RenglonSub = d.RenglonSub AND ctc.Renglon = d.Renglon AND ctc.ID = d.ID
LEFT OUTER JOIN Concepto ON d.Concepto = Concepto.Concepto AND Concepto.Modulo = 'COMSG'
JOIN Prov ON Cxp.Proveedor = Prov.Proveedor
LEFT OUTER JOIN MovTipo mt ON mt.Mov = c.Origen AND mt.Modulo = c.OrigenTipo
LEFT OUTER JOIN Pais ON Prov.Pais = Pais.Pais
LEFT OUTER JOIN DIOTPais dp ON Pais.Pais = dp.Pais
JOIN Version ver ON 1 = 1
WHERE (ISNULL(mt.Clave, '') IN ('COMS.EI','COMS.GX')
AND d.Concepto NOT IN(SELECT Concepto FROM DIOTConceptoImportacion UNION ALL SELECT Concepto FROM DIOTConceptoIVAImportacion))
INSERT INTO #Documentos(ID, Empresa, Pago, PagoID, Mov, MovID, Ejercicio, Periodo, FechaEmision, Proveedor, Nombre, RFC,
ImportadorRegistro, Pais, Nacionalidad, TipoDocumento, TipoTercero, Importe, BaseIVA, Tasa,
IVA, ConceptoClave, Concepto, EsImportacion, EsExcento, IEPS, ISAN, Retencion1, Retencion2,
DineroMov, DineroMovID,
DineroMov2,	DineroMovID2, DineroFormaPago, DineroImporte, ContID, ContMov, ContMovID)
SELECT Cxp.ID, Cxp.Empresa, p.Mov,  p.MovID, Cxp.Mov, Cxp.MovID, Cxp.Ejercicio, Cxp.Periodo, Cxp.FechaEmision, Cxp.Proveedor, Prov.Nombre, Prov.RFC,
Prov.ImportadorRegistro, dp.Pais, dp.Nacionalidad, dbo.fnDIOTTipoDocumento('CXP', Cxp.Mov), dbo.fnDIOTTipoTercero(Cxp.Proveedor), Cxp.Importe*Cxp.TipoCambio, (ISNULL(CONVERT(float,Cxp.Importe),0.0) + CASE WHEN ISNULL(ver.Impuesto2BaseImpuesto1,0.0) = 1 THEN ((CONVERT(float,Cxp.Importe)/NULLIF((1.0-ISNULL(CONVERT(float,Cxp.IEPSFiscal),0.0)),0.0))*ISNULL(CONVERT(float,Cxp.IEPSFiscal),0.0)) ELSE 0.0 END)*Cxp.TipoCambio, dbo.fnDIOTIVATasa(Cxp.Empresa,Cxp.Importe,Cxp.Impuestos),
dbo.fnDIOTIVA(Cxp.Importe, Cxp.Impuestos), Cxp.Concepto,  Cxp.Concepto, dbo.fnDIOTEsImportacion('CXP', Cxp.Mov), 0, (ISNULL(CONVERT(float,Cxp.Importe),0.0)/NULLIF((1.0-ISNULL(CONVERT(float,Cxp.IEPSFiscal),0.0)),0.0))*ISNULL(CONVERT(float,Cxp.IEPSFiscal),0.0)*Cxp.TipoCambio, 0.0,  0.0, Cxp.Retencion2*Cxp.TipoCambio,
DineroMov, DineroMovID,
p.DineroMov2, p.DineroMovID2, p.DineroFormaPago, p.DineroImporte, p.ContID, p.ContMov, p.ContMovID
FROM #Pagos p
JOIN Cxp ON p.Empresa = Cxp.Empresa AND p.Aplica = Cxp.Mov AND p.AplicaID = Cxp.MovID
JOIN Compra c ON c.MovID = Cxp.OrigenID AND c.Mov = cxp.Origen AND Cxp.OrigenTipo = 'COMS' AND c.Empresa = cxp.Empresa
JOIN MovTipo ON c.Mov = MovTipo.Mov AND MovTipo.Modulo = 'COMS'
JOIN Prov ON Cxp.Proveedor = Prov.Proveedor
LEFT OUTER JOIN Pais ON Prov.Pais = Pais.Pais
LEFT OUTER JOIN DIOTPais dp ON Pais.Pais = dp.Pais
JOIN Version ver ON 1 = 1
WHERE (ISNULL(MovTipo.Clave, '') IN ('COMS.EI','COMS.GX')
AND Cxp.Concepto NOT IN(SELECT Concepto FROM DIOTConceptoImportacion UNION ALL SELECT Concepto FROM DIOTConceptoIVAImportacion))
AND Cxp.Mov = @CxpGastoDiverso
INSERT INTO #Documentos(ID, Empresa, Pago, PagoID, Mov, MovID, Ejercicio, Periodo, FechaEmision, Proveedor, Nombre, RFC,
ImportadorRegistro, Pais, Nacionalidad, TipoDocumento, TipoTercero, Importe, BaseIVA,
Tasa, IVA, ConceptoClave, Concepto, EsImportacion, EsExcento, IEPS, ISAN, Retencion1, Retencion2,
DineroMov, DineroMovID,
DineroMov2, DineroMovID2, DineroFormaPago, DineroImporte, ContID, ContMov, ContMovID)
SELECT c.ID, c.Empresa, p.Mov, p.MovID, c.Mov, c.MovID, c.Ejercicio, c.Periodo, c.FechaEmision, c.Proveedor, Prov.Nombre,
Prov.RFC, Prov.ImportadorRegistro, dp.Pais, dp.Nacionalidad, dbo.fnDIOTTipoDocumento('COMS', c.Mov), dbo.fnDIOTTipoTercero(c.Proveedor), ctc.SubTotal*c.TipoCambio, ROUND((ISNULL(ctc.SubTotal,0.0) + CASE WHEN ISNULL(ver.Impuesto2BaseImpuesto1,0.0) = 1 THEN ISNULL(ctc.Impuesto2Total,0.0) ELSE 0.0 END)*c.TipoCambio, 2), ISNULL(d.Impuesto1, 0), ISNULL(ctc.Impuesto1Total,0.0)*c.TipoCambio,  Art.Articulo, Art.Descripcion1, dbo.fnDIOTEsImportacion('COMS', c3.Mov), ISNULL(Art.Impuesto1Excento,0), ISNULL(ctc.Impuesto2Total,0.0)*c.TipoCambio, 0.0,  ctc.Retencion1Total*c.TipoCambio, ctc.Retencion2Total*c.TipoCambio,
DineroMov, DineroMovID,
p.DineroMov2, p.DineroMovID2, p.DineroFormaPago, p.DineroImporte, p.ContID, p.ContMov, p.ContMovID
FROM #Pagos p
JOIN Cxp c ON p.Empresa = c.Empresa AND p.Aplica = c.Mov AND p.AplicaID = c.MovID
JOIN Cxp c2 ON c2.Empresa = c.Empresa AND c2.Mov = c.Origen AND c2.MovID = c.OrigenID
JOIN Compra c3 ON c3.Empresa = c2.Empresa AND c3.Mov = c2.Origen AND c3.MovID = c2.OrigenID
JOIN CompraD d ON d.ID = c3.ID
JOIN CompraTCalc ctc ON ctc.RenglonSub = d.RenglonSub AND ctc.Renglon = d.Renglon AND ctc.ID = d.ID
JOIN MovTipo mt ON c.Mov = mt.Mov
JOIN Art ON d.Articulo = Art.Articulo
JOIN Prov ON c.Proveedor = Prov.Proveedor
LEFT JOIN Pais ON Prov.Pais = Pais.Pais
LEFT JOIN DIOTPais dp ON Pais.Pais = dp.Pais
LEFT JOIN DIOTArt ON Art.Articulo = DIOTArt.Articulo
JOIN Version ver ON 1 = 1
WHERE ISNULL(DIOTArt.Articulo, '') = Art.Articulo
AND mt.Clave IN ('CXP.FAC','CXP.D')
AND c2.Mov <> @CxpGastoDiverso
INSERT INTO #Documentos(ID, Empresa, Pago, PagoID, Mov, MovID, Ejercicio, Periodo, FechaEmision, Proveedor, Nombre, RFC,
ImportadorRegistro, Pais, Nacionalidad, TipoDocumento, TipoTercero, Importe, BaseIVA,
Tasa, IVA, ConceptoClave, Concepto, EsImportacion, EsExcento, IEPS, ISAN, Retencion1, Retencion2,
DineroMov, DineroMovID,
DineroMov2, DineroMovID2, DineroFormaPago, DineroImporte, ContID, ContMov, ContMovID)
SELECT c.ID, c.Empresa, p.Mov, p.MovID, c.Mov, c.MovID, c.Ejercicio, c.Periodo, c.FechaEmision, c.Proveedor, Prov.Nombre,
Prov.RFC, Prov.ImportadorRegistro, dp.Pais, dp.Nacionalidad, dbo.fnDIOTTipoDocumento('GAS', c.Mov), dbo.fnDIOTTipoTercero(c.Proveedor), d.Importe*c.TipoCambio, ROUND((ISNULL(d.Importe,0.0) + CASE WHEN ISNULL(ver.Impuesto2BaseImpuesto1,0.0) = 1 THEN ISNULL(d.Impuestos2,0.0) ELSE 0.0 END)*c.TipoCambio, 2), CASE WHEN NULLIF(d.Impuestos,0.0) IS NULL THEN NULL ELSE ISNULL(d.Impuesto1, 0) END, ISNULL(d.Impuestos,0.0)*c.TipoCambio, d.Concepto, d.Concepto, dbo.fnDIOTEsImportacion('GAS', c3.Mov), ISNULL(Concepto.Impuesto1Excento,0), ISNULL(d.Impuestos2,0.0)*c.TipoCambio, 0.0, d.Retencion*c.TipoCambio, d.Retencion2*c.TipoCambio,
DineroMov, DineroMovID,
p.DineroMov2, p.DineroMovID2, p.DineroFormaPago, p.DineroImporte, p.ContID, p.ContMov, p.ContMovID
FROM #Pagos p
JOIN Cxp c ON p.Empresa = c.Empresa AND p.Aplica = c.Mov AND p.AplicaID = c.MovID
JOIN Cxp c2 ON c2.Empresa = c.Empresa AND c2.Mov = c.Origen AND c2.MovID = c.OrigenID
JOIN Gasto c3 ON c3.Empresa = c2.Empresa AND c3.Mov = c2.Origen AND c3.MovID = c2.OrigenID
JOIN GastoD d ON d.ID = c3.ID
JOIN GastoT ctc ON ctc.RenglonSub = d.RenglonSub AND ctc.Renglon = d.Renglon AND ctc.ID = d.ID
JOIN Concepto ON d.Concepto = Concepto.Concepto AND Concepto.Modulo = 'GAS'
JOIN MovTipo mt ON c.Mov = mt.Mov
JOIN Prov ON c.Proveedor = Prov.Proveedor
LEFT JOIN Pais ON Prov.Pais = Pais.Pais
LEFT JOIN DIOTPais dp ON Pais.Pais = dp.Pais
JOIN DIOTConcepto ON Concepto.Modulo = 'GAS' AND DIOTConcepto.Concepto = Concepto.Concepto
JOIN Version ver ON 1 = 1
WHERE d.Concepto NOT IN(SELECT Concepto FROM DIOTConceptoImportacion UNION ALL SELECT Concepto FROM DIOTConceptoIVAImportacion)
AND mt.Clave IN ('CXP.FAC','CXP.D')
INSERT INTO #Documentos(ID, Empresa, Pago, PagoID, Mov, MovID, Ejercicio, Periodo, FechaEmision, Proveedor, Nombre, RFC,
ImportadorRegistro, Pais, Nacionalidad, TipoDocumento, TipoTercero, Importe, BaseIVA, Tasa,
IVA, ConceptoClave, Concepto,EsImportacion, EsExcento, IEPS, ISAN, Retencion1, Retencion2,
DineroMov, DineroMovID,
DineroMov2, DineroMovID2, DineroFormaPago, DineroImporte, ContID, ContMov, ContMovID)
SELECT Cxp.ID, Cxp.Empresa, p.Mov, p.MovID, Cxp.Mov, Cxp.MovID, Cxp.Ejercicio, Cxp.Periodo, Cxp.FechaEmision, Cxp.Proveedor, Prov.Nombre, Prov.RFC,
Prov.ImportadorRegistro, dp.Pais, dp.Nacionalidad, dbo.fnDIOTTipoDocumento('CXP', Cxp.Mov), dbo.fnDIOTTipoTercero(Cxp.Proveedor), Cxp.Importe*Cxp.TipoCambio, (ISNULL(CONVERT(float,Cxp.Importe),0.0) + CASE WHEN ISNULL(ver.Impuesto2BaseImpuesto1,0.0) = 1 THEN ((CONVERT(float,Cxp.Importe)/NULLIF((1.0-ISNULL(CONVERT(float,Cxp.IEPSFiscal),0.0)),0.0))*ISNULL(CONVERT(float,Cxp.IEPSFiscal),0.0)) ELSE 0.0 END)*Cxp.TipoCambio, dbo.fnDIOTIVATasa(Cxp.Empresa, Cxp.Importe,Cxp.Impuestos), dbo.fnDIOTIVA(Cxp.Importe, Cxp.Impuestos), Cxp.Concepto,  Cxp.Concepto, dbo.fnDIOTEsImportacion('CXP', Cxp.Mov), 0,         (ISNULL(CONVERT(float,Cxp.Importe),0.0)/NULLIF((1.0-ISNULL(CONVERT(float,Cxp.IEPSFiscal),0.0)),0.0))*ISNULL(CONVERT(float,Cxp.IEPSFiscal),0.0)*Cxp.TipoCambio, 0.0,  0.0,Cxp.Retencion*Cxp.TipoCambio,
DineroMov, DineroMovID,
p.DineroMov2, p.DineroMovID2, p.DineroFormaPago, p.DineroImporte, p.ContID, p.ContMov, p.ContMovID
FROM #Pagos p
JOIN Cxp ON p.Empresa = Cxp.Empresa AND p.Aplica = Cxp.Mov AND p.AplicaID = Cxp.MovID AND ISNULL(OrigenTipo, '') IN('', 'CXP')
JOIN Prov ON Cxp.Proveedor = Prov.Proveedor
JOIN MovTipo mt ON mt.Mov = Cxp.Mov AND mt.Modulo = 'CXP'
LEFT JOIN Pais ON Prov.Pais = Pais.Pais
LEFT JOIN DIOTPais dp ON Pais.Pais = dp.Pais
JOIN Version ver ON 1 = 1
WHERE mt.Clave IN ('CXP.NC')
INSERT INTO #Documentos(ID, Empresa, Pago, PagoID, Mov, MovID, Ejercicio, Periodo, FechaEmision, Proveedor, Nombre, RFC,
ImportadorRegistro, Pais, Nacionalidad, TipoDocumento, TipoTercero, Importe, BaseIVA, Tasa,
IVA, ConceptoClave, Concepto,EsImportacion, EsExcento, IEPS, ISAN, Retencion1, Retencion2,
DineroMov, DineroMovID,
DineroMov2, DineroMovID2, DineroFormaPago, DineroImporte, ContID, ContMov, ContMovID)
SELECT Cxp.ID, Cxp.Empresa, p.Mov, p.MovID, Cxp.Mov, Cxp.MovID, Cxp.Ejercicio, Cxp.Periodo, Cxp.FechaEmision, Cxp.Proveedor, Prov.Nombre, Prov.RFC,
Prov.ImportadorRegistro, dp.Pais, dp.Nacionalidad, dbo.fnDIOTTipoDocumento('CXP', Cxp.Mov), dbo.fnDIOTTipoTercero(Cxp.Proveedor), Cxp.Importe*Cxp.TipoCambio, (ISNULL(CONVERT(float,Cxp.Importe),0.0) + CASE WHEN ISNULL(ver.Impuesto2BaseImpuesto1,0.0) = 1 THEN ((CONVERT(float,Cxp.Importe)/NULLIF((1.0-ISNULL(CONVERT(float,Cxp.IEPSFiscal),0.0)),0.0))*ISNULL(CONVERT(float,Cxp.IEPSFiscal),0.0)) ELSE 0.0 END)*Cxp.TipoCambio, dbo.fnDIOTIVATasa(Cxp.Empresa, Cxp.Importe,Cxp.Impuestos), dbo.fnDIOTIVA(Cxp.Importe, Cxp.Impuestos)*Cxp.TipoCambio, Cxp.Concepto,  Cxp.Concepto, dbo.fnDIOTEsImportacion('CXP', Cxp.Mov), 0,         (ISNULL(CONVERT(float,Cxp.Importe),0.0)/NULLIF((1.0-ISNULL(CONVERT(float,Cxp.IEPSFiscal),0.0)),0.0))*ISNULL(CONVERT(float,Cxp.IEPSFiscal),0.0)*Cxp.TipoCambio, 0.0,  0.0,Cxp.Retencion*Cxp.TipoCambio,
DineroMov, DineroMovID,
p.DineroMov2, p.DineroMovID2, p.DineroFormaPago, p.DineroImporte, p.ContID, p.ContMov, p.ContMovID
FROM #Pagos p
JOIN Cxp ON p.Empresa = Cxp.Empresa AND p.Aplica = Cxp.Mov AND p.AplicaID = Cxp.MovID AND ISNULL(OrigenTipo, '') IN('', 'CXP')
JOIN Prov ON Cxp.Proveedor = Prov.Proveedor
JOIN MovTipo mt ON mt.Mov = Cxp.Mov AND mt.Modulo = 'CXP'
LEFT JOIN Pais ON Prov.Pais = Pais.Pais
LEFT JOIN DIOTPais dp ON Pais.Pais = dp.Pais
JOIN Version ver ON 1 = 1
WHERE mt.Clave NOT IN ('CXP.FAC','CXP.D','CXP.NC')
AND Cxp.Estatus IN('PENDIENTE', 'CONCLUIDO')
RETURN
END

