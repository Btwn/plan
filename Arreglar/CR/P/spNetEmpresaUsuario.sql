SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spNetEmpresaUsuario
@IDUsuario  varchar(100)
AS BEGIN
SELECT e.Empresa, e.Nombre FROM Empresa as e
INNER JOIN pNetUsuarioEmpresa AS u ON u.Empresa = e.Empresa
WHERE u.IDUsuario = @IDUsuario
RETURN
END

