SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spCargarCaracteristicasCatalogo
@SesionID     Uniqueidentifier = null,
@Origen       varchar(255) = null,
@Pagina       Varchar(20) = null

AS BEGIN
select	[Pagina]
,ArticuloID
,[NombreArticulo]
,[DescripcionCorta]
,[DescripcionLarga]
,[Precio]
,[CalificacionArticulo]
,[CalificacionArticuloD]
,[TieneDetalle]
,[PermitirImagenCualidad]
,[URL_ImagenCualidad]
,[VerBotonComprar]
,[LeyendaBotonComprar]
,[VerInventarioArticulo]
,[spInventarioArticulo]
,[spSesionInventario]
,[spOrigenInventario]
,[spPaginaInventario]
,[VerCalificacionArticulo]
,[VerComentariosArticulo]
,[PermitirOrdenar]
,[PermitirBuscar]
,[PermitirImagenGrande]
,[AltoImagenGrande]
,[AnchoImagenGrande]
,[PermitirImagenPequeña]
,[AltoImagenPequeña]
,[AnchoImagenPequeña]
,[PermitirNombreArticulo]
,[PermitirPrecioArticulo]
,[PermitirDescripcionCorta]
,[PermitirDescripcionLarga]
,[PermitirNombreArticuloD]
,[PermitirPrecioArticuloD]
,[PermitirDescripcionCortaD]
,[PermitirDescripcionLargaD]
,[FilasPorPagina]
,[ColumnasPorPagina]
,[PermitirBoldPrecio]
,[PermitirBoldNombre]
,[PermitirBoldDescripcionCorta]
,[PermitirBoldDescripcionLarga]
,[PermitirBoldPrecioD]
,[PermitirBoldNombreD]
,[PermitirBoldDescripcionCortaD]
,[PermitirBoldDescripcionLargaD]
,[ColorPrecio]
,[ColorNombre]
,[ColorDescripcionCorta]
,[ColorDescripcionLarga]
,[ColorPrecioD]
,[ColorNombreD]
,[ColorDescripcionCortaD]
,[ColorDescripcionLargaD]
,ImagenPequena
,ImagenGrande
,ImagenCualidad
,URL_Imagenes
,[SeleccionarArticulo]
,[ComprarArticulo]
,VerBotonComprarD
,LeyendaBotonComprarD
,VerCalificacionArticuloD
FROM [WebPagina] WITH (NOLOCK) WHERE pagina=@Pagina
END

