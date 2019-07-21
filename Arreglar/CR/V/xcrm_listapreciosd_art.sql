SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER VIEW dbo.xcrm_listapreciosd_art

AS
select '(Precio Lista)' Lista,art.MonedaPrecio Moneda,ARt.Articulo,isnull(Art.PrecioLista,0) Precio,ld.CRMObjectId,art.ultimocambio CRMLastUpdate,Art.unidad
FROM art LD
JOIN Art ON LD.Articulo = Art.Articulo
union
select '(Precio 2)' Lista,art.MonedaPrecio Moneda,ARt.Articulo,isnull(Art.PrecioLista,0) Precio,ld.CRMObjectId,art.ultimocambio CRMLastUpdate,Art.unidad
FROM art LD
JOIN Art ON LD.Articulo = Art.Articulo

