SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER FUNCTION dbo.fnPOSCheckSumDetalle (
@ID			varchar(36),
@Renglon	float
)
RETURNS int

AS
BEGIN
DECLARE
@Resultado  int
SELECT @Resultado = CHECKSUM(ID, Renglon, RenglonSub, RenglonID, RenglonTipo, Aplica, AplicaID, Cantidad, Articulo, SubCuenta, Precio, PrecioSugerido,
DescuentoLinea, DescuentoImporte, Impuesto1, Impuesto2, Impuesto3, Unidad, Factor, CantidadInventario, Puntos, Comision, CantidadObsequio, OfertaID,
SerieLote, LDIServicio, Juego, Aplicado, PrecioImpuestoInc, AplicaDescGlobal, Codigo)
FROM POSLPorCobrarD WHERE ID = @ID AND Renglon = @Renglon
RETURN (@Resultado)
END

