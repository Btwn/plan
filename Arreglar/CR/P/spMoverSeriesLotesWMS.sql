SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spMoverSeriesLotesWMS
@Accion			        char(20),
@Tarima			        varchar(20),
@TarimaSurtido           varchar(20),
@Cantidad                float,
@Ok 				        int		OUTPUT,
@OkRef 			        varchar(255)	OUTPUT

AS BEGIN
DECLARE
@SerieLote			varchar(50),
@Propiedades		char(20),
@CantidadSerie   	float,
@CantidadRestante   float
SET @CantidadRestante = @Cantidad
IF @Accion = 'AFECTAR'
BEGIN
DECLARE crSerieLoteMov CURSOR FOR
SELECT NULLIF(RTRIM(SerieLote), ''), ISNULL(Existencia, 0.0), NULLIF(RTRIM(Propiedades), '')
FROM TarimaSerieLote
WHERE Tarima = @Tarima
OPEN crSerieLoteMov
FETCH NEXT FROM crSerieLoteMov INTO @SerieLote, @CantidadSerie, @Propiedades
IF @@ERROR <> 0 SELECT @Ok = 1
WHILE @@FETCH_STATUS <> -1 AND @Ok IS NULL
BEGIN
IF @@FETCH_STATUS <> -2 AND (@Cantidad <> 0.0)
BEGIN
IF @CantidadRestante > 0
BEGIN
IF @CantidadSerie > @CantidadRestante
SET @CantidadSerie = @CantidadRestante
UPDATE TarimaSerieLote SET Existencia = ISNULL(Existencia,0) - ISNULL(@CantidadSerie,0) WHERE Tarima = @Tarima
IF EXISTS (SELECT * FROM TarimaSerieLote WHERE SerieLote = @SerieLote AND ISNULL(Tarima,'') = ISNULL(@Tarima,''))
BEGIN
UPDATE TarimaSerieLote SET Existencia = ISNULL(Existencia,0) + ISNULL(@CantidadSerie,0) WHERE Tarima = @TarimaSurtido
END
IF NOT EXISTS (SELECT * FROM TarimaSerieLote WHERE SerieLote = @SerieLote AND ISNULL(Tarima,'') = ISNULL(@TarimaSurtido,''))
BEGIN
INSERT TarimaSerieLote (Tarima, SerieLote, Propiedades, Existencia)
VALUES (@TarimaSurtido, @SerieLote, @Propiedades, @CantidadSerie)
END
END
SET @CantidadRestante = ISNULL(@CantidadRestante,0) - @CantidadSerie
END
FETCH NEXT FROM crSerieLoteMov INTO @SerieLote, @Cantidad, @Propiedades
IF @@ERROR <> 0 SELECT @Ok = 1
END
CLOSE crSerieLoteMov
DEALLOCATE crSerieLoteMov
END
RETURN
END

