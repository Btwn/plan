SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spNetRutaAnexos
@TipoCuenta    varchar(20) = NULL,
@Cuenta        varchar(20) = NULL
AS BEGIN
DECLARE
@Empresa   varchar(5),
@Ruta      varchar(255),
@RutaMedia varchar(max)
IF ISNULL(@TipoCuenta,'') = 'Personal'
BEGIN
SELECT @Empresa = Empresa FROM Personal WHERE Personal = @Cuenta
SELECT @Ruta = DirectorioAnexosEsp
FROM EmpresaGral WHERE Empresa = @Empresa
SELECT @RutaMedia = URL
FROM PortalNetCfg WHERE Empresa = @Empresa AND Descripcion = 'APIMedia' AND UPPER(Estatus) = 'ALTA'
END
SELECT @Ruta Ruta, @RutaMedia RutaMedia
RETURN
END

