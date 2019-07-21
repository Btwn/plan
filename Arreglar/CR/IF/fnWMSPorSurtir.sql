SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER FUNCTION fnWMSPorSurtir (@Tarima varchar(20))
RETURNS TABLE
AS
RETURN (
SELECT x.Articulo, SUM(x.Cantidad) Cantidad
FROM(
SELECT d.Articulo, SUM(ISNULL(NULLIF(ISNULL(d.CantidadPendiente, 0.00) + ISNULL(d.CantidadReservada, 0.00),0.00),d.Cantidad - ISNULL(d.CantidadCancelada, 0.00) * CASE	WHEN v.Estatus = 'CANCELADO' THEN 0 ELSE 1 END)) Cantidad
FROM VentaD d
JOIN Venta v ON v.ID = d.ID
JOIN WMSModuloMovimiento w ON w.Modulo = 'VTAS' AND w.Movimiento = v.Mov
WHERE d.Tarima = @Tarima
AND v.Estatus <> 'SINAFECTAR'
GROUP BY d.Articulo
UNION ALL
SELECT d.Articulo, SUM(ISNULL(NULLIF(ISNULL(d.CantidadPendiente, 0.00) + ISNULL(d.CantidadReservada, 0.00),0.00),d.Cantidad - ISNULL(d.CantidadCancelada, 0.00) * CASE	WHEN v.Estatus = 'CANCELADO' THEN 0 ELSE 1 END)) Cantidad
FROM InvD d
JOIN Inv v ON v.ID = d.ID
JOIN WMSModuloMovimiento w ON w.Modulo = 'INV' AND w.Movimiento = v.Mov
WHERE d.Tarima = @Tarima
AND v.Estatus <> 'SINAFECTAR'
GROUP BY d.Articulo
UNION ALL
SELECT d.Articulo, SUM(ISNULL(NULLIF(ISNULL(d.CantidadPendiente, 0.00),0.00),d.Cantidad - ISNULL(d.CantidadCancelada, 0.00) * CASE	WHEN v.Estatus = 'CANCELADO' THEN 0 ELSE 1 END)) Cantidad
FROM CompraD d
JOIN Compra v ON v.ID = d.ID
JOIN WMSModuloMovimiento w ON w.Modulo = 'COMS' AND w.Movimiento = v.Mov
WHERE d.Tarima = @Tarima
AND v.Estatus <> 'SINAFECTAR'
GROUP BY d.Articulo
) x
GROUP BY x.Articulo
)

