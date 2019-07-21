SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spNetDeleteCfg
@Empresa		varchar(5)  = NULL,
@Descripcion	varchar(80) = NULL,
@VisiblePara	varchar(10)	= NULL
AS BEGIN
IF ISNULL(@VisiblePara,'') = 'Usuario'
BEGIN
DELETE FROM PortalNetCfgXUsuario WHERE Empresa = @Empresa AND Descripcion = @Descripcion
IF EXISTS(SELECT 1 FROM PortalNetCfgXPerfil WHERE Empresa = @Empresa AND Descripcion = @Descripcion)
DELETE FROM PortalNetCfgXPerfil WHERE Empresa = @Empresa AND Descripcion = @Descripcion
END
ELSE IF ISNULL(@VisiblePara,'') = 'Perfil'
BEGIN
DELETE FROM PortalNetCfgXPerfil WHERE Empresa = @Empresa AND Descripcion = @Descripcion
IF EXISTS(SELECT 1 FROM PortalNetCfgXUsuario WHERE Empresa = @Empresa AND Descripcion = @Descripcion)
DELETE FROM PortalNetCfgXUsuario WHERE Empresa = @Empresa AND Descripcion = @Descripcion
END
SELECT 'Registros Actualizados'
RETURN
END

