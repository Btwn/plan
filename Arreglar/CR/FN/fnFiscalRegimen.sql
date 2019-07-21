SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER FUNCTION fnFiscalRegimen
(
@Modulo				varchar(5),
@ID					int
)
RETURNS varchar(30)

AS BEGIN
DECLARE
@FiscalRegimen	varchar(30),
@ContactoTipo	varchar(20),
@Contacto		varchar(10)
IF @Modulo = 'VTAS' SELECT @FiscalRegimen = c.FiscalRegimen  FROM Venta  v  JOIN Cte c  ON c.Cliente = v.Cliente       WHERE  v.ID = @ID ELSE
IF @Modulo = 'COMS' SELECT @FiscalRegimen = p.FiscalRegimen  FROM Compra c  JOIN Prov p ON p.Proveedor = c.Proveedor   WHERE  c.ID = @ID ELSE
IF @Modulo = 'GAS'  SELECT @FiscalRegimen = p.FiscalRegimen  FROM Gasto  g  JOIN Prov p ON p.Proveedor = g.Acreedor    WHERE  g.ID = @ID ELSE
IF @Modulo = 'CXP'  SELECT @FiscalRegimen = p.FiscalRegimen  FROM Cxp    c  JOIN Prov p ON p.Proveedor = c.Proveedor   WHERE  c.ID = @ID ELSE
IF @Modulo = 'CXC'  SELECT @FiscalRegimen = c.FiscalRegimen  FROM Cxc    cx JOIN Cte c  ON c.Cliente   = cx.Cliente    WHERE cx.ID = @ID ELSE
IF @Modulo = 'DIN'
BEGIN
SELECT @ContactoTipo = ContactoTipo, @Contacto = Contacto FROM Dinero WHERE ID = @ID
IF @ContactoTipo = 'Proveedor' SELECT @FiscalRegimen = FiscalRegimen FROM Prov WHERE Proveedor = @Contacto ELSE
IF @ContactoTipo = 'Cliente'   SELECT @FiscalRegimen = FiscalRegimen FROM Cte  WHERE Cliente   = @Contacto ELSE SELECT @FiscalRegimen = '(Todos)'
END ELSE SELECT @FiscalRegimen = '(Todos)'
RETURN (ISNULL(NULLIF(@FiscalRegimen,''),'(Vacio)'))
END

