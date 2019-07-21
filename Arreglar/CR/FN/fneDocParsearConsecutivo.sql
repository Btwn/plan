SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER FUNCTION dbo.fneDocParsearConsecutivo
(
@XML				varchar(max)
)
RETURNS varchar(max)

AS BEGIN
DECLARE
@LEN          int,
@LEN2         int,
@Posicion     int,
@ValorInicial int,
@ValorFinal   int,
@Total        int,
@Valor       varchar(max),
@Consecutivo  varchar(max),
@Texto        varchar(max),
@Texto2       varchar(max),
@Texto3       varchar(max),
@Resultado    varchar(max) ,
@XMLResultado varchar(max),
@Cons         varchar(max),
@Inicial      int,
@Interval     int,
@Segundo      int,
@Primero      int
SET @XMLResultado = @XML
IF CHARINDEX('«',@XML) = 0
RETURN @XMLResultado
DECLARE @Tabla table(Valor  varchar(max),Consecutivo varchar(max),Intervalo int, Inicial int, Total  int)
SELECT @Texto = @XML+'«»'
SET @Posicion = 1
SELECT @LEN = LEN(@Texto)
SELECT @ValorInicial = 1
SELECT @ValorFinal = CHARINDEX('»',@Texto,@ValorInicial+1)
WHILE @ValorFinal<=@LEN
BEGIN
SELECT @Texto2 =SUBSTRING(@Texto,@ValorInicial,@ValorFinal-@ValorInicial+ 1)
SELECT @Valor = REPLACE(REPLACE(dbo.fneDocSepararConsecutivo(@Texto2),'»',''),'«','')
IF NOT EXISTS(SELECT * FROM @Tabla WHERE Valor = @Valor)
BEGIN
IF @Valor LIKE('%|%')
BEGIN
SELECT @len2 = LEN(@Valor)
SELECT @Primero= CHARINDEX('|',@Valor,1)
SELECT @cons =SUBSTRING(@Valor,1,@Primero-1)
SELECT @segundo =CHARINDEX('|',@Valor,@Primero+1)
IF @segundo >0
BEGIN
SELECT @Inicial = SUBSTRING(@Valor,@Primero+1,((@segundo)-(@Primero+1)))
SELECT @Interval = SUBSTRING(@Valor,@segundo+1,((@len2+1)-(@segundo+1)))
END
ELSE
SELECT @Inicial = SUBSTRING(@Valor,@Primero+1,((@LEN2+1)-(@Primero+1)))
END
INSERT @Tabla(Valor,Consecutivo,Inicial,Intervalo,Total)
SELECT        @Valor,ISNULL(@cons,''),ISNULL(@Inicial,'1'),ISNULL(@Interval,'1'), ISNULL(@Inicial,'1')
SELECT @Total = ISNULL(@Inicial,'1')
SELECT @Consecutivo = CONVERT(varchar,ISNULL(@Inicial,'1'))
END
ELSE
BEGIN
SELECT @Total = Total +Intervalo
FROM @Tabla WHERE Valor = @Valor
UPDATE @Tabla SET Total = @Total  WHERE Valor = @Valor
SELECT @Consecutivo =CONVERT(varchar,Total)
FROM @Tabla WHERE Valor = @Valor
END
IF @ValorFinal = @LEN
SELECT @Consecutivo ='',  @Valor = ''
SELECT @Texto2 = REPLACE(@Texto2,'«'+@Valor+'»',@Consecutivo)
SELECT @Texto3 = ISNULL(@Texto3,'')+@Texto2
SELECT @ValorInicial = @ValorFinal+1
SELECT @ValorFinal = CHARINDEX('»',@Texto,@ValorInicial+1)
SELECT @Posicion = @ValorFinal+1
SELECT @Valor = NULL,@Cons = NULL, @Inicial = NULL, @Interval = NULL
IF @Posicion = 0 BREAK
IF @ValorFinal =0 BREAK
END
SELECT @XMLResultado = @Texto3
RETURN @XMLResultado
END

