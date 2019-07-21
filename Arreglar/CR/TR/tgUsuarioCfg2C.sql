SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER TRIGGER tgUsuarioCfg2C ON UsuarioCfg2

FOR UPDATE
AS BEGIN
DECLARE
@Usuario		char(10),
@Configuracion	char(10)
IF dbo.fnEstaSincronizando() = 1 RETURN
SELECT @Usuario = Usuario FROM Inserted
SELECT @Configuracion = NULLIF(RTRIM(Configuracion), '') FROM Usuario WHERE Usuario = @Usuario
IF @Usuario IS NOT NULL
BEGIN
IF @Configuracion IS NULL
EXEC spCopiarUsuarioMaestroCfg @Usuario
ELSE
EXEC spCopiarUsuarioCfg @Configuracion, @Usuario
END
END

