SET DATEFIRST 7    
SET ANSI_NULLS ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1  
SET QUOTED_IDENTIFIER ON
SET NOCOUNT ON
SET ANSI_WARNINGS ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER FUNCTION fnSincroISRetraso
(
@Sucursal				int
)
RETURNS datetime

AS BEGIN
DECLARE
@Retraso			datetime,
@Segundos			float,
@Ahora				datetime,
@HoraActual			varchar(2),
@MinutoActual		varchar(2),
@TiempoActual		varchar(5),
@HoraRetraso		varchar(2),
@MinutoRetraso		varchar(2),
@SegundoRetraso		varchar(2),
@CentesimaRetraso	varchar(3),
@Entero				int,
@Fraccion			float,
@HoraSobrante		int,
@MinutoSobrante		int,
@SegundoSobrante	int
SET @Retraso = NULL
SET @Segundos = NULL
SET @Ahora = GETDATE()
SET @HoraActual = LTRIM(RTRIM(CONVERT(varchar(2),DATEPART(hour,@Ahora))))
SET @HoraActual = REPLICATE('0',2-LEN(@HoraActual)) + @HoraActual
SET @MinutoActual = LTRIM(RTRIM(CONVERT(varchar(2),DATEPART(minute,@Ahora))))
SET @MinutoActual = REPLICATE('0',2-LEN(@MinutoActual)) + @MinutoActual
SET @TiempoActual = @HoraActual + ':' + @MinutoActual
SELECT TOP 1 @Segundos = NULLIF(Retraso,0.0) FROM SincroISSucursalRetraso WITH(NOLOCK) WHERE Sucursal = @Sucursal AND Hora <= @TiempoActual ORDER BY Sucursal, Hora DESC
IF @Segundos IS NULL SELECT TOP 1 @Segundos = NULLIF(Retraso,0.0) FROM SincroISRetraso WITH(NOLOCK) WHERE Hora <= @TiempoActual ORDER BY Hora DESC
IF @Segundos IS NOT NULL
BEGIN
SET @Entero = FLOOR(@Segundos)
SET @Fraccion = @Segundos - FLOOR(@Segundos)
SET @HoraRetraso = LTRIM(RTRIM(CONVERT(varchar(2),@Entero / 3600)))
SET @HoraRetraso = REPLICATE('0',2-LEN(@HoraRetraso)) + @HoraRetraso
SET @MinutoSobrante = (@Entero - ((@Entero / 3600) * 3600)) / 60
SET @MinutoRetraso = LTRIM(RTRIM(CONVERT(varchar(2),@MinutoSobrante)))
SET @MinutoRetraso = REPLICATE('0',2-LEN(@MinutoRetraso)) + @MinutoRetraso
SET @SegundoSobrante = @Entero - (((@Entero / 3600) * 3600) + (@MinutoSobrante * 60))
SET @SegundoRetraso = LTRIM(RTRIM(CONVERT(varchar(2),@SegundoSobrante)))
SET @SegundoRetraso = REPLICATE('0',2-LEN(@SegundoRetraso)) + @SegundoRetraso
SET @CentesimaRetraso = SUBSTRING(LTRIM(RTRIM(CONVERT(varchar,ROUND(@Fraccion,3)))),1,3)
SET @CentesimaRetraso = SUBSTRING(@CentesimaRetraso,CHARINDEX('.',@CentesimaRetraso)+1,3)
SET @CentesimaRetraso = @CentesimaRetraso + REPLICATE('0',3-LEN(@CentesimaRetraso))
SET @Retraso = CONVERT(datetime,'1900-01-01 ' + @HoraRetraso + ':' + @MinutoRetraso + ':' + @SegundoRetraso + '.' + @CentesimaRetraso)
END
RETURN (@Retraso)
END

