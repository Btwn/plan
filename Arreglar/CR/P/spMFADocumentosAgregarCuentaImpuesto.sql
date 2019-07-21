SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spMFADocumentosAgregarCuentaImpuesto

AS BEGIN
TRUNCATE TABLE MFAPolizaImpuesto
INSERT MFAPolizaImpuesto (Empresa,   Poliza,   PolizaID,   Modulo, ModuloID,                  Mov,   ImpuestoTipo,    ImpuestoTasa)
SELECT  v.Empresa, v.Poliza, v.PolizaID, 'VTAS', CONVERT(int,ld.origen_id), v.Mov, 'Retencion ISR', 0
FROM layout_documentos ld
JOIN Venta v ON v.ID = CONVERT(int,ld.origen_id)
JOIN Art a ON a.Articulo = ld.concepto_clave
WHERE ld.origen_modulo = 'VTAS'
INSERT MFAPolizaImpuesto (Empresa,   Poliza,   PolizaID,   Modulo, ModuloID,                  Mov,   ImpuestoTipo, ImpuestoTasa)
SELECT  v.Empresa, v.Poliza, v.PolizaID, 'VTAS', CONVERT(int,ld.origen_id), v.Mov, 'IVA',        iva_tasa
FROM layout_documentos ld
JOIN Venta v ON v.ID = CONVERT(int,ld.origen_id)
JOIN Art a ON a.Articulo = ld.concepto_clave
WHERE ld.origen_modulo = 'VTAS'
INSERT MFAPolizaImpuesto (Empresa,   Poliza,   PolizaID,   Modulo, ModuloID,                  Mov,   ImpuestoTipo,    ImpuestoTasa)
SELECT  v.Empresa, v.Poliza, v.PolizaID, 'VTAS', CONVERT(int,ld.origen_id), v.Mov, 'Retencion IVA', 0
FROM layout_documentos ld
JOIN Venta v ON v.ID = CONVERT(int,ld.origen_id)
JOIN Art a ON a.Articulo = ld.concepto_clave
WHERE ld.origen_modulo = 'VTAS'
INSERT MFAPolizaImpuesto (Empresa,   Poliza,   PolizaID,   Modulo, ModuloID,                  Mov,   ImpuestoTipo,    ImpuestoTasa)
SELECT  v.Empresa, v.Poliza, v.PolizaID, 'VTAS', CONVERT(int,ld.origen_id), v.Mov, 'IEPS',          ieps_tasa
FROM layout_documentos ld
JOIN Venta v ON v.ID = CONVERT(int,ld.origen_id)
JOIN Art a ON a.Articulo = ld.concepto_clave
WHERE ld.origen_modulo = 'VTAS'
INSERT MFAPolizaImpuesto (Empresa,   Poliza,   PolizaID,   Modulo, ModuloID,                  Mov,   ImpuestoTipo,    ImpuestoTasa)
SELECT  v.Empresa, v.Poliza, v.PolizaID, 'VTAS', CONVERT(int,ld.origen_id), v.Mov, 'ISAN',          0
FROM layout_documentos ld
JOIN Venta v ON v.ID = CONVERT(int,ld.origen_id)
JOIN Art a ON a.Articulo = ld.concepto_clave
WHERE ld.origen_modulo = 'VTAS'
INSERT MFAPolizaImpuesto (Empresa,   Poliza,   PolizaID,   Modulo, ModuloID,                  Mov,   ImpuestoTipo,    ImpuestoTasa)
SELECT  v.Empresa, v.Poliza, v.PolizaID, 'VTAS', CONVERT(int,ld.origen_id), v.Mov, 'Otros',         otros_impuestos_tasa
FROM layout_documentos ld
JOIN Venta v ON v.ID = CONVERT(int,ld.origen_id)
JOIN Art a ON a.Articulo = ld.concepto_clave
WHERE ld.origen_modulo = 'VTAS'
INSERT MFAPolizaImpuesto (Empresa,   Poliza,   PolizaID,   Modulo, ModuloID,                  Mov,   ImpuestoTipo,    ImpuestoTasa)
SELECT  c.Empresa, c.Poliza, c.PolizaID, 'COMS', CONVERT(int,ld.origen_id), c.Mov, 'Retencion ISR', 0
FROM layout_documentos ld
JOIN Compra c ON c.ID = CONVERT(int,ld.origen_id)
JOIN Art a ON a.Articulo = ld.concepto_clave
WHERE ld.origen_modulo = 'COMS'
INSERT MFAPolizaImpuesto (Empresa,   Poliza,   PolizaID,   Modulo, ModuloID,                  Mov,   ImpuestoTipo,    ImpuestoTasa)
SELECT  c.Empresa, c.Poliza, c.PolizaID, 'COMS', CONVERT(int,ld.origen_id), c.Mov, 'IVA',           iva_tasa
FROM layout_documentos ld
JOIN Compra c ON c.ID = CONVERT(int,ld.origen_id)
JOIN Art a ON a.Articulo = ld.concepto_clave
WHERE ld.origen_modulo = 'COMS'
INSERT MFAPolizaImpuesto (Empresa,   Poliza,   PolizaID,   Modulo, ModuloID,                  Mov,   ImpuestoTipo,    ImpuestoTasa)
SELECT  c.Empresa, c.Poliza, c.PolizaID, 'COMS', CONVERT(int,ld.origen_id), c.Mov, 'Retencion IVA', 0
FROM layout_documentos ld
JOIN Compra c ON c.ID = CONVERT(int,ld.origen_id)
JOIN Art a ON a.Articulo = ld.concepto_clave
WHERE ld.origen_modulo = 'COMS'
INSERT MFAPolizaImpuesto (Empresa,   Poliza,   PolizaID,   Modulo, ModuloID,                  Mov,   ImpuestoTipo, ImpuestoTasa)
SELECT  c.Empresa, c.Poliza, c.PolizaID, 'COMS', CONVERT(int,ld.origen_id), c.Mov, 'IEPS',       ieps_tasa
FROM layout_documentos ld
JOIN Compra c ON c.ID = CONVERT(int,ld.origen_id)
JOIN Art a ON a.Articulo = ld.concepto_clave
WHERE ld.origen_modulo = 'COMS'
INSERT MFAPolizaImpuesto (Empresa,   Poliza,   PolizaID,   Modulo, ModuloID,                  Mov,   ImpuestoTipo, ImpuestoTasa)
SELECT  c.Empresa, c.Poliza, c.PolizaID, 'COMS', CONVERT(int,ld.origen_id), c.Mov, 'ISAN',       0
FROM layout_documentos ld
JOIN Compra c ON c.ID = CONVERT(int,ld.origen_id)
JOIN Art a ON a.Articulo = ld.concepto_clave
WHERE ld.origen_modulo = 'COMS'
INSERT MFAPolizaImpuesto (Empresa,   Poliza,   PolizaID,   Modulo, ModuloID,                  Mov,   ImpuestoTipo, ImpuestoTasa)
SELECT  c.Empresa, c.Poliza, c.PolizaID, 'COMS', CONVERT(int,ld.origen_id), c.Mov, 'Otros',      otros_impuestos_tasa
FROM layout_documentos ld
JOIN Compra c ON c.ID = CONVERT(int,ld.origen_id)
JOIN Art a ON a.Articulo = ld.concepto_clave
WHERE ld.origen_modulo = 'COMS'
INSERT MFAPolizaImpuesto (Empresa,   Poliza,   PolizaID,   Modulo, ModuloID,                   Mov,   ImpuestoTipo,    ImpuestoTasa)
SELECT  g.Empresa, g.Poliza, g.PolizaID, 'GAS',  CONVERT(int,ld.origen_id),  g.Mov, 'Retencion ISR', 0
FROM layout_documentos ld
JOIN Gasto g ON g.ID = CONVERT(int,ld.origen_id)
WHERE ld.origen_modulo = 'GAS'
INSERT MFAPolizaImpuesto (Empresa,   Poliza,   PolizaID,   Modulo, ModuloID,                   Mov,   ImpuestoTipo, ImpuestoTasa)
SELECT  g.Empresa, g.Poliza, g.PolizaID, 'GAS',  CONVERT(int,ld.origen_id),  g.Mov, 'IVA',        iva_tasa
FROM layout_documentos ld
JOIN Gasto g ON g.ID = CONVERT(int,ld.origen_id)
WHERE ld.origen_modulo = 'GAS'
INSERT MFAPolizaImpuesto (Empresa,   Poliza,   PolizaID,   Modulo, ModuloID,                   Mov,   ImpuestoTipo,    ImpuestoTasa)
SELECT  g.Empresa, g.Poliza, g.PolizaID, 'GAS',  CONVERT(int,ld.origen_id),  g.Mov, 'Retencion IVA', 0
FROM layout_documentos ld
JOIN Gasto g ON g.ID = CONVERT(int,ld.origen_id)
WHERE ld.origen_modulo = 'GAS'
INSERT MFAPolizaImpuesto (Empresa,   Poliza,   PolizaID,   Modulo, ModuloID,                   Mov,   ImpuestoTipo, ImpuestoTasa)
SELECT  g.Empresa, g.Poliza, g.PolizaID, 'GAS',  CONVERT(int,ld.origen_id),  g.Mov, 'IEPS',       ieps_tasa
FROM layout_documentos ld
JOIN Gasto g ON g.ID = CONVERT(int,ld.origen_id)
WHERE ld.origen_modulo = 'GAS'
INSERT MFAPolizaImpuesto (Empresa,   Poliza,   PolizaID,   Modulo, ModuloID,                   Mov,   ImpuestoTipo, ImpuestoTasa)
SELECT  g.Empresa, g.Poliza, g.PolizaID, 'GAS',  CONVERT(int,ld.origen_id),  g.Mov, 'ISAN',       0
FROM layout_documentos ld
JOIN Gasto g ON g.ID = CONVERT(int,ld.origen_id)
WHERE ld.origen_modulo = 'GAS'
INSERT MFAPolizaImpuesto (Empresa,   Poliza,   PolizaID,   Modulo, ModuloID,                   Mov,   ImpuestoTipo, ImpuestoTasa)
SELECT  g.Empresa, g.Poliza, g.PolizaID, 'GAS',  CONVERT(int,ld.origen_id),  g.Mov, 'Otros',      otros_impuestos_tasa
FROM layout_documentos ld
JOIN Gasto g ON g.ID = CONVERT(int,ld.origen_id)
WHERE ld.origen_modulo = 'GAS'
INSERT MFAPolizaImpuesto (Empresa,    Poliza,    PolizaID,    Modulo, ModuloID,                   Mov,    ImpuestoTipo,    ImpuestoTasa)
SELECT  cx.Empresa, cx.Poliza, cx.PolizaID, 'CXC',  CONVERT(int,ld.origen_id),  cx.Mov, 'Retencion ISR', 0
FROM layout_documentos ld
JOIN Cxc cx ON cx.ID = CONVERT(int,ld.origen_id)
WHERE ld.origen_modulo = 'CXC'
INSERT MFAPolizaImpuesto (Empresa,    Poliza,    PolizaID,    Modulo, ModuloID,                   Mov,    ImpuestoTipo, ImpuestoTasa)
SELECT  cx.Empresa, cx.Poliza, cx.PolizaID, 'CXC',  CONVERT(int,ld.origen_id),  cx.Mov, 'IVA',        iva_tasa
FROM layout_documentos ld
JOIN Cxc cx ON cx.ID = CONVERT(int,ld.origen_id)
WHERE ld.origen_modulo = 'CXC'
INSERT MFAPolizaImpuesto (Empresa,    Poliza,    PolizaID,    Modulo, ModuloID,                   Mov,    ImpuestoTipo,    ImpuestoTasa)
SELECT  cx.Empresa, cx.Poliza, cx.PolizaID, 'CXC',  CONVERT(int,ld.origen_id),  cx.Mov, 'Retencion IVA', 0
FROM layout_documentos ld
JOIN Cxc cx ON cx.ID = CONVERT(int,ld.origen_id)
WHERE ld.origen_modulo = 'CXC'
INSERT MFAPolizaImpuesto (Empresa,    Poliza,    PolizaID,    Modulo, ModuloID,                   Mov,    ImpuestoTipo, ImpuestoTasa)
SELECT  cx.Empresa, cx.Poliza, cx.PolizaID, 'CXC',  CONVERT(int,ld.origen_id),  cx.Mov, 'IEPS',       ieps_tasa
FROM layout_documentos ld
JOIN Cxc cx ON cx.ID = CONVERT(int,ld.origen_id)
WHERE ld.origen_modulo = 'CXC'
INSERT MFAPolizaImpuesto (Empresa,    Poliza,    PolizaID,    Modulo, ModuloID,                   Mov,    ImpuestoTipo, ImpuestoTasa)
SELECT  cx.Empresa, cx.Poliza, cx.PolizaID, 'CXC',  CONVERT(int,ld.origen_id),  cx.Mov, 'ISAN',       0
FROM layout_documentos ld
JOIN Cxc cx ON cx.ID = CONVERT(int,ld.origen_id)
WHERE ld.origen_modulo = 'CXC'
INSERT MFAPolizaImpuesto (Empresa,    Poliza,    PolizaID,    Modulo, ModuloID,                   Mov,    ImpuestoTipo, ImpuestoTasa)
SELECT  cx.Empresa, cx.Poliza, cx.PolizaID, 'CXC',  CONVERT(int,ld.origen_id),  cx.Mov, 'Otros',      otros_impuestos_tasa
FROM layout_documentos ld
JOIN Cxc cx ON cx.ID = CONVERT(int,ld.origen_id)
WHERE ld.origen_modulo = 'CXC'
INSERT MFAPolizaImpuesto (Empresa,    Poliza,    PolizaID,    Modulo, ModuloID,                   Mov,    ImpuestoTipo,    ImpuestoTasa)
SELECT  cx.Empresa, cx.Poliza, cx.PolizaID, 'CXP',  CONVERT(int,ld.origen_id),  cx.Mov, 'Retencion ISR', 0
FROM layout_documentos ld
JOIN Cxp cx ON cx.ID = CONVERT(int,ld.origen_id)
WHERE ld.origen_modulo = 'CXP'
INSERT MFAPolizaImpuesto (Empresa,    Poliza,    PolizaID,    Modulo, ModuloID,                   Mov,    ImpuestoTipo, ImpuestoTasa)
SELECT  cx.Empresa, cx.Poliza, cx.PolizaID, 'CXP',  CONVERT(int,ld.origen_id),  cx.Mov, 'IVA',        iva_tasa
FROM layout_documentos ld
JOIN Cxp cx ON cx.ID = CONVERT(int,ld.origen_id)
WHERE ld.origen_modulo = 'CXP'
INSERT MFAPolizaImpuesto (Empresa,    Poliza,    PolizaID,    Modulo, ModuloID,                   Mov,    ImpuestoTipo,    ImpuestoTasa)
SELECT  cx.Empresa, cx.Poliza, cx.PolizaID, 'CXP',  CONVERT(int,ld.origen_id),  cx.Mov, 'Retencion IVA', 0
FROM layout_documentos ld
JOIN Cxp cx ON cx.ID = CONVERT(int,ld.origen_id)
WHERE ld.origen_modulo = 'CXP'
INSERT MFAPolizaImpuesto (Empresa,    Poliza,    PolizaID,    Modulo, ModuloID,                   Mov,    ImpuestoTipo, ImpuestoTasa)
SELECT  cx.Empresa, cx.Poliza, cx.PolizaID, 'CXP',  CONVERT(int,ld.origen_id),  cx.Mov, 'IEPS',       ieps_tasa
FROM layout_documentos ld
JOIN Cxp cx ON cx.ID = CONVERT(int,ld.origen_id)
WHERE ld.origen_modulo = 'CXP'
INSERT MFAPolizaImpuesto (Empresa,    Poliza,    PolizaID,    Modulo, ModuloID,                   Mov,    ImpuestoTipo, ImpuestoTasa)
SELECT  cx.Empresa, cx.Poliza, cx.PolizaID, 'CXP',  CONVERT(int,ld.origen_id),  cx.Mov, 'ISAN',       0
FROM layout_documentos ld
JOIN Cxp cx ON cx.ID = CONVERT(int,ld.origen_id)
WHERE ld.origen_modulo = 'CXP'
INSERT MFAPolizaImpuesto (Empresa,    Poliza,    PolizaID,    Modulo, ModuloID,                   Mov,    ImpuestoTipo, ImpuestoTasa)
SELECT  cx.Empresa, cx.Poliza, cx.PolizaID, 'CXP',  CONVERT(int,ld.origen_id),  cx.Mov, 'Otros',      otros_impuestos_tasa
FROM layout_documentos ld
JOIN Cxp cx ON cx.ID = CONVERT(int,ld.origen_id)
WHERE ld.origen_modulo = 'CXP'
PRINT 'Fin inserts MFAPolizaImpuesto: ' + CONVERT(varchar,getdate(),126)
UPDATE MFAPolizaImpuesto
SET Cuenta = dbo.fnMFAObtenerCuentaImpuesto(Modulo,Mov,ImpuestoTasa,ImpuestoTipo,Empresa, Poliza, PolizaID)
PRINT 'Fin update MFAPolizaImpuesto: ' + CONVERT(varchar,getdate(),126)
UPDATE layout_documentos
SET retencion_isr_cuenta_contable = mpc.Cuenta
FROM layout_documentos ld
JOIN MFAPolizaImpuesto mpc ON mpc.ModuloID = CONVERT(int,ld.origen_id) AND mpc.Modulo = ld.origen_modulo AND mpc.ImpuestoTipo = 'ISR'
UPDATE layout_documentos
SET iva_cuenta_contable = mpc.Cuenta
FROM layout_documentos ld
JOIN MFAPolizaImpuesto mpc ON mpc.ModuloID = CONVERT(int,ld.origen_id) AND mpc.Modulo = ld.origen_modulo AND mpc.ImpuestoTipo = 'IVA'
UPDATE layout_documentos
SET retencion_iva_cuenta_contable = mpc.Cuenta
FROM layout_documentos ld
JOIN MFAPolizaImpuesto mpc ON mpc.ModuloID = CONVERT(int,ld.origen_id) AND mpc.Modulo = ld.origen_modulo AND mpc.ImpuestoTipo = 'Retencion IVA'
UPDATE layout_documentos
SET ieps_cuenta_contable = mpc.Cuenta
FROM layout_documentos ld
JOIN MFAPolizaImpuesto mpc ON mpc.ModuloID = CONVERT(int,ld.origen_id) AND mpc.Modulo = ld.origen_modulo AND mpc.ImpuestoTipo = 'IEPS'
UPDATE layout_documentos
SET isan_cuenta_contable = mpc.Cuenta
FROM layout_documentos ld
JOIN MFAPolizaImpuesto mpc ON mpc.ModuloID = CONVERT(int,ld.origen_id) AND mpc.Modulo = ld.origen_modulo AND mpc.ImpuestoTipo = 'ISAN'
UPDATE layout_documentos
SET otros_impuestos_cuenta_contable = mpc.Cuenta
FROM layout_documentos ld
JOIN MFAPolizaImpuesto mpc ON mpc.ModuloID = CONVERT(int,ld.origen_id) AND mpc.Modulo = ld.origen_modulo AND mpc.ImpuestoTipo = 'Otros'
PRINT 'Fin update layout_documentos impuesto: ' + CONVERT(varchar,getdate(),126)
RETURN
END

