SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER FUNCTION fneWebDescripcionHTML
(
@Descripcion				varchar(MAX)
)
RETURNS varchar(MAX)

AS BEGIN
DECLARE
@Longitud			bigint,
@Contador			bigint,
@Caracter			char(1),
@Seccion			varchar(MAX),
@Estado			int,
@EstadoAnterior	        int,
@Expresion			varchar(MAX)
IF NULLIF(@Descripcion,'') IS NULL RETURN (@Seccion)
SELECT @Expresion = WebArtDescripcion FROM WebVersion
SELECT @Expresion= ISNULL(@Expresion,' ')
SELECT @Longitud = LEN(@Expresion), @Contador = 1, @Caracter = NULL, @Seccion = '', @Estado = 0
SELECT @Descripcion = ISNULL(dbo.fnWebArtDescripcion(LTRIM(RTRIM(@Descripcion))),'')
WHILE @Contador <= @Longitud
BEGIN
SET @Caracter = SUBSTRING(@Expresion,@Contador,1)
SET @EstadoAnterior = @Estado
SET @Estado = CASE
WHEN @Estado = 0 AND @Caracter = '{'         THEN 1
WHEN @Estado = 2 AND @Caracter = '}'         THEN 0
ELSE @Estado
END
IF @Estado = 1
BEGIN
SET @Seccion = @Seccion + @Caracter
SET @Estado = 2
END
IF @Estado = 0
BEGIN
SET @Seccion = @Seccion + @Caracter
END
SET @Contador = @Contador + 1
END
SELECT @Seccion = REPLACE(@Seccion,'{}',@Descripcion)
SELECT @Seccion = dbo.fnWebArtQuitarTags(@Seccion,'<BODY>')
SELECT @Seccion = LTRIM(RTRIM(@Seccion))
RETURN(@Seccion)
END

