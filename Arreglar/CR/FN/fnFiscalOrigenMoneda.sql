SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER FUNCTION fnFiscalOrigenMoneda
(
@Modulo				varchar(5),
@ID					int
)
RETURNS varchar(10)

AS BEGIN
DECLARE
@Moneda			varchar(10)
SET @Moneda = NULL
IF @Modulo = 'VTAS' SELECT @Moneda = v.Moneda  FROM Venta v  WHERE  v.ID = @ID ELSE
IF @Modulo = 'COMS' SELECT @Moneda = c.Moneda  FROM Compra c WHERE  c.ID = @ID ELSE
IF @Modulo = 'GAS'  SELECT @Moneda = g.Moneda  FROM Gasto g  WHERE  g.ID = @ID ELSE
IF @Modulo = 'CXP'  SELECT @Moneda = c.Moneda  FROM Cxp c    WHERE  c.ID = @ID ELSE
IF @Modulo = 'CXC'  SELECT @Moneda = c.Moneda  FROM Cxc c    WHERE  c.ID = @ID ELSE
IF @Modulo = 'DIN'  SELECT @Moneda = d.Moneda  FROM Dinero d WHERE  d.ID = @ID
RETURN (@Moneda)
END

