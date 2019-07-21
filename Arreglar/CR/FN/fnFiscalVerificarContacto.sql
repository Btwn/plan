SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER FUNCTION fnFiscalVerificarContacto
(
@Modulo				varchar(5),
@ID					int
)
RETURNS bit

AS BEGIN
DECLARE
@FiscalGenerar	bit,
@ContactoTipo	varchar(20),
@Contacto		varchar(10)
IF @Modulo = 'VTAS' SELECT @FiscalGenerar = c.FiscalGenerar  FROM Venta  v  JOIN Cte c  ON c.Cliente = v.Cliente       WHERE  v.ID = @ID ELSE
IF @Modulo = 'COMS' SELECT @FiscalGenerar = p.FiscalGenerar  FROM Compra c  JOIN Prov p ON p.Proveedor = c.Proveedor   WHERE  c.ID = @ID ELSE
IF @Modulo = 'GAS'  SELECT @FiscalGenerar = p.FiscalGenerar  FROM Gasto  g  JOIN Prov p ON p.Proveedor = g.Acreedor    WHERE  g.ID = @ID ELSE
IF @Modulo = 'CXP'  SELECT @FiscalGenerar = p.FiscalGenerar  FROM Cxp    c  JOIN Prov p ON p.Proveedor = c.Proveedor   WHERE  c.ID = @ID ELSE
IF @Modulo = 'CXC'  SELECT @FiscalGenerar = c.FiscalGenerar  FROM Cxc    cx JOIN Cte c  ON c.Cliente   = cx.Cliente    WHERE cx.ID = @ID ELSE
IF @Modulo = 'DIN'
BEGIN
SELECT @ContactoTipo = ContactoTipo, @Contacto = Contacto FROM Dinero WHERE ID = @ID
IF @ContactoTipo = 'Proveedor' SELECT @FiscalGenerar = FiscalGenerar FROM Prov WHERE Proveedor = @Contacto ELSE
IF @ContactoTipo = 'Cliente'   SELECT @FiscalGenerar = FiscalGenerar FROM Cte  WHERE Cliente   = @Contacto ELSE SELECT @FiscalGenerar = 1
END ELSE SELECT @FiscalGenerar = 1
RETURN (ISNULL(@FiscalGenerar,0))
END

