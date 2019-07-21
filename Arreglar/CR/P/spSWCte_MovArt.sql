SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE dbo.spSWCte_MovArt
@Empresa varchar(5),
@Cliente varchar(10),
@FechaD   Datetime,
@FechaA   Datetime
AS BEGIN
SELECT
VentaUtilD.MovClave,
Art.Articulo,
Art.Categoria,
Art.Familia,
Art.Grupo,
Art.Linea,
Art.Fabricante,
VentaUtilD.Moneda,
VentaUtilD.DescuentoGlobal,
CASE VentaUtilD.MovClave
WHEN 'CXC.NC' THEN SUM(VentaUtilD.Cantidad *-1)
WHEN 'CXC.NCD' THEN SUM(VentaUtilD.Cantidad *-1)
WHEN 'VTAS.D'  THEN SUM(VentaUtilD.Cantidad *-1)
WHEN 'VTAS.F'  THEN SUM(VentaUtilD.Cantidad)
WHEN 'VTAS.B'  THEN SUM(VentaUtilD.Cantidad *-1)
WHEN 'CXC.DV'   THEN SUM(VentaUtilD.Cantidad *-1)
END Cantidad,
CASE VentaUtilD.MovClave
WHEN 'CXC.NC'  THEN SUM(VentaUtilD.Importe *-1)
WHEN 'CXC.NCD' THEN SUM(VentaUtilD.Importe *-1)
WHEN 'VTAS.D'  THEN SUM(VentaUtilD.Importe *-1)
WHEN 'VTAS.F'  THEN SUM(VentaUtilD.Importe)
WHEN 'VTAS.B'  THEN SUM(VentaUtilD.Importe *-1)
WHEN 'CXC.DV'   THEN SUM(VentaUtilD.Importe *-1)
END Saldo,VentaUtilD.Cliente
FROM Art WITH(NOLOCK, INDEX(priArt)) JOIN VentaUtilD WITH(NOLOCK) ON Art.Articulo = VentaUtilD.Articulo
WHERE
Importe IS NOT NULL
AND VentaUtilD.Empresa = @Empresa
AND VentaUtilD.Cliente = @Cliente
AND VentaUtilD.FechaEmision BETWEEN @FechaD AND @FechaA
GROUP BY VentaUtilD.Mov, Art.Articulo, Art.Familia, Art.Categoria, Art.Grupo, Art.Linea, Art.Fabricante, VentaUtilD.Moneda, VentaUtilD.MovClave, VentaUtilD.DescuentoGlobal, VentaUtilD.Cliente
ORDER BY Mov ASC
RETURN
END

