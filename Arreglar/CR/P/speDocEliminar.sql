SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE speDocEliminar
@Estacion		int,
@Modulo		varchar(5),
@eDoc			varchar(50)

AS BEGIN
DECLARE
@Transaccion		varchar(50),
@Ok					int,
@OkRef				varchar(255)
SET @Transaccion = 'speDocEliminar' + RTRIM(LTRIM(CONVERT(varchar,@Estacion)))
BEGIN TRANSACTION @Transaccion
DELETE FROM eDocDMapeoCampo WHERE Modulo = @Modulo AND eDoc = @eDoc
IF @@ERROR <> 0 SET @Ok = 1
IF @Ok IS NULL
BEGIN
DELETE FROM eDocD WHERE Modulo = @Modulo AND eDoc = @eDoc
IF @@ERROR <> 0 SET @Ok = 1
END
IF @Ok IS NULL
BEGIN
DELETE FROM eDoc WHERE Modulo = @Modulo AND eDoc = @eDoc
IF @@ERROR <> 0 SET @Ok = 1
END
IF @Ok IS NULL
BEGIN
COMMIT TRANSACTION @Transaccion
SELECT 'Proceso Exitoso'
END ELSE
BEGIN
ROLLBACK TRANSACTION @Transaccion
SELECT 'ERROR: ' + CONVERT(varchar,@Ok) + (SELECT Descripcion FROM MensajeLista WHERE Mensaje = @Ok) +'. ' + ISNULL(@OkRef,'')
END
END

