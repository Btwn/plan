SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER VIEW ProyectoDArtMaterialExplotado
AS
SELECT
pdam.ID,
pdam.Actividad,
CASE a.EsFormula WHEN 0 THEN pdam.Material ELSE am.Material END Material,
CASE a.EsFormula WHEN 0 THEN ISNULL(pdam.SubCuenta,'') ELSE ISNULL(am.SubCuenta,'') END SubCuenta,
CASE a.EsFormula WHEN 0 THEN ISNULL(pdam.Cantidad,0.0) ELSE ISNULL(pdam.Cantidad,0.0)*ISNULL(am.Cantidad,0.0) END Cantidad,
CASE a.EsFormula WHEN 0 THEN pdam.Unidad ELSE am.Unidad END Unidad,
CASE a.EsFormula WHEN 0 THEN pdam.Almacen ELSE am.Almacen END Almacen,
a.EsFormula
FROM ProyectoDArtMaterial pdam WITH(NOLOCK) JOIN Art a WITH(NOLOCK)
ON a.Articulo = pdam.Material LEFT OUTER JOIN ArtMaterial am WITH(NOLOCK)
ON a.Articulo = am.Articulo
WHERE PATINDEX('%' + ISNULL(am.SiOpcion,'') + '%',ISNULL(pdam.SubCuenta,'')) > 0

