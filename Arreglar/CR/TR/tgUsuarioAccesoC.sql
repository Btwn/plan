SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER TRIGGER tgUsuarioAccesoC ON UsuarioAcceso

FOR UPDATE
AS BEGIN
DECLARE
@Usuario	char(10),
@Acceso	char(10)
IF dbo.fnEstaSincronizando() = 1 RETURN
SELECT @Usuario = Usuario FROM Inserted
SELECT @Acceso = NULLIF(RTRIM(Acceso), '') FROM Usuario WHERE Usuario = @Usuario
IF @Usuario IS NOT NULL AND @Acceso IS NULL
EXEC spCopiarUsuarioMaestroAcceso @Usuario
END

