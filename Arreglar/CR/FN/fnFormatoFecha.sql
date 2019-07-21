SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER FUNCTION fnFormatoFecha
(
@Fecha				datetime,
@FormatoFecha				varchar(50)
)
RETURNS varchar(50)
AS
BEGIN
DECLARE	@FormatoFechaR		varchar(50),
@Anyo				varchar(50),
@Mes				varchar(50),
@Dia				varchar(50),
@Hora				varchar(50),
@Minuto				varchar(50),
@Segundo			varchar(50),
@AnyoCantidad		int,
@MesCantidad		int,
@DiaCantidad		int,
@HoraCantidad		int,
@MinutoCantidad		int,
@SegundoCantidad	int
DECLARE @Resultado	TABLE
(
Letra		varchar(50),
Cantidad	int
)
IF NULLIF(RTRIM(@FormatoFecha),'') IS NULL RETURN CONVERT(varchar,@Fecha,126)
SELECT @Anyo = '', @Mes = '', @Dia = '', @Hora = '', @Minuto = '', @Segundo = ''
SET @FormatoFecha = UPPER(@FormatoFecha)
INSERT @Resultado (Letra, Cantidad) SELECT Letra, Cantidad FROM fnFechaObtenerNumeroPosiciones(@FormatoFecha)
SELECT @AnyoCantidad    = Cantidad FROM @Resultado WHERE Letra = 'A'
SELECT @MesCantidad     = Cantidad FROM @Resultado WHERE Letra = 'M'
SELECT @DiaCantidad     = Cantidad FROM @Resultado WHERE Letra = 'D'
SELECT @HoraCantidad    = Cantidad FROM @Resultado WHERE Letra = 'H'
SELECT @MinutoCantidad  = Cantidad FROM @Resultado WHERE Letra = 'N'
SELECT @SegundoCantidad = Cantidad FROM @Resultado WHERE Letra = 'S'
SELECT @AnyoCantidad    = ISNULL(@AnyoCantidad,0)
SELECT @MesCantidad     = ISNULL(@MesCantidad,0)
SELECT @DiaCantidad     = ISNULL(@DiaCantidad,0)
SELECT @HoraCantidad    = ISNULL(@HoraCantidad,0)
SELECT @MinutoCantidad  = ISNULL(@MInutoCantidad,0)
SELECT @SegundoCantidad = ISNULL(@SegundoCantidad,0)
SET @Anyo    = ISNULL(RIGHT(RTRIM(CONVERT(varchar,DATEPART(year,@Fecha))),@AnyoCantidad),'')
SET @Mes     = ISNULL(RIGHT('0000' + RTRIM(CONVERT(varchar,DATEPART(month,@Fecha))),@MesCantidad),'')
SET @Dia     = ISNULL(RIGHT('0000' + RTRIM(CONVERT(varchar,DATEPART(day,@Fecha))),@DiaCantidad),'')
SET @Hora    = ISNULL(RIGHT('0000' + RTRIM(CONVERT(varchar,DATEPART(hour,@Fecha))),@HoraCantidad),'')
SET @Minuto  = ISNULL(RIGHT('0000' + RTRIM(CONVERT(varchar,DATEPART(minute,@Fecha))),@MinutoCantidad),'')
SET @Segundo = ISNULL(RIGHT('0000' + RTRIM(CONVERT(varchar,DATEPART(second,@Fecha))),@SegundoCantidad),'')
SET @FormatoFecha = REPLACE(@FormatoFecha,REPLICATE('A',@AnyoCantidad),@Anyo)
SET @FormatoFecha = REPLACE(@FormatoFecha,REPLICATE('M',@MesCantidad),@Mes)
SET @FormatoFecha = REPLACE(@FormatoFecha,REPLICATE('D',@DiaCantidad),@Dia)
SET @FormatoFecha = REPLACE(@FormatoFecha,REPLICATE('H',@HoraCantidad),@Hora)
SET @FormatoFecha = REPLACE(@FormatoFecha,REPLICATE('N',@MinutoCantidad),@Minuto)
SET @FormatoFecha = REPLACE(@FormatoFecha,REPLICATE('S',@SegundoCantidad),@Segundo)
SET @FormatoFechaR = @FormatoFecha
Return @FormatoFechaR
END

