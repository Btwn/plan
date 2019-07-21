SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER FUNCTION fnPOSImporteAMoneda (
@Importe			float,
@ImporteTipoCambio	float,
@MonedaDestino		varchar(10),
@Sucursal           int
)
RETURNS float

AS
BEGIN
DECLARE
@ImporteDestino				float,
@TipoCambioDestino			float
SET @ImporteDestino = NULL
SET @TipoCambioDestino = dbo.fnPOSTipoCambio(@MonedaDestino,@Sucursal)
IF @TipoCambioDestino IS NOT NULL
SET @ImporteDestino = (@Importe*@ImporteTipoCambio)/@TipoCambioDestino
RETURN (@ImporteDestino)
END

