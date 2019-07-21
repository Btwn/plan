SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE speDocInEliminar
@Estacion		int,
@eDocIn			varchar(50)

AS BEGIN
DECLARE
@Transaccion		varchar(50),
@Ok					int,
@OkRef				varchar(255)
SET @Transaccion = 'speDocInEliminar' + RTRIM(LTRIM(CONVERT(varchar,@Estacion)))
BEGIN TRANSACTION @Transaccion
DELETE FROM eDocIn WHERE eDocIn = @eDocIn
IF @Ok IS NULL
DELETE FROM eDocInRuta WHERE eDocIn = @eDocIn
IF @@ERROR <> 0 SET @Ok = 1
IF @Ok IS NULL
DELETE FROM eDocInRutaD WHERE eDocIn = @eDocIn
IF @@ERROR <> 0 SET @Ok = 1
IF @Ok IS NULL
DELETE FROM eDocInRutaTabla WHERE eDocIn = @eDocIn
IF @@ERROR <> 0 SET @Ok = 1
IF @Ok IS NULL
DELETE FROM eDocInRutaTablaD WHERE eDocIn = @eDocIn
IF @@ERROR <> 0 SET @Ok = 1
IF @Ok IS NULL
DELETE FROM eDocInRutaDCondicion WHERE eDocIn = @eDocIn
IF @Ok IS NULL
BEGIN
COMMIT TRANSACTION @Transaccion
SELECT 'Proceso Exitoso'
END ELSE
BEGIN
ROLLBACK TRANSACTION @Transaccion
SELECT 'ERROR  ' + CONVERT(varchar,@Ok) + (SELECT Descripcion FROM MensajeLista WHERE Mensaje = @Ok) +'. ' + ISNULL(@OkRef,'')
END
END

