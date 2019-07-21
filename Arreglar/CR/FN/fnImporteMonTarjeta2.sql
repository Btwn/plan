SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER FUNCTION fnImporteMonTarjeta2 (
@Importe		float,
@Monedero		varchar(20),
@OfertaID       int,
@Sucursal       int
)
RETURNS float

AS
BEGIN
DECLARE
@ImporteDestino			float,
@TipoCambioDestino		float,
@ImporteTipoCambio      float,
@MonedaTarjeta          varchar(10),
@MonedaMov			    varchar(10)
SELECT @MonedaTarjeta = Moneda
FROM POSValeSerie
WHERE Serie = @Monedero
SELECT @MonedaMov = Moneda
FROM Oferta
WHERE ID = @OfertaID
SELECT @ImporteTipoCambio = TipoCambio
FROM POSLTipoCambioRef m
WHERE Moneda = @MonedaMov AND Sucursal = @Sucursal
SELECT @TipoCambioDestino = TipoCambio
FROM POSLTipoCambioRef m
WHERE Moneda = @MonedaTarjeta AND Sucursal = @Sucursal
SET @ImporteDestino = ((@Importe*ISNULL(@ImporteTipoCambio,1.0))/ISNULL(@TipoCambioDestino,1.0))
RETURN (@ImporteDestino)
END

