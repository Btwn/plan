SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE dbo.spVerConceptoDim
@Empresa			VARCHAR(5),
@EstacionTrabajo	INT

AS BEGIN
DECLARE @NomAuto BIT
SELECT	@NomAuto=NomAuto
FROM	Empresagral
WHERE	Empresa=@Empresa
DELETE	DimListaConcepto
WHERE	Empresa=@Empresa
IF @NomAuto=1
BEGIN
INSERT	DimListaConcepto
(Empresa,	NominaConcepto,	Concepto)
SELECT	@Empresa,	NominaConcepto,	Concepto
FROM	NominaConcepto nc
ORDER	BY nc.Concepto
END
ELSE
BEGIN
INSERT	DimListaConcepto
(Empresa,	NominaConcepto,	Concepto)
SELECT  distinct @Empresa,	Concepto  ,		Concepto
FROM	NomXPersonal nx
ORDER	BY nx.Concepto
END
END

