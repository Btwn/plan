SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER FUNCTION dbo.fnPOSTablaTicket (
@Cadena			varchar(max),
@LargoLinea		int
)
RETURNS @Tabla TABLE (Campo varchar(255))

AS
BEGIN
DECLARE
@Contador	int,
@Numero		int
SET @Contador = LEN(@Cadena)
SELECT @LargoLinea = @LargoLinea-4
SET @Numero =0
WHILE  @Contador>=@Numero
BEGIN
INSERT @Tabla(Campo)
SELECT SUBSTRING(@Cadena,ISNULL(@Numero,0)+1,@LargoLinea)
SET @Numero = @Numero+@LargoLinea
END
RETURN
END

