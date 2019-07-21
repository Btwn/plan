SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE xpLanzarProyecto
@ID		int,
@Estacion	int,
@Empresa	char(5),
@Sucursal	int,
@Usuario	char(10),
@Fecha		datetime,
@Mov		varchar(20),
@Proyecto	varchar(50),
@UEN		int,
@Asunto		varchar(255)
AS BEGIN
DECLARE
@Cliente		char(10),
@SoporteID		int,
@Ok			int,
@OkRef		varchar(255),
@Conteo		int
SELECT @Conteo = 0, @Ok = NULL, @OkRef = NULL
SELECT @Mov = NULLIF(NULLIF(RTRIM(@Mov), '0'), ''),
@Proyecto = NULLIF(NULLIF(RTRIM(@Proyecto), '0'), ''),
@Asunto = NULLIF(NULLIF(RTRIM(@Asunto), '0'), '')
BEGIN TRANSACTION
DECLARE crListaSt CURSOR FOR
SELECT DISTINCT Clave
FROM ListaSt
WHERE Estacion = @Estacion
OPEN crListaSt
FETCH NEXT FROM crListaSt INTO @Cliente
WHILE @@FETCH_STATUS <> -1 AND @@Error = 0
BEGIN
IF @@FETCH_STATUS <> -2 AND NULLIF(RTRIM(@Cliente), '') IS NOT NULL
BEGIN
INSERT Soporte (
Empresa,  Sucursal,  Mov,  FechaEmision, Proyecto,  UEN,  Usuario,  UsuarioResponsable, Estatus,      Cliente,  Titulo)
VALUES (@Empresa, @Sucursal, @Mov, @Fecha,       @Proyecto, @UEN, @Usuario, @Usuario,           'SINAFECTAR', @Cliente, @Asunto)
SELECT @SoporteID = SCOPE_IDENTITY()
EXEC spAfectar 'ST', @SoporteID, @Usuario = @Usuario, @EnSilencio = 1, @Ok = @Ok OUTPUT, @OkRef = @OkRef OUTPUT, @Conexion = 1
SELECT @Conteo = @Conteo + 1
END
FETCH NEXT FROM crListaSt INTO @Cliente
END
CLOSE crListaSt
DEALLOCATE crListaSt
IF @Ok IS NULL
BEGIN
COMMIT TRANSACTION
SELECT 'Se Generaron '+LTRIM(CONVERT(char, @Conteo))+ ' Movimientos ('+@Mov+')'
END ELSE
BEGIN
ROLLBACK TRANSACTION
SELECT Descripcion+' '+ISNULL(RTRIM(@OkRef), '') FROM MensajeLista WHERE Mensaje = @Ok
END
RETURN
END

