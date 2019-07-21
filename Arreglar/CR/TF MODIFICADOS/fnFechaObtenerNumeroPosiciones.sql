SET DATEFIRST 7    
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1  
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER FUNCTION fnFechaObtenerNumeroPosiciones
(
@FormatoFecha		varchar(50)
)
RETURNS @Resultado TABLE
(
Letra		varchar(50),
Cantidad	int
)
AS
BEGIN
DECLARE	@Contador		int,
@Ultimoa		int,
@Ultimom		int,
@Ultimod		int,
@Ultimoh		int,
@Ultimon		int,
@Ultimos		int,
@Longitud		int,
@Caracter		char(1),
@Cadena			varchar(50)
SELECT
@Contador = 1,
@Longitud = LEN(@FormatoFecha),
@Ultimoa = 0,
@Ultimom = 0,
@Ultimod = 0,
@Ultimoh = 0,
@Ultimon = 0,
@Ultimos = 0,
@Caracter = NULL,
@Cadena = ''
WHILE @Contador <= @Longitud
BEGIN
SET @Caracter = SUBSTRING(UPPER(@FormatoFecha),@Contador,1)
IF @Caracter = 'A'
BEGIN
IF (@Contador - @Ultimoa = 1) OR (@Ultimoa = 0)
IF NOT EXISTS(SELECT * FROM @Resultado WHERE Letra = 'A')
INSERT @Resultado (Letra, Cantidad) VALUES ('A',1)
ELSE
UPDATE @Resultado SET Cantidad = Cantidad + 1 WHERE Letra = 'A'
SET @Ultimoa = @Contador
END
IF @Caracter = 'M'
BEGIN
IF (@Contador - @Ultimom = 1) OR (@Ultimom = 0)
IF NOT EXISTS(SELECT * FROM @Resultado WHERE Letra = 'M')
INSERT @Resultado (Letra, Cantidad) VALUES ('M',1)
ELSE
UPDATE @Resultado SET Cantidad = Cantidad + 1 WHERE Letra = 'M'
SET @Ultimom = @Contador
END
IF @Caracter = 'D'
BEGIN
IF (@Contador - @Ultimod = 1) OR (@Ultimod = 0)
IF NOT EXISTS(SELECT * FROM @Resultado WHERE Letra = 'D')
INSERT @Resultado (Letra, Cantidad) VALUES ('D',1)
ELSE
UPDATE @Resultado SET Cantidad = Cantidad + 1 WHERE Letra = 'D'
SET @Ultimod = @Contador
END
IF @Caracter = 'H'
BEGIN
IF (@Contador - @Ultimoh = 1) OR (@Ultimoh = 0)
IF NOT EXISTS(SELECT * FROM @Resultado WHERE Letra = 'H')
INSERT @Resultado (Letra, Cantidad) VALUES ('H',1)
ELSE
UPDATE @Resultado SET Cantidad = Cantidad + 1 WHERE Letra = 'H'
SET @Ultimoh = @Contador
END
IF @Caracter = 'N'
BEGIN
IF (@Contador - @Ultimon = 1) OR (@Ultimon = 0)
IF NOT EXISTS(SELECT * FROM @Resultado WHERE Letra = 'N')
INSERT @Resultado (Letra, Cantidad) VALUES ('N',1)
ELSE
UPDATE @Resultado SET Cantidad = Cantidad + 1 WHERE Letra = 'N'
SET @Ultimon = @Contador
END
IF @Caracter = 'S'
BEGIN
IF (@Contador - @Ultimos = 1) OR (@Ultimos = 0)
IF NOT EXISTS(SELECT * FROM @Resultado WHERE Letra = 'S')
INSERT @Resultado (Letra, Cantidad) VALUES ('S',1)
ELSE
UPDATE @Resultado SET Cantidad = Cantidad + 1 WHERE Letra = 'S'
SET @Ultimos = @Contador
END
SET @Contador = @Contador + 1
END
RETURN
END

