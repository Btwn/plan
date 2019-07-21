SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER VIEW vwSWCte_PagosAplicados
AS
SELECT
Cxc.ID,
Cxc.Mov,
Cxc.MovID,
(RTrim(Cxc.Mov) + ' ' + RTrim(Cxc.MovID)) as Movimiento,
Cte.NombreCorto,
Cxc.Referencia,
Cxc.FechaEmision,
CxcD.Aplica,
CxcD.AplicaID,
CxcD.Importe AS Saldo,
CxC.Moneda,
Cxc.Cliente,
Cxc.Empresa
FROM Cxc JOIN CxcD ON Cxc.ID = CxcD.ID
JOIN Cte ON Cte.Cliente = Cxc.Cliente
WHERE Cxc.Estatus = 'CONCLUIDO'

