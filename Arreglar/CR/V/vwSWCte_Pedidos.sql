SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER VIEW vwSWCte_Pedidos
AS
SELECT DISTINCT
Venta.ID,
Venta.Mov,
Venta.MovID,
(RTrim(Venta.Mov) + ' ' + RTrim(Venta.MovID)) as Movimiento,
Venta.FechaEmision,
Moneda + ' (' + cast(TipoCambio as varchar(10)) + ')' Moneda,
Venta.Importe,
Venta.Observaciones,
Venta.Cliente,
Venta.Empresa
FROM Venta
JOIN VentaD ON VentaD.ID = Venta.ID
JOIN MovTipo ON MovTipo.Mov = Venta.Mov
WHERE
MovTipo.Clave = 'VTAS.P'
AND Venta.Estatus = 'PENDIENTE'
AND (VentaD.CantidadReservada IS NOT NULL OR VentaD.CantidadPendiente IS NOT NULL OR VentaD.CantidadOrdenada IS NOT NULL)

