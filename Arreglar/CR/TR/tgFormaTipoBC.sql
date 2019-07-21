SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER TRIGGER tgFormaTipoBC ON FormaTipo

FOR UPDATE, DELETE
AS BEGIN
DECLARE
@FormaTipoA	varchar(20),
@FormaTipoN	varchar(20)
IF dbo.fnEstaSincronizando() = 1 RETURN
SELECT @FormaTipoN = FormaTipo FROM Inserted
SELECT @FormaTipoA = FormaTipo FROM Deleted
IF @FormaTipoN =  @FormaTipoA RETURN
IF @FormaTipoN IS NULL
BEGIN
DELETE FormaExtraCampo WHERE FormaTipo = @FormaTipoA
DELETE FormaExtraGrupo WHERE FormaTipo = @FormaTipoA
END ELSE
BEGIN
UPDATE FormaExtraCampo SET FormaTipo = @FormaTipoN WHERE FormaTipo = @FormaTipoA
UPDATE FormaExtraGrupo SET FormaTipo = @FormaTipoN WHERE FormaTipo = @FormaTipoA
END
END

