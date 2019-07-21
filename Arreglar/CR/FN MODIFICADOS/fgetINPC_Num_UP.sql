SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER FUNCTION fgetINPC_Num_UP (@FechaEnaj as Datetime)
RETURNS Float
AS
BEGIN
DECLARE	@valINPC as Float,
@Anio as Smallint,
@PeriodoINPC as int
SET @Anio = DATEPART(YEAR,@FechaEnaj);
SET @PeriodoINPC = DATEPART(MONTH,@FechaEnaj);
SET @PeriodoINPC = @PeriodoINPC - 1;
SELECT @valINPC= Importe FROM dbo.INPC WITH (NOLOCK) where Mes = @PeriodoINPC AND Anio = @Anio
RETURN @valINPC
END

