SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE xcrm_proyectos_admin
@Data xcrm_proyectos_adminType READONLY,
@R1 xcrm_VentaD_proyectosType READONLY,
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
INSERT INTO venta(mov,ultimocambio,usuario, Empresa,Moneda,Cliente,Almacen,CRMObjectId,referencia,observaciones,agente,listapreciosesp,estatus )
select substring(movimiento,1,20),GETDATE(),usuario, empresa,'',cliente,almacen,substring(crmobjectid,1,100),substring(referencia,1,50),observaciones,agente,'' ,'SINAFECTAR' from @Data
SELECT @LastId=@@IDENTITY;
if(@LastId>0) begin
INSERT INTO ventad(ID,articulo,fecharequerida,renglon,precio,cantidad,renglonid)
select @LastId,productosku,getdate(), (ROW_NUMBER() OVER(ORDER BY producto))*2048,
cast(precio as float) ,
cast (cantidad as float),
(ROW_NUMBER() OVER(ORDER BY producto))
from @R1
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
,@ErrorMsg=substring('ERR'+ CONVERT(varchar(25),ERROR_LINE()) + '-' + ERROR_MESSAGE() + '-' + ERROR_PROCEDURE(),1,500)
INSERT INTO IntelisisLinkage.dbo.errorLogs(integrationid,mapid,entity,attributes,description,date_error)
select 999,ERROR_NUMBER(),ERROR_PROCEDURE() ,ERROR_MESSAGE(),ERROR_LINE(),GETDATE()
set @RowsAffected=0
IF @@TRANCOUNT > 0
ROLLBACK TRANSACTION;
END CATCH;
IF @@TRANCOUNT > 0
COMMIT TRANSACTION;
END

