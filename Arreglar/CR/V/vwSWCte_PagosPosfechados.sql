SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER VIEW vwSWCte_PagosPosfechados
AS
SELECT
CxcInfo.ID,
RTrim(CxcInfo.Mov) Mov,
RTrim(CxcInfo.MovID) MovID,
(RTrim(CxcInfo.Mov) + ' ' + RTrim(CxcInfo.MovID)) as Movimiento,
CxcInfo.FechaEmision,
CxcInfo.Vencimiento,
CxcInfo.Saldo,
CxcInfo.Cliente,
CxcInfo.Empresa,
CxcInfo.Moneda
FROM CxcInfo
WHERE
CxcInfo.ID IS NOT NULL AND
CxcInfo.Mov IN ('Cobro Posfechado')

