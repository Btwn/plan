SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER VIEW dbo.xcrm_listapreciosd

AS
select LD.Lista,LD.moneda,LD.Articulo,isnull(LD.Precio,0) Precio,ld.CRMObjectId,ld.CRMLastUpdate,Art.unidad
FROM listapreciosd LD
JOIN Art ON LD.Articulo = Art.Articulo
where Art.unidad<>'MODULO' and Art.estatus='ALTA' and precio=0 and (tipo='Servicio' or tipo='Normal')

