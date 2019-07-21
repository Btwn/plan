SET DATEFIRST 7    
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1  
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER FUNCTION fnPCPMascaraReglaCaptura
(
@Mascara				varchar(50)
)
RETURNS varchar(50)

AS BEGIN
DECLARE
@Contador			int,
@Caracter			char(1),
@NuevaMascara		varchar(50)
DECLARE @Caracteres	TABLE
(
Caracter				char(1)
)
SELECT @Mascara = REPLACE(@Mascara,'1','C')
SELECT @Mascara = REPLACE(@Mascara,'2','C')
SELECT @Mascara = REPLACE(@Mascara,'3','C')
SELECT @Mascara = REPLACE(@Mascara,'4','C')
SELECT @Mascara = REPLACE(@Mascara,'5','C')
SELECT @Mascara = REPLACE(@Mascara,'6','C')
SELECT @Mascara = REPLACE(@Mascara,'7','C')
SELECT @Mascara = REPLACE(@Mascara,'8','C')
SELECT @Mascara = REPLACE(@Mascara,'9','C')
SELECT @Mascara = REPLACE(@Mascara,'A','C')
SELECT @Mascara = REPLACE(@Mascara,'B','C')
SELECT @Mascara = REPLACE(@Mascara,'C','C')
SELECT @NuevaMascara = @Mascara
SET @Contador = 1
WHILE @Contador <= LEN(@Mascara)
BEGIN
SET @Caracter = SUBSTRING(@Mascara,@Contador,1)
IF @Caracter <> 'C' AND @Caracter NOT IN (SELECT Caracter FROM @Caracteres)
BEGIN
SELECT @NuevaMascara = REPLACE(@NuevaMascara,@Caracter,'\' + @Caracter)
INSERT @Caracteres (Caracter) VALUES (@Caracter)
END
SET @Contador = @Contador + 1
END
SELECT @NuevaMascara = '>' + @NuevaMascara
RETURN (@NuevaMascara)
END

