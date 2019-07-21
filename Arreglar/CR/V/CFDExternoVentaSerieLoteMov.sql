SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER VIEW CFDExternoVentaSerieLoteMov AS
SELECT
REPLICATE('0',20-LEN(RTRIM(LTRIM(CONVERT(varchar,ID))))) + RTRIM(LTRIM(CONVERT(varchar,ID))) +
REPLICATE('0',12-LEN(RTRIM(LTRIM(CONVERT(varchar,Renglon))))) + RTRIM(LTRIM(CONVERT(varchar,Renglon))) +
REPLICATE('0',7-LEN(RTRIM(LTRIM(CONVERT(varchar,RenglonSub))))) + RTRIM(LTRIM(CONVERT(varchar,RenglonSub))) +
RTRIM(SerieLote) + REPLICATE (' ', 50 - LEN(RTRIM(SerieLote)))
OrdenExportacion,
ID,
Renglon,
RenglonSub,
SerieLote,
Cantidad,
Propiedades,
Ubicacion,
Localizacion,
ArtCostoInv,
Fecha1,
Fecha2,
Fecha3,
PedimentoClave,
PedimentoRegimen,
AgenteAduanal,
Aduana,
PedimentoTipo,
AduanaGLN
FROM CFDExtVentaSerieLoteMov

