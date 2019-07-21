SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER VIEW ArtSubDisponibleTarima

AS
SELECT
s.Empresa Empresa,
s.Cuenta Articulo,
s.SubCuenta SubCuenta,
s.Grupo Almacen,
s.SubGrupo Tarima,
Sum(s.SaldoU*r.Factor) Disponible
FROM
SaldoUGral s
JOIN Rama r ON s.SubCuenta is NOT NULL and s.Rama=r.Rama and r.Mayor = 'WMS'
GROUP BY
s.Empresa, s.Cuenta, s.Grupo, s.SubGrupo, s.SubCuenta

