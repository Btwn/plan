SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER VIEW MFACompraPreCalc AS
SELECT
id                     = c.ID,
concepto_clave         = cd.Articulo,
origen_tipo            = 'auto',
origen_modulo          = 'COMS',
origen_id              = RTRIM(LTRIM(CONVERT(varchar,c.ID))),
empresa                = c.Empresa,
emisor                 = 'terceros',
tipo_documento         = CASE
WHEN mt.Clave IN ('COMS.F','COMS.FL','COMS.EG', 'COMS.EI','COMS.CA','COMS.GX') THEN 'factura'
WHEN mt.Clave IN ('COMS.B') THEN 'nota_credito'
WHEN mt.Clave IN ('COMS.D') THEN 'devolucion'
ELSE mtmda.DocumentoTipo
END,
subtipo_documento      = ISNULL(NULLIF(mmdtdea.SubTipoDocumento,''),CASE
WHEN mt.Clave IN ('COMS.F','COMS.FL','COMS.EG', 'COMS.EI','COMS.CA','COMS.GX') THEN
(CASE WHEN ISNULL(fr.Extranjero,0) = 0 THEN 'adquisicion' ELSE 'importacion' END)
WHEN mt.Clave IN ('COMS.B') THEN
(CASE WHEN ISNULL(fr.Extranjero,0) = 0 THEN 'adquisicion' ELSE 'importacion' END)
WHEN mt.Clave IN ('COMS.D') THEN
(CASE WHEN ISNULL(fr.Extranjero,0) = 0 THEN 'adquisicion' ELSE 'importacion' END)
ELSE ''
END),
folio                  = RTRIM(ISNULL(cxp.Mov,'')) + ' ' + RTRIM(ISNULL(cxp.MovID,'')),
ejercicio              = c.Ejercicio,
periodo                = c.Periodo,
dia                    = DAY(c.FechaEmision),
fecha					 = c.FechaEmision,
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
entidad_tipo_operacion = p.MFATipoOperacion,
entidad_pais           = mp.Pais,
entidad_nacionalidad   = mp.Nacionalidad,
agente_clave           = c.Agente,
agente_nombre          = ag.Nombre,
concepto               = a.Descripcion1,
acumulable_deducible   = 'Si',
importe                = ctc.SubTotal*c.TipoCambio,
retencion_isr          = ctc.Retencion2Total*c.TipoCambio, 
retencion_iva          = ctc.Retencion1Total*c.TipoCambio,
base_iva               = (ISNULL(ctc.SubTotal,0.0) + CASE WHEN ISNULL(ver.Impuesto2BaseImpuesto1,0.0) = 1 THEN ISNULL(ctc.Impuesto2Total,0.0) ELSE 0.0 END)*c.TipoCambio,
iva_excento            = ISNULL(a.Impuesto1Excento,0),
iva_tasa               = cd.Impuesto1,
iva                    = ISNULL(ctc.Impuesto1Total,0.0)*c.TipoCambio,
base_ieps              = ctc.Subtotal*c.TipoCambio,
ieps_tasa              = CASE ma.Impuesto WHEN 'Impuesto 2' THEN ISNULL(cd.Impuesto2, 0) ELSE 0 END,
ieps                   = CASE ma.Impuesto WHEN 'Impuesto 2' THEN ISNULL(ctc.Impuesto2Total, 0)*c.TipoCambio ELSE ISNULL(ctc.Impuesto3Total, 0)*c.TipoCambio END,
base_isan              = 0.0,
isan                   = 0.0,
ieps_num_reporte         = ma.IEPSNumReporte,
ieps_categoria_concepto  = ma.IEPSCategoriaConcepto,
ieps_exento              = ma.IEPSExento,
ieps_envase_reutilizable = ma.IEPSEnvaseReutilizable,
ieps_retencion           = NULL,
ieps_cantidad            = cd.Cantidad,
ieps_unidad              = cd.Unidad,
ieps_cantidad2           = dbo.fnMFAArtUnidadConvertir(cd.Cantidad,
CASE
WHEN
ISNULL(ec.Multiunidades,0) = 1
THEN (CASE WHEN ec.NivelFactorMultiunidad = 'UNIDAD' THEN u.Factor ELSE au.Factor END)
ELSE 0.0
END,
CASE
WHEN
ISNULL(ec.Multiunidades,0) = 1
THEN (CASE WHEN ec.NivelFactorMultiunidad = 'UNIDAD' THEN u2.Factor ELSE au2.Factor END)
ELSE 0.0
END),
ieps_unidad2             = ISNULL(ma.UnidadBaseIEPS, cd.Unidad),
dinero				   = cxp.Dinero,
dinero_id				   = cxp.DineroID,
concepto_aplica_ietu     = ISNULL(NULLIF(mtmce.AplicaIetu,''), 'Si'),
concepto_aplica_ieps     = ISNULL(NULLIF(mtmce.AplicaIeps,''), 'Si'),
concepto_aplica_iva      = ISNULL(NULLIF(mtmce.AplicaIVA,''), 'Si'),
EsActivoFijo			   = CASE MFAArtAF.Articulo WHEN NULL THEN 0 ELSE 1 END,
TipoActivo			   = CASE MFAArtAF.Articulo WHEN NULL THEN NULL ELSE MFAActivoFCat.Tipo END,
TipoActividad			   = MFATipoActividad.Tipo,
0 'BaseIVAImportacion'
FROM Cxp cxp
JOIN Compra c ON c.MovID = cxp.OrigenID AND c.Mov = cxp.Origen AND cxp.OrigenTipo = 'COMS' AND c.Empresa = cxp.Empresa
JOIN MovTipo mt ON mt.Mov = c.Mov AND mt.Modulo = 'COMS'
JOIN Prov p ON p.Proveedor = c.Proveedor
LEFT OUTER JOIN FiscalRegimen fr ON fr.FiscalRegimen = p.FiscalRegimen
LEFT OUTER JOIN Pais pa ON pa.Clave = p.Pais
LEFT OUTER JOIN MFAPais mp ON mp.Pais = pa.Pais
LEFT OUTER JOIN Agente ag ON ag.Agente = c.Agente
JOIN CompraD cd ON cd.ID = c.ID
JOIN MFACompraTCalc ctc ON ctc.RenglonSub = cd.RenglonSub AND ctc.Renglon = cd.Renglon AND ctc.ID = cd.ID
JOIN Art a ON a.Articulo = cd.Articulo
LEFT OUTER JOIN MovTipoMFAConceptoExcepcion mtmce ON a.Articulo = mtmce.Concepto
JOIN EmpresaGral eg ON eg.Empresa = c.Empresa
JOIN EmpresaMFA em ON em.Empresa = c.Empresa
JOIN EmpresaCfg2 ec ON ec.Empresa = em.Empresa
JOIN Version ver ON 1 = 1
LEFT OUTER JOIN MFAMovExcepcion mme ON mme.Modulo = 'COMS' AND mme.ModuloID = c.ID
LEFT OUTER JOIN MovTipoMFADocExcepcion mtmde ON mtmde.Modulo = 'COMS' AND mtmde.Mov = c.Mov
LEFT OUTER JOIN MovTipoMFADocAdicion mtmda ON mtmda.Modulo = 'COMS' AND mtmda.Mov = c.Mov
LEFT OUTER JOIN MFAMovSubTipoDocumentoExcepcionArt mmdtdea ON  ISNULL(NULLIF(mmdtdea.Articulo,''),a.Articulo) = a.Articulo AND mmdtdea.Mov = c.Mov AND mmdtdea.Modulo = 'COMS'
LEFT OUTER JOIN MFAArt ma ON ma.Articulo = a.Articulo
LEFT OUTER JOIN Unidad u ON u.Unidad = cd.Unidad
LEFT OUTER JOIN Unidad u2 ON u2.Unidad = ma.UnidadBaseIEPS
LEFT OUTER JOIN ArtUnidad au ON au.Articulo = a.Articulo AND au.Unidad = cd.Unidad
LEFT OUTER JOIN ArtUnidad au2 ON au2.Articulo = a.Articulo AND au2.Unidad = ma.UnidadBaseIEPS
LEFT OUTER JOIN MFAArtAF ON a.Articulo = MFAArtAF.Articulo
LEFT OUTER JOIN MFAActivoFCat ON a.CategoriaActivoFijo = MFAActivoFCat.Categoria
LEFT OUTER JOIN MFATipoActividad ON MFATipoActividad.Modulo = 'COMS' AND MFATipoActividad.Mov = c.Mov
WHERE c.Estatus IN ('CONCLUIDO','PENDIENTE')
AND cxp.Estatus IN ('CONCLUIDO','PENDIENTE')
AND (mt.Clave IN ('COMS.F','COMS.FL','COMS.EG', /*'COMS.EI',*/'COMS.D','COMS.B','COMS.CA', 'COMS.GX') OR (mtmda.Modulo IS NOT NULL))
AND mtmde.Mov IS NULL
AND cxp.OrigenTipo = 'COMS'
AND mme.ModuloID IS NULL

