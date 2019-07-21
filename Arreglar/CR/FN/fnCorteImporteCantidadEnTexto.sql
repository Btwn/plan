SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER FUNCTION fnCorteImporteCantidadEnTexto(
@TipoTotalizador		varchar(255),
@Importe				float,
@SaldoU					float)
RETURNS varchar(30)

AS
BEGIN
DECLARE @Valor  varchar(30)
IF @TipoTotalizador = 'Monetario'
SELECT @Valor = dbo.fnMonetarioEnTexto(@Importe)
ELSE IF @TipoTotalizador = 'Unidad'
SELECT @Valor = dbo.fnCantidadEnTexto(@SaldoU)
RETURN @Valor
END

