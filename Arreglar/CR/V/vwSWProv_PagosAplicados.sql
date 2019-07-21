SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER VIEW vwSWProv_PagosAplicados
AS
SELECT
RTRIM(CxP.Id) ID,
RTRIM(CxP.Mov) Mov,
RTRIM(CxP.MovID) MovID,
(RTRIM(CxP.Mov) + ' ' + RTrim(CxP.MovID)) as Movimiento,
RTRIM(CxP.Referencia) Referencia,
CxP.FechaEmision,
RTRIM(CxPD.Aplica) Aplica,
RTRIM(CxPD.AplicaID) AplicaID,
CxPD.Importe AS Saldo,
CxP.Impuestos,
Total = (CxPD.Importe + CxP.Impuestos),
RTRIM(CxP.Moneda) AS Moneda,
CxP.Empresa,
CxP.Proveedor,
Cxp.Estatus
FROM CxP
JOIN Prov ON Prov.Proveedor = Cxp.Proveedor
LEFT OUTER JOIN CxPD ON Cxp.ID = CxpD.ID
WHERE CxP.Estatus = 'CONCLUIDO'

