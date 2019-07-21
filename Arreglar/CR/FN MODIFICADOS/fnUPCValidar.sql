SET DATEFIRST 7    
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1  
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER FUNCTION fnUPCValidar (@UPC varchar(20))
RETURNS bit

AS BEGIN
DECLARE
@r          bit,
@a        	int,
@valor	int,
@por3	bit,
@Ch       	char(1),
@Total	int
SELECT @r = 0
IF dbo.fnEsNumerico(@UPC) = 1 AND LEN(@UPC) IN (13, 8)
BEGIN
SELECT @a = LEN(@UPC)-1, @Total = 0, @por3 = 1
WHILE @a>0
BEGIN
SELECT @valor = CONVERT(int, SUBSTRING(@UPC, @a, 1))
IF @por3 = 1 SELECT @valor = @valor * 3
SELECT @por3 = ~@por3
SELECT @Total = @Total + @valor
SELECT @a = @a - 1
END
SELECT @Total = 10 - (@Total % 10)
IF @Total = 10 SELECT @Total = 0
SELECT @Ch = CONVERT(char, @Total)
IF SUBSTRING(@UPC, LEN(@UPC), 1) = @Ch
SELECT @r = 1
END
RETURN (@r)
END

