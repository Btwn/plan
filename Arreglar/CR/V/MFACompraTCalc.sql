SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER VIEW MFACompraTCalc

AS
SELECT
v.ID,
v.Sucursal,
v.Empresa,
v.Mov,
v.MovID,
v.Moneda,
v.TipoCambio,
v.Concepto,
v.Referencia,
v.Proyecto,
v.FechaEmision,
d.FechaRequerida,
v.Prioridad,
v.Estatus,
v.Situacion,
v.SituacionFecha,
v.SituacionUsuario,
v.SituacionNota,
v.Proveedor,
v.Agente,
v.FormaEnvio,
v.Condicion,
v.Vencimiento,
v.Usuario,
v.Observaciones,
v.Ejercicio,
v.Periodo,
v.Peso,
v.Volumen,
v.causa,
v.ZonaImpuesto,
v.FechaEntrega,
v.EmbarqueEstado,
v.FechaConclusion,
v.FechaRegistro,
v.UEN,
dbo.fnSubTotal(v.Importe, (ISNULL(v.DescuentoGlobal,0.0)), NULL) + ISNULL(v.Impuestos, 0) 'ImporteMov',
d.Renglon,
d.RenglonSub,
d.RenglonID,
d.RenglonTipo,
d.ImportacionProveedor,
d.ImportacionReferencia,
d.Articulo,
d.SubCuenta,
d.Unidad,
d.Almacen,
d.Costo,
d.AjusteCosteo,
d.CostoUEPS,
d.CostoPEPS,
d.UltimoCosto,
d.CostoEstandar,
d.PrecioLista,
d.DescuentoTipo,
d.Impuesto1,
d.Impuesto2,
d.Impuesto3,
d.Retencion1,
d.Retencion2,
d.Retencion3,
d.Cantidad,
d.Factor,
d.CantidadInventario,
d.CantidadNeta,
d.CantidadPendiente,
d.CantidadEmbarcada,
d.CantidadFactor,
d.PendienteFactor,
d.ImpuestosPorcentaje,
d.Importe,
d.DescuentoLineal,
d.ContUso,
d.ContUso2,
d.ContUso3,
d.Categoria,
d.Aplica,
d.AplicaID,
d.PresupuestoEsp,
d.ClavePresupuestal,
d.TipoImpuesto1,
d.TipoImpuesto2,
d.TipoImpuesto3,
d.TipoRetencion1,
d.TipoRetencion2,
d.TipoRetencion3,
d.CostoPromedio,
d.CostoReposicion,
d.RedondeoMonetarios,
"SubTotalInv"       = Convert(money, ROUND(d.CostoInv*d.CantidadNeta, d.RedondeoMonetarios)),
"DescuentosTotales" = convert(money, ROUND((d.Importe*ISNULL(v.DescuentoGlobal, 0.0)/100.0)+ISNULL(d.DescuentoLineal, 0.0), d.RedondeoMonetarios)),
"SubTotal"          = Convert(money, ROUND((d.Importe*(100-ISNULL(v.DescuentoGlobal, 0.0))/100.0)*CASE WHEN mt.SubClave = 'COMS.CE/GT' THEN (1-(ISNULL(Retencion3, 0.0)/100.0)) ELSE 1 END, d.RedondeoMonetarios)),
"Impuesto1Total"    = Convert(money, ROUND((d.Importe*(100-ISNULL(v.DescuentoGlobal, 0.0))/100.0)*CASE WHEN mt.SubClave = 'COMS.CE/GT' THEN (1-(ISNULL(Retencion3, 0.0)/100.0)) ELSE 1 END*(1.0+(ISNULL(d.Impuesto2BaseImpuesto1, 0.0)/100.0))*(ISNULL(Impuesto1Base, 0.0)/100.0), d.RedondeoMonetarios)),
"Impuesto2Total"    = Convert(money, ROUND((d.Importe*(100-ISNULL(v.DescuentoGlobal, 0.0))/100.0)*CASE WHEN mt.SubClave = 'COMS.CE/GT' THEN (1-(ISNULL(Retencion3, 0.0)/100.0)) ELSE 1 END*(ISNULL(Impuesto2Base, 0.0)/100.0), d.RedondeoMonetarios)),
"Impuesto3Total"    = ISNULL(ImpuestosImporte, 0.0), 
"Impuestos" 	      = ISNULL(ImpuestosImporte, 0.0) + Convert(money, ROUND((d.Importe*(100-ISNULL(v.DescuentoGlobal, 0.0))/100.0) * (ISNULL(ImpuestosPorcentaje, 0.0)/100.0), d.RedondeoMonetarios)),
"ImporteTotal"      = ISNULL(ImpuestosImporte, 0.0) + Convert(money, ROUND((d.Importe*(100-ISNULL(v.DescuentoGlobal, 0.0))/100.0) * (1.0+(ISNULL(ImpuestosPorcentaje, 0.0)/100.0)), d.RedondeoMonetarios)),
"Retencion1Total"   = Convert(money, ROUND((d.Importe*(100-ISNULL(v.DescuentoGlobal, 0.0))/100.0)*(1-(ISNULL(Retencion3, 0.0)/100.0))*(ISNULL(Retencion1, 0.0)/100.0), d.RedondeoMonetarios)),
"Retencion2Total"   = CASE
WHEN Version.Retencion2BaseImpuesto1 = 1 THEN
Convert(money, ROUND((d.Importe*(100-ISNULL(v.DescuentoGlobal, 0.0))/100.0)*(1-(ISNULL(Retencion3, 0.0)/100.0))*(1.0+(ISNULL(Impuesto2Base, 0.0)/100.0))*(ISNULL(Impuesto1Base, 0.0)/100.0)*(ISNULL(Retencion2, 0.0)/100.0), d.RedondeoMonetarios))
ELSE
Convert(money, ROUND((d.Importe*(100-ISNULL(v.DescuentoGlobal, 0.0))/100.0)*(1-(ISNULL(Retencion3, 0.0)/100.0))*(ISNULL(Retencion2, 0.0)/100.0), d.RedondeoMonetarios)) END,
"Retencion3Total"   = Convert(money, ROUND((d.Importe*(100-ISNULL(v.DescuentoGlobal, 0.0))/100.0)*(ISNULL(Retencion3, 0.0)/100.0), d.RedondeoMonetarios))
FROM
Compra v, MFACompraDCalc d, Version, MovTipo mt
WHERE
v.ID = d.ID
AND mt.Mov = v.Mov
AND mt.Modulo = 'COMS'

