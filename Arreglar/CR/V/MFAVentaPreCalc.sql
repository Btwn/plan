SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER VIEW MFAVentaPreCalc AS
SELECT
id                     = v.ID,
concepto_clave         = vd.Articulo,
origen_tipo            = 'auto',
origen_modulo          = 'VTAS',
origen_id              = RTRIM(LTRIM(CONVERT(varchar,v.ID))),
empresa                = v.Empresa,
emisor                 = 'empresa',
tipo_documento         = CASE
WHEN mt.Clave IN ('VTAS.F','VTAS.FX','VTAS.FAR','VTAS.FB','VTAS.FM','VTAS.N') THEN 'factura'
WHEN mt.Clave IN ('VTAS.B','VTAS.D','VTAS.DF') THEN 'nota_credito'
ELSE mtmda.DocumentoTipo
END,
subtipo_documento      = ISNULL(NULLIF(mmdtdea.SubTipoDocumento,''),CASE
WHEN mt.Clave IN ('VTAS.F','VTAS.FX','VTAS.FAR','VTAS.FB','VTAS.FM','VTAS.N') THEN
(CASE WHEN a.Articulo NOT IN ('Servicio') THEN 'enajenacion' ELSE 'prestacion_servicios' END)
WHEN mt.Clave IN ('VTAS.B','VTAS.D','VTAS.DF') THEN
(CASE WHEN a.Articulo NOT IN ('Servicio') THEN 'enajenacion' ELSE 'prestacion_servicios' END)
ELSE ''
END),
folio                  = RTRIM(ISNULL(cxc.Mov,'')) + ' ' + RTRIM(ISNULL(cxc.MovID,'')),
ejercicio              = v.Ejercicio, 
periodo                = v.Periodo,   
dia                    = DAY(v.FechaEmision),
fecha					 = v.FechaEmision,
entidad_clave          = v.Cliente,
entidad_nombre         = c.Nombre,
entidad_rfc            = c.RFC,
entidad_id_fiscal      = c.RFC,
entidad_tipo_tercero   = CASE
WHEN ISNULL(fr.Extranjero,0) = 0 THEN 'nacional'
WHEN ISNULL(fr.Extranjero,0) = 1 THEN 'extranjero'
END,
entidad_tipo_operacion = c.MFATipoOperacion,
entidad_pais           = p.Pais,
entidad_nacionalidad   = p.Nacionalidad,
agente_clave           = v.Agente,
agente_nombre          = ag.Nombre,
concepto               = a.Descripcion1,
acumulable_deducible   = 'Si',
importe                = (CONVERT(float, ROUND(dbo.fnSubTotal(CASE WHEN cfg.VentaPreciosImpuestoIncluido = 1 THEN (CASE WHEN cfg.VentaPrecioMoneda = 1 THEN CONVERT(float, ROUND(((vd.Cantidad-ISNULL(vd.CantidadCancelada, 0.0)-ISNULL(vd.CantidadObsequio, 0.0))*vd.Precio)-ISNULL(CASE WHEN vd.DescuentoTipo='$' then vd.DescuentoLinea else (vd.Cantidad-ISNULL(vd.CantidadCancelada, 0.0)-ISNULL(vd.CantidadObsequio, 0.0))*vd.Precio*(vd.DescuentoLinea/100.0) END, 0.0), ver.RedondeoMonetarios))*vd.PrecioTipoCambio/v.TipoCambio ELSE convert(float, ROUND(((vd.Cantidad-ISNULL(vd.CantidadCancelada, 0.0)-ISNULL(vd.CantidadObsequio, 0.0))*vd.Precio)-ISNULL(case when vd.DescuentoTipo='$' then vd.DescuentoLinea else (vd.Cantidad-ISNULL(vd.CantidadCancelada, 0.0)-ISNULL(vd.CantidadObsequio, 0.0))*vd.Precio*(vd.DescuentoLinea/100.0) end, 0.0), ver.RedondeoMonetarios))END-ISNULL(CASE WHEN ver.Impuesto3Info=1 THEN 0.0 ELSE vd.Impuesto3 END,0.0))/ (1.0 + (ISNULL(CASE WHEN ver.Impuesto2Info=1 THEN 0.0 ELSE vd.Impuesto2 END, 0.0)/100) + ((ISNULL(vd.Impuesto1,0.0)/100) * (1+(ISNULL(CASE WHEN ver.Impuesto2Info=1 OR ver.Impuesto2BaseImpuesto1=0 THEN 0.0 ELSE vd.Impuesto2 END, 0.0)/100)))) ELSE CASE WHEN cfg.VentaPrecioMoneda = 1 THEN convert(float, ROUND(((vd.Cantidad-ISNULL(vd.CantidadCancelada, 0.0)-ISNULL(vd.CantidadObsequio, 0.0))*vd.Precio)-ISNULL(case when vd.DescuentoTipo='$' then vd.DescuentoLinea else (vd.Cantidad-ISNULL(vd.CantidadCancelada, 0.0)-ISNULL(vd.CantidadObsequio, 0.0))*vd.Precio*(vd.DescuentoLinea/100.0) end, 0.0), ver.RedondeoMonetarios))*vd.PrecioTipoCambio/v.TipoCambio ELSE convert(float, ROUND(((vd.Cantidad-ISNULL(vd.CantidadCancelada, 0.0)-ISNULL(vd.CantidadObsequio, 0.0))*vd.Precio)-ISNULL(case when vd.DescuentoTipo='$' then vd.DescuentoLinea else (vd.Cantidad-ISNULL(vd.CantidadCancelada, 0.0)-ISNULL(vd.CantidadObsequio, 0.0))*vd.Precio*(vd.DescuentoLinea/100.0) end, 0.0), ver.RedondeoMonetarios)) END END, (ISNULL(v.DescuentoGlobal,0.0)), v.SobrePrecio), ver.RedondeoMonetarios)))*v.TipoCambio,
retencion_isr          = 0.0,
retencion_iva          = CONVERT(float, (ROUND((CASE WHEN ver.Retencion2BaseImpuesto1 = 0 THEN (CONVERT(float, ROUND(dbo.fnSubTotal(CASE WHEN cfg.VentaPreciosImpuestoIncluido = 1 THEN (CASE WHEN cfg.VentaPrecioMoneda = 1 THEN CONVERT(float, ROUND(((vd.Cantidad-ISNULL(vd.CantidadCancelada, 0.0)-ISNULL(vd.CantidadObsequio, 0.0))*vd.Precio)-ISNULL(CASE WHEN vd.DescuentoTipo='$' then vd.DescuentoLinea else (vd.Cantidad-ISNULL(vd.CantidadCancelada, 0.0)-ISNULL(vd.CantidadObsequio, 0.0))*vd.Precio*(vd.DescuentoLinea/100.0) END, 0.0), ver.RedondeoMonetarios))*vd.PrecioTipoCambio/v.TipoCambio ELSE convert(float, ROUND(((vd.Cantidad-ISNULL(vd.CantidadCancelada, 0.0)-ISNULL(vd.CantidadObsequio, 0.0))*vd.Precio)-ISNULL(case when vd.DescuentoTipo='$' then vd.DescuentoLinea else (vd.Cantidad-ISNULL(vd.CantidadCancelada, 0.0)-ISNULL(vd.CantidadObsequio, 0.0))*vd.Precio*(vd.DescuentoLinea/100.0) end, 0.0), ver.RedondeoMonetarios))END-ISNULL(CASE WHEN ver.Impuesto3Info=1 THEN 0.0 ELSE vd.Impuesto3 END,0.0))/ (1.0 + (ISNULL(CASE WHEN ver.Impuesto2Info=1 THEN 0.0 ELSE vd.Impuesto2 END, 0.0)/100) + ((ISNULL(vd.Impuesto1,0.0)/100) * (1+(ISNULL(CASE WHEN ver.Impuesto2Info=1 OR ver.Impuesto2BaseImpuesto1=0 THEN 0.0 ELSE vd.Impuesto2 END, 0.0)/100)))) ELSE CASE WHEN cfg.VentaPrecioMoneda = 1 THEN convert(float, ROUND(((vd.Cantidad-ISNULL(vd.CantidadCancelada, 0.0)-ISNULL(vd.CantidadObsequio, 0.0))*vd.Precio)-ISNULL(case when vd.DescuentoTipo='$' then vd.DescuentoLinea else (vd.Cantidad-ISNULL(vd.CantidadCancelada, 0.0)-ISNULL(vd.CantidadObsequio, 0.0))*vd.Precio*(vd.DescuentoLinea/100.0) end, 0.0), ver.RedondeoMonetarios))*vd.PrecioTipoCambio/v.TipoCambio ELSE convert(float, ROUND(((vd.Cantidad-ISNULL(vd.CantidadCancelada, 0.0)-ISNULL(vd.CantidadObsequio, 0.0))*vd.Precio)-ISNULL(case when vd.DescuentoTipo='$' then vd.DescuentoLinea else (vd.Cantidad-ISNULL(vd.CantidadCancelada, 0.0)-ISNULL(vd.CantidadObsequio, 0.0))*vd.Precio*(vd.DescuentoLinea/100.0) end, 0.0), ver.RedondeoMonetarios)) END END, (ISNULL(v.DescuentoGlobal,0.0)), v.SobrePrecio), ver.RedondeoMonetarios))) ELSE Convert(float, ROUND((CONVERT(float, ROUND(dbo.fnSubTotal(CASE WHEN cfg.VentaPreciosImpuestoIncluido = 1 THEN (CASE WHEN cfg.VentaPrecioMoneda = 1 THEN CONVERT(float, ROUND(((vd.Cantidad-ISNULL(vd.CantidadCancelada, 0.0)-ISNULL(vd.CantidadObsequio, 0.0))*vd.Precio)-ISNULL(CASE WHEN vd.DescuentoTipo='$' then vd.DescuentoLinea else (vd.Cantidad-ISNULL(vd.CantidadCancelada, 0.0)-ISNULL(vd.CantidadObsequio, 0.0))*vd.Precio*(vd.DescuentoLinea/100.0) END, 0.0), ver.RedondeoMonetarios))*vd.PrecioTipoCambio/v.TipoCambio ELSE convert(float, ROUND(((vd.Cantidad-ISNULL(vd.CantidadCancelada, 0.0)-ISNULL(vd.CantidadObsequio, 0.0))*vd.Precio)-ISNULL(case when vd.DescuentoTipo='$' then vd.DescuentoLinea else (vd.Cantidad-ISNULL(vd.CantidadCancelada, 0.0)-ISNULL(vd.CantidadObsequio, 0.0))*vd.Precio*(vd.DescuentoLinea/100.0) end, 0.0), ver.RedondeoMonetarios))END-ISNULL(CASE WHEN ver.Impuesto3Info=1 THEN 0.0 ELSE vd.Impuesto3 END,0.0))/ (1.0 + (ISNULL(CASE WHEN ver.Impuesto2Info=1 THEN 0.0 ELSE vd.Impuesto2 END, 0.0)/100) + ((ISNULL(vd.Impuesto1,0.0)/100) * (1+(ISNULL(CASE WHEN ver.Impuesto2Info=1 OR ver.Impuesto2BaseImpuesto1=0 THEN 0.0 ELSE vd.Impuesto2 END, 0.0)/100)))) ELSE CASE WHEN cfg.VentaPrecioMoneda = 1 THEN convert(float, ROUND(((vd.Cantidad-ISNULL(vd.CantidadCancelada, 0.0)-ISNULL(vd.CantidadObsequio, 0.0))*vd.Precio)-ISNULL(case when vd.DescuentoTipo='$' then vd.DescuentoLinea else (vd.Cantidad-ISNULL(vd.CantidadCancelada, 0.0)-ISNULL(vd.CantidadObsequio, 0.0))*vd.Precio*(vd.DescuentoLinea/100.0) end, 0.0), ver.RedondeoMonetarios))*vd.PrecioTipoCambio/v.TipoCambio ELSE convert(float, ROUND(((vd.Cantidad-ISNULL(vd.CantidadCancelada, 0.0)-ISNULL(vd.CantidadObsequio, 0.0))*vd.Precio)-ISNULL(case when vd.DescuentoTipo='$' then vd.DescuentoLinea else (vd.Cantidad-ISNULL(vd.CantidadCancelada, 0.0)-ISNULL(vd.CantidadObsequio, 0.0))*vd.Precio*(vd.DescuentoLinea/100.0) end, 0.0), ver.RedondeoMonetarios)) END END, (ISNULL(v.DescuentoGlobal,0.0)), v.SobrePrecio), ver.RedondeoMonetarios))) * (1.0+(ISNULL(ver.Impuesto2BaseImpuesto1, 0.0)/100.0))*(ISNULL(vd.Impuesto1, 0.0)/100.0), ver.RedondeoMonetarios)) END) *(ISNULL(vd.Retencion2, 0.0)/100.0), ver.RedondeoMonetarios) * v.TipoCambio)),
base_iva               = (ISNULL((CONVERT(float, ROUND(dbo.fnSubTotal(CASE WHEN cfg.VentaPreciosImpuestoIncluido = 1 THEN (CASE WHEN cfg.VentaPrecioMoneda = 1 THEN CONVERT(float, ROUND(((vd.Cantidad-ISNULL(vd.CantidadCancelada, 0.0)-ISNULL(vd.CantidadObsequio, 0.0))*vd.Precio)-ISNULL(CASE WHEN vd.DescuentoTipo='$' then vd.DescuentoLinea else (vd.Cantidad-ISNULL(vd.CantidadCancelada, 0.0)-ISNULL(vd.CantidadObsequio, 0.0))*vd.Precio*(vd.DescuentoLinea/100.0) END, 0.0), ver.RedondeoMonetarios))*vd.PrecioTipoCambio/v.TipoCambio ELSE convert(float, ROUND(((vd.Cantidad-ISNULL(vd.CantidadCancelada, 0.0)-ISNULL(vd.CantidadObsequio, 0.0))*vd.Precio)-ISNULL(case when vd.DescuentoTipo='$' then vd.DescuentoLinea else (vd.Cantidad-ISNULL(vd.CantidadCancelada, 0.0)-ISNULL(vd.CantidadObsequio, 0.0))*vd.Precio*(vd.DescuentoLinea/100.0) end, 0.0), ver.RedondeoMonetarios))END-ISNULL(CASE WHEN ver.Impuesto3Info=1 THEN 0.0 ELSE vd.Impuesto3 END,0.0))/ (1.0 + (ISNULL(CASE WHEN ver.Impuesto2Info=1 THEN 0.0 ELSE vd.Impuesto2 END, 0.0)/100) + ((ISNULL(vd.Impuesto1,0.0)/100) * (1+(ISNULL(CASE WHEN ver.Impuesto2Info=1 OR ver.Impuesto2BaseImpuesto1=0 THEN 0.0 ELSE vd.Impuesto2 END, 0.0)/100)))) ELSE CASE WHEN cfg.VentaPrecioMoneda = 1 THEN convert(float, ROUND(((vd.Cantidad-ISNULL(vd.CantidadCancelada, 0.0)-ISNULL(vd.CantidadObsequio, 0.0))*vd.Precio)-ISNULL(case when vd.DescuentoTipo='$' then vd.DescuentoLinea else (vd.Cantidad-ISNULL(vd.CantidadCancelada, 0.0)-ISNULL(vd.CantidadObsequio, 0.0))*vd.Precio*(vd.DescuentoLinea/100.0) end, 0.0), ver.RedondeoMonetarios))*vd.PrecioTipoCambio/v.TipoCambio ELSE convert(float, ROUND(((vd.Cantidad-ISNULL(vd.CantidadCancelada, 0.0)-ISNULL(vd.CantidadObsequio, 0.0))*vd.Precio)-ISNULL(case when vd.DescuentoTipo='$' then vd.DescuentoLinea else (vd.Cantidad-ISNULL(vd.CantidadCancelada, 0.0)-ISNULL(vd.CantidadObsequio, 0.0))*vd.Precio*(vd.DescuentoLinea/100.0) end, 0.0), ver.RedondeoMonetarios)) END END, (ISNULL(v.DescuentoGlobal,0.0)), v.SobrePrecio), ver.RedondeoMonetarios))),0.0) + CASE WHEN ISNULL(ver.Impuesto2BaseImpuesto1,0.0) = 1 THEN ISNULL((Convert(float, ROUND(dbo.fnSubTotal(CASE WHEN cfg.VentaPreciosImpuestoIncluido = 1 THEN (CASE WHEN cfg.VentaPrecioMoneda = 1 THEN convert(float, ROUND(((vd.Cantidad-ISNULL(vd.CantidadCancelada, 0.0)-ISNULL(vd.CantidadObsequio, 0.0))*vd.Precio)-ISNULL(case when vd.DescuentoTipo='$' then vd.DescuentoLinea else (vd.Cantidad-ISNULL(vd.CantidadCancelada, 0.0)-ISNULL(vd.CantidadObsequio, 0.0))*vd.Precio*(vd.DescuentoLinea/100.0) end, 0.0), ver.RedondeoMonetarios))*vd.PrecioTipoCambio/v.TipoCambio ELSE convert(float, ROUND(((vd.Cantidad-ISNULL(vd.CantidadCancelada, 0.0)-ISNULL(vd.CantidadObsequio, 0.0))*vd.Precio)-ISNULL(case when vd.DescuentoTipo='$' then vd.DescuentoLinea else (vd.Cantidad-ISNULL(vd.CantidadCancelada, 0.0)-ISNULL(vd.CantidadObsequio, 0.0))*vd.Precio*(vd.DescuentoLinea/100.0) end, 0.0), ver.RedondeoMonetarios)) END-ISNULL(CASE WHEN ver.Impuesto3Info=1 THEN 0.0 ELSE vd.Impuesto3 END,0.0))/ (1.0 + (ISNULL(CASE WHEN ver.Impuesto2Info=1 THEN 0.0 ELSE vd.Impuesto2 END, 0.0)/100) + ((ISNULL(vd.Impuesto1,0.0)/100) * (1+(ISNULL(CASE WHEN ver.Impuesto2Info=1 OR ver.Impuesto2BaseImpuesto1=0 THEN 0.0 ELSE vd.Impuesto2 END, 0.0)/100)))) ELSE CASE WHEN cfg.VentaPrecioMoneda = 1 THEN convert(float, ROUND(((vd.Cantidad-ISNULL(vd.CantidadCancelada, 0.0)-ISNULL(vd.CantidadObsequio, 0.0))*vd.Precio)-ISNULL(case when vd.DescuentoTipo='$' then vd.DescuentoLinea else (vd.Cantidad-ISNULL(vd.CantidadCancelada, 0.0)-ISNULL(vd.CantidadObsequio, 0.0))*vd.Precio*(vd.DescuentoLinea/100.0) end, 0.0), ver.RedondeoMonetarios))*vd.PrecioTipoCambio/v.TipoCambio ELSE convert(float, ROUND(((vd.Cantidad-ISNULL(vd.CantidadCancelada, 0.0)-ISNULL(vd.CantidadObsequio, 0.0))*vd.Precio)-ISNULL(case when vd.DescuentoTipo='$' then vd.DescuentoLinea else (vd.Cantidad-ISNULL(vd.CantidadCancelada, 0.0)-ISNULL(vd.CantidadObsequio, 0.0))*vd.Precio*(vd.DescuentoLinea/100.0) end, 0.0), ver.RedondeoMonetarios)) END END, (ISNULL(v.DescuentoGlobal,0.0)), v.SobrePrecio) * (ISNULL(CASE WHEN ver.Impuesto2Info=1 THEN 0.0 ELSE vd.Impuesto2 END, 0.0)/100.0), ver.RedondeoMonetarios))),0.0) ELSE 0.0 END)*v.TipoCambio,
iva_excento            = ISNULL(a.Impuesto1Excento,0),
iva_tasa               = vd.Impuesto1,
iva                    = ISNULL((Convert(float, ROUND(dbo.fnSubTotal(ISNULL(CASE WHEN cfg.VentaPreciosImpuestoIncluido = 1 THEN (CASE WHEN cfg.VentaPrecioMoneda = 1 THEN convert(float, ROUND(((vd.Cantidad-ISNULL(vd.CantidadCancelada, 0.0)-ISNULL(vd.CantidadObsequio, 0.0))*vd.Precio)-ISNULL(case when vd.DescuentoTipo='$' then vd.DescuentoLinea else (vd.Cantidad-ISNULL(vd.CantidadCancelada, 0.0)-ISNULL(vd.CantidadObsequio, 0.0))*vd.Precio*(vd.DescuentoLinea/100.0) end, 0.0), ver.RedondeoMonetarios))*vd.PrecioTipoCambio/v.TipoCambio ELSE convert(float, ROUND(((vd.Cantidad-ISNULL(vd.CantidadCancelada, 0.0)-ISNULL(vd.CantidadObsequio, 0.0))*vd.Precio)-ISNULL(case when vd.DescuentoTipo='$' then vd.DescuentoLinea else (vd.Cantidad-ISNULL(vd.CantidadCancelada, 0.0)-ISNULL(vd.CantidadObsequio, 0.0))*vd.Precio*(vd.DescuentoLinea/100.0) end, 0.0), ver.RedondeoMonetarios))END-ISNULL(CASE WHEN ver.Impuesto3Info=1 THEN 0.0 ELSE vd.Impuesto3 END,0.0))/ (1.0 + (ISNULL(CASE WHEN ver.Impuesto2Info=1 THEN 0.0 ELSE vd.Impuesto2 END, 0.0)/100) + ((ISNULL(vd.Impuesto1,0.0)/100) * (1+(ISNULL(CASE WHEN ver.Impuesto2Info=1 OR ver.Impuesto2BaseImpuesto1=0 THEN 0.0 ELSE vd.Impuesto2 END, 0.0)/100)))) ELSE CASE WHEN cfg.VentaPrecioMoneda = 1 THEN convert(float, ROUND(((vd.Cantidad-ISNULL(vd.CantidadCancelada, 0.0)-ISNULL(vd.CantidadObsequio, 0.0))*vd.Precio)-ISNULL(case when vd.DescuentoTipo='$' then vd.DescuentoLinea else (vd.Cantidad-ISNULL(vd.CantidadCancelada, 0.0)-ISNULL(vd.CantidadObsequio, 0.0))*vd.Precio*(vd.DescuentoLinea/100.0) end, 0.0), ver.RedondeoMonetarios))*vd.PrecioTipoCambio/v.TipoCambio ELSE convert(float, ROUND(((vd.Cantidad-ISNULL(vd.CantidadCancelada, 0.0)-ISNULL(vd.CantidadObsequio, 0.0))*vd.Precio)-ISNULL(case when vd.DescuentoTipo='$' then vd.DescuentoLinea else (vd.Cantidad-ISNULL(vd.CantidadCancelada, 0.0)-ISNULL(vd.CantidadObsequio, 0.0))*vd.Precio*(vd.DescuentoLinea/100.0) end, 0.0), ver.RedondeoMonetarios))END END,0.0), (ISNULL(v.DescuentoGlobal,0.0)), v.SobrePrecio) * (1.0+(ISNULL(CASE WHEN ver.Impuesto2Info=1 OR ver.Impuesto2BaseImpuesto1=0 THEN 0.0 ELSE vd.Impuesto2 END, 0.0)/100.0))*(ISNULL(vd.Impuesto1, 0.0)/100.0), ver.RedondeoMonetarios))),0.0)*v.TipoCambio,
base_ieps              = CASE WHEN ISNULL(em.Impuesto2,'') IN ('ieps') THEN (CONVERT(float, ROUND(dbo.fnSubTotal(CASE WHEN cfg.VentaPreciosImpuestoIncluido = 1 THEN (CASE WHEN cfg.VentaPrecioMoneda = 1 THEN CONVERT(float, ROUND(((vd.Cantidad-ISNULL(vd.CantidadCancelada, 0.0)-ISNULL(vd.CantidadObsequio, 0.0))*vd.Precio)-ISNULL(CASE WHEN vd.DescuentoTipo='$' then vd.DescuentoLinea else (vd.Cantidad-ISNULL(vd.CantidadCancelada, 0.0)-ISNULL(vd.CantidadObsequio, 0.0))*vd.Precio*(vd.DescuentoLinea/100.0) END, 0.0), ver.RedondeoMonetarios))*vd.PrecioTipoCambio/v.TipoCambio ELSE convert(float, ROUND(((vd.Cantidad-ISNULL(vd.CantidadCancelada, 0.0)-ISNULL(vd.CantidadObsequio, 0.0))*vd.Precio)-ISNULL(case when vd.DescuentoTipo='$' then vd.DescuentoLinea else (vd.Cantidad-ISNULL(vd.CantidadCancelada, 0.0)-ISNULL(vd.CantidadObsequio, 0.0))*vd.Precio*(vd.DescuentoLinea/100.0) end, 0.0), ver.RedondeoMonetarios))END-ISNULL(CASE WHEN ver.Impuesto3Info=1 THEN 0.0 ELSE vd.Impuesto3 END,0.0))/ (1.0 + (ISNULL(CASE WHEN ver.Impuesto2Info=1 THEN 0.0 ELSE vd.Impuesto2 END, 0.0)/100) + ((ISNULL(vd.Impuesto1,0.0)/100) * (1+(ISNULL(CASE WHEN ver.Impuesto2Info=1 OR ver.Impuesto2BaseImpuesto1=0 THEN 0.0 ELSE vd.Impuesto2 END, 0.0)/100)))) ELSE CASE WHEN cfg.VentaPrecioMoneda = 1 THEN convert(float, ROUND(((vd.Cantidad-ISNULL(vd.CantidadCancelada, 0.0)-ISNULL(vd.CantidadObsequio, 0.0))*vd.Precio)-ISNULL(case when vd.DescuentoTipo='$' then vd.DescuentoLinea else (vd.Cantidad-ISNULL(vd.CantidadCancelada, 0.0)-ISNULL(vd.CantidadObsequio, 0.0))*vd.Precio*(vd.DescuentoLinea/100.0) end, 0.0), ver.RedondeoMonetarios))*vd.PrecioTipoCambio/v.TipoCambio ELSE convert(float, ROUND(((vd.Cantidad-ISNULL(vd.CantidadCancelada, 0.0)-ISNULL(vd.CantidadObsequio, 0.0))*vd.Precio)-ISNULL(case when vd.DescuentoTipo='$' then vd.DescuentoLinea else (vd.Cantidad-ISNULL(vd.CantidadCancelada, 0.0)-ISNULL(vd.CantidadObsequio, 0.0))*vd.Precio*(vd.DescuentoLinea/100.0) end, 0.0), ver.RedondeoMonetarios)) END END, (ISNULL(v.DescuentoGlobal,0.0)), v.SobrePrecio), ver.RedondeoMonetarios))) ELSE 0.0 END*v.TipoCambio,
ieps_tasa              = CASE ma.Impuesto WHEN 'Impuesto 2' THEN CASE WHEN ISNULL(em.Impuesto2,'') IN ('ieps') THEN vd.Impuesto2 ELSE 0.0 END ELSE 0 END,
ieps                   = CASE ma.Impuesto WHEN 'Impuesto 2' THEN CASE WHEN ISNULL(em.Impuesto2,'') IN ('ieps') THEN ISNULL((Convert(float, ROUND(dbo.fnSubTotal(CASE WHEN cfg.VentaPreciosImpuestoIncluido = 1 THEN (CASE WHEN cfg.VentaPrecioMoneda = 1 THEN convert(float, ROUND(((vd.Cantidad-ISNULL(vd.CantidadCancelada, 0.0)-ISNULL(vd.CantidadObsequio, 0.0))*vd.Precio)-ISNULL(case when vd.DescuentoTipo='$' then vd.DescuentoLinea else (vd.Cantidad-ISNULL(vd.CantidadCancelada, 0.0)-ISNULL(vd.CantidadObsequio, 0.0))*vd.Precio*(vd.DescuentoLinea/100.0) end, 0.0), ver.RedondeoMonetarios))*vd.PrecioTipoCambio/v.TipoCambio ELSE convert(float, ROUND(((vd.Cantidad-ISNULL(vd.CantidadCancelada, 0.0)-ISNULL(vd.CantidadObsequio, 0.0))*vd.Precio)-ISNULL(case when vd.DescuentoTipo='$' then vd.DescuentoLinea else (vd.Cantidad-ISNULL(vd.CantidadCancelada, 0.0)-ISNULL(vd.CantidadObsequio, 0.0))*vd.Precio*(vd.DescuentoLinea/100.0) end, 0.0), ver.RedondeoMonetarios)) END-ISNULL(CASE WHEN ver.Impuesto3Info=1 THEN 0.0 ELSE vd.Impuesto3 END,0.0))/ (1.0 + (ISNULL(CASE WHEN ver.Impuesto2Info=1 THEN 0.0 ELSE vd.Impuesto2 END, 0.0)/100) + ((ISNULL(vd.Impuesto1,0.0)/100) * (1+(ISNULL(CASE WHEN ver.Impuesto2Info=1 OR ver.Impuesto2BaseImpuesto1=0 THEN 0.0 ELSE vd.Impuesto2 END, 0.0)/100)))) ELSE CASE WHEN cfg.VentaPrecioMoneda = 1 THEN convert(float, ROUND(((vd.Cantidad-ISNULL(vd.CantidadCancelada, 0.0)-ISNULL(vd.CantidadObsequio, 0.0))*vd.Precio)-ISNULL(case when vd.DescuentoTipo='$' then vd.DescuentoLinea else (vd.Cantidad-ISNULL(vd.CantidadCancelada, 0.0)-ISNULL(vd.CantidadObsequio, 0.0))*vd.Precio*(vd.DescuentoLinea/100.0) end, 0.0), ver.RedondeoMonetarios))*vd.PrecioTipoCambio/v.TipoCambio ELSE convert(float, ROUND(((vd.Cantidad-ISNULL(vd.CantidadCancelada, 0.0)-ISNULL(vd.CantidadObsequio, 0.0))*vd.Precio)-ISNULL(case when vd.DescuentoTipo='$' then vd.DescuentoLinea else (vd.Cantidad-ISNULL(vd.CantidadCancelada, 0.0)-ISNULL(vd.CantidadObsequio, 0.0))*vd.Precio*(vd.DescuentoLinea/100.0) end, 0.0), ver.RedondeoMonetarios)) END END, (ISNULL(v.DescuentoGlobal,0.0)), v.SobrePrecio) * (ISNULL(CASE WHEN ver.Impuesto2Info=1 THEN 0.0 ELSE vd.Impuesto2 END, 0.0)/100.0), ver.RedondeoMonetarios))),0.0) ELSE 0.0 END*v.TipoCambio ELSE ISNULL(vd.Impuesto3, 0)*v.TipoCambio END,
base_isan              = CASE WHEN ISNULL(em.Impuesto2,'') IN ('isan') THEN (CONVERT(float, ROUND(dbo.fnSubTotal(CASE WHEN cfg.VentaPreciosImpuestoIncluido = 1 THEN (CASE WHEN cfg.VentaPrecioMoneda = 1 THEN CONVERT(float, ROUND(((vd.Cantidad-ISNULL(vd.CantidadCancelada, 0.0)-ISNULL(vd.CantidadObsequio, 0.0))*vd.Precio)-ISNULL(CASE WHEN vd.DescuentoTipo='$' then vd.DescuentoLinea else (vd.Cantidad-ISNULL(vd.CantidadCancelada, 0.0)-ISNULL(vd.CantidadObsequio, 0.0))*vd.Precio*(vd.DescuentoLinea/100.0) END, 0.0), ver.RedondeoMonetarios))*vd.PrecioTipoCambio/v.TipoCambio ELSE convert(float, ROUND(((vd.Cantidad-ISNULL(vd.CantidadCancelada, 0.0)-ISNULL(vd.CantidadObsequio, 0.0))*vd.Precio)-ISNULL(case when vd.DescuentoTipo='$' then vd.DescuentoLinea else (vd.Cantidad-ISNULL(vd.CantidadCancelada, 0.0)-ISNULL(vd.CantidadObsequio, 0.0))*vd.Precio*(vd.DescuentoLinea/100.0) end, 0.0), ver.RedondeoMonetarios))END-ISNULL(CASE WHEN ver.Impuesto3Info=1 THEN 0.0 ELSE vd.Impuesto3 END,0.0))/ (1.0 + (ISNULL(CASE WHEN ver.Impuesto2Info=1 THEN 0.0 ELSE vd.Impuesto2 END, 0.0)/100) + ((ISNULL(vd.Impuesto1,0.0)/100) * (1+(ISNULL(CASE WHEN ver.Impuesto2Info=1 OR ver.Impuesto2BaseImpuesto1=0 THEN 0.0 ELSE vd.Impuesto2 END, 0.0)/100)))) ELSE CASE WHEN cfg.VentaPrecioMoneda = 1 THEN convert(float, ROUND(((vd.Cantidad-ISNULL(vd.CantidadCancelada, 0.0)-ISNULL(vd.CantidadObsequio, 0.0))*vd.Precio)-ISNULL(case when vd.DescuentoTipo='$' then vd.DescuentoLinea else (vd.Cantidad-ISNULL(vd.CantidadCancelada, 0.0)-ISNULL(vd.CantidadObsequio, 0.0))*vd.Precio*(vd.DescuentoLinea/100.0) end, 0.0), ver.RedondeoMonetarios))*vd.PrecioTipoCambio/v.TipoCambio ELSE convert(float, ROUND(((vd.Cantidad-ISNULL(vd.CantidadCancelada, 0.0)-ISNULL(vd.CantidadObsequio, 0.0))*vd.Precio)-ISNULL(case when vd.DescuentoTipo='$' then vd.DescuentoLinea else (vd.Cantidad-ISNULL(vd.CantidadCancelada, 0.0)-ISNULL(vd.CantidadObsequio, 0.0))*vd.Precio*(vd.DescuentoLinea/100.0) end, 0.0), ver.RedondeoMonetarios)) END END, (ISNULL(v.DescuentoGlobal,0.0)), v.SobrePrecio), ver.RedondeoMonetarios))) ELSE 0.0 END*v.TipoCambio,
isan                   = CASE WHEN ISNULL(em.Impuesto2,'') IN ('isan') THEN ISNULL((Convert(float, ROUND(dbo.fnSubTotal(CASE WHEN cfg.VentaPreciosImpuestoIncluido = 1 THEN (CASE WHEN cfg.VentaPrecioMoneda = 1 THEN convert(float, ROUND(((vd.Cantidad-ISNULL(vd.CantidadCancelada, 0.0)-ISNULL(vd.CantidadObsequio, 0.0))*vd.Precio)-ISNULL(case when vd.DescuentoTipo='$' then vd.DescuentoLinea else (vd.Cantidad-ISNULL(vd.CantidadCancelada, 0.0)-ISNULL(vd.CantidadObsequio, 0.0))*vd.Precio*(vd.DescuentoLinea/100.0) end, 0.0), ver.RedondeoMonetarios))*vd.PrecioTipoCambio/v.TipoCambio ELSE convert(float, ROUND(((vd.Cantidad-ISNULL(vd.CantidadCancelada, 0.0)-ISNULL(vd.CantidadObsequio, 0.0))*vd.Precio)-ISNULL(case when vd.DescuentoTipo='$' then vd.DescuentoLinea else (vd.Cantidad-ISNULL(vd.CantidadCancelada, 0.0)-ISNULL(vd.CantidadObsequio, 0.0))*vd.Precio*(vd.DescuentoLinea/100.0) end, 0.0), ver.RedondeoMonetarios)) END-ISNULL(CASE WHEN ver.Impuesto3Info=1 THEN 0.0 ELSE vd.Impuesto3 END,0.0))/ (1.0 + (ISNULL(CASE WHEN ver.Impuesto2Info=1 THEN 0.0 ELSE vd.Impuesto2 END, 0.0)/100) + ((ISNULL(vd.Impuesto1,0.0)/100) * (1+(ISNULL(CASE WHEN ver.Impuesto2Info=1 OR ver.Impuesto2BaseImpuesto1=0 THEN 0.0 ELSE vd.Impuesto2 END, 0.0)/100)))) ELSE CASE WHEN cfg.VentaPrecioMoneda = 1 THEN convert(float, ROUND(((vd.Cantidad-ISNULL(vd.CantidadCancelada, 0.0)-ISNULL(vd.CantidadObsequio, 0.0))*vd.Precio)-ISNULL(case when vd.DescuentoTipo='$' then vd.DescuentoLinea else (vd.Cantidad-ISNULL(vd.CantidadCancelada, 0.0)-ISNULL(vd.CantidadObsequio, 0.0))*vd.Precio*(vd.DescuentoLinea/100.0) end, 0.0), ver.RedondeoMonetarios))*vd.PrecioTipoCambio/v.TipoCambio ELSE convert(float, ROUND(((vd.Cantidad-ISNULL(vd.CantidadCancelada, 0.0)-ISNULL(vd.CantidadObsequio, 0.0))*vd.Precio)-ISNULL(case when vd.DescuentoTipo='$' then vd.DescuentoLinea else (vd.Cantidad-ISNULL(vd.CantidadCancelada, 0.0)-ISNULL(vd.CantidadObsequio, 0.0))*vd.Precio*(vd.DescuentoLinea/100.0) end, 0.0), ver.RedondeoMonetarios)) END END, (ISNULL(v.DescuentoGlobal,0.0)), v.SobrePrecio) * (ISNULL(CASE WHEN ver.Impuesto2Info=1 THEN 0.0 ELSE vd.Impuesto2 END, 0.0)/100.0), ver.RedondeoMonetarios))),0.0) ELSE 0.0 END*v.TipoCambio,
ieps_num_reporte         = ma.IEPSNumReporte,
ieps_categoria_concepto  = ma.IEPSCategoriaConcepto,
ieps_exento              = ma.IEPSExento,
ieps_envase_reutilizable = ma.IEPSEnvaseReutilizable,
ieps_retencion           = NULL,
ieps_cantidad            = ISNULL(dbo.fnMFAArtUnidadConvertir(vd.Cantidad,
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
END), vd.Cantidad),
ieps_unidad              = ISNULL(ma.UnidadBaseIEPS, vd.Unidad),
ieps_cantidad2           = ISNULL(dbo.fnMFAArtUnidadConvertir(vd.Cantidad,
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
END), vd.Cantidad),
ieps_unidad2             = ISNULL(ma.UnidadBaseIEPS, vd.Unidad),
dinero				   = cxc.Dinero,
dinero_id				   = cxc.DineroID,
concepto_aplica_ietu     = ISNULL(NULLIF(mtmce.AplicaIetu,''), 'Si'),
concepto_aplica_ieps     = ISNULL(NULLIF(mtmce.AplicaIeps,''), 'Si'),
concepto_aplica_iva      = ISNULL(NULLIF(mtmce.AplicaIVA,''), 'Si'),
EsActivoFijo			   = CASE MFAArtAF.Articulo WHEN NULL THEN 0 ELSE 1 END,
TipoActivo			   = CASE MFAArtAF.Articulo WHEN NULL THEN NULL ELSE MFAActivoFCat.Tipo END,
TipoActividad			   = MFATipoActividad.Tipo
FROM Cxc cxc
JOIN Venta v ON v.MovID = cxc.OrigenID AND v.Mov = cxc.Origen AND cxc.OrigenTipo = 'VTAS' AND v.Empresa = cxc.Empresa
JOIN MovTipo mt ON mt.Mov = v.Mov AND mt.Modulo = 'VTAS'
JOIN Cte c ON c.Cliente = v.Cliente
JOIN VentaD vd ON vd.ID = v.ID
JOIN Art a ON a.Articulo = vd.Articulo
LEFT OUTER JOIN MovTipoMFAConceptoExcepcion mtmce ON a.Articulo = mtmce.Concepto
JOIN EmpresaGral eg ON eg.Empresa = v.Empresa
JOIN EmpresaCfg cfg ON cfg.Empresa = v.Empresa
JOIN EmpresaMFA em ON em.Empresa = v.Empresa
JOIN EmpresaCfg2 ec ON ec.Empresa = em.Empresa
JOIN Version ver ON 1 = 1
LEFT OUTER JOIN MFAMovExcepcion mme ON mme.Modulo = 'VTAS' AND mme.ModuloID = v.ID
LEFT OUTER JOIN MovTipoMFADocExcepcion mtmde ON mtmde.Modulo = 'VTAS' AND mtmde.Mov = v.Mov
LEFT OUTER JOIN MovTipoMFADocAdicion mtmda ON mtmda.Modulo = 'VTAS' AND mtmda.Mov = v.Mov
LEFT OUTER JOIN MFAMovSubTipoDocumentoExcepcionArt mmdtdea ON  ISNULL(NULLIF(mmdtdea.Articulo,''),a.Articulo) = a.Articulo AND mmdtdea.Mov = v.Mov AND mmdtdea.Modulo = 'VTAS'
LEFT OUTER JOIN FiscalRegimen fr ON fr.FiscalRegimen = c.FiscalRegimen
LEFT OUTER JOIN Pais pa ON pa.Clave = c.Pais
LEFT OUTER JOIN MFAPais p ON p.Pais = pa.Pais
LEFT OUTER JOIN Agente ag ON ag.Agente = v.Agente
LEFT OUTER JOIN MFAArt ma ON ma.Articulo = a.Articulo
LEFT OUTER JOIN Unidad u ON u.Unidad = vd.Unidad
LEFT OUTER JOIN Unidad u2 ON u2.Unidad = ma.UnidadBaseIEPS
LEFT OUTER JOIN ArtUnidad au ON au.Articulo = a.Articulo AND au.Unidad = vd.Unidad
LEFT OUTER JOIN ArtUnidad au2 ON au2.Articulo = a.Articulo AND au2.Unidad = ma.UnidadBaseIEPS
LEFT OUTER JOIN MFAArtAF ON a.Articulo = MFAArtAF.Articulo
LEFT OUTER JOIN MFAActivoFCat ON a.CategoriaActivoFijo = MFAActivoFCat.Categoria
LEFT OUTER JOIN MFATipoActividad ON MFATipoActividad.Modulo = 'VTAS' AND MFATipoActividad.Mov = v.Mov
WHERE mtmde.Modulo IS NULL
AND cxc.OrigenTipo = 'VTAS'
AND mme.ModuloID IS NULL
AND v.Estatus IN ('CONCLUIDO','PENDIENTE')
AND cxc.Estatus IN ('CONCLUIDO','PENDIENTE')
AND (mt.Clave IN ('VTAS.B','VTAS.D','VTAS.DF','VTAS.F','VTAS.FX','VTAS.FAR','VTAS.FB') OR (mtmda.Modulo IS NOT NULL))

