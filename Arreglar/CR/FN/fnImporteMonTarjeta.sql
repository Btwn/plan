SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER FUNCTION fnImporteMonTarjeta (
@Importe				float,
@Moneda					varchar(10),
@ImporteTipoCambio		float,
@MonedaDestino			varchar(10),
@TipoCambioDestino      float,
@Sucursal               int
)
RETURNS float

AS
BEGIN
DECLARE
@ImporteDestino		float
SET @ImporteDestino = NULL
IF @ImporteTipoCambio IS NULL
IF @ImporteTipoCambio IS NULL
SELECT TOP 1 @ImporteTipoCambio = TipoCambio
FROM POSLTipoCambioRef m
WHERE Moneda = @Moneda AND Sucursal = @Sucursal
IF @TipoCambioDestino IS NULL
SELECT TOP 1 @TipoCambioDestino = TipoCambio
FROM POSLTipoCambioRef m
WHERE Moneda = @MonedaDestino AND Sucursal = @Sucursal
IF @TipoCambioDestino IS NOT NULL
SET @ImporteDestino = dbo.fnPOSImporteAMoneda (@Importe,@ImporteTipoCambio,@MonedaDestino,@Sucursal)
RETURN (@ImporteDestino)
END

