SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER FUNCTION fmMFAAcumulableDeducibleCOMSEI (@Concepto varchar(50), @Empresa varchar(5), @Mov varchar(20), @COMSIVAImportacionAnticipado bit)
RETURNS varchar(2)
AS
BEGIN
DECLARE @EsImportacion		bit,
@EsIVAImportacion		bit,
@Valor				varchar(2),
@MovGastoDiverso		varchar(20),
@MovGasto				varchar(20)
SELECT @MovGastoDiverso = CxpGastoDiverso, @MovGasto = Gasto FROM EmpresaCfgMov WITH (NOLOCK) WHERE Empresa = @Empresa
SELECT @EsImportacion = ISNULL(EsImportacion, 0), @EsIVAImportacion = ISNULL(EsIVAImportacion, 0) FROM Concepto WITH (NOLOCK) WHERE Concepto = @Concepto AND Modulo = 'COMSG'
IF @Mov IN(@MovGastoDiverso, @MovGasto)
BEGIN
IF ISNULL(@COMSIVAImportacionAnticipado, 0) = 0
BEGIN
IF @EsImportacion = 0 AND @EsIVAImportacion = 0
SELECT @Valor = 'Si'
ELSE
SELECT @Valor = 'No'
END
ELSE
BEGIN
IF @EsImportacion = 0 AND @EsIVAImportacion = 1
SELECT @Valor = 'Si'
ELSE IF @EsImportacion = 0 AND @EsIVAImportacion = 0
SELECT @Valor = 'Si'
ELSE
SELECT @Valor = 'No'
END
END
ELSE
SELECT @Valor = 'Si'
RETURN @Valor
END

