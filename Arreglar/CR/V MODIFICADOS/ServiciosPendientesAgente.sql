SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER VIEW ServiciosPendientesAgente

AS
SELECT d.Agente, "Cantidad" = SUM(ISNULL(d.CantidadPendiente, 0)+ISNULL(d.CantidadOrdenada, 0)), "Horas" = SUM(ISNULL(d.CantidadPendiente, 0)+ISNULL(d.CantidadOrdenada, 0)*a.Horas)
FROM VentaPendienteD d WITH(NOLOCK)
JOIN Art a WITH(NOLOCK) ON d.Articulo = a.Articulo
WHERE UPPER(a.Tipo)='SERVICIO' AND NULLIF(RTRIM(d.Agente), '') IS NOT NULL
GROUP BY d.Agente

