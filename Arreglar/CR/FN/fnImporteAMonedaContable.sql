SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER FUNCTION fnImporteAMonedaContable
(
@Importe				float,
@ImporteTipoCambio		float,
@MonedaDestino			varchar(10)
)
RETURNS float

AS BEGIN
DECLARE
@ImporteDestino				float,
@TipoCambioDestino			float
SET @ImporteDestino = NULL
SET @TipoCambioDestino = dbo.fnTipoCambio(@MonedaDestino)
IF @TipoCambioDestino IS NOT NULL
SET @ImporteDestino = (@Importe*@ImporteTipoCambio)/dbo.fnEvitarDivisionCero(@TipoCambioDestino)
RETURN (@ImporteDestino)
END

