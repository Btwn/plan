SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER TRIGGER tgFormaExtraGrupoC ON FormaExtraGrupo

FOR UPDATE, DELETE
AS BEGIN
DECLARE
@FormaTipoA	varchar(20),
@FormaTipoN	varchar(20),
@GrupoA	varchar(50),
@GrupoN	varchar(50)
IF dbo.fnEstaSincronizando() = 1 RETURN
SELECT @FormaTipoN = FormaTipo, @GrupoN = Grupo FROM Inserted
SELECT @FormaTipoA = FormaTipo, @GrupoA = Grupo FROM Deleted
IF @FormaTipoN = @FormaTipoA AND @GrupoN = @GrupoA RETURN
UPDATE FormaExtraCampo SET FormaTipo = @FormaTipoN, Grupo = @GrupoN WHERE FormaTipo = @FormaTipoA AND Grupo = @GrupoA
END

