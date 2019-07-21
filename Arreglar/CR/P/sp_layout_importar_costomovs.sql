SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE sp_layout_importar_costomovs
@usuario	varchar(20),
@pEmpresa varchar(5), 
@pEjercicio smallint

AS BEGIN
DECLARE
@log_id				int,
@error				int,
@error_mensaje		varchar(255),
@conteo				int
SELECT @usuario = UPPER(@usuario)
SELECT @error			= NULL,
@error_mensaje = NULL,
@conteo		= 0
EXEC sp_layout_log_in @usuario, 'importar costo', 'importando', @pEmpresa, @log_id OUTPUT
DELETE FROM CostoMovs where empresa = @pEmpresa and Ejercicio = @pEjercicio
INSERT INTO CostoMovs (
LogID,Empresa,Sucursal,Centro,Cve_almacen,Descr_almacen,Tipo_movimiento,
es_importacion,es_relacionada,es_deducible,Num_documento,Ejercicio,
Periodo,Dia,Unidad,Cantidad,Importe,Material,Descr_material,CatAlmacen)
SELECT @log_id,
Empresa,Sucursal,Centro,Cve_almacen,Descr_almacen,lower(Tipo_movimiento),
ISNULL(es_importacion,0),ISNULL(es_relacionada,0),ISNULL(es_deducible,0),Num_documento,Ejercicio,
Periodo,Dia,Unidad,Cantidad,Importe,Material,Descr_material,CatAlmacen
FROM layout_CostoMovs
WHERE empresa = @pEmpresa and Ejercicio = @pEjercicio 
SELECT @conteo = @conteo + @@ROWCOUNT
EXEC sp_layout_log_out @log_id, @conteo, @error, @error_mensaje
RETURN
END

