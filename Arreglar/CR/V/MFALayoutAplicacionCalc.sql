SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER VIEW MFALayoutAplicacionCalc AS
SELECT
origen_tipo            = mla.origen_tipo,
origen_modulo          = mla.origen_modulo,
origen_id              = mla.origen_id,
empresa                = mla.empresa,
tipo_aplicacion        = mla.tipo_aplicacion,
folio                  = mla.folio,
ejercicio              = YEAR(mla.fecha),
periodo                = MONTH(mla.fecha),
dia                    = DAY(mla.fecha),
fecha					 = mla.fecha,
Referencia             = mlad.referencia,
importe                = mlad.importe,
cuenta_bancaria        = mlad.cuenta_bancaria,
aplica_ieps			 = mla.aplica_ieps,
aplica_ietu			 = mla.aplica_ietu,
aplica_iva			 = mla.aplica_iva,
dinero				 = NULL,
dinero_id				 = NULL,
tipo_documento		 = NULL
FROM MFALayoutAplicacion mla
JOIN MFALayoutAplicacionD mlad ON mlad.DocumentoID = mla.DocumentoID

