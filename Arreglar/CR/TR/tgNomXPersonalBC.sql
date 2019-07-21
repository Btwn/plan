SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER TRIGGER tgNomXPersonalBC ON NomXPersonal

FOR UPDATE, DELETE
AS BEGIN
DECLARE
@ConceptoN  varchar(50),
@ConceptoA	varchar(50),
@IDN 	int,
@IDA 	int
IF dbo.fnEstaSincronizando() = 1 RETURN
SELECT @IDN = ID, @ConceptoN = Concepto FROM Inserted
SELECT @IDA = ID, @ConceptoA = Concepto FROM Deleted
IF @ConceptoA = @ConceptoN RETURN
IF @ConceptoN IS NULL
DELETE NomXPersonalGrupo WHERE ID = @IDA AND Concepto = @ConceptoA
ELSE
UPDATE NomXPersonalGrupo SET Concepto = @ConceptoN WHERE ID = @IDA AND Concepto = @ConceptoA
END

