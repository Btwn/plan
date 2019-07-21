SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER VIEW ArtSubExistenciaReservadoOpcion

AS
SELECT e.Sucursal,
e.Rama,
e.Moneda,
e.Empresa,
e.Articulo,
e.SubCuenta,
e.Almacen,
e.SubGrupo,
"Existencias" = e.Existencia,
r.Reservado Reservado,
ar.Remisionado,
(ISNULL(e.Existencia, 0.0)-ISNULL(r.Reservado, 0.0)) Disponible
FROM ArtSubExistenciaConsigOpcion e
LEFT OUTER JOIN ArtSubReservadoOpcion r ON e.Empresa = r.Empresa AND e.Articulo = r.Articulo AND e.SubCuenta = r.SubCuenta AND e.Almacen = r.Almacen AND NULLIF(RTRIM(e.Almacen), '') IS NOT NULL
LEFT OUTER JOIN ArtSubRemisionado ar ON e.Empresa = ar.Empresa AND e.Articulo = ar.Articulo AND e.SubCuenta = ar.SubCuenta AND e.Almacen = ar.Almacen

