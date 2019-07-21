SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spACCerrarDia
@Sucursal		int,
@Empresa		char(5),
@Usuario		char(10),
@FechaD		datetime,
@FechaA		datetime,
@Ok			int		OUTPUT,
@OkRef		varchar(255)	OUTPUT,
@ModuloEspecifico	char(5) = NULL

AS BEGIN
IF NOT EXISTS(SELECT * FROM Empresa WITH(NOLOCK) WHERE Empresa = @Empresa) RETURN
DECLARE
@FechaRegistro					datetime,
@Conteo							int,
@Hoy							datetime,
@AcCobroIntereses				varchar(20), 
@AcConsiderarInflacionIVA		bit, 
@ACMonedaCalculoInflacionIVA	varchar(10) 
SELECT 
@AcCobroIntereses = UPPER(RTRIM(ISNULL(ACCobroIntereses,''))),
@ACConsiderarInflacionIVA = ISNULL(ACConsiderarInflacionIVA,0),
@ACMonedaCalculoInflacionIVA = NULLIF(LTRIM(RTRIM(ACMonedaCalculoInflacionIVA)),'')
FROM EmpresaCfg WITH(NOLOCK)
WHERE Empresa = @Empresa
SELECT @Conteo = 0
EXEC spExtraerFecha @FechaD OUTPUT
EXEC spExtraerFecha @FechaA OUTPUT
SELECT @FechaRegistro = GETDATE()
SELECT @Hoy = @FechaD
WHILE @Hoy < @FechaA AND @Ok IS NULL
BEGIN
IF NOT EXISTS(SELECT * FROM ACDiaCerrado WITH(NOLOCK) WHERE Fecha = @Hoy)
BEGIN
IF @Ok IS NULL AND @ModuloEspecifico IN (NULL, 'CXC') EXEC spACReinversionAutomatica @Empresa, @Usuario, 'CXC', @Hoy, @Ok OUTPUT, @OkRef OUTPUT, 1
IF @Ok IS NULL AND @ModuloEspecifico IN (NULL, 'CXP') EXEC spACReinversionAutomatica @Empresa, @Usuario, 'CXP', @Hoy, @Ok OUTPUT, @OkRef OUTPUT, 1
IF @Ok IS NULL AND @ModuloEspecifico IN (NULL, 'CXC') EXEC spACActualizarTasas @Empresa, 'CXC', @Hoy, @Ok OUTPUT, @OkRef OUTPUT
IF @Ok IS NULL AND @ModuloEspecifico IN (NULL, 'CXC') EXEC spACCarteraVencidaCNBV @Empresa, @Sucursal, @Usuario, 'CXC', @Hoy, @FechaRegistro, @Ok OUTPUT, @OkRef OUTPUT
IF  @ACConsiderarInflacionIVA = 1 
BEGIN
IF @ACMonedaCalculoInflacionIVA IS NOT NULL
BEGIN
IF @Ok IS NULL AND @ModuloEspecifico IN (NULL, 'CXC') EXEC spACIVADescontarInflacion @Empresa, @Sucursal, @Usuario, 'CXC', @Hoy, @FechaRegistro, @Conteo OUTPUT, @Ok OUTPUT, @OkRef OUTPUT 
IF @Ok IS NULL AND @ModuloEspecifico IN (NULL, 'CXP') EXEC spACIVADescontarInflacion @Empresa, @Sucursal, @Usuario, 'CXP', @Hoy, @FechaRegistro, @Conteo OUTPUT, @Ok OUTPUT, @OkRef OUTPUT 
END ELSE
BEGIN
SELECT @Ok = 30075, @OkRef = dbo.fnIdiomaTraducir(@Usuario,'Verifique la moneda utilizada para el cálculo de inflación.')
END
END
IF @Ok IS NULL AND @ModuloEspecifico IN (NULL, 'CXC') EXEC spACDevengarIntereses @Empresa, @Sucursal, @Usuario, 'CXC', @Hoy, @FechaRegistro, 0, @Conteo OUTPUT, @Ok OUTPUT, @OkRef OUTPUT
IF @Ok IS NULL AND @ModuloEspecifico IN (NULL, 'CXC') EXEC spACDevengarIntereses @Empresa, @Sucursal, @Usuario, 'CXC', @Hoy, @FechaRegistro, 1, @Conteo OUTPUT, @Ok OUTPUT, @OkRef OUTPUT
IF @Ok IS NULL AND @ModuloEspecifico IN (NULL, 'CXP') EXEC spACDevengarIntereses @Empresa, @Sucursal, @Usuario, 'CXP', @Hoy, @FechaRegistro, 0, @Conteo OUTPUT, @Ok OUTPUT, @OkRef OUTPUT
IF @Ok IS NULL AND @ModuloEspecifico IN (NULL, 'CXC') EXEC spACMinistracionHipotecaria @Empresa, @Sucursal, @Usuario, @Hoy, @FechaRegistro, @Ok OUTPUT, @OkRef OUTPUT
IF @Ok IS NULL EXEC xpACCerrarDia @Empresa, @Usuario, @Hoy, @Ok OUTPUT, @OkRef OUTPUT
IF @Ok IS NULL INSERT ACDiaCerrado (Fecha) VALUES (@Hoy)
SELECT @Hoy = DATEADD(day, 1, @Hoy)
END ELSE SELECT @Ok = 35151, @OkRef = CONVERT(varchar, @Hoy)
END
RETURN
END

