SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER TRIGGER tgSustentoComprobanteAB ON SustentoComprobante

FOR INSERT, DELETE
AS BEGIN
DECLARE
@SustentoComprobanteN	varchar(10),
@SustentoComprobanteA	varchar(10)
IF dbo.fnEstaSincronizando() = 1 RETURN
SELECT
@SustentoComprobanteN = SustentoComprobante
FROM Inserted
SELECT
@SustentoComprobanteA = SustentoComprobante
FROM Deleted
IF @SustentoComprobanteA IS NULL AND  @SustentoComprobanteN IS NOT NULL
INSERT SustentoComprobanteD (SustentoComprobante, Concepto, Referencia, VigenciaD, TieneMovimientos)
SELECT  SustentoComprobante, Concepto, Referencia, VigenciaD, 0
FROM Inserted
ELSE IF @SustentoComprobanteA IS NOT NULL AND  @SustentoComprobanteN IS NULL
DELETE SustentoComprobanteD WHERE SustentoComprobante = @SustentoComprobanteA
END

