SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER VIEW ArtCostoEmpresaAlm

AS
SELECT
ac.Empresa,
a.Articulo,
"CostoPromedio" =	CASE WHEN ISNULL(ai.Inventario,0) = 0
THEN 0
ELSE
SUM(ISNULL(ai.Inventario,0)*ISNULL(AC.CostoPromedio,0))/SUM(ISNULL(ai.Inventario,0))
END,
"UltimoCosto" = CASE	WHEN ISNULL(ai.Inventario,0) = 0
THEN 0
ELSE
SUM(ISNULL(ai.Inventario,0)*ISNULL(AC.UltimoCosto,0) )/ SUM (ISNULL(ai.Inventario,0))
END,
"UltimoCostoSinGastos" = CASE WHEN ISNULL(ai.Inventario,0) = 0
THEN 0
ELSE
SUM(ISNULL(ai.Inventario,0)*ISNULL(AC.UltimoCostoSinGastos,0) )/ SUM (ISNULL(ai.Inventario,0))
END,
"CostoEstandar"= AVG(ISNULL(a.CostoEstandar,0)),
"CostoReposicion"= AVG(ISNULL(a.CostoReposicion,0)),
ai.Almacen
FROM  art a
JOIN ArtCosto ac on a.Articulo =ac.Articulo
JOIN ArtExistenciaInv  ai on a.Articulo =ai.Articulo
AND ac.Empresa =ai.Empresa
AND ac.Sucursal =ai.Sucursal
GROUP BY  a.Articulo,ac.Empresa,ai.Inventario, ai.Almacen

