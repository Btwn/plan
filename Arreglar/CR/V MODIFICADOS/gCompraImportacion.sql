SET DATEFIRST 7    
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1  
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER VIEW gCompraImportacion
 AS
SELECT
ID,
RenglonID,
Documento,
FechaDocumento,
GuiaEntrega,
FechaGuia,
Convenio,
PuertoCarga,
FechaCarga,
PuertoDestino,
FechaDestino,
Paquetes
FROM CompraImportacion WITH(NOLOCK)
UNION ALL
SELECT
ID,
RenglonID,
Documento,
FechaDocumento,
GuiaEntrega,
FechaGuia,
Convenio,
PuertoCarga,
FechaCarga,
PuertoDestino,
FechaDestino,
Paquetes
FROM hCompraImportacion WITH(NOLOCK)
;

