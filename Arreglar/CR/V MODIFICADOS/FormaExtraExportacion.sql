SET DATEFIRST 7    
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1  
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER VIEW FormaExtraExportacion AS
SELECT
REPLICATE('0',20-LEN(RTRIM(LTRIM(CONVERT(varchar,FormaExtra.ID))))) + RTRIM(LTRIM(CONVERT(varchar,FormaExtra.ID))) +
REPLICATE('0',12) +
REPLICATE('0',7) +
REPLICATE(' ',50)
OrdenExportacion,
FormaExtra.*,
Empresa.GLN GLN
FROM FormaExtra WITH(NOLOCK) JOIN Empresa WITH(NOLOCK)
ON FormaExtra.Empresa = Empresa.Empresa

