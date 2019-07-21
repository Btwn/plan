SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spMFADocumentosAgregarCuenta

AS BEGIN
EXEC spMFADocumentosAgregarCuentaEntidad
PRINT 'Fin agregar cuenta entidad (Q26.1): ' + CONVERT(varchar,getdate(),126)
EXEC spMFADocumentosAgregarCuentaConcepto
PRINT 'Fin agregar cuenta concepto (Q26.2): ' + CONVERT(varchar,getdate(),126)
EXEC spMFADocumentosAgregarCuentaImpuesto
PRINT 'Fin agregar cuenta concepto (Q26.3): ' + CONVERT(varchar,getdate(),126)
RETURN
END

