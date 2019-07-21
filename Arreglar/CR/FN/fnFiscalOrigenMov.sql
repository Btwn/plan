SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER FUNCTION fnFiscalOrigenMov
(
@Modulo				varchar(5),
@ID					int
)
RETURNS varchar(10)

AS BEGIN
DECLARE
@Mov			varchar(20)
SET @Mov = NULL
IF @Modulo = 'VTAS' SELECT @Mov = v.Mov  FROM Venta v  WHERE  v.ID = @ID ELSE
IF @Modulo = 'COMS' SELECT @Mov = c.Mov  FROM Compra c WHERE  c.ID = @ID ELSE
IF @Modulo = 'GAS'  SELECT @Mov = g.Mov  FROM Gasto g  WHERE  g.ID = @ID ELSE
IF @Modulo = 'CXP'  SELECT @Mov = c.Mov  FROM Cxp c    WHERE  c.ID = @ID ELSE
IF @Modulo = 'CXC'  SELECT @Mov = c.Mov  FROM Cxc c    WHERE  c.ID = @ID ELSE
IF @Modulo = 'DIN'  SELECT @Mov = d.Mov  FROM Dinero d WHERE  d.ID = @ID
RETURN (@Mov)
END

