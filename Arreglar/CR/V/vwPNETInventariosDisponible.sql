SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER VIEW dbo.vwPNETInventariosDisponible
AS
SELECT TOP 5 ROW_NUMBER() OVER (ORDER BY A.Articulo, D.Almacen) AS ID,
A.Articulo, A.Descripcion1, A.Categoria,  A.PrecioLista,  A.PrecioMinimo,  A.Precio2, A.Estatus, A.CostoEstandar,  D. Empresa, D.Disponible, D.Almacen
FROM Art A
JOIN ArtDisponible AS D ON A.Articulo = D.Articulo
WHERE D.Disponible <> 0 AND A.Estatus = 'ALTA'

