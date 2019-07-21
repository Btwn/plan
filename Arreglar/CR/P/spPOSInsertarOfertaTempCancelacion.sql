SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spPOSInsertarOfertaTempCancelacion
@Estacion		int,
@ID             varchar(36)

AS
BEGIN
DELETE POSOfertaTempCancelacion WHERE Estacion = @Estacion
INSERT POSOfertaTempCancelacion(
Estacion,  IDR, Articulo, Renglon, PrecioSugerido, Precio, Puntos, Cantidad)
SELECT
@Estacion, ID,  Articulo, Renglon, PrecioSugerido, Precio, Puntos, Cantidad
FROM POSLVenta
WHERE ID = @ID
AND  Aplicado = 1
END

