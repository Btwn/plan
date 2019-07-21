SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER TRIGGER tgWebUsuariosABC ON WebUsuarios

FOR INSERT, UPDATE, DELETE
AS BEGIN
DECLARE
@Ok				int,
@IDI                        int,
@IDD                        int,
@ContrasenaI		varchar(32),
@ContrasenaD		varchar(32),
@ConfirmacionI		varchar(32),
@ConfirmacionD		varchar(32),
@Mensaje			varchar(255)
SELECT @Ok = NULL
SELECT @IDI = ID, @ContrasenaI = Contrasena, @ConfirmacionI = ContrasenaConfirmacion FROM Inserted
SELECT @IDD = ID,  @ContrasenaD = Contrasena, @ConfirmacionD = ContrasenaConfirmacion FROM Deleted
IF @IDI IS NOT NULL AND @ContrasenaD <> @ContrasenaI 
BEGIN
IF @ContrasenaI <> @ConfirmacionI    SELECT @Ok = 60230
END
IF @ContrasenaI <> @ConfirmacionI    SELECT @Ok = 60230
IF @Ok IS NOT NULL
BEGIN
SELECT @Mensaje = Descripcion FROM MensajeLista WHERE Mensaje = @Ok
RAISERROR (@Mensaje,16,-1)
END
END

