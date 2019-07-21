SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER FUNCTION fnFiscalVerificarObligacionFiscal
(
@Modulo				varchar(5),
@Mov				varchar(20),
@OrigenModulo		varchar(5),
@OrigenMov			varchar(20),
@ObligacionFiscal	varchar(30)
)
RETURNS bit

AS BEGIN
DECLARE
@Resultado			bit,
@NombreModulo		varchar(50)
SET @Resultado = 1
SET @NombreModulo = CASE
WHEN @OrigenModulo = 'VTAS' THEN 'Ventas'
WHEN @OrigenModulo = 'COMS' THEN 'Compras'
WHEN @OrigenModulo = 'GAS'  THEN 'Gastos'
WHEN @OrigenModulo = 'CXP'  THEN 'Cxp'
WHEN @OrigenModulo = 'CXC'  THEN 'Cxc'
WHEN @OrigenModulo = 'DIN'  THEN 'Tesoreria'
WHEN @OrigenModulo = 'CONC'  THEN 'Conciliacion'
END
IF EXISTS(SELECT * FROM MovTipoObligacionFiscalOmitir WHERE Modulo = @Modulo AND Mov = @Mov AND OrigenModulo = @NombreModulo AND OrigenMov = @OrigenMov AND ObligacionFiscal = @ObligacionFiscal) SET @Resultado = 0
RETURN (@Resultado)
END

