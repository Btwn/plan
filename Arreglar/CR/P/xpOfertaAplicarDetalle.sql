SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE xpOfertaAplicarDetalle
@ID				int,
@Articulo		varchar(20),
@Aplica			bit OUTPUT
AS
BEGIN
/*
DELETE #VentaD
FROM VentaD
WHERE VentaD.Renglon = #VentaD.Renglon AND VentaD.RenglonSub = #VentaD.RenglonSub AND VentaD.Articulo = #VentaD.Articulo
AND VentaD.ID = @ID AND VentaD.Precio <> VentaD.PrecioSugerido
DELETE #VentaD
FROM VentaD
WHERE VentaD.Renglon = #VentaD.Renglon AND VentaD.RenglonSub = #VentaD.RenglonSub AND VentaD.Articulo = #VentaD.Articulo
AND VentaD.ID = @ID AND ISNULL(VentaD.DescuentoLinea,0) <> 0
IF (SELECT ISNULL(DescuentoLinea, 0) FROM VentaD WHERE ID = @ID AND Renglon = @Renglon AND RenglonSub = @RenglonSub AND OfertaID IS NULL) > 0
SELECT @Aplica = 0
*/
RETURN
END

