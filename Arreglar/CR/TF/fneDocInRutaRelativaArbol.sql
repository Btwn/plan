SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER FUNCTION fneDocInRutaRelativaArbol
(
@Ruta						varchar(max),
@RelativaA					varchar(max)
)
RETURNS @Nodos TABLE
(
ID				int identity(1,1) NOT NULL,
Nodo				varchar(255) COLLATE DATABASE_DEFAULT NULL,
NodoPadre			varchar(255) COLLATE DATABASE_DEFAULT NULL,
Tipo				varchar(50) COLLATE DATABASE_DEFAULT NULL
)

AS BEGIN
DECLARE
@Resultado					varchar(max),
@Estado						int,
@EstadoAnterior				int,
@Contador					bigint,
@Longitud					bigint,
@Caracter					char(1),
@Nodo						varchar(255),
@NodoPadre					varchar(255)
SET @Ruta = NULLIF(@Ruta,'')
SET @RelativaA = NULLIF(@RelativaA,'')
IF @Ruta IS NULL OR @RelativaA IS NULL RETURN
SELECT @Resultado = '', @Caracter = '', @Contador = 1, @Estado = 0, @EstadoAnterior = 0, @Nodo = '', @NodoPadre = ''
SET @Longitud = LEN(@RelativaA)
WHILE @Contador <= @Longitud
BEGIN
SET @Caracter = SUBSTRING(@RelativaA,@Contador,1)
IF @Caracter = '/'  SET @Estado = 1 ELSE
IF @Caracter <> '/' SET @Estado = 2
IF @Estado = 1
BEGIN
IF NULLIF(@Nodo,'') IS NOT NULL
BEGIN
INSERT @Nodos (Nodo, NodoPadre) VALUES (@Nodo, @NodoPadre)
END
SET @NodoPadre = @Nodo
SET @Nodo = ''
END ELSE
IF @Estado = 2
BEGIN
SET @Nodo = @Nodo + @Caracter
END
SET @Contador = @Contador + 1
END
UPDATE @Nodos SET Tipo = 'Origen' WHERE Nodo = @NodoPadre
SELECT @Resultado = '', @Caracter = '', @Contador = 1, @Estado = 0, @EstadoAnterior = 0, @Nodo = '', @NodoPadre = ''
SET @Longitud = LEN(@Ruta)
WHILE @Contador <= @Longitud
BEGIN
SET @Caracter = SUBSTRING(@Ruta,@Contador,1)
IF @Caracter = '/'  SET @Estado = 1 ELSE
IF @Caracter <> '/' SET @Estado = 2
IF @Estado = 1
BEGIN
IF NULLIF(@Nodo,'') IS NOT NULL
BEGIN
IF NOT EXISTS(SELECT 1 FROM @Nodos WHERE Nodo = @Nodo AND NodoPadre = @NodoPadre)
BEGIN
INSERT @Nodos (Nodo, NodoPadre) VALUES (@Nodo, @NodoPadre)
END
SET @NodoPadre = @Nodo
SET @Nodo = ''
END
END ELSE
IF @Estado = 2
BEGIN
SET @Nodo = @Nodo + @Caracter
END
SET @Contador = @Contador + 1
END
IF NULLIF(@NodoPadre,'') IS NOT NULL
UPDATE @Nodos SET Tipo = 'Destino' WHERE Nodo = @NodoPadre
RETURN
END

