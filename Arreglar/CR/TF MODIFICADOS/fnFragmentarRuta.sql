SET DATEFIRST 7    
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1  
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER FUNCTION fnFragmentarRuta
(
@Ruta				varchar(255)
)
RETURNS @Directorios TABLE
(
Directorio			varchar(255) COLLATE DATABASE_DEFAULT
)

AS BEGIN
DECLARE
@Longitud			bigint,
@Contador			bigint,
@Caracter			char(1),
@Directorio		varchar(255),
@Estado			int,
@EstadoAnterior	int
SELECT @Longitud = LEN(@Ruta), @Contador = 1, @Caracter = NULL, @Directorio = '', @Estado = 0
WHILE @Contador <= @Longitud
BEGIN
SET @Caracter = SUBSTRING(@Ruta,@Contador,1)
SET @EstadoAnterior = @Estado
SET @Estado = CASE
WHEN @Estado = 0 AND @Caracter = '\'         THEN 1
ELSE @Estado
END
IF @Estado = 0
BEGIN
SET @Directorio = @Directorio + @Caracter
END
IF @Estado = 1
BEGIN
INSERT @Directorios (Directorio) VALUES (@Directorio)
SET @Directorio = @Directorio + @Caracter
SET @Estado = 0
END
SET @Contador = @Contador + 1
END
IF @Caracter <> '\'
INSERT @Directorios (Directorio) VALUES (@Directorio)
DELETE FROM @Directorios WHERE NULLIF(Directorio,'') IS NULL
DELETE FROM @Directorios WHERE NULLIF(Directorio,'') = '\'
DELETE FROM @Directorios WHERE NULLIF(Directorio,'') LIKE '\\%' AND CHARINDEX('\',SUBSTRING(Directorio,3,LEN(Directorio)-2)) = 0
RETURN
END

