SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spNetDeleteComunicadoPerfil
@IDComunicado INT,
@IDUsuarioTipo INT
AS
BEGIN
IF (EXISTS(SELECT * FROM pNetComunicado pnc JOIN pNetComunicadoXPerfil pncxp ON pnc.IDComunicado = pncxp.IDComunicado JOIN pNetUsuarioTipo pnut ON pnut.IDUsuarioTipo = pncxp.IDUsuarioTipo WHERE pnc.IDComunicado = @IDComunicado AND pncxp.IDUsuarioTipo = @IDUsuarioTipo))
BEGIN
DELETE FROM pNetComunicadoXPerfil WHERE IDComunicado = @IDComunicado AND IDUsuarioTipo = @IDUsuarioTipo
SELECT COUNT (IDComunicado) as  ID FROM pNetComunicadoXPerfil WHERE IDComunicado = @IDComunicado
END
ELSE
SELECT -1 as ID
END

