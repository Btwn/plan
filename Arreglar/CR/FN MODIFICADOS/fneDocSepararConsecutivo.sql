SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER FUNCTION dbo.fneDocSepararConsecutivo
(
@Texto				varchar(max)
)
RETURNS varchar(max)

AS BEGIN
DECLARE
@LEN          bigint,
@LEN2         int,
@Posicion     int,
@Posicion2    int
SELECT @LEN = LEN(@Texto)
SELECT @Posicion = CHARINDEX('«',@Texto,1)
SELECT @Posicion2 = CHARINDEX('»',@Texto,1)
SELECT @Texto = SUBSTRING(@Texto,@Posicion,@Posicion2-@Posicion+1)
RETURN @Texto
END

