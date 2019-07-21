SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER VIEW CFDSorianaCajaTarima AS
SELECT
REPLICATE('0',20-LEN(RTRIM(LTRIM(CONVERT(varchar,SorianaCajasTarimas.ID))))) + RTRIM(LTRIM(CONVERT(varchar,SorianaCajasTarimas.ID))) +
REPLICATE(' ',12) +
REPLICATE(' ',7) +
REPLICATE(' ',50)
OrdenExportacion,
SorianaCajasTarimas.ID ID,
SorianaCajasTarimas.Proveedor SorianaProveedor,
SorianaCajasTarimas.Remision SorianaRemision,
SorianaCajasTarimas.NumeroCajaTarima SorianaNoCajaTarima,
SorianaCajasTarimas.CodigoBarraCajaTarima SorianaCodigoCaja,
SorianaCajasTarimas.SucursalDistribuir SorianaSucursalDistribuir,
CONVERT(Decimal(20,0), SorianaCajasTarimas.CantidadArticulos) SorianaCantidadArticulos
FROM SorianaCajasTarimas

