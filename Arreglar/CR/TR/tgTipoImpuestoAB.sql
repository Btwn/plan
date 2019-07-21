SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER TRIGGER tgTipoImpuestoAB ON TipoImpuesto

FOR INSERT, DELETE
AS BEGIN
DECLARE
@TipoImpuestoN	varchar(10),
@TipoImpuestoA	varchar(10),
@FechaHoy		datetime
IF dbo.fnEstaSincronizando() = 1 RETURN
SELECT @FechaHoy = GETDATE()
EXEC spExtraerFecha @FechaHoy OUTPUT
SELECT
@TipoImpuestoN = TipoImpuesto
FROM Inserted
SELECT
@TipoImpuestoA = TipoImpuesto
FROM Deleted
IF @TipoImpuestoA IS NULL AND  @TipoImpuestoN IS NOT NULL
INSERT TipoImpuestoD (TipoImpuesto,FechaD,FechaA,Tasa,Concepto,Referencia,CodigoFiscal,TieneMovimientos)
SELECT TipoImpuesto,@FechaHoy,NULL,Tasa,Concepto,Referencia,CodigoFiscal,1
FROM Inserted
ELSE IF @TipoImpuestoA IS NOT NULL AND  @TipoImpuestoN IS NULL
DELETE TipoImpuestoD WHERE TipoImpuesto = @TipoImpuestoA
END

