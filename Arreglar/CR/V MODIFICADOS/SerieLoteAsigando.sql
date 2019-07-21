SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER VIEW SerieLoteAsigando

AS
SELECT s.Empresa,
s.Articulo,
s.SubCuenta,
s.Almacen,
s.Cliente,
SUM(s.Existencia) Existencia,
SUM(s.ExistenciaAlterna) ExistenciaAlterna,
c.Nombre
FROM SerieLote s WITH(NOLOCK)
LEFT OUTER JOIN Cte c WITH(NOLOCK) ON s.Cliente=c.Cliente
GROUP BY s.Empresa, s.Articulo, s.SubCuenta, s.Almacen, s.Cliente, c.Nombre

