SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER VIEW eCommerceArtSubExistenciaInvSucursal

AS
SELECT a.Articulo , a.SubCuenta, SUM(a.Disponible)Inventario, s.Sucursal, a.Almacen
FROM ArtAlmSubDisponible a WITH (NOLOCK)
JOIN Alm s WITH (NOLOCK) ON a.Almacen = s.Almacen
GROUP BY   a.Articulo , a.SubCuenta, s.Sucursal, a.Almacen

