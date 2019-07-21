SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spCopiarUsuarioAcceso
@UsuarioD    char(10),
@UsuarioA	char(10)

AS BEGIN
UPDATE a
SET 
MenuPrincipal 		     	= d.MenuPrincipal,
MovsEdicion		     	= d.MovsEdicion,
MovsConsulta		 	= d.MovsConsulta,
MovsAutorizar			= d.MovsAutorizar,
Reportes			= d.Reportes
FROM UsuarioAcceso a, UsuarioAcceso d
WHERE a.Usuario = @UsuarioA AND d.Usuario = @UsuarioD
IF @@ROWCOUNT= 0
INSERT UsuarioAcceso
(Usuario,   MenuPrincipal, MovsEdicion, MovsConsulta, MovsAutorizar, Reportes)
SELECT @UsuarioA, MenuPrincipal, MovsEdicion, MovsConsulta, MovsAutorizar, Reportes
FROM UsuarioAcceso
WHERE Usuario = @UsuarioD
DELETE UsuarioMenuOpcion WHERE Usuario = @UsuarioA
INSERT UsuarioMenuOpcion (
Usuario,   Menu, Opcion, Estatus)
SELECT @UsuarioA, Menu, Opcion, Estatus
FROM UsuarioMenuOpcion
WHERE Usuario = @UsuarioD
DELETE UsuarioAccesoForma WHERE Usuario = @UsuarioA
INSERT UsuarioAccesoForma (
Usuario, Forma)
SELECT @UsuarioA, Forma
FROM UsuarioAccesoForma
WHERE Usuario = @UsuarioD
RETURN
END

