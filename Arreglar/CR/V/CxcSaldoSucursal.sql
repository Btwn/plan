SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER VIEW CxcSaldoSucursal

AS
SELECT
s.Empresa,
s.Sucursal,
s.Moneda,
s.Cuenta Cliente,
Convert(money, Sum(s.Saldo*r.Factor)) Saldo
FROM Saldo s
JOIN Rama r ON s.Rama=r.Rama AND r.Mayor='CXC'
GROUP BY
s.Empresa, s.Sucursal, s.Moneda, s.Cuenta

