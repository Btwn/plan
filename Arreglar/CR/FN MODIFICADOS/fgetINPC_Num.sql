SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER FUNCTION fgetINPC_Num (@Ejercicio as smallint,@Periodo as smallint,@mesesUso as smallint,@FechaIniUso as datetime)
RETURNS Float

AS BEGIN
DECLARE	@valINPC as Float,
@residuo as int,
@PeriodoINPC as int,
@MesIniUso as smallint;
SET @residuo = 0;
SET @residuo = @mesesUso % 2;
SELECT @MesIniUso = CASE WHEN YEAR(@FechaIniUso) < @Ejercicio THEN 1 ELSE MONTH(@FechaIniUso) END
IF(@residuo=0)
BEGIN
SET @PeriodoINPC =  (@MesIniUso - 1) + (@mesesUso / 2)
SELECT @valINPC = Importe FROM dbo.INPC WITH (NOLOCK) where Mes = @PeriodoINPC AND Anio = @Ejercicio
END
IF(@residuo>0)
BEGIN
IF(@Periodo = 1)
BEGIN
SELECT @valINPC = Importe FROM dbo.INPC WITH (NOLOCK) where Mes = 1 AND Anio = @Ejercicio
END
ELSE
BEGIN
SET @PeriodoINPC = (@MesIniUso - 1) + (@mesesUso / 2)
IF @PeriodoINPC = 0
SET @PeriodoINPC = 1
SELECT @valINPC = Importe FROM dbo.INPC WITH (NOLOCK) where Mes = @PeriodoINPC AND Anio = @Ejercicio
END
END
IF @mesesUso = 0
SELECT @valINPC = 0
RETURN ISNULL(@valINPC,0)
END

