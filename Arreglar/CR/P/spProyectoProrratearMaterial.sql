SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spProyectoProrratearMaterial
@ID			int,
@Fase		varchar(50),
@Estacion		int

AS BEGIN
DECLARE	@CantidadActividades		int,
@Actividad			varchar(50),
@Transaccion			varchar(50),
@Ok				int,
@OkRef				varchar(255)
SET @Transaccion = 'spProyectoProrratearMaterial' + RTRIM(LTRIM(CONVERT(varchar,@Estacion)))
SELECT @CantidadActividades = COUNT(*)
FROM ProyectoD
WHERE ID = @ID
AND Actividad LIKE RTRIM(@Fase) + '.%'
AND RTRIM(Actividad) <> @Fase
SET @Ok = NULL
SET @OkRef = NULL
BEGIN TRANSACTION @Transaccion
DECLARE crProyectoD CURSOR FOR
SELECT
Actividad
FROM ProyectoD p
WHERE ID = @ID
AND Actividad LIKE RTRIM(@Fase) + '.%'
AND RTRIM(Actividad) <> @Fase
OPEN crProyectoD
FETCH NEXT FROM crProyectoD INTO @Actividad
WHILE @@FETCH_STATUS <> -1 AND @Ok IS NULL
BEGIN
IF @@FETCH_STATUS <> -2 AND @Ok IS NULL
BEGIN
DELETE FROM ProyectoDArtMaterial WHERE ID = @ID AND Actividad = @Actividad
IF @@ERROR <> 0 SET @Ok = 1
IF @Ok IS NULL
BEGIN
INSERT ProyectoDArtMaterial (ID, Actividad, Material, SubCuenta, Cantidad, Unidad, Almacen)
SELECT
ID,
@Actividad,
Material,
SubCuenta,
Cantidad/@CantidadActividades,
Unidad,
Almacen
FROM ProyectoDArtMaterial
WHERE ID = @ID AND RTRIM(Actividad) = RTRIM(@Fase)
IF @@ERROR <> 0 SET @Ok = 1
END
END
FETCH NEXT FROM crProyectoD INTO @Actividad
END
CLOSE crProyectoD
DEALLOCATE crProyectoD
IF @Ok IS NULL
BEGIN
DELETE FROM ProyectoDArtMaterial WHERE ID = @ID AND RTRIM(Actividad) = RTRIM(@Fase)
IF @@ERROR <> 0 SET @Ok = 1
END
IF @Ok IS NULL
COMMIT TRANSACTION @Transaccion
ELSE
ROLLBACK TRANSACTION @Transaccion
IF @Ok IS NULL
SELECT 'Se ha prorrateado el material de la fase ' + RTRIM(@Fase) + ' entre ' + RTRIM(CONVERT(varchar,@CantidadActividades)) + ' actividades.'
ELSE
SELECT 'ERROR: ' + RTRIM(LTRIM(CONVERT(varchar,Mensaje))) + ', ' + Descripcion FROM MensajeLista WHERE Mensaje = @Ok
END

