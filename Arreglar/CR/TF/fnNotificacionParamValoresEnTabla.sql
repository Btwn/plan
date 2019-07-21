SET DATEFIRST 7
SET ANSI_NULLS ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET ANSI_WARNINGS ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER FUNCTION fnNotificacionParamValoresEnTabla
(
@Notificacion		varchar(50),
@Parametro			varchar(100)
)
RETURNS @Valores TABLE
(
Valor			varchar(255)
)

AS BEGIN
DECLARE
@Valor			varchar(max),
@Longitud			bigint,
@Contador			bigint,
@Caracter			char(1),
@ValorActual		varchar(255),
@Estado			int,
@EstadoAnterior	int
SELECT @Valor = Valor FROM NotificacionParam WHERE Notificacion = @Notificacion AND Parametro = @Parametro
SELECT @Longitud = LEN(@Valor), @Contador = 1, @Caracter = NULL, @ValorActual = '', @Estado = 0
WHILE @Contador <= @Longitud
BEGIN
SET @Caracter = SUBSTRING(@Valor,@Contador,1)
SET @EstadoAnterior = @Estado
SET @Estado = CASE
WHEN @Estado = 0 AND @Caracter = ';'         THEN 1
ELSE @Estado
END
IF @Estado = 0
BEGIN
SET @ValorActual = @ValorActual + @Caracter
END ELSE
IF @Estado = 1
BEGIN
INSERT @Valores (Valor) VALUES (RTRIM(LTRIM(@ValorActual)))
SET @ValorActual = ''
SET @Estado = 0
END
SET @Contador = @Contador + 1
END
IF LEN(@ValorActual) > 0
BEGIN
INSERT @Valores (Valor) VALUES (@ValorActual)
END
RETURN
END

