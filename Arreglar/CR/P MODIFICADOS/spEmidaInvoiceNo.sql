SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spEmidaInvoiceNo
@Estacion	int,
@Empresa	varchar(5),
@URL		varchar(255),
@Accion		varchar(20),
@Sucursal	int,
@Usuario	varchar(10),
@InvoiceNo	int			= NULL OUTPUT

AS
BEGIN
DECLARE @NivelCfgSiteID	varchar(10)
SELECT @NivelCfgSiteID = dbo.fnEmidaNivelCfgSiteID(@Empresa)
IF @NivelCfgSiteID = 'Agente'
SELECT @InvoiceNo = InvoiceNo FROM EmidaTerminalCfg WITH(NOLOCK) JOIN Usuario WITH(NOLOCK) ON EmidaTerminalCfg.Agente = Usuario.DefAgente WHERE Empresa = @Empresa AND Usuario = @Usuario AND URL = @URL
ELSE IF @NivelCfgSiteID =  'Sucursal'
SELECT @InvoiceNo = InvoiceNo FROM EmidaTerminalCfg WITH(NOLOCK) WHERE Empresa = @Empresa AND Sucursal = @Sucursal AND URL = @URL
ELSE IF @NivelCfgSiteID = 'Caja'
SELECT @InvoiceNo = InvoiceNo FROM EmidaTerminalCfg WITH(NOLOCK) JOIN Usuario WITH(NOLOCK) ON EmidaTerminalCfg.CtaDinero = Usuario.DefCtaDinero WHERE Empresa = @Empresa AND Usuario = @Usuario AND URL = @URL
IF @Accion = 'AFECTAR'
BEGIN
IF @NivelCfgSiteID = 'Agente'
BEGIN
IF @InvoiceNo = 99999
UPDATE EmidaTerminalCfg WITH(ROWLOCK) SET InvoiceNo = 1 FROM EmidaTerminalCfg JOIN Usuario WITH(NOLOCK) ON EmidaTerminalCfg.Agente = Usuario.DefAgente WHERE Empresa = @Empresa AND Usuario = @Usuario AND URL = @URL
ELSE
UPDATE EmidaTerminalCfg WITH(ROWLOCK) SET InvoiceNo = @InvoiceNo + 1 FROM EmidaTerminalCfg JOIN Usuario WITH(NOLOCK) ON EmidaTerminalCfg.Agente = Usuario.DefAgente WHERE Empresa = @Empresa AND Usuario = @Usuario AND URL = @URL
END
ELSE IF @NivelCfgSiteID = 'Sucursal'
BEGIN
IF @InvoiceNo = 99999
UPDATE EmidaTerminalCfg WITH(ROWLOCK) SET InvoiceNo = 1 FROM EmidaTerminalCfg WITH(NOLOCK) WHERE Empresa = @Empresa AND Sucursal = @Sucursal AND URL = @URL
ELSE
UPDATE EmidaTerminalCfg WITH(ROWLOCK) SET InvoiceNo = @InvoiceNo + 1 FROM EmidaTerminalCfg WITH(NOLOCK) WHERE Empresa = @Empresa AND Sucursal = @Sucursal AND URL = @URL
END
ELSE IF @NivelCfgSiteID = 'Caja'
BEGIN
IF @InvoiceNo = 99999
UPDATE EmidaTerminalCfg WITH(ROWLOCK) SET InvoiceNo = 1 FROM EmidaTerminalCfg  JOIN Usuario WITH(NOLOCK) ON EmidaTerminalCfg.CtaDinero = Usuario.DefCtaDinero WHERE Empresa = @Empresa AND Usuario = @Usuario AND URL = @URL
ELSE
UPDATE EmidaTerminalCfg WITH(ROWLOCK) SET InvoiceNo = @InvoiceNo + 1 FROM EmidaTerminalCfg JOIN Usuario WITH(NOLOCK) ON EmidaTerminalCfg.CtaDinero = Usuario.DefCtaDinero WHERE Empresa = @Empresa AND Usuario = @Usuario AND URL = @URL
END
END
RETURN
END

