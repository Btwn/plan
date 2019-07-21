SET DATEFIRST 7
SET ANSI_NULLS ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET ANSI_WARNINGS ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER FUNCTION fnHoraEnEntero
(
@Hora				varchar(5)
)
RETURNS int

AS BEGIN
DECLARE
@Resultado		int,
@HoraEntero		int,
@MinutoEntero		int
SET @HoraEntero = ISNULL(CONVERT(int,SUBSTRING(@Hora,1,2)),0)
SET @MinutoEntero = ISNULL(CONVERT(int,SUBSTRING(@Hora,4,2)),0)
SET @Resultado = (@HoraEntero * 60) + @MinutoEntero
RETURN (@Resultado)
END

