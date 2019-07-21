SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spPOSCancelarOfertaPuntos
@Estacion		int,
@ID             varchar(36)

AS
BEGIN
UPDATE POSLVenta WITH (ROWLOCK)
SET PrecioSugerido = NULL,
Precio = NULL,
DescuentoLinea = NULL,
DescuentoImporte = NULL,
Puntos = NULL,
Comision = NULL,
CantidadObsequio = NULL,
OfertaID = NULL,
Aplicado = 0,
PrecioImpuestoInc = NULL
FROM POSLVenta v JOIN POSOfertaTempCancelacion p WITH (NOLOCK) ON v.Renglon = p.Renglon AND p.Articulo = v.Articulo AND v.ID = p.IDR AND p.Estacion = @Estacion
WHERE v.ID = @ID AND p.ID IN(SELECT ID FROM ListaID WITH (NOLOCK) WHERE Estacion = @Estacion)
EXEC spPOSReAgruparPOSLVenta @Estacion, @ID
EXEC spPOSOfertaAplicar  @ID
EXEC spPOSOfertaPuntosInsertarTemp @ID, NULL, 1, @Estacion
END

