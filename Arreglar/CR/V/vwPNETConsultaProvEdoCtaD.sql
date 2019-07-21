SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER VIEW dbo.vwPNETConsultaProvEdoCtaD
AS
SELECT
AU.MovID AS Movimiento,
CONVERT(VARCHAR(10), AU.Fecha, 105) AS Fecha,
CONVERT(varchar(50), ISNULL(dbo.Cxp.Vencimiento, ''), 105) AS Vencimiento,
AU.Cargo,
AU.Abono,
dbo.Cxp.Saldo,
ISNULL(AU.Moneda, '') AS Moneda,
CONVERT(MONEY, ROUND(ISNULL(AU.TipoCambio, 0.00), 2)) AS TipoCambio,
ISNULL(dbo.Cxp.Estatus, '') AS Estatus,
ISNULL(dbo.Cxp.Concepto, '') AS Concepto,
AU.AplicaID, AU.Aplica,
AU.MovID,
AU.Mov,
AU.ModuloID,
P.Proveedor
FROM
dbo.EstadoCuenta AS EC INNER JOIN
dbo.Prov AS P ON P.Proveedor = EC.Cuenta LEFT OUTER JOIN
dbo.Auxiliar AS AU ON EC.AuxiliarID = AU.ID LEFT OUTER JOIN
dbo.Cxp ON dbo.Cxp.ID = AU.ModuloID LEFT OUTER JOIN
dbo.MovTipo AS MT ON MT.Modulo = AU.Modulo AND dbo.Cxp.Mov = MT.Mov
WHERE (EC.Modulo = 'CXP') AND (MT.Clave NOT IN ('CXP.EST', 'CXP.SD', 'CXP.SCH')) AND (dbo.Cxp.Estatus NOT IN ('CANCELADO'))
GROUP BY AU.Fecha, AU.Mov, AU.MovID, dbo.Cxp.Concepto, dbo.Cxp.Estatus, AU.Moneda, AU.TipoCambio, AU.Cargo, AU.Abono, dbo.Cxp.Saldo, dbo.Cxp.Vencimiento,
AU.AplicaID, AU.Aplica, AU.MovID, AU.Mov, AU.ModuloID, P.Proveedor

