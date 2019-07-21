SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER FUNCTION fnTCPinPad(
@Empresa		varchar(5),
@Sucursal		int,
@Usuario		varchar(10),
@Campo			varchar(15)
)
RETURNS varchar(20)
AS
BEGIN
DECLARE @NivelCfgPinPad	varchar(10),
@TerminalEquiv	varchar(20),
@Pinpad			varchar(3),
@Puerto			varchar(5),
@Valor			varchar(20)
SELECT @NivelCfgPinPad = dbo.fnTCNivelCfgPinPad(@Empresa)
IF @NivelCfgPinPad = 'Agente'
SELECT @Pinpad = PinPad, @TerminalEquiv = TerminalEquiv, @Puerto = Puerto FROM TCTerminalCfg JOIN Usuario ON TCTerminalCfg.Agente = Usuario.DefAgente WHERE Empresa = @Empresa AND Usuario = @Usuario
ELSE IF @NivelCfgPinPad =  'Sucursal'
SELECT @Pinpad = PinPad, @TerminalEquiv = TerminalEquiv, @Puerto = Puerto FROM TCTerminalCfg WHERE Empresa = @Empresa AND Sucursal = @Sucursal
ELSE IF @NivelCfgPinPad = 'Caja'
SELECT @Pinpad = PinPad, @TerminalEquiv = TerminalEquiv, @Puerto = Puerto FROM TCTerminalCfg JOIN Usuario ON TCTerminalCfg.CtaDinero = Usuario.DefCtaDinero WHERE Empresa = @Empresa AND Usuario = @Usuario
IF @Campo = 'Pinpad'
SELECT @Valor = @PinPad
ELSE IF @Campo = 'Puerto'
SELECT @Valor = @Puerto
ELSE IF @Campo = 'TerminalEquiv'
SELECT @Valor = @TerminalEquiv
RETURN @Valor
END

