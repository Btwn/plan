SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER VIEW ArtSubReservadoOpcion

AS
SELECT
s.Sucursal,
s.Rama,
s.Moneda,
s.Empresa,
s.Cuenta Articulo,
s.SubCuenta,
s.Grupo Almacen,
s.SubGrupo,
sum(s.SaldoU) Reservado
FROM SaldoUOpcion s
JOIN Rama r ON s.Rama=r.Rama and r.Rama='RESV'
GROUP BY
s.Sucursal, s.Rama, s.Moneda, s.Empresa, s.Cuenta, s.SubCuenta, s.Grupo, s.SubGrupo

