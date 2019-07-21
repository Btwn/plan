SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER VIEW MFADineroAnticipadoCobroCalc AS
SELECT
origen_tipo,
origen_modulo,
origen_id,
empresa,
tipo_aplicacion,
folio,
ejercicio,
periodo,
dia,
fecha,
Referencia,
importe = ISNULL(importe,0.0) + ISNULL(iva,0.0) + ISNULL(ieps,0.0) + ISNULL(isan,0.0) - ISNULL(retencion_isr,0.0) - ISNULL(retencion_iva,0.0),
cuenta_bancaria,
aplica_ietu,
aplica_ieps,
aplica_iva,
conciliado,
dinero,
dinero_id,
tipo_documento
FROM MFADineroAnticipadoCobroPreCalc

