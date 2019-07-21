SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE dbo.spNominaBuscarDiasBimestre
@FechaA      Datetime,
@PeriodoTipo varchar(20),
@DesfaseFin  int,
@FechaIni    datetime output,
@FechaFin    datetime output,
@Dias        int Output

AS BEGIN
DECLARE
@DiasPeriodo int,
@Mes int,
@Mes2 int,
@FechaFin2 datetime,
@FechaFinFIN datetime
SELECT @DiasPeriodo = DiasPeriodo
FROM PeriodoTipo
WHERE PeriodoTipo =  @PeriodoTipo
IF @PeriodoTipo = 'Catorcenal'
BEGIN
SELECT @FechaFin = @FechaA
SELECT @FechaFin2 = DATEADD(DAY, @DiasPeriodo, @FechaFin)
SELECT @FechaFin2 = DATEADD(DAY, @DesfaseFin * -1, @FechaFin2)
SELECT @Mes= MONTH(@FechaFin)
SELECT @Mes2= MONTH(@FechaFin2)
SELECT @FechaFin2 = DATEADD(DAY, @DesfaseFin ,    @FechaFin2)
WHILE  @Mes = @Mes2 and @Mes2 NOT IN(1,4,5,7,9,11)
BEGIN
SELECT @FechaFin  = DATEADD(DAY, 1,                @FechaFin2 )
SELECT @FechaFin2 = DATEADD(DAY, @DiasPeriodo,      @FechaFin  )
SELECT @FechaFin2 = DATEADD(DAY, @DesfaseFin * -1,    @FechaFin2 )
SELECT @Mes  = MONTH(@FechaFin)
SELECT @Mes2 = MONTH(@FechaFin2)
SELECT @FechaFin2 = DATEADD(DAY, @DesfaseFin ,    @FechaFin2 )
END
SELECT @FechaFin = DATEADD(day, @Desfasefin , @FechaFin2)
SELECT @FechaFinfin = DATEADD(day, (@DiasPeriodo * -1) -1, @FechaFin2)
SELECT @FechaA = DATEADD(day, (70 * -1) ,@FechaFinFin)
SELECT @FechaFin = @FechaA
SELECT @FechaFin2 = DATEADD(DAY, @DiasPeriodo, @FechaFin)
SELECT @FechaFin2 = DATEADD(DAY, @DesfaseFin * -1, @FechaFin2)
SELECT @Mes= MONTH(@FechaFin)
SELECT @Mes2= MONTH(@FechaFin2)
SELECT @FechaFin2 = DATEADD(DAY, @DesfaseFin ,    @FechaFin2 )
WHILE  @Mes = @Mes2 and @Mes2 NOT IN(1,3,5,7,9,11)
BEGIN
SELECT @FechaFin  = DATEADD(DAY, 1,                @FechaFin2 )
SELECT @FechaFin2 = DATEADD(DAY, @DiasPeriodo,      @FechaFin  )
SELECT @FechaFin2 = DATEADD(DAY, @DesfaseFin * -1,    @FechaFin2 )
SELECT @Mes  = MONTH(@FechaFin)
SELECT @Mes2 = MONTH(@FechaFin2)
SELECT @FechaFin2 = DATEADD(DAY, @DesfaseFin ,    @FechaFin2 )
END
SELECT @FechaFin = DATEADD(day, @Desfasefin , @FechaFin2)
SELECT @Fechaini = DATEADD(day, (@DiasPeriodo * -1)+1 , @FechaFin2)
SELECT @FechaFin= @FechaFinFin
END
SELECT @Dias = DATEDIFF(day,@FechaINI,@FechaFIN) + 1
END

