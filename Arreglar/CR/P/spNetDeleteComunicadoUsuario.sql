SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spNetDeleteComunicadoUsuario
@IDComunicado INT,
@Usuario VARCHAR(10),
@IDUsuarioTipo INT
AS
BEGIN
IF (EXISTS(SELECT * FROM pNetUsuario WHERE Usuario = @Usuario AND IDUsuarioTipo = @IDUsuarioTipo) AND EXISTS(SELECT * FROM pNetComunicado WHERE IDComunicado = @IDComunicado))
BEGIN
DELETE FROM pNetComunicadoXUsuario WHERE IDComunicado = @IDComunicado AND Usuario = @Usuario AND IDUsuarioTipo = @IDUsuarioTipo
SELECT COUNT (IDComunicado) as  ID FROM pNetComunicadoXUsuario WHERE IDComunicado = @IDComunicado
END
ELSE
SELECT -1 as ID
END

