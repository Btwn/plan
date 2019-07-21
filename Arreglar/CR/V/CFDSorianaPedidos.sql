SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER VIEW CFDSorianaPedidos AS
SELECT
REPLICATE('0',20-LEN(RTRIM(LTRIM(CONVERT(varchar,SorianaArticulos.ID))))) + RTRIM(LTRIM(CONVERT(varchar,SorianaArticulos.ID))) +
REPLICATE(' ',12) +
REPLICATE(' ',7) +
REPLICATE(' ',50)
OrdenExportacion,
SorianaArticulos.ID ID,
SorianaArticulos.Proveedor PedidosProveedor,
SorianaArticulos.Remision PedidosRemision,
SorianaArticulos.FolioPedido PedidosFolio,
SorianaArticulos.Tienda PedidosTienda,
count(distinct SorianaArticulos.Codigo)  PedidosCantidadArticulos
FROM SorianaArticulos
GROUP BY ID, Proveedor, Remision, FolioPedido, Tienda

