SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER VIEW POSCierreDia

AS
SELECT ROW_NUMBER() OVER(ORDER BY Venta.FechaEmision )  ID,
Venta.Empresa, Venta.FechaEmision, Venta.Moneda, Venta.Almacen, Venta.Sucursal
FROM  Venta Venta WITH(NOLOCK) JOIN MovTipo MovTipo WITH(NOLOCK) ON MovTipo.Mov = Venta.Mov AND MovTipo.Modulo = 'VTAS'
WHERE Venta.Estatus='PROCESAR' AND MovTipo.Clave IN ('VTAS.N', 'VTAS.NR')
GROUP BY   Venta.FechaEmision,   Venta.Moneda,   Venta.Almacen,   Venta.Sucursal, Venta.Empresa

