SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spCopiarUsuarioCfgMFA
@UsuarioD    char(10),
@UsuarioA	char(10)

AS BEGIN
UPDATE a
SET InterfazExentus             = d.InterfazExentus,
AccesoInterfazExentus       = d.AccesoInterfazExentus
FROM UsuarioCfg2 a, UsuarioCfg2 d
WHERE a.Usuario = @UsuarioA AND d.Usuario = @UsuarioD
EXEC xpCopiarUsuarioCfg @UsuarioD, @UsuarioA
RETURN
END

