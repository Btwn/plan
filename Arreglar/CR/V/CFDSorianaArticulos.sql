SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER VIEW CFDSorianaArticulos AS
SELECT
REPLICATE('0',20-LEN(RTRIM(LTRIM(CONVERT(varchar,SorianaArticulos.ID))))) + RTRIM(LTRIM(CONVERT(varchar,SorianaArticulos.ID))) +
REPLICATE(' ',12) +
REPLICATE(' ',7) +
REPLICATE(' ',50)
OrdenExportacion,
SorianaArticulos.ID ID,
SorianaArticulos.Proveedor SorianaProveedor,
SorianaArticulos.Remision SorianaRemision,
SorianaArticulos.FolioPedido SorianaFolioPedido,
SorianaArticulos.Tienda SorianaTienda,
SorianaArticulos.Codigo SorianaCodigo,
convert(decimal (20,0),CantidadUnidadCompra) SorianaCantidadUnidadCompra,
convert(money,CostoNetoUnidadCompra) SorianaCostoNetoUnidadCompra,
convert(decimal (20,2),PorcentajeIEPS) SorianaPorcentajeIEPS,
convert(decimal (20,2),PorcentajeIVA) SorianaPorcentajeIVA
FROM SorianaArticulos

