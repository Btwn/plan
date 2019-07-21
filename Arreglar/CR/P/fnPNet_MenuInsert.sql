SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE dbo.fnPNet_MenuInsert
@IDUsuarioTipo		int,
@IDRole				int,
@IDPermisoParent	int,
@DescripcionParent	nvarchar (200) = NULL,
@IconParent			nvarchar(100),
@IDPermiso			int,
@Descripcion		nvarchar (200),
@RutaPNet			nvarchar(100)
AS BEGIN
IF NOT EXISTS (SELECT IDPermiso FROM dbo.pNetPermiso WHERE IDPermiso = @IDPermisoParent) AND @DescripcionParent IS NOT NULL
BEGIN
INSERT INTO dbo.pNetPermiso (IDPermiso, Descripcion, IDUsuarioTipo, Icon, Ruta, IDPermisoPadre, Mostrar)
SELECT @IDPermisoParent, @DescripcionParent, @IDUsuarioTipo, @IconParent, '', NULL, 1
END
IF NOT EXISTS (SELECT IDRolePermiso FROM dbo.pNetRolePermiso WHERE IDRole = @IDRole AND IDPermiso = @IDPermisoParent)
BEGIN
INSERT INTO dbo.pNetRolePermiso (IDRole, IDPermiso)
SELECT @IDRole, @IDPermisoParent
END
IF NOT EXISTS (SELECT IDPermiso FROM dbo.pNetPermiso WHERE IDPermiso = @IDPermiso)
BEGIN
INSERT INTO dbo.pNetPermiso (IDPermiso, Descripcion, IDUsuarioTipo, Icon, Ruta, IDPermisoPadre, Mostrar)
SELECT @IDPermiso, @Descripcion, @IDUsuarioTipo, '', @RutaPNet, @IDPermisoParent, 1
END
IF NOT EXISTS (SELECT IDRolePermiso FROM dbo.pNetRolePermiso WHERE IDRole = @IDRole AND IDPermiso = @IDPermiso)
BEGIN
INSERT INTO dbo.pNetRolePermiso
SELECT @IDRole, @IDPermiso
END
RETURN
END

