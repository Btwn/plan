SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER VIEW dbo.xcrm_ventad

AS
select ventad.*,venta.ultimocambio,venta.mov,venta.referencia from ventad
join venta on(venta.id=ventad.id) and Mov='Pedido' and venta.folioCRM is not null

