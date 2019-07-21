SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER FUNCTION fnCFDFlexRegimenFiscal
(
@Empresa			varchar(5),
@Modulo				varchar(5),
@Concepto		    varchar(50)
)
RETURNS varchar(100)

AS BEGIN
DECLARE
@RegimenFiscal		varchar(30),
@Descripcion		varchar(100)
SELECT @RegimenFiscal = FiscalRegimen FROM CFDFlexConcepto WHERE Empresa = @Empresa AND Modulo = @Modulo AND Concepto = @Concepto
SELECT @Descripcion = Descripcion FROM FiscalRegimen WHERE FiscalRegimen = @RegimenFiscal
IF NULLIF(@Descripcion,'') IS NULL
BEGIN
SELECT @RegimenFiscal = FiscalRegimen FROM Empresa WHERE Empresa = @Empresa
SELECT @Descripcion = ISNULL(Descripcion,FiscalRegimen) FROM FiscalRegimen WHERE FiscalRegimen = @RegimenFiscal
END
RETURN (@Descripcion)
END

