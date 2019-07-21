SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER VIEW ArtSubExistenciaConsigAF

AS
SELECT
s.Empresa Empresa,
s.Cuenta Articulo,
s.SubCuenta SubCuenta,
s.Grupo Almacen,
Sum(s.SaldoU*r.Factor) Existencia
FROM SaldoU s
JOIN Rama r ON s.Rama=r.Rama AND r.Rama IN ('INV', 'CSG', 'GAR', 'VMOS', 'AF')
GROUP BY
s.Empresa, s.Cuenta, s.Grupo, s.SubCuenta

