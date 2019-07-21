SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER VIEW ContDW

AS
SELECT
'Cuenta' = r.Cuenta,
'Mayor' = dbo.fnCtaMayor(r.Cuenta),
'DetalleTipo' = dbo.fnDetalleTipo(Cta.DetalleTipo, Cta.Rama),
'CentroCostos' = r.SubCuenta,
'CentroCostos2' = r.SubCuenta2,
'CentroCostos3' = r.SubCuenta3,
'Debe' = r.Debe,
'Haber' = r.Haber,
'Neto' = ISNULL(r.Debe, 0.0)-ISNULL(r.Haber, 0.0),
'ContID' = r.ID,
'ContRID' = r.RID,
'ContConcepto' = ISNULL(r.Concepto, p.Concepto),
'ContReferencia' = p.Referencia,
'ContMov' = p.Mov,
'ContMovID' = p.MovID,
'ContEstatus'= p.Estatus,
'OrigenEmpresa' = p.OrigenEmpresa,
'TipoPresupuesto' = CASE WHEN mt.Clave = 'CONT.PR' THEN 'Presupuesto' ELSE 'Real' END,
p.Intercompania,
r.Modulo,
'ID' = r.ModuloID,
m.Mov,
m.MovID,
m.MovTipo,
'Empresa' =  r.Empresa,
'Sucursal' = p.Sucursal,
'FechaEmision' = m.FechaEmision,
'FechaContable' = p.FechaContable,
p.Ejercicio,
p.Periodo,
'Renglon' = r.ModuloRenglon,
'RenglonSub' = r.ModuloRenglonSub,
d.RenglonID,
d.RenglonTipo,
'Contacto' = ISNULL(r.ContactoEspecifico, ISNULL(d.Contacto, m.Contacto)),
'ContactoTipo' = ISNULL(d.CtoTipo, m.CtoTipo),
'ContactoSubTipo' = dbo.fnContactoNivel(ISNULL(d.CtoTipo, m.CtoTipo), ISNULL(r.ContactoEspecifico, ISNULL(d.Contacto, m.Contacto)), 'SUB TIPO'),
'ContactoEnviarA' = m.EnviarA,
m.Estatus,
m.Situacion,
/*m.SituacionFecha,
m.SituacionUsuario,
m.SituacionNota, */
'Proyecto' = ISNULL(d.Proyecto, m.Proyecto),
'Actividad' = d.Actividad,
'Concepto' = ISNULL(d.Concepto, m.Concepto),
'Referencia' = ISNULL(d.Referencia, m.Referencia),
m.Usuario,
m.Clase,
m.SubClase,
m.Causa,
m.FormaEnvio,
m.Condicion,
m.ZonaImpuesto,
m.CtaDinero,
m.Cajero,
m.Moneda,
m.TipoCambio,
m.Deudor,
m.Acreedor,
d.UEN,
'Personal' = ISNULL(d.Personal, m.Personal),
d.Almacen,
d.Codigo,
d.Articulo,
d.SubCuenta,
d.Cantidad,
d.Unidad,
d.Factor,
d.CantidadInventario,
d.Costo,
d.CostoInv,
d.CostoActividad,
d.Precio,
d.DescuentoTipo,
d.DescuentoLinea,
d.DescuentoImporte,
d.Impuesto1,
d.Impuesto2,
d.Impuesto3,
d.Retencion1,
d.Retencion2,
d.Retencion3,
d.ContUso,
d.Comision,
/*  d.Aplica,
d.AplicaID,
d.DestinoTipo,
d.Destino,
d.DestinoID,*/
d.FormaPago,
'Agente' = ISNULL(d.Agente, m.Agente),
d.Departamento,
d.Espacio,
d.AFArticulo,
d.AFSerie,
d.ObligacionFiscal,
d.Tasa
FROM ContReg r WITH (NOLOCK)
JOIN Cont p WITH (NOLOCK) ON p.ID = r.ID AND p.Estatus = 'CONCLUIDO'
LEFT OUTER JOIN MovTipo mt WITH (NOLOCK) ON mt.Modulo = 'CONT' AND mt.Mov = p.Mov
LEFT OUTER JOIN Cta WITH (NOLOCK) ON r.Cuenta = Cta.Cuenta
LEFT OUTER JOIN MovReg m WITH (NOLOCK) ON m.Modulo = r.Modulo AND m.ID = r.ModuloID
LEFT OUTER JOIN MovDReg d WITH (NOLOCK) ON d.Modulo = r.Modulo AND d.ID = r.ModuloID AND d.Renglon = r.ModuloRenglon AND ISNULL(d.RenglonSub, 0) = ISNULL(r.ModuloRenglonSub, 0)

