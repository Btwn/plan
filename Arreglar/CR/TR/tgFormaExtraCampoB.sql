SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER TRIGGER tgFormaExtraCampoB ON FormaExtraCampo

FOR DELETE
AS BEGIN
DECLARE
@FormaTipoA		varchar(20),
@CampoA		varchar(50)
IF dbo.fnEstaSincronizando() = 1 RETURN
SELECT @FormaTipoA = FormaTipo, @CampoA = Campo FROM Deleted
UPDATE FormaExtraValor SET Eliminado = 1 WHERE FormaTipo = @FormaTipoA AND Campo = @CampoA AND Eliminado = 0
END

