SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER FUNCTION fneDocSeccionXMLTexto
(
@XML				varchar(max)
)
RETURNS @SeccionXML TABLE
(
Seccion			varchar(100)
)

AS BEGIN
DECLARE
@Longitud			bigint,
@Contador			bigint,
@Caracter			char(1),
@Seccion			varchar(100),
@Estado			int,
@EstadoAnterior	int
SELECT @Longitud = LEN(@XML), @Contador = 1, @Caracter = NULL, @Seccion = '', @Estado = 0
WHILE @Contador <= @Longitud
BEGIN
SET @Caracter = SUBSTRING(@XML,@Contador,1)
SET @EstadoAnterior = @Estado
SET @Estado = CASE
WHEN @Estado = 0 AND @Caracter = '{'         THEN 1
WHEN @Estado = 1 AND @Caracter = '}'         THEN 2
WHEN @Estado = 2 AND @Caracter = '{'         THEN 1
WHEN @Estado = 2 AND @Caracter <> '}'        THEN 0
WHEN @Estado = 1 AND LEN(@Seccion) > 100     THEN 0
WHEN @Estado = 1 AND @Caracter = '/'         THEN 0
ELSE @Estado
END
IF @Estado = 0
BEGIN
IF @EstadoAnterior <> 0 SET @Seccion = ''
END
IF @Estado = 1
BEGIN
SET @Seccion = @Seccion + @Caracter
END
IF @Estado = 2
BEGIN
SET @Seccion = @Seccion + @Caracter
SET @Seccion = REPLACE(REPLACE(@Seccion,'{',''),'}','')
IF NOT EXISTS(SELECT * FROM @SeccionXML WHERE Seccion = @Seccion)
INSERT @SeccionXML (Seccion) VALUES (@Seccion)
SET @Seccion = ''
END
SET @Contador = @Contador + 1
END
RETURN
END

