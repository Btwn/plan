SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER FUNCTION fneDocInBorrarXmlnsOmision
(
@XML				varchar(max)
)
RETURNS varchar(max)
AS BEGIN
DECLARE
@Resultado			varchar(max),
@Longitud			bigint,
@Contador			bigint,
@Caracter			char(1),
@Estado				int,
@EstadoAnterior		int,
@xmlns				varchar(max)
SET @Resultado = ''
IF NULLIF(@XML,'') IS NULL RETURN @Resultado
SET @Longitud = LEN(@XML)
SET @Contador = 1
SET @Estado = 0
SET @xmlns = ''
WHILE @Contador <= @Longitud
BEGIN
SET @EstadoAnterior = @Estado
SET @Caracter = SUBSTRING(@XML,@Contador,1)
IF @Estado = 0 AND @Caracter = 'X'			  SET @Estado = 1 ELSE
IF @Estado = 1 AND @Caracter NOT IN ('M')	  SET @Estado = 0 ELSE
IF @Estado = 1 AND @Caracter = 'M'			  SET @Estado = 2 ELSE
IF @Estado = 2 AND @Caracter NOT IN ('L')	  SET @Estado = 0 ELSE
IF @Estado = 2 AND @Caracter = 'L'			  SET @Estado = 3 ELSE
IF @Estado = 3 AND @Caracter NOT IN ('N')	  SET @Estado = 0 ELSE
IF @Estado = 3 AND @Caracter = 'N'			  SET @Estado = 4 ELSE
IF @Estado = 4 AND @Caracter NOT IN ('S')	  SET @Estado = 0 ELSE
IF @Estado = 4 AND @Caracter = 'S'			  SET @Estado = 5 ELSE
IF @Estado = 5 AND @Caracter NOT IN ('=')     SET @Estado = 0 ELSE
IF @Estado = 5 AND @Caracter = '='			  SET @Estado = 7 ELSE
IF @Estado = 7 AND @Caracter NOT IN ('"')	  SET @Estado = 0 ELSE
IF @Estado = 7 AND @Caracter = '"'     	      SET @Estado = 8 ELSE
IF @Estado = 8 AND @Caracter = '"'     	      SET @Estado = 9
IF @Estado = 0
BEGIN
SET @Xmlns = ''
END ELSE IF @Estado > 0 AND @Estado < 9
BEGIN
SET @Xmlns = @Xmlns + @Caracter
END ELSE IF @Estado = 9
BEGIN
SET @Xmlns = @Xmlns + @Caracter
SET @XML = REPLACE(@XML,@Xmlns,'');
SET @Estado = 0
END
SET @Contador = @Contador + 1
END
SET @Resultado = @XML
RETURN @Resultado
END

