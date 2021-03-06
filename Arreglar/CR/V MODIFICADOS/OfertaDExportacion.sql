SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER VIEW OfertaDExportacion AS
SELECT
REPLICATE('0',20-LEN(RTRIM(LTRIM(CONVERT(varchar,ID))))) + RTRIM(LTRIM(CONVERT(varchar,OfertaD.ID))) +
REPLICATE(' ',50)
OrdenExportacion,
OfertaD.*,
Art.Descripcion1 Descripcion
FROM OfertaD WITH(NOLOCK) JOIN Art WITH(NOLOCK)
ON OfertaD.Articulo = Art.Articulo

