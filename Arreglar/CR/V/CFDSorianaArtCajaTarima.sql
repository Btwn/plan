SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER VIEW CFDSorianaArtCajaTarima AS
SELECT
REPLICATE('0',20-LEN(RTRIM(LTRIM(CONVERT(varchar,SorianaArtCajaTarima.ID))))) + RTRIM(LTRIM(CONVERT(varchar,SorianaArtCajaTarima.ID))) +
REPLICATE(' ',12) +
REPLICATE(' ',7) +
REPLICATE(' ',50)
OrdenExportacion,
SorianaArtCajaTarima.ID ID,
SorianaArtCajaTarima.Proveedor SorianaProveedor,
SorianaArtCajaTarima.Remision SorianaRemision,
SorianaArtCajaTarima.FolioPedido SorianaFolioPedido,
SorianaArtCajaTarima.NumeroCajaTarima SorianaNoCaja,
SorianaArtCajaTarima.SucursalDistribuir SorianaSucursalDistribuir,
SorianaArtCajaTarima.Codigo SorianaCodigo,
CONVERT(Decimal(20,0), SorianaArtCajaTarima.CantidadUnidadCompra) SorianaCantidadUnidadCompra
FROM SorianaArtCajaTarima

