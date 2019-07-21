SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER FUNCTION fnMFATablaExcepcion(
@origen_vista				varchar(255),
@aplicacion_MovTipo			varchar(20)
)
RETURNS varchar(255)
AS
BEGIN
DECLARE @Valor		varchar(255)
IF ISNULL(@origen_vista, '')  = ''
BEGIN
IF @aplicacion_MovTipo IN('CXC.ANC','CXC.ACA','CXC.AV','CXC.AE')
SELECT @origen_vista = 'MFACxcAplicacionCalc'
ELSE IF @aplicacion_MovTipo IN('CXC.C','CXC.DP','CXC.NCP')
SELECT @origen_vista = 'MFACxcCobroCalc'
ELSE IF @aplicacion_MovTipo IN('CXC.FAC')
SELECT @origen_vista = 'MFACxcEndosoCalc'
ELSE IF @aplicacion_MovTipo IN('CXC.DC')
SELECT @origen_vista = 'MFACxcPagoCalc'
ELSE IF @aplicacion_MovTipo IN('CR.C')
SELECT @origen_vista = 'MFACrCobroCalc'
ELSE IF @aplicacion_MovTipo IN('DIN.CH', 'DIN.CHE', 'DIN.D', 'DIN.DE')
SELECT @origen_vista = 'MFACxcDineroCalc'
ELSE IF @aplicacion_MovTipo IN('CXC.D','CXC.DA','CXC.DOCMON')
SELECT @origen_vista = 'MFACxcRedocumentacionCalc'
ELSE IF @aplicacion_MovTipo IN('CXP.ACA','CXP.AE','CXP.ANC')
SELECT @origen_vista = 'MFACxpAplicacionCalc'
ELSE IF @aplicacion_MovTipo IN('CXP.DC')
SELECT @origen_vista = 'MFACxpCobroCalc'
ELSE IF @aplicacion_MovTipo IN('DIN.CH', 'DIN.CHE', 'DIN.D', 'DIN.DE')
SELECT @origen_vista = 'MFACxpDineroCalc'
ELSE IF @aplicacion_MovTipo IN('CXP.FAC')
SELECT @origen_vista = 'MFACxpEndosoCalc'
ELSE IF @aplicacion_MovTipo IN('CXP.P','CXP.NCP','CXP.DP')
SELECT @origen_vista = 'MFACxpPagoCalc'
ELSE IF @aplicacion_MovTipo IN('CXP.D','CXP.DA')
SELECT @origen_vista = 'MFACxpRedocumentacionCalc'
ELSE IF @aplicacion_MovTipo IN('GAS.G', 'GAS.DC')
SELECT @origen_vista = 'MFAGastoDineroPagoCalc'
ELSE IF @aplicacion_MovTipo IN('GAS.C')
SELECT @origen_vista = 'MFAGastoPagoCalc'
END
IF @origen_vista = 'MFACompraCalc' SELECT @Valor = 'MovTipoMFADocExcepcion'
ELSE IF @origen_vista = 'MFACompraPendienteCalc' SELECT @Valor = 'MovTipoMFADocExcepcion'
ELSE IF @origen_vista = 'MFACrCobroCalc' SELECT @Valor = 'MovTipoMFARedocExcepcion'
ELSE IF @origen_vista = 'MFACxcAplicacionCalc' SELECT @Valor = 'MovTipoMFAAplicaExcepcion'
ELSE IF @origen_vista = 'MFACxcCobroCalc' SELECT @Valor = 'MovTipoMFACobroPagoExcepcion'
ELSE IF @origen_vista = 'MFACxcDineroCalc' SELECT @Valor = 'MovTipoMFAAplicaExcepcion'
ELSE IF @origen_vista = 'MFACxcDocumentoCalc' SELECT @Valor = 'MovTipoMFADocExcepcion'
ELSE IF @origen_vista = 'MFACxcDocumentoPendienteCalc' SELECT @Valor = 'MovTipoMFADocExcepcion'
ELSE IF @origen_vista = 'MFACxcEndosoCalc' SELECT @Valor = 'MovTipoMFAEndosoExcepcion'
ELSE IF @origen_vista = 'MFACxcRedocumentacionCalc' SELECT @Valor = 'MovTipoMFARedocExcepcion'
ELSE IF @origen_vista = 'MFACxpAplicacionCalc' SELECT @Valor = 'MovTipoMFAAplicaExcepcion'
ELSE IF @origen_vista = 'MFACxpCobroCalc' SELECT @Valor = 'MovTipoMFACobroPagoExcepcion'
ELSE IF @origen_vista = 'MFACxpDineroCalc' SELECT @Valor = 'MovTipoMFAAplicaExcepcion'
ELSE IF @origen_vista = 'MFACxpDocumentoCalc' SELECT @Valor = 'MovTipoMFADocExcepcion'
ELSE IF @origen_vista = 'MFACxpDocumentoPendienteCalc' SELECT @Valor = 'MovTipoMFADocExcepcion'
ELSE IF @origen_vista = 'MFACxpEndosoCalc' SELECT @Valor = 'MovTipoMFAEndosoExcepcion'
ELSE IF @origen_vista = 'MFACxpPagoCalc' SELECT @Valor = 'MovTipoMFACobroPagoExcepcion'
ELSE IF @origen_vista = 'MFACxpRedocumentacionCalc' SELECT @Valor = 'MovTipoMFARedocExcepcion'
ELSE IF @origen_vista = 'MFADocumentoInicialCalc' SELECT @Valor = ''
ELSE IF @origen_vista = 'MFAGastoCalc' SELECT @Valor = 'MovTipoMFADocExcepcion'
ELSE IF @origen_vista = 'MFAGastoCxcPendienteCalc' SELECT @Valor = 'MovTipoMFADocExcepcion'
ELSE IF @origen_vista = 'MFAGastoCxpPendienteCalc' SELECT @Valor = 'MovTipoMFADocExcepcion'
ELSE IF @origen_vista = 'MFAGastoDineroPagoCalc' SELECT @Valor = 'MovTipoMFADocExcepcion'
ELSE IF @origen_vista = 'MFAGastoDineroPendienteCalc' SELECT @Valor = 'MovTipoMFADocExcepcion'
ELSE IF @origen_vista = 'MFAGastoPagoCalc' SELECT @Valor = 'MovTipoMFADocExcepcion'
ELSE IF @origen_vista = 'MFALayoutAplicacionCalc' SELECT @Valor = ''
ELSE IF @origen_vista = 'MFALayoutDocCalc' SELECT @Valor = ''
ELSE IF @origen_vista = 'MFANominaCxpDocumentoCalc' SELECT @Valor = 'MovTipoMFADocExcepcion'
ELSE IF @origen_vista = 'MFANominaCxpDocumentoPendienteCalc' SELECT @Valor = 'MovTipoMFADocExcepcion'
ELSE IF @origen_vista = 'MFANotaCalc' SELECT @Valor = 'MovTipoMFADocExcepcion'
ELSE IF @origen_vista = 'MFAVentaCalc' SELECT @Valor = 'MovTipoMFADocExcepcion'
ELSE IF @origen_vista = 'MFAVentaPendienteCalc' SELECT @Valor = 'MovTipoMFADocExcepcion'
ELSE IF @origen_vista = 'MFACxcPagoCalc' SELECT @Valor = 'MovTipoMFACobroPagoExcepcion'
RETURN @Valor
END

