SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spAfectarTraficoGestion
@Sucursal	int,
@ID         int,
@Accion	char(20),
@Clave	char(20) = NULL,
@Transferir	char(20) = 'NO',
@EnSilencio	bit	 = 0

AS BEGIN
DECLARE
@Modulo		char(5),
@Empresa		char(5),
@NuevoUsuario	char(10),
@NuevoResponsable	char(10),
@NuevoEstatus	char(15),
@NuevaPrioridad	char(10),
@Prioridad		char(10),
@Propietario	char(10),
@PuedeDevolver	bit,
@Orden		int,
@Ok			int,
@OkRef	     	varchar(255),
@OkDesc     	varchar(255)
SELECT @Modulo = 'GES', @Ok = NULL, @OkDesc = NULL, @Accion = UPPER(@Accion), @Orden = 0, @PuedeDevolver = 0,
@NuevoUsuario = NULL, @NuevoResponsable = NULL, @NuevoEstatus = NULL, @NuevaPrioridad = NULL
IF @Accion NOT IN ('TRANSFERIR', 'DEVOLVER', 'PRIORIDAD')
SELECT @Ok = 60030
IF @Ok IS NULL
BEGIN
SELECT @Empresa = Empresa,
@Propietario = NULLIF(RTRIM(Usuario), ''),
@Prioridad = NULLIF(RTRIM(Prioridad), '')
FROM Gestion
WHERE ID = @ID
IF @Accion IN ('TRANSFERIR', 'DEVOLVER')
BEGIN
SELECT @Orden = ISNULL(MAX(Orden), 0) FROM MovUsuario WHERE Modulo = @Modulo AND ID = @ID
IF @Accion = 'TRANSFERIR' SELECT @NuevoUsuario = UPPER(@Clave) ELSE
IF @Accion = 'DEVOLVER' SELECT @NuevoUsuario = Usuario FROM MovUsuario WHERE Modulo = @Modulo AND ID = @ID AND Orden = @Orden AND Eliminado = 0
IF @NuevoUsuario IS NULL SELECT @Ok = 71010 ELSE
IF NOT EXISTS(SELECT * FROM Usuario WHERE Usuario = @NuevoUsuario) SELECT @Ok = 71020 ELSE
IF @NuevoUsuario = @Propietario  SELECT @Ok = 71030
END ELSE
IF @Accion = 'PRIORIDAD'
BEGIN
SELECT @NuevaPrioridad = @Clave
IF UPPER(@NuevaPrioridad) NOT IN ('ALTA', 'NORMAL', 'BAJA') SELECT @Ok = 71040
END
END
IF @Ok IS NULL
BEGIN
BEGIN TRANSACTION
IF @Accion IN ('TRANSFERIR', 'DEVOLVER')
BEGIN
IF @Accion = 'TRANSFERIR'
BEGIN
SELECT @Orden = @Orden + 1
IF EXISTS(SELECT * FROM MovUsuario WHERE Modulo = @Modulo AND ID = @ID AND Usuario = @Propietario AND Eliminado = 0)
UPDATE MovUsuario SET Orden = @Orden WHERE Modulo = @Modulo AND ID = @ID AND Usuario = @Propietario AND Eliminado = 0
ELSE
INSERT MovUsuario (Sucursal, Modulo, ID, Orden, Usuario) VALUES (@Sucursal, @Modulo, @ID, @Orden, @Propietario)
UPDATE MovUsuario SET Eliminado = 1 WHERE Modulo = @Modulo AND ID = @ID AND Usuario = @NuevoUsuario AND Eliminado = 0
END ELSE
IF @Accion = 'DEVOLVER'
UPDATE MovUsuario SET Eliminado = 1 WHERE Modulo = @Modulo AND ID = @ID AND Usuario = @NuevoUsuario AND Eliminado = 0 AND Orden = @Orden
IF EXISTS(SELECT * FROM MovUsuario WHERE Modulo = @Modulo AND ID = @ID AND Eliminado = 0) SELECT @PuedeDevolver = 1 ELSE SELECT @PuedeDevolver = 0
UPDATE Gestion SET PuedeDevolver = @PuedeDevolver, Usuario = @NuevoUsuario WHERE ID = @ID
END ELSE
IF @Accion = 'PRIORIDAD'
BEGIN
IF UPPER(@NuevaPrioridad) <> UPPER(@Prioridad)
BEGIN
IF UPPER(@NuevaPrioridad) = 'ALTA' SELECT @NuevoEstatus = 'ALTAPRIORIDAD' ELSE
IF UPPER(@NuevaPrioridad) = 'BAJA' SELECT @NuevoEstatus = 'PRIORIDADBAJA'
ELSE SELECT @NuevoEstatus = 'PENDIENTE'
EXEC spValidarTareas @Empresa, @Modulo, @ID, @NuevoEstatus, @Ok OUTPUT, @OkRef OUTPUT
UPDATE Gestion
SET Prioridad = @NuevaPrioridad, Estatus = @NuevoEstatus
WHERE ID = @ID
END
END
COMMIT TRANSACTION
END
IF @Ok IS NOT NULL
SELECT @OkDesc = Descripcion + ' '+ ISNULL(@OkRef, '') FROM MensajeLista WHERE Mensaje = @Ok
IF @EnSilencio = 0
SELECT "Mensaje" = @OkDesc
END

