SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER FUNCTION fnContParalelaCtaFiltro(
@Tipo		varchar(15)
)
RETURNS varchar(100)
AS
BEGIN
DECLARE @Valor	varchar(100)
IF @Tipo = 'Todas'
SELECT @Valor = '(1=1)'
ELSE IF @Tipo = 'Asignadas'
SELECT @Valor = '(NULLIF(RTRIM(ContParalelaCta.CuentaAsignada), '''') IS NOT NULL)'
ELSE IF @Tipo = 'SinAsignar'
SELECT @Valor = '(NULLIF(RTRIM(ContParalelaCta.CuentaAsignada), '''') IS NULL)'
RETURN @Valor
END

