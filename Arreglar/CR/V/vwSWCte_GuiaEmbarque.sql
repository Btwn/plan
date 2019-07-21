SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER VIEW vwSWCte_GuiaEmbarque
AS
SELECT
Venta.ID VentaID,
(RTrim(Venta.Mov) + ' ' + RTrim(Venta.MovID)) as Movimiento,
Venta.FechaEmision,
GuiaEmbarque.Paquetes,
GuiaEmbarque.FechaEnvio,
GuiaEmbarque.PersonaRecibio,
GuiaEmbarque.FechaRecepcion,
GuiaEmbarque.Modulo,
GuiaEmbarque.ID,
GuiaEmbarque.ID GuiaEmbarqueID,
GuiaEmbarqueD.Guia,
GuiaEmbarqueD.Sucursal,
GuiaEmbarque.FormaEnvio,
GuiaEmbarqueD.ID GuiaEmbarqueDID,
Cte.Cliente,
Venta.Empresa
FROM Venta
JOIN Cte ON Venta.Cliente = Cte.Cliente
JOIN GuiaEmbarque ON Venta.ID = GuiaEmbarque.ID
JOIN GuiaEmbarqueD ON GuiaEmbarqueD.Modulo = GuiaEmbarque.Modulo AND GuiaEmbarqueD.ID = GuiaEmbarque.ID
WHERE
GuiaEmbarque.Modulo = 'VTAS'

