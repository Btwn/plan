SET DATEFIRST 7    
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1  
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spNetAddCfgXPerfil
@Empresa		varchar(5)  = NULL,
@Descripcion	varchar(80) = NULL,
@IDUsuarioTipo	int			= NULL
AS BEGIN
IF NOT EXISTS(SELECT 1 FROM PortalNetCfgXPerfil WITH(NOLOCK) WHERE Empresa = @Empresa AND Descripcion = @Descripcion AND IDUsuarioTipo = @IDUsuarioTipo)
INSERT INTO PortalNetCfgXPerfil SELECT @Empresa, @Descripcion, @IDUsuarioTipo
SELECT 'Registro actualizado'
END

