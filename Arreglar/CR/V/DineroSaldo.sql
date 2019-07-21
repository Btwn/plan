SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER VIEW DineroSaldo

AS
SELECT
s.Empresa,
s.Moneda,
s.Cuenta CtaDinero,
Convert(money, Sum(s.Saldo*r.Factor)) Saldo,
Convert(money, Sum(s.PorConciliar*r.Factor)) PorConciliar,
Convert(money, Sum(ISNULL(s.Saldo, 0.0)-ISNULL(s.PorConciliar, 0.0)*r.Factor)) SaldoConciliado
FROM Saldo s
JOIN Rama r ON s.Rama=r.Rama and r.Mayor='DIN'
GROUP BY
s.Empresa, s.Moneda, s.Cuenta

