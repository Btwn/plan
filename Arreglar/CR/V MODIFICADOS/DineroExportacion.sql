SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER VIEW DineroExportacion AS
SELECT
REPLICATE('0',20-LEN(RTRIM(LTRIM(CONVERT(varchar,Dinero.ID))))) + RTRIM(LTRIM(CONVERT(varchar,Dinero.ID))) +
REPLICATE('0',12) +
REPLICATE('0',7) +
REPLICATE(' ',50)
OrdenExportacion,
Dinero.*,
Empresa.GLN GLN
FROM Dinero WITH (NOLOCK) JOIN Empresa WITH (NOLOCK)
ON Dinero.Empresa = Empresa.Empresa

