SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER VIEW gDimListaConcepto
 AS
SELECT
ID,
NominaConcepto,
Concepto,
Empresa
FROM DimListaConcepto
UNION ALL
SELECT
ID,
NominaConcepto,
Concepto,
Empresa
FROM hDimListaConcepto
;

