SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER FUNCTION [dbo].[fnAspelJustificaClave] (@Clave VARCHAR(20))
RETURNS VARCHAR(6) AS
BEGIN
DECLARE
@Nueva	varchar(6)
IF ISNUMERIC(@Clave) = 1 AND LEFT(@CLAVE,1) <> '0'
BEGIN
SET @Nueva = RIGHT('00000' + @Clave, 5)
END
ELSE
IF ISNUMERIC(@Clave) = 1 AND len(@CLAVE) = 5 AND LEFT(@CLAVE,1) = '0' 
SET @Nueva = '0' + @Clave	
ELSE
SET @Nueva = @Clave
RETURN(@Nueva)
END

