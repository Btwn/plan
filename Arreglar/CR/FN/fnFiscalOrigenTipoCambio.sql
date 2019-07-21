SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER FUNCTION fnFiscalOrigenTipoCambio
(
@Modulo				varchar(5),
@ID					int
)
RETURNS float

AS BEGIN
DECLARE
@TipoCambio			float
SET @TipoCambio = NULL
IF @Modulo = 'VTAS' SELECT @TipoCambio = v.TipoCambio  FROM Venta v  WHERE  v.ID = @ID ELSE
IF @Modulo = 'COMS' SELECT @TipoCambio = c.TipoCambio  FROM Compra c WHERE  c.ID = @ID ELSE
IF @Modulo = 'GAS'  SELECT @TipoCambio = g.TipoCambio  FROM Gasto g  WHERE  g.ID = @ID ELSE
IF @Modulo = 'CXP'  SELECT @TipoCambio = c.TipoCambio  FROM Cxp c    WHERE  c.ID = @ID ELSE
IF @Modulo = 'CXC'  SELECT @TipoCambio = c.TipoCambio  FROM Cxc c    WHERE  c.ID = @ID ELSE
IF @Modulo = 'DIN'  SELECT @TipoCambio = d.TipoCambio  FROM Dinero d WHERE  d.ID = @ID
RETURN (@TipoCambio)
END

