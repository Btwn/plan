SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER VIEW DemandaPaquetesPromedio

AS
SELECT i.Empresa, d.Almacen, d.Articulo, "SubCuenta" = NULLIF(RTRIM(d.SubCuenta), ''), "Cantidad" = SUM(d.Cantidad), "Paquetes" = SUM(d.Paquete), "Promedio" = CONVERT(float, SUM(d.Cantidad)/NULLIF(SUM(d.Paquete), 0))
FROM InvD d WITH (NOLOCK)
JOIN Inv i WITH (NOLOCK) ON i.ID = d.ID
JOIN MovTipo mt WITH (NOLOCK) ON i.Mov = mt.Mov AND mt.Modulo = 'INV'
WHERE i.Estatus = 'PENDIENTE' AND mt.Clave = 'INV.SOL'
GROUP BY i.Empresa, d.Almacen, d.Articulo, NULLIF(RTRIM(d.SubCuenta), '')

