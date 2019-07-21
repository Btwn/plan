SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE speCommerceRegistroWebArtOpcion
@Estacion int,
@Accion char(4),
@Nombre varchar(100),
@IDVariacion int,
@IDOpcion int = 0

AS BEGIN
DECLARE @OrdenSiguiente int,
@Transaccion	varchar(50),
@Ok				int,
@OkRef			varchar(255)
SET @Ok = 0
SET @OkRef = ''
SET @Transaccion = 'speCommerceRegistroWebArtOpcion' + RTRIM(LTRIM(CONVERT(varchar,@Estacion)))
BEGIN TRANSACTION @Transaccion
IF(@Accion = 'ALTA')
BEGIN
SELECT @OrdenSiguiente = MAX(Orden) + 1 FROM WebArtOpcion WHERE VariacionID = @IDVariacion
INSERT INTO WebArtOpcion (VariacionID,  Orden,			 Nombre, GUID)
VALUES					 (@IDVariacion, @OrdenSiguiente, @Nombre,     NEWID())
IF @@ERROR <> 0 SELECT @Ok = 1, @OkRef = @IDVariacion
END
ELSE IF(@Accion = 'BAJA' AND @IDOpcion <> 0)
BEGIN
IF EXISTS(SELECT ID FROM WebArtOpcion WHERE ID = @IDOpcion)
IF((SELECT TieneWebArt FROM WebArtVariacion WHERE ID = @IDVariacion) = 0)
DELETE FROM WebArtOpcion WHERE ID = @IDOpcion
ELSE
SELECT @Ok = 1, @OkRef = @IDOpcion
IF @@ERROR <> 0 SELECT @Ok = 1, @OkRef = @IDOpcion
END
ELSE
BEGIN
SELECT @Ok = 1, @OkRef = @Accion
END
IF NULLIF(@Ok,0) IS NULL
BEGIN
COMMIT TRANSACTION @Transaccion
END ELSE
BEGIN
ROLLBACK TRANSACTION @Transaccion
SELECT 'ERROR: ' + CONVERT(varchar,@Ok) + (SELECT Descripcion FROM MensajeLista WHERE Mensaje = @Ok) +'. ' + ISNULL(@OkRef,'')
END
END

