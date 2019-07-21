SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROC spTarimaTransitoC
@Tarima				varchar(20),
@TarimaTransito		varchar(20) OUTPUT

AS
BEGIN
IF NOT EXISTS(SELECT ID FROM TarimaTransitoC WITH(ROWLOCK) WHERE Tarima = @Tarima)
BEGIN
SELECT @TarimaTransito = RTRIM(@Tarima) + '-1'
INSERT INTO TarimaTransitoC(Tarima, Consecutivo) SELECT @Tarima, 2
END
ELSE
BEGIN
SELECT @TarimaTransito = RTRIM(@Tarima) + '-' + CONVERT(varchar(max), ISNULL(Consecutivo, 1)) FROM TarimaTransitoC WITH(ROWLOCK) WHERE Tarima = @Tarima
UPDATE TarimaTransitoC WITH(ROWLOCK) SET Consecutivo = Consecutivo + 1 FROM TarimaTransitoC WHERE Tarima = @Tarima
END
RETURN
END

