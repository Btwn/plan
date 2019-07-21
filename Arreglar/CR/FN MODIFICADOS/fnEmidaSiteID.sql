SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER FUNCTION fnEmidaSiteID(
@Empresa		varchar(5),
@URL			varchar(255),
@Sucursal		int,
@Usuario		varchar(10)
)
RETURNS varchar(20)
AS
BEGIN
DECLARE @terminalId		varchar(20),
@NivelCfgSiteID	varchar(10)
SELECT @NivelCfgSiteID = dbo.fnEmidaNivelCfgSiteID(@Empresa)
IF @NivelCfgSiteID = 'Agente'
SELECT @terminalId = SiteID FROM EmidaTerminalCfg WITH(NOLOCK) JOIN Usuario WITH(NOLOCK) ON EmidaTerminalCfg.Agente = Usuario.DefAgente WHERE Empresa = @Empresa AND Usuario = @Usuario AND URL = @URL
ELSE IF @NivelCfgSiteID =  'Sucursal'
SELECT @terminalId = SiteID FROM EmidaTerminalCfg WITH(NOLOCK) WHERE Empresa = @Empresa AND Sucursal = @Sucursal AND URL = @URL
ELSE IF @NivelCfgSiteID = 'Caja'
SELECT @terminalId = SiteID FROM EmidaTerminalCfg WITH(NOLOCK) JOIN Usuario WITH(NOLOCK) ON EmidaTerminalCfg.CtaDinero = Usuario.DefCtaDinero WHERE Empresa = @Empresa AND Usuario = @Usuario AND URL = @URL
RETURN @terminalId
END

