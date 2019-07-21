SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER VIEW ArtDisponible

AS
SELECT
s.Empresa Empresa,
s.Cuenta Articulo,
s.Grupo Almacen,
Sum(s.SaldoU*r.Factor) Disponible,
Sum(adt.Apartado) Apartado,
Sum(s.SaldoU*r.Factor)-ISNULL(SUM(adt.Apartado),0) DispMenosApartado
FROM SaldoU s
JOIN Rama r ON s.Rama=r.Rama
LEFT OUTER JOIN ArtDisponibleTarima adt ON s.Cuenta = adt.Articulo AND s.Grupo = adt.Almacen
WHERE r.Mayor='INV'
GROUP BY
s.Empresa, s.Cuenta, s.Grupo

