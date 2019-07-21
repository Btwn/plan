SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spPOSModificarOfertaTemp
@Estacion       int,
@ID				varchar(36)

AS
BEGIN
DELETE POSOfertaTempD WHERE Estacion = @Estacion AND IDR = @ID
INSERT POSOfertaTempD(
Estacion, ID, IDR, Articulo, Renglon, PrecioSugerido, Precio, Puntos,            CantidadO, CantidadM)
SELECT
Estacion, ID, IDR, Articulo, Renglon, PrecioSugerido, Precio, (Puntos/Cantidad), Cantidad,  Cantidad
FROM POSOfertaTemp WITH (NOLOCK)
WHERE Estacion = @Estacion
AND IDR = @ID
AND ID IN(SELECT ID FROM ListaID WITH (NOLOCK)  WHERE Estacion = @Estacion)
END

