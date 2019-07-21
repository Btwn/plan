SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER TRIGGER tgConceptoBC ON Concepto

FOR UPDATE, DELETE
AS BEGIN
DECLARE
@ModuloA    char(5),
@ConceptoN 	varchar(50),
@ConceptoA	varchar(50)
IF dbo.fnEstaSincronizando() = 1 RETURN
SELECT @ConceptoN = Concepto FROM Inserted
SELECT @ConceptoA = Concepto, @ModuloA = Modulo FROM Deleted
IF @ConceptoN = @ConceptoA RETURN
IF @ConceptoN IS NULL
BEGIN
DELETE ConceptoProrrateo WHERE Concepto = @ConceptoA AND Modulo = @ModuloA
DELETE ConceptoAcceso    WHERE Concepto = @ConceptoA AND Modulo = @ModuloA
DELETE ConceptoAcreedor  WHERE Concepto = @ConceptoA AND Modulo = @ModuloA
END ELSE
BEGIN
UPDATE ConceptoProrrateo SET Concepto = @ConceptoN WHERE Concepto = @ConceptoA AND Modulo = @ModuloA
UPDATE ConceptoAcreedor  SET Concepto = @ConceptoN WHERE Concepto = @ConceptoA AND Modulo = @ModuloA
END
END

