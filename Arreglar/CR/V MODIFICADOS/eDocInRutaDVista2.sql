SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER VIEW eDocInRutaDVista2

AS
SELECT d.OperadorLogico+' ('+CONVERT(varchar,row_number() over(partition by d.eDocIn, d.Ruta,d.OperadorLogico ORDER BY d.GUID ASC))+')'as OperadorNumero,
d.eDocIn, d.Ruta, d.GUID,d.OperadorLogico,d.Tipo
FROM eDocInRutaD d WITH (NOLOCK)
GROUP BY d.eDocIn, d.Ruta, d.GUID,d.OperadorLogico,d.Tipo

