SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER VIEW cOportunidadInteresadoEn

AS
SELECT
ID,
Renglon,
RenglonSub,
RenglonTipo,
RenglonID,
Articulo,
Cantidad,
SubCuenta,
Precio,
Sucursal,
SucursalOrigen,
UEN,
DescuentoLinea,
DescuentoImporte,
FechaRequerida,
HoraRequerida,
Espacio,
Almacen,
PrecioMoneda,
PrecioTipoCambio,
PoliticaPrecios,
DescuentoTipo,
PrecioSugerido,
Unidad,
Factor,
CantidadInventario
FROM
OportunidadInteresadoEn WITH (NOLOCK)

