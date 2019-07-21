SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER VIEW vwSWCte_ComprasPendientes
AS
SELECT
v.ID,
(RTrim(v.Mov) + ' ' + RTrim(MovID)) as Movimiento,
v.FechaEmision,
v.Moneda + ' (' + cast(v.TipoCambio as varchar(10)) + ')' Moneda,
CONVERT(money, dbo.fnSubTotal(v.Importe, v.DescuentoGlobal, v.SobrePrecio)) SubTotal,
v.Impuestos,
((CONVERT(money, dbo.fnSubTotal(v.Importe, v.DescuentoGlobal, v.SobrePrecio))) + v.Impuestos) AS Total,
ISNULL(Saldo, 0.00) Saldo,
v.Cliente,
v.Empresa
FROM
Venta v JOIN MovTipo mt ON mt.Modulo = 'VTAS' AND mt.Mov = v.Mov
WHERE
v.Estatus = 'PENDIENTE'

