SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spMFADocumentosAgregarCuentaEntidad

AS BEGIN
TRUNCATE TABLE MFAPolizaEntidad
INSERT MFAPolizaEntidad (Empresa,   Poliza,   PolizaID,   Modulo, ModuloID,                  Mov,   Categoria,   Familia,   Grupo,   EntidadTipo, Entidad)
SELECT  v.Empresa, v.Poliza, v.PolizaID, 'VTAS', CONVERT(int,ld.origen_id), v.Mov, c.Categoria, c.Familia, c.Grupo, 'Cliente',   c.Cliente
FROM layout_documentos ld
JOIN Venta v ON v.ID = CONVERT(int,ld.origen_id)
JOIN Cte c ON c.Cliente = v.Cliente
WHERE ld.origen_modulo = 'VTAS'
INSERT MFAPolizaEntidad (Empresa,   Poliza,   PolizaID,   Modulo, ModuloID,                  Mov,   Categoria,   Familia,   Grupo, EntidadTipo, Entidad)
SELECT  c.Empresa, c.Poliza, c.PolizaID, 'COMS', CONVERT(int,ld.origen_id), c.Mov, p.Categoria, p.Familia, NULL,  'Proveedor', p.Proveedor
FROM layout_documentos ld
JOIN Compra c ON c.ID = CONVERT(int,ld.origen_id)
JOIN Prov p ON p.Proveedor = c.Proveedor
WHERE ld.origen_modulo = 'COMS'
INSERT MFAPolizaEntidad (Empresa,   Poliza,   PolizaID,   Modulo, ModuloID,                   Mov,   Categoria,   Familia,   Grupo, EntidadTipo, Entidad)
SELECT  g.Empresa, g.Poliza, g.PolizaID, 'GAS',  CONVERT(int,ld.origen_id),  g.Mov, p.Categoria, p.Familia, NULL,  'Proveedor', p.Proveedor
FROM layout_documentos ld
JOIN Gasto g ON g.ID = CONVERT(int,ld.origen_id)
JOIN Prov p ON p.Proveedor = g.Acreedor
WHERE ld.origen_modulo = 'GAS'
INSERT MFAPolizaEntidad (Empresa,    Poliza,    PolizaID,    Modulo, ModuloID,                   Mov,    Categoria,   Familia,   Grupo,   EntidadTipo, Entidad)
SELECT  cx.Empresa, cx.Poliza, cx.PolizaID, 'CXC',  CONVERT(int,ld.origen_id),  cx.Mov, c.Categoria, c.Familia, c.Grupo, 'Cliente',   c.Cliente
FROM layout_documentos ld
JOIN Cxc cx ON cx.ID = CONVERT(int,ld.origen_id)
JOIN Cte c ON c.Cliente = cx.Cliente
WHERE ld.origen_modulo = 'CXC'
INSERT MFAPolizaEntidad (Empresa,    Poliza,    PolizaID,    Modulo, ModuloID,                   Mov,    Categoria,   Familia,   Grupo,   EntidadTipo, Entidad)
SELECT  cx.Empresa, cx.Poliza, cx.PolizaID, 'CXP',  CONVERT(int,ld.origen_id),  cx.Mov, p.Categoria, p.Familia, NULL,    'Proveedor', p.Proveedor
FROM layout_documentos ld
JOIN Cxp cx ON cx.ID = CONVERT(int,ld.origen_id)
JOIN Prov p ON p.Proveedor = cx.Proveedor
WHERE ld.origen_modulo = 'CXP'
PRINT 'Fin inserts MFAPolizaEntidad: ' + CONVERT(varchar,getdate(),126)
UPDATE MFAPolizaEntidad
SET Cuenta = dbo.fnMFAObtenerCuentaEntidad(Modulo,Mov,Categoria,Grupo,Familia,Entidad,EntidadTipo,Empresa, Poliza, PolizaID)
PRINT 'Fin update MFAPolizaEntidad: ' + CONVERT(varchar,getdate(),126)
UPDATE layout_documentos
SET entidad_cuenta_contable = mpe.Cuenta
FROM layout_documentos ld
JOIN MFAPolizaEntidad mpe ON mpe.ModuloID = CONVERT(int,ld.origen_id) AND mpe.Modulo = ld.origen_modulo
PRINT 'Fin update layout_documentos entidad: ' + CONVERT(varchar,getdate(),126)
RETURN
END

