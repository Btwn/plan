SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER VIEW vwSWCte_EdoCuenta
AS
SELECT
CxcAux.ModuloID ID,
RTrim(CxcAux.Mov) Mov,
CxcAux.MovID,
(RTrim(CxcAux.Mov) + ' ' + RTrim(CxcAux.MovID)) as Movimiento,
CxcAux.Fecha,
CxcAux.Cargo,
CxcAux.Abono,
RTrim(Moneda) Moneda,
CxcAux.EsCancelacion,
CxcAux.Cliente,
CxcAux.Empresa
FROM CxcAux
WHERE CxcAux.ModuloID IS NOT NULL

