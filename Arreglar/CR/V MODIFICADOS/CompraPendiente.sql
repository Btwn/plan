SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER VIEW CompraPendiente

AS
SELECT
c.ID,
c.Empresa,
c.Mov,
c.MovID,
c.Moneda,
c.FechaEmision,
c.FechaRequerida,
c.Referencia,
c.Estatus,
c.Proveedor,
c.Importe,
c.DescuentoGlobal,
c.Almacen,
"SubTotal"= Convert(money, (c.Importe*(100-ISNULL(c.DescuentoGlobal, 0.0))/100)),
c.Impuestos,
"Total"= CONVERT(money, (c.Importe*(100-c.DescuentoGlobal)/100) + c.Impuestos),
c.Saldo,
mt.Clave,
c.Proyecto,
c.UEN
FROM Compra c WITH (NOLOCK)
JOIN MovTipo mt WITH (NOLOCK) ON c.Mov = mt.Mov AND mt.Modulo = 'COMS'
WHERE
c.Estatus='PENDIENTE'

