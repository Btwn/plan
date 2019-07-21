SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spNetAddComunicadoPerfil
@IDComunicado INT,
@IDUsuarioTipo INT
AS
BEGIN
IF (EXISTS(SELECT * FROM pNetUsuarioTipo WHERE IDUsuarioTipo = @IDUsuarioTipo) AND EXISTS(SELECT * FROM pNetComunicado WHERE IDComunicado = @IDComunicado) AND NOT EXISTS(select * from pNetComunicadoXPerfil where IDComunicado = @IDComunicado AND IDUsuarioTipo = @IDUsuarioTipo))
BEGIN
INSERT INTO pNetComunicadoXPerfil values(@IDComunicado,@IDUsuarioTipo)
SELECT COUNT (IDComunicado) as ID FROM pNetComunicadoXPerfil WHERE IDComunicado = @IDComunicado
END
ELSE
SELECT -1 as ID
END

