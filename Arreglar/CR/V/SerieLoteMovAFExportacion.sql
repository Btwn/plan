SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER VIEW SerieLoteMovAFExportacion AS
SELECT
REPLICATE('0',20-LEN(RTRIM(LTRIM(CONVERT(varchar,ActivoFijoD.ID))))) + RTRIM(LTRIM(CONVERT(varchar,ActivoFijoD.ID))) +
REPLICATE('0',12-LEN(RTRIM(LTRIM(CONVERT(varchar,ActivoFijoD.Renglon))))) + RTRIM(LTRIM(CONVERT(varchar,ActivoFijoD.Renglon))) +
REPLICATE('0',7-LEN(RTRIM(LTRIM(CONVERT(varchar,ActivoFijoD.RenglonSub))))) + RTRIM(LTRIM(CONVERT(varchar,ActivoFijoD.RenglonSub))) +
RTRIM(SerieLoteMov.SerieLote)
OrdenExportacion,
SerieLoteMov.*
FROM SerieLoteMov JOIN ActivoFijoD
ON SerieLoteMov.ID = ActivoFijoD.ID AND SerieLoteMov.RenglonID = ActivoFijoD.Renglon
WHERE SerieLoteMov.Modulo = 'AF'

