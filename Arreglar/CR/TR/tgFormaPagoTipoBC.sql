SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER TRIGGER tgFormaPagoTipoBC ON FormaPagoTipo

FOR UPDATE
AS BEGIN
DECLARE
@TipoN 	varchar(50),
@TipoA		varchar(50)
IF dbo.fnEstaSincronizando() = 1 RETURN
SELECT @TipoN = Tipo FROM Inserted
SELECT @TipoA = Tipo FROM Deleted
IF @TipoN = @TipoA RETURN
IF @TipoN IS NULL
BEGIN
DELETE FormaPagoTipoD WHERE Tipo = @TipoA
END ELSE
BEGIN
UPDATE FormaPagoTipoD SET Tipo = @TipoN WHERE Tipo = @TipoA
END
END

