SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER TRIGGER tgTipoRegistroAB ON TipoRegistro

FOR INSERT, DELETE
AS BEGIN
DECLARE
@TipoRegistroN	varchar(10),
@TipoRegistroA	varchar(10)
IF dbo.fnEstaSincronizando() = 1 RETURN
SELECT
@TipoRegistroN = TipoRegistro
FROM Inserted
SELECT
@TipoRegistroA = TipoRegistro
FROM Deleted
IF @TipoRegistroA IS NULL AND  @TipoRegistroN IS NOT NULL
INSERT TipoRegistroD (TipoRegistro, Concepto, Mascara, TipoContacto, Referencia, VigenciaD, TieneMovimientos)
SELECT  TipoRegistro, Concepto, Mascara, TipoContacto, Referencia, VigenciaD, 0
FROM Inserted
ELSE IF @TipoRegistroA IS NOT NULL AND  @TipoRegistroN IS NULL
DELETE TipoRegistroD WHERE TipoRegistro = @TipoRegistroA
END

