SET DATEFIRST 7    
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1  
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROC spCFDINominaConceptoLista
@Empresa			varchar(5)

AS BEGIN
DECLARE @NomAuto bit
SELECT @NomAuto = NomAuto FROM Empresagral WITH (NOLOCK) WHERE Empresa = @Empresa
DELETE CFDINominaConceptoLista WHERE	Empresa = @Empresa
IF @NomAuto=1
BEGIN
INSERT CFDINominaConceptoLista(
Empresa, NominaConcepto, Concepto)
SELECT @Empresa, NominaConcepto, Concepto
FROM NominaConcepto nc WITH (NOLOCK)
GROUP BY NominaConcepto, Concepto
ORDER BY nc.Concepto
END
ELSE
BEGIN
INSERT CFDINominaConceptoLista(
Empresa, NominaConcepto, Concepto)
SELECT @Empresa, Concepto,       Concepto
FROM NomXPersonal nx WITH (NOLOCK)
GROUP BY Concepto
ORDER BY nx.Concepto
END
END

