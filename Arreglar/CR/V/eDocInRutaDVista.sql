SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER VIEW eDocInRutaDVista

AS
SELECT d.eDocIn, d.Ruta, d.GUID,d.OperadorLogico, c.Operador, ISNULL(c.Operando1,'')+' '+c.Operador+' '+ISNULL(c.Operando2,'') AS Condicion ,d.Tipo, d.OperadorNumero
FROM eDocInRutaDVista2 d LEFT JOIN eDocInRutaDCondicion c ON  d.eDocIn = c.eDocIn AND d.Ruta = c.Ruta AND d.GUID = c.GUID

