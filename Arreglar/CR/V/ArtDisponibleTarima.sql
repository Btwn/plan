SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER VIEW ArtDisponibleTarima

AS
SELECT
s.Empresa Empresa,
s.Cuenta Articulo,
s.Grupo Almacen,
s.SubGrupo Tarima,
Sum(s.SaldoU*r.Factor) Disponible,
Sum(ISNULL(a.Apartado,0)*r.Factor) Apartado
FROM SaldoUWMS s
JOIN Rama r ON s.Rama=r.Rama
LEFT JOIN ArtApartadoTarima a ON s.Empresa = a.Empresa AND s.Grupo = a.Almacen AND s.SubGrupo = a.Tarima AND s.Cuenta = a.Articulo
WHERE r.Mayor='WMS'
GROUP BY
s.Empresa, s.Cuenta, s.Grupo, s.SubGrupo
UNION ALL 
SELECT Empresa, Articulo, Almacen, Tarima, SaldoU, 0  FROM ArtSaldoUSinTarima WHERE SaldoU>0

