SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spTipoTasa
@TipoTasa	varchar(20),
@TasaDiaria     float        		OUTPUT,
@TasaTotal	float        = NULL 	OUTPUT ,
@TieneTasaEsp	bit 	     = 0,
@TasaEsp	float	     = NULL,
@TasaRetencion	float	     = NULL	OUTPUT

AS BEGIN
DECLARE
@Fecha            	datetime,
@EsTasaFija	      	bit,
@TasaBase         	varchar(50),          
@TasaBase2        	varchar(50),          
@TasaBase3        	varchar(50),          
@TasaFija         	float,                
@SobreTasaEn      	varchar(20),          
@SobreTasa        	float,
@RetencionPuntos	float,
@ComisionPorcentaje	float,
@TasaTotalMinima  	float,                
@TasaTotalMaxima  	float,                
@TasaDias         	int,
@Mensaje          	varchar(255)
SELECT @EsTasaFija         = UPPER(EsTasaFija),
@TasaFija           = ISNULL(TasaFija, 0),
@TasaBase           = TasaBase,
@TasaBase2          = TasaBase2,
@TasaBase3          = TasaBase3,
@SobreTasaEn        = UPPER(SobreTasaEn),
@SobreTasa          = ISNULL(SobreTasa, 0),
@TasaTotalMinima    = NULLIF(TasaTotalMinima, 0),
@TasaTotalMaxima    = NULLIF(TasaTotalMaxima, 0),
@RetencionPuntos    = NULLIF(RetencionPuntos, 0),
@ComisionPorcentaje = NULLIF(ComisionPorcentaje, 0)
FROM TipoTasa
WHERE TipoTasa = @TipoTasa
EXEC spTasaBase @TasaBase, @TasaBase2, @TasaBase3, @TasaBase OUTPUT, @TasaDias OUTPUT
SELECT @TasaTotal = 0.0, @TasaRetencion = 0.0
IF @TieneTasaEsp = 1
SELECT @TasaTotal = @TasaEsp
ELSE
IF @EsTasaFija = 1
SELECT @TasaTotal = @TasaFija
ELSE BEGIN
SELECT @TasaTotal = ISNULL(Porcentaje, 0) FROM TasaD WHERE Tasa = @TasaBase AND Fecha = @Fecha
IF @@ROWCOUNT = 0
SELECT @TasaTotal = ISNULL(Porcentaje, 0) FROM Tasa WHERE Tasa = @TasaBase
IF @SobreTasaEn = '%'
SELECT @TasaTotal = @TasaTotal * (1+(@SobreTasa/100.0))
ELSE
SELECT @TasaTotal = @TasaTotal + @SobreTasa
IF @TasaTotalMinima IS NOT NULL AND @TasaTotal < @TasaTotalMinima SELECT @TasaTotal = @TasaTotalMinima
IF @TasaTotalMaxima IS NOT NULL AND @TasaTotal > @TasaTotalMaxima SELECT @TasaTotal = @TasaTotalMaxima
END
IF @ComisionPorcentaje IS NOT NULL
SELECT @TasaTotal = @TasaTotal - (@TasaTotal * (@ComisionPorcentaje/100))
IF @RetencionPuntos IS NOT NULL
SELECT @TasaTotal = @TasaTotal - @RetencionPuntos
SELECT @TasaDiaria = @TasaTotal / @TasaDias,
@TasaRetencion = @RetencionPuntos / @TasaDias
RETURN
END

