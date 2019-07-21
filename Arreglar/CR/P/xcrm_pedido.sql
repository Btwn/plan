SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE xcrm_pedido
@Data xcrm_pedidoType READONLY,
@R1 xcrm_VentaDType READONLY,
@RowsAffected INT OUTPUT,
@ErrorCode int OUTPUT,
@ErrorMsg varchar(500) OUTPUT

As Begin
Declare @LastId as int
Declare @RowsAffected_tmp as int
Declare @ErrorCode_tmp as VARCHAR(MAX)
BEGIN TRANSACTION;
BEGIN TRY
Declare  @CountPedido as int
set @CountPedido=0
select @CountPedido=count(*) from venta where crmobjectid in (select crmobjectid from @R1)
if(@CountPedido>0) begin
set @RowsAffected=0
set @ErrorCode=1
set @ErrorMsg='Registro duplicado '
end
else begin
INSERT INTO venta(mov,ultimocambio,usuario, Empresa,Moneda,Cliente,Almacen,CRMObjectId,referencia,observaciones,agente,listapreciosesp,estatus,FechaEmision,concepto,tipocambio,prioridad,fecharequerida,condicion,vencimiento,zonaImpuesto,Sucursal,SucursalVenta,sucursalorigen,foliocrm )
select substring(movimiento,1,20),GETDATE(),usuario, empresa,moneda,cliente,almacen,substring(crmobjectid,1,100),substring(referencia,1,50),observaciones,agente,listaprecios ,'SINAFECTAR',GETDATE(),concepto,1,'Normal',GETDATE(),'(Fecha)',GETDATE(),'16%',1,1,1,substring(referencia,1,50) from @Data
SELECT @LastId=@@IDENTITY;
if(@LastId>0) begin
Declare @Almacen as varchar(20)
Declare @Agente as varchar(10)
Declare @Moneda as varchar(10)
select @Almacen=Almacen,@Agente=Agente,@Moneda=Moneda from @Data
INSERT INTO ventad(ID,articulo,fecharequerida,renglon,precio,cantidad,cantidadInventario,sucursal,
renglonid,Almacen,agente,preciomoneda,precioTipocambio,DescuentoTipo,DescuentoLinea,Impuesto1,unidad,crmobjectid,DescuentoImporte)
select @LastId,productosku,getdate(), (ROW_NUMBER() OVER(ORDER BY producto))*2048,
cast(precio as float) ,
cast (cantidad as float),
cast (cantidad as float),
0,
(ROW_NUMBER() OVER(ORDER BY producto)),
@Almacen,@Agente,@Moneda,1,'%',
(cast (descuento as float)/(cast (cantidad as float)*cast (precio as float)))*100,
16,
(select top 1 unidad from art where articulo=Articulo),
crmobjectid,
descuento
from @R1
Declare @maxRenglonID as varchar(10)
SELECT @RowsAffected = @@ROWCOUNT, @ErrorCode = @@ERROR
end
set @RowsAffected=1
set @ErrorCode=0
set @ErrorMsg=''
end
END TRY
BEGIN CATCH
SELECT
@ErrorCode=ERROR_NUMBER()
,@ErrorMsg=substring('ERR'+ CONVERT(VARCHAR(25),ERROR_LINE()) + '-' + ERROR_MESSAGE() + '-' + ERROR_PROCEDURE(),1,500)
INSERT INTO IntelisisLinkage.dbo.errorLogs(integrationid,mapid,entity,attributes,description,date_error)
select 999,ERROR_NUMBER(),ERROR_PROCEDURE() ,ERROR_MESSAGE(),ERROR_LINE(),GETDATE()
set @RowsAffected=0
IF @@TRANCOUNT > 0
ROLLBACK TRANSACTION;
END CATCH;
IF @@TRANCOUNT > 0
COMMIT TRANSACTION;
END

