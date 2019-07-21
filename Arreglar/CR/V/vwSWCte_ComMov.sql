SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER VIEW vwSWCte_ComMov
AS
SELECT
ID,
MovID,
(RTrim(Mov) + ' ' + RTrim(MovID)) as Movimiento,
Proyecto,
UEN,
Moneda + ' (' + cast(TipoCambio as varchar(10)) + ')' Moneda,
FechaEmision,
CASE WHEN MovClave = 'VTAS.F'
THEN (Importe * ((100 - ISNULL(DescuentoGlobal, 0)) / 100))
ELSE (Importe * ((100 - ISNULL(DescuentoGlobal, 0)) / 100) * -1) END Saldo,
CASE WHEN MovClave = 'VTAS.F'
THEN ISNULL(Impuestos, 0) ELSE (ISNULL(Impuestos, 0) *-1) END Impuestos,
CASE WHEN MovClave = 'VTAS.F'
THEN (Importe * ((100 - ISNULL(DescuentoGlobal, 0)) / 100))
ELSE (Importe * ((100 - ISNULL(DescuentoGlobal, 0)) / 100) * -1) END  +
CASE WHEN MovClave = 'VTAS.F' THEN ISNULL(Impuestos, 0)
ELSE (ISNULL(Impuestos, 0) *-1) END Total,
Cliente,
Empresa
FROM VentaUtil

