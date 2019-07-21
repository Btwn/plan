SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER FUNCTION fneDocInXmlns
(
@XML				varchar(max),
@ConNodo			bit = 0
)
RETURNS varchar(max)

AS BEGIN
DECLARE
@Resultado			varchar(max),
@Longitud			bigint,
@Contador			bigint,
@Caracter			char(1),
@Estado			int,
@EstadoAnterior		int,
@Prefijo			varchar(max),
@Nombre			varchar(max)
SET @Resultado = ''
IF NULLIF(@XML,'') IS NULL RETURN @Resultado
DECLARE @xmlns TABLE
(
Prefijo					varchar(max) COLLATE DATABASE_DEFAULT NULL,
Nombre					varchar(max) COLLATE DATABASE_DEFAULT NULL
)
SET @Longitud = LEN(@XML)
SET @Contador = 1
SET @Estado = 0
SET @Prefijo = ''
SET @Nombre  = ''
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
IF @Estado = 5 AND @Caracter NOT IN (char(58),'=') SET @Estado = 0 ELSE
IF @Estado = 5 AND @Caracter = char(58)	  SET @Estado = 6 ELSE
IF @Estado = 5 AND @Caracter = '='			  SET @Estado = 7 ELSE
IF @Estado = 6 AND @Caracter = '='     	      SET @Estado = 7 ELSE
IF @Estado = 7 AND @Caracter NOT IN ('"')	  SET @Estado = 0 ELSE
IF @Estado = 7 AND @Caracter = '"'     	      SET @Estado = 8 ELSE
IF @Estado = 8 AND @Caracter = '"'     	      SET @Estado = 9
IF @Estado = 6 AND @EstadoAnterior = 6
BEGIN
SET @Prefijo = @Prefijo + @Caracter
END ELSE IF @Estado = 8 AND @EstadoAnterior = 8
BEGIN
SET @Nombre = @Nombre + @Caracter
END ELSE IF @Estado = 9
BEGIN
IF NULLIF(@Nombre,'') IS NOT NULL
BEGIN
INSERT @xmlns (Prefijo, Nombre) VALUES (NULLIF(@Prefijo,''), NULLIF(@Nombre,''))
END
SET @Prefijo = ''
SET @Nombre = ''
SET @Estado = 0
END
SET @Contador = @Contador + 1
END
IF @ConNodo = 1 AND EXISTS(SELECT 1 FROM @xmlns)
BEGIN
SET @Resultado = '<ns '
END
DECLARE crXMLNS CURSOR FOR
SELECT Prefijo, Nombre
FROM @xmlns
ORDER BY Prefijo
OPEN crXMLNS
FETCH NEXT FROM crXMLNS INTO @Prefijo, @Nombre
WHILE @@FETCH_STATUS = 0
BEGIN
IF @Prefijo IS NULL
BEGIN
IF @ConNodo = 0
BEGIN
SET @Resultado = @Resultado + 'declare default element namespace ' + CHAR(34) + RTRIM(ISNULL(@Nombre,'')) + CHAR(34) + '; '
END ELSE IF @ConNodo = 1
BEGIN
SET @Resultado = @Resultado + 'xmlns=' + CHAR(34) + RTRIM(ISNULL(@Nombre,'')) + CHAR(34) + ' '
END
END ELSE IF @Prefijo IS NOT NULL
BEGIN
IF @ConNodo = 0
BEGIN
SET @Resultado = @Resultado + 'declare namespace ' + RTRIM(ISNULL(@Prefijo,'')) + '=' + CHAR(34) + RTRIM(ISNULL(@Nombre,'')) + CHAR(34) + '; '
END ELSE IF @ConNodo = 1
BEGIN
SET @Resultado = @Resultado + 'xmlns' + CHAR(58) + RTRIM(ISNULL(@Prefijo,'')) + '=' + CHAR(34) + RTRIM(ISNULL(@Nombre,'')) + CHAR(34) + ' '
END
END
FETCH NEXT FROM crXMLNS INTO @Prefijo, @Nombre
END
CLOSE crXMLNS
DEALLOCATE crXMLNS
IF @ConNodo = 1 AND EXISTS(SELECT 1 FROM @xmlns)
BEGIN
SET @Resultado = @Resultado + '/>'
END
RETURN @Resultado
END

