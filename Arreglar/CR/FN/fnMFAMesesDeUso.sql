SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER FUNCTION fnMFAMesesDeUso (@Clave varchar(50),@Empresa varchar(5), @FechaCalculo datetime)
RETURNS int
AS BEGIN
DECLARE
@Resultado					int,
@FechaFin						datetime,
@FechaInicioEjercicio			datetime,
@FechaInicio					datetime,
@FechaBaja					datetime,
@Estatus						varchar(1),
@Moi							float,
@DepFiscal					float,
@DepFiscalAct					float
SELECT @FechaInicio = FechaIniUso,@FechaBaja = FechaBaja,@Estatus = Estatus,@Moi = CASE WHEN ISNULL(MontoFisAuto,0) > 0 THEN MontoFisAuto ELSE MontoOrig END,@DepFiscal = DepFiscal,@DepFiscalAct = DepFiscalAct
FROM ActivosF
WHERE Clave = @Clave AND Empresa = @Empresa
SELECT @FechaInicioEjercicio = CAST('01/01/'+LTRIM(STR(YEAR(@FechaCalculo))) as datetime)
SELECT @Resultado = 0
SELECT @FechaFin = CASE WHEN @Estatus IN('V','P','S') THEN @FechaBaja ELSE @FechaCalculo END
IF DATEPART(YEAR,@FechaInicio) = DATEPART(YEAR,@FechaFin) AND DATEPART(MONTH,@FechaInicio) <= DATEPART(MONTH,@FechaFin)
BEGIN
SELECT @Resultado = DATEDIFF(MONTH,@FechaInicio,@FechaFin)
+ CASE WHEN @Estatus in('V','P','S') THEN case when DATEDIFF(MONTH,@FechaInicio,@FechaFin) = 0 then 1
else 0 end
ELSE 1 END
IF(@Resultado > 0 AND DATEPART(DAY,@FechaInicio) > 1)
SET @Resultado = @Resultado - 1
END
ELSE IF DATEPART(YEAR,@FechaInicio) < DATEPART(YEAR,@FechaFin)
BEGIN
SELECT @Resultado = DATEDIFF(MONTH,@FechaInicioEjercicio,@FechaFin)
+ CASE WHEN @Estatus in('V','P','S') THEN	case when DATEDIFF(MONTH,@FechaInicioEjercicio,@FechaFin) = 0 then 1
else 0 end
ELSE 1 END
END
ELSE
IF(@Resultado > 0 AND ISNULL(@DepFiscalAct,0) >= ISNULL(@Moi,0))
SELECT @Resultado = 0
IF(@Resultado>0 and UPPER(@Estatus) = 'A')
BEGIN
IF(@DepFiscalAct + dbo.fgetDeduccion(@MOI,@DepFiscal,@Resultado) > @Moi)
SELECT @Resultado = CASE WHEN ( CAST((@Moi - @DepFiscalAct ) as decimal(18,2)) % CAST(dbo.fgetDeduccion(@Moi,@DepFiscal,1) as decimal(18,2)) ) > 0 THEN CAST(( (@Moi - @DepFiscalAct) / dbo.fgetDeduccion(@Moi,@DepFiscal,1) ) AS INT) + 1 ELSE @Resultado END
END
RETURN ISNULL(@Resultado, 0)
END

