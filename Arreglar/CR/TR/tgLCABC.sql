SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER TRIGGER tgLCABC ON LC

FOR INSERT, UPDATE, DELETE
AS BEGIN
IF dbo.fnEstaSincronizando() = 1 RETURN
INSERT LCHist (LineaCredito, FechaCambio, Uso, Fecha, Descripcion, TipoCredito, Acreditado, Coacreditado, Acreedor, Agente, VigenciaDesde, VigenciaCondicion, VigenciaHasta, Importe, Moneda, DisposicionTipo, DisposicionPlazoMinimo, DisposicionPlazoMaximo, Condicion, TipoTasa, TipoAmortizacion, Estatus, Situacion, SituacionFecha, SituacionUsuario, SituacionNota, Reestructurada, Calificacion, UsuarioCambio)
SELECT LineaCredito,   GETDATE(),   Uso, Fecha, Descripcion, TipoCredito, Acreditado, Coacreditado, Acreedor, Agente, VigenciaDesde, VigenciaCondicion, VigenciaHasta, Importe, Moneda, DisposicionTipo, DisposicionPlazoMinimo, DisposicionPlazoMaximo, Condicion, TipoTasa, TipoAmortizacion, Estatus, Situacion, SituacionFecha, SituacionUsuario, SituacionNota, Reestructurada, Calificacion, UsuarioCambio
FROM Inserted
DECLARE
@LineaCreditoN	char(20),
@LineaCreditoA	char(20)
SELECT @LineaCreditoN = LineaCredito FROM Inserted
SELECT @LineaCreditoA = LineaCredito FROM Deleted
IF @LineaCreditoN=@LineaCreditoA RETURN
IF @LineaCreditoN IS NULL
BEGIN
DELETE LCAval     WHERE LineaCredito = @LineaCreditoN
DELETE LCGarantia WHERE LineaCredito = @LineaCreditoN
DELETE LCDoc      WHERE LineaCredito = @LineaCreditoN
END ELSE
IF @LineaCreditoN <> @LineaCreditoA AND @LineaCreditoA IS NOT NULL
BEGIN
UPDATE LCAval     SET LineaCredito = @LineaCreditoN WHERE LineaCredito = @LineaCreditoA
UPDATE LCGarantia SET LineaCredito = @LineaCreditoN WHERE LineaCredito = @LineaCreditoA
UPDATE LCDoc      SET LineaCredito = @LineaCreditoN WHERE LineaCredito = @LineaCreditoA
END
END

