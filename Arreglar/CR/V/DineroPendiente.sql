SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER VIEW DineroPendiente

AS
SELECT
b.ID,
b.Empresa,
b.Mov,
b.MovID,
b.Moneda,
b.Referencia,
b.CtaDinero,
b.Importe,
b.Saldo,
b.FechaEmision,
b.FechaProgramada,
b.Estatus,
b.Sucursal,
b.FormaPago,
"Dias"  = datediff(day, b.FechaProgramada, GETDATE()),
mt.Clave MovTipo
FROM Dinero b
JOIN MovTipo mt ON b.Mov = mt.Mov AND mt.Modulo = 'DIN'
WHERE b.Estatus = 'PENDIENTE'

