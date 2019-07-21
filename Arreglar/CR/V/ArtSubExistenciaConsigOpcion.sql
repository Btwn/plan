SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER VIEW ArtSubExistenciaConsigOpcion

AS
SELECT
s.Sucursal,
s.Rama,
s.Moneda,
s.Empresa,
s.Cuenta Articulo,
s.SubCuenta SubCuenta,
s.Grupo Almacen,
s.SubGrupo,
Sum(s.SaldoU*r.Factor) Existencia
FROM SaldoUOpcion s
JOIN Rama r ON s.Rama=r.Rama and r.Mayor IN ('INV','PZA') and r.Rama <> 'RESV'
GROUP BY
s.Sucursal, s.Rama, s.Moneda, s.Empresa, s.Cuenta, s.Grupo, s.SubCuenta, s.SubGrupo

