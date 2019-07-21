SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROC spNetGuardarCfg
@Empresa			varchar(5)	 = NULL,
@VisiblePara		varchar(10)  = NULL,
@APIMedia			varchar(255) = NULL,
@APIMediaEstatus	varchar(15)  = NULL,
@Proyectos			varchar(255) = NULL,
@ProyectosEstatus	varchar(15)  = NULL
AS BEGIN
IF ISNULL(@Empresa,'') <> '' AND EXISTS(SELECT 1 FROM PortalNetCfg WHERE Empresa = @Empresa AND Descripcion = 'APIMedia')
UPDATE PortalNetCfg SET URL = @APIMedia, Estatus = @APIMediaEstatus WHERE Empresa = @Empresa AND Descripcion = 'APIMedia'
ELSE
INSERT INTO PortalNetCfg(Empresa, URL, Descripcion, Estatus) SELECT @Empresa, @APIMedia, 'APIMedia', @APIMediaEstatus
IF ISNULL(@Empresa,'') <> '' AND EXISTS(SELECT 1 FROM PortalNetCfg WHERE Empresa = @Empresa AND Descripcion = 'Proyectos')
UPDATE PortalNetCfg SET URL = @Proyectos, Estatus = @ProyectosEstatus, VisiblePara = @VisiblePara  WHERE Empresa = @Empresa AND Descripcion = 'Proyectos'
ELSE
INSERT INTO PortalNetCfg(Empresa, URL, Descripcion, Estatus, VisiblePara) SELECT @Empresa, @Proyectos, 'Proyectos', @ProyectosEstatus, @VisiblePara
SELECT 'Configuración actualizada con éxito'
RETURN
END

