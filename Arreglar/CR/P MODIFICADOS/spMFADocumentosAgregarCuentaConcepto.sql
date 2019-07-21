SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spMFADocumentosAgregarCuentaConcepto

AS BEGIN
TRUNCATE TABLE MFAPolizaConcepto
INSERT MFAPolizaConcepto (Empresa,   Poliza,   PolizaID,   Modulo, ModuloID,                  Mov,   Categoria,   Familia,   Grupo,   ConceptoTipo, Concepto)
SELECT  v.Empresa, v.Poliza, v.PolizaID, 'VTAS', CONVERT(int,ld.origen_id), v.Mov, a.Categoria, a.Familia, a.Grupo, 'Articulo',   ld.concepto_clave
FROM layout_documentos ld  WITH (NOLOCK) 
JOIN Venta v  WITH (NOLOCK) ON v.ID = CONVERT(int,ld.origen_id)
JOIN Art a  WITH (NOLOCK) ON a.Articulo = ld.concepto_clave
WHERE ld.origen_modulo = 'VTAS'
INSERT MFAPolizaConcepto (Empresa,   Poliza,   PolizaID,   Modulo, ModuloID,                  Mov,   Categoria,   Familia,   Grupo,   ConceptoTipo, Concepto)
SELECT  c.Empresa, c.Poliza, c.PolizaID, 'COMS', CONVERT(int,ld.origen_id), c.Mov, a.Categoria, a.Familia, a.Grupo, 'Articulo',   ld.concepto_clave
FROM layout_documentos ld WITH (NOLOCK) 
JOIN Compra c  WITH (NOLOCK) ON c.ID = CONVERT(int,ld.origen_id)
JOIN Art a  WITH (NOLOCK) ON a.Articulo = ld.concepto_clave
WHERE ld.origen_modulo = 'COMS'
INSERT MFAPolizaConcepto (Empresa,   Poliza,   PolizaID,   Modulo, ModuloID,                   Mov,   Categoria, Familia, Grupo, ConceptoTipo,     Concepto)
SELECT  g.Empresa, g.Poliza, g.PolizaID, 'GAS',  CONVERT(int,ld.origen_id),  g.Mov, NULL,      NULL,    NULL,  'Concepto Gasto', ld.concepto_clave
FROM layout_documentos ld WITH (NOLOCK) 
JOIN Gasto g  WITH (NOLOCK) ON g.ID = CONVERT(int,ld.origen_id)
WHERE ld.origen_modulo = 'GAS'
INSERT MFAPolizaConcepto (Empresa,    Poliza,    PolizaID,    Modulo, ModuloID,                   Mov,    Categoria, Familia, Grupo, ConceptoTipo,   Concepto)
SELECT  cx.Empresa, cx.Poliza, cx.PolizaID, 'CXC',  CONVERT(int,ld.origen_id),  cx.Mov, NULL,      NULL,    NULL,  'Concepto Cxc', ld.concepto_clave
FROM layout_documentos ld WITH (NOLOCK) 
JOIN Cxc cx  WITH (NOLOCK) ON cx.ID = CONVERT(int,ld.origen_id)
WHERE ld.origen_modulo = 'CXC'
INSERT MFAPolizaConcepto (Empresa,    Poliza,    PolizaID,    Modulo, ModuloID,                   Mov,    Categoria, Familia, Grupo,   ConceptoTipo,   Concepto)
SELECT  cx.Empresa, cx.Poliza, cx.PolizaID, 'CXP',  CONVERT(int,ld.origen_id),  cx.Mov, NULL,      NULL,    NULL,    'Concepto Cxp', ld.concepto_clave
FROM layout_documentos ld  WITH (NOLOCK)
JOIN Cxp cx WITH (NOLOCK) ON cx.ID = CONVERT(int,ld.origen_id)
WHERE ld.origen_modulo = 'CXP'
PRINT 'Fin inserts MFAPolizaConcepto: ' + CONVERT(varchar,getdate(),126)
UPDATE MFAPolizaConcepto WITH (ROWLOCK)
SET Cuenta = dbo.fnMFAObtenerCuentaConcepto(Modulo,Mov,Categoria,Grupo,Familia,Concepto,ConceptoTipo,Empresa, Poliza, PolizaID)
PRINT 'Fin update MFAPolizaConcepto: ' + CONVERT(varchar,getdate(),126)
UPDATE layout_documentos
SET concepto_cuenta_contable = mpc.Cuenta
FROM layout_documentos ld 
JOIN MFAPolizaConcepto mpc  WITH (NOLOCK) ON mpc.ModuloID = CONVERT(int,ld.origen_id) AND mpc.Modulo = ld.origen_modulo
PRINT 'Fin update layout_documento concepto: ' + CONVERT(varchar,getdate(),126)
RETURN
END

