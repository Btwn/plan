SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spVentaCteD
@Estacion		int,
@Empresa		char(5),
@Cliente		char(10),
@FechaD		datetime,
@FechaA		datetime

AS BEGIN
DELETE VentaCteDLista WHERE Estacion = @Estacion
INSERT VentaCteDLista (Estacion, ID, Renglon, RenglonSub, Cantidad, Estatus)
SELECT /*TOP 1000 */@Estacion, d.ID, d.Renglon, ISNULL(d.RenglonSub, 0), d.Cantidad, 0
FROM Venta v, VentaD d
WHERE v.ID = d.ID
AND v.Empresa = @Empresa
AND v.Cliente = @Cliente
AND v.FechaEmision BETWEEN @FechaD AND @FechaA
AND d.RenglonTipo NOT IN ('C', 'E')  
ORDER BY v.ID DESC
END

