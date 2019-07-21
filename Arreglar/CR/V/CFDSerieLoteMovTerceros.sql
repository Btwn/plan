SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER VIEW CFDSerieLoteMovTerceros AS
SELECT
REPLICATE('0',20-LEN(RTRIM(LTRIM(CONVERT(varchar,VentaD.ID))))) + RTRIM(LTRIM(CONVERT(varchar,VentaD.ID))) +
REPLICATE('0',12-LEN(RTRIM(LTRIM(CONVERT(varchar,VentaD.Renglon))))) + RTRIM(LTRIM(CONVERT(varchar,VentaD.Renglon))) +
REPLICATE('0',7-LEN(RTRIM(LTRIM(CONVERT(varchar,VentaD.RenglonSub))))) + RTRIM(LTRIM(CONVERT(varchar,VentaD.RenglonSub))) +
REPLICATE('0',20-LEN(RTRIM(LTRIM(CONVERT(varchar,CFDVentaDProv.Proveedor))))) +RTRIM(CFDVentaDProv.Proveedor) +
RTRIM(SerieLoteMov.SerieLote) + REPLICATE (' ', 50 - LEN(RTRIM(SerieLoteMov.SerieLote)))
OrdenExportacion,
SerieLoteMov.ID ID,
SerieLoteMov.SerieLote,
SerieLoteMov.Cantidad,
SerieLoteMov.Propiedades,
SerieLoteMov.Ubicacion,
SerieLoteMov.Localizacion,
SerieLoteMov.ArtCostoInv,
SerieLoteprop.Fecha1,
SerieLoteprop.Fecha2,
SerieLoteprop.Fecha3,
SerieLoteprop.PedimentoClave,
SerieLoteprop.PedimentoRegimen,
SerieLoteprop.AgenteAduanal,
SerieLoteprop.Aduana,
SerieLoteprop.PedimentoTipo,
Aduana.GLN AduanaGLN
FROM SerieLoteMov JOIN VentaD
ON SerieLoteMov.ID = VentaD.ID AND SerieLoteMov.RenglonID = VentaD.RenglonID
JOIN SerieLoteProp ON SerieLoteMov.Propiedades = SerieLoteProp.Propiedades
LEFT OUTER JOIN Aduana ON SerieLoteProp.Aduana = Aduana.Aduana
JOIN CFDVentaDProv ON CFDVentaDProv.ID = VentaD.ID AND VentaD.Renglon = CFDVentaDProv.Renglon AND CFDVentaDProv.RenglonSub = VentaD.RenglonSub AND CFDVentaDProv.Articulo = VentaD.Articulo
JOIN prov ON CFDVentaDprov.Proveedor = Prov.Proveedor
WHERE SerieLoteMov.Modulo = 'VTAS'

