SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER FUNCTION fnImporteMonTarjetaOfertaPuntos (
@Importe		float,
@Monedero       varchar(20),
@OfertaID       int,
@Sucursal       int,
@Articulo       varchar(20),
@SubCuenta		varchar(50)
)
RETURNS float

AS
BEGIN
DECLARE
@ImporteDestino			float,
@TipoCambioDestino		float,
@ImporteTipoCambio      float,
@MonedaTarjeta          varchar(10),
@MonedaMov			    varchar(10),
@MonedaDetalle		    varchar(10),
@TipoCambioDetalle		float
SELECT @MonedaTarjeta = Moneda
FROM POSValeSerie
WHERE Serie = @Monedero
SELECT @MonedaMov = Moneda
FROM Oferta
WHERE ID =   @OfertaID
SELECT @MonedaDetalle = Moneda
FROM OfertaD
WHERE ID = @OfertaID AND Articulo = @Articulo AND ISNULL(SubCuenta,'') = ISNULL(@SubCuenta,'')
SELECT @ImporteTipoCambio = TipoCambio
FROM POSLTipoCambioRef m
WHERE Moneda = @MonedaMov AND Sucursal = @Sucursal
SELECT @TipoCambioDestino = TipoCambio
FROM POSLTipoCambioRef m
WHERE Moneda = @MonedaTarjeta AND Sucursal = @Sucursal
SELECT @TipoCambioDetalle = TipoCambio
FROM POSLTipoCambioRef m
WHERE Moneda = @MonedaDetalle AND Sucursal = @Sucursal
SET @ImporteDestino = dbo.fnPOSImporteAMoneda (@Importe,@TipoCambioDetalle,@MonedaTarjeta,@Sucursal)
RETURN (@ImporteDestino)
END

