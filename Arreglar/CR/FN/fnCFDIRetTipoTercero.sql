SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER FUNCTION fnCFDIRetTipoTercero(
@Proveedor				varchar(10)
)
RETURNS varchar(20)
AS
BEGIN
DECLARE @Valor		varchar(20)
SELECT @Valor = CASE
WHEN ISNULL(FiscalRegimen.Extranjero,0) = 0 THEN 'Nacional'
WHEN ISNULL(FiscalRegimen.Extranjero,0) = 1 THEN 'Extranjero'
END
FROM Prov
JOIN FiscalRegimen ON Prov.FiscalRegimen = FiscalRegimen.FiscalRegimen
WHERE Prov.Proveedor = @Proveedor
RETURN ISNULL(NULLIF(RTRIM(@Valor), ''), 'Nacional')
END

