SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER FUNCTION dbo.fnPOSTablaTicketCadena(
@Cadena			varchar(max),
@LargoLinea		int
)
RETURNS varchar(max)

AS
BEGIN
DECLARE
@Columns varchar(max)
SELECT @Columns = ISNULL(@Columns,'') + '<BR>' + dbo.fnCentrar(dbo.fnRellenarConCaracter(ISNULL(Campo,''),@LargoLinea,'D',CHAR(32)) ,@LargoLinea)
FROM dbo.fnPOSTablaTicket(@Cadena,52)
SELECT @Columns =STUFF(@Columns,1,4,'' )+ '<BR>'
RETURN @Columns
END

