SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER FUNCTION fnFechaRegistro(
@Modulo		varchar(10),
@ID int
)
RETURNS datetime
AS
BEGIN
DECLARE
@FechaRegistro	datetime
IF @Modulo = 'VTAS'  SELECT @FechaRegistro = FechaRegistro FROM Venta WHERE ID = @ID ELSE
IF @Modulo = 'COMS'  SELECT @FechaRegistro = FechaRegistro FROM Compra WHERE ID = @ID ELSE
IF @Modulo = 'PROD'  SELECT @FechaRegistro = FechaRegistro FROM Prod WHERE ID = @ID ELSE
IF @Modulo = 'INV'   SELECT @FechaRegistro = FechaRegistro FROM Inv WHERE ID = @ID
SELECT @FechaRegistro = dbo.fnFechasinhora(@FechaRegistro)
RETURN @FechaRegistro
END

