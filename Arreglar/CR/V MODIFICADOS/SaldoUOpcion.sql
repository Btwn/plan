SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER VIEW SaldoUOpcion

AS
SELECT u.Sucursal,
u.Empresa,
u.Rama,
u.Moneda,
u.Grupo,
u.SubGrupo,
u.Cuenta,
u.SubCuenta,
SUM(ISNULL(u.Cargo,0.00) - ISNULL(u.Abono,0.00)) Saldo,
SUM(ISNULL(u.CargoU,0.00) - ISNULL(u.AbonoU,0.00)) SaldoU,
CASE WHEN ISNULL(u.Conciliado,0) = 1 THEN SUM(ISNULL(u.Cargo,0.00) - ISNULL(u.Abono,0.00)) ELSE 0 END PorConciliar,
CASE WHEN ISNULL(u.Conciliado,0) = 1 THEN SUM(ISNULL(u.CargoU,0.00) - ISNULL(u.AbonoU,0.00)) ELSE 0 END PorConciliarU,
o.A, o.B, o.C, o.D, o.E, o.F, o.G, o.H, o.I, o.J, o.K, o.L, o.M, o.N, o.O, o.P, o.Q, o.R, o.S, o.T, o.W, o.X, o.Y, o.Z
FROM AuxiliarU u WITH(NOLOCK) LEFT OUTER JOIN MovOpcion o WITH(NOLOCK)
ON u.Modulo = o.Modulo AND u.ModuloID = o.ModuloID AND u.Renglon = o.Renglon AND u.RenglonSub = o.RenglonSub
GROUP BY u.Sucursal, u.Empresa, u.Rama, u.Moneda, u.Grupo, u.SubGrupo, u.Cuenta, u.SubCuenta, u.Conciliado,
o.A, o.B, o.C, o.D, o.E, o.F, o.G, o.H, o.I, o.J, o.K, o.L, o.M, o.N, o.O, o.P, o.Q, o.R, o.S, o.T, o.W, o.X, o.Y, o.Z

