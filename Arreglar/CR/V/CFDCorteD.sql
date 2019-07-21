SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER VIEW CFDCorteD AS
SELECT
REPLICATE('0',20-LEN(RTRIM(LTRIM(CONVERT(varchar,CorteD.ID))))) + RTRIM(LTRIM(CONVERT(varchar,CorteD.ID))) +
REPLICATE('0',12-LEN(RTRIM(LTRIM(CONVERT(varchar,CorteD.Renglon))))) + RTRIM(LTRIM(CONVERT(varchar,CorteD.Renglon))) +
REPLICATE('0',7-LEN(RTRIM(LTRIM(CONVERT(varchar,CorteD.RenglonSub))))) + RTRIM(LTRIM(CONVERT(varchar,CorteD.RenglonSub))) +
REPLICATE(' ',50)
OrdenExportacion,
CorteD. Cuenta CorteCliente,
CorteD.ID,
CorteD.Mov Movimiento,
CorteD.MovID MovimientoFolio,
CorteD.Fecha MovimientoFecha,
CorteD.Vencimiento MovimientoVencimiento,
CorteD.Moneda MovimientoMoneda,
CorteD.Aplica MovimientoAplica,
CorteD.AplicaID MovimientoAplicaFolio,
ISNULL(CorteD.Cargo, 0) MovimientoCargo,
ISNULL(CorteD.Abono, 0) MovimientoAbono
FROM CorteD

