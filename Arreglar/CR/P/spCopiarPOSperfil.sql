SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spCopiarPOSperfil
@UsuarioD    char(10),
@UsuarioA	char(10)

AS BEGIN
IF NULLIF(@UsuarioD,'') IS NOT NULL
BEGIN
UPDATE a
SET POSEsSupervisor	= d.POSEsSupervisor
FROM Usuario a, Usuario d
WHERE a.Usuario = @UsuarioA AND d.Usuario = @UsuarioD
DELETE POSUsuarioAccion WHERE Usuario = @UsuarioA
INSERT POSUsuarioAccion (Usuario,		Accion)
SELECT				   @UsuarioA,	Accion
FROM POSUsuarioAccion
WHERE Usuario = @UsuarioD
DELETE POSUsuarioMov WHERE Usuario = @UsuarioA
INSERT POSUsuarioMov (Usuario,	Mov, PuedeAutorizar)
SELECT				@UsuarioA,	Mov, 1
FROM POSUsuarioMov
WHERE Usuario = @UsuarioD
END
RETURN
END

