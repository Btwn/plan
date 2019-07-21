SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER VIEW dbo.xcrm_invoice

AS
select cliente,listapreciosesp,moneda,origenid,estatus,movid,id,origen, isnull(importe ,0) importe , isnull(impuestos,0) impuestos, isnull(preciototal,0) preciototal
,ultimocambio,mov
from venta
where venta.mov in ('Factura','Devolucion Venta') and (origen in ('Pedido') or origen is null) and foliocrm is not null

