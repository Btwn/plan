SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER FUNCTION dbo.fneDocParsearCuenta
(
@XML                    varchar(max)
)
RETURNS varchar(max)

AS BEGIN
DECLARE
@LEN          bigint,
@LEN2         int,
@Posicion     int,
@Posicion2    int,
@Posicion3    int,
@ValorInicial int,
@ValorFinal   int,
@Total        int,
@Cuenta       varchar(max),
@Texto        varchar(max),
@Texto2       varchar(max),
@Resultado    varchar(max) ,
@XMLResultado varchar(max)
DECLARE @Tabla table(Valor  varchar(max),Cantidad int)
SET @XMLResultado = @XML
IF CHARINDEX('^',@XML) = 0  RETURN @XMLResultado
SELECT @Texto = @XML
SET @Posicion = 1
SELECT @LEN = LEN(@Texto)
SELECT @LEN2 =  CHARINDEX('~',@Texto,1)
WHILE @Posicion< @LEN
BEGIN
SELECT @Posicion2 =  CHARINDEX('^',@Texto,@Posicion)
IF @Posicion = 0
SET @Posicion = @LEN2
IF @ValorFinal IS NULL AND @ValorInicial IS NOT NULL
SELECT @ValorFinal = @Posicion2
IF @ValorInicial IS NULL
SELECT @ValorInicial = @Posicion2+1
IF @ValorInicial IS NOT NULL AND @ValorFinal IS NOT NULL
BEGIN
SELECT @Texto2 = SUBSTRING (@Texto,@ValorInicial,(@ValorFinal-@ValorInicial))
IF EXISTS (SELECT * FROM @Tabla WHERE Valor = @Texto2)
UPDATE @Tabla SET Cantidad = Cantidad+1 WHERE Valor = @Texto2
ELSE
INSERT @Tabla(Valor,cantidad)
SELECT @Texto2,1
SELECT @ValorInicial = NULL, @ValorFinal = NULL, @Texto2 = NULL
END
IF @Posicion2 = 0 BREAK
SELECT @Posicion = @Posicion2+1
END
SELECT @Resultado = @Texto
DECLARE crCuentas CURSOR local  FOR
SELECT  Cantidad, Valor FROM @Tabla
OPEN crCuentas
FETCH NEXT FROM crCuentas INTO @Total, @Cuenta
WHILE @@FETCH_STATUS = 0
BEGIN
SELECT @Resultado = REPLACE(@Resultado,'~'+@Cuenta+'~',CONVERT(varchar,@Total))
SELECT @Resultado = REPLACE(@Resultado,'^'+@Cuenta+'^','')
SELECT @Cuenta = '',@Total = NULL
FETCH NEXT FROM crCuentas INTO @Total, @Cuenta
END
CLOSE crCuentas
DEALLOCATE crCuentas
SELECT @XMLResultado = REPLACE(REPLACE(@Resultado,'^',''),'~','')
RETURN @XMLResultado
END

