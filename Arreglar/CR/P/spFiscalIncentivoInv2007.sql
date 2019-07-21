SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spFiscalIncentivoInv2007
@Empresa		char(5)

AS BEGIN
CREATE TABLE #Reporte (
ID		int		NOT NULL IDENTITY(1,1) PRIMARY KEY,
Modulo		varchar(5)	NULL,
ModuloID	int		NULL,
Mov		varchar(20)	NULL,
MovID		varchar(20)	NULL,
FechaEmision	datetime	NULL,
Proveedor	varchar(10)	NULL,
Cliente		varchar(10)	NULL,
Articulo	varchar(20)	NULL,
Cantidad	float		NULL,
Unidad		varchar(50)	NULL,
CompraMN	money		NULL,
VentaMN		money		NULL,
CxpMN		money		NULL)
INSERT #Reporte (
Modulo, ModuloID, Mov,   MovID,   FechaEmision,   Proveedor,   Articulo,   Cantidad,   Unidad,   CompraMN)
SELECT 'COMS', c.ID,     c.Mov, c.MovID, c.FechaEmision, c.Proveedor, c.Articulo, c.Cantidad, c.Unidad, SUM(c.SubTotal*c.TipoCambio)
FROM CompraTCalc c
JOIN MovTipo mt ON mt.Modulo = 'COMS' AND mt.Mov = c.Mov AND mt.Clave IN ('COMS.F', 'COMS.FL', 'COMS.EG', 'COMS.EI')
WHERE c.Empresa = @Empresa AND c.Estatus IN ('PENDIENTE', 'CONCLUIDO') AND YEAR(c.FechaEmision) = 2007 AND MONTH(c.FechaEmision) BETWEEN 11 AND 12
GROUP BY c.FechaEmision, c.ID, c.Mov, c.MovID, c.Proveedor, c.Articulo, c.Cantidad, c.Unidad
ORDER BY c.FechaEmision, c.ID, c.Mov, c.MovID, c.Proveedor, c.Articulo, c.Cantidad, c.Unidad
INSERT #Reporte (
Modulo, ModuloID, Mov,   MovID,   FechaEmision,   Cliente,   Articulo,   Cantidad,   Unidad,   VentaMN)
SELECT 'VTAS', c.ID,     c.Mov, c.MovID, c.FechaEmision, c.Cliente, c.Articulo, c.Cantidad, c.Unidad, SUM(c.SubTotal*dbo.fnFactorFiscal(mt.FactorFiscalEsp,mt.FactorFiscal,mt.Factor)*c.TipoCambio) 
FROM VentaTCalc c
JOIN MovTipo mt ON mt.Modulo = 'VTAS' AND mt.Mov = c.Mov AND mt.Clave IN ('VTAS.F','VTAS.FAR', 'VTAS.D', 'VTAS.DF', 'VTAS.B')
JOIN #Reporte r ON r.Articulo = c.Articulo AND r.Modulo = 'COMS'
WHERE c.Empresa = @Empresa AND c.Estatus IN ('PENDIENTE', 'CONCLUIDO') AND YEAR(c.FechaEmision) = 2007 AND MONTH(c.FechaEmision) BETWEEN 11 AND 12
GROUP BY c.FechaEmision, c.ID, c.Mov, c.MovID, c.Cliente, c.Articulo, c.Cantidad, c.Unidad
ORDER BY c.FechaEmision, c.ID, c.Mov, c.MovID, c.Cliente, c.Articulo, c.Cantidad, c.Unidad
UPDATE #Reporte
SET CxpMN = dbo.fnR3(c.Importe+ISNULL(c.Impuestos, 0.0)-ISNULL(c.Retencion, 0.0), c.Saldo, c.Importe)*c.TipoCambio
FROM #Reporte r
JOIN Cxp c ON c.Empresa = @Empresa AND c.Estatus IN ('PENDIENTE', 'CONCLUIDO')
WHERE r.Mov = c.Mov AND r.MovID = c.MovID AND r.Modulo = 'COMS'
/*  INSERT #Reporte (
Modulo, ModuloID, Mov,   MovID,   FechaEmision,   Proveedor,  CxpMN)
SELECT 'CXP', c.ID,      c.Mov, c.MovID, c.FechaEmision, c.Proveedor, SUM(c.Saldo*c.TipoCambio)
FROM Cxp c
JOIN #Reporte r ON r.Mov = c.Mov AND r.MovID = c.MovID AND r.Modulo = 'COMS'
WHERE c.Empresa = @Empresa AND c.Estatus IN ('PENDIENTE', 'CONCLUIDO')
GROUP BY c.FechaEmision, c.ID, c.Mov, c.MovID, c.Proveedor
ORDER BY c.FechaEmision, c.ID, c.Mov, c.MovID, c.Proveedor
*/
SELECT r.ID, r.Modulo, r.Mov, r.MovID, r.FechaEmision, r.Proveedor, 'ProveedorNombre' = p.Nombre, 'ProveedorRFC' = p.RFC, r.Cliente, 'ClienteNombre' = c.Nombre, 'ClienteRFC' = c.RFC, r.Articulo, 'ArticuloDescripcion' = a.Descripcion1, r.Cantidad, r.Unidad, r.CompraMN, r.VentaMN, r.CxpMN
FROM #Reporte r
LEFT OUTER JOIN Cte c ON c.Cliente = r.Cliente
LEFT OUTER JOIN Prov p ON p.Proveedor = r.Proveedor
LEFT OUTER JOIN Art a ON a.Articulo = r.Articulo
ORDER BY r.ID
RETURN
END

