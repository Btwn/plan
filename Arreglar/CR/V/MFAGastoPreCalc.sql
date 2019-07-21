SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER VIEW MFAGastoPreCalc AS
SELECT
ID                     = g.ID,
concepto_clave         = gd.Concepto,
concepto_es_importacion= ISNULL(co.EsImportacion, 0),
origen_tipo            = 'auto',
origen_modulo          = 'GAS',
origen_id              = RTRIM(LTRIM(CONVERT(varchar,g.ID))),
empresa                = g.Empresa,
emisor                 = 'terceros',
tipo_documento         = CASE
WHEN mt.Clave IN ('GAS.A','GAS.ASC','GAS.G','GAS.GTC','GAS.GP','GAS.C','GAS.CCH','GAS.CP','GAS.CB') THEN 'factura'
WHEN mt.Clave IN ('GAS.DA','GAS.DG','GAS.DC','GAS.DGP','GAS.OI','GAS.AB') THEN 'nota_credito'
ELSE mtmda.DocumentoTipo
END,
subtipo_documento      = ISNULL(NULLIF(mmdtdeg.SubTipoDocumento,''),CASE
WHEN mt.Clave IN ('GAS.A','GAS.ASC','GAS.G','GAS.GTC','GAS.GP','GAS.C','GAS.CCH','GAS.CP','GAS.CB') THEN
(CASE WHEN ISNULL(fr.Extranjero,0) = 0 THEN 'adquisicion' ELSE 'importacion' END)
WHEN mt.Clave IN ('GAS.DA','GAS.DG','GAS.DC','GAS.DGP','GAS.OI','GAS.AB') THEN
(CASE WHEN ISNULL(fr.Extranjero,0) = 0 THEN 'adquisicion' ELSE 'importacion' END)
ELSE ''
END),
folio                  = RTRIM(ISNULL(cxp.Mov,'')) + ' ' + RTRIM(ISNULL(cxp.MovID,'')),
ejercicio              = g.Ejercicio,
periodo                = g.Periodo,
dia                    = DAY(g.FechaEmision),
fecha					 = g.FechaEmision,
entidad_clave          = p.Proveedor,
entidad_nombre         = p.Nombre,
entidad_rfc            = p.RFC,
entidad_id_fiscal      = CASE
WHEN ISNULL(fr.Extranjero,0) = 0 THEN p.RFC
WHEN ISNULL(fr.Extranjero,0) = 1 THEN p.ImportadorRegistro
END,
entidad_tipo_tercero   = CASE
WHEN ISNULL(fr.Extranjero,0) = 0 THEN 'nacional'
WHEN ISNULL(fr.Extranjero,0) = 1 THEN 'extranjero'
END,
entidad_tipo_operacion = CASE
WHEN co.TipoOperacion IN ('Renta') THEN 'arrendamiento_inmuebles'
WHEN co.TipoOperacion IN ('Honorarios', 'Importacion Servicios') THEN 'prestacion_servicios'
WHEN co.TipoOperacion NOT IN ('Honorarios', 'Importacion Servicios', 'Renta') THEN 'otros'
END,
entidad_pais           = mp.Pais,
entidad_nacionalidad   = mp.Nacionalidad,
agente_clave           = p.Agente,
agente_nombre          = ag.Nombre,
concepto               = gd.Concepto,
acumulable_deducible   = CASE WHEN ISNULL(co.MFAEsDeducible,0) = 1 THEN 'Si' ELSE 'No' END,
importe                = gd.Importe*g.TipoCambio,
retencion_isr          = gd.Retencion*g.TipoCambio,
retencion_iva          = gd.Retencion2*g.TipoCambio,
base_iva               = (ISNULL(gd.Importe,0.0) + CASE WHEN ISNULL(ver.Impuesto2BaseImpuesto1,0.0) = 1 THEN ISNULL(gd.Impuestos2,0.0) ELSE 0.0 END)*g.TipoCambio,
iva_excento            = ISNULL(co.Impuesto1Excento,0)*g.TipoCambio,
iva_tasa               = CASE
WHEN NULLIF(gd.Impuestos,0.0) IS NULL THEN NULL
ELSE
CASE
WHEN NULLIF(gd.Impuesto1, 0) IS NULL THEN dbo.fnMFAIVATasa(g.Empresa, gd.Importe,gd.Impuestos)
ELSE gd.Impuesto1
END
END,
iva                    = ISNULL(gd.Impuestos,0.0)*g.TipoCambio,
base_ieps              = gd.Importe*g.TipoCambio,
ieps_tasa              = CASE WHEN NULLIF(gd.Impuestos2,0.0) IS NULL THEN NULL ELSE  gd.Impuesto2 END,
ieps                   = ISNULL(gd.Impuestos2,0.0)*g.TipoCambio,
base_isan              = 0.0,
isan                   = 0.0,
ieps_num_reporte         = mcg.IEPSNumReporte,
ieps_categoria_concepto  = mcg.IEPSCategoriaConcepto,
ieps_exento              = mcg.IEPSExento,
ieps_envase_reutilizable = mcg.IEPSEnvaseReutilizable,
ieps_retencion           = NULL,
ieps_cantidad            = 1,
ieps_unidad              = CONVERT(varchar(50),NULL),
ieps_cantidad2           = CONVERT(float,NULL),
ieps_unidad2             = CONVERT(varchar(50),NULL),
dinero				   = cxp.Dinero,
dinero_id				   = cxp.DineroID,
concepto_aplica_ietu     = ISNULL(NULLIF(mtmce.AplicaIetu,''), 'Si'),
concepto_aplica_ieps     = ISNULL(NULLIF(mtmce.AplicaIeps,''), 'Si'),
concepto_aplica_iva      = ISNULL(NULLIF(mtmce.AplicaIVA,''), 'Si'),
EsActivoFijo			   = 0,
TipoActivo			   = NULL,
TipoActividad			   = MFATipoActividad.Tipo,
PorcentajeDeducible	   = dbo.fnMFAGASImporte(ISNULL(emfa.GASPorcentajeDeducible, 0), gd.PorcentajeDeducible)
FROM Cxp cxp
JOIN Gasto g ON g.MovID = cxp.OrigenID AND g.Mov = cxp.Origen AND cxp.OrigenTipo = 'GAS' AND g.Empresa = cxp.Empresa
JOIN MovTipo mt ON mt.Mov = g.Mov AND mt.Modulo = 'GAS'
JOIN GastoD gd ON gd.ID = g.ID
JOIN Prov p ON p.Proveedor = ISNULL(NULLIF(gd.AcreedorRef,''),g.Acreedor)
LEFT OUTER JOIN FiscalRegimen fr ON fr.FiscalRegimen = p.FiscalRegimen
LEFT OUTER JOIN Pais pa ON pa.Clave = p.Pais
LEFT OUTER JOIN MFAPais mp ON mp.Pais = pa.Pais
LEFT OUTER JOIN Agente ag ON ag.Agente = p.Agente
JOIN Concepto co ON co.Concepto = gd.Concepto AND co.Modulo = 'GAS'
LEFT OUTER JOIN MovTipoMFAConceptoExcepcion mtmce ON co.Concepto = mtmce.Concepto
JOIN EmpresaGral eg ON eg.Empresa = g.Empresa
LEFT OUTER JOIN EmpresaMFA emfa ON eg.Empresa = emfa.Empresa
JOIN Version ver ON 1 = 1
LEFT OUTER JOIN MFAMovExcepcion mme ON mme.Modulo = 'GAS' AND mme.ModuloID = g.ID
LEFT OUTER JOIN MovTipoMFADocExcepcion mtmde ON mtmde.Modulo = 'GAS' AND mtmde.Mov = g.Mov
LEFT OUTER JOIN MovTipoMFADocAdicion mtmda ON mtmda.Modulo = 'GAS' AND mtmda.Mov = g.Mov
LEFT OUTER JOIN MFAMovSubTipoDocumentoExcepcionGas mmdtdeg ON ISNULL(NULLIF(mmdtdeg.ConceptoGas,''),co.Concepto) = co.Concepto AND mmdtdeg.Mov = g.Mov AND mmdtdeg.Modulo = 'GAS'
LEFT OUTER JOIN MFAConceptoGas mcg ON mcg.ConceptoGas = co.Concepto
LEFT OUTER JOIN MFATipoActividad ON MFATipoActividad.Modulo = 'GAS' AND MFATipoActividad.Mov = g.Mov
WHERE g.Estatus IN ('CONCLUIDO','PENDIENTE')
AND cxp.Estatus IN ('CONCLUIDO','PENDIENTE')
AND (mt.Clave IN ('GAS.A','GAS.DA', 'GAS.ASC','GAS.G','GAS.GTC','GAS.GP','GAS.C','GAS.CCH','GAS.CP','GAS.DG','GAS.DC','GAS.DGP', 'GAS.OI', 'GAS.CB', 'GAS.AB') OR mtmda.Modulo IS NOT NULL)
AND mt.Mov NOT IN (SELECT Mov FROM MovTipoMFADocExcepcion WHERE Modulo = 'GAS')
AND ISNULL(co.MFAEsDeducible,0) = 1
AND mme.ModuloID IS NULL
AND mtmde.Mov IS NULL

