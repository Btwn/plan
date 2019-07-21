SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER VIEW dbo.vwPNETConsultaCteEdoCtaD
AS
SELECT C.Cliente, AU.MovID AS Movimiento, CONVERT(VARCHAR(10), AU.Fecha, 105) AS Fecha, CONVERT(varchar(50), ISNULL(CXC.Vencimiento, ''), 105) AS Vencimiento,
AU.Cargo, AU.Abono, CXC.Saldo, ISNULL(AU.Moneda, '') AS Moneda, CONVERT(MONEY, ROUND(ISNULL(AU.TipoCambio, 0.00), 2)) AS TipoCambio,
ISNULL(CXC.Estatus, '') AS Estatus, ISNULL(CXC.Concepto, '') AS Concepto, AU.AplicaID, AU.Aplica, AU.MovID, AU.Mov, AU.ModuloID
FROM dbo.EstadoCuenta AS EC INNER JOIN
dbo.Cte AS C ON EC.Cuenta = C.Cliente LEFT OUTER JOIN
dbo.Auxiliar AS AU ON EC.AuxiliarID = AU.ID LEFT OUTER JOIN
dbo.Cxc AS CXC ON CXC.ID = AU.ModuloID LEFT OUTER JOIN
dbo.MovTipo AS MT ON MT.Modulo = AU.Modulo AND CXC.Mov = MT.Mov
WHERE (EC.Modulo = 'CXC') AND (MT.Clave NOT IN ('CXC.EST', 'CXC.SD', 'CXC.SCH')) AND (CXC.Estatus NOT IN ('CANCELADO'))
GROUP BY AU.Fecha, AU.Mov, AU.MovID, CXC.Concepto, CXC.Estatus, AU.Moneda, AU.TipoCambio, AU.Cargo, AU.Abono, CXC.Saldo, CXC.Vencimiento, AU.AplicaID, AU.Aplica,
AU.MovID, AU.Mov, AU.ModuloID, C.Cliente

