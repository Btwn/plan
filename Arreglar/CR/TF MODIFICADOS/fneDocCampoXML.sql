SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER FUNCTION fneDocCampoXML
(
@Modulo				varchar(5),
@eDoc				varchar(50)
)
RETURNS @CampoXML TABLE
(
Campo			varchar(255)
)

AS BEGIN
DECLARE
@XML				varchar(max),
@Longitud			bigint,
@Contador			bigint,
@Caracter			char(1),
@Campo			varchar(255),
@Estado			int,
@EstadoAnterior	int
SELECT @XML = Documento FROM eDoc WITH (NOLOCK) WHERE Modulo = @Modulo AND eDoc = @eDoc
SELECT @Longitud = LEN(@XML), @Contador = 1, @Caracter = NULL, @Campo = '', @Estado = 0
WHILE @Contador <= @Longitud
BEGIN
SET @Caracter = SUBSTRING(@XML,@Contador,1)
SET @EstadoAnterior = @Estado
SET @Estado = CASE
WHEN @Estado = 0 AND @Caracter = '['         THEN 1
WHEN @Estado = 1 AND @Caracter = ']'         THEN 2
WHEN @Estado = 2 AND @Caracter = '['         THEN 1
WHEN @Estado = 2 AND @Caracter <> '['        THEN 0
WHEN @Estado = 1 AND LEN(@Campo) > 100       THEN 0
ELSE @Estado
END
IF @Estado = 0
BEGIN
IF @EstadoAnterior <> 0 SET @Campo = ''
END
IF @Estado = 1
BEGIN
SET @Campo = @Campo + @Caracter
END
IF @Estado = 2
BEGIN
SET @Campo = @Campo + @Caracter
IF NOT EXISTS(SELECT * FROM @CampoXML WHERE Campo = @Campo)
INSERT @CampoXML (Campo) VALUES (@Campo)
SET @Campo = ''
END
SET @Contador = @Contador + 1
END
RETURN
END

