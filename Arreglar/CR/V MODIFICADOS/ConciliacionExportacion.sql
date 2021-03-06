SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER VIEW ConciliacionExportacion AS
SELECT
REPLICATE('0',20-LEN(RTRIM(LTRIM(CONVERT(varchar,Conciliacion.ID))))) + RTRIM(LTRIM(CONVERT(varchar,Conciliacion.ID))) +
REPLICATE('0',12) +
REPLICATE('0',7) +
REPLICATE(' ',50)
OrdenExportacion,
Conciliacion.*,
Empresa.GLN GLN
FROM Conciliacion WITH (NOLOCK) JOIN Empresa WITH (NOLOCK)
ON Conciliacion.Empresa = Empresa.Empresa

