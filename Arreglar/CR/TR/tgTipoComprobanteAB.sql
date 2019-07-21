SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER TRIGGER tgTipoComprobanteAB ON TipoComprobante

FOR INSERT, DELETE
AS BEGIN
DECLARE
@TipoComprobanteN	varchar(10),
@TipoComprobanteA	varchar(10)
IF dbo.fnEstaSincronizando() = 1 RETURN
SELECT
@TipoComprobanteN = TipoComprobante
FROM Inserted
SELECT
@TipoComprobanteA = TipoComprobante
FROM Deleted
IF @TipoComprobanteA IS NULL AND  @TipoComprobanteN IS NOT NULL
INSERT TipoComprobanteD (TipoComprobante, Concepto, Referencia,VigenciaD, TieneMovimientos)
SELECT  TipoComprobante, Concepto, Referencia,VigenciaD, 0
FROM Inserted
ELSE IF @TipoComprobanteA IS NOT NULL AND  @TipoComprobanteN IS NULL
DELETE TipoComprobanteD WHERE TipoComprobante = @TipoComprobanteA
END

